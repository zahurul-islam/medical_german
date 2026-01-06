#!/usr/bin/env python3
"""
Translate Learning Objectives and Grammar Focus into all supported languages
Uses deep-translator (Google Translate free tier)
"""

import json
import os
import glob
import time
from deep_translator import GoogleTranslator

SECTIONS_DIR = os.path.join(os.path.dirname(__file__), '..', 'content', 'sections')

# Language codes
LANGUAGES = {
    'bn': 'bn',  # Bengali
    'hi': 'hi',  # Hindi
    'ur': 'ur',  # Urdu
    'tr': 'tr',  # Turkish
}


def translate_text(text, target_lang, max_retries=3):
    """Translate text to target language with retry logic."""
    if not text or text.strip() == '':
        return ''
    
    for attempt in range(max_retries):
        try:
            translator = GoogleTranslator(source='en', target=target_lang)
            # Split long text into chunks if needed (Google Translate limit)
            if len(text) > 4500:
                chunks = [text[i:i+4500] for i in range(0, len(text), 4500)]
                translated_chunks = []
                for chunk in chunks:
                    translated_chunks.append(translator.translate(chunk))
                    time.sleep(0.5)
                return ''.join(translated_chunks)
            else:
                result = translator.translate(text)
                return result if result else text
        except Exception as e:
            if attempt < max_retries - 1:
                time.sleep(2 ** attempt)  # Exponential backoff
            else:
                print(f"    ✗ Translation error for {target_lang}: {str(e)[:50]}")
                return text  # Return original on error
    return text


def translate_learning_objectives(objectives_en):
    """Translate learning objectives to all languages."""
    result = {
        'en': objectives_en,
        'bn': [],
        'hi': [],
        'ur': [],
        'tr': []
    }
    
    for i, obj in enumerate(objectives_en):
        for lang_key, lang_code in LANGUAGES.items():
            translated = translate_text(obj, lang_code)
            result[lang_key].append(translated)
            time.sleep(0.3)  # Rate limiting
        print(f"      Translated objective {i+1}/{len(objectives_en)}")
    
    return result


def translate_grammar_focus(grammar_en):
    """Translate grammar focus to all languages."""
    result = {'en': grammar_en}
    
    for lang_key, lang_code in LANGUAGES.items():
        print(f"      Translating to {lang_key}...")
        result[lang_key] = translate_text(grammar_en, lang_code)
        time.sleep(1)  # Rate limiting for longer texts
    
    return result


def process_section(filepath):
    """Process and translate a single section file."""
    with open(filepath, 'r', encoding='utf-8') as f:
        section = json.load(f)
    
    section_id = section.get('id', os.path.basename(filepath).replace('.json', ''))
    print(f"\n📁 Processing {section_id}...")
    
    modified = False
    
    if 'textContent' not in section or not section['textContent']:
        print("  - No textContent, skipping")
        return False
    
    # Translate Learning Objectives
    learning_objs = section['textContent'].get('learningObjectives', {})
    
    # Get English objectives
    if isinstance(learning_objs, list):
        english_objs = learning_objs
    elif isinstance(learning_objs, dict):
        english_objs = learning_objs.get('en', [])
    else:
        english_objs = []
    
    if english_objs:
        print(f"    Translating {len(english_objs)} learning objectives...")
        translated_objs = translate_learning_objectives(english_objs)
        section['textContent']['learningObjectives'] = translated_objs
        modified = True
    
    # Translate Grammar Focus
    grammar_focus = section['textContent'].get('grammarFocus', {})
    
    # Get English grammar
    if isinstance(grammar_focus, str):
        english_grammar = grammar_focus
    elif isinstance(grammar_focus, dict):
        english_grammar = grammar_focus.get('en', grammar_focus.get('de', ''))
    else:
        english_grammar = ''
    
    if english_grammar:
        print(f"    Translating grammar focus ({len(english_grammar)} chars)...")
        translated_grammar = translate_grammar_focus(english_grammar)
        section['textContent']['grammarFocus'] = translated_grammar
        modified = True
    
    if modified:
        with open(filepath, 'w', encoding='utf-8') as f:
            json.dump(section, f, ensure_ascii=False, indent=4)
        print(f"  ✓ Saved translations for {section_id}")
    
    return modified


def main():
    print("🌐 MedDeutsch Content Translator")
    print("Using Google Translate (deep-translator)")
    print("=" * 50)
    
    section_files = sorted(glob.glob(os.path.join(SECTIONS_DIR, 'section_*.json')))
    print(f"\nFound {len(section_files)} sections to translate.\n")
    
    translated_count = 0
    
    for filepath in section_files:
        try:
            if process_section(filepath):
                translated_count += 1
        except Exception as e:
            print(f"  ✗ Error: {str(e)[:80]}")
    
    print("\n" + "=" * 50)
    print(f"\n✅ Translation complete!")
    print(f"   Translated: {translated_count} sections")
    print("""
Next steps:
1. Upload content to Firestore: node upload_to_firebase.js
2. Rebuild the app: flutter run -d <device> --release
""")


if __name__ == '__main__':
    main()


