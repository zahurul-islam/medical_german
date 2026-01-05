#!/usr/bin/env node
/**
 * Audio Generation Script using Google Cloud Text-to-Speech
 * Generates pronunciation audio for all vocabulary items and dialogue lines
 * 
 * Prerequisites:
 * 1. npm install @google-cloud/text-to-speech
 * 2. Set GOOGLE_APPLICATION_CREDENTIALS to the Firebase Admin SDK key
 * 
 * Usage: node generate_audio.js
 */

const textToSpeech = require('@google-cloud/text-to-speech');
const fs = require('fs');
const path = require('path');

const client = new textToSpeech.TextToSpeechClient();

// Output directory for audio files - directly to assets
const OUTPUT_BASE = path.join(__dirname, '..', 'assets', 'audio');
const ASSETS_DIR = path.join(__dirname, '..', 'assets', 'audio');

async function generateAudio(text, outputPath, voice = 'de-DE-Neural2-B', gender = 'MALE') {
    // Skip if file already exists
    if (fs.existsSync(outputPath)) {
        return { skipped: true, path: outputPath };
    }

    const request = {
        input: { text: text },
        voice: {
            languageCode: 'de-DE',
            name: voice,
            ssmlGender: gender
        },
        audioConfig: {
            audioEncoding: 'MP3',
            speakingRate: 0.9, // Slightly slower for learning
            pitch: 0
        }
    };

    try {
        const [response] = await client.synthesizeSpeech(request);

        // Ensure directory exists
        const dir = path.dirname(outputPath);
        if (!fs.existsSync(dir)) {
            fs.mkdirSync(dir, { recursive: true });
        }

        await fs.promises.writeFile(outputPath, response.audioContent, 'binary');
        return { success: true, path: outputPath };
    } catch (err) {
        return { error: err.message, path: outputPath };
    }
}

async function processSection(sectionFile) {
    const section = JSON.parse(fs.readFileSync(sectionFile, 'utf8'));
    const sectionId = section.id;
    console.log(`\n📁 Processing ${sectionId}...`);

    const audioDir = path.join(OUTPUT_BASE, 'sections', sectionId);
    let generated = 0;
    let skipped = 0;
    let errors = 0;

    // Generate vocabulary audio
    if (section.vocabulary && section.vocabulary.length > 0) {
        const vocabDir = path.join(audioDir, 'vocabulary');
        console.log(`  📚 Vocabulary: ${section.vocabulary.length} items`);
        
        for (const vocab of section.vocabulary) {
            const outputPath = path.join(vocabDir, `${vocab.id}.mp3`);
            // Use the germanTerm for pronunciation
            const text = vocab.germanTerm;
            
            const result = await generateAudio(text, outputPath);
            
            if (result.skipped) {
                skipped++;
            } else if (result.success) {
                generated++;
                console.log(`    ✓ ${text}`);
            } else {
                errors++;
                console.error(`    ✗ ${text}: ${result.error}`);
            }
        }
    }

    // Generate dialogue audio
    if (section.dialogues && section.dialogues.length > 0) {
        const dialogueDir = path.join(audioDir, 'dialogues');
        console.log(`  💬 Dialogues: ${section.dialogues.length} dialogues`);
        
        for (const dialogue of section.dialogues) {
            for (let i = 0; i < dialogue.lines.length; i++) {
                const line = dialogue.lines[i];
                const outputPath = path.join(dialogueDir, `${dialogue.id}_line${i + 1}.mp3`);
                const text = line.germanText;
                
                // Choose voice based on speaker
                const isDoctor = line.speaker.toLowerCase().includes('arzt') || 
                                line.speaker.toLowerCase().includes('dr.');
                const voice = isDoctor ? 'de-DE-Neural2-B' : 'de-DE-Neural2-C';
                const gender = isDoctor ? 'MALE' : 'FEMALE';
                
                const result = await generateAudio(text, outputPath, voice, gender);
                
                if (result.skipped) {
                    skipped++;
                } else if (result.success) {
                    generated++;
                    console.log(`    ✓ ${line.speaker}: ${text.substring(0, 40)}...`);
                } else {
                    errors++;
                    console.error(`    ✗ ${line.speaker}: ${result.error}`);
                }
            }
        }
    }

    return { generated, skipped, errors };
}

