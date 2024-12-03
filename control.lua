-- List of demolisher corpse boulder entities to mark for deconstruction.
local toDeconstruct = {}
for _, size in pairs({"small", "medium", "big", "behemoth"}) do
	local name1 = size .. "-demolisher-corpse"
	if prototypes.entity[name1] then
		toDeconstruct[name1] = true
	end
	local name2 = size .. "-demolisher-corpse-head"
	if prototypes.entity[name2] then
		toDeconstruct[name2] = true
	end
end

local function onCreatedEntity(event)
	if not settings.global["DemolisherScales-mark-deconstruction"].value then return end
	if not toDeconstruct[event.entity.name] then return end

	for _, force in pairs(game.forces) do
		event.entity.order_deconstruction(force)
	end
end

script.on_event(defines.events.on_trigger_created_entity, onCreatedEntity)