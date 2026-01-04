#!/bin/bash
# Audio Generation Script using macOS TTS with German voices
# Generates audio files for vocabulary and dialogues from all 55 sections

set -e

VOICE_MALE="Reed"
VOICE_FEMALE="Sandy"
AUDIO_DIR="audio/sections"
CONTENT_DIR="content/sections"

echo "🎵 MedDeutsch Audio Generator (macOS TTS)"
echo "Using voices: $VOICE_MALE (male), $VOICE_FEMALE (female)"
echo ""

mkdir -p "$AUDIO_DIR"
total=0

# Process each section JSON file
for json_file in "$CONTENT_DIR"/*.json; do
    # Extract section ID from the JSON content itself
    section_id=$(python3 -c "import json; print(json.load(open('$json_file'))['id'])" 2>/dev/null || echo "unknown")
    
    if [ "$section_id" = "unknown" ]; then
        echo "⚠️ Skipping $json_file - could not extract ID"
        continue
    fi
    
    echo "📁 Processing $section_id..."
    
    section_audio_dir="$AUDIO_DIR/$section_id"
    mkdir -p "$section_audio_dir/vocabulary"
    mkdir -p "$section_audio_dir/dialogues"
    
    # Extract and generate vocabulary audio
    python3 -c "
import json
data = json.load(open('$json_file'))
for v in data.get('vocabulary', []):
    vid = v.get('id', '')
    term = v.get('germanTerm', '')
    sentence = v.get('exampleSentence', '')
    if vid and term:
        print(f'VOCAB|{vid}|{term}')
    if vid and sentence:
        print(f'SENTENCE|{vid}_example|{sentence}')
for d in data.get('dialogues', []):
    did = d.get('id', '')
    for i, line in enumerate(d.get('lines', [])):
        speaker = line.get('speaker', '')
        text = line.get('germanText', '')
        if did and text:
            print(f'DIALOGUE|{did}_line{i+1}|{speaker}|{text}')
" 2>/dev/null | while IFS='|' read -r type id speaker_or_term text_or_empty; do
        case "$type" in
            VOCAB)
                output_file="$section_audio_dir/vocabulary/${id}.m4a"
                if [ ! -f "$output_file" ]; then
                    say -v "$VOICE_MALE" -r 150 -o "$output_file" "$speaker_or_term" 2>/dev/null && \
                    echo "  ✓ $speaker_or_term" || echo "  ✗ $speaker_or_term"
                fi
                ;;
            SENTENCE)
                output_file="$section_audio_dir/vocabulary/${id}.m4a"
                if [ ! -f "$output_file" ]; then
                    say -v "$VOICE_FEMALE" -r 140 -o "$output_file" "$speaker_or_term" 2>/dev/null && \
                    echo "  ✓ Sentence: ${speaker_or_term:0:30}..." || true
                fi
                ;;
            DIALOGUE)
                output_file="$section_audio_dir/dialogues/${id}.m4a"
                if [ ! -f "$output_file" ]; then
                    if [[ "$speaker_or_term" == *"Arzt"* ]] || [[ "$speaker_or_term" == *"Dr."* ]]; then
                        voice="$VOICE_MALE"
                    else
                        voice="$VOICE_FEMALE"
                    fi
                    say -v "$voice" -r 140 -o "$output_file" "$text_or_empty" 2>/dev/null && \
                    echo "  ✓ $speaker_or_term: ${text_or_empty:0:30}..." || true
                fi
                ;;
        esac
    done
done

echo ""
echo "✅ Audio generation complete!"
echo ""
total_files=$(find "$AUDIO_DIR" -name "*.m4a" | wc -l)
echo "📊 Total audio files: $total_files"
