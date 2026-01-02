/// Firebase content upload script
/// Run with: dart run scripts/upload_content.dart
import 'dart:convert';
import 'dart:io';

/// This script reads the content JSON files and prepares them for Firebase upload
/// To actually upload to Firebase, you'll need to:
/// 1. Install Firebase CLI: npm install -g firebase-tools  
/// 2. Login: firebase login
/// 3. Use firebase emulators or direct Firestore SDK

void main() async {
  print('=== MedDeutsch Content Upload Script ===\n');
  
  // Read phases
  final phasesFile = File('content/phases.json');
  if (await phasesFile.exists()) {
    final phasesContent = await phasesFile.readAsString();
    final phasesData = json.decode(phasesContent);
    print('✓ Found ${phasesData['phases'].length} phases');
    
    for (final phase in phasesData['phases']) {
      print('  - ${phase['id']}: ${phase['title']['en']} (${phase['level']})');
    }
  } else {
    print('✗ phases.json not found');
  }
  
  print('');
  
  // Read sections
  final sectionsDir = Directory('content/sections');
  if (await sectionsDir.exists()) {
    final sections = await sectionsDir.list().where((f) => f.path.endsWith('.json')).toList();
    print('✓ Found ${sections.length} section files');
    
    for (final sectionFile in sections) {
      final content = await File(sectionFile.path).readAsString();
      final sectionData = json.decode(content);
      final vocabCount = (sectionData['vocabulary'] as List?)?.length ?? 0;
      final dialogueCount = (sectionData['dialogues'] as List?)?.length ?? 0;
      final exerciseCount = (sectionData['exercises'] as List?)?.length ?? 0;
      
      print('  - ${sectionData['id']}: ${sectionData['title']['en']}');
      print('    Vocabulary: $vocabCount, Dialogues: $dialogueCount, Exercises: $exerciseCount');
    }
  } else {
    print('✗ sections directory not found');
  }
  
  print('\n=== Upload Instructions ===');
  print('''
To upload this content to Firebase Firestore:

1. Configure Firebase:
   \$ flutterfire configure --project=project-149956547132

2. Install Firebase Admin SDK (Node.js):
   \$ npm install firebase-admin

3. Create an upload script or use Firebase Console:
   - Go to Firebase Console > Firestore
   - Import the JSON data manually or use Admin SDK

4. For production, use Cloud Functions to batch import:
   
   const admin = require('firebase-admin');
   admin.initializeApp();
   const db = admin.firestore();
   
   // Upload phases
   const phases = require('./content/phases.json').phases;
   for (const phase of phases) {
     await db.collection('phases').doc(phase.id).set(phase);
   }
   
   // Upload sections  
   const section = require('./content/sections/section_01_greetings.json');
   await db.collection('sections').doc(section.id).set({
     ...section,
     vocabulary: null,  // Store in subcollection
     dialogues: null,
     exercises: null
   });
   
   // Store vocabulary as subcollection
   for (const vocab of section.vocabulary) {
     await db.collection('sections').doc(section.id)
       .collection('vocabulary').doc(vocab.id).set(vocab);
   }
''');
  
  print('\n✓ Script completed');
}
