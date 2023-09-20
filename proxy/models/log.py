from pydantic import BaseModel
from typing_extensions import Literal

TimeLogCategory = Literal["get_characters", "get_scenes", "get_keywords", "get_slide"]


class TimeLogType(BaseModel):
    time: float
    response_time: float


KeywordUsageCategory = Literal["used", "unused"]
