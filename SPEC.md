# SPEC.md - Minimal Vault-First Assistant (Bootstrap-Only)

## 0. Goal

Build an absolutely minimalist personal assistant on top of an existing CLI model (Claude / Gemini CLI / Codex) using only a markdown notes vault as the system of record.

Key properties:

- no required runtime codebase up front
- transparent, file-first behavior
- simple, user-editable memory model
- proactive behavior described in `_assistant/HEARTBEAT.md`
- reusable capability extensions via file-based skills
- categories as the backbone of long-term organization

---

## 1. Canonical Core Files

Core contract files use ALLCAPS naming:

1. `ASSISTANT.md` - role and operating rules (root)
2. `BOOTSTRAP.md` - one-time installer instructions (root)
3. `_assistant/` - assistant operating state (directory)

Supporting state directories:

- `_assistant/Memory/`
- `_assistant/Conversations/`
- `_assistant/Skills/`

Compatibility note:

- if host tools use `AGENTS.md` / `CLAUDE.md` / `GEMINI.md`, those files should point to `ASSISTANT.md`
- `ASSISTANT.md` remains the source of truth

---

## 2. Bootstrap Lifecycle (Canonical)

Bootstrap is one-time and file-driven via `BOOTSTRAP.md`.

### 2.1 Idempotency

If `BOOTSTRAP_DONE.md` exists, bootstrap must stop.

### 2.2 Discovery and User Input

Bootstrap gathers:

1. default conversation category
2. edit-caution policy for notes outside `/_assistant/` (`never`, `ask`, `sometimes`, `yolo`; default `ask`)
3. whether heartbeat scheduling should be enabled now (default no)
4. note-organization style/preferences (folders, tags, techniques; can be skipped)

Bootstrap questioning behavior:

- ask one question at a time
- apply defaults when user leaves values blank
- defaults:
  - default category: `Misc`
  - outside `/_assistant/` note edits mode: `ask`
  - heartbeat scheduling: `no`
- do not ask additional setup questions
- do not create or modify `/_assistant/**` files during question-asking
- if heartbeat is enabled, infer a default non-interactive CLI command pattern automatically
- if vault structure is sparse or unclear, initialize starter categories automatically: `Daily`, `Home`, `Work`, `Hobbies`, `Misc`
- carry inferred settings forward and write them during later steps (not during question-asking):
  - write runtime settings to `ASSISTANT.md` in Step 4
  - write behavior defaults and note-organization preferences to `_assistant/Memory/Preferences.md` in Step 7
  - note organization model summary from user answer + vault structure
  - memory updates mode: `suggest`
  - transcript saving mode: `suggest`
  - timezone: current machine timezone

Bootstrap also performs lightweight read-only vault analysis:

- top-level folder patterns
- tag usage (if present)
- daily note patterns (if present)

### 2.3 Install Completion

Bootstrap completes by renaming:

- `BOOTSTRAP.md` -> `BOOTSTRAP_DONE.md`

During install, `ASSISTANT.md` should be updated in-place (not regenerated) via a `Runtime Configuration` section, and behavior defaults should be initialized in `_assistant/Memory/Preferences.md`.

---

## 3. Vault Layout

```text
ASSISTANT.md
BOOTSTRAP.md (during install only; renamed to BOOTSTRAP_DONE.md)

_assistant/
  HEARTBEAT.md
  USER.md

  Memory/
    Working.md
    Preferences.md
    LongTerm.md

  Conversations/
    Transcripts/
    <category-1>/
    <category-2>/
    ...

  Skills/
    SKILLS.md
    <skill-name>/
      SKILL.md
      run.py or run.sh (optional)
```

---

## 4. Runtime Behavior Contract (File-Driven)

The host model follows `ASSISTANT.md` rules.

For each interaction:

1. choose/confirm a conversation category
2. proactively search likely relevant vault notes for applicable requests and ground the response in found content
3. ask the user to identify a source note only when multiple plausible notes conflict or no relevant note is found
4. write/update conversation artifacts under `_assistant/Conversations/`
5. refresh `_assistant/Memory/Working.md` (short and current)
6. follow `suggest` vs `auto` write mode

On heartbeat:

1. read `_assistant/HEARTBEAT.md`
2. resolve target `job_id` (from cron/manual invocation)
3. run the matching job
4. update `_assistant/Memory/Working.md` when relevant

---

## 5. Memory Model

### 5.1 `_assistant/Memory/Working.md`

- short-term, volatile, in-conversation memory
- generally rewrite instead of append
- keep headings minimal and evolve only when repeated patterns justify it

### 5.2 `_assistant/Memory/Preferences.md`

- user collaboration and organizational preferences
- includes a prominent `Conversation Categories` section
- includes `Assistant Behavior Defaults` (memory updates mode, transcript saving mode, timezone)
- category policy here is user-editable and authoritative

### 5.3 `_assistant/Memory/LongTerm.md`

