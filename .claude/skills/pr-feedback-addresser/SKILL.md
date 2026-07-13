---
name: pr-feedback-addresser
description: This skill should be used when addressing PR feedback, reviewing PR comments, or responding to code review feedback on a pull request. Use when the user asks to address PR comments, respond to feedback, or implement requested changes from a code review. The skill automatically finds the PR for the current branch, fetches all feedback, detects already-addressed items, and walks through each piece of feedback interactively.
---

# PR Feedback Addresser

When a pull request receives code review feedback, this skill automates the process of collecting all comments, detecting which have already been addressed, and walking the user through each remaining item one-by-one. After the user has provided direction on all feedback, the skill implements all changes and posts replies to addressed comments with the commit SHA.

## Workflow

This skill follows a systematic workflow to ensure all feedback is properly addressed.

### Step 1: Fetch PR Information

**IMPORTANT:** PR data fetching MUST be delegated to a haiku subagent using the Task tool. GitHub API responses for PRs can contain hundreds of review comments, and fetching them directly in the main agent risks context window exhaustion. The subagent runs all the `gh` CLI commands, parses the raw JSON, and returns only a compact structured summary.

First, determine the current branch and owner/repo so you can construct the subagent prompt:

```bash
# Get current branch
git rev-parse --abbrev-ref HEAD

# Get owner/repo
gh repo view --json nameWithOwner -q .nameWithOwner
```

Then launch the data-fetching subagent:

```
Task(
  model: "haiku",
  prompt: <PR data fetch prompt below>,
  description: "Fetch PR feedback for branch <branch>"
)
```

**PR Data Fetch Subagent Prompt:**

````
Fetch all PR feedback data for branch "{BRANCH}" in repo "{OWNER}/{REPO}" and return a compact structured summary.

Run the following commands using the Bash tool, then parse and summarize the results.

## Step 1: Find the PR

```bash
gh pr list --repo {OWNER}/{REPO} --head {BRANCH} --json number,title,body,state,author,baseRefName,headRefName,url,createdAt,updatedAt
```

If no PR is found, return EXACTLY: "NO_PR_FOUND: No pull request exists for branch {BRANCH}" and stop.

Extract the PR number from the result.

## Step 2: Fetch all PR data

Run ALL of the following commands:

```bash
# Get PR files changed
gh pr diff {PR_NUMBER} --repo {OWNER}/{REPO} --name-only

# Get review comments (inline code comments) - includes in_reply_to_id for threading
gh api /repos/{OWNER}/{REPO}/pulls/{PR_NUMBER}/comments --paginate

# Get issue comments (general PR discussion)
gh api /repos/{OWNER}/{REPO}/issues/{PR_NUMBER}/comments --paginate

# Get reviews (overall review decisions with bodies)
gh api /repos/{OWNER}/{REPO}/pulls/{PR_NUMBER}/reviews --paginate
```

## Step 3: Return structured summary

Parse all the raw JSON responses and return a summary in EXACTLY this format. Do NOT return raw JSON. Extract only the fields listed below.

```
PR_NUMBER: <number>
PR_URL: <url>
OWNER_REPO: {OWNER}/{REPO}
TITLE: <title>
AUTHOR: <author login>
BASE_BRANCH: <base ref name>
HEAD_BRANCH: <head ref name>
STATE: <state>

CHANGED_FILES:
- <file path 1>
- <file path 2>
...

REVIEW_COMMENTS:
- id: <id>, author: <user login>, file: <path>, line: <line or original_line>, body: "<comment body>", created_at: <timestamp>, in_reply_to_id: <id or null>
- ...

ISSUE_COMMENTS:
- id: <id>, author: <user login>, body: "<comment body>", created_at: <timestamp>
- ...

REVIEWS:
- id: <id>, author: <user login>, state: <APPROVED|CHANGES_REQUESTED|COMMENTED|DISMISSED>, body: "<review body or empty>"
- ...
```

RULES:
- Run the commands EXACTLY as provided
- Do NOT analyze or interpret the feedback content — just extract and format
- For comment bodies, preserve the full text (do not truncate)
- If any command fails, report the error for that section and continue with the remaining commands
- If a section has no items, write "none" under that heading
- Return control to calling agent immediately after producing the summary
````

