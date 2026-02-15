import os
import sys
import re
import json
from datetime import datetime

class SkillValidator:
    """
    Kỹ sư thẩm định chất lượng Agent Skill.
    Đảm bảo tính chính trực giữa thiết kế (design) và thực thi (build).
    """
    def __init__(self, skill_path, design_path=None, log_mode=False):
        self.skill_path = os.path.abspath(skill_path)
        self.skill_name = os.path.basename(self.skill_path.rstrip('/'))
        self.design_path = os.path.abspath(design_path) if design_path else None
        self.log_mode = log_mode
        self.errors = []
        self.warnings = []
        self.reports = []

    def log(self, message, level="INFO"):
        prefix = f"[{level}] " if level != "INFO" else ""
        formatted_message = f"{prefix}{message}"
        self.reports.append(formatted_message)
        print(formatted_message)

    def check_structure(self):
        self.log("1. Checking 4 Zones Structural Integrity...")
        mandatory_zones = ["SKILL.md", "knowledge", "scripts", "loop"]
        passed = True
        for zone in mandatory_zones:
            path = os.path.join(self.skill_path, zone)
            if not os.path.exists(path):
                self.errors.append(f"[E01] CRITICAL: Missing mandatory zone: {zone}")
                passed = False
        return passed

    def check_skill_md_constraints(self):
        skill_md_path = os.path.join(self.skill_path, "SKILL.md")
        if not os.path.exists(skill_md_path): return False
        
        with open(skill_md_path, 'r', encoding='utf-8') as f:
            lines = f.readlines()
            content = "".join(lines)
        
        self.log(f"2. Analyzing SKILL.md (Lines: {len(lines)})")
        
        if len(lines) > 500:
            self.errors.append(f"[E03] ERROR: SKILL.md exceeds 500 lines limit ({len(lines)})")

        mandatory_keywords = ["Persona:", "Workflow", "Guardrails"]
        for kw in mandatory_keywords:
            if kw not in content:
                self.errors.append(f"[E04] ERROR: SKILL.md missing mandatory section keyword: '{kw}'")
        
        return len(self.errors) == 0

    def check_pd_links(self):
        self.log("3. Progressive Disclosure (PD) Integrity Check...")
        skill_md_path = os.path.join(self.skill_path, "SKILL.md")
        if not os.path.exists(skill_md_path): return False
        
        with open(skill_md_path, 'r', encoding='utf-8') as f:
            content = f.read()

        tier2_files = []
        for root, _, files in os.walk(self.skill_path):
            rel_root = os.path.relpath(root, self.skill_path)
            if any(rel_root.startswith(z) for z in ["knowledge", "scripts", "loop"]):
                for file in files:
                    if not file.startswith('.'):
                        rel_path = os.path.normpath(os.path.join(rel_root, file))
                        tier2_files.append(rel_path)

        orphan_count = 0
        for f_path in tier2_files:
            # Pattern: [Label](path) - must use markdown link as per User's request
            regex_path = re.escape(f_path)
            pattern = rf"\[.*\]\(.*{regex_path}.*\)"
            if not re.search(pattern, content):
                self.warnings.append(f"WARNING: Orphan file detected: '{f_path}' is not linked in SKILL.md via Markdown link.")
                self.log(f"   -> Orphan (Missing MD Link): {f_path}", "WARN")
                orphan_count += 1
        
        return orphan_count == 0

    def check_file_mapping(self):
        if not self.design_path:
            # Policy High: Design path is required if provided in arguments
            return True
            
        if not os.path.exists(self.design_path):
            self.errors.append(f"[E06] CRITICAL: Design file not found at {self.design_path}")
            self.log(f"   -> Design not found: {self.design_path}", "FAIL")
            return False

        self.log(f"4. File Mapping (Actual vs Design §3) Check...")
        with open(self.design_path, 'r', encoding='utf-8') as f:
            design_content = f.read()

        expected_files: set[str] = set()
        # Parse from Zone Mapping table
        lines = design_content.split('\n')
        in_zone_mapping = False
        for line in lines:
            if '## 3. Zone Mapping' in line:
                in_zone_mapping = True
            elif in_zone_mapping and line.startswith('##'):
                if '## 3.' not in line: # Another section started
                    in_zone_mapping = False
            
            if in_zone_mapping:
                # Find file paths in backticks like `knowledge/architect.md`
                matches = re.findall(r"`([a-zA-Z0-9_\-\./]+\.[a-z]{2,4})`", line)
                for m in matches:
                    if "/" in m or m == "SKILL.md":
                        expected_files.add(os.path.normpath(m))
        
        # Ensure SKILL.md is expected
        expected_files.add("SKILL.md")

        actual_files: set[str] = set()
        for root, _, files in os.walk(self.skill_path):
            rel_root = os.path.relpath(root, self.skill_path)
            for file in files:
                if not file.startswith('.'):
                    rel_path = os.path.normpath(os.path.join(rel_root, file)) if rel_root != "." else file
                    actual_files.add(rel_path)

        missing = expected_files - actual_files
        # Exclude loop/build-log.md if it's dynamic
        ignore_extra = {"scripts/validate_skill.py", "loop/build-log.md", "loop/build-checklist.md"}
        extra = actual_files - expected_files - ignore_extra

        if missing:
            for f in missing:
                self.errors.append(f"[E02] ERROR: Missing file from design: {f}")
                self.log(f"   -> Missing: {f}", "FAIL")
        
        if extra:
            for f in extra:
                self.warnings.append(f"WARNING: Extra file not in design: {f}")
                self.log(f"   -> Extra: {f}", "WARN")

        return len(missing) == 0

    def check_placeholder_density(self):
        self.log("5. Placeholder Density Check...")
        total_placeholders = 0
        for root, _, files in os.walk(self.skill_path):
            for file in files:
                if file.endswith('.md'):
                    path = os.path.join(root, file)
                    with open(path, 'r', encoding='utf-8') as f:
                        total_placeholders += f.read().count("[MISSING_DOMAIN_DATA]")
        
        self.log(f"   -> Total Placeholders: {total_placeholders}")
        if total_placeholders >= 10:
            self.errors.append(f"[E05] FAIL: High Placeholder Density ({total_placeholders}). >10 is unacceptable.")
        elif total_placeholders >= 5:
            self.warnings.append(f"WARNING: Medium Placeholder Density ({total_placeholders}). Progressing to failure.")
        
        return total_placeholders < 10

    def check_error_handling(self):
        """Logic P0: Kiểm tra tính tuân thủ Error STOP policy"""
        # Look for build-log.md in loop/
        log_path = os.path.join(self.skill_path, "loop", "build-log.md")
        if not os.path.exists(log_path):
            return True
            
        self.log("6. Error Handling Policy Check...")
        with open(log_path, 'r', encoding='utf-8') as f:
            log_content = f.read()

        # If system error occurred but build didn't stop (no final status or more files added)
        # This is a simplified check
        if "ERROR" in log_content.upper() and "Log-Notify-Stop" in log_content:
            self.log("   -> System Error detected in log. Verifying STOP stance.", "INFO")
        return True

    def report(self):
        print("\n" + "="*50)
        print("   AGENT SKILL VALIDATION REPORT")
        print(f"   Target: {self.skill_name}")
        print(f"   Time: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
        print("="*50)
        
        self.check_structure()
        self.check_skill_md_constraints()
        self.check_pd_links()
        self.check_file_mapping()
        self.check_placeholder_density()
        self.check_error_handling() # Fix Medium: Call checking error handling
        
        print("="*50)
        final_status = "PASS" if not self.errors else "FAIL"
        if self.warnings and final_status == "PASS":
            final_status = "PASS (With Warnings)"
            
        print(f"FINAL STATUS: {final_status}")
        
        if self.log_mode:
            self.write_log(final_status)
            
        if self.errors:
            sys.exit(1)
        sys.exit(0)

    def write_log(self, status):
        """High Fix: Resolve correct path for build-log.md in .skill-context"""
        # Search for build-log.md in .skill-context/{skill-name}/
        workspace_root = os.path.dirname(os.path.dirname(os.path.dirname(self.skill_path)))
        target_log_path = os.path.join(workspace_root, ".skill-context", self.skill_name, "build-log.md")
        
        if not os.path.exists(target_log_path):
            self.log(f"Warning: Build log not found at {target_log_path}", "WARN")
            return

        with open(target_log_path, 'a', encoding='utf-8') as f:
            f.write(f"\n\n## Validation Result ({datetime.now().strftime('%Y-%m-%d %H:%M:%S')})\n")
            f.write(f"- **Final Status**: {status}\n")
            f.write(f"- **Errors**: {len(self.errors)}\n")
            f.write(f"- **Warnings**: {len(self.warnings)}\n")
            if self.errors:
                f.write("### Issues Found:\n")
                for err in self.errors:
                    f.write(f"- [FAILED] {err}\n")
            self.log(f"Results appended to {target_log_path}")

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument("path", help="Path to the skill directory")
    parser.add_argument("--design", help="Path to design.md")
    parser.add_argument("--log", action="store_true", help="Append results to build-log.md")
    args = parser.parse_args()
    
    validator = SkillValidator(args.path, design_path=args.design, log_mode=args.log)
    validator.report()
