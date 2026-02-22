# BOOTSTRAP.md - Turn This Vault Into a Notes-First Personal Assistant

You are being asked to transform this markdown notes vault into a transparent, file-based personal assistant system.

Follow these steps exactly.

---

## STEP 1 - Confirm Installation

If a file named `BOOTSTRAP_DONE.md` already exists in this directory, STOP.  
This vault is already bootstrapped.

If not, continue.

---

## STEP 2 - Ask the User These Questions

Run this step in two passes.

Ask one question at a time (not as a single block).
After each answer, confirm the effective value.
If user leaves a value blank, apply the default shown below.

Pass A - Ask these first:

1. Default conversation category for uncategorized content? (default: `Misc`)
2. Memory updates mode: `suggest` or `auto`? (default: `suggest`)
3. Transcript saving mode: `suggest`, `auto`, or `off-by-default`? (default: `suggest`)
4. Require confirmation for risky actions outside assistant-owned files/folders? (`yes`/`no`, default: `yes`)
5. Timezone for scheduling? (default: current machine timezone)
6. Enable heartbeat scheduling now? (`yes`/`no`, default: `no`)
7. If heartbeat is enabled: which non-interactive CLI command pattern should heartbeat use?  
   - first infer the current CLI and suggest a default command pattern
   - ask user to accept or edit it

After Pass A answers are received, do a lightweight read-only analysis of the markdown notes vault:

- top-level folders
- common subfolder patterns
- tag usage (if present)
- daily note patterns (if present)

Then ask Pass B:

8. In 1-3 sentences, describe how you organize and think about your notes (saved to `_assistant/Memory/Preferences.md`). We can evolve this later. Ask targeted follow-ups only if needed:
   - Do you use daily notes? How much and for what?
   - Do you organize mainly by folders/sub-folders, by tags, or both?
   - Are there any hard categories or directory structures you want strictly enforced?

If the vault has little/no clear structure and user has no strong preference, suggest starter categories:

- `Daily`
- `Home`
- `Work`
- `Hobbies`

and ask for confirmation.

Wait for answers before proceeding.

---

## STEP 3 - Create Core Directory Structure

Create the following directory tree if it does not exist:

```text
/_assistant/
  HEARTBEAT.md
  USER.md

  /Memory/
    Working.md
    Preferences.md
    LongTerm.md

  /Conversations/
    Transcripts/
    <category-1>/
    <category-2>/
    ...

  /Skills/
    SKILLS.md
    /daily-conversation-summary/
      SKILL.md
    /memory-compact/
      SKILL.md
```

Rules:

- Create conversation category folders from the category model inferred from the user's vault structure and their answers.
- Ensure the selected default category folder exists under `/_assistant/Conversations/`.
- Do not literally create `<category-1>` or `<category-2>` folders; replace those placeholders with real category names.
- If inferred categories are sparse or unclear, ask for 3-7 starter categories and create those.
- If no category decision is made, use `Misc` as the default category.

---

## STEP 4 - Create ASSISTANT.md

`ASSISTANT.md` should already exist in the vault root (copied by the user before bootstrap).
Do not rewrite it from scratch.

Update or append only a `## Runtime Configuration` section in `ASSISTANT.md` with finalized values from Step 2:

- Default category
- Memory updates mode
- Transcript saving mode
- Risky action confirmation mode
- Timezone
- Heartbeat scheduling enabled/disabled
- Heartbeat CLI command pattern (if enabled)

If any of these files already exist in the vault root:

- `AGENTS.md`
- `CLAUDE.md`
- `GEMINI.md`

prepend this single line at the top (without replacing the rest of the file):

`Read ./ASSISTANT.md first and follow it as the personal-assistant contract for this vault; use this file only for tool-specific overrides.`

---

## STEP 5 - Create HEARTBEAT.md

Create `_assistant/HEARTBEAT.md` with default jobs and IDs:

```md
# HEARTBEAT

## Jobs

### hourly-maintenance
- cadence: hourly
- mode: system
- action: review recent conversations, refresh `_assistant/Memory/Working.md`, and suggest category adjustments when patterns drift

### daily-summary
- cadence: daily
- mode: skill
- skill: daily-conversation-summary
- output: day summary note + suggested updates for `_assistant/Memory/LongTerm.md`

### weekly-memory-structure-review
- cadence: weekly
- mode: system
- action: inspect current memory file contents and propose a cleaner structure when it would improve usefulness
- write_mode: suggest
```

Use the user's timezone.
Always create this file, even if heartbeat scheduling is disabled for now.

---

## STEP 6 - Create USER.md

Create `_assistant/USER.md`.

Initialize it with this skeleton:

```md
# USER.md

## Basics
- Name:
- Timezone:

## Communication Defaults
- Tone:
- Verbosity:
- Decision style:

## Boundaries
- Hard no-go areas:
- Confirmation requirements:

## Current Priorities
- 
```

