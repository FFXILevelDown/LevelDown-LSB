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

#include "0x01b_job_info.h"

#include <cstring>

#include "aman.h"
#include "entities/char_entity.h"
#include "data/enums/key_item.h"
#include "job_points.h"
#include "utils/charutils.h"

GP_SERV_COMMAND_JOB_INFO::GP_SERV_COMMAND_JOB_INFO(CCharEntity* PChar)
{
    auto& packet = this->data();

    packet.dancer.face_no      = PChar->look.race;
    packet.dancer.mjob_no      = PChar->GetMJob();
    packet.dancer.sjob_no      = PChar->GetSJob();
    packet.dancer.get_job_flag = PChar->jobs.unlocked;

    std::memcpy(packet.dancer.job_lev, &PChar->jobs.job, sizeof(packet.dancer.job_lev));
    std::memcpy(packet.dancer.bp_base, &PChar->stats, sizeof(packet.dancer.bp_base));
    std::memcpy(packet.dancer.job_lev2, &PChar->jobs.job, sizeof(packet.dancer.job_lev2));

    packet.dancer.hpmax   = PChar->health.maxhp;
    packet.dancer.mpmax   = PChar->health.maxmp;
    packet.dancer.sjobflg = PChar->jobs.unlocked & 1;

    packet.encumbrance          = (PChar->m_EquipBlock) | (PChar->m_StatsDebilitation << 16);
    packet.can_thumbs_up_mentor = PChar->aman().canThumbsUp();
    packet.mentor_rank          = PChar->aman().getMentorRank();
    packet.mastery_rank         = PChar->aman().getMasteryRank();

    /* LD MASTER LEVELS */
    if (charutils::GetCharVar(PChar, "LevelCap") != 75) // 99 path = not the 75 path (LevelCap is unset for most players)
    {
        const JobPoints_t* PJobPoints   = PChar->PJobPoints->GetAllJobPoints();
        const bool         hasBreaker   = charutils::hasKeyItem(PChar, xi::KeyItem::MasterBreaker);
        constexpr uint8    jobsInPacket = sizeof(packet.job_mastery_levels);

        for (uint8 job = 1; job < MAX_JOBTYPE && job < jobsInPacket; ++job)
        {
            if (PJobPoints[job].totalJpSpent >= 2100 && PChar->jobs.job[job] >= 99) // a Master below 99 (Paragon T1 relevel) shows as a normal levelling job
            {
                packet.job_mastery_flags |= (1u << job);
                if (hasBreaker)
                {
                    packet.job_mastery_levels[job] = static_cast<uint8>(charutils::GetCharVar(PChar, "[ML]Lv" + std::to_string(job)));
                }
            }
        }
    }

    if (PChar->m_PMonstrosity != nullptr)
    {
        packet.dancer.mjob_no = xi::Job::MON;
        packet.dancer.sjob_no = xi::Job::MON;
    }
}
