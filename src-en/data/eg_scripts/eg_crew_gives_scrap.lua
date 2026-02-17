local vter = mods.multiverse.vter
local userdata_table = mods.multiverse.userdata_table
local time_increment = mods.multiverse.time_increment

local scrap_crew = 
{
	eg_second_voice_officiary = 2,
	unique_corporate = 2,
}
script.on_internal_event(Defines.InternalEvents.JUMP_LEAVE, function(ShipManager)
	for crew in vter(ShipManager.vCrewList) do
		local scrap_gain = scrap_crew[crew.type]
		if scrap_gain then
			ShipManager:ModifyScrapCount(scrap_gain, false)
		end
	end
end)