#!/usr/bin/env python3
"""
Medical German AI Content Populator
Uses Google Gemini to generate actual medical German content for all sections.
Requires: pip install google-generativeai
Set GEMINI_API_KEY environment variable before running.
"""

import json
import os
import re
import sys
import time
from pathlib import Path
from typing import Optional

try:
    import google.generativeai as genai
    HAS_GENAI = True
except ImportError:
    HAS_GENAI = False

CONTENT_DIR = Path(__file__).parent.parent / "content" / "sections"


def fix_json_string(text: str) -> str:
    """Fix common JSON issues from AI-generated content."""
    # Remove trailing commas before ] or }
    text = re.sub(r',\s*]', ']', text)
    text = re.sub(r',\s*}', '}', text)
    return text

# Section topics for AI generation
SECTION_TOPICS = {
    1: ("Greetings & Titles", "formal greetings, medical titles, Sie/du forms, hospital hierarchy, Oberarzt, Chefarzt, Kollegin"),
    2: ("Human Body I - External", "external anatomy: head (Kopf), face (Gesicht), eye (Auge), ear (Ohr), nose (Nase), mouth (Mund), arm, hand, finger, leg, foot, skin"),
    3: ("Human Body II - Internal", "internal organs: heart (Herz), lung (Lunge), liver (Leber), kidney (Niere), stomach (Magen), intestine (Darm), brain (Gehirn), bladder"),
    4: ("Hospital Departments", "Notaufnahme, Intensivstation, OP-Saal, Station, Ambulanz, Radiologie, Labor, Pathologie"),
    5: ("Medical Equipment", "Stethoskop, Thermometer, Blutdruckmessgerät, Spritze, Infusion, Katheter, Skalpell, Klemme"),
    6: ("Time & Scheduling", "Frühschicht, Spätschicht, Nachtdienst, Bereitschaftsdienst, Termin, Uhrzeit, Wochentage"),
    7: ("Vital Signs & Numbers", "Blutdruck, Puls, Temperatur, Atemfrequenz, Sauerstoffsättigung, Gewicht, Größe, BMI"),
    8: ("Nursing Staff", "Pflegekraft, Krankenschwester, Pfleger, Stationsleitung, Pflegedienstleitung, teamwork"),
    9: ("Patient Reception", "Aufnahme, Versicherung, Personalien, Anmeldeformular, Einweisung, Überweisungsschein"),
    10: ("Basic Symptoms", "Schmerzen, Fieber, Husten, Übelkeit, Erbrechen, Durchfall, Schwindel, Müdigkeit"),
    11: ("Pharmacy Basics", "Antibiotikum, Schmerzmittel, Dosierung, Rezept, Nebenwirkung, Wechselwirkung"),
    12: ("Emergency Calls", "Notruf, Reanimation, Notfall, Rettungswagen, Erste Hilfe, lebensbedrohlich"),
    13: ("Anamnese I - Chief Complaint", "Hauptbeschwerde, aktuelle Beschwerden, Beginn, Verlauf, Schmerzcharakter"),
    14: ("Anamnese II - History", "Familienanamnese, Sozialanamnese, Lebensstil, Beruf, Rauchen, Alkohol"),
    15: ("Anamnese III - Medical", "Vorerkrankungen, Operationen, Allergien, Medikamente, Impfungen"),
    16: ("Pain Assessment", "Schmerzskala, VAS, stechend, brennend, dumpf, krampfartig, ausstrahlend"),
    17: ("Physical Examination", "Untersuchung, Auskultation, Palpation, Perkussion, Inspektion, Reflexe"),
    18: ("Informed Consent", "Aufklärung, Einwilligung, Risiken, Komplikationen, Alternativen, Unterschrift"),
    19: ("Lab Results", "Blutbild, Hämoglobin, Leukozyten, Thrombozyten, CRP, Kreatinin, Leberwerte"),
    20: ("Radiology", "Röntgen, CT, MRT, Ultraschall, Kontrastmittel, Befund, Aufnahme"),
    21: ("Cardiovascular", "Herzinsuffizienz, Myokardinfarkt, Hypertonie, Arrhythmie, EKG, Herzkathetabler"),
    22: ("Respiratory", "Asthma, COPD, Pneumonie, Bronchitis, Dyspnoe, Beatmung, Lungenfunktion"),
    23: ("Gastrointestinal", "Gastritis, Appendizitis, Hepatitis, Kolitis, Obstipation, Ileus, Endoskopie"),
    24: ("Neurology", "Schlaganfall, Epilepsie, Parkinson, Multiple Sklerose, Lähmung, Bewusstsein, GCS"),
    25: ("Endocrinology", "Diabetes mellitus, Schilddrüse, Hyperthyreose, Hypothyreose, HbA1c, Insulin"),
    26: ("Surgery Basics", "Operation, präoperativ, postoperativ, Wundversorgung, Naht, Drainage, Verband"),
    27: ("Pediatrics", "Kinderarzt, Entwicklung, Impfkalender, Vorsorge, U-Untersuchung, Wachstum"),
    28: ("OBGYN", "Frauenheilkunde, Vorsorgeuntersuchung, Ultraschall, Routinekontrolle, Blutdruck, Beratung"),
    29: ("Psychiatry", "Depression, Angststörung, Psychose, Suizid, Therapie, Medikation, Einweisung"),
    30: ("Discharge Letter I", "Arztbrief, Diagnose, Anamnese, Befund, Therapie, Procedere, Entlassungsbrief"),
    31: ("Discharge Letter II", "Epikrise, Zusammenfassung, Empfehlung, Nachsorge, Medikationsplan"),
    32: ("Case Presentation", "Fallvorstellung, Patientenvorstellung, Visite, Anamnese, Befund, Diagnose"),
    33: ("Colleague Communication", "Übergabe, Dienst, Konsil, Rücksprache, Besprechung, Teambesprechung"),
    34: ("Documentation", "Dokumentation, Akte, Verlauf, Pflegebericht, Kurve, Unterschrift"),
    35: ("Differential Diagnosis", "Differentialdiagnose, Ausschluss, Verdacht, wahrscheinlich, unwahrscheinlich"),
    36: ("Medical Ethics", "Patientenverfügung, Vorsorgevollmacht, Therapieziel, palliativ, kurativ"),
    37: ("German Health System", "Krankenkasse, GKV, PKV, Kassenärztliche Vereinigung, Facharzt, Hausarzt"),
    38: ("Pharmacotherapy", "Arzneimittel, Wirkstoff, Indikation, Kontraindikation, Dosisanpassung"),
    39: ("Laboratory Reports", "Laborwert, Referenzbereich, erhöht, erniedrigt, pathologisch, Verlaufskontrolle"),
    40: ("SOPs", "Standardarbeitsanweisung, Protokoll, Hygiene, Qualitätsmanagement, Checkliste"),
    41: ("Breaking Bad News", "schlechte Nachricht, SPIKES, Empathie, Trauerreaktion, Unterstützung"),
    42: ("Approbation Process", "Approbation, Anerkennung, Kenntnisprüfung, Fachsprachprüfung, Berufserlaubnis"),
    43: ("Work-Life Balance", "Weiterbildung, Facharztausbildung, Arbeitszeit, Überstunden, Urlaub"),
    44: ("FSP I - Patient Talk", "Arzt-Patienten-Gespräch, Anamnese, Aufklärung, Beratung, Fragen"),
    45: ("FSP II - Documentation", "Dokumentation, Arztbrief, Befund, Verlauf, Medikamentenplan"),
    46: ("FSP III - Doctor Talk", "Arzt-Arzt-Gespräch, Konsil, Übergabe, Fallbesprechung, Empfehlung"),
    47: ("Orthopedics", "Fraktur, Gelenkersatz, Prothese, Physiotherapie, Rehabilitation, Mobilisation"),
    48: ("Urology", "Niere, Blase, Prostata, Harnwegsinfekt, Katheter, Dialyse, Nephrologie"),
    49: ("Dermatology", "Haut, Ausschlag, Ekzem, Dermatitis, Läsion, Biopsie, Wundversorgung"),
    50: ("Ophthalmology & ENT", "Auge, Ohr, Nase, Hals, Sehtest, Hörtest, Tonsillektomie, Kataraktoperation"),
    51: ("Emergency Medicine", "Notfall, Reanimation, ACLS, BLS, Schock, Trauma, Notaufnahme"),
    52: ("Intensive Care", "Intensivstation, Beatmung, Monitor, Sedierung, Vasopressor, Katecholamine"),
    53: ("Infectious Diseases", "Infektion, MRSA, Isolation, Hygiene, Antibiotika, Resistenz, Impfung"),
    54: ("Palliative Care", "Palliativ, Schmerztherapie, Symptomkontrolle, Lebensqualität, Hospiz"),
    55: ("Medical Law", "Haftung, Behandlungsfehler, Aufklärungspflicht, Dokumentationspflicht, Schweigepflicht"),
}