Then fill only concise, user-confirmed facts (no speculation).
Do not infer communication style from writing tone; unknown fields should remain blank or `Unknown`.

---

## STEP 7 - Initialize Memory Files

Create these files with starter structure (not blank):

- `_assistant/Memory/Working.md`
- `_assistant/Memory/Preferences.md`
- `_assistant/Memory/LongTerm.md`

`_assistant/Memory/Working.md`
```md
# Working Memory

## Current Context
- 

## Active Focus
- 

## Next Actions
- 
```

`_assistant/Memory/Preferences.md`
```md
# Preferences

## Conversation Categories
- Categories:
- Default category:

## Routing Rules (folders/tags)
- 

## Collaboration Preferences
- 
```

`_assistant/Memory/LongTerm.md`
```md
# Long-Term Memory

## Durable Facts
- 

## Stable Projects/Interests
- 

## Open Loops
- 
```

Requirements:

- `Working.md` is short-term and volatile; prefer rewriting over appending.
- `LongTerm.md` stores durable non-preference facts and should be periodically compacted.
- `Preferences.md` must include a prominent section named `Conversation Categories` that contains:
  - current category list
  - default category
  - folder/tag routing cues
  - any hard constraints for categorization
- weekly heartbeat should review memory structure and propose refactors when organization becomes unhelpful

Treat categories as a slowly changing dimension: evolve carefully over time, keep top-level category count human-scale (single digits to low dozens), and avoid unnecessary churn.

---

## STEP 8 - Initialize Skills

Create `_assistant/Skills/SKILLS.md` as a lightweight index (not a how-to manual) and seed two starter example skills:

- `_assistant/Skills/daily-conversation-summary/SKILL.md`
- `_assistant/Skills/memory-compact/SKILL.md`

Initialize `_assistant/Skills/SKILLS.md` with:

```md
# Skills Index

This file is a registry of available skills and where they live.

## Skills

- `daily-conversation-summary`
  - path: `_assistant/Skills/daily-conversation-summary/SKILL.md`
  - purpose: summarize recent conversations into concise daily notes

- `memory-compact`
  - path: `_assistant/Skills/memory-compact/SKILL.md`
  - purpose: compact `_assistant/Memory/LongTerm.md` while preserving important facts
```

Initialize `_assistant/Skills/daily-conversation-summary/SKILL.md` with:

```md
---
name: daily-conversation-summary
description: Summarize recent conversation activity into a concise daily summary with suggested long-term memory updates.
---

# Daily Conversation Summary

## When to use

- on daily heartbeat summary jobs
- when user requests a daily recap

## Inputs

- recent files under `_assistant/Conversations/`
- current `_assistant/Memory/Working.md`
- current date/time (user timezone)

## Outputs

- concise day summary note (or summary section update)
- suggested additions/edits for `_assistant/Memory/LongTerm.md`

## Constraints

- prefer concise bullet summaries
- avoid speculation
- cite source conversations by filename when possible
```

Initialize `_assistant/Skills/memory-compact/SKILL.md` with:

```md
---
name: memory-compact
description: Compact long-term memory by removing redundancy and preserving durable, high-value facts.
---

# Memory Compact

## When to use

- on hourly/daily maintenance when memory grows noisy
- when user asks to compact long-term memory

## Inputs

- `_assistant/Memory/LongTerm.md`
- relevant recent conversation summaries (if available)

## Outputs

- rewritten, cleaner `_assistant/Memory/LongTerm.md`
- optional note of major merges/removals

## Constraints

- preserve durable facts
- remove duplication and stale fragments
- keep structure stable and readable
```

Skill rules:

- each skill lives at `/_assistant/Skills/<skill-name>/SKILL.md`
- keep `SKILLS.md` as an index only (name, path, purpose)
- when user asks "add a skill", create/update the folder and update `SKILLS.md`
- if a skill requires local executable code, default entrypoint names to:
  - `run.py` (preferred)
  - `run.sh` (fallback)
- prefer `uv` + Python for real code (`run.py`) unless shell is clearly simpler

Follow the Agent Skills style for frontmatter and concise instructions.

---

## STEP 9 - Configure Cron for Heartbeat

Only run this step if the user enabled heartbeat scheduling in Step 2.

If heartbeat is disabled, skip cron setup and proceed to Step 10.

If heartbeat is enabled, use the user-provided CLI command pattern to configure cron entries that pass explicit `job_id` values:

- hourly: `job_id=hourly-maintenance`
- daily: `job_id=daily-summary`
- weekly: `job_id=weekly-memory-structure-review`

Each cron entry should:

- change directory to the vault root first
- launch the CLI in non-interactive mode
- use a prompt equivalent to:

`Read ./_assistant/HEARTBEAT.md and run job_id=<id>.`

If direct cron installation is not possible, output ready-to-paste cron lines.

---

## STEP 10 - Finalize

Rename this file:

```text
BOOTSTRAP.md -> BOOTSTRAP_DONE.md
```

After renaming, confirm:

"Vault-first personal assistant successfully installed."
