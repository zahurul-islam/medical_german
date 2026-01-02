#!/usr/bin/env node
/**
 * MedDeutsch Content Upload Script for Firebase
 * Uploads all section content to Firestore
 * 
 * Prerequisites:
 * 1. npm install firebase-admin
 * 2. Download service account key from Firebase Console
 * 3. Set GOOGLE_APPLICATION_CREDENTIALS environment variable
 * 
 * Usage: node upload_to_firebase.js
 */

const admin = require('firebase-admin');
const fs = require('fs');
const path = require('path');

// Initialize Firebase Admin
admin.initializeApp({
  credential: admin.credential.applicationDefault(),
  storageBucket: 'german-med.firebasestorage.app'
});

const db = admin.firestore();
const bucket = admin.storage().bucket();

async function uploadPhases() {
  console.log('📦 Uploading phases...');
  const phasesData = JSON.parse(fs.readFileSync('../content/phases.json', 'utf8'));

  for (const phase of phasesData.phases) {
    await db.collection('phases').doc(phase.id).set(phase);
    console.log(`  ✓ Phase: ${phase.id}`);
  }
}

async function uploadSections() {
  console.log('📦 Uploading sections...');
  const sectionsDir = '../content/sections';
  const files = fs.readdirSync(sectionsDir).filter(f => f.endsWith('.json'));

  for (const file of files) {
    const sectionData = JSON.parse(fs.readFileSync(path.join(sectionsDir, file), 'utf8'));
    const sectionId = sectionData.id;

    // Extract subcollections
    const vocabulary = sectionData.vocabulary || [];
    const dialogues = sectionData.dialogues || [];
    const exercises = sectionData.exercises || [];

    // Remove subcollection data from main document
    const sectionDoc = { ...sectionData };
    delete sectionDoc.vocabulary;
    delete sectionDoc.dialogues;
    delete sectionDoc.exercises;

    // Upload main section document
    await db.collection('sections').doc(sectionId).set(sectionDoc);

    // Upload vocabulary as subcollection
    for (const vocab of vocabulary) {
      await db.collection('sections').doc(sectionId)
        .collection('vocabulary').doc(vocab.id).set(vocab);
    }

    // Upload dialogues as subcollection
    for (const dialogue of dialogues) {
      await db.collection('sections').doc(sectionId)
        .collection('dialogues').doc(dialogue.id).set(dialogue);
    }

    // Upload exercises as subcollection
    for (const exercise of exercises) {
      await db.collection('sections').doc(sectionId)
        .collection('exercises').doc(exercise.id).set(exercise);
    }

    console.log(`  ✓ Section: ${sectionId} (${vocabulary.length} vocab, ${dialogues.length} dialogues, ${exercises.length} exercises)`);
  }
}

async function generateAudioPlaceholders() {
  console.log('🎵 Creating audio placeholder structure...');

  // Create directory structure for audio files
  const audioStructure = `
Audio files should be uploaded to Firebase Storage at:
gs://german-med.firebasestorage.app/audio/sections/{sectionId}/vocabulary/{vocabId}.mp3
gs://german-med.firebasestorage.app/audio/sections/{sectionId}/dialogues/{dialogueId}.mp3

Use Google Cloud Text-to-Speech or Amazon Polly for audio generation:
- Voice: de-DE (German)
- Speed: 0.9 (slightly slower for learning)
- Format: MP3, 48kHz
`;

  fs.writeFileSync('content/audio_instructions.txt', audioStructure);
  console.log('  ✓ Created audio_instructions.txt');
}

async function main() {
  console.log('🚀 MedDeutsch Content Upload\n');

  try {
    await uploadPhases();
    await uploadSections();
    await generateAudioPlaceholders();

    console.log('\n✅ Upload complete!');
    console.log(`
Next steps:
1. Generate audio files using TTS service
2. Upload audio to Firebase Storage
3. Create video content for each section
4. Test the app with real content
`);
  } catch (error) {
    console.error('❌ Error:', error.message);
    process.exit(1);
  }
}

main();
