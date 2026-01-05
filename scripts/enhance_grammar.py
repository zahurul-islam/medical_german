#!/usr/bin/env python3
"""
Enhance grammar content in all section JSON files with more elaborative
explanations and practical medical German examples.

This script transforms the grammarFocus section from brief bullet points
to comprehensive grammar lessons with examples in all 6 languages.
"""

import json
import os
from pathlib import Path

CONTENT_DIR = Path(__file__).parent.parent / "content" / "sections"

# Enhanced grammar content for each section topic
# Format: section_num -> list of grammar points with examples
ENHANCED_GRAMMAR = {
    "01": {
        "en": [
            "**German Titles with Names (Declension)**\nIn German, titles precede names without articles: 'Herr Doktor Müller', 'Frau Professor Schmidt'.\n\n*Example*:\n- 'Guten Tag, Herr Oberarzt Weber.'\n- 'Frau Dr. Schulz, Ihr Patient wartet.'",
            "**Sie vs. Du (Formal/Informal Address)**\nAlways use 'Sie' with patients, superiors, and colleagues until invited to use 'du'.\n\n*Verb Conjugations*:\n- 'Sie haben' (you have, formal) vs. 'du hast' (you have, informal)\n- 'Haben Sie Schmerzen?' (formal) vs. 'Hast du Schmerzen?' (informal)\n\n*Hospital Rule*: When in doubt, always use 'Sie'."
        ],
        "de": [
            "**Deutsche Titel mit Namen (Deklination)**\nIm Deutschen stehen Titel vor Namen ohne Artikel: 'Herr Doktor Müller', 'Frau Professor Schmidt'.\n\n*Beispiel*:\n- 'Guten Tag, Herr Oberarzt Weber.'\n- 'Frau Dr. Schulz, Ihr Patient wartet.'",
            "**Sie vs. Du (Formelle/Informelle Anrede)**\nVerwenden Sie immer 'Sie' bei Patienten, Vorgesetzten und Kollegen, bis zum 'du' eingeladen wird.\n\n*Verbkonjugationen*:\n- 'Sie haben' vs. 'du hast'\n- 'Haben Sie Schmerzen?' vs. 'Hast du Schmerzen?'\n\n*Krankenhausregel*: Im Zweifel immer 'Sie' verwenden."
        ],
        "bn": [
            "**জার্মান শিরোনাম নামের সাথে (পদাবলি)**\nজার্মান ভাষায়, শিরোনামগুলি নামের আগে আসে without article: 'Herr Doktor Müller', 'Frau Professor Schmidt'।\n\n*উদাহরণ*:\n- 'Guten Tag, Herr Oberarzt Weber.'\n- 'Frau Dr. Schulz, Ihr Patient wartet.'",
            "**Sie বনাম Du (আনুষ্ঠানিক/অনানুষ্ঠানিক সম্বোধন)**\nরোগী, ঊর্ধ্বতন এবং সহকর্মীদের সাথে সর্বদা 'Sie' ব্যবহার করুন যতক্ষণ না 'du' ব্যবহারের আমন্ত্রণ পান।\n\n*ক্রিয়ার রূপ*:\n- 'Sie haben' (আপনার আছে, আনুষ্ঠানিক) vs. 'du hast' (তোমার আছে, অনানুষ্ঠানিক)\n\n*হাসপাতালের নিয়ম*: সন্দেহ হলে সর্বদা 'Sie' ব্যবহার করুন।"
        ],
        "hi": [
            "**जर्मन शीर्षक नामों के साथ (विभक्ति)**\nजर्मन में, शीर्षक नामों से पहले आते हैं बिना article के: 'Herr Doktor Müller', 'Frau Professor Schmidt'।\n\n*उदाहरण*:\n- 'Guten Tag, Herr Oberarzt Weber.'\n- 'Frau Dr. Schulz, Ihr Patient wartet.'",
            "**Sie बनाम Du (औपचारिक/अनौपचारिक संबोधन)**\nरोगियों, वरिष्ठों और सहकर्मियों के साथ हमेशा 'Sie' का उपयोग करें जब तक 'du' का निमंत्रण न मिले।\n\n*क्रिया रूप*:\n- 'Sie haben' (आपके पास है, औपचारिक) vs. 'du hast' (तुम्हारे पास है, अनौपचारिक)\n\n*अस्पताल नियम*: संदेह होने पर हमेशा 'Sie' का उपयोग करें।"
        ],
        "ur": [
            "**جرمن القاب ناموں کے ساتھ (حالت)**\nجرمن میں، القاب ناموں سے پہلے آتے ہیں بغیر article کے: 'Herr Doktor Müller', 'Frau Professor Schmidt'۔\n\n*مثال*:\n- 'Guten Tag, Herr Oberarzt Weber.'\n- 'Frau Dr. Schulz, Ihr Patient wartet.'",
            "**Sie بمقابلہ Du (رسمی/غیر رسمی خطاب)**\nمریضوں، اعلیٰ عہدیداروں اور ساتھیوں کے ساتھ ہمیشہ 'Sie' استعمال کریں جب تک 'du' کی دعوت نہ ملے۔\n\n*فعل کی تصریف*:\n- 'Sie haben' (آپ کے پاس ہے، رسمی) vs. 'du hast' (تیرے پاس ہے، غیر رسمی)\n\n*ہسپتال کا اصول*: شک ہو تو ہمیشہ 'Sie' استعمال کریں۔"
        ],
        "tr": [
            "**Almanca Unvanlar İsimlerle (Çekim)**\nAlmancada unvanlar, artikelsiz olarak isimlerden önce gelir: 'Herr Doktor Müller', 'Frau Professor Schmidt'.\n\n*Örnek*:\n- 'Guten Tag, Herr Oberarzt Weber.'\n- 'Frau Dr. Schulz, Ihr Patient wartet.'",
            "**Sie / Du (Resmi/Gayri Resmi Hitap)**\nHastalar, üstler ve meslektaşlarla 'du' davet edilene kadar her zaman 'Sie' kullanın.\n\n*Fiil Çekimleri*:\n- 'Sie haben' (sizin var, resmi) vs. 'du hast' (senin var, gayri resmi)\n\n*Hastane Kuralı*: Şüphe durumunda her zaman 'Sie' kullanın."
        ]
    },
    "02": {
        "en": [
            "**Definite Articles with Body Parts**\nAll German nouns have grammatical gender. Body parts use: der (masculine), die (feminine), das (neuter).\n\n*Examples*:\n- der Kopf (the head), die Hand (the hand), das Auge (the eye)\n- 'Der Patient hat Schmerzen im Kopf.' (The patient has pain in the head.)",
            "**Accusative Case with Body Parts**\nWhen body parts are direct objects, use accusative articles.\n\n*Nominative → Accusative*:\n- der → den: 'Ich untersuche den Arm.' (I examine the arm.)\n- die → die: 'Bitte heben Sie die Hand.' (Please raise the hand.)\n- das → das: 'Öffnen Sie das Auge.' (Open the eye.)"
        ],
        "de": [
            "**Bestimmte Artikel mit Körperteilen**\nAlle deutschen Nomen haben ein grammatisches Geschlecht. Körperteile verwenden: der (maskulin), die (feminin), das (neutral).\n\n*Beispiele*:\n- der Kopf, die Hand, das Auge\n- 'Der Patient hat Schmerzen im Kopf.'",
            "**Akkusativ mit Körperteilen**\nWenn Körperteile direkte Objekte sind, verwenden Sie Akkusativartikel.\n\n*Nominativ → Akkusativ*:\n- der → den: 'Ich untersuche den Arm.'\n- die → die: 'Bitte heben Sie die Hand.'\n- das → das: 'Öffnen Sie das Auge.'"
        ],
        "bn": [
            "**শরীরের অঙ্গের সাথে নির্দিষ্ট আর্টিকেল**\nসব জার্মান বিশেষ্যের ব্যাকরণগত লিঙ্গ আছে। শরীরের অঙ্গ ব্যবহার করে: der (পুরুষবাচক), die (স্ত্রীবাচক), das (ক্লীববাচক)।\n\n*উদাহরণ*:\n- der Kopf (মাথা), die Hand (হাত), das Auge (চোখ)\n- 'Der Patient hat Schmerzen im Kopf.' (রোগীর মাথায় ব্যথা আছে।)",
            "**শরীরের অঙ্গের সাথে কর্মকারক**\nযখন শরীরের অঙ্গ সরাসরি object হয়, কর্মকারক article ব্যবহার করুন।\n\n*Nominativ → Akkusativ*:\n- der → den: 'Ich untersuche den Arm.' (আমি বাহু পরীক্ষা করছি।)"
        ],
        "hi": [
            "**शरीर के अंगों के साथ निश्चित आर्टिकल**\nसभी जर्मन संज्ञाओं में व्याकरणिक लिंग होता है। शरीर के अंगों में उपयोग: der (पुल्लिंग), die (स्त्रीलिंग), das (नपुंसक)।\n\n*उदाहरण*:\n- der Kopf (सिर), die Hand (हाथ), das Auge (आँख)\n- 'Der Patient hat Schmerzen im Kopf.' (मरीज के सिर में दर्द है।)",
            "**शरीर के अंगों के साथ कर्म कारक**\nजब शरीर के अंग प्रत्यक्ष object हों, कर्म कारक article का उपयोग करें।\n\n*कर्ता → कर्म*:\n- der → den: 'Ich untersuche den Arm.' (मैं बांह की जांच करता हूं।)"
        ],
        "ur": [
            "**جسم کے اعضاء کے ساتھ معینہ آرٹیکل**\nتمام جرمن اسماء کی گرامر جنس ہوتی ہے۔ جسم کے اعضاء میں استعمال: der (مذکر)، die (مؤنث)، das (غیر جنس)۔\n\n*مثالیں*:\n- der Kopf (سر)، die Hand (ہاتھ)، das Auge (آنکھ)\n- 'Der Patient hat Schmerzen im Kopf.' (مریض کے سر میں درد ہے۔)",
            "**جسم کے اعضاء کے ساتھ مفعولی حالت**\nجب جسم کے اعضاء براہ راست مفعول ہوں، مفعولی آرٹیکل استعمال کریں۔\n\n*فاعلی → مفعولی*:\n- der → den: 'Ich untersuche den Arm.' (میں بازو کا معائنہ کرتا ہوں۔)"
        ],
        "tr": [
            "**Vücut Parçalarıyla Belirli Artikeller**\nTüm Almanca isimlerin gramer cinsiyeti vardır. Vücut parçaları kullanır: der (eril), die (dişil), das (nötr).\n\n*Örnekler*:\n- der Kopf (kafa), die Hand (el), das Auge (göz)\n- 'Der Patient hat Schmerzen im Kopf.' (Hastanın başında ağrı var.)",
            "**Vücut Parçalarıyla Belirtme Hali**\nVücut parçaları doğrudan nesne olduğunda, belirtme hali artikelleri kullanın.\n\n*Yalın → Belirtme*:\n- der → den: 'Ich untersuche den Arm.' (Kolu muayene ediyorum.)"
        ]
    }
    # More sections will be auto-generated with contextual grammar
}