- durable facts not captured in preferences
- periodically compacted to stay useful and bounded
- periodically reviewed for structure quality (merge/simplify sections as needed)

General rules:

- no speculative personal facts
- keep memory concise
- prefer evidence-linked updates when possible

---

## 6. Category Model (Backbone)

Categories are derived from:

- existing user folder structures
- tags
- explicit user guidance

Category principles:

- treat categories as a slowly changing dimension
- keep top-level count human-scale (single digits to low dozens)
- evolve deliberately as interests change
- allow user edits directly through `_assistant/Memory/Preferences.md`

---

## 7. Conversation and Transcript Policy

Primary organization is by category under:

- `_assistant/Conversations/<Category>/`

Full transcript storage is separate under:

- `_assistant/Conversations/Transcripts/YYYY-MM-DD_short_generated_name.md`

Transcript saving may be:

- `suggest` (recommended)
- `auto`
- or disabled except on explicit request (if user chooses)

The transcript mode default should be stored in `_assistant/Memory/Preferences.md` (`Assistant Behavior Defaults`).

---

## 8. Skills

Skills are user-extensible capabilities stored in:

- `/_assistant/Skills/<skill-name>/SKILL.md`

`_assistant/Skills/SKILLS.md` is an index/registry only (name, path, purpose), not a how-to guide.

Bootstrap should seed these starter skills:

- `summarize-day`
- `summarize-conversation` (invoked explicitly via `a:summarize-conversation`)
- `compact-assistant`

When user asks to add a skill, assistant should:

1. create/update the skill folder and `SKILL.md`
2. update `SKILLS.md`
3. keep instructions concise and executable
4. use existing local skills as style examples

If skill-local code is required:

- default entrypoint names:
  - `run.py` (preferred)
  - `run.sh` (fallback)
- prefer `uv` + Python for real code paths unless shell is clearly simpler

---

## 9. Heartbeat Scheduling and Job Model

`_assistant/HEARTBEAT.md` is the single scheduling/behavior contract for proactive work.

MVP defaults:

- one hourly job (`job_id: hourly-maintenance`)
- one daily job (`job_id: daily-summary`)
- one weekly review job (`job_id: weekly-memory-structure-review`)

Cron should run the preferred CLI in non-interactive mode and pass an explicit `job_id`.

Scheduling enablement:

- heartbeat scheduling is optional at bootstrap time
- default is disabled unless the user explicitly enables it

Expected prompt shape:

- `Read ./_assistant/HEARTBEAT.md and run job_id=<id>.`

Job modes:

- `mode: system` for internal maintenance behavior
- `mode: skill` for invoking a named skill

For memory-structure refactors, default to propose-first behavior (`suggest`) unless user explicitly opts into automatic restructuring.

---

## 10. Safety Boundaries

Default write scope:

- `ASSISTANT.md`
- `_assistant/**`

By default (`ask` mode), outside this scope requires confirmation.

External notes edit policy is configured in `ASSISTANT.md` Runtime Configuration:

- `never`: never edit outside `/_assistant/`; suggest only
- `ask`: require confirmation before outside edits (default)
- `sometimes`: allow low-risk outside edits when clearly requested; ask on ambiguity
- `yolo`: allow direct outside edits when clearly useful and aligned

Hard rules:

- no recursive deletes
- no secret exposure
- no unrelated modifications without intent

---

## 11. Acceptance Checklist

System is aligned when:

1. `ASSISTANT.md` is present in the root and remains the contract source of truth.
2. `_assistant/HEARTBEAT.md` and `_assistant/USER.md` are present and coherent.
3. `_assistant/Memory/Working.md`, `_assistant/Memory/Preferences.md`, and `_assistant/Memory/LongTerm.md` are initialized with clear roles.
4. `_assistant/Conversations/` exists with category folders and `Transcripts/`.
5. `_assistant/Skills/SKILLS.md` exists and at least one example skill is present.
6. Category policy and assistant behavior defaults are explicitly documented in `_assistant/Memory/Preferences.md`.
7. Heartbeat defaults include hourly, daily, and weekly-memory-structure-review `job_id`s.
8. Bootstrap is one-time and marked by `BOOTSTRAP_DONE.md`.

---

## 12. TODO

Near-term follow-ups:

1. Default transcript behavior to auto-save full transcripts (replace repeated per-turn save prompts).
2. Add hourly transcript compaction to keep transcript context bounded and useful.
3. Add an explicit named command (for example: `a:save-summary`) for on-demand summary save.
4. Tune retrieval heuristics for note-grounded requests (ranking, ambiguity handling, and fallback behavior).
5. Add a bootstrap rule to check existing skills before creating new ones (update or alias instead of duplicating).
6. Defer native CLI command mapping work until more cross-CLI testing shows clear value.
7. Instruct assistant to infer conversation boundaries as reliably as possible (where a conversation starts/ends).
8. Instruct assistant to infer best-fit category for each saved conversation, with user confirmation when uncertain.

END.