def get_ai_model():
    """Initialize and return Gemini model."""
    if not HAS_GENAI:
        raise ImportError("google-generativeai package not installed. Run: pip install google-generativeai")
    
    api_key = os.environ.get("GEMINI_API_KEY")
    if not api_key:
        raise ValueError("GEMINI_API_KEY environment variable not set")
    
    genai.configure(api_key=api_key)
    return genai.GenerativeModel(
        'gemini-2.0-flash',
        safety_settings=[
            {"category": "HARM_CATEGORY_HARASSMENT", "threshold": "BLOCK_NONE"},
            {"category": "HARM_CATEGORY_HATE_SPEECH", "threshold": "BLOCK_NONE"},
            {"category": "HARM_CATEGORY_SEXUALLY_EXPLICIT", "threshold": "BLOCK_NONE"},
            {"category": "HARM_CATEGORY_DANGEROUS_CONTENT", "threshold": "BLOCK_NONE"},
        ]
    )


def generate_vocabulary(model, topic: str, count: int = 30) -> list:
    """Generate vocabulary items using AI."""
    prompt = f"""As a German language professor specializing in Medical German for foreign doctors, generate exactly {count} vocabulary items for the topic: "{topic}"

For each vocabulary item, provide a JSON object with:
- germanTerm: the German medical term
- article: der/die/das (for nouns)
- plural: plural form
- pronunciation: IPA pronunciation
- category: noun/verb/adjective/phrase
- translation: object with en, bn (Bengali), hi (Hindi), ur (Urdu), tr (Turkish) translations
- exampleSentence: a realistic hospital usage example in German
- exampleTranslation: translations of the example in all 5 languages

Return ONLY a valid JSON array of {count} vocabulary objects. No markdown, no explanation."""

    response = model.generate_content(prompt)
    try:
        text = fix_json_string(response.text)
        return json.loads(text)
    except json.JSONDecodeError:
        # Try to extract JSON from response
        text = fix_json_string(response.text)
        start = text.find('[')
        end = text.rfind(']') + 1
        if start >= 0 and end > start:
            return json.loads(text[start:end])
        raise


