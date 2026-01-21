local vter = mods.fusion.vter
local userdata_table = mods.multiverse.userdata_table
local time_increment = mods.multiverse.time_increment

script.on_internal_event(Defines.InternalEvents.ACTIVATE_POWER, function(power, ship)
    local crew = power.crew
    if crew.type == "unique_mirrored" then
        for room in vter(ship.ship.vRoomList) do
            room.extend.hullDamageResistChance = 100

            userdata_table(room, "mods.multiverse.mirroredResist").time = 6
        end
    end
end)

script.on_internal_event(Defines.InternalEvents.SHIP_LOOP, function(ship)
    local roomDefs = Hyperspace.CustomShipSelect.GetInstance():GetDefinition(ship.myBlueprint.blueprintName).roomDefs
    for room in vter(ship.ship.vRoomList) do
        local resistData = userdata_table(room, "mods.multiverse.mirroredResist")
        if resistData.time then
            if resistData.time > 0 then
                -- Tick timer while it exists
                resistData.time = resistData.time - time_increment()

                -- Keep resist chances maxed, needed for compatibility with other mods that alter them
                room.extend.hullDamageResistChance = 100
            else
                -- Delete timer when it reaches 0 and reset resist chances
                resistData.time  = nil
                if roomDefs:has_key(room.iRoomId) then
                    local roomDef = roomDefs[room.iRoomId]
                    room.extend.hullDamageResistChance = roomDef.hullDamageResistChance
                else
                    room.extend.hullDamageResistChance = 0
                end
            end
        end
    end
end, -100)
