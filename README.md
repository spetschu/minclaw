 An experiment in building an absolute minimalist claw. No code, all bootstrap.

 # Requirements

I take all of my notes in markdown. My vault of notes is organized in a way that matches my life and my interests (everything is in clean markdown notes vault format with liberal use of [[wikilinks]] to encourage a navigable knowledge graph). 

I want to use tools like claude/gemini-cli/codex not just for session programming but as an ongoing, learning, evolving assistant on top of my notes in a way that they can take advantage of their human curated knowledge and organizational constructs.

So basically Claud Code and friends, but with claw-like personal assitant capabilities -- proactive organization, short and long term memory, and a heartbeat.

# Architecture

- Almost everything drives off of the BOOTSTRAP and evolves from there
- Readable flat files in human scale directory structures whenever possible
- Skill/trait driven development over features/code
- Absolute minimum configs/plugins/abstractions up front. Instead, evolve to fit the purpose as you go

 # Installation

1. Copy BOOTSTRAP.md and ASSISTANT.md into your directory root.
2. Start Claude / Gemini CLI / Codex in that directory.
3. Prompt:
    "Follow the instructions in BOOTSTRAP.md to turn yourself into a claw-like personal assistant."

Stricter kick off prompt:
   "Read and execute BOOTSTRAP.md exactly, step by step. Start with Step 1 and do not skip ahead. Ask Step 2 questions in order, wait for my answers, then continue. Create/update only the files and folders specified by BOOTSTRAP.md, and show a brief checklist of what you changed after each step."


# Manual Test Loop

Use the synthetic fixture vault in `test_vault/` for repeatable manual smoke tests.

1. Prepare test vault with current bootstrap files:
   `make testprep`
2. Start your target CLI in `test_vault/` and prompt it to run bootstrap manually as above.
3. Reset generated assistant artifacts between runs:
   `make testclean`
4. Check current fixture state:
   `make teststatus`

# TODO

- finish heartbeat/recurring items
- think through skills and how they relate to the CLIs skills