def generate_dialogues(model, topic: str, count: int = 5) -> list:
    """Generate dialogue scenarios using AI."""
    prompt = f"""As a German language professor for Medical German, create {count} realistic hospital dialogues about: "{topic}"

Each dialogue should have 5-6 lines between doctors, nurses, and patients.

Return a JSON array where each dialogue has:
- title: object with en, bn, hi, ur, tr translations
- context: object with en, bn, hi, ur, tr translations describing the scenario
- lines: array of dialogue lines, each with:
  - speaker: name (Dr. Schmidt, Schwester Weber, Patient Müller, etc.)
  - speakerRole: Assistenzarzt/Oberarzt/Krankenschwester/Patient
  - germanText: the German dialogue line
  - translation: object with en, bn, hi, ur, tr translations

Return ONLY valid JSON array. No markdown."""

    response = model.generate_content(prompt)
    try:
        text = fix_json_string(response.text)
        return json.loads(text)
    except json.JSONDecodeError:
        text = fix_json_string(response.text)
        start = text.find('[')
        end = text.rfind(']') + 1
        if start >= 0 and end > start:
            return json.loads(text[start:end])
        raise


def generate_exercises(model, topic: str, count: int = 18) -> list:
    """Generate practice exercises using AI."""
    prompt = f"""Create {count} FSP-exam style exercises for Medical German topic: "{topic}"

Mix of types:
- 10 multipleChoice (with 4 options array)
- 5 fillBlank
- 3 translation

Each exercise needs:
- type: multipleChoice/fillBlank/translation
- question: object with de (German), en, bn, hi, ur, tr
- options: array of 4 choices (only for multipleChoice)
- correctAnswer: the correct answer string
- explanation: object with en, bn, hi, ur, tr explaining why
- points: 10

Return ONLY valid JSON array. No markdown."""

    response = model.generate_content(prompt)
    try:
        text = fix_json_string(response.text)
        return json.loads(text)
    except json.JSONDecodeError:
        text = fix_json_string(response.text)
        start = text.find('[')
        end = text.rfind(']') + 1
        if start >= 0 and end > start:
            return json.loads(text[start:end])
        raise



