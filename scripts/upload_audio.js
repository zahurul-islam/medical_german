#!/usr/bin/env node
/**
 * Upload audio files to Firebase Storage
 * Uses firebase-admin SDK instead of gsutil
 */

const admin = require('firebase-admin');
const fs = require('fs');
const path = require('path');

admin.initializeApp({
    credential: admin.credential.applicationDefault(),
    storageBucket: 'german-med.firebasestorage.app'
});

const bucket = admin.storage().bucket();

async function uploadFile(localPath, remotePath) {
    try {
        await bucket.upload(localPath, {
            destination: remotePath,
            metadata: {
                contentType: 'audio/mpeg',
                cacheControl: 'public, max-age=31536000'
            }
        });
        return true;
    } catch (err) {
        console.error(`  ✗ ${path.basename(localPath)}: ${err.message}`);
        return false;
    }
}

async function uploadDirectory(localDir, remoteDir) {
    const files = fs.readdirSync(localDir);
    let uploaded = 0;
    let failed = 0;

    for (const file of files) {
        const localPath = path.join(localDir, file);
        const stat = fs.statSync(localPath);

        if (stat.isDirectory()) {
            const result = await uploadDirectory(localPath, `${remoteDir}/${file}`);
            uploaded += result.uploaded;
            failed += result.failed;
        } else if (file.endsWith('.mp3')) {
            const success = await uploadFile(localPath, `${remoteDir}/${file}`);
            if (success) {
                uploaded++;
                process.stdout.write(`\r  Uploaded: ${uploaded} files...`);
            } else {
                failed++;
            }
        }
    }

    return { uploaded, failed };
}

async function main() {
    console.log('🎵 Uploading audio files to Firebase Storage\n');

    const audioDir = 'audio';
    if (!fs.existsSync(audioDir)) {
        console.error('❌ Audio directory not found. Run generate_audio.js first.');
        process.exit(1);
    }

    const result = await uploadDirectory(audioDir, 'audio');

    console.log(`\n\n✅ Upload complete!`);
    console.log(`   Uploaded: ${result.uploaded} files`);
    if (result.failed > 0) {
        console.log(`   Failed: ${result.failed} files`);
    }
}

main().catch(console.error);
