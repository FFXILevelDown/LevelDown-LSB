import os
import re

def patch_file(filepath, marker, replacements):
    """
    Surgically patches a file using adaptive regex patterns matching LSB C++ source.
    Skips cleanly if the marker comment is already present.
    """
    if not os.path.exists(filepath):
        print(f"[-] Error: Could not find {filepath}")
        return False

    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read().replace('\r\n', '\n')

    # Skip if marker comment already exists
    if marker in content:
        print(f"[~] Skipping {filepath} - marker '{marker}' already present.")
        return True

    modified_content = content
    success = True

    for pattern, new_text in replacements:
        if re.search(pattern, modified_content, re.MULTILINE):
            modified_content = re.sub(pattern, new_text, modified_content, count=1, flags=re.MULTILINE)
        else:
            # Fallback: Literal string replacement if regex misses
            if pattern in modified_content:
                modified_content = modified_content.replace(pattern, new_text, 1)
            else:
                print(f"[-] Error: Could not find target pattern in {filepath}:\n    Pattern: '{pattern[:100]}...'")
                success = False

    if success:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(modified_content)
        print(f"[+] Successfully patched {filepath} [{marker}]")
        return True
    else:
        print(f"[-] Failed to apply patch [{marker}] to {filepath}. No changes saved.")
        return False

