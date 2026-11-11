#import "../../lib.typ": demo

= The Deep Agent Environment
*Purpose:* Understand where a deep agent acts.

An agent is only as useful as what it can touch.
The execution environment is the part of the harness that lets it take action.

Deep Agents describes four layers:

#table(
  columns: (1fr, 2fr),
  table.header([Layer], [What it gives the agent]),
  [Tools], [Custom functions, APIs, databases, and MCP servers],
  [Virtual filesystem], [Read, write, edit, search, and delete files through built-in tools],
  [Filesystem permissions], [Declarative rules for which paths may be read or written],
  [Code execution], [Shell commands through a sandbox, or JavaScript through an interpreter],
)

The filesystem is _virtual_: the agent works with paths such as `/reference/chinook-sales.md`, and a backend maps those paths to real storage.
This is a powerful abstraction, because the same agent can run against in-memory state, local disk, a database, or a remote sandbox without changing its tools.

== Filesystem Backends
*Purpose:* Choose where the agent's files actually live.

A backend implements the storage behind the virtual filesystem.
The demos use three of them:

- `StateBackend` -- stores files in the agent state. Fast and simple, but tied to the thread.
- `FilesystemBackend` -- maps paths to a real directory on disk.
- `StoreBackend` -- stores files in a LangGraph store, which can persist across threads.
- `CompositeBackend` -- sends different path prefixes to different backends.

#figure(
  image("/assets/diagrams/backends.svg", width: 100%),
  caption: [A composite backend routes each virtual path to the backend that should store it.],
)

In `filesystem.py`, most paths use the default `StateBackend`, but anything under `/reference/` is routed to a real directory:

```python
backend=CompositeBackend(
    default=StateBackend(),
    routes={
        "/reference/": FilesystemBackend(
            root_dir=str(reference_dir),
            virtual_mode=True,
        ),
    },
),
```

`virtual_mode=True` keeps the agent's view contained inside `root_dir`.
It cannot use `..` to wander out of the directory we gave it.

The demo also adds a permission rule that allows writes under `/reference/**`.
Permissions are evaluated in order, and the first matching rule wins.
If no rule matches, the operation is allowed by default -- so it is worth being explicit about what should be denied.

#demo("src/08-deepagent-environment/filesystem.py", raw("uv run python src/08-deepagent-environment/filesystem.py"))

*Further reading:*
- #link("https://docs.langchain.com/oss/python/deepagents/backends")[Deep Agents docs -- Backends]
- #link("https://docs.langchain.com/oss/python/deepagents/permissions")[Deep Agents docs -- Permissions]

== Sandboxes and LocalShell
*Purpose:* Let the agent run commands.

Some tasks need more than file edits. They need a shell.

A sandbox backend adds an `execute` tool that runs commands in an isolated environment.
`LocalShellBackend` is the local version: it runs commands on your machine, inside a chosen workspace directory.

```python
from deepagents.backends.local_shell import LocalShellBackend

backend = LocalShellBackend(root_dir=workspace_dir, virtual_mode=True)
```

In the demo, the agent writes the first 15 Fibonacci numbers to `fib.py` and then runs it.

`LocalShellBackend` is excellent for learning and for trusted local workflows.
It is not a security boundary. If you are running untrusted code, use a real sandbox provider instead.

#demo("src/08-deepagent-environment/localshell.py", raw("uv run python src/08-deepagent-environment/localshell.py"))

*Further reading:* #link("https://docs.langchain.com/oss/python/deepagents/sandboxes")[Deep Agents docs -- Sandboxes]

== Interpreter
*Purpose:* Give the agent a programmable layer for multi-step data work.

A shell is not always the right tool.
Sometimes we want a small, safe runtime where the agent can loop, transform data, and call tools programmatically.

`CodeInterpreterMiddleware` adds an `eval` tool that runs JavaScript in a QuickJS runtime.
It has no shell access, no package installation, and no filesystem or network access.

The interesting part is _Programmatic Tool Calling_.

```python
middleware=[CodeInterpreterMiddleware(ptc=["query_chinook"])]
```

With `ptc`, the tool is exposed inside the interpreter as `tools.queryChinook()`.
The agent can write one JavaScript snippet that calls the tool several times, keeps intermediate values in variables, and returns only the final result.

Why does this matter?
Consider a chain of dependent database queries: the second query needs the result of the first, and the third needs the result of the second.
Without the interpreter, every intermediate result travels back to the model as a message.
With the interpreter, those values stay in JavaScript and never enter the model's context.

That means fewer round trips and far fewer tokens.

#figure(
  image("/assets/diagrams/interpreter.svg", width: 100%),
  caption: [Programmatic tool calling keeps intermediate results inside the interpreter instead of sending them back to the model.],
)

The demo runs the same analytics task twice -- once with the interpreter and once without -- against the Chinook database.
Compare both the answers and the amount of work the model had to do.

#demo("src/08-deepagent-environment/interpreter.py", raw("uv run python src/08-deepagent-environment/interpreter.py"))

*Further reading:* #link("https://docs.langchain.com/oss/python/deepagents/interpreters")[Deep Agents docs -- Interpreters]

