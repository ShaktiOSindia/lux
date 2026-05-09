import translate_api

def translate_content(content, language):
    # Translate the content
    translated_content = translate_api.translate(content, language)
    return translated_content