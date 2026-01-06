#!/usr/bin/env node
/**
 * Translate Learning Objectives and Grammar Focus into all supported languages
 * Uses Google Cloud Translation API
 */

const { Translate } = require('@google-cloud/translate').v2;
const fs = require('fs');
const path = require('path');

// Initialize translator
const translate = new Translate();

// Language codes mapping
const LANGUAGES = {
    'bn': 'bn',  // Bengali
    'hi': 'hi',  // Hindi
    'ur': 'ur',  // Urdu
    'tr': 'tr',  // Turkish
};

async function translateText(text, targetLang) {
    if (!text || text.trim() === '') return '';
    
    try {
        const [translation] = await translate.translate(text, targetLang);
        return translation;
    } catch (err) {
        console.error(`  ✗ Translation error for ${targetLang}: ${err.message}`);
        return text; // Return original on error
    }
}

async function translateLearningObjectives(objectives, existingTranslations = {}) {
    const result = {
        en: objectives,
        bn: [],
        hi: [],
        ur: [],
        tr: []
    };

    console.log(`    Translating ${objectives.length} learning objectives...`);
    
    for (const objective of objectives) {
        for (const [langKey, langCode] of Object.entries(LANGUAGES)) {
            // Check if already has a proper translation (not mixed with English)
            const existing = existingTranslations[langKey]?.[objectives.indexOf(objective)];
            if (existing && !existing.includes('appropriately') && !existing.includes('German')) {
                result[langKey].push(existing);
            } else {
                const translated = await translateText(objective, langCode);
                result[langKey].push(translated);
                // Add small delay to avoid rate limiting
                await new Promise(r => setTimeout(r, 100));
            }
        }
    }

    return result;
}

async function translateGrammarFocus(grammarEn, existingTranslations = {}) {
    const result = { en: grammarEn };

    console.log(`    Translating grammar focus (${grammarEn.length} chars)...`);
    
    for (const [langKey, langCode] of Object.entries(LANGUAGES)) {
        // Check if already has a proper translation (not same as English)
        const existing = existingTranslations[langKey];
        if (existing && existing !== grammarEn && !existing.startsWith('**Formal vs.')) {
            result[langKey] = existing;
        } else {
            result[langKey] = await translateText(grammarEn, langCode);
            // Add delay to avoid rate limiting
            await new Promise(r => setTimeout(r, 200));
        }
    }

    return result;
}

async function processSection(filePath) {
    const section = JSON.parse(fs.readFileSync(filePath, 'utf8'));
    const sectionId = section.id;
    console.log(`\n📁 Processing ${sectionId}...`);

    let modified = false;

    if (section.textContent) {
        // Translate Learning Objectives
        const learningObjs = section.textContent.learningObjectives;
        if (learningObjs) {
            // Get English objectives
            const englishObjs = Array.isArray(learningObjs) 
                ? learningObjs 
                : (learningObjs.en || []);
            
            if (englishObjs.length > 0) {
                const translatedObjs = await translateLearningObjectives(
                    englishObjs, 
                    Array.isArray(learningObjs) ? {} : learningObjs
                );
                section.textContent.learningObjectives = translatedObjs;
                modified = true;
            }
        }

        // Translate Grammar Focus
        const grammarFocus = section.textContent.grammarFocus;
        if (grammarFocus) {
            const englishGrammar = typeof grammarFocus === 'string' 
                ? grammarFocus 
                : (grammarFocus.en || grammarFocus.de || '');
            
            if (englishGrammar) {
                const translatedGrammar = await translateGrammarFocus(
                    englishGrammar,
                    typeof grammarFocus === 'string' ? {} : grammarFocus
                );
                section.textContent.grammarFocus = translatedGrammar;
                modified = true;
            }
        }
    }

    if (modified) {
        fs.writeFileSync(filePath, JSON.stringify(section, null, 4), 'utf8');
        console.log(`  ✓ Saved translations for ${sectionId}`);
    }

    return modified;
}

async function main() {
    console.log('🌐 MedDeutsch Content Translator\n');
    console.log('Using Google Cloud Translation API\n');
    console.log('=' .repeat(50));

    // Check for credentials
    if (!process.env.GOOGLE_APPLICATION_CREDENTIALS) {
        const projectRoot = path.join(__dirname, '..');
        const keyFiles = fs.readdirSync(projectRoot)
            .filter(f => f.includes('firebase-adminsdk') && f.endsWith('.json'));
        
        if (keyFiles.length > 0) {
            process.env.GOOGLE_APPLICATION_CREDENTIALS = path.join(projectRoot, keyFiles[0]);
            console.log(`Using credentials: ${keyFiles[0]}\n`);
        } else {
            console.error('❌ No Google Cloud credentials found.');
            process.exit(1);
        }
    }

    const sectionsDir = path.join(__dirname, '..', 'content', 'sections');
    const files = fs.readdirSync(sectionsDir)
        .filter(f => f.endsWith('.json'))
        .sort();

    console.log(`Found ${files.length} sections to translate.\n`);

    let translatedCount = 0;
    
    for (const file of files) {
        try {
            const modified = await processSection(path.join(sectionsDir, file));
            if (modified) translatedCount++;
        } catch (err) {
            console.error(`  ✗ Error processing ${file}: ${err.message}`);
        }
    }

    console.log('\n' + '='.repeat(50));
    console.log(`\n✅ Translation complete!`);
    console.log(`   Translated: ${translatedCount} sections`);
    console.log(`
Next steps:
1. Upload content to Firestore: node upload_to_firebase.js
2. Rebuild the app: flutter run -d <device> --release
`);
}

main().catch(console.error);


