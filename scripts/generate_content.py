#!/usr/bin/env python3
"""
Medical German Content Generator
Generates expanded vocabulary, dialogues, and exercises for all 55 sections.
Requirements: pip install google-generativeai
"""

import json
import os
import sys
from pathlib import Path

# Try to import Google Generative AI
try:
    import google.generativeai as genai
    HAS_GENAI = True
except ImportError:
    HAS_GENAI = False
    print("Note: google-generativeai not installed. Using template-based generation.")

CONTENT_DIR = Path(__file__).parent.parent / "content" / "sections"

# Section definitions with topics for content generation
SECTIONS = {
    "section_01": {
        "title": "Greetings & Titles",
        "titleDe": "Begrüßungen und Anreden",
        "topic": "formal greetings, medical titles, Sie/du forms, hospital hierarchy",
        "level": "A1"
    },
    "section_02": {
        "title": "Human Body I",
        "titleDe": "Der menschliche Körper I",
        "topic": "external anatomy, head, face, limbs, joints, skin",
        "level": "A1"
    },
    "section_03": {
        "title": "Human Body II",
        "titleDe": "Der menschliche Körper II",
        "topic": "internal organs, Herz, Lunge, Leber, Niere, Magen, Darm, Gehirn",
        "level": "A1"
    },
    "section_04": {
        "title": "Hospital Departments",
        "titleDe": "Krankenhausabteilungen",
        "topic": "Notaufnahme, Intensivstation, OP-Saal, Station, Ambulanz",
        "level": "A1"
    },
    "section_05": {
        "title": "Medical Equipment",
        "titleDe": "Medizinische Geräte",
        "topic": "Stethoskop, Thermometer, Blutdruckmessgerät, Spritze, Infusion",
        "level": "A1"
    },
    "section_06": {
        "title": "Time & Scheduling",
        "titleDe": "Zeit und Dienstplan",
        "topic": "Frühschicht, Spätschicht, Nachtdienst, Bereitschaftsdienst, appointments",
        "level": "A1"
    },
    "section_07": {
        "title": "Numbers & Vital Signs",
        "titleDe": "Zahlen und Vitalzeichen",
        "topic": "Blutdruck, Puls, Temperatur, Atemfrequenz, Sauerstoffsättigung",
        "level": "A1"
    },
    "section_08": {
        "title": "Nursing Staff",
        "titleDe": "Das Pflegepersonal",
        "topic": "Pflegekräfte, Krankenschwester, Pfleger, delegation, teamwork",
        "level": "A2"
    },
    "section_09": {
        "title": "Patient Reception",
        "titleDe": "Patientenaufnahme",
        "topic": "registration, personal data, insurance, admission forms",
        "level": "A2"
    },
    "section_10": {
        "title": "Basic Symptoms",
        "titleDe": "Grundlegende Symptome",
        "topic": "Schmerzen, Fieber, Husten, Übelkeit, Erbrechen, Durchfall",
        "level": "A2"
    },
    "section_11": {
        "title": "Pharmacy Basics",
        "titleDe": "Apotheken-Grundlagen",
        "topic": "Antibiotika, Schmerzmittel, dosages, prescription terms",
        "level": "A2"
    },
    "section_12": {
        "title": "Emergency Calls",
        "titleDe": "Notrufe",
        "topic": "patient condition, location, urgency level, handover",
        "level": "A2"
    },
    # Phase 2 sections (13-29)
    "section_13": {"title": "Anamnese I", "titleDe": "Anamnese I", "topic": "chief complaint, current illness history", "level": "B1"},
    "section_14": {"title": "Anamnese II", "titleDe": "Anamnese II", "topic": "family history, social history, lifestyle", "level": "B1"},
    "section_15": {"title": "Anamnese III", "titleDe": "Anamnese III", "topic": "medication history, allergies, previous surgeries", "level": "B1"},
    "section_16": {"title": "Pain Assessment", "titleDe": "Schmerzanamnese", "topic": "pain quality, intensity, VAS scale, duration, location", "level": "B1"},
    "section_17": {"title": "Physical Examination", "titleDe": "Körperliche Untersuchung", "topic": "examination instructions, patient commands", "level": "B1"},
    "section_18": {"title": "Informed Consent", "titleDe": "Aufklärung", "topic": "procedure risks, blood draw, injections, consent documentation", "level": "B1"},
    "section_19": {"title": "Lab Results", "titleDe": "Laborbefunde beschreiben", "topic": "blood counts, Hämoglobin, Leukozyten, CRP, Kreatinin", "level": "B1"},
    "section_20": {"title": "Radiology Vocabulary", "titleDe": "Radiologie-Vokabular", "topic": "Röntgen, CT, MRT, Ultraschall, imaging findings", "level": "B1"},
    "section_21": {"title": "Cardiovascular System", "titleDe": "Herz-Kreislauf-System", "topic": "Herzinsuffizienz, Myokardinfarkt, Hypertonie, ECG", "level": "B2"},
    "section_22": {"title": "Respiratory System", "titleDe": "Atmungssystem", "topic": "Asthma, COPD, Pneumonie, lung examination, oxygen therapy", "level": "B2"},
    "section_23": {"title": "Gastrointestinal System", "titleDe": "Verdauungssystem", "topic": "Gastritis, Appendizitis, Hepatitis, GI symptoms", "level": "B2"},
    "section_24": {"title": "Neurology Basics", "titleDe": "Neurologie-Grundlagen", "topic": "Schlaganfall, Epilepsie, neurological examination, GCS", "level": "B2"},
    "section_25": {"title": "Endocrinology", "titleDe": "Endokrinologie", "topic": "Diabetes mellitus, Schilddrüsenerkrankungen, HbA1c", "level": "B2"},
    "section_26": {"title": "Surgery Basics", "titleDe": "Chirurgie-Grundlagen", "topic": "pre-operative, post-operative care, wound management", "level": "B2"},
    "section_27": {"title": "Pediatrics", "titleDe": "Pädiatrie", "topic": "child communication, developmental milestones, vaccinations", "level": "B2"},
    "section_28": {"title": "OBGYN", "titleDe": "Gynäkologie/Geburtshilfe", "topic": "Schwangerschaft, gynecological exams, prenatal care", "level": "B2"},
    "section_29": {"title": "Psychiatry", "titleDe": "Psychiatrie", "topic": "Depression, Angststörung, patient rapport", "level": "B2"},
    # Phase 3 sections (30-55)
    "section_30": {"title": "Discharge Letter I", "titleDe": "Arztbrief I", "topic": "letter structure, Diagnosen, Anamnese, Befund format", "level": "C1"},
    "section_31": {"title": "Discharge Letter II", "titleDe": "Arztbrief II", "topic": "Epikrise, Zusammenfassung, medical writing style", "level": "C1"},
    "section_32": {"title": "Case Presentation", "titleDe": "Patientenvorstellung", "topic": "structured oral case presentation format", "level": "C1"},
    "section_33": {"title": "Colleague Communication", "titleDe": "Kollegiale Kommunikation", "topic": "handover protocols, Übergabe, shift change", "level": "C1"},
    "section_34": {"title": "Medical Documentation", "titleDe": "Medizinische Dokumentation", "topic": "legal charting, documentation standards, abbreviations", "level": "C1"},
    "section_35": {"title": "Differential Diagnosis", "titleDe": "Differentialdiagnose", "topic": "diagnostic possibilities, clinical reasoning language", "level": "C1"},
    "section_36": {"title": "Medical Ethics", "titleDe": "Medizinische Ethik", "topic": "end-of-life care, Patientenverfügung, ethical discussions", "level": "C1"},
    "section_37": {"title": "German Health System", "titleDe": "Deutsches Gesundheitssystem", "topic": "GKV vs PKV, KV-System, Krankenkasse", "level": "C1"},
    "section_38": {"title": "Pharmacotherapy", "titleDe": "Pharmakotherapie", "topic": "drug interactions, contraindications, prescription language", "level": "C1"},
    "section_39": {"title": "Laboratory Reports", "titleDe": "Laborbefunde", "topic": "explaining pathology results to patients", "level": "C1"},
    "section_40": {"title": "SOPs", "titleDe": "Standardarbeitsanweisungen", "topic": "Standard Operating Procedures, quality management", "level": "C1"},
    "section_41": {"title": "Breaking Bad News", "titleDe": "Schlechte Nachrichten überbringen", "topic": "SPIKES protocol, empathetic communication", "level": "C1"},
    "section_42": {"title": "Approbation Process", "titleDe": "Approbationsverfahren", "topic": "German medical license, required documents", "level": "C1"},
    "section_43": {"title": "Work-Life Balance", "titleDe": "Work-Life-Balance", "topic": "Weiterbildung, Facharzt path", "level": "C1"},
    "section_44": {"title": "FSP Simulation I", "titleDe": "FSP-Simulation I", "topic": "Arzt-Patienten-Gespräch practice", "level": "C1"},
    "section_45": {"title": "FSP Simulation II", "titleDe": "FSP-Simulation II", "topic": "Dokumentation practice", "level": "C1"},
    "section_46": {"title": "FSP Simulation III", "titleDe": "FSP-Simulation III", "topic": "Arzt-Arzt-Gespräch practice", "level": "C1"},
    "section_47": {"title": "Orthopedics", "titleDe": "Orthopädie", "topic": "Frakturen, Gelenkersatz, rehabilitation", "level": "C1"},
    "section_48": {"title": "Urology", "titleDe": "Urologie", "topic": "Nierenerkrankungen, catheterization, prostate", "level": "C1"},
    "section_49": {"title": "Dermatology", "titleDe": "Dermatologie", "topic": "skin lesions, Ausschlag, Exanthem, morphology", "level": "C1"},
    "section_50": {"title": "Ophthalmology & ENT", "titleDe": "Augenheilkunde & HNO", "topic": "sensory exams, eye and ear conditions", "level": "C1"},
    "section_51": {"title": "Emergency Medicine", "titleDe": "Notfallmedizin", "topic": "ACLS/BLS terminology, Reanimation, emergency protocols", "level": "C1"},
    "section_52": {"title": "Intensive Care", "titleDe": "Intensivmedizin (ITS)", "topic": "Beatmung, monitoring, ICU documentation", "level": "C1"},
    "section_53": {"title": "Infectious Diseases", "titleDe": "Infektionskrankheiten", "topic": "isolation protocols, MRSA, infection control", "level": "C1"},
    "section_54": {"title": "Palliative Care", "titleDe": "Palliativmedizin", "topic": "pain management, end-of-life care, comfort measures", "level": "C1"},
    "section_55": {"title": "Medical Jurisprudence", "titleDe": "Medizinrecht", "topic": "Haftung, malpractice laws, legal documentation", "level": "C1"},
}


