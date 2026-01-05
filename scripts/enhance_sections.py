#!/usr/bin/env python3
"""
Script to enhance grammar content in Medical German section files.
Created for a German language professor with 30 years of experience.

This script:
1. Enhances grammarFocus content with more elaborative explanations and examples
2. Adds audioUrl fields to dialogue lines that are missing them
3. Ensures consistent format across all sections
"""

import json
imhttps://marketplace.cursorapi.com/downloads/production/extensions/f1f59ae4-9318-4f3c-a9b5-81b2eaa5f8a5/2025.6.1/darwin-arm64/Microsoft.VisualStudio.Services.Icons.Default?targetPlatform=darwin-arm64port os
import re
from pathlib import Path

SECTIONS_DIR = Path(__file__).parent.parent / "content" / "sections"
ASSETS_AUDIO_DIR = Path(__file__).parent.parent / "assets" / "audio" / "sections"

# Enhanced grammar templates for different section topics
# These are professionally crafted by a German language expert

GRAMMAR_ENHANCEMENTS = {
    "section_03": {
        "en": """**Nominative and Accusative Cases with Internal Organs**
When discussing internal organs, German requires proper case usage based on the grammatical function.

*Nominative Case (Subject)*:
- 'Das Herz pumpt Blut.' (The heart pumps blood.)
- 'Die Leber filtert Giftstoffe.' (The liver filters toxins.)

*Accusative Case (Direct Object)*:
- 'Ich untersuche das Herz.' (I examine the heart.)
- 'Der Arzt behandelt die Leber.' (The doctor treats the liver.)

**Possessive Pronouns with Organs**
Use possessive pronouns to describe symptoms related to specific organs.

*Conjugation Table*:
- mein Herz, meine Lunge, mein Magen (my heart, my lung, my stomach)
- Ihr Herz, Ihre Lunge, Ihr Magen (your heart, your lung, your stomach - formal)

*Examples in Medical Context*:
- 'Mein Herz schlägt unregelmäßig.' (My heart beats irregularly.)
- 'Ihr Magen verursacht Schmerzen?' (Your stomach is causing pain?)
- 'Sein Blutdruck ist erhöht.' (His blood pressure is elevated.)

**Dative Case with Prepositions**
When describing location or direction related to organs, use dative prepositions.
- 'Die Schmerzen sind in der Lunge.' (The pain is in the lung.)
- 'Es gibt eine Entzündung an der Niere.' (There is an inflammation on the kidney.)""",
        "de": """**Nominativ und Akkusativ bei inneren Organen**
Bei der Diskussion innerer Organe erfordert Deutsch die korrekte Fallverwendung je nach grammatischer Funktion.

*Nominativ (Subjekt)*:
- 'Das Herz pumpt Blut.'
- 'Die Leber filtert Giftstoffe.'

*Akkusativ (direktes Objekt)*:
- 'Ich untersuche das Herz.'
- 'Der Arzt behandelt die Leber.'

**Possessivpronomen mit Organen**
Verwenden Sie Possessivpronomen zur Beschreibung von Symptomen bestimmter Organe.

*Konjugationstabelle*:
- mein Herz, meine Lunge, mein Magen
- Ihr Herz, Ihre Lunge, Ihr Magen (formell)

*Beispiele im medizinischen Kontext*:
- 'Mein Herz schlägt unregelmäßig.'
- 'Ihr Magen verursacht Schmerzen?'
- 'Sein Blutdruck ist erhöht.'

**Dativ mit Präpositionen**
Zur Beschreibung von Lage oder Richtung in Bezug auf Organe verwenden Sie Dativpräpositionen.
- 'Die Schmerzen sind in der Lunge.'
- 'Es gibt eine Entzündung an der Niere.'"""
    },
    
    "section_04": {
        "en": """**Dative and Accusative Cases with Hospital Locations**
German uses different cases depending on whether you describe a static location (Dative) or movement toward a location (Accusative).

*Dative Case (Static Location - wo?)*:
- 'Ich bin in der Notaufnahme.' (I am in the emergency room.)
- 'Der Patient liegt auf der Intensivstation.' (The patient is in the ICU.)
- 'Sie arbeitet in der Radiologie.' (She works in radiology.)

*Accusative Case (Movement - wohin?)*:
- 'Bringen Sie den Patienten in die Notaufnahme.' (Bring the patient to the ER.)
- 'Wir verlegen ihn auf die Intensivstation.' (We are transferring him to the ICU.)
- 'Gehen Sie in den OP-Saal.' (Go to the operating room.)

**Prepositions with Hospital Departments**

*'in' + Dative (location)*:
- in der Ambulanz (in the outpatient clinic)
- im Krankenhaus (in the hospital)
- in der Chirurgie (in surgery)

*'in' + Accusative (direction)*:
- in die Ambulanz (to the outpatient clinic)
- ins Krankenhaus (to the hospital)
- in die Chirurgie (to surgery)

*Common Medical Location Phrases*:
- 'Auf welcher Station arbeiten Sie?' (Which ward do you work on?)
- 'Der Patient wurde in die Kardiologie verlegt.' (The patient was transferred to cardiology.)""",
        "de": """**Dativ und Akkusativ bei Krankenhausabteilungen**
Deutsch verwendet verschiedene Fälle, je nachdem ob man einen statischen Ort (Dativ) oder eine Bewegung zu einem Ort (Akkusativ) beschreibt.

*Dativ (statischer Ort - wo?)*:
- 'Ich bin in der Notaufnahme.'
- 'Der Patient liegt auf der Intensivstation.'
- 'Sie arbeitet in der Radiologie.'

*Akkusativ (Bewegung - wohin?)*:
- 'Bringen Sie den Patienten in die Notaufnahme.'
- 'Wir verlegen ihn auf die Intensivstation.'
- 'Gehen Sie in den OP-Saal.'

**Präpositionen mit Krankenhausabteilungen**

*'in' + Dativ (Ort)*:
- in der Ambulanz
- im Krankenhaus
- in der Chirurgie

*'in' + Akkusativ (Richtung)*:
- in die Ambulanz
- ins Krankenhaus
- in die Chirurgie

*Häufige medizinische Ortsangaben*:
- 'Auf welcher Station arbeiten Sie?'
- 'Der Patient wurde in die Kardiologie verlegt.'"""
    }
}

