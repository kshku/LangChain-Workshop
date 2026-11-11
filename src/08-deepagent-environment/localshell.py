from deepagents import create_deep_agent
from deepagents.backends.local_shell import LocalShellBackend
from pathlib import Path

from models import model

workspace_dir = Path(__file__).resolve().parent / "workspace"
workspace_dir.mkdir(exist_ok=True)

backend = LocalShellBackend(root_dir=workspace_dir, virtual_mode=True)

agent = create_deep_agent(
    model=model,
    backend=backend,
    system_prompt=(
        "You are a coding assistant. When asked to run code, write the script "
        "to a file first, then execute it. Show the output in your final answer."
    ),
)

result = agent.invoke(
    {
        "messages": [
            {
                "role": "user",
                "content": (
                    "Write a Python script that prints the first 15 Fibonacci numbers, "
                    "save it to fib.py, and run it."
                ),
            }
        ]
    }
)
print(result["messages"][-1].text)

