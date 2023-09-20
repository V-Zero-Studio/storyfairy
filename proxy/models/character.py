from pydantic import BaseModel


class Character(BaseModel):
    name: str
    images: list[str]
    description: str
