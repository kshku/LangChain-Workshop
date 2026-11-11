#import "../../lib.typ": demo

= Managing Long Conversations
*Purpose:* Keep conversations useful as they grow.

Every message, tool call, and tool result consumes tokens.
A model has a finite context window, and a long-running conversation will eventually reach it.

We have two common strategies:

- _Summarization_ -- compress older messages into a short summary.
- _Trimming_ -- remove messages that are no longer needed.

#figure(
  image("/assets/diagrams/managing-context.svg", width: 100%),
  caption: [Two ways to keep a conversation inside the context window.],
)

== Summarization
LangChain provides `SummarizationMiddleware`.
When the conversation crosses a trigger, the middleware asks a model to summarize the older part of the conversation, then keeps the most recent messages.

```python
from langchain.agents.middleware import SummarizationMiddleware

middleware=[
    SummarizationMiddleware(
        model=summarization_model,
        trigger=("tokens", 100),
        keep=("messages", 1),
    ),
]
```

The values `100` and `1` are intentionally small so the effect is easy to see in a demo.
In a real application they should match the model's context window and your tolerance for losing detail.

After the run, `response["messages"][0].content` contains the summary.
The original conversation has been replaced in the model's context by that summary plus the messages we chose to keep.

#demo("src/04-managing-conversation/summarization.ipynb", [Execute `uv run jupyter lab` from the repository root and open the notebook.])

== Trimming messages
Summarization is not the only option.
Sometimes we know exactly which messages are disposable.

In the demo we write a small middleware using `@before_agent`.
It runs before the agent starts, finds every `ToolMessage` in the state, and removes them with `RemoveMessage`.

```python
@before_agent
def trim_messages(state: AgentState, runtime: Runtime) -> dict[str, any] | None:
    messages = state["messages"]
    tool_messages = [m for m in messages if isinstance(m, ToolMessage)]
    return {"messages": [RemoveMessage(id=m.id) for m in tool_messages]}
```

Tool messages are often large and are usually needed only while the model is deciding what to do next.
Removing them can free a lot of context.

Be careful in a real agent: if you remove a tool result, keep the conversation coherent.
The demo removes all of them so the behavior is obvious.

#demo("src/04-managing-conversation/trim_messages.ipynb", [Execute `uv run jupyter lab` from the repository root and open the notebook.])

*Further reading:* #link("https://docs.langchain.com/oss/python/langchain/middleware")[LangChain docs -- Middleware]