def create_vocabulary_template(section_id: str, section_info: dict, count: int = 30) -> list:
    """Create vocabulary items template."""
    vocab = []
    for i in range(1, count + 1):
        vocab.append({
            "id": f"v{section_id[-2:]}_{i:02d}",
            "germanTerm": f"[VOCAB_{i}_GERMAN]",
            "article": "der/die/das",
            "plural": f"[VOCAB_{i}_PLURAL]",
            "pronunciation": "/[IPA]/",
            "category": "noun",
            "translation": {
                "en": f"[VOCAB_{i}_EN]",
                "bn": f"[VOCAB_{i}_BN]",
                "hi": f"[VOCAB_{i}_HI]",
                "ur": f"[VOCAB_{i}_UR]",
                "tr": f"[VOCAB_{i}_TR]"
            },
            "exampleSentence": f"[EXAMPLE_SENTENCE_{i}_DE]",
            "exampleTranslation": {
                "en": f"[EXAMPLE_{i}_EN]",
                "bn": f"[EXAMPLE_{i}_BN]",
                "hi": f"[EXAMPLE_{i}_HI]",
                "ur": f"[EXAMPLE_{i}_UR]",
                "tr": f"[EXAMPLE_{i}_TR]"
            }
        })
    return vocab


def create_dialogue_template(section_id: str, dialogue_num: int, lines_count: int = 6) -> dict:
    """Create a dialogue template."""
    lines = []
    speakers = ["Dr. Schmidt", "Patient Müller", "Schwester Weber", "Oberarzt Bauer"]
    roles = ["Assistenzarzt", "Patient", "Krankenschwester", "Oberarzt"]
    
    for i in range(lines_count):
        speaker_idx = i % len(speakers)
        lines.append({
            "speaker": speakers[speaker_idx],
            "speakerRole": roles[speaker_idx],
            "germanText": f"[DIALOGUE_{dialogue_num}_LINE_{i+1}_DE]",
            "translation": {
                "en": f"[DIALOGUE_{dialogue_num}_LINE_{i+1}_EN]",
                "bn": f"[DIALOGUE_{dialogue_num}_LINE_{i+1}_BN]",
                "hi": f"[DIALOGUE_{dialogue_num}_LINE_{i+1}_HI]",
                "ur": f"[DIALOGUE_{dialogue_num}_LINE_{i+1}_UR]",
                "tr": f"[DIALOGUE_{dialogue_num}_LINE_{i+1}_TR]"
            }
        })
    
    return {
        "id": f"d{section_id[-2:]}_{dialogue_num:02d}",
        "title": {
            "en": f"[DIALOGUE_{dialogue_num}_TITLE_EN]",
            "bn": f"[DIALOGUE_{dialogue_num}_TITLE_BN]",
            "hi": f"[DIALOGUE_{dialogue_num}_TITLE_HI]",
            "ur": f"[DIALOGUE_{dialogue_num}_TITLE_UR]",
            "tr": f"[DIALOGUE_{dialogue_num}_TITLE_TR]"
        },
        "context": {
            "en": f"[DIALOGUE_{dialogue_num}_CONTEXT_EN]",
            "bn": f"[DIALOGUE_{dialogue_num}_CONTEXT_BN]",
            "hi": f"[DIALOGUE_{dialogue_num}_CONTEXT_HI]",
            "ur": f"[DIALOGUE_{dialogue_num}_CONTEXT_UR]",
            "tr": f"[DIALOGUE_{dialogue_num}_CONTEXT_TR]"
        },
        "lines": lines
    }


