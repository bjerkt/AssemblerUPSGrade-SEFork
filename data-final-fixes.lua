local CONST = require("prototypes.constants")
local RECIPE_UTIL = require("prototypes.recipe.recipe_util")
require("prototypes.functions")
--require("prototypes.oil-functions")

--require("prototypes.recipe.recipe-functions")
require("prototypes.recipe.recipe")
local ENTITY = require("prototypes.entity.entities")
--require("prototypes.entity.oil-entity")
local ITEMS = require("prototypes.item.items")
local TECH = require("prototypes.technology.technology")

function round(num)
	return num + (2^52 + 2^51) - (2^52 + 2^51)
end
data:extend({
	{
		type = "item-subgroup",
		name = "asif-buildings",
		group = "production",
		order = "e1",
	}
})
--Add new crafting category
data:extend({
	{
		type = "recipe-category",
		name = "asif-crafting"
	}
})

for asif_name, target_item in pairs(CONST.ITEM_LIST) do
	log("Creating: "..asif_name)
	local ingredient_list = {
		normal = {},
		expensive = {}
	}
	local blocks_needed = {
		normal = 1,
		expensive = 1
	}
	local starting_recipe_name = CONST.RECIPE_VARIANT_OVERRIDE[target_item] or RECIPE_UTIL.item[target_item].product_of[1]
	local starting_recipe = data.raw["recipe"][starting_recipe_name]
	RECIPE_UTIL.get_ingredient_list(starting_recipe, ingredient_list.normal, "normal", target_item, 1, CONST)
	RECIPE_UTIL.get_ingredient_list(starting_recipe, ingredient_list.expensive, "expensive", target_item, 1, CONST)
	-- Recipe is currently for 1 product, multiply all ingredients by desired output rate
	-- Also subtract bonus ingredients given by productivity
	local desired_rate = settings.startup[asif_name.."-items-per-second"].value
	for _,recipe_mode in pairs({"normal", "expensive"}) do
		RECIPE_UTIL.scale_ingredients(ingredient_list[recipe_mode], desired_rate, CONST.assembler_block.productivity)
		-- Now find out how many blocks we need running in parallel to get total time to 1 sec
		blocks_needed[recipe_mode] = ingredient_list[recipe_mode].energy_required.amount / CONST.assembler_block.speed
		ingredient_list[recipe_mode].energy_required = nil
	end
	-- Final post-processing
	-- Check for anything over the amount limit
	-- Should do some scaling in the future to bump everything back down
	for _,recipe_mode in pairs({"normal", "expensive"}) do
		for _,ingredient in pairs(ingredient_list[recipe_mode]) do
			if ingredient.amount > CONST.MAX_INPUT_AMOUNT then
				log("Error creating "..asif_name.." - "..ingredient.name.." exceeded amount limit. Current amount: "..ingredient.amount)
				log("Truncating amount to "..CONST.MAX_INPUT_AMOUNT)
				ingredient.amount = CONST.MAX_INPUT_AMOUNT
			end
		end
	end
	-- Round everything to integers
	for _,recipe_mode in pairs({"normal", "expensive"}) do
		for _,ingredient in pairs(ingredient_list[recipe_mode]) do
			ingredient.amount = round(ingredient.amount)
		end
		blocks_needed[recipe_mode] = round(blocks_needed[recipe_mode])
	end
	-- Make ASIF recipe
	data:extend({RECIPE_UTIL.create_assembler_entity_recipe(asif_name, blocks_needed)})
	-- Make ASIF entity
	ENTITY.create_assembler_entity(asif_name, blocks_needed["normal"], CONST)
	-- Make ASIF item
	data:extend({ITEMS.createItem(false, asif_name, CONST)})
	-- Make ASIF tech
	data:extend({TECH.create_technology(asif_name, CONST)})
	-- Make recipe ASIF uses
	data:extend({RECIPE_UTIL.create_asif_working_recipe(asif_name, target_item, desired_rate, ingredient_list)})
	
