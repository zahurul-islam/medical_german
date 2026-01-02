const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

// Configuration
const FFMPEG_PATH = '/opt/homebrew/opt/ffmpeg/bin/ffmpeg';
const FONT_PATH = '/System/Library/Fonts/Helvetica.ttc';
const CONTENT_DIR = path.join(__dirname, '../content/sections');
const AUDIO_DIR = path.join(__dirname, '../assets/audio/sections');
const VIDEO_DIR = path.join(__dirname, '../assets/video/sections');

// Ensure video directory exists
if (!fs.existsSync(VIDEO_DIR)) {
    fs.mkdirSync(VIDEO_DIR, { recursive: true });
}

function generateVideo(text, audioPath, outputPath) {
    try {
        // Escape text for ffmpeg
        const escapedText = text.replace(/'/g, "'\\''").replace(/:/g, "\\:");

        // Use proper font path and handle spaces
        const cmd = `"${FFMPEG_PATH}" -y -f lavfi -i color=c=0x005696:s=1280x720 -i "${audioPath}" -vf "drawtext=text='${escapedText}':fontfile='${FONT_PATH}':fontcolor=white:fontsize=48:x=(w-text_w)/2:y=(h-text_h)/2" -c:v libx264 -pix_fmt yuv420p -c:a aac -shortest "${outputPath}"`;

        execSync(cmd, { stdio: 'pipe' });
        console.log(`  ✅ Generated: ${path.basename(outputPath)}`);
        return true;
    } catch (error) {
        return false;
    }
}

async function main() {
    console.log('🎥 MedDeutsch Video Generator');
    console.log('=============================\n');

    if (!fs.existsSync(FFMPEG_PATH)) {
        console.error(`❌ ffmpeg not found at ${FFMPEG_PATH}. Please install it or update path.`);
        process.exit(1);
    }

    const sections = fs.readdirSync(CONTENT_DIR).filter(f => f.endsWith('.json'));

    for (const sectionFile of sections) {
        // Extract section number from "section_01_greetings.json" -> "01"
        const sectionIdFull = sectionFile.replace('.json', '');
        const parts = sectionIdFull.split('_');
        const sectionNum = parts[1]; // "01"

        if (!sectionNum || isNaN(parseInt(sectionNum))) {
            console.warn(`Skipping malformed filename: ${sectionFile}`);
            continue;
        }

        const sectionId = sectionNum; // e.g. "01" for paths
        const sectionPath = path.join(CONTENT_DIR, sectionFile);
        const sectionData = JSON.parse(fs.readFileSync(sectionPath, 'utf8'));

        console.log(`Processing Section ${sectionNum}: ${sectionData.title.en}`);

        const sectionVideoDir = path.join(VIDEO_DIR, `section_${sectionNum}`);
        if (!fs.existsSync(sectionVideoDir)) {
            fs.mkdirSync(sectionVideoDir, { recursive: true });
        }

        // 1. Generate Dialogue Videos
        if (sectionData.dialogues && sectionData.dialogues.length > 0) {
            process.stdout.write('  Creating dialogue videos... ');
            let count = 0;
            for (const dialogue of sectionData.dialogues) {
                for (let i = 0; i < dialogue.lines.length; i++) {
                    const line = dialogue.lines[i];
                    // Check if audio exists - dialogue.id already contains prefix usually
                    const audioFilename = `${dialogue.id}_line${i + 1}.mp3`;
                    const audioPath = path.join(AUDIO_DIR, `section_${sectionId}`, 'dialogues', audioFilename);

                    if (fs.existsSync(audioPath)) {
                        const videoPath = path.join(sectionVideoDir, `dialogue_${dialogue.id}_line${i + 1}.mp4`);
                        if (!fs.existsSync(videoPath)) {
                            generateVideo(line.german, audioPath, videoPath);
                            count++;
                        }
                    }
                }
            }
            console.log(`${count} created.`);
        }

        // 2. Vocabulary Videos (Sample first 3)
        if (sectionData.vocabulary && sectionData.vocabulary.length > 0) {
            process.stdout.write('  Creating vocabulary videos... ');
            let count = 0;
            for (let i = 0; i < Math.min(3, sectionData.vocabulary.length); i++) {
                const vocab = sectionData.vocabulary[i];
                const audioFilename = `v${sectionId}_${(i + 1).toString().padStart(2, '0')}.mp3`;
                const audioPath = path.join(AUDIO_DIR, `section_${sectionId}`, 'vocabulary', audioFilename);

                if (fs.existsSync(audioPath)) {
                    const videoPath = path.join(sectionVideoDir, `vocab_${i + 1}.mp4`);
                    if (!fs.existsSync(videoPath)) {
                        generateVideo(vocab.german, audioPath, videoPath);
                        count++;
                    }
                }
            }
            console.log(`${count} created.`);
        }
    }
}

main();