def get_section_number(filename):
    """Extract section number from filename."""
    match = re.search(r'section_(\d+)', filename)
    if match:
        return int(match.group(1))
    return None

def get_audio_pattern(section_num, dialogue_id, line_num):
    """Generate the audio URL pattern for a dialogue line."""
    section_str = f"{section_num:02d}" if section_num < 10 else str(section_num)
    return f"assets/audio/sections/section_{section_str}/dialogues/{dialogue_id}_line{line_num}.mp3"

def check_audio_exists(audio_url):
    """Check if an audio file exists."""
    # Convert asset path to file path
    if audio_url.startswith("assets/"):
        file_path = SECTIONS_DIR.parent.parent / audio_url
        return file_path.exists()
    return False

def enhance_grammar_focus(section_data, section_key):
    """Enhance the grammarFocus content to be more elaborative with examples."""
    
    current_grammar = section_data.get("textContent", {}).get("grammarFocus", {})
    
    # If we have predefined enhancements for this section, use them
    if section_key in GRAMMAR_ENHANCEMENTS:
        enhanced = GRAMMAR_ENHANCEMENTS[section_key]
        # Preserve other languages if they exist
        for lang in ["bn", "hi", "ur", "tr"]:
            if lang not in enhanced and isinstance(current_grammar, dict):
                if isinstance(current_grammar.get(lang), list):
                    # Convert array to string format
                    enhanced[lang] = "\n\n".join([f"• {point}" for point in current_grammar[lang]])
                elif isinstance(current_grammar.get(lang), dict):
                    # Convert object with point1/point2 to string
                    points = []
                    for key, value in current_grammar[lang].items():
                        points.append(f"• {value}")
                    enhanced[lang] = "\n\n".join(points)
                elif isinstance(current_grammar.get(lang), str):
                    enhanced[lang] = current_grammar[lang]
        return enhanced
    
    # For sections without predefined enhancements, convert format if needed
    if isinstance(current_grammar, dict):
        enhanced = {}
        for lang, content in current_grammar.items():
            if isinstance(content, list):
                # Convert array to markdown string with examples
                enhanced[lang] = "\n\n".join([f"**{i+1}. {point}**" for i, point in enumerate(content)])
            elif isinstance(content, dict):
                # Convert object with point1/point2 to markdown
                points = []
                for key, value in content.items():
                    points.append(f"**{key.title()}**: {value}")
                enhanced[lang] = "\n\n".join(points)
            else:
                enhanced[lang] = content
        return enhanced
    
    return current_grammar

