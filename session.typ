#set document(
  title: "Building Agentic Applications with LangChain and Deep Agents",
)

#set page(
  paper: "a4",
  margin: 2.5cm,
)

#set text(
  font: "EB Garamond",
  size: 12pt,
)

#set par(
  justify: true,
)

#set heading(
  numbering: "1.1.",
)

#show table.cell.where(y: 0): it => {
  set align(center)
  strong(it)
}

#show link: underline

#align(center, title())

#align(center)[
  #text(size: 10pt, style: "italic")[
    These notes follow the demo code in the `main` branch. \
    `src/01`--`04` are adapted from the LangChain Foundation course; \
    `src/05`--`09` from the Deep Agents course. \
    This is a curated subset, not a full copy of either course.
  ]
]

#include "sections/00-requirements.typ"
#include "sections/foundations/01-introduction.typ"
#include "sections/foundations/02-what-is-an-agent.typ"
#include "sections/foundations/03-chat-models-and-providers.typ"
#include "sections/foundations/04-what-is-langchain.typ"
#include "sections/foundations/05-foundation.typ"
#include "sections/foundations/06-tools.typ"
#include "sections/foundations/07-short-term-memory.typ"
#include "sections/foundations/08-managing-long-conversations.typ"
#include "sections/deep-agents/01-deep-agents.typ"
#include "sections/deep-agents/02-mcp.typ"
#include "sections/deep-agents/03-human-in-the-loop.typ"
#include "sections/deep-agents/04-environment.typ"
#include "sections/deep-agents/05-context-management.typ"
#include "sections/deep-agents/06-wrapping-up.typ"
