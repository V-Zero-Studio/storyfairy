from fastapi import FastAPI, Request
from fastapi.responses import HTMLResponse
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
from pydantic import BaseModel

from services.db_service import get_log_data, get_keyword_usage
from services.text_service import get_scenes, get_keywords, get_slide, get_characters_from_existing
from models.story import StoryType

app = FastAPI()
app.mount("/static", StaticFiles(directory="static"), name="static")

templates = Jinja2Templates(directory="templates")


@app.get("/", response_class=HTMLResponse)
async def root(request: Request):
    log_data = get_log_data()
    log_data = {key: log_data.get(key, []) for key in ["get_characters", "get_scenes", "get_keywords", "get_slide"]}

    keyword_usage_data = get_keyword_usage()

    return templates.TemplateResponse("chart.html", {"request": request, "log_data": log_data,
                                                     "keyword_usage_data": keyword_usage_data})


@app.get("/hello/{name}")
async def say_hello(name: str):
    return {"message": f"Hello {name}"}


class SceneListRequest(BaseModel):
    characters: list[str]


@app.post("/characters/")
async def _get_characters():
    characters = await get_characters_from_existing()
    return characters


@app.post("/scenes/")
async def _get_scene(scene_request: SceneListRequest):
    scenes = await get_scenes(scene_request.characters)
    return scenes


class KeywordRequest(BaseModel):
    story: StoryType


@app.post("/keywords/")
async def _get_keywords(request: KeywordRequest):
    keywords = await get_keywords(request.story)
    return keywords


class SlideRequest(BaseModel):
    story: StoryType
    new_keywords: list[str]


@app.post("/slide/")
async def _get_slide(request: SlideRequest):
    slide = await get_slide(request.story, request.new_keywords)
    return slide


@app.get("/filter/")
async def _filter_character_list():
    from services.db_service import filter_character_list
    filter_character_list()
    return True


@app.get("/descriptions/")
async def _update_character_descriptions():
    from services.text_service import update_character_descriptions
    await update_character_descriptions()
    return True
