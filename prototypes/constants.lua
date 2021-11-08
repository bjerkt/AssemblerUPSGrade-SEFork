local CONST = {}
CONST.DEBUG = false
CONST.assembler_block = {}
-- Total speed of 1 assembler block
CONST.assembler_block.speed = 2.25*8
-- Total productivity of 1 assembler block
CONST.assembler_block.productivity = 0.32
-- Total pollution of 1 assembler block
CONST.assembler_block.pollution = 24.27*8
-- Total power consumption of 1 assembler block (in kW)
-- All 8 assemblers + beacon + 16 stack inserters
CONST.assembler_block.energy_usage = (2792.5*8)+200+(133*16)
-- Footprint of 1 assembler block (in square meters)
CONST.assembler_block.area = 12*13
-- Ingredients list of 1 assembler block
CONST.assembler_block.ingredients = {
	{name="assembling-machine-3", amount=8},
	{name="beacon", amount=1},
	{name="stack-inserter", amount=16},
	{name="productivity-module-3", amount=32},
	{name="speed-module-3", amount=8},
	{name="express-transport-belt", amount=31},
	{name="express-underground-belt", amount=2}
}


--Number of beacons around a standard building.
CONST.beacon_count = 12

CONST.RECIPE_USES_FLUID = {
	["bluecircuit-asif"] = true,
	["spd-3-asif"] = true,
	["prod-3-asif"] = true,
	["plastic-asif"] = true,
	["rocketfuel-asif"] = true,
	["solidfuel-petroleumgas-asif"] = true,
	["solidfuel-lightoil-asif"] = true,
	["solidfuel-heavyoil-asif"] = true,
	["rocketcontrolunit-asif"] = true,
	["arty-shell-asif"] = true
}
CONST.MAX_FLUID_PER_INPUT_PER_SECOND = settings.startup["max-flow-rate"].value
-- Game has hard limit on input amount
CONST.MAX_INPUT_AMOUNT = 65535

