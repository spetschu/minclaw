 An experiment in building an absolute minimalist claw for working with a collection of notes.

 # Requirements

Claude Code (or codex or gemini-cli) on top of an Obsidian notes vault enhanced with claw-like personal assistant capabilities -- proactive organization, short and long term memory, and a heartbeat.


# Architectural Principles

- Skill/trait driven development over features/code
- LLM interpretation over fragile code and abstrations
- Purpose built over general purpose - provide architectural suggestions to the LLM and use it to implement concretely 
- Drive off of the BOOTSTRAP and evolve from there

For the notes:
- Readable flat files in human scale directory structures whenever possible
- Key off of the semantics of the human organized notes to drive the assistant's organizational strategy

 # Installation

1. Copy BOOTSTRAP.md and ASSISTANT.md into your directory root.
2. Start Claude / Gemini CLI / Codex in that directory.
3. Prompt:
    "Follow the instructions in BOOTSTRAP.md to turn yourself into a claw-like personal assistant."

Stricter kick off prompt (if the above doesn't work):
   "Read and execute BOOTSTRAP.md exactly, step by step. Start with Step 1 and do not skip ahead. Create/update only the files and folders specified by BOOTSTRAP.md, and show a brief checklist of what you changed after each step."


# Manual Test Loop

Use the synthetic fixture vault in `test_vault/` to try it out first.

1. Prepare test vault with current bootstrap files:
   `make testprep`
2. Start your target CLI in `test_vault/` and prompt it to run bootstrap manually as above.
3. Reset generated assistant artifacts between runs:
   `make testclean`


# Heartbeat Runtime

Heartbeat scheduling/runtime is zero-code, the LLM wakes up on beat and interprets the HEARTBEAT.md.

- one cron entry wakes up whatever AI coding CLI you're using every hour 
- the CLI reads `_assistant/HEARTBEAT.md` and executes items that make sense based on when it woke up, what it last did, and the task granularity  
   - summary log: `_assistant/Memory/Events.md`
   - raw CLI wake log: `_assistant/logs/heartbeat-cli.log`
