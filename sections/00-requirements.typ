= Requirements
*Purpose:* Make sure your environment is ready before we start.

#table(
  columns: (1fr, 2fr),
  table.header([Requirement], [Why you need it]),
  [Python 3.12+], [The demos use modern Python syntax and are tested on 3.12],
  [uv], [Installs dependencies and runs notebooks and scripts reproducibly],
  [Git], [Clones the repository and switches between branches],
  [An API key], [At least one provider: OpenAI, Anthropic, Google, or OpenRouter. Ollama is optional for local models],
  [Internet access], [Provider APIs and the LangChain docs MCP server],
  [Optional: LangSmith key], [Tracing and debugging, if you want to follow the agent's steps],
)

The Python dependencies are declared in `pyproject.toml` and installed with `uv sync`.
They include LangChain, LangGraph, Deep Agents, the MCP integration, QuickJS, Pydantic Settings, and Questionary.

A plain `uv sync` installs the base packages. The provider integrations live in optional extras,
so install the one that matches your model provider:

#table(
  columns: (auto, 1fr, 1fr),
  table.header([Extra], [Adds], [Install with]),
  [`ollama`], [`langchain-ollama`], [`uv sync --extra ollama`],
  [`openrouter`], [`langchain-openrouter`], [`uv sync --extra openrouter`],
)

OpenAI, Anthropic, and Google integrations are already included in the base dependencies,
so no extra is needed for those.

If you want everything (for example, to try several providers), use `uv sync --all-extras`.
Note that `uv sync --ollama` does not work -- `--ollama` is not a uv flag. The package group is
called `ollama`, but uv expects the `--extra` prefix.

```bash
git clone https://github.com/kshku/LangChain-Workshop.git
cd LangChain-Workshop
uv sync                      # base dependencies
# uv sync --extra ollama     # ...or add a provider extra
cp .env.example .env
```

Then open `.env` and fill in `MODEL_PROVIDER`, `MODEL_NAME`, and the API key for your provider.
The `chinook.db` file used by the interpreter demo is already in the repository.

To rebuild these notes you also need Typst and Graphviz, but that is not required to follow the session.

