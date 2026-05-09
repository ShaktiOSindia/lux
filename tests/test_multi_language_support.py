import unittest
from multi_language_support import translate_content

class TestMultiLanguageSupport(unittest.TestCase):
    def test_translate_content(self):
        content = 'Hello, world!'
        language = 'es'
        translated_content = translate_content(content, language)
        self.assertIsNotNone(translated_content)