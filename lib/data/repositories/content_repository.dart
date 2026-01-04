// Content repository for fetching learning content from Firestore
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import '../models/models.dart';

class ContentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Cache for frequently accessed data
  List<PhaseModel>? _phasesCache;
  final Map<String, List<SectionModel>> _sectionsCache = {};

  // Default phases data
  static final List<PhaseModel> _defaultPhases = [
    PhaseModel(
      id: 'phase1',
      order: 1,
      level: 'A1-A2',
      title: {
        'en': 'Foundation & Hospital Basics',
        'de': 'Grundlagen & Krankenhaus-Basics',
        'bn': 'ভিত্তি এবং হাসপাতালের মৌলিক বিষয়',
        'hi': 'नींव और अस्पताल की बुनियादी बातें',
        'ur': 'بنیاد اور ہسپتال کی بنیادی باتیں',
        'tr': 'Temel Bilgiler ve Hastane Temelleri',
      },
      description: {
        'en': 'Essential greetings, anatomy vocabulary, hospital departments, and basic medical communication for beginners.',
        'de': 'Wesentliche Begrüßungen, Anatomievokabular, Krankenhausabteilungen und grundlegende medizinische Kommunikation für Anfänger.',
        'bn': 'নতুনদের জন্য প্রয়োজনীয় অভিবাদন, শরীরের গঠন, হাসপাতাল বিভাগ এবং মৌলিক চিকিৎসা যোগাযোগ।',
        'hi': 'शुरुआती लोगों के लिए आवश्यक अभिवादन, शरीर रचना, अस्पताल विभाग और बुनियादी चिकित्सा संचार।',
        'ur': 'شروع کرنے والوں کے لیے ضروری سلام، جسمانی ساخت، ہسپتال کے شعبے اور بنیادی طبی مواصلات۔',
        'tr': 'Yeni başlayanlar için temel selamlaşmalar, anatomi kelime bilgisi, hastane bölümleri ve temel tıbbi iletişim.',
      },
      sectionCount: 12,
      colorHex: '#4CAF50',
      gradientStartHex: '#4CAF50',
      gradientEndHex: '#8BC34A',
    ),
    PhaseModel(
      id: 'phase2',
      order: 2,
      level: 'B1-B2',
      title: {
        'en': 'Clinical Communication',
        'de': 'Klinische Kommunikation',
        'bn': 'ক্লিনিক্যাল যোগাযোগ',
        'hi': 'क्लिनिकल संचार',
        'ur': 'کلینیکل مواصلات',
        'tr': 'Klinik İletişim',
      },
      description: {
        'en': 'Patient history taking, physical examinations, informed consent, and specialty-specific medical vocabulary.',
        'de': 'Patientenanamnese, körperliche Untersuchungen, Einwilligung und fachspezifisches medizinisches Vokabular.',
        'bn': 'রোগীর ইতিহাস নেওয়া, শারীরিক পরীক্ষা, সম্মতি এবং বিশেষজ্ঞতা-নির্দিষ্ট চিকিৎসা শব্দভাণ্ডার।',
        'hi': 'रोगी इतिहास लेना, शारीरिक परीक्षण, सूचित सहमति और विशेषता-विशिष्ट चिकित्सा शब्दावली।',
        'ur': 'مریض کی تاریخ لینا، جسمانی معائنے، باخبر رضامندی اور تخصص سے متعلق طبی الفاظ۔',
        'tr': 'Hasta geçmişi alma, fiziksel muayeneler, bilgilendirilmiş onam ve uzmanlık alanına özgü tıbbi kelime bilgisi.',
      },
      sectionCount: 17,
      colorHex: '#FFC107',
      gradientStartHex: '#FFC107',
      gradientEndHex: '#FF9800',
    ),
    PhaseModel(
      id: 'phase3',
      order: 3,
      level: 'C1',
      title: {
        'en': 'Professional Expertise & FSP Preparation',
        'de': 'Professionelle Expertise & FSP-Vorbereitung',
        'bn': 'পেশাদার দক্ষতা এবং FSP প্রস্তুতি',
        'hi': 'पेशेवर विशेषज्ञता और FSP तैयारी',
        'ur': 'پیشہ ورانہ مہارت اور FSP کی تیاری',
        'tr': 'Profesyonel Uzmanlık ve FSP Hazırlığı',
      },
      description: {
        'en': 'Medical documentation, discharge letters, case presentations, FSP exam simulation, and advanced specialties.',
        'de': 'Medizinische Dokumentation, Arztbriefe, Fallpräsentationen, FSP-Prüfungssimulation und fortgeschrittene Fachgebiete.',
        'bn': 'চিকিৎসা ডকুমেন্টেশন, ডিসচার্জ লেটার, কেস প্রেজেন্টেশন, FSP পরীক্ষা সিমুলেশন এবং উন্নত বিশেষত্ব।',
        'hi': 'चिकित्सा दस्तावेज़ीकरण, डिस्चार्ज पत्र, केस प्रस्तुतियाँ, FSP परीक्षा सिमुलेशन और उन्नत विशेषताएँ।',
        'ur': 'طبی دستاویزات، ڈسچارج لیٹرز، کیس پریزنٹیشنز، FSP امتحان سمولیشن اور اعلیٰ تخصصات۔',
        'tr': 'Tıbbi dokümantasyon, taburcu mektupları, vaka sunumları, FSP sınav simülasyonu ve ileri uzmanlıklar.',
      },
      sectionCount: 26,
      colorHex: '#E91E63',
      gradientStartHex: '#E91E63',
      gradientEndHex: '#F44336',
    ),
  ];

  // Default sections data - all 55 sections matching content/sections/*.json
  static final List<SectionModel> _defaultSections = [
    // Phase 1: Foundation & Hospital Basics (A1-A2) — 12 Sections
    SectionModel(
      id: 'section_01',
      phaseId: 'phase1',
      order: 1,
      level: 'A1',
      titleDe: 'Begrüßungen und Anreden',
      title: {'en': 'Greetings & Titles', 'de': 'Begrüßungen und Anreden'},
      description: {'en': 'Address colleagues properly: Herr Oberarzt, Frau Kollegin, Sie/Du forms, hospital hierarchy titles'},
      estimatedMinutes: 25,
    ),
    SectionModel(
      id: 'section_02',
      phaseId: 'phase1',
      order: 2,
      level: 'A1',
      titleDe: 'Der menschliche Körper I',
      title: {'en': 'The Human Body I', 'de': 'Der menschliche Körper I'},
      description: {'en': 'External anatomy vocabulary: head, limbs, skin, joints, basic body parts in German'},
      estimatedMinutes: 30,
    ),
    SectionModel(
      id: 'section_03',
      phaseId: 'phase1',
      order: 3,
      level: 'A1',
      titleDe: 'Der menschliche Körper II',
      title: {'en': 'The Human Body II', 'de': 'Der menschliche Körper II'},
      description: {'en': 'Major internal organs: Herz, Lunge, Leber, Niere, Magen, Darm, Gehirn'},
      estimatedMinutes: 30,
    ),
    SectionModel(
      id: 'section_04',
      phaseId: 'phase1',
      order: 4,
      level: 'A1',
      titleDe: 'Krankenhausabteilungen',
      title: {'en': 'Hospital Departments', 'de': 'Krankenhausabteilungen'},
      description: {'en': 'German hospital layout: Notaufnahme, Intensivstation, OP-Saal, Station, Ambulanz'},
      estimatedMinutes: 25,
    ),
    SectionModel(
      id: 'section_05',
      phaseId: 'phase1',
      order: 5,
      level: 'A1',
      titleDe: 'Medizinische Geräte',
      title: {'en': 'Medical Equipment', 'de': 'Medizinische Geräte'},
      description: {'en': 'Common tools: Stethoskop, Thermometer, Blutdruckmessgerät, Spritze, Infusion'},
      estimatedMinutes: 25,
    ),
    SectionModel(
      id: 'section_06',
      phaseId: 'phase1',
      order: 6,
      level: 'A1',
      titleDe: 'Zeit und Dienstplan',
      title: {'en': 'Time & Scheduling', 'de': 'Zeit und Dienstplan'},
      description: {'en': 'Express shifts: Frühschicht, Spätschicht, Nachtdienst, Bereitschaftsdienst, appointment times'},
      estimatedMinutes: 25,
    ),
    SectionModel(
      id: 'section_07',
      phaseId: 'phase1',
      order: 7,
      level: 'A1',
      titleDe: 'Zahlen und Vitalzeichen',
      title: {'en': 'Numbers & Vital Signs', 'de': 'Zahlen und Vitalzeichen'},
      description: {'en': 'Report: Blutdruck (blood pressure), Puls, Temperatur, Atemfrequenz, Sauerstoffsättigung'},
      estimatedMinutes: 30,
    ),
    SectionModel(
      id: 'section_08',
      phaseId: 'phase1',
      order: 8,
      level: 'A2',
      titleDe: 'Das Pflegepersonal',
      title: {'en': 'The Nursing Staff', 'de': 'Das Pflegepersonal'},
      description: {'en': 'Communicate with Pflegekräfte, Krankenschwester, Pfleger, delegation and teamwork'},
      estimatedMinutes: 30,
    ),
    SectionModel(
      id: 'section_09',
      phaseId: 'phase1',
      order: 9,
      level: 'A2',
      titleDe: 'Patientenaufnahme',
      title: {'en': 'Patient Reception', 'de': 'Patientenaufnahme'},
      description: {'en': 'Register new patients: personal data, insurance (Versicherung), admission forms'},
      estimatedMinutes: 35,
    ),
    SectionModel(
      id: 'section_10',
      phaseId: 'phase1',
      order: 10,
      level: 'A2',
      titleDe: 'Grundlegende Symptome',
      title: {'en': 'Basic Symptoms', 'de': 'Grundlegende Symptome'},
      description: {'en': 'Common complaints: Schmerzen, Fieber, Husten, Übelkeit, Erbrechen, Durchfall'},
      estimatedMinutes: 35,
    ),
    SectionModel(
      id: 'section_11',
      phaseId: 'phase1',
      order: 11,
      level: 'A2',
      titleDe: 'Apotheken-Grundlagen',
      title: {'en': 'Pharmacy Basics', 'de': 'Apotheken-Grundlagen'},
      description: {'en': 'Common medications: Antibiotika, Schmerzmittel, dosages (Dosierung), prescription terms'},
      estimatedMinutes: 30,
    ),
    SectionModel(
      id: 'section_12',
      phaseId: 'phase1',
      order: 12,
      level: 'A2',
      titleDe: 'Notrufe',
      title: {'en': 'Emergency Calls', 'de': 'Notrufe'},
      description: {'en': 'Give clear phone information: patient condition, location, urgency level, handover'},
      estimatedMinutes: 30,
    ),
    // Phase 2: Clinical Communication (B1-B2) — 17 Sections
    SectionModel(
      id: 'section_13',
      phaseId: 'phase2',
      order: 13,
      level: 'B1',
      titleDe: 'Anamnese I',
      title: {'en': 'Anamnese I', 'de': 'Anamnese I'},
      description: {'en': 'General patient history: chief complaint (Hauptbeschwerde), current illness'},
      estimatedMinutes: 35,
    ),
    SectionModel(
      id: 'section_14',
      phaseId: 'phase2',
      order: 14,
      level: 'B1',
      titleDe: 'Anamnese II',
      title: {'en': 'Anamnese II', 'de': 'Anamnese II'},
      description: {'en': 'Family history (Familienanamnese), social history, lifestyle factors'},
      estimatedMinutes: 35,
    ),
    SectionModel(
      id: 'section_15',
      phaseId: 'phase2',
      order: 15,
      level: 'B1',
      titleDe: 'Anamnese III',
      title: {'en': 'Anamnese III', 'de': 'Anamnese III'},
      description: {'en': 'Medication history, allergies (Allergien), previous surgeries'},
      estimatedMinutes: 35,
    ),
    SectionModel(
      id: 'section_16',
      phaseId: 'phase2',
      order: 16,
      level: 'B1',
      titleDe: 'Schmerzanamnese',
      title: {'en': 'Pain Assessment', 'de': 'Schmerzanamnese'},
      description: {'en': 'Describe quality (stechend, brennend), intensity (VAS scale), duration, location'},
      estimatedMinutes: 40,
    ),
    SectionModel(
      id: 'section_17',
      phaseId: 'phase2',
      order: 17,
      level: 'B1',
      titleDe: 'Körperliche Untersuchung',
      title: {'en': 'Physical Examination', 'de': 'Körperliche Untersuchung'},
      description: {'en': 'Give instructions: "Tief einatmen", "Bitte entspannen", "Zeigen Sie mir die Stelle"'},
      estimatedMinutes: 45,
    ),
    SectionModel(
      id: 'section_18',
      phaseId: 'phase2',
      order: 18,
      level: 'B1',
      titleDe: 'Aufklärung',
      title: {'en': 'Informed Consent', 'de': 'Aufklärung'},
      description: {'en': 'Explain risks for procedures: blood draw, injections, informed consent documentation'},
      estimatedMinutes: 40,
    ),
    SectionModel(
      id: 'section_19',
      phaseId: 'phase2',
      order: 19,
      level: 'B1',
      titleDe: 'Laborbefunde beschreiben',
      title: {'en': 'Describing Lab Results', 'de': 'Laborbefunde beschreiben'},
      description: {'en': 'Interpret blood counts: Hämoglobin, Leukozyten, Thrombozyten, CRP, Kreatinin'},
      estimatedMinutes: 45,
    ),
    SectionModel(
      id: 'section_20',
      phaseId: 'phase2',
      order: 20,
      level: 'B1',
      titleDe: 'Radiologie-Vokabular',
      title: {'en': 'Radiology Vocabulary', 'de': 'Radiologie-Vokabular'},
      description: {'en': 'Discuss imaging: Röntgen, CT, MRT, Ultraschall, Befund terminology'},
      estimatedMinutes: 40,
    ),
    SectionModel(
      id: 'section_21',
      phaseId: 'phase2',
      order: 21,
      level: 'B2',
      titleDe: 'Herz-Kreislauf-System',
      title: {'en': 'Cardiovascular System', 'de': 'Herz-Kreislauf-System'},
      description: {'en': 'Heart failure (Herzinsuffizienz), Myokardinfarkt, Hypertonie, ECG findings'},
      estimatedMinutes: 50,
    ),
    SectionModel(
      id: 'section_22',
      phaseId: 'phase2',
      order: 22,
      level: 'B2',
      titleDe: 'Atmungssystem',
      title: {'en': 'Respiratory System', 'de': 'Atmungssystem'},
      description: {'en': 'Asthma, COPD, Pneumonie, lung examination findings, oxygen therapy'},
      estimatedMinutes: 50,
    ),
    SectionModel(
      id: 'section_23',
      phaseId: 'phase2',
      order: 23,
      level: 'B2',
      titleDe: 'Verdauungssystem',
      title: {'en': 'Gastrointestinal System', 'de': 'Verdauungssystem'},
      description: {'en': 'Gastritis, Appendizitis, Hepatitis, GI symptoms and examination'},
      estimatedMinutes: 50,
    ),
    SectionModel(
      id: 'section_24',
      phaseId: 'phase2',
      order: 24,
      level: 'B2',
      titleDe: 'Neurologie-Grundlagen',
      title: {'en': 'Neurology Basics', 'de': 'Neurologie-Grundlagen'},
      description: {'en': 'Schlaganfall (stroke), Epilepsie, neurological examination, GCS'},
      estimatedMinutes: 50,
    ),
    SectionModel(
      id: 'section_25',
      phaseId: 'phase2',
      order: 25,
      level: 'B2',
      titleDe: 'Endokrinologie',
      title: {'en': 'Endocrinology', 'de': 'Endokrinologie'},
      description: {'en': 'Diabetes mellitus management, Schilddrüsenerkrankungen, HbA1c discussion'},
      estimatedMinutes: 45,
    ),
    SectionModel(
      id: 'section_26',
      phaseId: 'phase2',
      order: 26,
      level: 'B2',
      titleDe: 'Chirurgie-Grundlagen',
      title: {'en': 'Surgery Basics', 'de': 'Chirurgie-Grundlagen'},
      description: {'en': 'Pre-operative (präoperativ), post-operative care, wound management'},
      estimatedMinutes: 45,
    ),
    SectionModel(
      id: 'section_27',
      phaseId: 'phase2',
      order: 27,
      level: 'B2',
      titleDe: 'Pädiatrie',
      title: {'en': 'Pediatrics', 'de': 'Pädiatrie'},
      description: {'en': 'Communicate with parents and children, developmental milestones, vaccinations'},
      estimatedMinutes: 45,
    ),
    SectionModel(
      id: 'section_28',
      phaseId: 'phase2',
      order: 28,
      level: 'B2',
      titleDe: 'Gynäkologie/Geburtshilfe',
      title: {'en': 'OBGYN', 'de': 'Gynäkologie/Geburtshilfe'},
      description: {'en': 'Pregnancy (Schwangerschaft), gynecological exams, prenatal care'},
      estimatedMinutes: 45,
    ),
    SectionModel(
      id: 'section_29',
      phaseId: 'phase2',
      order: 29,
      level: 'B2',
      titleDe: 'Psychiatrie',
      title: {'en': 'Psychiatry', 'de': 'Psychiatrie'},
      description: {'en': 'Mental health basics, Depression, Angststörung, patient rapport building'},
      estimatedMinutes: 50,
    ),
    // Phase 3: Professional Expertise & FSP Preparation (C1) — 26 Sections
    SectionModel(
      id: 'section_30',
      phaseId: 'phase3',
      order: 30,
      level: 'C1',
      titleDe: 'Arztbrief I',
      title: {'en': 'Discharge Letter I', 'de': 'Arztbrief I'},
      description: {'en': 'Structure of German discharge letter: Diagnosen, Anamnese, Befund format'},
      estimatedMinutes: 40,
    ),
    SectionModel(
      id: 'section_31',
      phaseId: 'phase3',
      order: 31,
      level: 'C1',
      titleDe: 'Arztbrief II',
      title: {'en': 'Discharge Letter II', 'de': 'Arztbrief II'},
      description: {'en': 'Writing the epicrisis (Epikrise/Zusammenfassung), medical writing style'},
      estimatedMinutes: 40,
    ),
    SectionModel(
      id: 'section_32',
      phaseId: 'phase3',
      order: 32,
      level: 'C1',
      titleDe: 'Patientenvorstellung',
      title: {'en': 'Case Presentation', 'de': 'Patientenvorstellung'},
      description: {'en': 'Present to Chefarzt: structured oral case presentation format'},
      estimatedMinutes: 45,
    ),
    SectionModel(
      id: 'section_33',
      phaseId: 'phase3',
      order: 33,
      level: 'C1',
      titleDe: 'Kollegiale Kommunikation',
      title: {'en': 'Colleague Communication', 'de': 'Kollegiale Kommunikation'},
      description: {'en': 'Handover protocols (Übergabe), shift change communication'},
      estimatedMinutes: 40,
    ),
    SectionModel(
      id: 'section_34',
      phaseId: 'phase3',
      order: 34,
      level: 'C1',
      titleDe: 'Medizinische Dokumentation',
      title: {'en': 'Medical Documentation', 'de': 'Medizinische Dokumentation'},
      description: {'en': 'Legal charting requirements, documentation standards, abbreviations'},
      estimatedMinutes: 45,
    ),
    SectionModel(
      id: 'section_35',
      phaseId: 'phase3',
      order: 35,
      level: 'C1',
      titleDe: 'Differentialdiagnose',
      title: {'en': 'Differential Diagnosis', 'de': 'Differentialdiagnose'},
      description: {'en': 'Debate diagnostic possibilities in German, clinical reasoning language'},
      estimatedMinutes: 50,
    ),
    SectionModel(
      id: 'section_36',
      phaseId: 'phase3',
      order: 36,
      level: 'C1',
      titleDe: 'Medizinische Ethik',
      title: {'en': 'Medical Ethics', 'de': 'Medizinische Ethik'},
      description: {'en': 'End-of-life care, Patientenverfügung (living will), ethical discussions'},
      estimatedMinutes: 45,
    ),
    SectionModel(
      id: 'section_37',
      phaseId: 'phase3',
      order: 37,
      level: 'C1',
      titleDe: 'Deutsches Gesundheitssystem',
      title: {'en': 'German Health System', 'de': 'Deutsches Gesundheitssystem'},
      description: {'en': 'Insurance: GKV vs PKV, KV-System, Krankenkasse, healthcare structure'},
      estimatedMinutes: 50,
    ),
    SectionModel(
      id: 'section_38',
      phaseId: 'phase3',
      order: 38,
      level: 'C1',
      titleDe: 'Pharmakotherapie',
      title: {'en': 'Pharmacotherapy', 'de': 'Pharmakotherapie'},
      description: {'en': 'Advanced drug interactions, contraindications, prescription language'},
      estimatedMinutes: 50,
    ),
    SectionModel(
      id: 'section_39',
      phaseId: 'phase3',
      order: 39,
      level: 'C1',
      titleDe: 'Laborbefunde',
      title: {'en': 'Laboratory Reports', 'de': 'Laborbefunde'},
      description: {'en': 'Explain complex pathology results to patients in understandable terms'},
      estimatedMinutes: 45,
    ),
    SectionModel(
      id: 'section_40',
      phaseId: 'phase3',
      order: 40,
      level: 'C1',
      titleDe: 'Standardarbeitsanweisungen',
      title: {'en': 'SOPs', 'de': 'Standardarbeitsanweisungen'},
      description: {'en': 'Follow hospital Standard Operating Procedures, quality management'},
      estimatedMinutes: 40,
    ),
    SectionModel(
      id: 'section_41',
      phaseId: 'phase3',
      order: 41,
      level: 'C1',
      titleDe: 'Schlechte Nachrichten überbringen',
      title: {'en': 'Breaking Bad News', 'de': 'Schlechte Nachrichten überbringen'},
      description: {'en': 'SPIKES protocol in German, empathetic communication techniques'},
      estimatedMinutes: 55,
    ),
    SectionModel(
      id: 'section_42',
      phaseId: 'phase3',
      order: 42,
      level: 'C1',
      titleDe: 'Approbationsverfahren',
      title: {'en': 'Approbation Process', 'de': 'Approbationsverfahren'},
      description: {'en': 'Navigate legal path to German medical license, required documents'},
      estimatedMinutes: 50,
    ),
    SectionModel(
      id: 'section_43',
      phaseId: 'phase3',
      order: 43,
      level: 'C1',
      titleDe: 'Work-Life-Balance',
      title: {'en': 'Work-Life Balance', 'de': 'Work-Life-Balance'},
      description: {'en': 'Managing Weiterbildung (specialization training), Facharzt path'},
      estimatedMinutes: 40,
    ),
    SectionModel(
      id: 'section_44',
      phaseId: 'phase3',
      order: 44,
      level: 'C1',
      titleDe: 'FSP-Simulation I',
      title: {'en': 'FSP Simulation I', 'de': 'FSP-Simulation I'},
      description: {'en': 'Practice: The Patient Interview (Arzt-Patienten-Gespräch)'},
      estimatedMinutes: 60,
    ),
    SectionModel(
      id: 'section_45',
      phaseId: 'phase3',
      order: 45,
      level: 'C1',
      titleDe: 'FSP-Simulation II',
      title: {'en': 'FSP Simulation II', 'de': 'FSP-Simulation II'},
      description: {'en': 'Practice: The Documentation Stage (Dokumentation)'},
      estimatedMinutes: 60,
    ),
    SectionModel(
      id: 'section_46',
      phaseId: 'phase3',
      order: 46,
      level: 'C1',
      titleDe: 'FSP-Simulation III',
      title: {'en': 'FSP Simulation III', 'de': 'FSP-Simulation III'},
      description: {'en': 'Practice: The Doctor-to-Doctor Talk (Arzt-Arzt-Gespräch)'},
      estimatedMinutes: 60,
    ),
    SectionModel(
      id: 'section_47',
      phaseId: 'phase3',
      order: 47,
      level: 'C1',
      titleDe: 'Orthopädie',
      title: {'en': 'Orthopedics', 'de': 'Orthopädie'},
      description: {'en': 'Fractures (Frakturen), joint replacements (Gelenkersatz), rehabilitation'},
      estimatedMinutes: 50,
    ),
    SectionModel(
      id: 'section_48',
      phaseId: 'phase3',
      order: 48,
      level: 'C1',
      titleDe: 'Urologie',
      title: {'en': 'Urology', 'de': 'Urologie'},
      description: {'en': 'Renal issues (Nierenerkrankungen), catheterization, prostate conditions'},
      estimatedMinutes: 45,
    ),
    SectionModel(
      id: 'section_49',
      phaseId: 'phase3',
      order: 49,
      level: 'C1',
      titleDe: 'Dermatologie',
      title: {'en': 'Dermatology', 'de': 'Dermatologie'},
      description: {'en': 'Describe skin lesions: Ausschlag, Exanthem, morphology terminology'},
      estimatedMinutes: 45,
    ),
    SectionModel(
      id: 'section_50',
      phaseId: 'phase3',
      order: 50,
      level: 'C1',
      titleDe: 'Augenheilkunde & HNO',
      title: {'en': 'Ophthalmology & ENT', 'de': 'Augenheilkunde & HNO'},
      description: {'en': 'Specialized sensory exams, common conditions, examination vocabulary'},
      estimatedMinutes: 50,
    ),
    SectionModel(
      id: 'section_51',
      phaseId: 'phase3',
      order: 51,
      level: 'C1',
      titleDe: 'Notfallmedizin',
      title: {'en': 'Emergency Medicine', 'de': 'Notfallmedizin'},
      description: {'en': 'ACLS/BLS terminology in German, Reanimation, emergency protocols'},
      estimatedMinutes: 55,
    ),
    SectionModel(
      id: 'section_52',
      phaseId: 'phase3',
      order: 52,
      level: 'C1',
      titleDe: 'Intensivmedizin (ITS)',
      title: {'en': 'Intensive Care', 'de': 'Intensivmedizin (ITS)'},
      description: {'en': 'Ventilator settings (Beatmung), monitoring, ICU documentation'},
      estimatedMinutes: 55,
    ),
    SectionModel(
      id: 'section_53',
      phaseId: 'phase3',
      order: 53,
      level: 'C1',
      titleDe: 'Infektionskrankheiten',
      title: {'en': 'Infectious Diseases', 'de': 'Infektionskrankheiten'},
      description: {'en': 'Isolation protocols, MRSA, infection control terminology'},
      estimatedMinutes: 50,
    ),
    SectionModel(
      id: 'section_54',
      phaseId: 'phase3',
      order: 54,
      level: 'C1',
      titleDe: 'Palliativmedizin',
      title: {'en': 'Palliative Care', 'de': 'Palliativmedizin'},
      description: {'en': 'Pain management, end-of-life care, comfort measures communication'},
      estimatedMinutes: 50,
    ),
    SectionModel(
      id: 'section_55',
      phaseId: 'phase3',
      order: 55,
      level: 'C1',
      titleDe: 'Medizinrecht',
      title: {'en': 'Medical Jurisprudence', 'de': 'Medizinrecht'},
      description: {'en': 'Liability (Haftung), malpractice laws, legal documentation requirements'},
      estimatedMinutes: 50,
    ),
  ];


  /// Get all learning phases
  Future<List<PhaseModel>> getPhases() async {
    if (_phasesCache != null) {
      return _phasesCache!;
    }

    // Use default data directly to avoid Firestore permission/connection issues
    // TODO: Re-enable Firestore when database is seeded
    _phasesCache = _defaultPhases;
    return _phasesCache!;
  }

  /// Get sections for a specific phase
  Future<List<SectionModel>> getSectionsByPhase(String phaseId) async {
    if (_sectionsCache.containsKey(phaseId)) {
      return _sectionsCache[phaseId]!;
    }

    // Use default data directly to avoid Firestore permission/connection issues
    // TODO: Re-enable Firestore when database is seeded
    final sections = _defaultSections.where((s) => s.phaseId == phaseId).toList();
    _sectionsCache[phaseId] = sections;
    return sections;
  }

  /// Get all sections
  Future<List<SectionModel>> getAllSections() async {
    // Use default data directly
    return _defaultSections;
  }

  /// Get a specific section by ID - loads from JSON for full content
  Future<SectionModel?> getSection(String sectionId) async {
    // Try to find in default sections first
    SectionModel? baseSection;
    try {
      baseSection = _defaultSections.firstWhere((s) => s.id == sectionId);
    } catch (e) {
      return null;
    }

    // Load JSON data to get textContent and full translations
    try {
      final jsonData = await _loadSectionJson(sectionId);
      if (jsonData != null) {
        // Merge JSON data with base section to get textContent and translations
        return baseSection.copyWithJsonData(jsonData);
      }
    } catch (e) {
      print('Error loading JSON for section $sectionId: $e');
    }

    // Return base section if JSON loading fails
    return baseSection;
  }

  /// Get vocabulary for a section - loads from local JSON
  Future<List<VocabularyModel>> getVocabulary(String sectionId) async {
    try {
      // Load from local JSON file
      final jsonData = await _loadSectionJson(sectionId);
      if (jsonData == null || jsonData['vocabulary'] == null) {
        return [];
      }
      
      final vocabList = jsonData['vocabulary'] as List;
      return vocabList.map((v) => VocabularyModel.fromJson(v as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error loading vocabulary for $sectionId: $e');
      return [];
    }
  }

  /// Get dialogues for a section - loads from local JSON
  Future<List<DialogueModel>> getDialogues(String sectionId) async {
    try {
      final jsonData = await _loadSectionJson(sectionId);
      if (jsonData == null || jsonData['dialogues'] == null) {
        return [];
      }
      
      final dialogueList = jsonData['dialogues'] as List;
      return dialogueList.map((d) => DialogueModel.fromJson(d as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error loading dialogues for $sectionId: $e');
      return [];
    }
  }

  /// Get exercises for a section - loads from local JSON
  Future<List<ExerciseModel>> getExercises(String sectionId) async {
    try {
      final jsonData = await _loadSectionJson(sectionId);
      if (jsonData == null || jsonData['exercises'] == null) {
        return [];
      }
      
      final exerciseList = jsonData['exercises'] as List;
      return exerciseList.map((e) => ExerciseModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error loading exercises for $sectionId: $e');
      return [];
    }
  }

  // Cache for loaded JSON data
  final Map<String, Map<String, dynamic>> _jsonCache = {};

  // Known section filename suffixes for each section number
  static const Map<String, String> _sectionSuffixes = {
    '01': '_greetings',
    '02': '_human_body_1',
    '03': '_human_body_2',
    '04': '_hospital_departments',
    '05': '_medical_equipment',
    '06': '_time_scheduling',
    '07': '_vital_signs',
    '08': '_nursing_staff',
    '09': '_patient_reception',
    '10': '_basic_symptoms',
    '11': '_pharmacy_basics',
    '12': '_emergency_calls',
    '13': '_anamnese_1',
    '14': '_anamnese_2',
    '15': '_anamnese_3',
    '16': '_pain_assessment',
    '17': '_physical_exam',
    '18': '_informed_consent',
    // Sections 19+ use simple naming (section_XX.json)
  };

  /// Helper method to load section JSON from assets
  Future<Map<String, dynamic>?> _loadSectionJson(String sectionId) async {
    if (_jsonCache.containsKey(sectionId)) {
      return _jsonCache[sectionId];
    }

    try {
      // Generate number from section ID
      final sectionNum = sectionId.replaceAll('section_', '');
      final paddedNum = sectionNum.padLeft(2, '0');
      
      // Get suffix if known, otherwise try without suffix
      final suffix = _sectionSuffixes[paddedNum] ?? '';
      
      // Try with suffix first, then without
      final paths = [
        'content/sections/section_$paddedNum$suffix.json',
        if (suffix.isNotEmpty) 'content/sections/section_$paddedNum.json',
      ];
      
      for (final path in paths) {
        try {
          final jsonString = await rootBundle.loadString(path);
          final data = json.decode(jsonString) as Map<String, dynamic>;
          _jsonCache[sectionId] = data;
          return data;
        } catch (e) {
          // Continue to next path
          continue;
        }
      }
      
      return null;
    } catch (e) {
      print('Error loading JSON for $sectionId: $e');
      return null;
    }
  }

  /// Search sections by title
  Future<List<SectionModel>> searchSections(String query, String languageCode) async {
    // Note: Firestore doesn't support full-text search
    // This is a basic implementation - consider using Algolia for production
    final allSections = await getAllSections();
    final queryLower = query.toLowerCase();
    
    return allSections.where((section) {
      final title = section.getTitle(languageCode).toLowerCase();
      final titleDe = section.titleDe.toLowerCase();
      return title.contains(queryLower) || titleDe.contains(queryLower);
    }).toList();
  }

  /// Get sections by level
  Future<List<SectionModel>> getSectionsByLevel(String level) async {
    final snapshot = await _firestore
        .collection('sections')
        .where('level', isEqualTo: level)
        .orderBy('order')
        .get();

    return snapshot.docs
        .map((doc) => SectionModel.fromFirestore(doc))
        .toList();
  }

  /// Clear cache
  void clearCache() {
    _phasesCache = null;
    _sectionsCache.clear();
  }

  /// Get section count per phase
  Future<Map<String, int>> getSectionCountByPhase() async {
    final sections = await getAllSections();
    final countMap = <String, int>{};
    
    for (final section in sections) {
      countMap[section.phaseId] = (countMap[section.phaseId] ?? 0) + 1;
    }
    
    return countMap;
  }

  /// Get sections with progress for a user
  Future<List<Map<String, dynamic>>> getSectionsWithProgress({
    required String userId,
    required String phaseId,
  }) async {
    final sections = await getSectionsByPhase(phaseId);
    final results = <Map<String, dynamic>>[];

    for (final section in sections) {
      final progressDoc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('progress')
          .doc(section.id)
          .get();

      results.add({
        'section': section,
        'progress': progressDoc.exists 
            ? ProgressModel.fromFirestore(progressDoc) 
            : null,
      });
    }

    return results;
  }
}
