from models.character import Character
from .openai_service import openai
from .db_service import get_character_images, save_character_image, get_scene_images, save_scene_image
from .imgbb_service import upload_image
from .prompt import character_image_prompt, scene_image_prompt, slide_image_prompt


async def get_character_image(character: str):
    img_in_db = get_character_images(character)
    if len(img_in_db) > 0:
        return img_in_db[0]
    else:
        res = await openai.Image.acreate(
            prompt=character_image_prompt(character),
            n=1,
            size="512x512",
            response_format="b64_json"
        )

        b64_image = res.data[0].b64_json
        permanent_url = await upload_image(b64_image)
        save_character_image(character, [permanent_url])

        return permanent_url


async def get_scene_image(scene: str):
    img_in_db = get_scene_images(scene)
    if len(img_in_db) > 0:
        return img_in_db[0]
    else:
        res = await openai.Image.acreate(
            prompt=scene_image_prompt(scene),
            n=1,
            size="512x512",
            response_format="url"
        )

        b64_image = res.data[0].url
        # permanent_url = await upload_image(b64_image)
        # save_scene_image(scene, [permanent_url])

        return b64_image


async def get_slide_image(text: str, characters: list[Character]):
    res = await openai.Image.acreate(
        prompt=slide_image_prompt(text, characters),
        n=1,
        size="512x512",
        response_format="url"
    )

    return res.data[0].url