end
--[[
for asif_name,stock_item in pairs(ITEM_LIST) do
	local compression_ratio = settings.startup[asif_name .. "-ratio"].value
	local productivity_factor, building_mod_bonus = getProductivityAndSpeedFactors(stock_item)
	local crafting_cat = data.raw.recipe[stock_item].category or "crafting"
	local plastic_override = false
	if crafting_cat == "chemistry"
	then
		plastic_override = true
	end
	
	--Factors in productivity factor for us, and knows whether or not the item *can* benefit from productivity.
	local nrips,erips = computeItemsPerSecond(stock_item)

	local ipsn = nrips * compression_ratio
	local ipse = erips * compression_ratio
	
	--Determine how many assemblers make up our ASIF
	local result = { ["expensive"] = {}, ["normal"] = {}, ["recip_n"] = {}, ["recip_e"] = {}, ["fluid_per_second"] = 0 }
	
	--unwindAssemblersNeeded requires productivity factor (if applicable) to already be factored in.
	unwindAssemblersNeeded(stock_item, "n", ipsn, result, plastic_override)
	unwindAssemblersNeeded(stock_item, "e", ipse, result, plastic_override)

	local normal_ass_needed = compression_ratio
	local expensive_ass_needed = compression_ratio
	for i_name,num in pairs(result.normal) do
		--New way: Assume partially utilized buildings are kept busy through ASIF magic.
		normal_ass_needed = normal_ass_needed + num
		--Old way: assume we have partially used extra buildings for each intermediate.
		--normal_ass_needed = normal_ass_needed + math.ceil(num)
	end
	for _,num in pairs(result.expensive) do
		expensive_ass_needed = expensive_ass_needed + num
		--expensive_ass_needed = expensive_ass_needed + math.ceil(num)
	end
	normal_ass_needed = math.ceil(normal_ass_needed)
	expensive_ass_needed = math.ceil(expensive_ass_needed)
	
	--Create ASIFs
	if crafting_cat == "crafting" or crafting_cat == "advanced-crafting" or crafting_cat == "basic-crafting" or crafting_cat == "crafting-with-fluid"
	then
		createEntityRecipe(asif_name, normal_ass_needed, expensive_ass_needed, "a", compression_ratio)
		createAssemblerEntity(asif_name, compression_ratio, normal_ass_needed, expensive_ass_needed, result.fluid_per_second)
	elseif crafting_cat == "chemistry"
	then
		createEntityRecipe(asif_name, normal_ass_needed, expensive_ass_needed, "c", compression_ratio)
		createChemPlantEntity(asif_name, compression_ratio, normal_ass_needed, expensive_ass_needed, result.fluid_per_second)
	end
	
	--Create the recipe the ASIF uses to build components
	createResultRecipes(stock_item, asif_name, compression_ratio, ipsn, ipse, result)
	createItem(plastic_override, asif_name)
	
	--Add research
	addTechnology(asif_name)
end
]]
--///////////////////////////////////////////////
--oil is its own little world and a bit simpler than the other items as each thing is only a single stage, so we do it in its own loop.
--///////////////////////////////////////////////
--[[
local compression_ratio = settings.startup["oil-asif-ratio"].value

local productivity_factor = oil_productivity_factor
local building_mod_bonus = oil_total_speed_bonus

--Create item definition
ITEMS.createOilRefItem("oil-asif", CONST)

--There's a dependency here between the recipe and the building. You need to know
-- how much the recipe needs/produces to build the entity.
--So here's the order we do things:
--1. Create the recipe for the building itself
--2. Recompute the recipe for oil processing. As in X crude oil in = y HO/LO/PG out.
--3. Determine how many inputs and outputs are needed to handle the fluid flow rate of the new recipe.
--4. Determine how large the building is supposed to be (limiter vs unlimited size)
--5. Create the building and place the fluid inputs along the side(s).

--Create recipe for the Oil Refinery ASIF building itself
local new_recipe = util.table.deepcopy(data.raw.recipe["oil-refinery"])
new_recipe.result = "oil-asif"
new_recipe.name = "oil-asif"
new_recipe.energy_required = 30

new_recipe.overload_multiplier = 1.0
new_recipe.requester_paste_multiplier = 1
new_recipe.ingredients = {
	{ "asif-oil-block", compression_ratio },
	{ "beacon", 16 },
	{ "speed-module-3", 16 * 2 },
	{ "substation", math.ceil(compression_ratio / 6) },
}
data:extend({new_recipe})

local asif_adv_oil_recipe = computeAdvOilProcRecipe("advanced-oil-processing", compression_ratio, productivity_factor)
createAdvOilProResultRecipes("advanced-oil-processing", "oil-asif", asif_adv_oil_recipe)
createOilRefEntity("oil-asif", compression_ratio, asif_adv_oil_recipe)

--///////////////////////////////////////////////
--Now we create the cracking recipes/buildings.
--///////////////////////////////////////////////
for _,item in pairs({"hc-asif", "lc-asif"}) do
	local compression_ratio = settings.startup[item .. "-ratio"].value
	
	--Add new crafting category
	data:extend({
		{
			type = "recipe-category",
			name = item
		}
	})
	
	--Create item definition
	createItem(true,item)
	
	--Recipe to build the ASIF
	createEntityRecipe(item, compression_ratio, compression_ratio, "c", compression_ratio)
	
	local asif_result_recipe = computeAdvOilProcRecipe(RECIPE_MAP[item], compression_ratio, productivity_factor)
	createAdvOilProResultRecipes(RECIPE_MAP[item], item, asif_result_recipe)

	--Create the entity of the ASIF
	createCrackingChemPlantEntity(item, compression_ratio, asif_result_recipe)
end
]]