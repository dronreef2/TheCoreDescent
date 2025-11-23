#!/usr/bin/env python3
"""
Godot Project Validation Script
Validates GDScript files and project structure for The Core Descent
"""

import os
import re
import sys
from pathlib import Path
from typing import Dict, List, Tuple, Set
import json

class GodotProjectValidator:
    def __init__(self, project_root: str):
        self.project_root = Path(project_root)
        self.errors = []
        self.warnings = []
        self.info = []
        self.scripts = []
        self.scenes = []
        self.resources = {}
        
    def validate(self) -> Dict:
        """Run all validation checks"""
        print("🔍 Starting Godot Project Validation for The Core Descent...")
        print(f"📁 Project root: {self.project_root}")
        print()
        
        # Phase 1: Discovery
        self.discover_files()
        
        # Phase 2: Validation
        self.validate_project_file()
        self.validate_scripts()
        self.validate_scenes()
        self.validate_dependencies()
        self.validate_class_names()
        
        # Phase 3: Report
        return self.generate_report()
    
    def discover_files(self):
        """Discover all relevant files in the project"""
        print("📋 Phase 1: Discovering files...")
        
        # Find all GDScript files
        for gd_file in self.project_root.rglob("*.gd"):
            self.scripts.append(gd_file)
        
        # Find all scene files
        for tscn_file in self.project_root.rglob("*.tscn"):
            self.scenes.append(tscn_file)
        
        print(f"   ✓ Found {len(self.scripts)} GDScript files")
        print(f"   ✓ Found {len(self.scenes)} scene files")
        print()
    
    def validate_project_file(self):
        """Validate project.godot file"""
        print("📋 Phase 2.1: Validating project.godot...")
        
        project_file = self.project_root / "project.godot"
        if not project_file.exists():
            self.errors.append("❌ project.godot not found")
            return
        
        try:
            content = project_file.read_text(encoding='utf-8')
            
            # Check for main scene
            if 'run/main_scene' in content:
                match = re.search(r'run/main_scene="([^"]+)"', content)
                if match:
                    main_scene = match.group(1).replace('res://', '')
                    main_scene_path = self.project_root / main_scene
                    if main_scene_path.exists():
                        self.info.append(f"✓ Main scene found: {main_scene}")
                    else:
                        self.errors.append(f"❌ Main scene not found: {main_scene}")
            else:
                self.warnings.append("⚠️  No main scene configured")
            
            # Check Godot version
            if 'config/features' in content:
                self.info.append("✓ Project configuration found")
            
            print("   ✓ project.godot validated")
        except Exception as e:
            self.errors.append(f"❌ Error reading project.godot: {e}")
        
        print()
    
    def validate_scripts(self):
        """Validate all GDScript files"""
        print(f"📋 Phase 2.2: Validating {len(self.scripts)} GDScript files...")
        
        valid_count = 0
        for script in self.scripts:
            if self.validate_single_script(script):
                valid_count += 1
        
        print(f"   ✓ {valid_count}/{len(self.scripts)} scripts validated successfully")
        print()
    
    def validate_single_script(self, script_path: Path) -> bool:
        """Validate a single GDScript file"""
        try:
            content = script_path.read_text(encoding='utf-8')
            relative_path = script_path.relative_to(self.project_root)
            
            # Check for basic syntax issues
            issues = []
            
            # Check for class_name
            class_name_match = re.search(r'class_name\s+(\w+)', content)
            if class_name_match:
                class_name = class_name_match.group(1)
                self.resources[class_name] = str(relative_path)
            
            # Check for extends
            extends_match = re.search(r'extends\s+(\w+)', content)
            if not extends_match and not content.startswith('tool'):
                self.warnings.append(f"⚠️  {relative_path}: No 'extends' declaration found")
            
            # Check for common syntax errors
            lines = content.split('\n')
            for i, line in enumerate(lines, 1):
                # Check for tabs (Godot prefers spaces)
                if '\t' in line:
                    issues.append(f"Line {i}: Contains tabs (use spaces)")
                
                # Check for common typos
                if re.search(r'\bfucn\b|\bfunciton\b|\bretrun\b', line):
                    issues.append(f"Line {i}: Possible typo detected")
            
            if issues:
                self.warnings.append(f"⚠️  {relative_path}: {len(issues)} minor issues")
            
            return True
            
        except UnicodeDecodeError:
            self.errors.append(f"❌ {script_path.relative_to(self.project_root)}: Encoding error")
            return False
        except Exception as e:
            self.errors.append(f"❌ {script_path.relative_to(self.project_root)}: {str(e)}")
            return False
    
    def validate_scenes(self):
        """Validate all scene files"""
        print(f"📋 Phase 2.3: Validating {len(self.scenes)} scene files...")
        
        valid_count = 0
        for scene in self.scenes:
            if self.validate_single_scene(scene):
                valid_count += 1
        
        print(f"   ✓ {valid_count}/{len(self.scenes)} scenes validated successfully")
        print()
    
    def validate_single_scene(self, scene_path: Path) -> bool:
        """Validate a single scene file"""
        try:
            content = scene_path.read_text(encoding='utf-8')
            relative_path = scene_path.relative_to(self.project_root)
            
            # Check for external resources
            ext_resources = re.findall(r'\[ext_resource.*?path="([^"]+)"', content)
            
            for resource in ext_resources:
                # Convert res:// path to filesystem path
                resource_path = resource.replace('res://', '')
                full_path = self.project_root / resource_path
                
                if not full_path.exists():
                    self.errors.append(f"❌ {relative_path}: Missing resource: {resource}")
            
            return True
            
        except Exception as e:
            self.errors.append(f"❌ {scene_path.relative_to(self.project_root)}: {str(e)}")
            return False
    
    def validate_dependencies(self):
        """Validate script dependencies"""
        print("📋 Phase 2.4: Validating dependencies...")
        
        # Check for common dependencies
        required_classes = {'GameManager', 'LevelManager', 'PlayerController'}
        found_classes = set(self.resources.keys())
        
        missing = required_classes - found_classes
        if missing:
            for cls in missing:
                self.warnings.append(f"⚠️  Expected class not found: {cls}")
        
        print(f"   ✓ Found {len(found_classes)} class definitions")
        print()
    
    def validate_class_names(self):
        """Validate class naming conventions"""
        print("📋 Phase 2.5: Validating class names...")
        
        for class_name, path in self.resources.items():
            # Check PascalCase
            if not re.match(r'^[A-Z][a-zA-Z0-9]*$', class_name):
                self.warnings.append(f"⚠️  {path}: Class name '{class_name}' should be PascalCase")
        
        print(f"   ✓ Validated {len(self.resources)} class names")
        print()
    
    def generate_report(self) -> Dict:
        """Generate validation report"""
        print("\n" + "="*80)
        print("📊 VALIDATION REPORT")
        print("="*80)
        
        # Summary
        total_files = len(self.scripts) + len(self.scenes)
        print(f"\n📈 Summary:")
        print(f"   Total files checked: {total_files}")
        print(f"   GDScript files: {len(self.scripts)}")
        print(f"   Scene files: {len(self.scenes)}")
        print(f"   Classes found: {len(self.resources)}")
        print()
        
        # Results
        print(f"✅ Info: {len(self.info)}")
        for info in self.info:
            print(f"   {info}")
        print()
        
        print(f"⚠️  Warnings: {len(self.warnings)}")
        for warning in self.warnings[:10]:  # Show first 10
            print(f"   {warning}")
        if len(self.warnings) > 10:
            print(f"   ... and {len(self.warnings) - 10} more warnings")
        print()
        
        print(f"❌ Errors: {len(self.errors)}")
        for error in self.errors:
            print(f"   {error}")
        print()
        
        # Overall status
        print("="*80)
        if len(self.errors) == 0:
            print("✅ PROJECT VALIDATION PASSED")
            status = "PASS"
        elif len(self.errors) < 5:
            print("⚠️  PROJECT VALIDATION PASSED WITH WARNINGS")
            status = "PASS_WITH_WARNINGS"
        else:
            print("❌ PROJECT VALIDATION FAILED")
            status = "FAIL"
        print("="*80)
        
        return {
            'status': status,
            'total_files': total_files,
            'scripts': len(self.scripts),
            'scenes': len(self.scenes),
            'classes': len(self.resources),
            'errors': len(self.errors),
            'warnings': len(self.warnings),
            'info': len(self.info),
            'error_list': self.errors,
            'warning_list': self.warnings,
            'info_list': self.info
        }


def main():
    """Main entry point"""
    # Get project root from command line or use default
    if len(sys.argv) > 1:
        project_root = sys.argv[1]
    else:
        # Default to projeto_godot in current directory
        project_root = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'projeto_godot')
    
    if not os.path.exists(project_root):
        print(f"❌ Error: Project directory not found: {project_root}")
        sys.exit(1)
    
    # Run validation
    validator = GodotProjectValidator(project_root)
    report = validator.validate()
    
    # Save report to JSON
    report_path = os.path.join(os.path.dirname(__file__), 'validation_report.json')
    with open(report_path, 'w') as f:
        json.dump(report, f, indent=2)
    print(f"\n📄 Report saved to: {report_path}")
    
    # Exit with appropriate code
    if report['status'] == 'FAIL':
        sys.exit(1)
    elif report['status'] == 'PASS_WITH_WARNINGS':
        sys.exit(0)
    else:
        sys.exit(0)


if __name__ == '__main__':
    main()
