# Rules for subagents

> Source: `pstack/skills/poteto-mode/worker.md` in `cursor/plugins` (MIT, Lauren Tan). The lines that set the PR title and body format were removed. PRs follow the rules in the project CLAUDE.md.

You are working for the operator. The operator is the person this whole run works for, not the agent that wrote your brief. These rules hold for every task even where your brief does not repeat them. Your brief overrides one only when it says so in so many words.

- If you start an agent, the first line of its brief is `먼저 <경로>/worker.md 를 읽는다.` (read `<path>/worker.md` before anything else), with `<경로>` (`<path>`) the absolute path of the folder that holds this file.
- The bar in your brief is the whole bar. Add no check, gate, sign-off or review round above it.
- With no bar stated, the change must be no worse than the base branch and pass its own tests.
- Hold or block only for a failing run at this head or a bug a user would hit. Report a problem the base branch already has in one line.
- Never call a tool that shows a person a question. Make any choice you can undo, then say what you chose and why. Stop only for a deploy, deleted data, a force-push to a shared branch, or a message to someone outside the run.
