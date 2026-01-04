#!/bin/bash
# Create video directory structure for all sections
# Videos can be generated later using video creation tools

VIDEO_DIR="video/sections"

echo "📹 Creating video directory structure..."
echo ""

for i in $(seq -w 1 55); do
    section_dir="$VIDEO_DIR/section_$i"
    mkdir -p "$section_dir"
    
    # Create placeholder info files
    cat > "$section_dir/README.md" << EOF
# Section $i Videos

## Required Videos

1. **intro.mp4** - Introduction video (2-3 min)
   - Topic overview in German
   - Learning objectives
   - Key vocabulary preview

2. **vocabulary.mp4** - Vocabulary video (3-5 min)
   - Each German term with pronunciation
   - Visual representations
   - Example sentences

3. **dialogue.mp4** - Dialogue video (5-10 min)
   - Role-play clinical scenarios
   - German text with translations
   - Pause for learner repetition

## Audio Available
Audio files for this section are in: \`audio/sections/section_$i/\`

Use these audio files as voiceover for video creation.
EOF
    echo "  ✓ Created $section_dir"
done

echo ""
echo "✅ Video directory structure created!"
echo ""
total=$(find "$VIDEO_DIR" -name "README.md" | wc -l)
echo "📊 Created $total section directories with README templates"
echo ""
echo "📋 Next steps for video creation:"
echo "   1. Use audio files as voiceover"
echo "   2. Create slides/animations with Canva"
echo "   3. Generate AI videos with Synthesia/HeyGen"
echo "   4. Export as MP4 (1920x1080)"