The subagent will return a compact summary that the main agent uses for all subsequent steps. If the subagent reports `NO_PR_FOUND`, check:
- User is on a git branch (not detached HEAD)
- A PR exists for the current branch
- `gh` CLI is authenticated and has access to the repository
- The repository owner and name are correct

If there is an unrecoverable error, escalate to the user

### Step 2: Update to Latest Branch State

Ensure working with the latest code by fetching and checking out the current PR branch:

```bash
git fetch origin && git checkout <branch_name> && git pull origin <branch_name>
```

This ensures the analysis reflects the most recent state of the PR, which is critical for understanding if any feedback has already been addressed.

### Step 3: Analyze the PR Changes

Read and understand the changes made in the PR:

1. **Review the PR diff**: Use `git diff <base_branch>...<head_branch>` to see all changes
2. **Read modified files**: Use the Read tool to examine each changed file's current state
3. **Understand the context**: Review the PR title and description to understand the intent
4. **Identify key changes**: Note the main modifications, additions, and deletions

This context is essential for understanding the feedback in context. Never propose changes to code that hasn't been read.

### Step 4: Detect Already-Addressed Feedback

For each piece of feedback, determine if it has already been addressed. A comment is considered **already addressed** if ANY of the following are true:

**Git History Indicators:**
- Check `git log --oneline <base>..HEAD` for commit messages that reference the feedback
- Use `git blame` on the relevant lines to see if they were modified after the comment was posted
- Compare the comment's `created_at` timestamp against commits touching that file/line

**Comment Thread Indicators:**
- The comment has a reply (check `in_reply_to_id` field in other comments) indicating resolution
- A reply from the PR author acknowledges the change was made
- A reply contains phrases like "fixed", "done", "addressed", "updated"

**Code State Indicators:**
- The specific code mentioned in the comment no longer exists in that form
- The requested change is already present in the current code state
- The file/function referenced has been significantly refactored

**Detection Commands:**
```bash
# Get commits after a specific date (comment creation time)
git log --oneline --after="<comment_created_at>" -- <file_path>

# Check if specific lines were modified after comment
git blame -L <start>,<end> <file_path>

# See what changed in file since a specific commit
git diff <commit_at_comment_time>..HEAD -- <file_path>
```

For each comment determined to be already addressed, note:
- The comment ID (for later reply posting)
- The evidence for why it's addressed (commit SHA, code state, reply thread)
- Brief summary for user notification

**Report to User:** Before proceeding, briefly list all auto-detected already-addressed items:
> "Detected X comments as already addressed and will skip them:
> - Comment by @reviewer on file.ts:42 - line was modified in commit abc123
> - Comment by @reviewer on utils.ts:15 - has reply thread indicating resolution"

### Step 4b: Create Task List for All Feedback Items

**IMPORTANT: This step creates durable task state that survives context compaction.** Use the TaskCreate tool to create a task for every feedback item — both those needing review and those already addressed. This ensures the full picture of work is preserved even if the conversation is compressed.

**For each already-addressed feedback item**, create a task marked as `completed`:
```
TaskCreate(
  description: "PR feedback: @<reviewer> on <file>:<line> — <short summary of comment>",
  status: "completed"
)
```

**For each feedback item needing review**, create a task marked as `pending`:
```
TaskCreate(
  description: "PR feedback: @<reviewer> on <file>:<line> — <short summary of comment>",
  status: "pending"
)
```

Include the following in the task description so all context is self-contained and recoverable:
- The GitHub comment ID (for posting replies later)
- The reviewer username
- The file and line (if applicable)
- The full comment body (quoted)
- The comment type (review comment, issue comment, or review body)

Also create a parent/summary task to track overall progress:
```
TaskCreate(
  description: "Address PR feedback for PR #<number> (<title>) — <total> items, <addressed> already addressed, <pending> pending review"
)
```

### Step 5: Interactive Feedback Review (Collection Phase)

**IMPORTANT: This step is a collection-only phase. Do NOT implement any changes during this step. Walk through ALL feedback items first, collect the user's decisions for every item, and only then proceed to Step 6 for implementation.**

**Resume support:** At the start of this step, check the task list (TaskList) for any existing feedback tasks. If tasks already have decisions recorded (status is not `pending`), skip those items — they were already reviewed in a previous pass before a context compaction. Only present items whose tasks are still `pending`.

