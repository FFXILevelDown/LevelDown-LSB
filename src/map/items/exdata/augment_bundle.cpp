/*
===========================================================================

  Copyright (c) 2026 LandSandBoat Dev Teams

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

#include "augment_bundle.h"

#include "base.h"

void Exdata::AugmentBundle::toTable(sol::table& table) const
{
    table["augmentKind"]    = static_cast<uint8_t>(this->AugmentKind);
    table["augmentSubKind"] = static_cast<uint8_t>(this->AugmentSubKind);
    table["type"]           = static_cast<uint32_t>(this->Type);
    table["rank"]           = static_cast<uint32_t>(this->Rank);
    table["accumulatedRP"]  = static_cast<uint32_t>(this->AccumulatedRP);
    table["maxRankTier"]    = static_cast<uint32_t>(this->MaxRankTier);
    table["rpCurve"]        = static_cast<uint32_t>(this->RPCurve);
    table["flag25"]         = static_cast<uint32_t>(this->padding01);
    table["augmentIndex"]   = this->AugmentIndex;
    table["signature"]      = Exdata::decodeSignature(this->Signature);
}

void Exdata::AugmentBundle::fromTable(const sol::table& data)
{
    /* CUSTOM BUNDLED AUGMENT SUBKIND FIX */
    this->AugmentKind    = AugmentKindFlags::Bundled;
    /* LD BUNDLED SUBKIND RETAIL */
    // LD: retail sends 0x83 here on every bundled item (Oboro / Dynamis-D captures, header 0x8303), and the client
    // only draws the <Type/Rank/RP> line with it. The "inconsistent decoding depending on the viewer" that led
    // to clearing it was the /check packet rebuilding exdata with subkind 0 (fixed in 0x0c9_equip_inspect_equipment).
    this->AugmentSubKind = static_cast<AugmentSubKindFlags>(0x83);
    this->padding01      = Exdata::get_or<uint32_t>(data, "flag25", this->padding01); // LD: set on Dynamis-D gear (captures), meaning unknown
    this->Type           = Exdata::get_or<uint32_t>(data, "type", this->Type);
    this->Rank           = Exdata::get_or<uint32_t>(data, "rank", this->Rank);
    this->AccumulatedRP  = Exdata::get_or<uint32_t>(data, "accumulatedRP", this->AccumulatedRP);
    this->MaxRankTier    = Exdata::get_or<uint32_t>(data, "maxRankTier", this->MaxRankTier);
    this->RPCurve        = Exdata::get_or<uint32_t>(data, "rpCurve", this->RPCurve);
    this->AugmentIndex   = Exdata::get_or<uint32_t>(data, "augmentIndex", this->AugmentIndex);

    if (sol::optional<std::string> sig = data["signature"])
    {
        Exdata::encodeSignature(*sig, this->Signature);
    }
}
