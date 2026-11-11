#import "../../lib.typ": demo

= Context Management
*Purpose:* Keep a long-running agent useful as its context grows.

A deep agent may work for hundreds of steps.
The context window does not grow with it.

Context management decides what enters the model's context, what stays available outside it, and what can be forgotten.

There are four layers:

- _Input context_ -- the system prompt, memory, skills, and tool descriptions the agent starts with.
- _Compression_ -- summarization and offloading of older history and large results.
- _Isolation_ -- subagents that do heavy work in a separate context and return only a report.
- _Long-term memory_ -- persistent files that survive across threads.

== Summarization and Offload
*Purpose:* See how a deep agent keeps working when the conversation gets long.

Summarization compresses older messages.
Offloading moves large results out of the conversation and into the filesystem, leaving a reference behind.

The demo makes this visible by shrinking the model's reported context window:

```python
model.profile = {**model.profile, "max_input_tokens": 6200}
```

With a smaller window, summarization happens quickly and we can watch it in a short run.

After each turn, the demo prints two things:

- how many messages are stored in the thread.
- what the model actually saw -- either the full history, or a summary plus `messages[cutoff:]`.

The stored history is never trimmed. The agent keeps the raw conversation in state, while the model receives a compressed view.

The `_summarization_event` in state records where the cutoff happened.

#figure(
  image("/assets/diagrams/summarization.svg", width: 100%),
  caption: [The full history stays in state; the model receives a compressed view.],
)

#demo("src/09-summarization/summarization.py", raw("uv run python src/09-summarization/summarization.py"))

*Further reading:* #link("https://docs.langchain.com/oss/python/deepagents/context-engineering")[Deep Agents docs -- Context engineering]

== Skills
*Purpose:* Package specialist instructions the agent loads only when needed.

A skill is a directory containing a `SKILL.md` file.
The file starts with metadata and then contains instructions:

```markdown
---
name: qualify-lead
description: Use when the user wants to qualify a sales lead or prospect.
---

# Qualify a Lead

Use the BANT framework...
```

Skills follow the #link("https://agentskills.io/")[Agent Skills standard].
They can also include scripts, templates, and reference documents.

Deep Agents load skills with _progressive disclosure_.
At startup, the agent sees only the name and description of each skill.
When a task matches, it reads the full instructions.

This keeps the starting context small while still making detailed workflows available on demand.

```python
agent = create_deep_agent(
    model=model,
    name="Sales_Assistant",
    backend=backend,
    skills=["/skills"],
    system_prompt="You are a sales assistant.",
)
```

The demo includes two skills: `qualify-lead` and `draft-pitch`.
Ask the agent to qualify a lead, and watch it discover and load the right skill.

#demo("src/09-summarization/skills.py", raw("uv run python src/09-summarization/skills.py"))

*Further reading:* #link("https://docs.langchain.com/oss/python/deepagents/skills")[Deep Agents docs -- Skills]

== Memory
*Purpose:* Keep knowledge across conversations.

Skills are loaded on demand. Memory is always present.

#figure(
  image("/assets/diagrams/skills-memory.svg", width: 100%),
  caption: [Skills enter context when a task needs them; memory is loaded at startup.],
)

Memory uses `AGENTS.md` files.
The content is loaded at startup and stays in the system context, so the agent follows it without being reminded.

```python
agent = create_deep_agent(
    model=model,
    name="Memory_Agent",
    backend=CompositeBackend(
        default=StateBackend(),
        routes={"/memories/": StoreBackend(namespace=lambda _: default_namespace)},
    ),
    store=store,
    memory=["/memories/AGENTS.md"],
    system_prompt="You are a helpful coding assistant for this project.",
)
```

Because the file lives in a `StoreBackend`, it can persist beyond a single thread.
The demo seeds an `AGENTS.md` with project guidelines, then does two things:

- asks a question whose answer is in memory.
- asks the agent to update memory with a new team decision.

At the end, it prints the stored `AGENTS.md` so we can see the change.

That last step is important. Memory is not only read at startup; the agent can also write to it, so preferences and conventions carry forward.

#demo("src/09-summarization/memory.py", raw("uv run python src/09-summarization/memory.py"))

*Further reading:* #link("https://docs.langchain.com/oss/python/deepagents/customization#memory")[Deep Agents docs -- Memory]