async function copyToAssets() {
    console.log('\n📋 Copying audio files to assets directory...');
    
    const srcDir = path.join(OUTPUT_BASE, 'sections');
    const destDir = path.join(ASSETS_DIR, 'sections');
    
    // Create destination directory
    if (!fs.existsSync(destDir)) {
        fs.mkdirSync(destDir, { recursive: true });
    }
    
    // Copy recursively
    function copyRecursive(src, dest) {
        const stat = fs.statSync(src);
        
        if (stat.isDirectory()) {
            if (!fs.existsSync(dest)) {
                fs.mkdirSync(dest, { recursive: true });
            }
            const files = fs.readdirSync(src);
            for (const file of files) {
                copyRecursive(path.join(src, file), path.join(dest, file));
            }
        } else if (src.endsWith('.mp3')) {
            fs.copyFileSync(src, dest);
        }
    }
    
    if (fs.existsSync(srcDir)) {
        copyRecursive(srcDir, destDir);
        console.log('✓ Audio files copied to assets/audio/sections/');
    }
}

async function updateJsonAudioUrls() {
    console.log('\n📝 Updating JSON files with audio URLs...');
    
    const sectionsDir = path.join(__dirname, '..', 'content', 'sections');
    const files = fs.readdirSync(sectionsDir)
        .filter(f => f.endsWith('.json'))
        .sort();
    
    for (const file of files) {
        const filePath = path.join(sectionsDir, file);
        const section = JSON.parse(fs.readFileSync(filePath, 'utf8'));
        const sectionId = section.id;
        let updated = false;
        
        // Update vocabulary audioUrls
        if (section.vocabulary) {
            for (const vocab of section.vocabulary) {
                const expectedPath = `assets/audio/sections/${sectionId}/vocabulary/${vocab.id}.mp3`;
                const audioFile = path.join(ASSETS_DIR, 'sections', sectionId, 'vocabulary', `${vocab.id}.mp3`);
                
                if (fs.existsSync(audioFile)) {
                    vocab.audioUrl = expectedPath;
                    updated = true;
                }
            }
        }
        
        // Update dialogue audioUrls
        if (section.dialogues) {
            for (const dialogue of section.dialogues) {
                for (let i = 0; i < dialogue.lines.length; i++) {
                    const line = dialogue.lines[i];
                    const lineId = `${dialogue.id}_line${i + 1}`;
                    const expectedPath = `assets/audio/sections/${sectionId}/dialogues/${lineId}.mp3`;
                    const audioFile = path.join(ASSETS_DIR, 'sections', sectionId, 'dialogues', `${lineId}.mp3`);
                    
                    if (fs.existsSync(audioFile)) {
                        line.audioUrl = expectedPath;
                        updated = true;
                    }
                }
            }
        }
        
        if (updated) {
            fs.writeFileSync(filePath, JSON.stringify(section, null, 4));
            console.log(`  ✓ Updated ${file}`);
        }
    }
}

async function main() {
    console.log('🎵 MedDeutsch Audio Generator\n');
    console.log('Using Google Cloud Text-to-Speech (de-DE Neural voices)\n');

    // Check for credentials
    if (!process.env.GOOGLE_APPLICATION_CREDENTIALS) {
        // Try to find Firebase Admin SDK key in project root
        const projectRoot = path.join(__dirname, '..');
        const keyFiles = fs.readdirSync(projectRoot)
            .filter(f => f.includes('firebase-adminsdk') && f.endsWith('.json'));
        
        if (keyFiles.length > 0) {
            const keyPath = path.join(projectRoot, keyFiles[0]);
            process.env.GOOGLE_APPLICATION_CREDENTIALS = keyPath;
            console.log(`Using credentials: ${keyFiles[0]}\n`);
        } else {
            console.error('❌ No Google Cloud credentials found.');
            console.error('Set GOOGLE_APPLICATION_CREDENTIALS or place a Firebase Admin SDK key in the project root.');
            process.exit(1);
        }
    }

    const sectionsDir = path.join(__dirname, '..', 'content', 'sections');
    const files = fs.readdirSync(sectionsDir)
        .filter(f => f.endsWith('.json'))
        .sort();

    console.log(`Found ${files.length} sections to process.\n`);

    let totalGenerated = 0;
    let totalSkipped = 0;
    let totalErrors = 0;

    for (const file of files) {
        const result = await processSection(path.join(sectionsDir, file));
        totalGenerated += result.generated;
        totalSkipped += result.skipped;
        totalErrors += result.errors;
    }

    console.log('\n' + '='.repeat(50));
    console.log('📊 Summary:');
    console.log(`   Generated: ${totalGenerated} files`);
    console.log(`   Skipped (already exist): ${totalSkipped} files`);
    if (totalErrors > 0) {
        console.log(`   Errors: ${totalErrors} files`);
    }

    // Copy to assets
    await copyToAssets();
    
    // Update JSON files with audio URLs
    await updateJsonAudioUrls();

    console.log('\n✅ Audio generation complete!');
    console.log(`
Next steps:
1. Run the audio upload script to upload to Firebase Storage:
   node upload_audio.js

2. Run the content upload script to update Firestore:
   node upload_to_firebase.js

3. Rebuild the Flutter app:
   flutter build ios --release
`);
}

main().catch(console.error);
