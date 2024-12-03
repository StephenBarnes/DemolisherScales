-- Create an item for the demolisher scale.
data:extend({
	{
		type = "item",
		name = "demolisher-scale",
		icon = "__DemolisherScales__/scale_icon.png",
		subgroup = data.raw.item["tungsten-plate"].subgroup,
		order = data.raw.item["tungsten-plate"].order .. "-b",
		stack_size = data.raw.item["tungsten-plate"].stack_size,
		weight = data.raw.item["tungsten-plate"].weight,
		pick_sound = data.raw.item["tungsten-ore"].pick_sound,
		drop_sound = data.raw.item["tungsten-ore"].drop_sound,
		inventory_move_sound = data.raw.item["tungsten-ore"].inventory_move_sound,
	}
})

-- Add the demolisher scale as ingredient to big-mining-drill.
if data.raw.recipe["big-mining-drill"] ~= nil and data.raw.recipe["big-mining-drill"].ingredients ~= nil then
	table.insert(data.raw.recipe["big-mining-drill"].ingredients, {
		type = "item",
		name = "demolisher-scale",
		amount = 1,
	})
else
	log("Could not add demolisher scale to big-mining-drill: recipe not found.")
end

-- Update tech description with addendum.
if data.raw.technology["big-mining-drill"].localised_description == nil then
	data.raw.technology["big-mining-drill"].localised_description = { "",
		{ "technology-description.big-mining-drill" },
		{ "technology-description.big-mining-drill-addendum" } }
elseif type(data.raw.technology["big-mining-drill"].localised_description) == "string" then
	data.raw.technology["big-mining-drill"].localised_description = { "",
		{ data.raw.technology["big-mining-drill"].localised_description },
		{ "technology-description.big-mining-drill-addendum" } }
elseif type(data.raw.technology["big-mining-drill"].localised_description) == "table" then
	data.raw.technology["big-mining-drill"].localised_description = { "",
		data.raw.technology["big-mining-drill"].localised_description,
		{ "technology-description.big-mining-drill-addendum" } }
else
	log("Could not update description of big-mining-drill tech.")
end

-- Add the demolisher scale as a drop from the demolisher.
-- For calculating: all demolisher sizes give ~38-44 boulders, each with 1-33 tungsten (so 17 average).
local function hasMinableResults(ent)
	return ent ~= nil and ent.minable ~= nil and ent.minable.results ~= nil
end
local dropMult = settings.startup["DemolisherScales-scale-drop-multiplier"].value
for size, amounts in pairs({
	small = {0, 0.5}, -- average 0.25, so 10 scales per demolisher.
	medium = {0, 1}, -- average 0.5, so 20 scales per demolisher.
	big = {0, 4}, -- average 2, so 80 scales per demolisher.
	behemoth = {0, 20}, -- average 10, so 400 scales per demolisher.
}) do
	local max = amounts[2] * dropMult
	local min = amounts[1] * dropMult
	-- Handle case where min is 0 and max is like 0.2.
	-- In this case, we make it 0 and set the extra_count_fraction to half of max.
	-- For example, if min is 0, max is 0.1, then it should be 0 with a 5% chance of the extra. 
	-- Note the extra_count_fraction here isn't shown in Factoriopedia, but it did take effect when I tested it in-game.
	local extraProb = nil
	if min == 0 and max < 1 and max > 0 then
		extraProb = max / 2
		max = 0
	end
	if extraProb ~= nil or max >= 1 then
		if hasMinableResults(data.raw["simple-entity"][size .. "-demolisher-corpse"]) then
			table.insert(data.raw["simple-entity"][size .. "-demolisher-corpse"].minable.results, {
				type = "item",
				name = "demolisher-scale",
				amount_min = min,
				amount_max = max,
				extra_count_fraction = extraProb,
			})
		end
		-- Special "head" entities - might be created by Biochemistry mod?
		if hasMinableResults(data.raw["simple-entity"][size .. "-demolisher-corpse-head"]) then
			table.insert(data.raw["simple-entity"][size .. "-demolisher-corpse-head"].minable.results, {
				type = "item",
				name = "demolisher-scale",
				amount_min = min,
				amount_max = max,
				extra_count_fraction = extraProb,
			})
		end
	end
end

-- TODO possible future feature: add an option to drop a few from minable boulders, etc. on Vulcanus, so you can still do some guerilla tungsten mining at the start.