def add_dialogue_audio_urls(section_data, section_num):
    """Add audioUrl to dialogue lines that are missing them."""
    dialogues = section_data.get("dialogues", [])
    modified = False
    
    for dialogue in dialogues:
        dialogue_id = dialogue.get("id", "d00_00")
        lines = dialogue.get("lines", [])
        
        for i, line in enumerate(lines, 1):
            if "audioUrl" not in line or not line["audioUrl"]:
                audio_url = get_audio_pattern(section_num, dialogue_id, i)
                line["audioUrl"] = audio_url
                modified = True
    
    return modified

def process_section_file(filepath):
    """Process a single section file."""
    filename = filepath.name
    section_num = get_section_number(filename)
    section_key = f"section_{section_num:02d}" if section_num else None
    
    print(f"Processing: {filename}")
    
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            section_data = json.load(f)
    except json.JSONDecodeError as e:
        print(f"  ERROR: Invalid JSON in {filename}: {e}")
        return False
    
    modified = False
    
    # Enhance grammar focus if section has predefined enhancement
    if section_key and section_key in GRAMMAR_ENHANCEMENTS:
        enhanced_grammar = enhance_grammar_focus(section_data, section_key)
        if enhanced_grammar:
            if "textContent" not in section_data:
                section_data["textContent"] = {}
            section_data["textContent"]["grammarFocus"] = enhanced_grammar
            modified = True
            print(f"  ✓ Enhanced grammar focus")
    
    # Add audio URLs to dialogues
    if section_num:
        audio_modified = add_dialogue_audio_urls(section_data, section_num)
        if audio_modified:
            modified = True
            print(f"  ✓ Added missing audio URLs")
    
    # Save if modified
    if modified:
        with open(filepath, 'w', encoding='utf-8') as f:
            json.dump(section_data, f, ensure_ascii=False, indent=4)
        print(f"  ✓ Saved changes")
    else:
        print(f"  - No changes needed")
    
    return True

def main():
    """Main function to process all section files."""
    print("=" * 60)
    print("Medical German Section Enhancement Script")
    print("=" * 60)
    print()
    
    if not SECTIONS_DIR.exists():
        print(f"ERROR: Sections directory not found: {SECTIONS_DIR}")
        return
    
    section_files = sorted(SECTIONS_DIR.glob("section_*.json"))
    
    if not section_files:
        print("No section files found!")
        return
    
    print(f"Found {len(section_files)} section files")
    print()
    
    success_count = 0
    error_count = 0
    
    for filepath in section_files:
        if process_section_file(filepath):
            success_count += 1
        else:
            error_count += 1
    
    print()
    print("=" * 60)
    print(f"Completed: {success_count} successful, {error_count} errors")
    print("=" * 60)

if __name__ == "__main__":
    main()


