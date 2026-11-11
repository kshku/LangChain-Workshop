#import "../../lib.typ": demo

= Tools
*Purpose:* Give the agent the ability to act, not just talk.

Until now, our agent could only produce text.
It could reason, but it could not _do_ anything outside the conversation.

A tool is a function that we expose to the model.
The model does not run Python by itself. We describe the tool to it -- its name, what it does, and what arguments it accepts. The model then returns a tool call, our code executes the function, and the result is sent back to the model as a tool message.
This loop is what makes an application agentic.

#figure(
  image("/assets/diagrams/agent-loop.svg", width: 100%),
  caption: [The tool-calling loop: the model requests a tool, our code runs it, and the result returns to the model.],
)

If you want to go deeper:
#link("https://docs.langchain.com/oss/python/langchain/tools")[LangChain docs -- Tools]

== Defining a tool
The `@tool` decorator from `langchain.tools` turns a normal Python function into a tool.

```python
from langchain.tools import tool

@tool
def square_root(x: float) -> float:
    """Calculate the square root of a number."""
    return x ** 0.5
```

The function name, the type hints, and the docstring are not decoration.
LangChain uses them to build the schema that the model sees.
A vague docstring gives the model a vague idea of when to use the tool, so write it as if you are explaining the tool to a new teammate.

There are a few equivalent ways to define the same tool:

- `@tool` -- uses the function name and docstring.
- `@tool("square_root")` -- overrides the tool name.
- `@tool("square_root", description="Calculate the square root of a number")` -- overrides both.

A tool can also be called directly, without an agent:

```python
tool1.invoke({"x": 49})
```

This is useful for testing the function and seeing the exact input schema.

== Giving tools to an agent
Once the tool is defined, pass it to the agent through the `tools` parameter.

```python
agent = create_agent(
    model=model,
    tools=[square_root],
    system_prompt="You are an arithmetic wizard. Use your tools to calculate the square root of any number.",
)
```

Ask the agent _What is the square root of 49?_ and then inspect the response messages.
You will see more than one message: the model first requests the tool, our code runs it, and then the model uses the result to answer.
The tool call itself is available in `response["messages"][1].tool_calls`.

This is a good moment to look at the whole message list instead of only the final answer.
Seeing the intermediate steps makes the loop much easier to understand.

#demo("src/02-tools/tools.ipynb", [Execute `uv run jupyter lab` from the repository root and open the notebook.])