For each piece of feedback that was NOT auto-detected as addressed and whose task is still `pending`, research how to best address it, then present it to the user one at a time and gather their direction.

**For each feedback item, first research:**
1. **Read the relevant code**: Use the Read tool to examine the file and surrounding context
2. **Understand the request**: Analyze what the reviewer is asking for
3. **Investigate implementation options**: Determine the best way to address the feedback
4. **Identify any concerns**: Note if the suggested change might have unintended consequences
5. **Formulate a recommendation**: Prepare a suggested approach to present to the user

**Then display to the user:**
1. **Reviewer**: Who left the comment
2. **Location**: File and line number (if applicable)
3. **Comment**: The exact feedback text (quoted verbatim)
4. **Type**: Review comment, issue comment, or review body
5. **Context**: Show the relevant code snippet if it's an inline comment
6. **Recommended approach**: Your analysis of how to best address this feedback, including any trade-offs or concerns

**Then use AskUserQuestion to get the user's direction with these options:**

For actionable feedback (code change requests):
- **Implement as requested** - Make the change exactly as the reviewer suggests
- **Implement with modification** - Make a change, but with a different approach (prompt for details)
- **Decline and respond** - Don't make the change, but respond to the reviewer (prompt for response text)
- **Create follow-up issue and respond** - Create a GitHub issue for follow-up work, respond with a link to the reviewer
- **Skip silently** - Don't make the change and don't respond (use sparingly)

For questions or discussion comments:
- **Respond with explanation** - Reply to the comment (prompt for response text)
- **This needs a code change** - Treat as actionable feedback and implement something
- **Skip silently** - No response needed

**After each user decision, immediately update the corresponding task** using TaskUpdate:
```
TaskUpdate(
  id: <task_id>,
  status: "in_progress",
  description: "<original description>\n\nDECISION: <implement|implement-modified|decline|issue-followup|respond|skip>\nIMPLEMENTATION NOTES: <details of what to change, or response text to post>\nCOMMENT ID: <github_comment_id>"
)
```

This ensures each decision is durably recorded. If context is compacted mid-review, the agent can resume by reading the task list and skipping items that already have a DECISION recorded.

**Continue presenting items and collecting decisions until ALL feedback items have been reviewed with the user. Do not begin any implementation until every item has a decision.**

### Step 6: Implement All Changes (Parallel Execution Phase)

**This step begins ONLY after ALL feedback decisions have been collected in Step 5.**

**Resume support:** Read the task list (TaskList) to recover all decisions. If this step is reached after a context compaction, the task list is the source of truth for what to implement. Filter for tasks with `status: "in_progress"` that have a `DECISION` of `implement`, `implement-modified`, `issue-followup`, or `respond`.

Implement all the changes the user approved using parallel subagents for maximum efficiency:

