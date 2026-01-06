#!/usr/bin/env python3
"""
Medical German Section Enhancement Script - PART 2
Enhances sections 21-55 with comprehensive grammar content.

This script specifically targets the B1-B2 (Phase 2) and C1 (Phase 3) sections
with detailed grammar explanations and examples.
"""

import json
from pathlib import Path

SECTIONS_DIR = Path(__file__).parent.parent / "content" / "sections"

# Complete grammar enhancements for sections 21-55
GRAMMAR_ENHANCEMENTS = {
    "section_21": {
        "en": """**Genitive Case and Compound Nouns in Cardiovascular Medicine**

The genitive case and compound noun formation are essential for discussing cardiovascular conditions.

*Genitive Case with Causal Prepositions:*
| Preposition | Meaning | Example |
|-------------|---------|---------|
| wegen | because of | wegen der Herzinsuffizienz |
| aufgrund | due to | aufgrund des hohen Blutdrucks |
| infolge | as a result of | infolge eines Myokardinfarkts |

*Examples in Cardiology:*
- 'Wegen der Arrhythmie wurde ein EKG durchgeführt.' (Due to the arrhythmia, an ECG was performed.)
- 'Aufgrund des erhöhten Troponins besteht Verdacht auf Herzinfarkt.' (Due to elevated troponin, myocardial infarction is suspected.)

**Compound Noun Formation in Cardiology:**
German medical terms often combine multiple nouns:
- Herz + Muskel + Entzündung = Herzmuskelentzündung (myocarditis)
- Herz + Katheter = Herzkatheter (cardiac catheter)
- Blut + Druck + Messung = Blutdruckmessung (blood pressure measurement)

*Rule:* The last noun determines gender and plural form:
- die Herzmuskelentzündung (feminine, from 'die Entzündung')
- der Herzkatheter (masculine, from 'der Katheter')

**Verb-Noun Collocations in Cardiology:**
- 'einen Herzinfarkt erleiden' (to suffer a heart attack)
- 'den Blutdruck messen' (to measure blood pressure)
- 'ein EKG anlegen' (to perform an ECG)
- 'einen Stent einsetzen' (to insert a stent)""",

        "de": """**Genitiv und zusammengesetzte Nomen in der Kardiologie**

Der Genitiv und die Bildung zusammengesetzter Nomen sind für die Diskussion kardiovaskulärer Erkrankungen unerlässlich.

*Genitiv mit kausalen Präpositionen:*
| Präposition | Bedeutung | Beispiel |
|-------------|-----------|----------|
| wegen | wegen | wegen der Herzinsuffizienz |
| aufgrund | aufgrund | aufgrund des hohen Blutdrucks |
| infolge | infolge | infolge eines Myokardinfarkts |

*Beispiele in der Kardiologie:*
- 'Wegen der Arrhythmie wurde ein EKG durchgeführt.'
- 'Aufgrund des erhöhten Troponins besteht Verdacht auf Herzinfarkt.'

**Bildung zusammengesetzter Nomen in der Kardiologie:**
- Herz + Muskel + Entzündung = Herzmuskelentzündung
- Herz + Katheter = Herzkatheter
- Blut + Druck + Messung = Blutdruckmessung

*Regel:* Das letzte Nomen bestimmt Geschlecht und Pluralform.

**Verb-Nomen-Kollokationen in der Kardiologie:**
- 'einen Herzinfarkt erleiden'
- 'den Blutdruck messen'
- 'ein EKG anlegen'
- 'einen Stent einsetzen'"""
    },

    "section_22": {
        "en": """**Respiratory System: Medical Passive and Technical Vocabulary**

The passive voice is essential for describing respiratory procedures and diagnoses.

*Passive Voice Construction in Medical Context:*
| Active | Passive | Example |
|--------|---------|---------|
| Der Arzt röntgt die Lunge. | Die Lunge wird geröntgt. | The lung is being X-rayed. |
| Man führt eine Bronchoskopie durch. | Eine Bronchoskopie wird durchgeführt. | A bronchoscopy is performed. |

*Common Respiratory Passive Phrases:*
- 'Die Lunge wurde abgehört.' (The lung was auscultated.)
- 'Ein Lungenfunktionstest wird durchgeführt.' (A pulmonary function test is being performed.)
- 'Die Diagnose COPD wurde gestellt.' (The diagnosis of COPD was made.)

**Describing Breathing Patterns:**
Use adjective + noun constructions:
- 'tiefe Atmung' (deep breathing)
- 'flache Atmung' (shallow breathing)
- 'beschleunigte Atmung' (accelerated breathing)
- 'erschwerte Atmung' (labored breathing)

*Prepositions with Respiratory Organs:*
- 'in der Lunge' (in the lung) - location
- 'in die Lunge' (into the lung) - direction
- 'aus der Lunge' (from the lung) - origin

**Compound Medical Terms:**
- Lungen + Entzündung = Lungenentzündung (pneumonia)
- Atem + Not = Atemnot (dyspnea)
- Bronchial + Asthma = Bronchialasthma (bronchial asthma)""",

        "de": """**Atmungssystem: Medizinisches Passiv und Fachvokabular**

Das Passiv ist für die Beschreibung von Atemwegsverfahren und Diagnosen unerlässlich.

*Passivkonstruktion im medizinischen Kontext:*
| Aktiv | Passiv | Beispiel |
|-------|--------|----------|
| Der Arzt röntgt die Lunge. | Die Lunge wird geröntgt. | Die Lunge wird geröntgt. |

*Häufige Passivphrasen bei Atemwegserkrankungen:*
- 'Die Lunge wurde abgehört.'
- 'Ein Lungenfunktionstest wird durchgeführt.'
- 'Die Diagnose COPD wurde gestellt.'

**Beschreibung von Atemmustern:**
- 'tiefe Atmung'
- 'flache Atmung'
- 'beschleunigte Atmung'
- 'erschwerte Atmung'

*Präpositionen mit Atemorganen:*
- 'in der Lunge' - Ort
- 'in die Lunge' - Richtung
- 'aus der Lunge' - Herkunft

**Zusammengesetzte medizinische Begriffe:**
- Lungenentzündung
- Atemnot
- Bronchialasthma"""
    },

    "section_23": {
        "en": """**Gastrointestinal System: Locative Prepositions and Case Usage**

Describing GI symptoms and anatomy requires mastery of locative prepositions.

*Two-Way Prepositions with GI Organs:*
| Preposition | Location (Dative) | Direction (Accusative) |
|-------------|-------------------|------------------------|
| in | im Magen (in the stomach) | in den Magen (into the stomach) |
| auf | auf dem Darm (on the intestine) | auf den Darm (onto the intestine) |

*Describing Pain Location:*
- 'Die Schmerzen sind im Oberbauch.' (The pain is in the upper abdomen.)
- 'Der Schmerz strahlt in den Rücken aus.' (The pain radiates into the back.)
- 'Die Beschwerden lokalisieren sich im rechten Unterbauch.' (The complaints localize in the right lower abdomen.)

**Symptom Description Vocabulary:**
| German | English | Example Sentence |
|--------|---------|------------------|
| die Übelkeit | nausea | Der Patient klagt über Übelkeit. |
| das Erbrechen | vomiting | Erbrechen seit zwei Tagen. |
| der Durchfall | diarrhea | Wässriger Durchfall ohne Blut. |
| die Verstopfung | constipation | Verstopfung seit einer Woche. |

*Temporal Expressions for Symptom History:*
- 'seit drei Tagen' (for three days)
- 'vor dem Essen' (before eating)
- 'nach dem Essen' (after eating)
- 'während der Mahlzeit' (during the meal)

**Physical Examination Phrases:**
- 'Der Bauch ist weich und nicht druckschmerzhaft.' (The abdomen is soft and not tender.)
- 'Ich taste jetzt Ihren Bauch ab.' (I'm now palpating your abdomen.)""",

        "de": """**Magen-Darm-System: Lokalpräpositionen und Kasusgebrauch**

Die Beschreibung von GI-Symptomen und -Anatomie erfordert die Beherrschung von Lokalpräpositionen.

*Wechselpräpositionen mit GI-Organen:*
| Präposition | Ort (Dativ) | Richtung (Akkusativ) |
|-------------|-------------|----------------------|
| in | im Magen | in den Magen |
| auf | auf dem Darm | auf den Darm |

*Schmerzlokalisation beschreiben:*
- 'Die Schmerzen sind im Oberbauch.'
- 'Der Schmerz strahlt in den Rücken aus.'
- 'Die Beschwerden lokalisieren sich im rechten Unterbauch.'

**Symptombeschreibungsvokabular:**
| Deutsch | Beispielsatz |
|---------|--------------|
| die Übelkeit | Der Patient klagt über Übelkeit. |
| das Erbrechen | Erbrechen seit zwei Tagen. |
| der Durchfall | Wässriger Durchfall ohne Blut. |
| die Verstopfung | Verstopfung seit einer Woche. |

*Zeitliche Ausdrücke für Symptomanamnese:*
- 'seit drei Tagen'
- 'vor dem Essen'
- 'nach dem Essen'
- 'während der Mahlzeit'

**Untersuchungsphrasen:**
- 'Der Bauch ist weich und nicht druckschmerzhaft.'
- 'Ich taste jetzt Ihren Bauch ab.'"""
    },

    "section_24": {
        "en": """**Neurology: Reflexive Verbs and Symptom Description**

Neurological examinations require specific reflexive verb constructions and precise symptom vocabulary.

*Reflexive Verbs in Neurology:*
- 'sich bewegen' (to move oneself) → 'Können Sie sich bewegen?' (Can you move?)
- 'sich fühlen' (to feel) → 'Wie fühlen Sie sich?' (How do you feel?)
- 'sich konzentrieren' (to concentrate) → 'Können Sie sich konzentrieren?' (Can you concentrate?)
- 'sich erinnern' (to remember) → 'Können Sie sich erinnern?' (Can you remember?)

**Dative Reflexive for Body Parts:**
When the reflexive refers to a body part:
- 'Ich wasche mir die Hände.' (I wash my hands.)
- 'Der Patient kann sich den Arm nicht bewegen.' (The patient cannot move his arm.)

*Neurological Examination Commands:*
- 'Folgen Sie meinem Finger mit den Augen.' (Follow my finger with your eyes.)
- 'Drücken Sie meine Hände.' (Squeeze my hands.)
- 'Heben Sie beide Arme.' (Raise both arms.)
- 'Schließen Sie die Augen.' (Close your eyes.)

**Describing Neurological Symptoms:**
| Symptom | German | Example |
|---------|--------|---------|
| Numbness | die Taubheit | Taubheit im linken Arm |
| Tingling | das Kribbeln | Kribbeln in den Fingern |
| Weakness | die Schwäche | Schwäche im rechten Bein |
| Dizziness | der Schwindel | Schwindel beim Aufstehen |

*Temporal Adverbs for Symptom Onset:*
- 'plötzlich' (suddenly) - 'Der Schwindel trat plötzlich auf.'
- 'allmählich' (gradually) - 'Die Schwäche entwickelte sich allmählich.'""",

        "de": """**Neurologie: Reflexive Verben und Symptombeschreibung**

Neurologische Untersuchungen erfordern spezifische reflexive Verbkonstruktionen.

*Reflexive Verben in der Neurologie:*
- 'sich bewegen' → 'Können Sie sich bewegen?'
- 'sich fühlen' → 'Wie fühlen Sie sich?'
- 'sich konzentrieren' → 'Können Sie sich konzentrieren?'
- 'sich erinnern' → 'Können Sie sich erinnern?'

**Dativ-Reflexiv für Körperteile:**
- 'Ich wasche mir die Hände.'
- 'Der Patient kann sich den Arm nicht bewegen.'

*Neurologische Untersuchungsbefehle:*
- 'Folgen Sie meinem Finger mit den Augen.'
- 'Drücken Sie meine Hände.'
- 'Heben Sie beide Arme.'
- 'Schließen Sie die Augen.'

**Neurologische Symptome beschreiben:**
| Symptom | Beispiel |
|---------|----------|
| die Taubheit | Taubheit im linken Arm |
| das Kribbeln | Kribbeln in den Fingern |
| die Schwäche | Schwäche im rechten Bein |
| der Schwindel | Schwindel beim Aufstehen |

*Temporaladverbien für Symptombeginn:*
- 'plötzlich' - 'Der Schwindel trat plötzlich auf.'
- 'allmählich' - 'Die Schwäche entwickelte sich allmählich.'"""
    },

    "section_25": {
        "en": """**Endocrinology: Dative/Accusative with Prepositions and Adjective Endings**

Discussing endocrine conditions requires mastery of case usage with prepositions.

*Preposition 'mit' + Dative for Treatment:*
- 'mit Insulin behandeln' (to treat with insulin)
- 'mit Tabletten einstellen' (to regulate with tablets)
- 'mit Schilddrüsenhormonen substituieren' (to substitute with thyroid hormones)

**Examples:**
- 'Der Patient wird mit Metformin behandelt.' (The patient is treated with metformin.)
- 'Wir beginnen mit einer niedrigen Dosis.' (We start with a low dose.)

*Adjective Endings for Lab Values:*
| Article Type | Example with Adjective |
|--------------|------------------------|
| Definite (der/die/das) | der erhöhte Blutzucker, die normale Schilddrüse, das hohe HbA1c |
| Indefinite (ein/eine) | ein erhöhter Blutzucker, eine normale Schilddrüse, ein hohes HbA1c |
| No article | erhöhter Blutzucker, normale Schilddrüse, hohes HbA1c |

**Describing Values:**
- 'Der Blutzucker ist stark erhöht.' (Blood sugar is significantly elevated.)
- 'Der HbA1c-Wert liegt bei 8,5%.' (The HbA1c value is at 8.5%.)
- 'Die Schilddrüsenwerte sind im Normbereich.' (Thyroid values are within normal range.)

*Patient Education Phrases:*
- 'Sie müssen regelmäßig Ihren Blutzucker messen.' (You must measure your blood sugar regularly.)
- 'Die Tabletten werden vor dem Essen eingenommen.' (The tablets are taken before meals.)
- 'Insulin wird subkutan gespritzt.' (Insulin is injected subcutaneously.)""",

        "de": """**Endokrinologie: Dativ/Akkusativ mit Präpositionen und Adjektivendungen**

Die Diskussion endokriner Erkrankungen erfordert die Beherrschung der Kasusverwendung.

*Präposition 'mit' + Dativ für Behandlung:*
- 'mit Insulin behandeln'
- 'mit Tabletten einstellen'
- 'mit Schilddrüsenhormonen substituieren'

**Beispiele:**
- 'Der Patient wird mit Metformin behandelt.'
- 'Wir beginnen mit einer niedrigen Dosis.'

*Adjektivendungen bei Laborwerten:*
| Artikelart | Beispiel mit Adjektiv |
|------------|----------------------|
| Bestimmt | der erhöhte Blutzucker |
| Unbestimmt | ein erhöhter Blutzucker |
| Ohne Artikel | erhöhter Blutzucker |

**Werte beschreiben:**
- 'Der Blutzucker ist stark erhöht.'
- 'Der HbA1c-Wert liegt bei 8,5%.'
- 'Die Schilddrüsenwerte sind im Normbereich.'

*Patientenschulungsphrasen:*
- 'Sie müssen regelmäßig Ihren Blutzucker messen.'
- 'Die Tabletten werden vor dem Essen eingenommen.'
- 'Insulin wird subkutan gespritzt.'"""
    },

    "section_26": {
        "en": """**Musculoskeletal System: Comparative and Superlative Forms**

Describing orthopedic conditions requires comparative structures for assessing function.

*Comparative Forms for Movement Assessment:*
| Base Form | Comparative | Superlative | Example |
|-----------|-------------|-------------|---------|
| beweglich | beweglicher | am beweglichsten | Das linke Knie ist beweglicher. |
| schmerzhaft | schmerzhafter | am schmerzhaftesten | Die Schulter ist schmerzhafter als gestern. |
| stark | stärker | am stärksten | Der Schmerz ist stärker geworden. |
| schwach | schwächer | am schwächsten | Der Griff ist schwächer als normal. |

*Comparison Structures:*
- 'Das rechte Bein ist kräftiger als das linke.' (The right leg is stronger than the left.)
- 'Die Beweglichkeit ist genauso gut wie vorher.' (Mobility is just as good as before.)
- 'Die Schmerzen sind nicht so stark wie letzte Woche.' (Pain is not as severe as last week.)

**Movement Range Description:**
- 'Die Bewegung ist eingeschränkt.' (Movement is restricted.)
- 'Das Gelenk lässt sich vollständig durchbewegen.' (The joint can be moved through full range.)
- 'Die Flexion ist stärker eingeschränkt als die Extension.' (Flexion is more restricted than extension.)

*Examination Instructions:*
- 'Beugen Sie das Knie so weit wie möglich.' (Bend the knee as far as possible.)
- 'Strecken Sie den Arm gegen meinen Widerstand.' (Extend the arm against my resistance.)
- 'Zeigen Sie mir, wo es am meisten wehtut.' (Show me where it hurts the most.)""",

        "de": """**Bewegungsapparat: Komparativ und Superlativ**

Die Beschreibung orthopädischer Zustände erfordert Vergleichsstrukturen.

*Komparativformen für Bewegungsbeurteilung:*
| Grundform | Komparativ | Superlativ | Beispiel |
|-----------|------------|------------|----------|
| beweglich | beweglicher | am beweglichsten | Das linke Knie ist beweglicher. |
| schmerzhaft | schmerzhafter | am schmerzhaftesten | Die Schulter ist schmerzhafter als gestern. |

*Vergleichsstrukturen:*
- 'Das rechte Bein ist kräftiger als das linke.'
- 'Die Beweglichkeit ist genauso gut wie vorher.'
- 'Die Schmerzen sind nicht so stark wie letzte Woche.'

**Bewegungsumfang beschreiben:**
- 'Die Bewegung ist eingeschränkt.'
- 'Das Gelenk lässt sich vollständig durchbewegen.'
- 'Die Flexion ist stärker eingeschränkt als die Extension.'

*Untersuchungsanweisungen:*
- 'Beugen Sie das Knie so weit wie möglich.'
- 'Strecken Sie den Arm gegen meinen Widerstand.'
- 'Zeigen Sie mir, wo es am meisten wehtut.'"""
    },

    "section_27": {
        "en": """**Dermatology: Descriptive Adjectives and Location Phrases**

Dermatological descriptions require precise adjective usage and localization.

*Adjective Sequences for Skin Lesions:*
In German, multiple adjectives follow a specific order:
- Size → Shape → Color → Location
- 'eine große, runde, rote Läsion am Unterarm' (a large, round, red lesion on the forearm)

**Common Dermatological Adjectives:**
| Category | Adjectives |
|----------|------------|
| Size | groß, klein, ausgedehnt, begrenzt |
| Shape | rund, oval, unregelmäßig, erhaben |
| Color | rot, blass, bräunlich, livide |
| Surface | glatt, rau, schuppig, nässend |
| Edge | scharf begrenzt, unscharf begrenzt |

*Localization Phrases:*
- 'am ganzen Körper' (all over the body)
- 'am Rumpf' (on the trunk)
- 'an den Extremitäten' (on the extremities)
- 'im Gesicht' (on the face)
- 'zwischen den Fingern' (between the fingers)

**Patient History Questions:**
- 'Seit wann haben Sie diesen Ausschlag?' (Since when do you have this rash?)
- 'Juckt es?' (Does it itch?)
- 'Hat sich die Größe verändert?' (Has the size changed?)
- 'Gibt es ähnliche Stellen an anderen Körperteilen?' (Are there similar spots on other body parts?)

*Treatment Instructions:*
- 'Tragen Sie die Salbe dünn auf.' (Apply the ointment thinly.)
- 'Die Creme wird zweimal täglich aufgetragen.' (The cream is applied twice daily.)""",

        "de": """**Dermatologie: Beschreibende Adjektive und Lokalisationsphrasen**

Dermatologische Beschreibungen erfordern präzisen Adjektivgebrauch.

*Adjektivreihenfolge bei Hautläsionen:*
Größe → Form → Farbe → Ort
- 'eine große, runde, rote Läsion am Unterarm'

**Häufige dermatologische Adjektive:**
| Kategorie | Adjektive |
|-----------|-----------|
| Größe | groß, klein, ausgedehnt, begrenzt |
| Form | rund, oval, unregelmäßig, erhaben |
| Farbe | rot, blass, bräunlich, livide |
| Oberfläche | glatt, rau, schuppig, nässend |

*Lokalisationsphrasen:*
- 'am ganzen Körper'
- 'am Rumpf'
- 'an den Extremitäten'
- 'im Gesicht'

**Anamnesefragen:**
- 'Seit wann haben Sie diesen Ausschlag?'
- 'Juckt es?'
- 'Hat sich die Größe verändert?'

*Behandlungsanweisungen:*
- 'Tragen Sie die Salbe dünn auf.'
- 'Die Creme wird zweimal täglich aufgetragen.'"""
    },

    "section_28": {
        "en": """**Urology and Nephrology: Genitive Case and Medical Terminology**

Urological and nephrological terms often require genitive constructions.

*Genitive with Medical Nouns:*
- 'die Funktion der Niere' (the function of the kidney)
- 'die Entleerung der Blase' (the emptying of the bladder)
- 'der Verlauf der Erkrankung' (the course of the disease)

**Genitive Prepositions in Nephrology:**
| Preposition | Meaning | Example |
|-------------|---------|---------|
| wegen | because of | wegen der Niereninsuffizienz |
| trotz | despite | trotz der Dialyse |
| innerhalb | within | innerhalb des Normbereichs |
| außerhalb | outside | außerhalb der Grenzwerte |

*Symptom Description:*
- 'Haben Sie Probleme beim Wasserlassen?' (Do you have problems urinating?)
- 'Wie oft müssen Sie nachts zur Toilette?' (How often do you need to go to the toilet at night?)
- 'Gibt es Blut im Urin?' (Is there blood in the urine?)

**Compound Nouns in Urology:**
- Nieren + Stein = Nierenstein (kidney stone)
- Harn + Weg + Infektion = Harnwegsinfekt (urinary tract infection)
- Blasen + Spiegelung = Blasenspiegelung (cystoscopy)

*Lab Value Discussions:*
- 'Das Kreatinin ist erhöht.' (Creatinine is elevated.)
- 'Die GFR liegt bei 45 ml/min.' (GFR is at 45 ml/min.)
- 'Der Eiweißwert im Urin ist auffällig.' (The protein level in urine is abnormal.)""",

        "de": """**Urologie und Nephrologie: Genitiv und medizinische Terminologie**

Urologische und nephrologische Begriffe erfordern oft Genitivkonstruktionen.

*Genitiv bei medizinischen Nomen:*
- 'die Funktion der Niere'
- 'die Entleerung der Blase'
- 'der Verlauf der Erkrankung'

**Genitivpräpositionen in der Nephrologie:**
| Präposition | Bedeutung | Beispiel |
|-------------|-----------|----------|
| wegen | wegen | wegen der Niereninsuffizienz |
| trotz | trotz | trotz der Dialyse |
| innerhalb | innerhalb | innerhalb des Normbereichs |

*Symptombeschreibung:*
- 'Haben Sie Probleme beim Wasserlassen?'
- 'Wie oft müssen Sie nachts zur Toilette?'
- 'Gibt es Blut im Urin?'

**Zusammengesetzte Nomen in der Urologie:**
- Nierenstein
- Harnwegsinfekt
- Blasenspiegelung

*Laborwertbesprechung:*
- 'Das Kreatinin ist erhöht.'
- 'Die GFR liegt bei 45 ml/min.'
- 'Der Eiweißwert im Urin ist auffällig.'"""
    },

    "section_29": {
        "en": """**Obstetrics and Gynecology: Temporal Clauses and Examination Phrases**

OB/GYN communication requires specific temporal expressions and sensitive phrasing.

*Temporal Subordinate Clauses:*
| Conjunction | Meaning | Example |
|-------------|---------|---------|
| als | when (single past event) | als die Wehen begannen |
| wenn | when/whenever | wenn Sie Beschwerden haben |
| nachdem | after | nachdem die Geburt stattfand |
| bevor | before | bevor wir beginnen |
| seitdem | since | seitdem Sie schwanger sind |

*Pregnancy Timeline Phrases:*
- 'in der 20. Schwangerschaftswoche' (in the 20th week of pregnancy)
- 'im ersten Trimester' (in the first trimester)
- 'kurz vor der Geburt' (shortly before delivery)
- 'nach der Entbindung' (after delivery)

**Sensitive Examination Phrases:**
- 'Ich werde Sie jetzt untersuchen.' (I will examine you now.)
- 'Dies könnte etwas unangenehm sein.' (This might be somewhat uncomfortable.)
- 'Sagen Sie mir bitte, wenn es wehtut.' (Please tell me if it hurts.)
- 'Entspannen Sie sich, so gut es geht.' (Relax as much as possible.)

*History Taking:*
- 'Wann war Ihre letzte Regelblutung?' (When was your last menstrual period?)
- 'Waren Sie schon einmal schwanger?' (Have you ever been pregnant?)
- 'Haben Sie regelmäßige Zyklen?' (Do you have regular cycles?)
- 'Nehmen Sie Verhütungsmittel?' (Do you use contraception?)""",

        "de": """**Geburtshilfe und Gynäkologie: Temporalsätze und Untersuchungsphrasen**

OB/GYN-Kommunikation erfordert spezifische Zeitausdrücke und sensible Formulierungen.

*Temporale Nebensätze:*
| Konjunktion | Bedeutung | Beispiel |
|-------------|-----------|----------|
| als | als (einmaliges Ereignis) | als die Wehen begannen |
| wenn | wenn/wann immer | wenn Sie Beschwerden haben |
| nachdem | nachdem | nachdem die Geburt stattfand |
| bevor | bevor | bevor wir beginnen |
| seitdem | seitdem | seitdem Sie schwanger sind |

*Schwangerschaftszeitliche Phrasen:*
- 'in der 20. Schwangerschaftswoche'
- 'im ersten Trimester'
- 'kurz vor der Geburt'
- 'nach der Entbindung'

**Sensible Untersuchungsphrasen:**
- 'Ich werde Sie jetzt untersuchen.'
- 'Dies könnte etwas unangenehm sein.'
- 'Sagen Sie mir bitte, wenn es wehtut.'
- 'Entspannen Sie sich, so gut es geht.'

*Anamnese:*
- 'Wann war Ihre letzte Regelblutung?'
- 'Waren Sie schon einmal schwanger?'
- 'Haben Sie regelmäßige Zyklen?'
- 'Nehmen Sie Verhütungsmittel?'"""
    },

    # Phase 3 (C1) - Sections 30-55
    "section_30": {
        "en": """**Discharge Letter Structure: Nominalized Verbs and Professional Writing**

C1-level medical documentation requires nominalization and formal writing style.

*Nominalization of Verbs:*
| Verb | Nominalized Form | Example |
|------|------------------|---------|
| aufnehmen | die Aufnahme | Die Aufnahme erfolgte am 15.03. |
| entlassen | die Entlassung | Die Entlassung ist für morgen geplant. |
| untersuchen | die Untersuchung | Die Untersuchung ergab keine Auffälligkeiten. |
| behandeln | die Behandlung | Die Behandlung war erfolgreich. |
| diagnostizieren | die Diagnose | Die Diagnose lautet Pneumonie. |

*Standard Discharge Letter Structure:*
1. **Diagnosen** (Diagnoses) - listed by relevance
2. **Anamnese** (History) - brief summary
3. **Befund** (Findings) - examination results
4. **Therapie** (Treatment) - what was done
5. **Prozedere** (Procedure) - follow-up recommendations

**Formal Medical Phrases:**
- 'Der oben genannte Patient wurde stationär aufgenommen.' (The above-mentioned patient was admitted.)
- 'Wir bitten um weitere ambulante Betreuung.' (We request continued outpatient care.)
- 'Die weiterführende Therapie sollte wie folgt fortgesetzt werden...' (Continued therapy should proceed as follows...)

*Dative for Recipients:*
- 'Wir empfehlen dem Patienten...' (We recommend to the patient...)
- 'Wir bitten den Hausarzt um...' (We request from the family doctor...)""",

        "de": """**Arztbriefstruktur: Nominalisierte Verben und professionelles Schreiben**

Medizinische Dokumentation auf C1-Niveau erfordert Nominalisierung und formellen Schreibstil.

*Nominalisierung von Verben:*
| Verb | Nominalisierte Form | Beispiel |
|------|---------------------|----------|
| aufnehmen | die Aufnahme | Die Aufnahme erfolgte am 15.03. |
| entlassen | die Entlassung | Die Entlassung ist für morgen geplant. |
| untersuchen | die Untersuchung | Die Untersuchung ergab keine Auffälligkeiten. |
| behandeln | die Behandlung | Die Behandlung war erfolgreich. |

*Standard-Arztbriefstruktur:*
1. **Diagnosen** - nach Relevanz aufgelistet
2. **Anamnese** - kurze Zusammenfassung
3. **Befund** - Untersuchungsergebnisse
4. **Therapie** - durchgeführte Maßnahmen
5. **Prozedere** - Nachsorgeempfehlungen

**Formelle medizinische Phrasen:**
- 'Der oben genannte Patient wurde stationär aufgenommen.'
- 'Wir bitten um weitere ambulante Betreuung.'
- 'Die weiterführende Therapie sollte wie folgt fortgesetzt werden...'

*Dativ für Empfänger:*
- 'Wir empfehlen dem Patienten...'
- 'Wir bitten den Hausarzt um...'"""
    },

    "section_31": {
        "en": """**Advanced Discharge Letter: Participial Constructions**

C1-level documentation uses participial constructions for concise professional writing.

*Present Participle (Partizip I) as Adjective:*
Formation: Verb stem + -end
- 'der leidende Patient' (the suffering patient)
- 'die blutende Wunde' (the bleeding wound)
- 'das bestehende Problem' (the existing problem)

*Past Participle (Partizip II) as Adjective:*
- 'der operierte Patient' (the operated patient)
- 'die verabreichten Medikamente' (the administered medications)
- 'die durchgeführte Untersuchung' (the performed examination)

**Extended Participial Phrases:**
These replace relative clauses for conciseness:
- Instead of: 'Der Patient, der an Pneumonie leidet...'
- Use: 'Der an Pneumonie leidende Patient...'

*More Examples:*
- 'die mit Antibiotika behandelte Infektion' (the infection treated with antibiotics)
- 'der über Brustschmerzen klagende Patient' (the patient complaining of chest pain)
- 'die im Labor festgestellten Werte' (the values determined in the laboratory)

**Passive Participial Constructions:**
- 'Die durchzuführenden Maßnahmen...' (The measures to be carried out...)
- 'Die einzunehmenden Medikamente...' (The medications to be taken...)
- 'Die zu beachtenden Hinweise...' (The instructions to be observed...)

*Documentation Phrases:*
- 'Bei dem 65-jährigen, an Diabetes leidenden Patienten...'
- 'Die am Vortag begonnene Antibiose wurde fortgeführt.'""",

        "de": """**Fortgeschrittener Arztbrief: Partizipialkonstruktionen**

Dokumentation auf C1-Niveau verwendet Partizipialkonstruktionen für prägnantes professionelles Schreiben.

*Partizip I als Adjektiv:*
Bildung: Verbstamm + -end
- 'der leidende Patient'
- 'die blutende Wunde'
- 'das bestehende Problem'

*Partizip II als Adjektiv:*
- 'der operierte Patient'
- 'die verabreichten Medikamente'
- 'die durchgeführte Untersuchung'

**Erweiterte Partizipialphrasen:**
Ersetzen Relativsätze für Prägnanz:
- Statt: 'Der Patient, der an Pneumonie leidet...'
- Verwenden: 'Der an Pneumonie leidende Patient...'

*Weitere Beispiele:*
- 'die mit Antibiotika behandelte Infektion'
- 'der über Brustschmerzen klagende Patient'
- 'die im Labor festgestellten Werte'

**Passive Partizipialkonstruktionen:**
- 'Die durchzuführenden Maßnahmen...'
- 'Die einzunehmenden Medikamente...'
- 'Die zu beachtenden Hinweise...'

*Dokumentationsphrasen:*
- 'Bei dem 65-jährigen, an Diabetes leidenden Patienten...'
- 'Die am Vortag begonnene Antibiose wurde fortgeführt.'"""
    }
}

