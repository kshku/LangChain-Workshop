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

```bash
git clone https://github.com/kshku/LangChain-Workshop.git
cd LangChain-Workshop
uv sync
cp .env.example .env
```

Then open `.env` and fill in `MODEL_PROVIDER`, `MODEL_NAME`, and the API key for your provider.
The `chinook.db` file used by the interpreter demo is already in the repository.

To rebuild these notes you also need Typst and Graphviz, but that is not required to follow the session.

