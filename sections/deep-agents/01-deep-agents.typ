= Deep Agents
*Purpose:* Move from a single agent loop to a harness built for long-running work.

`create_agent` gives us the core loop: the model, the tools, and the messages.
That is enough for many tasks, but complex work needs more scaffolding.

#link("https://docs.langchain.com/oss/python/concepts/products")[Deep Agents] is an _agent harness_ built on top of LangChain and LangGraph.
It keeps the same tool-calling loop, but adds capabilities that make an agent reliable over longer runs:

- Task planning and a to-do list.
- A virtual filesystem for reading and writing files.
- Context management: summarization, offloading, skills, and memory.
- Delegation to subagents with isolated context.
- Human-in-the-loop approval for sensitive actions.
- An execution environment with shell and code interpreter support.

#figure(
  image("/assets/diagrams/deep-agent-harness.svg", width: 72%),
  caption: [Deep Agents adds a harness on top of the LangChain loop and the LangGraph runtime.],
)

The model is still the brain.
The harness is everything around it that lets the agent work for more than one turn.

== Running a Deep Agent
Creating one is deliberately familiar.

```python
from deepagents import create_deep_agent

agent = create_deep_agent(model=model)
result = agent.invoke({"messages": [{"role": "user", "content": "What is an LLM?"}]})
print(result["messages"][-1].text)
```

Try the same prompt with `create_agent` and with `create_deep_agent`.
The answers may look similar, but the deep agent now has filesystem tools, planning, and the rest of the harness available behind the scenes.

*Demo code:* `src/05-creating-deepagents/creating_deep_agent.py` \
*Running:* `uv run python src/05-creating-deepagents/creating_deep_agent.py`

*Further reading:* #link("https://docs.langchain.com/oss/python/deepagents/overview")[Deep Agents overview]

