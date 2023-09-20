from typing import Optional

from pydantic import BaseModel


class SlideType(BaseModel):
    text: str
    image: str
    keywords: list[str]


class StoryType(BaseModel):
    title: str
    characters: list[str]
    scene: str
    slides: list[SlideType]
    latent: Optional[str]
