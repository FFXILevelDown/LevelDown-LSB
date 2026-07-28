import os
import glob
import re
import importlib.util

PATCH_DIR = os.path.join("modules", "LevelDown Custom Modules", "cpp", "patchs")

def apply_patch_module(module_path):
    # Load module dynamically
    module_name = os.path.splitext(os.path.basename(module_path))[0]
    spec = importlib.util.spec_from_file_location(module_name, module_path)
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)

    filepath = getattr(mod, "TARGET_FILE", None)
    marker = getattr(mod, "MARKER", None)
    replacements = getattr(mod, "REPLACEMENTS", [])

    if not filepath or not marker:
        print(f"[-] Skipping invalid patch file: {module_name}.py")
        return False

    if not os.path.exists(filepath):
        print(f"[-] Error: Could not find target file {filepath}")
        return False

    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read().replace('\r\n', '\n')

    if marker in content:
        print(f"[~] Skipping {os.path.basename(filepath)} - [{marker}] already present.")
        return True

    modified_content = content
    success = True

    for pattern, new_text in replacements:
        if re.search(pattern, modified_content, re.MULTILINE):
            modified_content = re.sub(pattern, new_text, modified_content, count=1, flags=re.MULTILINE)
        else:
            if pattern in modified_content:
                modified_content = modified_content.replace(pattern, new_text, 1)
            else:
                print(f"[-] Error: Could not find target pattern in {filepath}:\n    Pattern: '{pattern[:80]}...'")
                success = False

    if success:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(modified_content)
        print(f"[+] Successfully patched {os.path.basename(filepath)} [{marker}]")
        return True
    else:
        print(f"[-] Failed to apply patch [{marker}] to {filepath}.")
        return False

def main():
    print("=======================================================================")
    print("  LevelDown Modular C++ Patch Loader")
    print("=======================================================================\n")

    if not os.path.exists(PATCH_DIR):
        print(f"[-] Directory does not exist: {PATCH_DIR}")
        return

    patch_files = sorted(glob.glob(os.path.join(PATCH_DIR, "*.py")))
    print(f"[+] Found {len(patch_files)} patch module(s) to evaluate.\n")

    applied, skipped, failed = 0, 0, 0

    for patch_file in patch_files:
        result = apply_patch_module(patch_file)
        if result:
            applied += 1
        else:
            failed += 1

    print("\n=======================================================================")
    print("  Execution complete!")
    print("=======================================================================")

if __name__ == "__main__":
    main()
    if os.name == "nt":
        input("\nPress ENTER to close...")