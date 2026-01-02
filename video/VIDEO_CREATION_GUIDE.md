# Video Content Creation Guide for MedDeutsch

## Directory Structure
Each section has a dedicated folder under `video/sections/section_XX/`:
- `intro.mp4` - Introduction video (2-3 min)
- `vocabulary.mp4` - Vocabulary demonstration (3-5 min)
- `dialogue.mp4` - Clinical dialogue demonstration (5-10 min)

## Recommended Tools for Video Creation

### AI Video Generation (Quick Setup)
1. **Synthesia.io** - AI avatars speaking German
2. **HeyGen** - AI presenter with German TTS
3. **D-ID** - AI-generated talking head videos

### Screen Recording + Editing
1. **OBS Studio** - Free screen recording
2. **DaVinci Resolve** - Free professional editing
3. **Kapwing** - Online video editor

### Stock Footage + Voiceover
1. **Pexels/Pixabay** - Free medical stock footage
2. **ElevenLabs** - High-quality German TTS for voiceovers

## Video Specifications
- Resolution: 1920x1080 (1080p)
- Format: MP4 (H.264)
- Audio: 48kHz, AAC
- Duration: 2-10 minutes per video

## Content Guidelines

### Intro Videos (2-3 min)
- Topic overview in German
- Learning objectives
- Key vocabulary preview

### Vocabulary Videos (3-5 min)
- Show each German term with pronunciation
- Visual representation (images, animations)
- Example sentences spoken clearly

### Dialogue Videos (5-10 min)
- Role-play clinical scenarios
- Show German text with translations
- Pause for learner repetition

## Quick Start Script

For each section, create a simple video using:
1. Canva (free) for slides + text
2. ElevenLabs for German voiceover
3. Kapwing to combine

Example workflow:
1. Create slides with vocabulary/dialogue in Canva
2. Generate German audio with ElevenLabs
3. Combine in Kapwing
4. Export as MP4
5. Upload to Firebase Storage

## Firebase Storage Path
Upload completed videos to:
```
gs://german-med.firebasestorage.app/video/sections/section_XX/intro.mp4
gs://german-med.firebasestorage.app/video/sections/section_XX/vocabulary.mp4
gs://german-med.firebasestorage.app/video/sections/section_XX/dialogue.mp4
```
