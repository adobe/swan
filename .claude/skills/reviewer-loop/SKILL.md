---
name: reviewer-loop
description: Orchestrate iterative code review using reviewer and implementer agents until sign-off.
---

# Review-Fix Loop

Orchestrate iterative code review using reviewer and implementer agents until sign-off.

## Reviewer Agents

Launch all of the following reviewer agents as subagents in parallel using the Task tool:

- `reviewer-architecture` — architectural concerns, design patterns, maintainability
- `reviewer-logic` — logic errors, correctness issues, bugs
- `reviewer-performance` — performance issues, resource usage, efficiency
- `reviewer-security` — security vulnerabilities, threat modeling
- `reviewer-tests` — test coverage, test quality, testing best practices
- `reviewer-docs` — documentation coverage, clarity, maintainability

## Required Output Format for All Reviewers

Every reviewer agent MUST end its review with a structured verdict block in exactly this format:

```
## Verdict
SIGN-OFF: [APPROVED | CHANGES_REQUESTED]
CRITICAL: [count]
IMPORTANT: [count]
SUGGESTED: [count]
```

The orchestrator uses this block to determine loop control. The following parsing rules apply:

- Reviewers MUST use `CHANGES_REQUESTED` if `CRITICAL > 0`.
- If a reviewer's `SIGN-OFF` says `APPROVED` but `CRITICAL > 0`, the orchestrator MUST override and treat it as `CHANGES_REQUESTED`.
- If the `CRITICAL`, `IMPORTANT`, or `SUGGESTED` counts are missing or non-numeric, the orchestrator MUST treat the review as `CHANGES_REQUESTED`.
- If the verdict block is only partially present (e.g., missing `SIGN-OFF` or missing count lines), the orchestrator MUST treat the review as `CHANGES_REQUESTED`.

## Execution Constraints for Reviewer Agents

- Reviewer agents MUST NOT modify, create, or delete any files.
- Reviewer agents MUST NOT run build or test commands.
- Their role is analysis and reporting only.
- Only the implementer agent may modify files.

## Prerequisites

- There must be changes to review: uncommitted changes, a branch diff, or a user-specified set of files. If none exist, stop and inform the user.
- The orchestrator should infer a description of the changes from the git log and diff if the user does not provide one.
- This skill can be invoked with `/reviewer-loop` or phrases like "review my changes", "run the review loop".

## Workflow

### 1. Initial Review

- Launch ALL reviewer agents in parallel
- Provide each reviewer with: the git diff of the changes, a description of what changed and why, and which files are affected

### 2. Synthesize and Deduplicate

After all reviewers return, the lead agent MUST:

1. Parse each reviewer's verdict block (applying the parsing rules above)
2. Collect all issues into a unified list grouped by file and region
3. Deduplicate issues flagged by multiple reviewers (keep the most actionable version)
4. **Check for contradictions** — if two reviewers give opposing advice on the same code (e.g., "add an abstraction" vs "keep it simple"), **stop and present the contradiction to the user for resolution** before proceeding. Do NOT proceed to the implementer until the user has resolved all contradictions.
5. Present the consolidated issue list to the user for awareness before dispatching the implementer

### 3. Fix Issues

- If any reviewer returned `CHANGES_REQUESTED`: launch an implementer agent (using the built-in `implementer` subagent type via the Task tool) with the consolidated, deduplicated issue list. The implementer is not a custom agent definition — it is Claude Code's general-purpose implementer that receives the issue list as its prompt and makes minimal, focused changes to address each issue.
- If all reviewers returned `APPROVED`: skip to step 5
- If a reviewer agent fails to return any result (timeout, crash, empty output), treat it as `CHANGES_REQUESTED` with no specific issues. Alert the user that the reviewer failed and ask whether to retry it or skip it for this iteration.

### 4. Re-Review (targeted)

After the implementer finishes, check which files the implementer modified. Then:

- Re-launch the reviewer agents that returned `CHANGES_REQUESTED` in the previous iteration.
- Additionally, if the implementer modified files that were NOT in the original consolidated issue list, re-launch any approved reviewers whose domain is relevant to those new files. This prevents implementer fixes from introducing unreviewed changes in other domains.

**Cross-domain escalation:** If a reviewer discovers an issue that spans another reviewer's domain (e.g., a logic bug with security implications), it should flag the issue and note which other reviewer domain may need to evaluate it. The orchestrator should ensure that domain's reviewer is included in the next re-review pass.

Repeat steps 2-4 until all reviewers have returned `APPROVED`.

### 5. Build Verification

After all reviewers have signed off:

- Execute `swift build`
- If build fails: launch the implementer to fix build errors, then analyze which files the implementer changed and re-launch only the reviewer agents whose domain is relevant to those changes. If the scope of changes is unclear, conservatively re-launch all reviewers. Then return to step 2.

### 6. Test Verification

After build succeeds:

- Execute `swift test`
- If tests fail: launch the implementer to fix test failures, then analyze which files the implementer changed and re-launch only the reviewer agents whose domain is relevant to those changes. If the scope of changes is unclear, conservatively re-launch all reviewers. Then return to step 2.

