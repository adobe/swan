---
name: renovate-swift-upgrade
description: Use when consolidating open Renovate pull requests, updating Swift package dependencies, or checking for a newer stable Swift toolchain in Swan.
---

# Renovate and Swift Upgrade

## Overview

Prepare one validated PR containing all open Renovate updates and any compatible stable Swift toolchain upgrade. Keep source PRs open until a later invocation verifies the combined PR has merged.

## When to Use

Use this skill when asked to consolidate open Renovate PRs, update Swift package dependencies, or check whether Swan has a newer supported stable Swift toolchain.

## Example

If #101 updates a package to 1.9.0, #102 proposes a compatible 2.0.0 update for it, and #103 updates a GitHub Action, inspect all three diffs, use #102 rather than stacking both package versions, and carry #103 into the batch. The combined PR body links all three sources, marks #101 as superseded by #102, and reports exact results such as `swift package update` — **PASS** (exit 0). Leave all source PRs open and never merge the combined PR.

## Workflow

### Preflight and inventory

1. Inspect `git status` and determine the repository's default branch. If the working tree is dirty, stop without changing or stashing it.
2. Check `gh auth status` and confirm repository access. If GitHub access or an inventory query fails, stop before making changes and report the error; an incomplete query is not evidence that there is no work.
3. Before preparing changes, find any existing combined PR, including one using the branch `mitaylor/renovate-swift-upgrade`. Do not create duplicate work. If it is open, report it and leave source PRs open.
4. Inventory every currently open Renovate PR, including GitHub Actions and other non-Swift updates. For each, record its number, title, URL, head branch, and proposed diff. Inspect every diff before changing files.

### Reconcile updates

- Carry every open Renovate update into the combined PR unless a newer PR for the same dependency supersedes it. Include all categories, including GitHub Actions and non-Swift dependencies.
- When multiple PRs update the same dependency, investigate the newest proposed version and its compatibility; use the newer superseding update, not stacked older bumps. Preparation effort is not a reason to choose an older version.
- If diffs conflict, an update cannot be safely combined, or compatibility of a newer version is unclear, stop and ask for guidance. Do not silently omit the update or fall back to an older bump.

### Decide on Swift

Check official Swift release information for the latest stable release. Exclude prereleases and development snapshots. Promote a snapshot to stable on the same major/minor line, or move to a newer stable line; never move from a newer snapshot line to an older stable line.

Before changing any toolchain pin, verify the candidate is supported by both Windows architectures in `.github/workflows/swift-windows.yaml` and has a matching usable WASM SDK for the repository's WASM build. Verify the official release/download tags and SDK mapping rather than inferring compatibility from the version number. If either support is unavailable, retain all existing toolchain pins, report the blocker, and continue Renovate consolidation with the current toolchain.

For a supported stable update, update `.swift-version`, the WASM SDK pin and mapping, Windows installer-tag handling, and every directly affected version reference found in the repository. Check `.swan-config`, `package.json`, `Makefile`, `AGENTS.md`, and workflows, then search for stale references. Do not change unrelated versions.

### Update, validate, and open one PR

If there are changes to propose, work on the isolated branch `mitaylor/renovate-swift-upgrade` based on the latest fetched default branch. If already on that branch, reuse it only when it is clean, up to date with the latest fetched default branch, and has no unrelated commits; otherwise stop without resetting or overwriting it. If on another branch, create the named branch only if it does not already exist. Never modify the default branch; stop and report if the named branch exists elsewhere or contains unrelated work. After the toolchain decision, install and select the final version from `.swift-version` before updating packages:

```sh
export PATH="$HOME/.swiftly/bin:$PATH"
swiftly install
swiftly use
swift --version
swift package update
```

Include the resulting `Package.resolved` changes and required manifest changes. Run each applicable command and record its exact command and pass/fail result:

```sh
swift build
swift test
make wasm-build
make wasm-build-bitonic
```

Install the matching WASM SDK first if needed. If a required local command fails or cannot run, troubleshoot it; if unresolved, stop without opening any PR, including a draft. Report checks that only run in CI as pending, never as passed.

Open one PR against the default branch only after all required local validation is resolved. Use the repository PR template if present, preserving its structure. The body must summarize the updates, link and number every source Renovate PR from the inventory (including older PRs superseded by a newer update, with the supersession noted), state the Swift toolchain decision or compatibility blocker, and list exact commands and pass/fail results for `swift package update` and every applicable build/test command above. For example: `swift build` — **PASS** (exit 0). Report CI-only checks as pending. Do not open a draft to bypass incomplete validation or close source PRs after opening the combined PR. Never merge the combined PR, manually or automatically; the workflow ends after opening it.

### Later cleanup invocation

Source-PR cleanup is a separate later invocation, not a continuation of PR creation. When asked to clean up source PRs, use the provided combined PR or identify it from the repository, then verify its merged state with GitHub before closing anything. If the combined PR is open or its merged state cannot be confirmed, leave every source PR open, report that cleanup is waiting, and end the invocation; do not poll or wait for the merge. In a later cleanup invocation after verifying it merged, close only still-open source PRs recorded in its body, with a comment explaining they were superseded by the merged combined PR.

### No-work case

If there are no open Renovate PRs, still check for a compatible stable Swift upgrade. Open a PR only if there are changes to propose; otherwise report that there is no work. Report any unsupported toolchain candidate as a blocker without changing its pins.

## Quick reference

| Situation | Required outcome |
|---|---|
| GitHub auth or complete PR inventory unavailable | Stop before changes; explain the error |
| Newer update supersedes an older PR | Investigate and use the newer update |
| Conflict or compatibility remains unclear | Stop and ask for guidance |
| Swift candidate lacks Windows or WASM support | Keep all toolchain pins; continue package updates |
| Required local validation remains unresolved | Do not open a PR, including a draft |
| Combined PR has not merged | Keep source PRs open |
| No Renovate PRs and no supported Swift change | Report no work; do not create an empty PR |

## Common mistakes and red flags

| Temptation | Required response |
|---|---|
| Leaving a GitHub Action or other non-Swift Renovate PR out of the batch | Inventory and include every open Renovate category |
| Reusing an already-prepared older bump instead of investigating a newer major update | Assess the newest update; ask for guidance if compatibility is unresolved |
| Closing sources when the combined PR merely passes checks | Wait for a later invocation and verify the combined PR is merged |
| Opening a draft while required validation is incomplete | Resolve validation or stop without opening a PR |
| Updating Swift based on release recency alone | Verify both Windows and WASM support before changing any toolchain pin |

**Red flags:** an omitted open Renovate PR; an older version chosen for convenience; an unexplained conflict; a source PR closed before merge; a draft opened with unresolved required validation; or a changed Swift pin without both compatibility checks. Stop and correct the workflow before proceeding.