def generate_metadata(model, topic: str) -> dict:
    """Generate multilingual metadata and text content."""
    prompt = f"""As a German language professor for Medical German, create multilingual metadata for the section topic: "{topic}"

    Generate:
    1. Title in 5 languages (Medical German context)
    2. Description (1 sentence) in 5 languages
    3. Introduction (2 sentences explaining what will be learned) in 5 languages
    4. Grammar Focus (1-2 bullet points) in 5 languages. MUST be a single string with markdown bullets (e.g. "- Point 1\\n- Point 2")
    5. Cultural Notes (1 relevant point) in 5 languages. MUST be a single string.
    6. Summary (1 sentence wrap-up) in 5 languages. MUST be a single string.
    7. Learning Objectives (4 bullet points in English)

    Output JSON object with keys: title, description, textContent, learningObjectives.
    textContent must have keys: introduction, grammarFocus, culturalNotes, summary.
    Each lowest level value (e.g. textContent.grammarFocus.en) MUST be a STRING, not an object/array.
    learningObjectives should be a simple array of strings (English).
    
    Return ONLY valid JSON."""

    response = model.generate_content(prompt)
    try:
        text = fix_json_string(response.text)
        return json.loads(text)
    except json.JSONDecodeError:
        text = fix_json_string(response.text)
        start = text.find('{')
        end = text.rfind('}') + 1
        if start >= 0 and end > start:
            return json.loads(text[start:end])
        raise