CONST.TECH_DETAILS = {
	["arty-shell-asif"] = { cost = 750000, prereqs = {"greencircuit-asif", "plastic-asif"} },
	["greencircuit-asif"] = { cost = 250000, prereqs = {"asif"} },
	["redcircuit-asif"] = { cost = 500000, prereqs = {"greencircuit-asif"} },
	["bluecircuit-asif"] = { cost = 1000000, prereqs = {"redcircuit-asif"} },
	--["se-bc-asif"] = { cost = 1000000, prereqs = {"bluecircuit-asif"} },
	--["beacon-asif"] = { cost = 1000000, prereqs = {"redcircuit-asif"} },
	["lowdensitystructure-asif"] = { cost = 500000, prereqs = {"asif"} },
	--["se-lds-asif"] = { cost = 500000, prereqs = {"lds-asif"} },
	["heatshielding-asif"] = { cost = 500000, prereqs = {"asif"} },
	--["se-hsi-asif"] = { cost = 500000, prereqs = {"se-hs-asif"} },
	["engine-asif"] = { cost = 500000, prereqs = {"asif"} },
	["plastic-asif"] = { cost = 500000, prereqs = {"asif"} },
	--RF is handled on its own since it unlocks multiple recipes.
	["rocketfuel-asif"] = { cost = 500000, prereqs = {"asif"} },
	["rocketcontrolunit-asif"] = { cost = 1000000, prereqs = {"bluecircuit-asif"} },
	--["spd-3-asif"] = { cost = 1000000, prereqs = {"bluecircuit-asif"} },
	--["prod-3-asif"] = { cost = 1000000, prereqs = {"bluecircuit-asif"} },
	--["eff-3-asif"] = { cost = 1000000, prereqs = {"bluecircuit-asif"} },
	--Oil is handled on its own since it unlocks multiple recipes.
	["oil-asif"] = { cost = 4000000, prereqs = {"asif"} },
}
-- Map of ASIF name to desired item output
CONST.ITEM_LIST = {
	--["arty-shell-asif"] = "artillery-shell",
	["greencircuit-asif"] = "electronic-circuit",
	["redcircuit-asif"] = "advanced-circuit",
	["bluecircuit-asif"] = "processing-unit",
	--["se-bc-asif"] = "se-processing-unit-holmium",
	["lowdensitystructure-asif"] = "low-density-structure",
	--["se-lds-asif"] = "se-low-density-structure-beryllium",
	["heatshielding-asif"] = "se-heat-shielding",
	--["se-hsi-asif"] = "se-heat-shielding-iridium",
	["engine-asif"] = "engine-unit",
	--["plastic-asif"] = "plastic-bar",
	["rocketfuel-asif"] = "rocket-fuel",
	--["solidfuel-petroleumgas-asif"] = "solid-fuel-from-petroleum-gas",
	--["solidfuel-lightoil-asif"] = "solid-fuel-from-light-oil",
	--["solidfuel-heavyoil-asif"] = "solid-fuel-from-heavy-oil",
	--["rocketcontrolunit-asif"] = "rocket-control-unit",
	--["spd-3-asif"] = "speed-module-3",
	--["prod-3-asif"] = "productivity-module-3",
	--["eff-3-asif"] = "effectivity-module-3",
	--["beacon-asif"] = "beacon",
}
CONST.RECIPE_MAP = {
	["heavycracking-asif"] = "heavy-oil-cracking",
	["lightcracking-asif"] = "light-oil-cracking"
}
-- Root ingredients; we don't need to recurse past these
CONST.BASE_ITEMS = {
	["copper-plate"] = true,
	["iron-plate"] = true,
	["steel-plate"] = true,
	["plastic-bar"] = true,
	["sulfuric-acid"] = true,
	["solid-fuel"] = true,
	["petroleum-gas"] = true,
	["heavy-oil"] = true,
	["light-oil"] = true,
	["sulfur"] = true,
	["coal"] = true,
	["water"] = true,
	["wood"] = true,
	["stone"] = true,
	["stone-brick"] = true,
	["glass"] = true,
	["sand"] = true,
	["se-vitamelange-extract"] = true,
	["se-beryllium-ingot"] = true,
	["se-holmium-ingot"] = true,
	["se-iridium-ingot"] = true,
	["se-naquium-ingot"] = true,
	["se-cryonite-rod"] = true,
	["se-vulcanite-block"] = true

}
CONST.PLASTIC_BASE_RECIPES =
{
	["coal"] = true,
	["sulfur"] = true,
	["petroleum-gas"] = true,
	["light-oil"] = true,
	["heavy-oil"] = true,
	["water"] = true
}
CONST.FLUID_NAMES = 
{
	["sulfuric-acid"] = true,
	["petroleum-gas"] = true,
	["light-oil"] = true,
	["heavy-oil"] = true,
	["water"] = true
}

CONST.RECIPE_VARIANT_OVERRIDE = {
	["electronic-circuit"] = settings.startup["greencircuit-asif-recipe-variant"].value,
	["processing-unit"] = settings.startup["bluecircuit-asif-recipe-variant"].value,
	["low-density-structure"] = settings.startup["lowdensitystructure-asif-recipe-variant"].value,
	["se-heat-shielding"] = settings.startup["heatshielding-asif-recipe-variant"].value,
	["rocket-fuel"] = settings.startup["rocketfuel-asif-recipe-variant"].value
}

