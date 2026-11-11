#import "../../lib.typ": demo

= Human-in-the-Loop
*Purpose:* Let a human approve or change an action before it happens.

An agent that can act can also make mistakes with real consequences.
It might send an email to the wrong person, delete a file, or call an API that costs money.

Human-in-the-loop gives us a checkpoint before those actions.
In Deep Agents we enable it with `interrupt_on`.

```python
agent = create_deep_agent(
    model=model,
    tools=[send_email],
    interrupt_on={"send_email": True},
    checkpointer=MemorySaver(),
)
```

The checkpointer is required: when the agent pauses, its state has to be saved so it can continue later.

The run stops before `send_email` executes.
The result contains the pending action requests, and we decide what to do with each one.

The `version="v2"` argument makes the result easier to work with: `result.value` holds the agent state and `result.interrupts` holds anything waiting for a human.
Use the same version when you resume, so the result shape stays consistent.

- _Approve_ -- run the tool call as proposed.
- _Edit_ -- change the arguments before running it.
- _Reject_ -- do not run it, and tell the agent why.

#figure(
  image("/assets/diagrams/hitl.svg", width: 100%),
  caption: [The agent pauses before the tool runs; the human decision determines what happens next.],
)

After collecting the decisions, we resume the same thread:

```python
result = agent.invoke(
    Command(resume={"decisions": decisions}),
    config=config,
    version="v2",
)
```

== Approving, editing and rejecting
Run `hitl.py` and try all three decisions.

When you edit an email, notice that the tool result quotes the edited subject and body -- not the original request.
That is why the system prompt tells the agent to trust the tool result instead of assuming the request was carried out.

#demo("src/07-HITL/hitl.py", raw("uv run python src/07-HITL/hitl.py"))

== Responding to the agent
Sometimes the agent does not need permission. It needs information that only the user can provide.

In `hitl_response.py` we add an `ask_user` tool with a fixed set of choices.
Its interrupt is configured with `allowed_decisions: ["respond"]`, so instead of approve/edit/reject, the human sends an answer back to the agent.

The email tool keeps its usual `["approve", "edit", "reject"]` decisions.
This shows that different tools can have different levels of human control in the same agent.

The demo uses `questionary` to make the choices interactive.

#demo("src/07-HITL/hitl_response.py", raw("uv run python src/07-HITL/hitl_response.py"))

*Further reading:* #link("https://docs.langchain.com/oss/python/deepagents/human-in-the-loop")[Deep Agents docs -- Human-in-the-loop]

