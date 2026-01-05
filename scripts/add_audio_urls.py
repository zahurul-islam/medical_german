#!/usr/bin/env python3
"""
Add audioUrl fields to all dialogue lines in section JSON files.
Audio files follow naming convention: d{section}_{dialogue}_line{n}.mp3
"""

import json
import os
from pathlib import Path

CONTENT_DIR = Path(__file__).parent.parent / "content" / "sections"
AUDIO_BASE_PATH = "assets/audio/sections"

def add_audio_urls_to_section(json_path: Path):
    """Add audioUrl fields to dialogues in a section JSON file."""
    
    # Extract section number from filename
    filename = json_path.stem  # e.g., "section_01_greetings" or "section_19"
    parts = filename.split('_')
    section_num = parts[1]  # e.g., "01" or "19"
    
    # Handle section_01a case
    if 'a' in section_num:
        print(f"  Skipping {filename} (already processed)")
        return False
    
    with open(json_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    dialogues = data.get('dialogues', [])
    if not dialogues:
        print(f"  No dialogues in {filename}")
        return False
    
    modified = False
    for d_idx, dialogue in enumerate(dialogues, 1):
        dialogue_id = f"d{section_num}_{d_idx:02d}"
        
        # Add audioUrl to each dialogue line
        lines = dialogue.get('lines', [])
        for l_idx, line in enumerate(lines, 1):
            audio_path = f"{AUDIO_BASE_PATH}/section_{section_num}/dialogues/{dialogue_id}_line{l_idx}.mp3"
            if 'audioUrl' not in line or line.get('audioUrl') != audio_path:
                line['audioUrl'] = audio_path
                modified = True
    
    if modified:
        with open(json_path, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=4)
        print(f"  ✓ Updated {filename} ({len(dialogues)} dialogues)")
    else:
        print(f"  - {filename} (no changes needed)")
    
    return modified

def main():
    print("Adding audio URLs to dialogue lines in all sections...")
    print("=" * 60)
    
    json_files = sorted(CONTENT_DIR.glob("section_*.json"))
    updated_count = 0
    
    for json_path in json_files:
        if add_audio_urls_to_section(json_path):
            updated_count += 1
    
    print("=" * 60)
    print(f"Updated {updated_count} section files.")

if __name__ == "__main__":
    main()
