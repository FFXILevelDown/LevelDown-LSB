/*
===========================================================================

  Copyright (c) 2025 LandSandBoat Dev Teams

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

#include "0x0c9_equip_inspect_equipment.h"

#include "entities/char_entity.h"
#include "items/exdata/augment_standard.h"
#include "items/item_equipment.h"
#include "items/item_usable.h"

GP_SERV_COMMAND_EQUIP_INSPECT::EQUIPMENT::EQUIPMENT(CCharEntity* PChar, CCharEntity* PTarget)
{
    auto& packet = this->data();

    packet.UniqNo     = PTarget->id;
    packet.ActIndex   = PTarget->targid;
    packet.OptionFlag = 0x03;

    uint8 count = 0;

    for (int32 i = 0; i < 16; ++i)
    {
        if (CItem* PItem = PTarget->getEquip(static_cast<SLOTTYPE>(i)))
        {
            auto& item = packet.Equip[count];

            item.ItemNo    = PItem->getID();
            item.EquipKind = static_cast<SAVE_EQUIP_KIND>(i);

            if (PItem->isSubType(ITEM_CHARGED))
            {
                timer::time_point currentTime = timer::now();
                timer::time_point nextUseTime = static_cast<CItemUsable*>(PItem)->getNextUseTime();

                item.Data[0] = 0x01; // Type
                item.Data[1] = static_cast<CItemUsable*>(PItem)->getCurrentCharges();
                item.Data[3] = nextUseTime > currentTime ? 0x90 : 0xD0; // ChargeFlag

                uint32 vNextUseTime = earth_time::vanadiel_timestamp(timer::to_utc(nextUseTime));
                uint32 vUseDelay    = static_cast<uint32>(timer::count_seconds(static_cast<CItemUsable*>(PItem)->getUseDelay()) + earth_time::vanadiel_timestamp());

                std::memcpy(&item.Data[4], &vNextUseTime, sizeof(uint32));
                std::memcpy(&item.Data[8], &vUseDelay, sizeof(uint32));
            }

            /* LD INSPECT REAL EXDATA */
            // Send the item's own augment exdata (kind, subkind, payload) instead of rebuilding it.
            // The rebuild left the subkind byte at 0 and dropped the 5th augment, so other players
            // saw garbage augments on /check; it also could not carry mezzotint or bundled layouts.
            const uint8 augmentKind = PItem->m_extra[0];
            if (!PItem->isSubType(ITEM_CHARGED) &&
                (PItem->isSubType(ITEM_AUGMENTED) || augmentKind == 0x02 || augmentKind == 0x03))
            {
                std::memcpy(&item.Data[0], PItem->m_extra, 12);
            }

            // All equipment exdata types have Signature at offset 0x0C; struct choice is irrelevant.
            std::memcpy(&item.Data[12], PItem->exdata<Exdata::AugmentStandard>().Signature, sizeof(Exdata::AugmentStandard::Signature));

            count++;

            if (count == 8)
            {
                packet.EquipCount = count;
                this->setSize(sizeof(GP_SERV_HEADER) + 8 + sizeof(packet.Equip[0]) * count);
                PChar->pushPacket(this->copy());

                // Reset for next batch
                std::memset(packet.Equip, 0, sizeof(packet.Equip));
                count = 0;
            }
        }
    }

    packet.EquipCount = count;
    this->setSize(sizeof(GP_SERV_HEADER) + 8 + sizeof(packet.Equip[0]) * std::max<uint8>(count, 1));
}
