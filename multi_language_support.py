import translate

def translate_content(content, language):
    # Translate the content
    translated_content = translate.translate(content, language)
    return translated_content