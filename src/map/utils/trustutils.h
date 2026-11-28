/*
===========================================================================

  Copyright (c) 2024 LandSandBoat Dev Teams

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see http://www.gnu.org/licenses/

===========================================================================
*/
#pragma once

#include "common/cbasetypes.h"

class CCharEntity;
class CTrustEntity;

/* LD AI PLAYERS SQUAD SPEC */
namespace trustutils
{

// Optional overrides used by the squad system (modules/custom/cpp/squad.cpp).
// When supplied to SpawnTrust, the trust spawns with this job/subjob/level instead of the
// trust's own job and the master's level. Everything else (spell list, skills, AI) still
// comes from the trust that TrustID points at.
struct SquadSpec
{
    uint8  mJob{ 0 };     // main job (required)
    uint8  sJob{ 0 };     // sub job, 0 = none
    uint8  mLevel{ 0 };   // main level (required)
    uint8  sLevel{ 0 };   // sub level, 0 = half of main level (when a sub job is set)
    uint32 squadId{ 0 };  // stored on the entity as local var SQUAD_ID so Lua can recognise squad mates
    uint8  race{ 0 };     // player race 1-8 (Hume M/F, Elvaan M/F, Taru M/F, Mithra, Galka): stats use that race's player tables. 0 = the trust's own

    // Appearance, applied BEFORE the character spawns so the very first spawn message already shows it
    // (a renamed character's later update messages garble the armor). Armor values carry their slot: head 0x1000, body 0x2000,
    // hands 0x3000, legs 0x4000, feet 0x5000, main 0x6000, sub 0x7000, ranged 0x8000. 0 = nothing shown in that slot.
    bool   hasLook{ false };
    uint8  face{ 0 };
    uint16 lookHead{ 0 };
    uint16 lookBody{ 0 };
    uint16 lookHands{ 0 };
    uint16 lookLegs{ 0 };
    uint16 lookFeet{ 0 };
    uint16 lookMain{ 0 };
    uint16 lookSub{ 0 };
    uint16 lookRanged{ 0 };
};

// We cache all of this so we don't have to hit the database every time a trust is spawned
void LoadTrustList();
auto SpawnTrust(CCharEntity* PMaster, uint32 TrustID, const SquadSpec* spec = nullptr) -> CTrustEntity*;

}; // namespace trustutils
