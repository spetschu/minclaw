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

Ask one question at a time (not as a single block).
After each answer, confirm the effective value.
If user leaves a value blank, apply the default shown below.

Ask only these four setup questions:

1. Default conversation category for uncategorized content? (default: `Misc`)
2. How cautious should assistant be about edits to notes outside `/_assistant/`? (user can describe preference or choose: `never`, `ask`, `sometimes`, `yolo`; default: `ask`)
3. Enable heartbeat scheduling now? (`yes`/`no`, default: `no`)
4. Tell me how you use and organize your notes. How do you use folders/tags, and what note-taking techniques do you use, if any? (or `skip`)

Do not ask additional setup questions.
Do not create or modify `/_assistant/**` files in Step 2.
Carry these answers forward and write them in later steps:

- Step 4: write runtime settings to `ASSISTANT.md`
- Step 7: write behavior defaults and note-organization preferences to `_assistant/Memory/Preferences.md`

After these four answers are received, do a lightweight read-only analysis of the markdown notes vault:

- top-level folders
- common subfolder patterns
- tag usage (if present)
- daily note patterns (if present)

Make use of the user's answers about how they think about their notes along with this analysis to create initial organization and behavior defaults and carry them forward.  

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
    /summarize-day/
      SKILL.md
    /summarize-conversation/
      SKILL.md
    /compact-assistant/
      SKILL.md
```

Rules:

- Create conversation category folders from the category model inferred from the user's vault structure and their answers.
- Ensure the selected default category folder exists under `/_assistant/Conversations/`.
- Do not literally create `<category-1>` or `<category-2>` folders; replace those placeholders with real category names.
- If inferred categories are sparse or unclear, initialize starter categories automatically: `Daily`, `Home`, `Work`, `Hobbies`, `Misc`.
- If no category decision is made, use `Misc` as the default category.

---

## STEP 4 - Create ASSISTANT.md

`ASSISTANT.md` should already exist in the vault root (copied by the user before bootstrap).
Do not rewrite it from scratch.

Update or append only a `## Runtime Configuration` section in `ASSISTANT.md` with finalized values from Step 2:

- Default category
- Outside `_assistant/` note edits mode
- Heartbeat scheduling enabled/disabled
- Heartbeat CLI command pattern (auto-inferred if enabled)

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
- skill: summarize-day
- output: day summary note + suggested updates for `_assistant/Memory/LongTerm.md`

### weekly-memory-structure-review
- cadence: weekly
- mode: system
- action: inspect current memory file contents and propose a cleaner structure when it would improve usefulness
- write_mode: suggest
```

Use the machine timezone detected during bootstrap (or existing timezone preference if already present).
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

Then fill only concise, user-confirmed facts (no speculation), except machine-detected timezone may be filled directly.
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

## Assistant Behavior Defaults
- Memory updates mode: suggest
- Transcript saving mode: suggest
- Timezone:

## Collaboration Preferences
- Note organization model:
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
- `Preferences.md` must also include `Assistant Behavior Defaults` with:
  - memory updates mode (default: `suggest`)
  - transcript saving mode (default: `suggest`)
  - timezone (default: current machine timezone)
- `Collaboration Preferences` should include a short, inferred note-organization model from vault analysis (user-editable).
- weekly heartbeat should review memory structure and propose refactors when organization becomes unhelpful

Treat categories as a slowly changing dimension: evolve carefully over time, keep top-level category count human-scale (single digits to low dozens), and avoid unnecessary churn.

---

## STEP 8 - Initialize Skills

Create `_assistant/Skills/SKILLS.md` as a lightweight index (not a how-to manual) and seed three starter example skills:

- `_assistant/Skills/summarize-day/SKILL.md`
- `_assistant/Skills/summarize-conversation/SKILL.md`
- `_assistant/Skills/compact-assistant/SKILL.md`

Initialize `_assistant/Skills/SKILLS.md` with:

```md
# Skills Index

This file is a registry of available skills and where they live.

## Skills

- `summarize-day`
  - path: `_assistant/Skills/summarize-day/SKILL.md`
  - purpose: summarize recent conversations into concise Daily notes in `_assistant/Daily` following the naming conventions for Daily notes.

- `summarize-conversation`
  - path: `_assistant/Skills/summarize-conversation/SKILL.md`
  - purpose: save the current conversation to the best-fit category under `_assistant/Conversations/` with best-effort conversation boundaries

- `compact-assistant`
  - path: `_assistant/Skills/compact-assistant/SKILL.md`
  - purpose: compact assistant memory files while preserving important facts
```

Initialize `_assistant/Skills/summarize-day/SKILL.md` with:

```md
---
name: summarize-day
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
- cite source conversations by filename when possible using `[[wikilinks]]`
```

Initialize `_assistant/Skills/summarize-conversation/SKILL.md` with:

```md
---
name: summarize-conversation
description: Save the current conversation as a categorized conversation note with best-effort conversation boundaries.
---

# Summarize Conversation

## When to use

- when user invokes `a:summarize-conversation`
- when user explicitly asks to save/summarize the current conversation

## Inputs

- current conversation in this session
- `_assistant/Memory/Preferences.md` for category policy
- `_assistant/Memory/Working.md` for current context

## Process

1. Determine the most appropriate category from conversation content and category policy.
2. Determine a best-effort conversation boundary for what to include now.
3. Save a concise summary note to `/_assistant/Conversations/<Category>/YYYY-MM-DD_short_generated_name.md`.
4. Use `[[wikilinks]]` when referencing vault markdown notes.
5. If category or boundary is uncertain, choose the best fit and include one short uncertainty note.

## Outputs

- saved conversation note under the chosen category
- optional prompt to also save a full transcript in `/_assistant/Conversations/Transcripts/` (based on transcript mode)

## Constraints

- prioritize useful summary over verbatim transcript
- avoid speculation
- preserve key decisions, requests, and next actions
```

Initialize `_assistant/Skills/compact-assistant/SKILL.md` with:

```md
---
name: compact-assistant
description: Compact assistant memory by removing redundancy and preserving durable, high-value facts.
---

# Compact Assistant Memory

## When to use

- on hourly/daily maintenance when memory grows noisy
- when user asks to compact assistant memory

## Inputs

- `_assistant/Memory/LongTerm.md`
- `_assistant/Memory/Working.md` (optional for context)
- `_assistant/Memory/Preferences.md` (optional for preference elevation)
- relevant recent conversation summaries (if available)

## Outputs

- rewritten, cleaner assistant memory files (typically `_assistant/Memory/LongTerm.md`)
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
- for explicit skill invocations, use portable named commands in the form `a:<command-name>` instead of slash-menu dependencies
- when referring to markdown files in the vault, prefer `[[wikilinks]]` over backticked file paths
- if a skill requires local executable code, default entrypoint names to:
  - `run.py` (preferred)
  - `run.sh` (fallback)
- prefer `uv` + Python for real code (`run.py`) unless shell is clearly simpler

Follow the Agent Skills style for frontmatter and concise instructions.

---

## STEP 9 - Configure Cron for Heartbeat

Only run this step if the user enabled heartbeat scheduling in Step 2.

If heartbeat is disabled, skip cron setup and proceed to Step 10.

If heartbeat is enabled, infer a non-interactive CLI command pattern and configure cron entries that pass explicit `job_id` values:

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
