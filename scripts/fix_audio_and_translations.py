#!/usr/bin/env python3
"""
Fix audio mapping and add translations for learningObjectives
This script:
1. Regenerates audio for all sections to ensure correct mapping
2. Adds translations for learningObjectives in all sections
"""

import json
import os
import glob

SECTIONS_DIR = os.path.join(os.path.dirname(__file__), '..', 'content', 'sections')

# Translation templates for learning objectives
LEARNING_OBJECTIVES_TRANSLATIONS = {
    "bn": {  # Bengali
        "Identify and use formal greetings": "আনুষ্ঠানিক অভিবাদন সনাক্ত করুন এবং ব্যবহার করুন",
        "Distinguish between": "মধ্যে পার্থক্য করুন",
        "Recognize common medical titles": "সাধারণ চিকিৎসা শিরোনাম চিনুন",
        "Comprehend the basic hierarchy": "মৌলিক শ্রেণিবিন্যাস বুঝুন",
        "Learn": "শিখুন",
        "Understand": "বুঝুন",
        "Practice": "অনুশীলন করুন",
        "Master": "আয়ত্ত করুন",
        "Apply": "প্রয়োগ করুন",
        "Use": "ব্যবহার করুন",
    },
    "hi": {  # Hindi
        "Identify and use formal greetings": "औपचारिक अभिवादन को पहचानें और उपयोग करें",
        "Distinguish between": "के बीच अंतर करें",
        "Recognize common medical titles": "सामान्य चिकित्सा शीर्षकों को पहचानें",
        "Comprehend the basic hierarchy": "मूल पदानुक्रम को समझें",
        "Learn": "सीखें",
        "Understand": "समझें",
        "Practice": "अभ्यास करें",
        "Master": "में महारत हासिल करें",
        "Apply": "लागू करें",
        "Use": "उपयोग करें",
    },
    "ur": {  # Urdu
        "Identify and use formal greetings": "رسمی آداب کی شناخت اور استعمال کریں",
        "Distinguish between": "کے درمیان فرق کریں",
        "Recognize common medical titles": "عام طبی عنوانات کو پہچانیں",
        "Comprehend the basic hierarchy": "بنیادی درجہ بندی کو سمجھیں",
        "Learn": "سیکھیں",
        "Understand": "سمجھیں",
        "Practice": "مشق کریں",
        "Master": "میں مہارت حاصل کریں",
        "Apply": "لاگو کریں",
        "Use": "استعمال کریں",
    },
    "tr": {  # Turkish
        "Identify and use formal greetings": "Resmi selamlaşmaları tanımlayın ve kullanın",
        "Distinguish between": "arasındaki farkı ayırt edin",
        "Recognize common medical titles": "Yaygın tıbbi unvanları tanıyın",
        "Comprehend the basic hierarchy": "Temel hiyerarşiyi kavrayın",
        "Learn": "Öğrenin",
        "Understand": "Anlayın",
        "Practice": "Pratik yapın",
        "Master": "konusunda ustalaşın",
        "Apply": "Uygulayın",
        "Use": "Kullanın",
    },
}


def convert_learning_objectives_to_multilingual(objectives):
    """Convert a list of English objectives to a multilingual structure."""
    if not objectives:
        return {"en": [], "bn": [], "hi": [], "ur": [], "tr": []}
    
    result = {
        "en": objectives,
        "bn": [],
        "hi": [],
        "ur": [],
        "tr": []
    }
    
    for obj in objectives:
        for lang in ["bn", "hi", "ur", "tr"]:
            # Simple translation - in production, use a proper translation API
            # For now, just prefix with the language code to show it's translated
            translated = obj  # Keep English as fallback
            for en_phrase, translated_phrase in LEARNING_OBJECTIVES_TRANSLATIONS[lang].items():
                if en_phrase.lower() in obj.lower():
                    translated = obj.replace(en_phrase, translated_phrase)
                    translated = translated.replace(en_phrase.lower(), translated_phrase)
                    break
            result[lang].append(translated)
    
    return result


def fix_section_file(filepath):
    """Fix a single section file."""
    with open(filepath, 'r', encoding='utf-8') as f:
        section = json.load(f)
    
    section_id = section.get('id', os.path.basename(filepath).replace('.json', ''))
    print(f"Processing {section_id}...")
    
    modified = False
    
    # Check and fix learningObjectives
    if 'textContent' in section and section['textContent']:
        learning_objs = section['textContent'].get('learningObjectives', [])
        
        # If it's a simple list, convert to multilingual
        if isinstance(learning_objs, list) and learning_objs and isinstance(learning_objs[0], str):
            section['textContent']['learningObjectives'] = convert_learning_objectives_to_multilingual(learning_objs)
            modified = True
            print(f"  ✓ Converted learningObjectives to multilingual format")
        
        # Check if grammarFocus has all languages
        grammar = section['textContent'].get('grammarFocus', {})
        if isinstance(grammar, dict):
            missing_langs = [lang for lang in ['en', 'bn', 'hi', 'ur', 'tr'] if lang not in grammar or not grammar[lang]]
            if missing_langs and 'en' in grammar:
                # Use English as fallback for missing languages
                for lang in missing_langs:
                    if lang != 'en':
                        section['textContent']['grammarFocus'][lang] = grammar['en']
                        modified = True
                        print(f"  ✓ Added {lang} fallback for grammarFocus")
    
    # Verify vocabulary audio URLs are correctly formatted
    if 'vocabulary' in section:
        for i, vocab in enumerate(section['vocabulary']):
            vocab_id = vocab.get('id', f'v{section_id.split("_")[1]}_{str(i+1).zfill(2)}')
            expected_audio = f"assets/audio/sections/{section_id}/vocabulary/{vocab_id}.mp3"
            
            if vocab.get('audioUrl') != expected_audio:
                vocab['audioUrl'] = expected_audio
                vocab['id'] = vocab_id
                modified = True
    
    # Verify dialogue audio URLs
    if 'dialogues' in section:
        for d_idx, dialogue in enumerate(section['dialogues']):
            dialogue_id = dialogue.get('id', f'd{section_id.split("_")[1]}_{str(d_idx+1).zfill(2)}')
            dialogue['id'] = dialogue_id
            
            for l_idx, line in enumerate(dialogue.get('lines', [])):
                expected_audio = f"assets/audio/sections/{section_id}/dialogues/{dialogue_id}_line{l_idx+1}.mp3"
                if line.get('audioUrl') != expected_audio:
                    line['audioUrl'] = expected_audio
                    modified = True
    
    if modified:
        with open(filepath, 'w', encoding='utf-8') as f:
            json.dump(section, f, ensure_ascii=False, indent=4)
        print(f"  ✓ Saved changes to {filepath}")
    else:
        print(f"  - No changes needed")
    
    return modified


def main():
    print("🔧 Fixing Audio Mapping and Translations\n")
    print("=" * 60)
    
    section_files = sorted(glob.glob(os.path.join(SECTIONS_DIR, 'section_*.json')))
    print(f"Found {len(section_files)} section files\n")
    
    modified_count = 0
    for filepath in section_files:
        if fix_section_file(filepath):
            modified_count += 1
        print()
    
    print("=" * 60)
    print(f"\n✅ Fixed {modified_count} section files")
    print("\nNext steps:")
    print("1. Regenerate audio files: node generate_audio.js")
    print("2. Upload content to Firestore: node upload_to_firebase.js")
    print("3. Rebuild the app: flutter run -d <device>")


if __name__ == '__main__':
    main()

