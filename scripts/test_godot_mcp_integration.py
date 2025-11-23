#!/usr/bin/env python3
"""
Godot MCP Integration Test
Tests the integration between GitHub Agent and Godot MCP Server
"""

import json
import os
import subprocess
import sys
from pathlib import Path

class GodotMCPIntegrationTest:
    def __init__(self, project_root: str):
        self.project_root = Path(project_root)
        self.godot_project = self.project_root / "projeto_godot"
        self.mcp_server = self.project_root / "godot-mcp-server"
        self.results = {
            "tests_passed": 0,
            "tests_failed": 0,
            "tests_total": 0,
            "details": []
        }
    
    def run_test(self, name: str, func) -> bool:
        """Run a single test"""
        self.results["tests_total"] += 1
        try:
            print(f"🧪 Testing: {name}...")
            result = func()
            if result:
                print(f"   ✅ PASSED")
                self.results["tests_passed"] += 1
                self.results["details"].append({
                    "name": name,
                    "status": "PASSED",
                    "message": "Test completed successfully"
                })
                return True
            else:
                print(f"   ❌ FAILED")
                self.results["tests_failed"] += 1
                self.results["details"].append({
                    "name": name,
                    "status": "FAILED",
                    "message": "Test returned False"
                })
                return False
        except Exception as e:
            print(f"   ❌ ERROR: {e}")
            self.results["tests_failed"] += 1
            self.results["details"].append({
                "name": name,
                "status": "ERROR",
                "message": str(e)
            })
            return False
    
    def test_project_structure(self) -> bool:
        """Test that project structure is correct"""
        required_paths = [
            self.godot_project / "project.godot",
            self.godot_project / "scenes" / "Main.tscn",
            self.godot_project / "scripts",
            self.mcp_server / "package.json",
            self.mcp_server / "build" / "index.js"
        ]
        
        for path in required_paths:
            if not path.exists():
                print(f"      Missing: {path}")
                return False
        
        return True
    
    def test_mcp_server_build(self) -> bool:
        """Test that MCP server is built"""
        build_dir = self.mcp_server / "build"
        if not build_dir.exists():
            return False
        
        required_files = ["index.js", "config.js", "processManager.js"]
        for file in required_files:
            if not (build_dir / file).exists():
                print(f"      Missing build file: {file}")
                return False
        
        return True
    
    def test_godot_scripts_syntax(self) -> bool:
        """Test that all GDScript files have valid syntax"""
        validation_report = self.project_root / "scripts" / "validation_report.json"
        
        if not validation_report.exists():
            print("      Validation report not found, running validation...")
            result = subprocess.run(
                ["python3", "scripts/validate_godot_project.py", "projeto_godot"],
                cwd=self.project_root,
                capture_output=True
            )
            if result.returncode != 0:
                return False
        
        with open(validation_report, 'r') as f:
            report = json.load(f)
        
        return report.get('errors', 1) == 0
    
    def test_level_files_present(self) -> bool:
        """Test that all level files are present"""
        levels = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]
        scripts_dir = self.godot_project / "scripts"
        
        for level in levels:
            level_file = scripts_dir / f"Level{level}.gd"
            if not level_file.exists():
                print(f"      Missing level: Level{level}.gd")
                return False
        
        return True
    
    def test_core_systems_present(self) -> bool:
        """Test that core game systems are present"""
        core_systems = [
            "GameManager.gd",
            "LevelManager.gd",
            "PlayerController.gd",
            "DragAndDropSystem.gd",
            "LanguageAbilitySystem.gd"
        ]
        
        scripts_dir = self.godot_project / "scripts"
        
        for system in core_systems:
            system_file = scripts_dir / system
            if not system_file.exists():
                print(f"      Missing core system: {system}")
                return False
        
        return True
    
    def test_mcp_addon_present(self) -> bool:
        """Test that MCP addon is present"""
        mcp_addon = self.godot_project / "addons" / "mcp_server.gd"
        return mcp_addon.exists()
    
    def test_package_dependencies(self) -> bool:
        """Test that MCP server has dependencies installed"""
        node_modules = self.mcp_server / "node_modules"
        return node_modules.exists()
    
    def test_configuration_files(self) -> bool:
        """Test that configuration files are present"""
        configs = [
            self.project_root / "claude_desktop_config_core_descent.json",
            self.mcp_server / "mcp-config.json"
        ]
        
        for config in configs:
            if not config.exists():
                print(f"      Missing config: {config}")
                return False
        
        return True
    
    def test_documentation_present(self) -> bool:
        """Test that key documentation files are present"""
        docs = [
            self.project_root / "README.md",
            self.project_root / "GUIA_GODOT_MCP.md",
            self.mcp_server / "README.md"
        ]
        
        for doc in docs:
            if not doc.exists():
                print(f"      Missing documentation: {doc}")
                return False
        
        return True
    
    def run_all_tests(self):
        """Run all integration tests"""
        print("\n" + "="*80)
        print("🚀 GODOT MCP INTEGRATION TEST SUITE")
        print("="*80 + "\n")
        
        # Run tests
        self.run_test("Project Structure", self.test_project_structure)
        self.run_test("MCP Server Build", self.test_mcp_server_build)
        self.run_test("GDScript Syntax Validation", self.test_godot_scripts_syntax)
        self.run_test("Level Files Present", self.test_level_files_present)
        self.run_test("Core Systems Present", self.test_core_systems_present)
        self.run_test("MCP Addon Present", self.test_mcp_addon_present)
        self.run_test("Package Dependencies", self.test_package_dependencies)
        self.run_test("Configuration Files", self.test_configuration_files)
        self.run_test("Documentation Present", self.test_documentation_present)
        
        # Print summary
        print("\n" + "="*80)
        print("📊 TEST SUMMARY")
        print("="*80)
        print(f"Total Tests: {self.results['tests_total']}")
        print(f"✅ Passed: {self.results['tests_passed']}")
        print(f"❌ Failed: {self.results['tests_failed']}")
        print(f"Success Rate: {self.results['tests_passed']/self.results['tests_total']*100:.1f}%")
        print("="*80 + "\n")
        
        # Save results
        results_path = self.project_root / "scripts" / "integration_test_results.json"
        with open(results_path, 'w') as f:
            json.dump(self.results, f, indent=2)
        
        print(f"📄 Results saved to: {results_path}\n")
        
        # Return success/failure
        return self.results['tests_failed'] == 0

def main():
    # Get project root
    if len(sys.argv) > 1:
        project_root = sys.argv[1]
    else:
        project_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    
    # Run tests
    tester = GodotMCPIntegrationTest(project_root)
    success = tester.run_all_tests()
    
    # Exit with appropriate code
    sys.exit(0 if success else 1)

if __name__ == '__main__':
    main()