1. **Group related changes**: If multiple feedback items affect the same file/area, group them into a single implementation unit
2. **Identify independent work items**: Separate the grouped changes into independent units that can be implemented in parallel (changes to different files/areas with no overlap)
3. **Launch parallel implementer subagents**: Use the Task tool with `subagent_type=implementer` to launch multiple implementer agents simultaneously for all independent work items. Each subagent should receive the full context of what to change and why (the feedback, the user's decision, and any implementation notes)
4. **Wait for all subagents to complete**: Ensure all parallel implementations finish successfully
5. **Make all changes before committing**: Verify all implementations are complete and consistent
6. **Create a single commit**: Commit all changes together with a descriptive message listing what was addressed

Record the commit SHA for use in reply comments.

**After committing, update all implementation tasks:**
```
TaskUpdate(
  id: <task_id>,
  status: "completed",
  description: "<existing description>\n\nCOMMIT: <sha>"
)
```

**Commit Message Format:**
```
Address PR feedback

- <specific change 1>
- <specific change 2>
- <specific change 3>
```

### Step 7: Post Reply Comments

After all changes are committed, post replies to the PR for each addressed comment. Read the task list to recover comment IDs and decisions:

**For implemented changes:**
```bash
# Reply to a review comment
gh api /repos/{owner}/{repo}/pulls/<pr_number>/comments \
  -X POST \
  -f body="Addressed in commit <sha>" \
  -f in_reply_to=<original_comment_id>
```

**For declined feedback with response:**
```bash
gh api /repos/{owner}/{repo}/pulls/<pr_number>/comments \
  -X POST \
  -f body="<user's response text>" \
  -f in_reply_to=<original_comment_id>
```

**For issue comments (general discussion), reply differently:**
```bash
gh api /repos/{owner}/{repo}/issues/<pr_number>/comments \
  -X POST \
  -f body="<response text>"
```

After posting each reply, update the task to record it:
```
TaskUpdate(
  id: <task_id>,
  description: "<existing description>\n\nREPLY POSTED: yes"
)
```

### Step 8: Final Summary

Read the full task list (TaskList) to compile the summary. Present to the user:

1. **Changes implemented**: The commit SHA and list of what was addressed
2. **Replies posted**: List of comments that received replies
3. **Skipped items**: Any feedback that was skipped without response
4. **Next steps**: Remind user to push changes and request re-review if needed

```bash
# Push changes
git push origin <branch_name>

# Request re-review (optional)
gh pr edit <pr_number> --add-reviewer <reviewer_username>
```

Update the parent summary task to completed:
```
TaskUpdate(
  id: <summary_task_id>,
  status: "completed",
  description: "Address PR feedback for PR #<number> — ALL DONE. Commit: <sha>"
)
```

## Important Guidelines

- **Tasks as durable state**: Use TaskCreate/TaskUpdate throughout the workflow to persist progress. Tasks survive context compaction and allow the agent to resume mid-workflow without losing decisions or state.
- **Resume from tasks**: At the start of any step, check TaskList for existing progress. If tasks already exist with recorded decisions/status, resume from where the previous context left off rather than starting over.
- **Collect ALL decisions first**: Walk through every feedback item and gather the user's direction on ALL items before implementing anything. Never implement a change while still collecting decisions on remaining items.
- **Parallel implementation**: After all decisions are collected, launch parallel implementer subagents (Task tool with subagent_type=implementer) for independent work items to maximize efficiency
- **Auto-detect addressed feedback**: Always check git history and comment threads before presenting feedback to user
- **Research before presenting**: Investigate each feedback item and formulate a recommendation before showing to user
- **One at a time**: Present each feedback item individually, don't overwhelm with a summary
- **Always fetch latest**: Pull the latest branch state before analyzing
- **Read the code**: Never propose changes to code not read and understood
- **Quote feedback exactly**: Always include exact reviewer quotes
- **Record decisions**: Track what the user decides for each item — persist to task immediately
- **Single commit**: All changes go into one commit
- **Post replies**: Always reply to addressed comments with commit SHA

## Common Edge Cases

**No PR found**: If `gh pr list` reports no PR for the branch, verify:
- The branch has been pushed to remote
- A PR has been created for this branch
- The PR isn't closed or merged already
- The user has permissions to access the PR

**Multiple PRs**: If multiple PRs exist for the branch (unusual), `gh pr list` may return multiple results. Verify with the user which PR they want to address.

**No comments**: If PR has no comments or all reviews are approvals without comments, inform the user there's no feedback to address. The PR may be ready to merge.

**All feedback already addressed**: If auto-detection determines all feedback is already addressed, report this to the user and ask if they want to post "Addressed in commit X" replies to any outstanding comments.

**Comment threads**: Review comments may have replies and discussions. Analyze the entire thread to understand the final resolution or request, not just the initial comment. If a thread shows resolution, mark as already addressed.

## GitHub CLI Commands Reference

This skill relies on the `gh` CLI tool for fetching and posting PR information. Key commands used:

**Fetching:**
- `gh pr list --head <branch>`: Find PR for a specific branch
- `gh pr view <number>`: Get PR details
- `gh pr diff <number>`: Get changed files in a PR
- `gh api /repos/{owner}/{repo}/pulls/<number>/comments`: Get review comments
- `gh api /repos/{owner}/{repo}/issues/<number>/comments`: Get issue comments
- `gh api /repos/{owner}/{repo}/pulls/<number>/reviews`: Get review summaries

**Posting replies:**
- `gh api /repos/{owner}/{repo}/pulls/<number>/comments -X POST -f body="..." -f in_reply_to=<id>`: Reply to review comment
- `gh api /repos/{owner}/{repo}/issues/<number>/comments -X POST -f body="..."`: Post issue comment

The `--paginate` flag ensures all comments are fetched even for PRs with many comments.