--replicate changes here to control.lua!
CONST.ORDER_MAP = {
	["greencircuit-asif"] = "a",
	["redcircuit-asif"] = "b",
	["bluecircuit-asif"] = "c",
	--["se-bc-asif"] = "c1",
	["lowdensitystructure-asif"] = "e",
	--["se-lds-asif"] = "e1",
	["heatshielding-asif"] = "h",
	--["se-hsi-asif"] = "h1",
	["engine-asif"] = "d",
	["plastic-asif"] = "f",
	["rocketfuel-asif"] = "h",
	--["solidfuel-petroleumgas-asif"] = "g2",
	--["solidfuel-lightoil-asif"] = "g1",
	--["solidfuel-heavyoil-asif"] = "g3",
	["rocketcontrolunit-asif"] = "i",
	["arty-shell-asif"] = "j",
	["oil-asif"] = "o1",
	["lightcracking-asif"] = "o2",
	["heavycracking-asif"] = "o3",
	["spd-3-asif"] = "z1",
	["prod-3-asif"] = "z2",
	["eff-3-asif"] = "z3",
	["beacon-asif"] = "z4",
}

--//modules (level 3)
local spd_module_speed_bonus = data.raw.module["speed-module-3"].effect.speed.bonus
local spd_module_pwr_penality = data.raw.module["speed-module-3"].effect.consumption.bonus
local prod_mod_speed_penalty = data.raw.module["productivity-module-3"].effect.speed.bonus
prod_mod_prod_bonus = data.raw.module["productivity-module-3"].effect.productivity.bonus
local prod_mod_pwr_penality = data.raw.module["productivity-module-3"].effect.consumption.bonus
prod_mod_pollution_penalty = data.raw.module["productivity-module-3"].effect.pollution.bonus

--//Beacon
tmp = string.gsub(data.raw["beacon"]["beacon"].energy_usage,"%kW","")
beacon_pwr_drain = tonumber(tmp)

beacon_pwr_penalty = spd_module_pwr_penality * CONST.beacon_count
total_beacon_speed_bonus = spd_module_speed_bonus * CONST.beacon_count

--//Assembler (refers to vanilla object)
CONST.base_assembler_entity = table.deepcopy(data.raw["assembling-machine"]["assembling-machine-3"])
CONST.base_assembler_entity.crafting_speed = 1
CONST.base_assembler_entity.crafting_categories = { "asif-crafting" }
CONST.base_assembler_entity.allowed_effects = nil
CONST.base_assembler_entity.module_specification.module_slots = 0
CONST.base_assembler_entity.scale_entity_info_icon = true
CONST.base_assembler_entity.ingredient_count = 255
CONST.base_assembler_entity.base_productivity = 0
-- Graphics changes
CONST.base_assembler_entity.icon_size = 64
for i,_ in pairs(CONST.base_assembler_entity.animation.layers) do
	CONST.base_assembler_entity.animation.layers[i].filename = "__AssemblerUPSGrade-SEFork__/graphics/entity/assembler-model.png"
	CONST.base_assembler_entity.animation.layers[i].height = 237
	CONST.base_assembler_entity.animation.layers[i].width = 214
	CONST.base_assembler_entity.animation.layers[i].hr_version.filename = "__AssemblerUPSGrade-SEFork__/graphics/entity/uhr/assembler-model.png"
	CONST.base_assembler_entity.animation.layers[i].hr_version.height = 237*4
	CONST.base_assembler_entity.animation.layers[i].hr_version.width = 214*4
	CONST.base_assembler_entity.animation.layers[i].hr_version.scale = 0.25
end
local edge_art = {
	filename = "__AssemblerUPSGrade-SEFork__/graphics/entity/assembler-border.png",
	frame_count = CONST.base_assembler_entity.animation.layers[1].frame_count,
	line_length = CONST.base_assembler_entity.animation.layers[1].line_length,
	height = 256,
	priority = "high",
	scale = 0.69,
	width = 256,
}
table.insert(CONST.base_assembler_entity.animation.layers, edge_art)

