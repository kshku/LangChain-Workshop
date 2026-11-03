#set document(
  title: "Building Agentic Applications with LangChain and Deep Agents",
)

#set page(
  paper: "a4",
)

#set text(
  font: "EB Garamond",
  size: 12pt,
)

#set par(
  justify: true,
)

#set heading(
  numbering: "1.",
)

#show table.cell.where(y: 0): it => {
  set align(center)
  strong(it)
}


#align(center, title())

= Introduction
*Purpose:* Establish what students already know about LLMs and AI-powered applications, and get them thinking about how these application have evolved.

== Discussion
- What are the chatbots you used?
- How long you have been using?
- Have you noticed how these applications changed over last few years?
- What can today's AI assistants do that earlier chatbots couldn't?

#table(
  columns: (1fr, 1fr),
  table.header([Earlier chatbots], [Modern AI assistants]),
  [Primarily text-based conversations], [Multimodal interactions],
  [Respond to individual prompts], [Handle multi-step tasks],
  [Limited external capabilities], [Can interact with external tools],
  [Mostly stateless interactions], [Can maintain conversational context],
  [Generate responses], [Can take actions on behalf of users],
)

*Can AI perform actions for us instead of just answering?*

= What is an Agent?
*Purpose:* Introduce to agentic systems.

+ What is an agent? \
  Agent is a AI systems that can reason about a task, decide what actions to take, interact with its environment, and work towards achieving a specified goal.
+ What makes an application agentic? \
  Application becomes agentic when it gives the AI system the ability to deterimine and execute actions towards goal. \
  Examples:
  - Reading emails and identifying those requiring attention.
  - Writing and executing code, then examining the execution output.
  - Searching multiple sources and synthesizing information.
  - Interacting with external services through tools and APIs.

= What is LangChain
*Purpose:* Introduce to LangChain

#link("https://github.com/langchain-ai")[LangChain]
is an open-source framework and ecosystem for developing applications powered by Large Language Models (LLMs).
It provides abstractions and integrations that simplify working with models, tools, data sources and agentic workflows.

#table(
  columns: (0.3fr, 1fr),
  table.header([Component], [What it provides]),
  [LangChain], [High-level abstractions for building LLM applications and agents],
  [LangGraph], [Graph-based orchestration for stateful and long-running agent workflows],
  [Deep Agents], [A higher-level agent harness built on LangGraph],
  [LangSmith], [Observability, evaluation and deployment capabilities],
)
