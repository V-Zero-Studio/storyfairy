from typing_extensions import Literal

from models.character import Character
from models.story import StoryType, SlideType
from .openai_service import openai
from .prompt import character_choices_prompt, scene_choices_prompt, beginning_sentence_prompt, \
    order_next_sentence_prompt, order_next_sentence_keywords_prompt, keyword_choices_prompt, \
    character_description_prompt
from .image_service import get_character_image, get_scene_image, get_slide_image
from .db_service import save_time_log, get_character_list, save_keyword_usage, save_character_description, \
    get_all_characters, get_character_description
from config import TOTAL_SLIDES
import asyncio
import time
from tqdm import tqdm


async def update_character_descriptions():
    character_list = get_all_characters()

    async def update_one_character(character):
        if "description" not in character:
            res = await openai.ChatCompletion.acreate(
                model="gpt-3.5-turbo",
                messages=[
                    {
                        "role": "user",
                        "content": character_description_prompt(character["name"])
                    }
                ],
            )

            description = res.choices[0].message.content
            save_character_description(character["name"], description)

    for character in tqdm(character_list):
        try:
            await update_one_character(character)
        except:
            print(f"Error when updating {character['name']}")
    return True


async def get_items(
        item_type: Literal["character", "scene"] = "character",
        character_choices: list[str] = None
):
    prompt = character_choices_prompt() if item_type == "character" else scene_choices_prompt(character_choices)
    res = await openai.ChatCompletion.acreate(
        model="gpt-3.5-turbo",
        messages=[
            {
                "role": "user",
                "content": prompt
            }
        ]
    )

    items_name = res.choices[0].message.content.split(",")

    async def get_item(item_name):
        func = get_character_image if item_type == "character" else get_scene_image
        return {
            "name": item_name.strip(),
            "image": await func(item_name.strip())
        }

    tasks = [get_item(item_name) for item_name in items_name]

    items = await asyncio.gather(*tasks)
    return items


async def get_characters_from_existing():
    start_time = time.time()
    character_list = get_character_list()
    character_list = [{"name": item["name"], "image": item["images"][0]} for item in character_list]
    end_time = time.time()

    save_time_log("get_characters", start_time, end_time)

    return character_list


async def get_scenes(character_choices: list[str]):
    start_time = time.time()
    scenes = await get_items("scene", character_choices)
    end_time = time.time()
    save_time_log("get_scenes", start_time, end_time)
    return scenes


def get_current_messages(story: StoryType, new_prompt: str) -> list[
    dict
]:
    latent = story.latent
    characters = story.characters
    scene = story.scene
    slides = story.slides

    messages = []

    for index, slide in enumerate(slides):
        if index == 0:
            messages.append({
                "role": "user",
                "content": beginning_sentence_prompt(latent, characters, scene, TOTAL_SLIDES)
            })

        else:
            messages.append({
                "role": "user",
                "content": order_next_sentence_prompt(index + 1, TOTAL_SLIDES)
            })

        messages.append({
            "role": "assistant",
            "content": slide.text
        })

    messages.append({
        "role": "user",
        "content": new_prompt
    })

    return messages


async def get_beginning(story: StoryType):
    messages = get_current_messages(story, beginning_sentence_prompt(story.latent, story.characters, story.scene,
                                                                     TOTAL_SLIDES))
    res = await openai.ChatCompletion.acreate(
        model="gpt-3.5-turbo",
        messages=messages
    )

    return res.choices[0].message.content


async def get_next(story: StoryType, new_keywords: list[str]):
    if len(new_keywords) == 0:
        new_prompt = order_next_sentence_prompt(len(story.slides) + 1, TOTAL_SLIDES)
    else:
        new_prompt = order_next_sentence_keywords_prompt(len(story.slides) + 1, TOTAL_SLIDES, new_keywords)

    messages = get_current_messages(story, new_prompt)
    res = await openai.ChatCompletion.acreate(
        model="gpt-3.5-turbo",
        messages=messages
    )

    return res.choices[0].message.content


async def get_slide(story: StoryType, new_keywords=None):
    start_time = time.time()

    if new_keywords is None:
        new_keywords = []

    if len(story.slides) == 0:
        text = await get_beginning(story)
    else:
        if len(new_keywords) == 0:
            save_keyword_usage(used=False)
        else:
            save_keyword_usage(used=True)
        text = await get_next(story, new_keywords)

    character_names = [character for character in story.characters]

    characters = [Character(name=character_name, images=[], description=get_character_description(character_name)) for
                  character_name in character_names]

    image = await get_slide_image(text, characters)

    new_slides = story.slides + [SlideType(text=text, image=image, keywords=[])]
    new_story = StoryType(title=story.title, characters=story.characters, scene=story.scene, slides=new_slides,
                          latent=story.latent)
    keywords = await get_keywords(new_story)

    end_time = time.time()

    save_time_log("get_slide", start_time, end_time)

    return SlideType(text=text, image=image, keywords=keywords)


async def get_keywords(story: StoryType):
    all_text = " ".join([slide.text for slide in story.slides])
    res = await openai.ChatCompletion.acreate(
        model="gpt-3.5-turbo",
        messages=[
            {
                "role": "user",
                "content": keyword_choices_prompt(all_text)
            }
        ]
    )

    choices = res.choices[0].message.content.split(",")
    return [choice.strip() for choice in choices]
