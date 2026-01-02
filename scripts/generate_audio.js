#!/usr/bin/env node
/**
 * Audio Generation Script using Google Cloud Text-to-Speech
 * Generates pronunciation audio for all vocabulary items
 * 
 * Prerequisites:
 * 1. npm install @google-cloud/text-to-speech
 * 2. Set GOOGLE_APPLICATION_CREDENTIALS
 * 
 * Usage: node generate_audio.js
 */

const textToSpeech = require('@google-cloud/text-to-speech');
const fs = require('fs');
const path = require('path');
const util = require('util');

const client = new textToSpeech.TextToSpeechClient();

async function generateAudio(text, outputPath) {
    const request = {
        input: { text: text },
        voice: {
            languageCode: 'de-DE',
            name: 'de-DE-Neural2-B', // Neural voice for better quality
            ssmlGender: 'MALE'
        },
        audioConfig: {
            audioEncoding: 'MP3',
            speakingRate: 0.9, // Slightly slower for learning
            pitch: 0
        }
    };

    const [response] = await client.synthesizeSpeech(request);

    // Ensure directory exists
    const dir = path.dirname(outputPath);
    if (!fs.existsSync(dir)) {
        fs.mkdirSync(dir, { recursive: true });
    }

    await fs.promises.writeFile(outputPath, response.audioContent, 'binary');
    return outputPath;
}

async function processSection(sectionFile) {
    const section = JSON.parse(fs.readFileSync(sectionFile, 'utf8'));
    const sectionId = section.id;
    console.log(`\n📁 Processing ${sectionId}...`);

    const audioDir = `audio/sections/${sectionId}`;

    // Generate vocabulary audio
    if (section.vocabulary) {
        const vocabDir = `${audioDir}/vocabulary`;
        for (const vocab of section.vocabulary) {
            const outputPath = `${vocabDir}/${vocab.id}.mp3`;
            try {
                await generateAudio(vocab.germanTerm, outputPath);
                console.log(`  ✓ ${vocab.germanTerm}`);
            } catch (err) {
                console.error(`  ✗ ${vocab.germanTerm}: ${err.message}`);
            }
        }
    }

    // Generate dialogue audio
    if (section.dialogues) {
        const dialogueDir = `${audioDir}/dialogues`;
        for (const dialogue of section.dialogues) {
            for (let i = 0; i < dialogue.lines.length; i++) {
                const line = dialogue.lines[i];
                const outputPath = `${dialogueDir}/${dialogue.id}_line${i + 1}.mp3`;
                try {
                    await generateAudio(line.germanText, outputPath);
                    console.log(`  ✓ Line ${i + 1}: ${line.germanText.substring(0, 30)}...`);
                } catch (err) {
                    console.error(`  ✗ Line ${i + 1}: ${err.message}`);
                }
            }
        }
    }
}

async function main() {
    console.log('🎵 MedDeutsch Audio Generator\n');
    console.log('Using Google Cloud Text-to-Speech (de-DE Neural voice)\n');

    const sectionsDir = '../content/sections';
    const files = fs.readdirSync(sectionsDir)
        .filter(f => f.endsWith('.json'))
        .sort();

    console.log(`Found ${files.length} sections to process.`);

    for (const file of files) {
        await processSection(path.join(sectionsDir, file));
    }

    console.log('\n✅ Audio generation complete!');
    console.log(`
Next steps:
1. Upload generated audio to Firebase Storage:
   gsutil -m cp -r audio/* gs://german-med.firebasestorage.app/audio/

2. Update section JSON files with correct Storage URLs

3. Run the Firebase content upload script
`);
}

main().catch(console.error);
