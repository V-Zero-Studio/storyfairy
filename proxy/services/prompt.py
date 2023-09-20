from models.character import Character


def character_image_prompt(character: str):
    return f"${character}, storybook character, abstract style, no facial details, cartoon, colored pencil, detailed, " \
           f"happy mood"


def scene_image_prompt(scene: str):
    return f"${scene}, storybook scene, abstract style, no character, background, minimalistic cartoon, " \
           f"colored pencil, happy mood"


def slide_image_prompt(text: str, characters: list[Character]):
    characters_str = f"The characters are: {'; '.join([f'{character.name}: ({character.description})' for character in characters])}."
    return f"${text[:256]} no text, abstract style, minimalistic cartoon, " \
           f"colored pencil, happy mood. {characters_str}"


def character_choices_prompt():
    return "Give me 60 storybook characters of a 5 year old bedtime story. One word per character. Split by comma. " \
           "Example: 'dog, cat, mouse, queen, fairy' "


def scene_choices_prompt(
        character_choices: list[str]
):
    return f"Give me 8 places (like In a forest, Beside a lake...) for a child story with these characters: " \
           f"{', '.join(character_choices)}. Split by comma, don't include end-note, no serial number: "


def beginning_sentence_prompt(
        latent: str,
        characters: list[str],
        scene: str,
        total: int
):
    return f"Give me a 5-year-old {latent} bedtime story with these characters: {', '.join(characters)} and " \
           f"this scene: {scene}. Don't rename the characters or use pronouns. The story should have {total} sentences in total,  " \
           f"each sentence have at most 20 words. Now return the first sentence:"


def character_description_prompt(
        character: str,
):
    return (f"You should work like a description generator for bed-time storybook characters. I will give you a "
            f"character like 'dog', and you will return the detailed description (including color and shape) of this "
            f"character used for image generation. Try to keep precise within 15 words, but consistent. The return "
            f"for this example should be 'A medium-sized, golden retriever with a sleek, muscular body, soft, wavy, "
            f"caramel-colored fur, and expressive brown eyes'. Now I give you '{character}', return the description. ")


def order_next_sentence_prompt(
        order: int,
        total: int,
):
    if order == total - 3:
        return f"Return the {order}/{total} sentence. Start to generate a climax."
    elif order == total:
        return f"Return the {order}/{total} sentence. This is the last sentence. Start to generate an end-note to end " \
               f"the story."
    else:
        return f"Return the {order}/{total} sentence."


def order_next_sentence_keywords_prompt(
        order: int,
        total: int,
        keywords: list[str],
):
    return f"{order_next_sentence_prompt(order, total)} Add new elements to the story: {', '.join(keywords)}"


def keyword_choices_prompt(
        story_text: str,
):
    return (
        f"I have this story: {story_text}. What entities could be added to the story? Give me 2~3 items, each item "
        f"has no more than 3 words, split by comma, don't include end-note, no serial number. ")
