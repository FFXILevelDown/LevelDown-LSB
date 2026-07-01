import os
import re
import sys

def apply(patcher_engine=None):
    """
    Recipe: Discord Dev Community Requests & Level Cap Restrictions
    Purpose: Groups multi-file adjustments using exact layout patterns from the current branch.
    Notes: Modified to safely run as a standalone script without requiring dbtool orchestration.
    """
    print("\n=======================================================================")
    print("  [+] Executing Complete Resilient Discord Community Dev patches...")
    print("=======================================================================")

    # Determine server root directory automatically if executing as a standalone script
    try:
        import __main__
        from_server_path = __main__.from_server_path
    except Exception:
        # Fallback: assume script is inside a subdirectory of the server root (e.g., /cpp_patches or /tools)
        base_dir = os.path.normpath(os.path.join(os.path.dirname(os.path.abspath(__file__)), ".."))
        def from_server_path(p): 
            return os.path.normpath(os.path.join(base_dir, p))

    stats = {"patched": 0, "skipped": 0, "failed": 0}

    def precise_regex_patch(relative_path, unique_marker, pattern, replacement):
        filepath = from_server_path(relative_path)
        if not os.path.exists(filepath):
            print(f"  [-] Error: Could not find {filepath}")
            stats["failed"] += 1
            return

        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read().replace('\r\n', '\n')

        if unique_marker in content:
            print(f"  [~] Skipping {relative_path} - rule already applied.")
            stats["skipped"] += 1
            return

        new_content, count = re.subn(pattern, replacement, content, flags=re.MULTILINE)
        
        if count > 0:
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(new_content)
            print(f"  [+] Precise Patched {relative_path} ({count} matches)")
            stats["patched"] += 1
        else:
            print(f"  [-] Error: Pattern matching failed in {relative_path}")
            stats["failed"] += 1

    # =========================================================================
    # 1. Reduce Blue Set Spell Recast/Casting Time to 10s
    # =========================================================================
    precise_regex_patch(
        os.path.join("src", "map", "packets", "c2s", "0x102_extended_job.cpp"),
        "/* CUSTOM 10S RECAST */",
        r"(Add\(RECAST_MAGIC,\s*static_cast<Recast>\(PBlueSpell->getID\(\)\),\s*)\d+s\);",
        r"\1 10s); /* CUSTOM 10S RECAST */"
    )

    # =========================================================================
    # 2. Skillchain Damage Limit Tracking Changes (Action Framework)
    # =========================================================================
    precise_regex_patch(
        os.path.join("src", "map", "action", "action.h"),
        "/* SC int32_t override */",
        r"void\s+recordSkillchain\(\s*ActionProcSkillChain\s+effect\s*,\s*(?:uint16|uint32|uint16_t|uint32_t|int32_t)\s+dmg\s*\);",
        r"void recordSkillchain(ActionProcSkillChain effect, int32_t dmg); /* SC int32_t override */"
    )

    precise_regex_patch(
        os.path.join("src", "map", "action", "action.cpp"),
        "/* SC int32_t definition override */",
        r"void\s+action_result_t::recordSkillchain\(\s*const\s+ActionProcSkillChain\s+effect\s*,\s*const\s+(?:uint16|uint32|uint16_t|uint32_t|int32_t)\s+dmg\s*\)",
        r"void action_result_t::recordSkillchain(const ActionProcSkillChain effect, const int32_t dmg) /* SC int32_t definition override */"
    )

    # =========================================================================
    # 3. Increase Max Mobskill ID limit for SQL entries
    # =========================================================================
    precise_regex_patch(
        os.path.join("src", "map", "mobskill.h"),
        "/* CUSTOM MAX MOBSKILL */",
        r"#define\s+MAX_MOBSKILL_ID\s+\d+",
        r"#define MAX_MOBSKILL_ID 4386 /* CUSTOM MAX MOBSKILL */"
    )

    # =========================================================================
    # 4. Visible Players in Mog Garden & Feretory
    # =========================================================================
    precise_regex_patch(
        os.path.join("src", "map", "zone_entities.cpp"),
        "/* REMOVED: Mog Garden and Feretory solo zone visibility block */",
        r"(\s*if\s*\(\s*PChar->m_moghouseID\s*!=\s*PCurrentChar->m_moghouseID\s*\)\s*\{\s*continue;\s*\})",
        r"""\1
                        
                        // Custom Bracket Visibility Filter Added
                        if (PChar->getCharVar("[LevelRatio]Restriction") != PCurrentChar->getCharVar("[LevelRatio]Restriction"))
                        {
                            continue;
                        } /* REMOVED: Mog Garden and Feretory solo zone visibility block */"""
    )

    # =========================================================================
    # 5. Support Job Ninja to utilize Universal Tools
    # =========================================================================
    precise_regex_patch(
        os.path.join("src", "map", "utils", "battleutils.cpp"),
        "/* CUSTOM NIN TOOL UTILITY */",
        r"(if\s*\(\s*PChar->GetMJob\(\)\s*==\s*JOB_NIN\s*\|\|\s*PChar->GetSJob\(\)\s*==\s*JOB_NIN\s*\))",
        r"\1 /* CUSTOM NIN TOOL UTILITY */"
    )

    # =========================================================================
    # 6. Allow Support Job Dragoon to call Wyverns
    # =========================================================================
    precise_regex_patch(
        os.path.join("src", "map", "utils", "petutils.cpp"),
        "/* CUSTOM DRG SUBJOB CALL */",
        r"(if\s*\(\s*PetID\s*==\s*PETID_WYVERN\s*&&\s*PMaster->GetMJob\(\)\s*!=\s*JOB_DRG\s*&&\s*PMaster->GetSJob\(\)\s*!=\s*JOB_DRG\s*\))",
        r"\1 /* CUSTOM DRG SUBJOB CALL */"
    )

    # =========================================================================
    # 7. Level Cap Restriction Overrides (Dynamic Subjob Ratio)
    # =========================================================================
    precise_regex_patch(
        os.path.join("src", "map", "entities", "battle_entity.cpp"),
        "/* CUSTOM DYNAMIC SUBJOB BRACKETS */",
        r"(uint32\s+customRatio\s*=\s*charutils::GetCharVar\(\s*PChar\s*,\s*\"Ratio\"\s*\);)",
        r"""uint32 customRatio = charutils::GetCharVar(PChar, "[LevelRatio]Restriction");
            if (customRatio == 0) {
                customRatio = charutils::GetCharVar(PChar, "Ratio");
            } /* CUSTOM DYNAMIC SUBJOB BRACKETS */"""
    )

    # =========================================================================
    # 8. Restrict Alliance/Party Invitation hooks
    # =========================================================================
    precise_regex_patch(
        os.path.join("src", "map", "packets", "c2s", "0x074_group_solicit_res.cpp"),
        "/* CUSTOM BRACKET INVITE RESTRICTION */",
        r"(void\s+GP_CLI_COMMAND_GROUP_SOLICIT_RES::process\s*\([^)]*\)\s*const\s*\{)",
        r"""\1
    // Custom Restriction Bracket Logic
    if (CCharEntity* PInviter = zoneutils::GetCharFromWorld(PChar->InvitePending.id, PChar->InvitePending.targid); PInviter != nullptr)
    {
        if (PChar->getCharVar("[LevelRatio]Restriction") != PInviter->getCharVar("[LevelRatio]Restriction"))
        {
            PChar->pushPacket<GP_SERV_COMMAND_MESSAGE>(PChar, 0, 0, MsgStd::CannotBeProcessed);
            PChar->InvitePending.clean();
            return;
        }
    } /* CUSTOM BRACKET INVITE RESTRICTION */"""
    )

    # =========================================================================
    # 9. Block cross-bracket item trade functionality
    # =========================================================================
    precise_regex_patch(
        os.path.join("src", "map", "utils", "charutils.cpp"),
        "/* CUSTOM BRACKET TRADE RESTRICTION */",
        r"(bool\s+CanTrade\s*\(\s*CCharEntity\*\s*PChar\s*,\s*CCharEntity\*\s*PTarget\s*\)\s*\{)",
        r"""\1
    if (PChar && PTarget && PChar->getCharVar("[LevelRatio]Restriction") != PTarget->getCharVar("[LevelRatio]Restriction"))
    {
        return false;
    } /* CUSTOM BRACKET TRADE RESTRICTION */"""
    )

    # =========================================================================
    # 10. Restrict browsing/interaction with opposing bracket Player Bazaars
    # =========================================================================
    precise_regex_patch(
        os.path.join("src", "map", "packets", "c2s", "0x106_bazaar_buy.cpp"),
        "/* CUSTOM BRACKET BAZAAR RESTRICTION */",
        r"(void\s+GP_CLI_COMMAND_BAZAAR_BUY::process\s*\(\s*MapSession\*\s*PSession\s*,\s*CCharEntity\*\s*PChar\s*\)\s*const\s*\{)",
        r"""\1
    auto* PBracketCheckEntity = PChar->GetEntity(PChar->BazaarID.targid, TYPE_PC);
    if (PBracketCheckEntity && PChar) {
        auto* PBracketCheckTarget = static_cast<CCharEntity*>(PBracketCheckEntity);
        if (PChar->getCharVar("[LevelRatio]Restriction") != PBracketCheckTarget->getCharVar("[LevelRatio]Restriction")) {
            return;
        }
    } /* CUSTOM BRACKET BAZAAR RESTRICTION */"""
    )

    # =========================================================================
    # 11. Delivery Box cross-bracket restriction rules
    # =========================================================================
    precise_regex_patch(
        os.path.join("src", "map", "utils", "dboxutils.cpp"),
        "/* CUSTOM BRACKET DBOX RESTRICTION */",
        r"(\s*if\s*\(\s*PItem->getFlag\(\)\s*&\s*ITEM_FLAG_NODELIVERY\s*\))",
        r"""
            // Custom Bracket Restriction Delivery Block Injected
            if (PChar && PChar->getCharVar("[LevelRatio]Restriction") != charutils::FetchCharVar(recvCharid, "[LevelRatio]Restriction").first)
            {
                return;
            } /* CUSTOM BRACKET DBOX RESTRICTION */
\1"""
    )

    print("\n=======================================================================")
    print(f"  [+] Run Execution Summary: {stats['patched']} Patched | {stats['skipped']} Skipped | {stats['failed']} Failed")
    print("=======================================================================")

# Standalone runtime capability override block
if __name__ == "__main__":
    apply()
    if os.name == "nt":
        input("\nPress ENTER to close...")