--[[
local tmp = string.gsub(base_ass_entity.energy_usage,"%kW","")
assembler_base_pwr_use = tonumber(tmp)
assembler_base_speed = base_ass_entity.crafting_speed
assembler_base_pollution = base_ass_entity.energy_source.emissions_per_minute
assembler_base_modules = base_ass_entity.module_specification.module_slots

local assembler_modules_speed_effect_prod = assembler_base_modules * prod_mod_speed_penalty
local assembler_modules_speed_effect_speed = assembler_base_modules * spd_module_speed_bonus
local assembler_modules_pwr_penalty_prod = assembler_base_modules * prod_mod_pwr_penality
local assembler_modules_pwr_penalty_speed = assembler_base_modules * spd_module_pwr_penality
assembler_productivity_factor = assembler_base_modules * prod_mod_prod_bonus

--Total bonus with prod modules in assemblers
assembler_total_speed_bonus_prod = assembler_base_speed * (assembler_modules_speed_effect_prod + total_beacon_speed_bonus + 1)
--Total bonus with speed modules in assemblers
assembler_total_speed_bonus_speed = assembler_base_speed * (assembler_modules_speed_effect_speed + total_beacon_speed_bonus + 1)
assembler_per_unit_pwr_drain_penalty_prod = (beacon_pwr_penalty + assembler_modules_pwr_penalty_prod + 1)
assembler_per_unit_pwr_drain_penalty_speed = (beacon_pwr_penalty + assembler_modules_pwr_penalty_speed + 1)
--Note: value DOES NOT include power drain from beacons (IE the 320Kw the beacon itself uses). This is to be done in the
-- entity function itself.
assembler_total_pwr_draw_prod = assembler_base_pwr_use * assembler_per_unit_pwr_drain_penalty_prod
assembler_total_pwr_draw_speed = assembler_base_pwr_use * assembler_per_unit_pwr_drain_penalty_speed
]]

--//Chem plant (refers to vanilla object)
base_chem_entity = data.raw["assembling-machine"]["chemical-plant"]
local tmp = string.gsub(base_chem_entity.energy_usage,"%kW","")
chem_base_pwr_use = tonumber(tmp)
chem_base_speed = base_chem_entity.crafting_speed
chem_base_pollution = base_chem_entity.energy_source.emissions_per_minute
chem_base_modules = base_chem_entity.module_specification.module_slots

local chem_modules_speed_effect = chem_base_modules * prod_mod_speed_penalty
local chem_modules_pwr_penalty = chem_base_modules * prod_mod_pwr_penality
chem_productivity_factor = chem_base_modules * prod_mod_prod_bonus

chem_total_speed_bonus = chem_base_speed * (chem_modules_speed_effect + total_beacon_speed_bonus + 1)
chem_per_unit_pwr_drain_penalty = (beacon_pwr_penalty + chem_modules_pwr_penalty + 1)
chem_total_pwr_draw = chem_base_pwr_use * chem_per_unit_pwr_drain_penalty

--//Oil Refinery (refers to vanilla object)
base_oil_entity = data.raw["assembling-machine"]["oil-refinery"]
local tmp = string.gsub(base_oil_entity.energy_usage,"%kW","")
oil_base_pwr_use = tonumber(tmp)
oil_base_speed = base_oil_entity.crafting_speed
oil_base_pollution = base_oil_entity.energy_source.emissions_per_minute
oil_base_modules = base_oil_entity.module_specification.module_slots

local oil_modules_speed_effect = oil_base_modules * prod_mod_speed_penalty
local oil_modules_pwr_penalty = oil_base_modules * prod_mod_pwr_penality
oil_productivity_factor = oil_base_modules * prod_mod_prod_bonus

oil_total_speed_bonus = oil_base_speed * (oil_modules_speed_effect + (spd_module_speed_bonus * 16) + 1)
oil_per_unit_pwr_drain_penalty = (beacon_pwr_penalty + oil_modules_pwr_penalty + 1)
oil_total_pwr_draw = oil_base_pwr_use * oil_per_unit_pwr_drain_penalty

