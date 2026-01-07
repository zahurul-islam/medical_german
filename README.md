# MedDeutsch - Medical German Learning App

A comprehensive Flutter application for learning Medical German, designed specifically for healthcare professionals preparing for FSP (Fachsprachprüfung) and KP (Kenntnisprüfung) exams.

## Features

### Learning Content
- **55 Sections** covering A1 to C1 levels
- **Phase 1 (A1-A2)**: Foundation & Hospital Basics (12 sections)
- **Phase 2 (B1-B2)**: Clinical Communication (17 sections)
- **Phase 3 (C1)**: Professional Expertise & FSP Preparation (26 sections)

### Practice & Testing
- **130 Mock Test Questions** across all levels
- FSP and KP mock exams for each phase
- Multiple exercise types: Multiple choice, Fill-in-blank, Matching

### Multi-language Support
- German (Target language)
- English, Bengali, Hindi, Urdu, Turkish (Source languages)

### Audio Learning
- Native German pronunciation for all vocabulary
- Professional audio recordings

### Offline Mode
- Full content available without internet connection
- Download lessons for offline study

### Premium Features
- Unlimited access to all lessons
- All mock tests
- Ad-free learning experience

## Technical Stack

- **Framework**: Flutter 3.x
- **State Management**: Riverpod
- **Authentication**: Firebase Auth (Email, Google, Apple)
- **Backend**: Firebase Firestore
- **Audio**: audioplayers
- **Local Storage**: shared_preferences

## Project Structure

```
lib/
├── core/
│   ├── localization/     # Multi-language support
│   ├── router/           # App navigation
│   ├── services/         # Subscription, audio services
│   └── themes/           # Colors, typography
├── data/
│   ├── models/           # Data models
│   └── repositories/     # Data access layer
└── presentation/
    ├── providers/        # Riverpod providers
    ├── screens/          # UI screens
    └── widgets/          # Reusable components
```

## Content Topics

### Phase 1 - Foundation (A1-A2)
1. Greetings & Hospital Hierarchy
2. German Articles (der, die, das)
3. Human Body I - External Anatomy
4. Human Body II - Internal Organs
5. Hospital Departments
6. Medical Equipment
7. Time & Scheduling
8. Vital Signs & Numbers
9. Nursing Staff & Teamwork
10. Patient Reception
11. Basic Symptoms
12. Pharmacy Basics

### Phase 2 - Clinical Communication (B1-B2)
13. Emergency Calls
14. Anamnese I - Chief Complaint
15. Anamnese II - Social/Family History
16. Anamnese III - Medical History
17. Pain Assessment
18. Physical Examination
19. Informed Consent
20. Radiology
21. Cardiovascular
22. Respiratory System
23. Gastrointestinal
24. Neurology
25. Endocrinology
26. Psychiatry
27. Pediatrics
28. Gynecology
29. Oncology

### Phase 3 - Professional Expertise (C1)
30. Discharge Letter I - Structure
31. Discharge Letter II - Epikrise
32. Case Presentation
33. Colleague Communication
34. Medical Documentation
35. Surgery & OR
36. Medical Ethics
37. German Healthcare System
38. Pharmacotherapy
39. Laboratory Reports
40. SOPs & Protocols
41. Breaking Bad News (SPIKES)
42. Approbation Process
43. Work-Life Balance in Medical Training
44. FSP I - Patient Dialogue
45. FSP II - Documentation
46. Anesthesiology
47. Orthopedics
48. Urology
49. Dermatology
50. Ophthalmology & ENT
51. Emergency Medicine
52. Intensive Care
53. Infectious Diseases
54. Palliative Care
55. Psychiatry Advanced

## Getting Started

### Prerequisites
- Flutter SDK 3.x or higher
- Dart SDK 3.x or higher
- Xcode (for iOS development)
- Android Studio (for Android development)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/your-org/medical_german.git
cd medical_german
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Building for Production

**iOS:**
```bash
flutter build ipa
```

**Android:**
```bash
flutter build appbundle
```

## License

This project is proprietary software. All rights reserved.

## Contact

For support or inquiries, visit [www.meddeutsch.de](https://www.meddeutsch.de/)
