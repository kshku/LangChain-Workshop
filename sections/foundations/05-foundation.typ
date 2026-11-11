#import "../../lib.typ": demo

= Foundation
*Purpose:* Get familiar with initializing a chat model, agent and interacting with them using LangChain.

== Project Setup
Setup `MODEL_PROVIDER`, `MODEL_NAME`, and the corresponding provider API key in the `.env` file.

An `.env.example` file is already provided. Copy it to `.env` and fill in the values for the provider you want to use.

Install the dependencies with `uv sync`, then start the notebooks with `uv run jupyter lab` from the repository root.

The `main` branch contains two shared modules:
- `settings.py` -> Loads application configuration using Pydantic Settings and loads environment variables using `python-dotenv`.
- `models.py` -> Initializes the chat model used throughout the demo code, except for the first model-connection demo.

`settings.py` is where the application reads `MODEL_PROVIDER` and `MODEL_NAME` from the environment.
Because the fields are required, the application fails early with a clear error if the `.env` file is incomplete.
`models.py` builds the shared `model` object once, so the demos do not repeat the same setup code.
It also exposes `summarization_model`, which we will use later when summarizing long conversations.

== Connecting to a chat model
The first demo connects to a model directly, without the shared modules, so we can see the raw interaction.

`init_chat_model` takes a model identifier in the form `provider:model`.
For example, `openrouter:openai/gpt-oss-120b` selects the OpenRouter provider and an OpenAI model served through it.

```python
from langchain.chat_models import init_chat_model

model = init_chat_model(model="openrouter:openai/gpt-oss-120b")
response = model.invoke("Hi, there! How are you!")
```

`response.content` contains the generated text.
`response.response_metadata` contains provider-specific details such as token usage, finish reason, or the model that actually served the request.
It is worth looking at both, because the metadata often explains _why_ a response ended the way it did.

Try different providers and different models.

For supported providers, changing the provider and model configuration is usually enough.
The corresponding LangChain integration must be installed, and LangChain handles the provider-specific interaction underneath.

You will frequently refer to the
#link("https://docs.langchain.com/")[Documentation of LangChain]
throughout the session.

Try out parameters such as `temperature`, `max_tokens`, `timeout`, and `max_retries`.
Observe how changing these parameters affects the model interaction.

#demo("src/01-foundation/connecting-to-model.ipynb", [Execute `uv run jupyter lab` from the repository root and open the notebook.])

== Creating Agent
An agent wraps the model in a loop.
It receives messages, decides whether to answer or call a tool, runs any requested tools, and repeats until it has a final answer.

```python
from langchain.agents import create_agent

agent = create_agent(model=model)
```

With no tools attached, the loop is short -- but it is the same loop that later drives all of our demos.

We invoke the agent with a list of messages:

```python
from langchain.messages import HumanMessage

response = agent.invoke(
    {"messages": [HumanMessage(content="What is the capital of the Moon?")]}
)
print(response["messages"][-1].content)
```

The response contains the whole conversation, not just the final text.
That is useful: we can inspect what the agent received, what it decided, and what it sent back.

Messages have roles. `HumanMessage` is the user, `AIMessage` is the model.
You can also pass messages as tuples such as `("human", "...")` or as dictionaries with a `role` and `content`.

A useful experiment is to pass a short history instead of a single message.
The agent will use that history as context for the next reply.

Finally, the demo shows streaming:

```python
for token, metadata in agent.stream(
    {"messages": [("human", "Tell me about Luna City")]},
    stream_mode="messages",
):
    if token.content:
        print(token.content, end="", flush=True)
```

Streaming returns tokens as they are produced instead of waiting for the complete response.
That is what makes a chat interface feel responsive.

#demo("src/01-foundation/creating-agent.ipynb", [Execute `uv run jupyter lab` from the repository root and open the notebook.])

== System Prompt
The system prompt is the instruction the model receives before the conversation starts.
It sets the role, the rules, and the expected shape of the answer.

```python
system_prompt = "You are a science fiction writer, create a capital city at the user request."

agent = create_agent(
    model=model,
    system_prompt=system_prompt,
)
```

Compare a run with the system prompt to a run without it.
The user question is the same, but the answers differ because the model is playing a different role.

A system prompt is also a good place to put examples.

In the few-shot example, we show the model a few input/output pairs:

```text
User: What is the capital of mars?
Scifi Writer: Marsialis

User: What is the capital of Venus?
Scifi Writer: Venusovia
```

The model recognizes the pattern and follows it for the new question.
This is useful when the desired behavior is easier to demonstrate than to describe.

We can make the output more consistent by describing a structure:

```text
Name: The name of capital city
Location: Where it is based
Vibe: 2-3 words to describe its vibe
Economy: Main industries
```

But a prompt is still just text.
If the application needs a predictable object, define a schema instead:

```python
from pydantic import BaseModel

class CapitalInfo(BaseModel):
    name: str
    location: str
    vibe: str
    economy: str

agent = create_agent(
    model=model,
    system_prompt=system_prompt,
    response_format=CapitalInfo,
)
```

Now the result is available as `response["structured_response"]`, and the fields are validated by Pydantic.
This is much safer than parsing free-form text in application code.

#demo("src/01-foundation/system-prompt.ipynb", [Execute `uv run jupyter lab` from the repository root and open the notebook.])

