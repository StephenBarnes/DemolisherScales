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
	if event.entity == nil or not event.entity.valid then return end
	if not toDeconstruct[event.entity.name] then return end

	for _, force in pairs(game.forces) do
		if force ~= nil and force.valid and event.entity.valid then
				-- Note the check for event.entity.valid is necessary each time because e.g. in Blueprint Sandboxes mod with "auto-build" turned on, it erases entities as soon as one force marks them for deconstruction, then the game crashes when another force tries to also mark it for deconstruction.
			event.entity.order_deconstruction(force)
		end
	end
end

script.on_event(defines.events.on_trigger_created_entity, onCreatedEntity)