from pydantic_settings import BaseSettings, SettingsConfigDict
from dotenv import load_dotenv

from pathlib import Path

root = Path(__file__).resolve().parent
env_file = root / ".env"

load_dotenv(env_file)

class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=root / ".env",
        extra='ignore',
        env_prefix='',
    )

    model_provider: str
    model_name: str


settings = Settings()
