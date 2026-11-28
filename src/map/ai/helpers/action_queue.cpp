/*
===========================================================================

  Copyright (c) 2010-2015 Darkstar Dev Teams

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

#include "action_queue.h"

#include "ai/ai_container.h"
#include "entities/base_entity.h"
/* LD AI PLAYERS ACTION QUEUE LIVENESS */

CAIActionQueue::CAIActionQueue(CBaseEntity* entity)
: PEntity(entity)
, m_OwnerSerial(entity != nullptr ? entity->serial() : 0)
{
}

void CAIActionQueue::pushAction(queueAction_t&& action)
{
    if (action.checkState)
    {
        actionQueue.push(std::move(action));
    }
    else
    {
        timerQueue.push(std::move(action));
    }
}

void CAIActionQueue::checkAction(timer::time_point tick)
{
    while (!timerQueue.empty() && tick > timerQueue.top().deadline)
    {
        queueAction_t action = timerQueue.pop();
        handleAction(action);
    }

    while (!actionQueue.empty() && tick > actionQueue.top().deadline && PEntity->PAI->CanChangeState())
    {
        queueAction_t action = actionQueue.pop();
        handleAction(action);
    }
}

void CAIActionQueue::handleAction(queueAction_t& action)
{
    if (!action.func)
    {
        return;
    }

    // The entity owning this queue can be gone while a Lua timer is still pending (a zone change frees the
    // old character object). Running the callback would hand Lua a dead handle, so let the timer lapse.
    if (!CBaseEntity::isLive(PEntity, m_OwnerSerial))
    {
        return;
    }

    action.func(PEntity);
}

auto CAIActionQueue::isEmpty() const -> bool
{
    return actionQueue.empty() && timerQueue.empty();
}

void CAIActionQueue::clearActionQueue()
{
    actionQueue.clear();
}

void CAIActionQueue::clearTimerQueue()
{
    timerQueue.clear();
}