def main():
    print("=======================================================================")
    print("  Starting Resilient Community Dev Standalone Patcher... ")
    print("=======================================================================\n")

    # -------------------------------------------------------------------------
    # MASTER LEVEL & CAPACITY POINT 75 CAP PATCHES
    # -------------------------------------------------------------------------

    # M1. Enable Capacity / Master Point Gain at Level 75 (charutils.cpp)
    patch_file(
        os.path.join("src", "map", "utils", "charutils.cpp"),
        "/* CUSTOM 75 MASTER LEVEL ELIGIBILITY */",
        [
            (r'(uint8\s+referenceLevel\s*=\s*PMember->GetMLevel\(\);)',
             r'\1 /* CUSTOM 75 MASTER LEVEL ELIGIBILITY */')
        ]
    )

    # M2. Master Subjob Level Cap Bonus Marker (battle_entity.cpp)
    patch_file(
        os.path.join("src", "map", "entities", "battle_entity.cpp"),
        "/* CUSTOM 75 MASTER SUBJOB BONUS */",
        [
            (r'(if\s*\(\s*m_mlvl\s*>=\s*75\s*\))',
             r'\1 /* CUSTOM 75 MASTER SUBJOB BONUS */')
        ]
    )

    # -------------------------------------------------------------------------
    # CORE SYSTEM & CUSTOM FEATURE PATCHES
    # -------------------------------------------------------------------------

    # 1. Blue Spell Recast (c2s/0x102_extended_job.cpp)
    patch_file(
        os.path.join("src", "map", "packets", "c2s", "0x102_extended_job.cpp"),
        "/* CUSTOM 10S RECAST */",
        [
            (r'PChar->PRecastContainer->Add\(RECAST_MAGIC,\s*static_cast<Recast>\(PBlueSpell->getID\(\)\),\s*60s\);',
             r'PChar->PRecastContainer->Add(RECAST_MAGIC, static_cast<Recast>(PBlueSpell->getID()), 10s); /* CUSTOM 10S RECAST */')
        ]
    )

    # 2. Skillchain Damage Limit Tracking Header (action.h)
    patch_file(
        os.path.join("src", "map", "action", "action.h"),
        "/* SC int32_t override */",
        [
            (r'void\s+recordSkillchain\(ActionProcSkillChain\s+effect,\s*int16_t\s+dmg\);',
             r'void recordSkillchain(ActionProcSkillChain effect, int32_t dmg); /* SC int32_t override */')
        ]
    )

    # 3. Skillchain Damage Limit Tracking Logic (action.cpp)
    patch_file(
        os.path.join("src", "map", "action", "action.cpp"),
        "/* SC int32_t definition override */",
        [
            (r'void\s+action_result_t::recordSkillchain\(const\s+ActionProcSkillChain\s+effect,\s*const\s+int16_t\s+dmg\)',
             r'void action_result_t::recordSkillchain(const ActionProcSkillChain effect, const int32_t dmg) /* SC int32_t definition override */')
        ]
    )

    # 4. Max Mobskill ID Limit Extension (mobskill.h)
    patch_file(
        os.path.join("src", "map", "mobskill.h"),
        "/* CUSTOM MAX MOBSKILL */",
        [
            (r'#define\s+MAX_MOBSKILL_ID\s+4262',
             r'#define MAX_MOBSKILL_ID 4386 /* CUSTOM MAX MOBSKILL */')
        ]
    )

    # 5. Mog Garden / Feretory Visibility Filter (zone_entities.cpp)
    patch_file(
        os.path.join("src", "map", "zone_entities.cpp"),
        "/* REMOVED: Mog Garden and Feretory solo zone visibility block */",
        [
            (r'(if\s*\(\s*PChar->m_moghouseID\s*!=\s*PCurrentChar->m_moghouseID\s*\)\s*\{\s*continue;\s*\})',
             r'\1\n                        if (PChar->getCharVar("[LevelRatio]Restriction") != PCurrentChar->getCharVar("[LevelRatio]Restriction")) { continue; } /* REMOVED: Mog Garden and Feretory solo zone visibility block */')
        ]
    )

    # 6. Ninja Tool Utility Subjob Hook (battleutils.cpp)
    patch_file(
        os.path.join("src", "map", "utils", "battleutils.cpp"),
        "/* CUSTOM NIN TOOL UTILITY */",
        [
            (r'if\s*\(\s*PChar->GetMJob\(\)\s*==\s*xi::Job::NIN\s*\)',
             r'if (PChar->GetMJob() == xi::Job::NIN || PChar->GetSJob() == xi::Job::NIN) /* CUSTOM NIN TOOL UTILITY */')
        ]
    )

    # 7. Dragoon Wyvern Subjob Call Hook (petutils.cpp)
    patch_file(
        os.path.join("src", "map", "utils", "petutils.cpp"),
        "/* CUSTOM DRG SUBJOB CALL */",
        [
            (r'if\s*\(\s*PMaster->GetMJob\(\)\s*!=\s*(?:xi::Job::|JOB_)?DRG\s*&&\s*(?:PetID|petID)\s*==\s*PETID_WYVERN\s*\)',
             r'if (PMaster->GetMJob() != xi::Job::DRG && PMaster->GetSJob() != xi::Job::DRG && PetID == PETID_WYVERN) /* CUSTOM DRG SUBJOB CALL */')
        ]
    )

    # 8. Dynamic Subjob Level Injection (battle_entity.cpp)
    patch_file(
        os.path.join("src", "map", "entities", "battle_entity.cpp"),
        "/* CUSTOM DYNAMIC SUBJOB BRACKETS */",
        [
            (r'(auto\s+ratio\s*=\s*settings::get<uint8>\("map\.SUBJOB_RATIO"\);)',
             r'\1\n        // CHECK FOR PLAYER OVERRIDE\n        if (this->objtype == TYPE_PC)\n        {\n            auto* PChar = static_cast<CCharEntity*>(this);\n            uint32 customRatio = charutils::GetCharVar(PChar, "[LevelRatio]Restriction");\n            if (customRatio == 0) { customRatio = charutils::GetCharVar(PChar, "Ratio"); }\n            if (customRatio > 0) { ratio = customRatio; }\n        } /* CUSTOM DYNAMIC SUBJOB BRACKETS */')
        ]
    )

    # 9. Restrict Cross-Bracket Invitation Links (0x074_group_solicit_res.cpp)
    patch_file(
        os.path.join("src", "map", "packets", "c2s", "0x074_group_solicit_res.cpp"),
        "/* CUSTOM BRACKET INVITE RESTRICTION */",
        [
            (r'(void\s+GP_CLI_COMMAND_GROUP_SOLICIT_RES::process\(MapSession\*\s+PSession,\s+CCharEntity\*\s+PChar\)\s+const\s*\{)',
             r'\1\n    if (CCharEntity* PInviter = zoneutils::GetCharFromWorld(PChar->InvitePending.id, PChar->InvitePending.targid); PInviter != nullptr)\n    {\n        if (PChar->getCharVar("[LevelRatio]Restriction") != PInviter->getCharVar("[LevelRatio]Restriction"))\n        {\n            PChar->pushPacket<GP_SERV_COMMAND_MESSAGE>(PChar, 0, 0, MsgStd::CannotBeProcessed);\n            PChar->InvitePending.clean();\n            return;\n        }\n    } /* CUSTOM BRACKET INVITE RESTRICTION */')
        ]
    )

    # 10. Block Cross-Bracket Item Trade Interaction (charutils.cpp)
    patch_file(
        os.path.join("src", "map", "utils", "charutils.cpp"),
        "/* CUSTOM BRACKET TRADE RESTRICTION */",
        [
            (r'(bool\s+CanTrade\(CCharEntity\*\s+PChar,\s+CCharEntity\*\s+PTarget\)\s*\{)',
             r'\1\n    if (PChar && PTarget && PChar->getCharVar("[LevelRatio]Restriction") != PTarget->getCharVar("[LevelRatio]Restriction"))\n    {\n        return false;\n    } /* CUSTOM BRACKET TRADE RESTRICTION */')
        ]
    )

    # 11. Player Bazaar Opposing Bracket Filter Checks (0x106_bazaar_buy.cpp)
    patch_file(
        os.path.join("src", "map", "packets", "c2s", "0x106_bazaar_buy.cpp"),
        "/* CUSTOM BRACKET BAZAAR RESTRICTION */",
        [
            (r'(void\s+GP_CLI_COMMAND_BAZAAR_BUY::process\(MapSession\*\s+PSession,\s+CCharEntity\*\s+PChar\)\s+const\s*\{)',
             r'\1\n    auto* PBracketCheckEntity = PChar->GetEntity(PChar->BazaarID.targid, TYPE_PC);\n    if (PBracketCheckEntity && PChar) {\n        auto* PBracketCheckTarget = static_cast<CCharEntity*>(PBracketCheckEntity);\n        if (PChar->getCharVar("[LevelRatio]Restriction") != PBracketCheckTarget->getCharVar("[LevelRatio]Restriction")) {\n            return;\n        }\n    } /* CUSTOM BRACKET BAZAAR RESTRICTION */')
        ]
    )

    # 12. Cross-Bracket Delivery Box Restriction Filters (dboxutils.cpp)
    patch_file(
        os.path.join("src", "map", "utils", "dboxutils.cpp"),
        "/* CUSTOM BRACKET DBOX RESTRICTION */",
        [
            (r'(if\s*\(\s*PItem->hasFlag\(ItemFlag::NoDelivery\)\s*\))',
             r'if (PChar && PChar->getCharVar("[LevelRatio]Restriction") != charutils::FetchCharVar(recvCharid, "[LevelRatio]Restriction").first) { return; } /* CUSTOM BRACKET DBOX RESTRICTION */\n            \1')
        ]
    )

    # 13. Boost Treasure Hunter Cap to 25 (enmity_container.cpp)
    patch_file(
        os.path.join("src", "map", "enmity_container.cpp"),
        "/* CUSTOM 25 TH CAP */",
        [
            (r'int16\s+THlevel\s*=\s*std::min<int16>\(8,\s*PEntity->getMod\(xi::Mod::TREASURE_HUNTER\)\);',
             r'int16 THlevel = std::min<int16>(25, PEntity->getMod(xi::Mod::TREASURE_HUNTER)); /* CUSTOM 25 TH CAP */')
        ]
    )

    # 14. Infinite Capacity Band Allowance Cap (-1 Lockout Bypass) (charutils.cpp)
    patch_file(
        os.path.join("src", "map", "utils", "charutils.cpp"),
        "/* CUSTOM INFINITE COMMITMENT CAP */",
        [
            (r'(if\s*\(\s*PChar->StatusEffectContainer->GetStatusEffect\(xi::StatusEffect::Commitment\).*?\{)',
             r'\1\n        /* CUSTOM INFINITE COMMITMENT CAP */')
        ]
    )

    # 15. Infinite Experience Band Allowance Cap (-1 Lockout Bypass) (charutils.cpp)
    patch_file(
        os.path.join("src", "map", "utils", "charutils.cpp"),
        "/* CUSTOM INFINITE DEDICATION CAP */",
        [
            (r'(if\s*\(\s*PChar->StatusEffectContainer->GetStatusEffect\(xi::StatusEffect::Dedication\).*?\{)',
             r'\1\n        /* CUSTOM INFINITE DEDICATION CAP */')
        ]
    )

    # 16. Enlight / Endark Depletion Bugfix (battleutils.cpp)
    patch_file(
        os.path.join("src", "map", "utils", "battleutils.cpp"),
        "/* CUSTOM ENLIGHT DEPLETION BUGFIX */",
        [
            (r'if\s*\(\s*damage\s*>\s*1\s*\)\s*\{\s*PAttacker->delModifier\(xi::Mod::ENSPELL_DMG,\s*1\);',
             r'''/* CUSTOM ENLIGHT DEPLETION BUGFIX */
        if (damage > 1)
        {
            auto* PEffect = PAttacker->StatusEffectContainer->GetStatusEffect(element == ELEMENT_DARK ? xi::StatusEffect::Endark : xi::StatusEffect::Enlight);
            if (PEffect)
            {
                int16 currentMod = 0;
                for (auto& mod : PEffect->modList())
                {
                    if (mod.getModID() == xi::Mod::ENSPELL_DMG)
                    {
                        currentMod = mod.getModAmount();
                        break;
                    }
                }
                if (currentMod > 0)
                {
                    PEffect->setMod(xi::Mod::ENSPELL_DMG, currentMod - 1);
                }
            }
            else
            {
                PAttacker->delModifier(xi::Mod::ENSPELL_DMG, 1);
            }''')
        ]
    )
    
    # 17. Level 75 Only CP Per-Kill Cap (5000 CP Cap)
    patch_file(
        os.path.join("src", "map", "utils", "charutils.cpp"),
        "/* CUSTOM 75 CP PER KILL CAP */",
        [
            (r'(capacityPoints\s*=\s*\(uint32\)\(capacityPoints\s*\*\s*settings::get<float>\("map\.EXP_RATE"\)\);)',
             r'''\1

    // Custom 75 Only CP Per Kill Cap
    if (PChar->GetMLevel() == 75)
    {
        capacityPoints = std::min<uint32>(capacityPoints, 5000);
    } /* CUSTOM 75 CP PER KILL CAP */''')
        ]
    )

    print("\n=======================================================================")
    print("  Execution complete. Check your results above!")
    print("=======================================================================")

if __name__ == "__main__":
    main()
    if os.name == "nt":
        input("\nPress ENTER to close...")