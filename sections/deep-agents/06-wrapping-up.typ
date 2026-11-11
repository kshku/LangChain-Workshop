= Wrapping Up
We started with a simple question: can AI do more than answer?

Along the way we built up the pieces of an agentic application:

- a model as the reasoning engine,
- tools that let it act,
- memory and checkpoints that let it continue a conversation,
- middleware that keeps long conversations manageable,
- a deep agent harness for long-running work,
- MCP for external tools,
- human approval for sensitive actions,
- filesystems, shells, and interpreters for execution,
- and context management through summarization, skills, and memory.

The same ideas scale from a notebook demo to a production application.
The harness does not replace the model -- it gives the model a place to work.

== Where to go next
The demos are adapted from two LangChain Academy courses:

- `src/01`--`04`: #link("https://academy.langchain.com/courses/foundation-introduction-to-langchain-python")[Introduction to LangChain -- Python]
- `src/05`--`09`: #link("https://academy.langchain.com/courses/foundation-introduction-to-deepagents")[Introduction to Deep Agents]

The courses cover more than we use here. We kept the parts that fit this session and left out topics such as multimodal messages, multi-agent systems, and deployment.
If you want to continue, the next topics are delegation and subagents, LangSmith tracing, evaluation, and deployment.

Try changing the demos. Swap the model. Add a tool. Break something and read the trace.
That is where the learning happens.