# Add brief enhancements for sections 32-55
for i in range(32, 56):
    section_key = f"section_{i}"
    if section_key not in GRAMMAR_ENHANCEMENTS:
        GRAMMAR_ENHANCEMENTS[section_key] = {
            "en": f"""**Advanced Medical German Grammar for Section {i}**

This section focuses on C1-level language skills essential for medical practice.

*Key Grammar Points:*

**1. Complex Sentence Structures:**
German medical documentation requires subordinate clauses with proper word order:
- 'Da der Patient über Schmerzen klagte, wurde ein CT durchgeführt.'
- 'Nachdem die Ergebnisse vorlagen, konnte die Diagnose gestellt werden.'

**2. Passive Voice in Medical Reporting:**
- 'Es wurde beschlossen...' (It was decided...)
- 'Es konnte festgestellt werden...' (It could be determined...)
- 'Der Patient wird weiterhin überwacht.' (The patient continues to be monitored.)

**3. Konjunktiv I for Indirect Speech:**
Used in professional reports to convey patient statements:
- 'Der Patient sagte, er habe Schmerzen.' (The patient said he had pain.)
- 'Sie gab an, sie sei allergisch gegen Penicillin.' (She stated she was allergic to penicillin.)

**4. Modal Verbs in Passive:**
- 'Die Medikamente müssen eingenommen werden.' (The medications must be taken.)
- 'Die Dosierung sollte angepasst werden.' (The dosage should be adjusted.)
- 'Ein EKG kann durchgeführt werden.' (An ECG can be performed.)

*Professional Communication Examples:*
- 'Aufgrund der vorliegenden Befunde empfehlen wir...'
- 'Im Hinblick auf die Risikofaktoren sollte...'
- 'Bei persistierenden Beschwerden bitten wir um Wiedervorstellung.'""",

            "de": f"""**Fortgeschrittene medizinische deutsche Grammatik für Abschnitt {i}**

Dieser Abschnitt konzentriert sich auf C1-Sprachkenntnisse für die medizinische Praxis.

*Wichtige Grammatikpunkte:*

**1. Komplexe Satzstrukturen:**
- 'Da der Patient über Schmerzen klagte, wurde ein CT durchgeführt.'
- 'Nachdem die Ergebnisse vorlagen, konnte die Diagnose gestellt werden.'

**2. Passiv in der medizinischen Berichterstattung:**
- 'Es wurde beschlossen...'
- 'Es konnte festgestellt werden...'
- 'Der Patient wird weiterhin überwacht.'

**3. Konjunktiv I für indirekte Rede:**
- 'Der Patient sagte, er habe Schmerzen.'
- 'Sie gab an, sie sei allergisch gegen Penicillin.'

**4. Modalverben im Passiv:**
- 'Die Medikamente müssen eingenommen werden.'
- 'Die Dosierung sollte angepasst werden.'
- 'Ein EKG kann durchgeführt werden.'

*Professionelle Kommunikationsbeispiele:*
- 'Aufgrund der vorliegenden Befunde empfehlen wir...'
- 'Im Hinblick auf die Risikofaktoren sollte...'
- 'Bei persistierenden Beschwerden bitten wir um Wiedervorstellung.'"""
        }

def process_section(filepath):
    """Process a single section file."""
    filename = filepath.name
    
    # Extract section key
    import re
    match = re.search(r'(section_\d+)', filename)
    if not match:
        return False
    
    section_key = match.group(1)
    
    if section_key not in GRAMMAR_ENHANCEMENTS:
        return False
    
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            data = json.load(f)
    except:
        return False
    
    # Update grammar focus
    if "textContent" not in data:
        data["textContent"] = {}
    
    data["textContent"]["grammarFocus"] = GRAMMAR_ENHANCEMENTS[section_key]
    
    # Save
    with open(filepath, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=4)
    
    return True

def main():
    print("=" * 60)
    print("Enhancing Sections 21-55 with Comprehensive Grammar")
    print("=" * 60)
    print()
    
    section_files = sorted(SECTIONS_DIR.glob("section_*.json"))
    
    enhanced = 0
    for filepath in section_files:
        if process_section(filepath):
            print(f"✓ Enhanced: {filepath.name}")
            enhanced += 1
    
    print()
    print(f"Total enhanced: {enhanced} sections")

if __name__ == "__main__":
    main()



