= Chat models and Providers
*Purpose:* Introduce chat models, model providers and how applications interact with them.

According to what we understood till now, we know we need an intelligent system to do the reasoning and make decisions.
We call it the brain of the Agent.
Usually we use chat models as the brain of the Agent.

_What is the difference between chat models and LLMs?_

== Chat Models
There are several Large Language Models (LLMs) available today, such as GPT, Claude, Gemini, Grok, DeepSeek, etc.
These models are trained on large amounts of data and can understand and generate human-like text.
Chat models are models designed to interact through conversational messages.

Building and training our own LLMs from scratch requires enormous amounts of data, computational resources and infrastructure.
This is generally beyond the scope of our application development.
Instead, we use already-trained models made available by different providers.

== Model Providers
A model provider is an organization or service that makes models available for applications to use.

Examples:
- OpenAI -- GPT models
- Anthropic -- Claude models
- Google -- Gemini models
- DeepSeek -- DeepSeek models
- xAI - Grok models

These providers expose APIs that allow external applications to interact with their models.
Each provider may define its own API, authentication mechanism, request format and response format.

For example, when we want to use a model:
+ We obtain an API key from the provider.
+ Our application sends a request to the provider's API.
+ The provider processes the request using the selected model.
+ The model generates a response.
+ The provider returns the response to our application.

Example API references:
- #link("https://developers.openai.com/api/reference")[OpenAI API Reference]
- #link("https://aistudio.google.com/api-reference")[Gemini API Reference]

Imagine writing an app using OpenAI's api, and later you want to shift to Gemini.
Now you need to understand Gemini's API, authentication mechanisms, request and response formats, and we may also need to rewrite code!

What if we had a common interface which deals with different models regardless of the provider API?

This is one of the problems that LangChain helps to solve.

#figure(
  image("/assets/diagrams/provider-abstraction.svg", width: 100%),
  caption: [One interface in the application, provider-specific APIs underneath.],
)