def create_exercise_template(section_id: str, exercise_num: int, exercise_type: str) -> dict:
    """Create an exercise template."""
    base = {
        "id": f"e{section_id[-2:]}_{exercise_num:02d}",
        "type": exercise_type,
        "question": {
            "de": f"[QUESTION_{exercise_num}_DE]",
            "en": f"[QUESTION_{exercise_num}_EN]",
            "bn": f"[QUESTION_{exercise_num}_BN]",
            "hi": f"[QUESTION_{exercise_num}_HI]",
            "ur": f"[QUESTION_{exercise_num}_UR]",
            "tr": f"[QUESTION_{exercise_num}_TR]"
        },
        "correctAnswer": f"[ANSWER_{exercise_num}]",
        "explanation": {
            "en": f"[EXPLANATION_{exercise_num}_EN]",
            "bn": f"[EXPLANATION_{exercise_num}_BN]",
            "hi": f"[EXPLANATION_{exercise_num}_HI]",
            "ur": f"[EXPLANATION_{exercise_num}_UR]",
            "tr": f"[EXPLANATION_{exercise_num}_TR]"
        },
        "points": 10
    }
    
    if exercise_type == "multipleChoice":
        base["options"] = [
            f"[OPTION_{exercise_num}_A]",
            f"[OPTION_{exercise_num}_B]",
            f"[OPTION_{exercise_num}_C]",
            f"[OPTION_{exercise_num}_D]"
        ]
    
    return base