def generate_enhanced_grammar(section_num: str, topic: str) -> dict:
    """Generate enhanced grammar for sections not in ENHANCED_GRAMMAR."""
    # Default comprehensive grammar structure for all sections
    default_grammar = {
        lang: [
            f"**Grammar Point 1**: Detailed explanation with medical context for {topic}.\n\n*Example*:\n- German sentence example\n- Translation",
            f"**Grammar Point 2**: Second grammar concept applicable to {topic}.\n\n*Example*:\n- Practical hospital dialogue example"
        ]
        for lang in ["en", "de", "bn", "hi", "ur", "tr"]
    }
    return ENHANCED_GRAMMAR.get(section_num, default_grammar)


def enhance_grammar_in_section(json_path: Path) -> bool:
    """Enhance the grammarFocus section with more elaborative content."""
    
    filename = json_path.stem
    parts = filename.split('_')
    section_num = parts[1]
    
    # Skip if already enhanced or special section
    if 'a' in section_num:
        print(f"  Skipping {filename} (special section)")
        return False
    
    with open(json_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    # Get or generate enhanced grammar
    topic = data.get('titleDe', 'Medical German')
    enhanced = generate_enhanced_grammar(section_num, topic)
    
    # Check if grammar needs enhancement
    text_content = data.get('textContent', {})
    current_grammar = text_content.get('grammarFocus', {})
    
    # Only update if we have predefined content for this section (01, 02)
    if section_num not in ENHANCED_GRAMMAR:
        print(f"  - {filename} (no enhanced grammar defined, skipping)")
        return False
    
    # Convert list of points to combined string format
    new_grammar = {}
    for lang in ["en", "de", "bn", "hi", "ur", "tr"]:
        points = enhanced.get(lang, [])
        if points:
            new_grammar[lang] = "\n\n".join(points)
        else:
            new_grammar[lang] = current_grammar.get(lang, {})
    
    data['textContent']['grammarFocus'] = new_grammar
    
    with open(json_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=4)
    
    print(f"  ✓ Enhanced {filename}")
    return True


def main():
    print("Enhancing grammar content in section files...")
    print("=" * 60)
    
    json_files = sorted(CONTENT_DIR.glob("section_*.json"))
    enhanced_count = 0
    
    for json_path in json_files:
        if enhance_grammar_in_section(json_path):
            enhanced_count += 1
    
    print("=" * 60)
    print(f"Enhanced {enhanced_count} section files.")
    print("\nNote: To enhance more sections, add grammar content to ENHANCED_GRAMMAR dict.")


if __name__ == "__main__":
    main()
