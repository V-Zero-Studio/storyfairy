import re
import random
import time

from models.log import TimeLogType, TimeLogCategory

from config.database import CHARACTER_COLLECTION, SCENE_COLLECTION, TIME_LOG_CHARACTER_COLLECTION, \
    TIME_LOG_SCENE_COLLECTION, TIME_LOG_SLIDE_COLLECTION, KEYWORDS_USAGE_COLLECTION


def save_time_log(category: TimeLogCategory, start_time: float, end_time: float):
    time_log = TimeLogType(
        time=start_time,
        response_time=end_time - start_time
    ).model_dump()

    if category == "get_characters":
        TIME_LOG_CHARACTER_COLLECTION.insert_one(time_log)
    elif category == "get_scenes":
        TIME_LOG_SCENE_COLLECTION.insert_one(time_log)
    elif category == "get_slide":
        TIME_LOG_SLIDE_COLLECTION.insert_one(time_log)
    else:
        return False

    return True


def save_keyword_usage(used: bool):
    KEYWORDS_USAGE_COLLECTION.insert_one({
        "used": used
    })


def get_keyword_usage():
    # return two numbers: used and unused
    used = KEYWORDS_USAGE_COLLECTION.count_documents({"used": True})
    unused = KEYWORDS_USAGE_COLLECTION.count_documents({"used": False})

    return {
        "used": used,
        "unused": unused
    }


def encode_name(name: str):
    return re.sub(r'\W+', '', name.lower())


def get_character_images(character: str):
    character_name = encode_name(character)

    doc_ref = CHARACTER_COLLECTION.find_one({"name": character_name})

    if doc_ref:
        return doc_ref["images"]
    else:
        return []


def get_all_characters():
    data = CHARACTER_COLLECTION.find()

    data = [item for item in data]

    return data


def get_character_list():
    # doc_ref = db.collection(u'characters').stream()
    #
    # data = []
    #
    # for doc in doc_ref:
    #     data.append(doc.to_dict())

    data = CHARACTER_COLLECTION.find()

    data = [item for item in data]

    # filter out empty characters with no images or name
    data = [item for item in data if len(item['images']) > 0 and "name" in item and item["name"] != ""]

    # sample and random shuffle into 60 characters
    data = random.sample(data, 60)

    random.shuffle(data)

    return data


def save_character_description(character: str, description: str):
    # character_name = encode_name(character)

    # if character_name == "":
    #     return False

    CHARACTER_COLLECTION.update_one(
        {"name": character},
        {"$set": {"description": description}}
    )

    return True


def get_character_description(character: str) -> str:
    character_name = encode_name(character)

    doc_ref = CHARACTER_COLLECTION.find_one({"name": character_name})

    if doc_ref:
        return doc_ref["description"] if "description" in doc_ref else ""
    else:
        return ""


def filter_character_list():
    # remove characters with no images or name in the database
    # doc_ref = db.collection(u'characters').stream()
    #
    # for doc in doc_ref:
    #     data = doc.to_dict()
    #
    #     if "images" not in data or len(data['images']) == 0 or "name" not in data or data["name"] == "" or len(
    #             data["name"]) > 20:
    #         db.collection(u'characters').document(doc.id).delete()

    CHARACTER_COLLECTION.delete_many({
        "$or": [
            {"images": {"$exists": False}},
            {"images": {"$size": 0}},
            {"name": {"$exists": False}},
            {"name": {"$eq": ""}},
            {"name": {"$exists": True, "$not": {"$type": "string"}}},
            {"name": {"$exists": True, "$type": "string", "$gt": 20}}
        ]
    })

    return True


def get_scene_images(scene: str):
    scene_name = encode_name(scene)

    # doc_ref = db.collection(u'scenes').document(scene_name).get()
    #
    # if doc_ref.exists:
    #     return doc_ref.to_dict()['images']
    # else:
    #     return []

    doc_ref = SCENE_COLLECTION.find_one({"name": scene_name})

    if doc_ref:
        return doc_ref["images"]
    else:
        return []


def save_character_image(character: str, img: list[str]):
    character_name = encode_name(character)

    if len(img) == 0 or character_name == "":
        return False

    CHARACTER_COLLECTION.insert_one({
        "name": character_name,
        "images": img
    })


def save_scene_image(scene: str, img: list[str]):
    scene_name = encode_name(scene)

    if len(img) == 0 or scene_name == "":
        return False

    # doc_ref = db.collection(u'scenes').document(scene_name)
    #
    # doc_ref.set({
    #     u'images': img
    # })

    SCENE_COLLECTION.insert_one({
        "name": scene_name,
        "images": img
    })


def get_log_data():
    data = {
        "get_characters": [],
        "get_scenes": [],
        "get_keywords": [],
        "get_slide": []
    }

    for doc in TIME_LOG_CHARACTER_COLLECTION.find():
        # remove _id
        doc.pop("_id")
        data["get_characters"].append(doc)

    for doc in TIME_LOG_SCENE_COLLECTION.find():
        doc.pop("_id")
        data["get_scenes"].append(doc)

    for doc in TIME_LOG_SLIDE_COLLECTION.find():
        doc.pop("_id")
        data["get_slide"].append(doc)

    # filter out the data before 7 days ago

    data["get_characters"] = [item for item in data["get_characters"] if item["time"] > time.time() - 7 * 24 * 60 * 60]
    data["get_scenes"] = [item for item in data["get_scenes"] if item["time"] > time.time() - 7 * 24 * 60 * 60]
    data["get_slide"] = [item for item in data["get_slide"] if item["time"] > time.time() - 7 * 24 * 60 * 60]

    return data
