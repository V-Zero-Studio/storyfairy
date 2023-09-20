import os
import requests

IMGBB_URL = "https://api.imgbb.com/1/upload"
IMGBB_KEY = os.getenv("IMGBB_KEY")


async def upload_image(
        base64_image: str,
):
    response = requests.post(
        IMGBB_URL,
        data={
            "key": IMGBB_KEY,
            "image": base64_image
        }
    )
    return response.json()["data"]["url"]