--///
--Reminder: Crafting speed formula is:
--final speed = Recipe time / (assembler speed * (beacon_effect + module_spd_effect + 1)
--final speed is the number of seconds it takes to craft one item, so to get items/second,
-- you need to divide 1 by it. IE: 1/final speed = items per second.
--Note: Productivity modules also cause additional items to be produced, so remember to
-- factor in that effect as well. IE: Items per second = ProdModBonus * 1/final_speed
--///

--///
--Color, tint, and graphics section
--///

CONST.GRAPHICS_MAP = {
	["greencircuit-asif"] = {icon = "gc-asif.png", tint = {r= .2, g = .6, b = .01, a = 1}},
	["redcircuit-asif"] = {icon = "rc-asif.png", tint = {r= .78, g = .01, b = .01, a = 1}},
	["bluecircuit-asif"] = {icon = "bc-asif.png", tint = {r= .2, g = .13, b = .72, a = 1}},
	--["se-bc-asif"] = {icon = "bc-asif.png", tint = {r= .2, g = .13, b = .72, a = 1}},
	["lowdensitystructure-asif"] = {icon = "lds-asif.png", tint = {r= .88, g = .75, b = 0.5, a = 1}},
	--["se-lds-asif"] = {icon = "lds-asif.png", tint = {r= .88, g = .75, b = 0.5, a = 1}},
	["heatshielding-asif"] = {icon = "se-hs-asif.png", tint = {r= 64, g = 69, b = 74, a = 255}},
	--["se-hsi-asif"] = {icon = "se-hs-asif.png", tint = {r= 64, g = 69, b = 74, a = 255}},
	["engine-asif"] = {icon = "eng-asif.png", tint = {r= .49, g = .35, b = .31, a = 1}},
	["plastic-asif"] = {icon = "pla-asif.png", tint = data.raw.recipe["plastic-bar"].crafting_machine_tint.primary},
	["rocketfuel-asif"] = {icon = "rf-asif.png", tint = {r= .8, g = .65, b = .11, a = 1}},
	["solidfuel-petroleumgas-asif"] = {icon = "sfpg-asif.png", tint = data.raw.recipe["solid-fuel-from-petroleum-gas"].crafting_machine_tint.primary},
	["solidfuel-lightoil-asif"] = {icon = "sflo-asif.png", tint = data.raw.recipe["solid-fuel-from-light-oil"].crafting_machine_tint.primary},
	["solidfuel-heavyoil-asif"] = {icon = "sfho-asif.png", tint = data.raw.recipe["solid-fuel-from-heavy-oil"].crafting_machine_tint.primary},
	["rocketcontrolunit-asif"] = {icon = "rcu-asif.png", tint = {181, 255, 181, 255}},
	["prod-3-asif"] = {icon = "prod-3-asif.png", tint = {r= 240, g = 66, b = 19, a = 255}},
	["spd-3-asif"] = {icon = "spd-3-asif.png", tint = {r= .25, g = .93, b = .92, a = 1}},
	["eff-3-asif"] = {icon = "eff-3-asif.png", tint = {r= 0, g = 1, b = 0, a = 1}},
	["oil-asif"] = {icon = "oil-asif.png", tint = {r= 0, g = 0, b = 0, a = 1}},
	["lightcracking-asif"] = {icon = "lc-asif.png", tint = data.raw.recipe["heavy-oil-cracking"].crafting_machine_tint.primary},
	["heavycracking-asif"] = {icon = "hc-asif.png", tint = data.raw.recipe["light-oil-cracking"].crafting_machine_tint.primary},
	["arty-shell-asif"] = {icon = "arty-shell-asif.png", tint = {r= 255, g = 149, b = 0, a = 255}},
	["beacon-asif"] = {icon = "beacon-asif.png", tint = {r= 156, g = 99, b = 66, a = 255}},
}

CONST.RECIPE_TINT = {r= 1, g = .533, b = 0, a = 1}
return CONST