def generate_section_template(section_id: str, section_info: dict) -> dict:
    """Generate a complete section template."""
    num = section_id[-2:]
    
    # Create 5 dialogues with ~5 lines each = 25 dialogue pairs
    dialogues = [create_dialogue_template(section_id, i, 5) for i in range(1, 6)]
    
    # Create 18 exercises with mixed types
    exercises = []
    types = ["multipleChoice", "fillBlank", "translation", "multipleChoice", "fillBlank", "multipleChoice"]
    for i in range(1, 19):
        ex_type = types[i % len(types)]
        exercises.append(create_exercise_template(section_id, i, ex_type))
    
    return {
        "id": section_id,
        "phaseId": "phase1" if int(num) <= 12 else ("phase2" if int(num) <= 29 else "phase3"),
        "order": int(num),
        "titleDe": section_info["titleDe"],
        "title": {
            "en": section_info["title"],
            "bn": f"[{section_info['title']}_BN]",
            "hi": f"[{section_info['title']}_HI]",
            "ur": f"[{section_info['title']}_UR]",
            "tr": f"[{section_info['title']}_TR]"
        },
        "description": {
            "en": f"Learn essential {section_info['topic']} vocabulary and phrases for medical professionals.",
            "bn": "[DESCRIPTION_BN]",
            "hi": "[DESCRIPTION_HI]",
            "ur": "[DESCRIPTION_UR]",
            "tr": "[DESCRIPTION_TR]"
        },
        "level": section_info["level"],
        "estimatedMinutes": 45,
        "isPremium": int(num) > 12,
        "textContent": {
            "introduction": {
                "en": f"[INTRODUCTION about {section_info['topic']}]",
                "bn": "[INTRODUCTION_BN]",
                "hi": "[INTRODUCTION_HI]",
                "ur": "[INTRODUCTION_UR]",
                "tr": "[INTRODUCTION_TR]"
            },
            "grammarFocus": {
                "en": "[GRAMMAR_FOCUS_EN]",
                "bn": "[GRAMMAR_FOCUS_BN]",
                "hi": "[GRAMMAR_FOCUS_HI]",
                "ur": "[GRAMMAR_FOCUS_UR]",
                "tr": "[GRAMMAR_FOCUS_TR]"
            },
            "culturalNotes": {
                "en": "[CULTURAL_NOTES_EN]",
                "bn": "[CULTURAL_NOTES_BN]",
                "hi": "[CULTURAL_NOTES_HI]",
                "ur": "[CULTURAL_NOTES_UR]",
                "tr": "[CULTURAL_NOTES_TR]"
            },
            "summary": {
                "en": "[SUMMARY_EN]",
                "bn": "[SUMMARY_BN]",
                "hi": "[SUMMARY_HI]",
                "ur": "[SUMMARY_UR]",
                "tr": "[SUMMARY_TR]"
            },
            "learningObjectives": [
                f"Master key vocabulary for {section_info['topic']}",
                "Apply terms in realistic hospital dialogues",
                "Practice with FSP-style exercises",
                "Build confidence in medical German communication"
            ]
        },
        "vocabulary": create_vocabulary_template(section_id, section_info, 30),
        "dialogues": dialogues,
        "exercises": exercises,
        "media": {
            "introVideoUrl": "",
            "vocabularyVideoUrl": "",
            "dialogueVideoUrl": ""
        }
    }


def main():
    print("Medical German Content Generator")
    print("=" * 50)
    
    if len(sys.argv) > 1 and sys.argv[1] == "--template":
        # Generate template files
        print("\nGenerating template files for all 55 sections...")
        
        for section_id, section_info in SECTIONS.items():
            template = generate_section_template(section_id, section_info)
            
            # Determine filename
            num = section_id[-2:]
            if int(num) <= 18:
                # These have named files
                files = list(CONTENT_DIR.glob(f"section_{num}_*.json"))
                if files:
                    filepath = files[0]
                else:
                    filepath = CONTENT_DIR / f"{section_id}.json"
            else:
                filepath = CONTENT_DIR / f"{section_id}.json"
            
            # Write template
            with open(filepath, 'w', encoding='utf-8') as f:
                json.dump(template, f, ensure_ascii=False, indent=4)
            
            print(f"✓ Generated template: {filepath.name}")
        
        print("\n" + "=" * 50)
        print("Templates generated! Replace [PLACEHOLDER] values with actual content.")
        
    else:
        print("\nUsage:")
        print("  python generate_content.py --template    Generate template JSON files")
        print("\nNote: Templates contain placeholder values that need to be filled with actual medical German content.")


if __name__ == "__main__":
    main()
