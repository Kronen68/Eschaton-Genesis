-- stolen from Fusion 

local function vter(cvec)
    local i = -1
    local n = cvec:size()
    return function()
        i = i + 1
        if i < n then return cvec[i] end
    end
end

-- Автоматический ремонт систем корабля
-- speed = 1  -> стандартная скорость авто-кораблей
-- speed = 2  -> в 2 раза быстрее
-- speed = 0.5 -> в 2 раза медленнее
-- speed < 0  -> откат ремонта (но не ломает системы)
function setAutoRepair(speed, ship)
    for system in vter(ship.vSystemList) do
        if not system.bBreached then
            system:PartialRepair(speed, true)
        end
    end
end

-- Автоматический ремонт одной системы
function setAutoRepairSingleSystem(speed, systemId, ship)
    if ship:HasSystem(systemId) then
        local system = ship:GetSystem(systemId)
        if not system.bBreached then
            system:PartialRepair(speed, true)
        end
    end
end

-- Делает рабочим аугмент
script.on_internal_event(Defines.InternalEvents.SHIP_LOOP, function(ship)
    local repairValue = ship:GetAugmentationValue("EG_AUTO_REPAIR")
    if repairValue ~= 0 then
        setAutoRepair(repairValue, ship)
    end
end)

