from pydantic import BaseModel


class Scene(BaseModel):
    name: str
    images: list[str]
