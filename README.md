# LangChain Workshop

Building Agentic Applications with LangChain and Deep Agents

## Requirements

- Python 3.12+
- [uv](https://docs.astral.sh/uv/)
- Git
- An API key for at least one provider: OpenAI, Anthropic, Google, or OpenRouter
- Optional: an [Ollama](https://ollama.com/) install, if you want to use local models
- Optional: a LangSmith API key, for tracing

## Setup

```bash
git clone https://github.com/kshku/LangChain-Workshop.git
cd LangChain-Workshop
uv sync
cp .env.example .env
```

The base dependencies include the OpenAI, Anthropic, and Google integrations.
If you use Ollama or OpenRouter, add the matching extra:

```bash
uv sync --extra ollama
uv sync --extra openrouter
# or install every extra
uv sync --all-extras
```

Then edit `.env` and set your provider, model, and API key:

```dotenv
MODEL_PROVIDER=openai
MODEL_NAME=gpt-4.1-mini
OPENAI_API_KEY=your-key
```

## Running the demos

The notebooks in `src/01`–`04` open in Jupyter:

```bash
uv run jupyter lab
```

The scripts in `src/05`–`09` are run directly from the repository root:

```bash
uv run python src/05-creating-deepagents/creating_deep_agent.py
uv run python src/06-mcp/mcp-demo.py
uv run python src/07-HITL/hitl.py
uv run python src/07-HITL/hitl_response.py
uv run python src/08-deepagent-environment/filesystem.py
uv run python src/08-deepagent-environment/interpreter.py
uv run python src/08-deepagent-environment/localshell.py
uv run python src/09-summarization/memory.py
uv run python src/09-summarization/skills.py
uv run python src/09-summarization/summarization.py
```

## Building the session notes

The notes are written in Typst and need Typst and Graphviz:

```bash
make          # build session.pdf and the diagram SVGs
make clean    # remove the generated PDF and SVGs
```