### 7. Deadlock Detection

If any reviewer has returned `CHANGES_REQUESTED` for 3 consecutive iterations:

- **Stop the loop immediately**
- Present the repeating issues to the user
- Explain which reviewer(s) are not converging and what the implementer attempted
- Ask the user for guidance on how to proceed

Note: The per-reviewer consecutive failure counter resets to 0 when a reviewer transitions to `APPROVED`. If that reviewer is later re-invoked (e.g., due to build-fix scope expansion) and starts requesting changes again, the 3-iteration counter starts fresh. The global iteration cap (`MAX_TOTAL_ITERATIONS = 10`) provides the hard backstop against oscillation scenarios where a reviewer alternates between approved and changes-requested across build-fix cycles.

Also stop and alert the user if:
- Two reviewers are giving contradictory guidance that the implementer cannot satisfy simultaneously
- The implementer's fix for one reviewer's issue causes a different reviewer to flag a new issue in a cycle

### 8. Confirm Completion

Report completion when:
- All reviewers have signed off (APPROVED)
- Build succeeds
- All tests pass

## Execution Pattern

```
MAX_ITERATIONS = 3          # per-reviewer consecutive failure cap
MAX_TOTAL_ITERATIONS = 10   # global iteration cap across the entire loop
iteration_counts = {}       # track per-reviewer consecutive iteration counts
reviewers_pending = ALL_REVIEWERS
total_iterations = 0

while True:
    total_iterations += 1

    # Global iteration cap
    if total_iterations > MAX_TOTAL_ITERATIONS:
        alert_user_global_cap_exceeded(total_iterations)
        break

    # Launch reviewers (all on first pass, only pending on subsequent passes)
    results = launch_reviewers_in_parallel(reviewers_pending, changes_context)

    # Handle reviewer failures (timeout, crash, empty output)
    for reviewer in reviewers_pending:
        if reviewer not in results or results[reviewer] is None:
            alert_user_reviewer_failed(reviewer)
            # Treat as CHANGES_REQUESTED per spec; user chooses retry or skip
            results[reviewer] = Result(sign_off=CHANGES_REQUESTED, issues=[])

    # Synthesize: deduplicate, check for contradictions
    consolidated = synthesize_and_deduplicate(results)

    if consolidated.has_contradictions:
        alert_user_and_wait(consolidated.contradictions)
        # Do NOT proceed until the user resolves contradictions
        if not contradictions_resolved:
            break

    # Track iterations per reviewer
    for reviewer in reviewers_pending:
        if results[reviewer].sign_off == CHANGES_REQUESTED:
            iteration_counts[reviewer] = iteration_counts.get(reviewer, 0) + 1
        elif results[reviewer].sign_off == APPROVED:
            # Reset counter when a reviewer transitions to APPROVED
            iteration_counts[reviewer] = 0

    # Deadlock detection
    deadlocked = {r: c for r, c in iteration_counts.items() if c >= MAX_ITERATIONS}
    if deadlocked:
        # Present all deadlocked reviewers to the user
        for reviewer in deadlocked:
            alert_user_deadlock(reviewer, results.get(reviewer))
        # User decides: skip the deadlocked reviewer(s) or abort the loop
        for reviewer in deadlocked:
            if user_says_skip(reviewer):
                del iteration_counts[reviewer]
            else:
                break  # user chose to abort
        else:
            # All deadlocked reviewers were skipped; continue the loop
            reviewers_pending = [r for r in reviewers_pending if r not in deadlocked]
            continue
        break  # user chose to abort

    # Determine which reviewers still need changes
    reviewers_pending = [r for r in reviewers_pending
                         if results[r].sign_off == CHANGES_REQUESTED]

    if not reviewers_pending:
        # All reviewers approved — proceed to build/test verification

        # Build verification
        build_result = run_build()
        if build_result.failed:
            launch_implementer(build_result.errors)
            changes_context = recompute_changes_context()
            changed_files = get_implementer_changed_files()
            reviewers_pending = select_relevant_reviewers(changed_files, ALL_REVIEWERS)
            continue  # back to review loop

        # Test verification
        test_result = run_tests()
        if test_result.failed:
            launch_implementer(test_result.errors)
            changes_context = recompute_changes_context()
            changed_files = get_implementer_changed_files()
            reviewers_pending = select_relevant_reviewers(changed_files, ALL_REVIEWERS)
            continue  # back to review loop

        # Everything passed
        break

    # Fix issues
    launch_implementer(consolidated.issues)
    changes_context = recompute_changes_context()

    # Check if implementer touched files outside the original issue scope
    changed_files = get_implementer_changed_files()
    issue_files = consolidated.affected_files
    new_files = changed_files - issue_files
    if new_files:
        # Re-add approved reviewers whose domain covers the newly touched files
        extra_reviewers = select_relevant_reviewers(new_files, ALL_REVIEWERS)
        reviewers_pending = list(set(reviewers_pending) | set(extra_reviewers))

report_completion()
```
