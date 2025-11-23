#!/usr/bin/env python3
"""
Fix tabs in GDScript files
Converts tabs to spaces (Godot standard is 4 spaces per tab)
"""

import sys
from pathlib import Path

def fix_tabs_in_file(file_path: Path, tab_size: int = 4) -> bool:
    """Convert tabs to spaces in a file"""
    try:
        content = file_path.read_text(encoding='utf-8')
        original_content = content
        
        # Replace tabs with spaces
        fixed_content = content.replace('\t', ' ' * tab_size)
        
        if fixed_content != original_content:
            file_path.write_text(fixed_content, encoding='utf-8')
            return True
        return False
    except Exception as e:
        print(f"Error processing {file_path}: {e}")
        return False

def main():
    if len(sys.argv) < 2:
        print("Usage: fix_tabs.py <directory>")
        sys.exit(1)
    
    root = Path(sys.argv[1])
    if not root.exists():
        print(f"Directory not found: {root}")
        sys.exit(1)
    
    # Find all GDScript files
    gd_files = list(root.rglob("*.gd"))
    
    print(f"🔧 Fixing tabs in {len(gd_files)} GDScript files...")
    
    fixed_count = 0
    for gd_file in gd_files:
        if fix_tabs_in_file(gd_file):
            print(f"   ✓ Fixed: {gd_file.relative_to(root)}")
            fixed_count += 1
    
    print(f"\n✅ Fixed {fixed_count} files")

if __name__ == '__main__':
    main()
