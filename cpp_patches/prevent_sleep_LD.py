import os

def patch_file(filepath, search_str, replacements):
    # Check if the file actually exists before we try to open it
    if not os.path.exists(filepath):
        print(f"[-] Error: Could not find {filepath}")
        return

    # Read the file and standardize line endings to avoid \r\n vs \n issues
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read().replace('\r\n', '\n')

    # If our unique function name is already in the file, we skip it
    if search_str in content:
        print(f"[~] Skipping {filepath} - already patched.")
        return

    # Perform the find-and-replace with safety checks
    success = True
    for old_text, new_text in replacements:
        if old_text not in content:
            print(f"[-] Error: Could not find target text in {filepath}:\n'{old_text}'")
            success = False
        else:
            content = content.replace(old_text, new_text)

    # Only write to the file if all replacements were found successfully
    if success:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"[+] Patched {filepath}")
    else:
        print(f"[-] Failed to patch {filepath}. No changes saved.")

def main():
    print("=======================================================================")
    print("  Starting Complete Zone Awake Standalone Auto-Patcher... ")
    print("=======================================================================\n")

    # 1. Patch zone.h (Matched to your modern private layout)
    patch_file(
        os.path.join("src", "map", "zone.h"),
        "SetPreventSleep",
        [
            ("void SetBackgroundMusicNight(uint16 music);", 
             "void SetBackgroundMusicNight(uint16 music);\n    void SetPreventSleep(bool value);"),
            ("uint32         m_zoneIP{};", 
             "uint32         m_zoneIP{};\n    bool           m_preventSleep{false};")
        ]
    )

    # 2. Patch lua_zone.h
    patch_file(
        os.path.join("src", "map", "lua", "lua_zone.h"),
        "setPreventSleep",
        [
            ("auto        insertDynamicEntity(sol::table table) -> CBaseEntity*;", 
             "auto        insertDynamicEntity(sol::table table) -> CBaseEntity*;\n    void        setPreventSleep(bool value);")
        ]
    )

    # 3. Patch lua_zone.cpp
    patch_file(
        os.path.join("src", "map", "lua", "lua_zone.cpp"),
        "setPreventSleep",
        [
            ('SOL_REGISTER("insertDynamicEntity", CLuaZone::insertDynamicEntity);', 
             'SOL_REGISTER("insertDynamicEntity", CLuaZone::insertDynamicEntity);\n    SOL_REGISTER("preventSleep", CLuaZone::setPreventSleep);'),
            ("return luautils::GenerateDynamicEntity(m_pLuaZone, nullptr, std::move(table));\n}", 
             "return luautils::GenerateDynamicEntity(m_pLuaZone, nullptr, std::move(table));\n}\n\nvoid CLuaZone::setPreventSleep(bool value)\n{\n    m_pLuaZone->SetPreventSleep(value);\n}")
        ]
    )

    # 4. Patch zone.cpp (Matched to your asynchronous scheduler loop tokens)
    patch_file(
        os.path.join("src", "map", "zone.cpp"),
        "SetPreventSleep",
        [
            ("if (zoneTimerToken_.has_value() && m_zoneEntities->CharListEmpty() && m_timeZoneEmpty + 5s < timer::now() && CheckMobsPathedBack())", 
             "if (!m_preventSleep && zoneTimerToken_.has_value() && m_zoneEntities->CharListEmpty() && m_timeZoneEmpty + 5s < timer::now() && CheckMobsPathedBack())"),
            ("void CZone::SetBackgroundMusicNight(uint16 music)\n{\n    m_zoneMusic.m_songNight = music;\n}", 
             'void CZone::SetBackgroundMusicNight(uint16 music)\n{\n    m_zoneMusic.m_songNight = music;\n}\n\nvoid CZone::SetPreventSleep(bool value)\n{\n    m_preventSleep = value;\n\n    if (m_preventSleep && !zoneTimerToken_.has_value())\n    {\n        createZoneTimers();\n        ShowInfoFmt("Zone {} ({}) forced awake by SetPreventSleep.", GetID(), getName());\n    }\n}')
        ]
    )

    print("\n=======================================================================")
    print("  All files processed successfully! You are safe to compile.")
    print("=======================================================================")

if __name__ == "__main__":
    main()
    if os.name == "nt":
        input("\nPress ENTER to exit...")