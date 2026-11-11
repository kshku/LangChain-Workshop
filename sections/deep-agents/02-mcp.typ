= Model Context Protocol (MCP)
*Purpose:* Connect an agent to external tools through one shared protocol.

The Model Context Protocol is an open standard for exposing tools, resources, and prompts to AI applications.
Instead of writing a custom integration for every service, an application can connect to an MCP server and discover what it offers.

The LangChain documentation itself exposes an MCP server at
#link("https://docs.langchain.com/mcp")[docs.langchain.com/mcp].
Our demo connects to it, lists the available tools, and lets the agent use one of them.

```python
from langchain.mcp import MCPAdapter

async with MCPAdapter("https://docs.langchain.com/mcp") as adapter:
    tools = await adapter.list_tools()
```

Two ideas are worth noticing here.

First, _discovery_: the client asks the server which tools exist, and the server describes them.
Second, _selection_: we do not have to give the agent every tool we discover.
In the demo we filter the list down to a single allowed tool before creating the agent.

That is a useful habit. A remote server may expose many tools, and an agent should usually receive only the ones it needs for the task.

Notice also that MCP calls are asynchronous, so the demo uses `async`/`await` and `agent.ainvoke`.

#figure(
  image("/assets/diagrams/mcp.svg", width: 100%),
  caption: [MCP separates tool discovery from tool selection.],
)

*Demo code:* `src/06-mcp/mcp-demo.py` \
*Running:* `uv run python src/06-mcp/mcp-demo.py`

*Further reading:*
- #link("https://modelcontextprotocol.io/")[Model Context Protocol]
- #link("https://docs.langchain.com/oss/python/langchain/mcp")[LangChain docs -- MCP]

