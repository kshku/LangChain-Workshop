= Short-term Memory
*Purpose:* Give an agent memory within a conversation.

Every call to an agent starts from the messages we pass in.
If we do not store anything between calls, the agent has no idea what happened before.

== No memory
Predict what will happen in `no-memory.ipynb`.

We tell the agent our name and favourite colour in one call.
Then, in a separate call, we ask what our favourite colour is.
Since the second call only contains the new question, the agent has nothing to remember.
Any answer it gives is a guess, not a memory.

*Demo code:* `src/03-short-term-memory/no-memory.ipynb` \
*Running:* Execute `uv run jupyter lab` from the repository root and open the notebook.

== Threads and checkpointers
To remember a conversation, we need two things:

- A _thread_ -- an identifier for the conversation, passed as `thread_id`.
- A _checkpointer_ -- the component that saves the agent state after every step.

With both in place, each new call loads the saved state for that thread before continuing.

```python
from langgraph.checkpoint.memory import InMemorySaver

agent = create_agent(
    model,
    checkpointer=InMemorySaver(),
)

config = {"configurable": {"thread_id": "1"}}
```

Now the first call can introduce us, and the second call -- using the same config -- can answer questions about what we said earlier.

#figure(
  image("/assets/diagrams/memory-threads.svg", width: 100%),
  caption: [The checkpointer keeps a separate state for each `thread_id`.],
)

`InMemorySaver` stores everything in memory, so it disappears when the process ends.
That is perfect for a demo.
For a real application, use a persistent checkpointer such as `SqliteSaver` or `PostgresSaver`.

Try changing the `thread_id` and observe how the agent's memory changes.

*Demo code:* `src/03-short-term-memory/checkpointer.ipynb` \
*Running:* Execute `uv run jupyter lab` from the repository root and open the notebook.

*Further reading:* #link("https://docs.langchain.com/oss/python/langchain/short-term-memory")[LangChain docs -- Short-term memory]