def populate_section(model, section_num: int, existing_file: Optional[Path] = None, metadata_only: bool = False) -> dict:
    """Populate a section with AI-generated content."""
    topic_name, topic_keywords = SECTION_TOPICS[section_num]
    full_topic = f"{topic_name}: {topic_keywords}"
    
    # Load existing file to preserve structure
    if existing_file and existing_file.exists():
        with open(existing_file, 'r', encoding='utf-8') as f:
            section = json.load(f)
    else:
        section = {
            "id": f"section_{section_num:02d}",
            "phaseId": "phase1" if section_num <= 12 else ("phase2" if section_num <= 29 else "phase3"),
            "order": section_num,
            "level": "A1" if section_num <= 7 else ("A2" if section_num <= 12 else ("B1" if section_num <= 20 else ("B2" if section_num <= 29 else "C1")))
        }

    if metadata_only:
        print(f"\n  Generating metadata & text content...")
        metadata = generate_metadata(model, full_topic)
        
        # Merge metadata
        if "title" in metadata:
            # Keep German title if exists/preferred, or update if placeholder
            section["title"] = metadata["title"]
        if "description" in metadata:
            section["description"] = metadata["description"]
        if "textContent" in metadata:
            section["textContent"] = metadata["textContent"]
            # Ensure learning objectives are preserved or updated if missing
            if "learningObjectives" in metadata:
                 section["textContent"]["learningObjectives"] = metadata["learningObjectives"]
        
        return section

    print(f"\n  Generating vocabulary ({30} items)...")
    vocab = generate_vocabulary(model, full_topic, 30)
    time.sleep(1)  # Rate limiting
    
    print(f"  Generating dialogues ({5} dialogues)...")
    dialogues = generate_dialogues(model, full_topic, 5)
    time.sleep(1)
    
    print(f"  Generating exercises ({18} questions)...")
    exercises = generate_exercises(model, full_topic, 18)
    
    # Add IDs to generated content
    for i, v in enumerate(vocab, 1):
        v["id"] = f"v{section_num:02d}_{i:02d}"
    
    for i, d in enumerate(dialogues, 1):
        d["id"] = f"d{section_num:02d}_{i:02d}"
    
    for i, e in enumerate(exercises, 1):
        e["id"] = f"e{section_num:02d}_{i:02d}"
    
    section["vocabulary"] = vocab
    section["dialogues"] = dialogues
    section["exercises"] = exercises
    
    return section


def main():
    import argparse
    parser = argparse.ArgumentParser(description="Populate Medical German content with AI")
    parser.add_argument("--section", type=int, help="Specific section number to populate (1-55)")
    parser.add_argument("--all", action="store_true", help="Populate all sections")
    parser.add_argument("--metadata", action="store_true", help="Populate ONLY metadata/text content")
    parser.add_argument("--start", type=int, default=1, help="Start section for range")
    parser.add_argument("--end", type=int, default=55, help="End section for range")
    args = parser.parse_args()
    
    if not HAS_GENAI:
        print("ERROR: google-generativeai not installed")
        print("Run: pip install google-generativeai")
        sys.exit(1)
    
    if not os.environ.get("GEMINI_API_KEY"):
        print("ERROR: GEMINI_API_KEY environment variable not set")
        sys.exit(1)
    
    model = get_ai_model()
    print("Medical German AI Content Populator")
    print("=" * 50)
    
    sections_to_process = []
    if args.section:
        sections_to_process = [args.section]
    elif args.all:
        sections_to_process = list(range(args.start, args.end + 1))
    else:
        print("\nUsage:")
        print("  python ai_populate.py --section 1     # Populate section 1")
        print("  python ai_populate.py --all           # Populate all sections")
        print("  python ai_populate.py --start 1 --end 12  # Populate sections 1-12")
        return
    
    for section_num in sections_to_process:
        if section_num not in SECTION_TOPICS:
            print(f"Unknown section: {section_num}")
            continue
        
        topic_name = SECTION_TOPICS[section_num][0]
        print(f"\n[{section_num}/55] Processing: {topic_name}")
        
        # Find existing file
        files = list(CONTENT_DIR.glob(f"section_{section_num:02d}*.json"))
        existing = files[0] if files else None
        
        try:
            section = populate_section(model, section_num, existing, metadata_only=args.metadata)
            
            # Determine output filename
            if existing:
                output_file = existing
            else:
                output_file = CONTENT_DIR / f"section_{section_num:02d}.json"
            
            with open(output_file, 'w', encoding='utf-8') as f:
                json.dump(section, f, ensure_ascii=False, indent=4)
            
            print(f"  ✓ Saved: {output_file.name}")
            
            # Rate limiting between sections
            if section_num != sections_to_process[-1]:
                time.sleep(2)
                
        except Exception as e:
            print(f"  ✗ Error: {e}")
            continue
    
    print("\n" + "=" * 50)
    print("Content population complete!")


if __name__ == "__main__":
    main()
