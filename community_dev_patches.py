import os

def patch_file(filepath, search_str, replacements):
    # Check if the file actually exists before trying to open it
    if not os.path.exists(filepath):
        print(f"[-] Error: Could not find {filepath}")
        return False

    # Read the file and standardize line endings to avoid \r\n vs \n issues
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read().replace('\r\n', '\n')

    # If our unique marker is already in the file, we skip it cleanly
    if search_str in content:
        print(f"[~] Skipping {filepath} - already patched.")
        return True

    # Perform the find-and-replace with safety checks
    success = True
    modified_content = content
    for old_text, new_text in replacements:
        if old_text not in modified_content:
            print(f"[-] Error: Could not find target text in {filepath}:\n'{old_text}'")
            success = False
        else:
            modified_content = modified_content.replace(old_text, new_text)

    # Only write to the file if all replacements were found successfully
    if success:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(modified_content)
        print(f"[+] Patched {filepath}")
        return True
    else:
        print(f"[-] Failed to patch {filepath}. No changes saved.")
        return False

def main():
    print("=======================================================================")
    print("  Starting Complete Resilient Community Dev Standalone Patcher... ")
    print("=======================================================================\n")

    # 1. Blue Spell Recast (Updated from 60s signature anchor)
    patch_file(
        os.path.join("src", "map", "packets", "c2s", "0x102_extended_job.cpp"),
        "/* CUSTOM 10S RECAST */",
        [
            ("PChar->PRecastContainer->Add(RECAST_MAGIC, static_cast<Recast>(PBlueSpell->getID()), 60s);",
             "PChar->PRecastContainer->Add(RECAST_MAGIC, static_cast<Recast>(PBlueSpell->getID()), 10s); /* CUSTOM 10S RECAST */")
        ]
    )

    # 2. Skillchain Damage Limit Tracking Changes (action.h)
    patch_file(
        os.path.join("src", "map", "action", "action.h"),
        "/* SC int32_t override */",
        [
            ("void recordSkillchain(ActionProcSkillChain effect, int16_t dmg);",
             "void recordSkillchain(ActionProcSkillChain effect, int32_t dmg); /* SC int32_t override */")
        ]
    )

    # 3. Skillchain Damage Limit Tracking Changes (action.cpp)
    patch_file(
        os.path.join("src", "map", "action", "action.cpp"),
        "/* SC int32_t definition override */",
        [
            ("void action_result_t::recordSkillchain(const ActionProcSkillChain effect, const int16_t dmg)",
             "void action_result_t::recordSkillchain(const ActionProcSkillChain effect, const int32_t dmg) /* SC int32_t definition override */")
        ]
    )

    # 4. Max Mobskill ID Limit Extension (Updated from 4262 signature anchor)
    patch_file(
        os.path.join("src", "map", "mobskill.h"),
        "/* CUSTOM MAX MOBSKILL */",
        [
            ("#define MAX_MOBSKILL_ID 4262", "#define MAX_MOBSKILL_ID 4386 /* CUSTOM MAX MOBSKILL */")
        ]
    )

    # 5. Visible Players in Mog Garden / Feretory Custom Bracket Filter (Updated Spacing)
    patch_file(
        os.path.join("src", "map", "zone_entities.cpp"),
        "/* REMOVED: Mog Garden and Feretory solo zone visibility block */",
        [
            ("if (PChar->m_moghouseID != PCurrentChar->m_moghouseID)\n                        {\n                            continue;\n                        }",
             "if (PChar->m_moghouseID != PCurrentChar->m_moghouseID)\n                        {\n                            continue;\n                        }\n\n                        if (PChar->getCharVar(\"[LevelRatio]Restriction\") != PCurrentChar->getCharVar(\"[LevelRatio]Restriction\"))\n                        {\n                            continue;\n                        } /* REMOVED: Mog Garden and Feretory solo zone visibility block */")
        ]
    )

    # 6. Support Job Ninja Tool Utility Hook
    patch_file(
        os.path.join("src", "map", "utils", "battleutils.cpp"),
        "/* CUSTOM NIN TOOL UTILITY */",
        [
            ("if (PChar->GetMJob() == JOB_NIN)",
             "if (PChar->GetMJob() == JOB_NIN || PChar->GetSJob() == JOB_NIN) /* CUSTOM NIN TOOL UTILITY */")
        ]
    )

    # 7. Support Job Dragoon Wyvern Summon Permissions
    patch_file(
        os.path.join("src", "map", "utils", "petutils.cpp"),
        "/* CUSTOM DRG SUBJOB CALL */",
        [
            ("if (PMaster->GetMJob() != JOB_DRG && PetID == PETID_WYVERN)",
             "if (PMaster->GetMJob() != JOB_DRG && PMaster->GetSJob() != JOB_DRG && PetID == PETID_WYVERN) /* CUSTOM DRG SUBJOB CALL */")
        ]
    )

    # 8. Complete Dynamic Subjob Level Calculation Overwrite
    patch_file(
        os.path.join("src", "map", "entities", "battle_entity.cpp"),
        "/* CUSTOM DYNAMIC SUBJOB BRACKETS */",
        [
            ('''void CBattleEntity::SetSLevel(uint8 slvl)
{
    TracyZoneScoped;

    if (!settings::get<bool>("map.INCLUDE_MOB_SJ") && this->objtype == TYPE_MOB && this->objtype != TYPE_PET)
    {
        m_slvl = m_mlvl; // All mobs have a 1:1 ratio of MainJob/Subjob
    }
    else
    {
        auto ratio = settings::get<uint8>("map.SUBJOB_RATIO");
        switch (ratio)
        {
            case 0: // no SJ
                m_slvl = 0;
                break;
            case 1: // 1/2 (75/37, 99/49)
                m_slvl = (slvl > (m_mlvl >> 1) ? (m_mlvl == 1 ? 1 : (m_mlvl >> 1)) : slvl);
                break;
            case 2: // 2/3 (75/50, 99/66)
                m_slvl = (slvl > (m_mlvl * 2) / 3 ? (m_mlvl == 1 ? 1 : (m_mlvl * 2) / 3) : slvl);
                break;
            case 3: // equal (75/75, 99/99)
                m_slvl = (slvl > m_mlvl ? (m_mlvl == 1 ? 1 : m_mlvl) : slvl);
                break;
            default: // Error
                ShowError("Error setting subjob level: Invalid ratio '%s' check your settings file!", ratio);
                break;
        }
    }

    if (this->objtype & TYPE_PC)
    {
        db::preparedStmt("UPDATE char_stats SET slvl = ? WHERE charid = ? LIMIT 1", m_slvl, this->id);
    }
}''',
             '''void CBattleEntity::SetSLevel(uint8 slvl)
{
    TracyZoneScoped;
    if (!settings::get<bool>("map.INCLUDE_MOB_SJ") && this->objtype == TYPE_MOB && this->objtype != TYPE_PET)
    {
        m_slvl = m_mlvl; // All mobs have a 1:1 ratio of MainJob/Subjob
    }
    else
    {
        // 1. Get the global server setting first
        auto ratio = settings::get<uint8>("map.SUBJOB_RATIO");

        // 2. CHECK FOR PLAYER OVERRIDE
        if (this->objtype == TYPE_PC)
        {
            // Cast this generic BattleEntity into a CharEntity so we can access player variables
            auto* PChar = static_cast<CCharEntity*>(this);
            
            // First, look for the specialized bracket level ratio constraint
            uint32 customRatio = charutils::GetCharVar(PChar, "[LevelRatio]Restriction");
            
            // Fallback: If the specialized bracket isn't set, check your standard "Ratio" variable
            if (customRatio == 0)
            {
                customRatio = charutils::GetCharVar(PChar, "Ratio");
            }
            
            // If any custom override ratio was found in the database, intercept the global map configuration
            if (customRatio > 0)
            {
                ratio = customRatio;
            }
        }

        // 3. Continue with the normal math based on the final ratio
        switch (ratio)
        {
            case 0: // no SJ
                m_slvl = 0;
                break;
            case 1: // 1/2 (75/37, 99/49)
                m_slvl = (slvl > (m_mlvl >> 1) ? (m_mlvl == 1 ? 1 : (m_mlvl >> 1)) : slvl);
                break;
            case 2: // 2/3 (75/50, 99/66)
                m_slvl = (slvl > (m_mlvl * 2) / 3 ? (m_mlvl == 1 ? 1 : (m_mlvl * 2) / 3) : slvl);
                break;
            case 3: // equal (75/75, 99/99)
                m_slvl = (slvl > m_mlvl ? (m_mlvl == 1 ? 1 : m_mlvl) : slvl);
                break;
            default: // Error
                ShowError("Error setting subjob level: Invalid ratio '%s' check your settings file!", ratio);
                break;
        }
    }

    if (this->objtype & TYPE_PC)
    {
        db::preparedStmt("UPDATE char_stats SET slvl = ? WHERE charid = ? LIMIT 1", m_slvl, this->id);
    }
} /* CUSTOM DYNAMIC SUBJOB BRACKETS */''')
        ]
    )

    # 9. Restrict Cross-Bracket Invitation Links
    patch_file(
        os.path.join("src", "map", "packets", "c2s", "0x074_group_solicit_res.cpp"),
        "/* CUSTOM BRACKET INVITE RESTRICTION */",
        [
            ("void GP_CLI_COMMAND_GROUP_SOLICIT_RES::process(MapSession* PSession, CCharEntity* PChar) const\n{",
             "void GP_CLI_COMMAND_GROUP_SOLICIT_RES::process(MapSession* PSession, CCharEntity* PChar) const\n{\n    if (CCharEntity* PInviter = zoneutils::GetCharFromWorld(PChar->InvitePending.id, PChar->InvitePending.targid); PInviter != nullptr)\n    {\n        if (PChar->getCharVar(\"[LevelRatio]Restriction\") != PInviter->getCharVar(\"[LevelRatio]Restriction\"))\n        {\n            PChar->pushPacket<GP_SERV_COMMAND_MESSAGE>(PChar, 0, 0, MsgStd::CannotBeProcessed);\n            PChar->InvitePending.clean();\n            return;\n        }\n    } /* CUSTOM BRACKET INVITE RESTRICTION */")
        ]
    )

    # 10. Block Cross-Bracket Item Trade Interaction
    patch_file(
        os.path.join("src", "map", "utils", "charutils.cpp"),
        "/* CUSTOM BRACKET TRADE RESTRICTION */",
        [
            ("bool CanTrade(CCharEntity* PChar, CCharEntity* PTarget)\n{",
             "bool CanTrade(CCharEntity* PChar, CCharEntity* PTarget)\n{\n    if (PChar && PTarget && PChar->getCharVar(\"[LevelRatio]Restriction\") != PTarget->getCharVar(\"[LevelRatio]Restriction\"))\n    {\n        return false;\n    } /* CUSTOM BRACKET TRADE RESTRICTION */")
        ]
    )

    # 11. Player Bazaar Opposing Bracket Filter Checks
    patch_file(
        os.path.join("src", "map", "packets", "c2s", "0x106_bazaar_buy.cpp"),
        "/* CUSTOM BRACKET BAZAAR RESTRICTION */",
        [
            ("void GP_CLI_COMMAND_BAZAAR_BUY::process(MapSession* PSession, CCharEntity* PChar) const\n{",
             "void GP_CLI_COMMAND_BAZAAR_BUY::process(MapSession* PSession, CCharEntity* PChar) const\n{\n    auto* PBracketCheckEntity = PChar->GetEntity(PChar->BazaarID.targid, TYPE_PC);\n    if (PBracketCheckEntity && PChar) {\n        auto* PBracketCheckTarget = static_cast<CCharEntity*>(PBracketCheckEntity);\n        if (PChar->getCharVar(\"[LevelRatio]Restriction\") != PBracketCheckTarget->getCharVar(\"[LevelRatio]Restriction\")) {\n            return;\n        }\n    } /* CUSTOM BRACKET BAZAAR RESTRICTION */")
        ]
    )

    # 12. Cross-Bracket Delivery Box Restriction Filters
    patch_file(
        os.path.join("src", "map", "utils", "dboxutils.cpp"),
        "/* CUSTOM BRACKET DBOX RESTRICTION */",
        [
            ("if (PItem->hasFlag(ItemFlag::NoDelivery))",
             "// Custom Bracket Restriction Delivery Block Injected\n            if (PChar && PChar->getCharVar(\"[LevelRatio]Restriction\") != charutils::FetchCharVar(recvCharid, \"[LevelRatio]Restriction\").first)\n            {\n                return;\n            } /* CUSTOM BRACKET DBOX RESTRICTION */\n            if (PItem->hasFlag(ItemFlag::NoDelivery))")
        ]
    )

    print("\n=======================================================================")
    print("  Execution complete. Check your results above!")
    print("=======================================================================")

if __name__ == "__main__":
    main()
    if os.name == "nt":
        input("\nPress ENTER to close...")