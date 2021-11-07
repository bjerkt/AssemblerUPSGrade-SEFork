local TECH = {}
data:extend(
{
	{
		type = "technology",
		name = "asif",
		icon = "__AssemblerUPSGrade-SEFork__/graphics/ASIF.png",
		icon_size = 64,
		effects =
		{
			{type = "unlock-recipe", recipe = "asif-assembler-block" },
			{type = "unlock-recipe", recipe = "asif-chem-block" },
			{type = "unlock-recipe", recipe = "asif-logi-block" },
			{type = "unlock-recipe", recipe = "asif-oil-block" },
		},
		prerequisites = {"rocket-silo"},
		unit =
		{
			count = 25000,
			ingredients =
			{
				{"automation-science-pack", 1},
				{"logistic-science-pack", 1},
				{"chemical-science-pack", 1},		
				{"production-science-pack", 1},
				{"utility-science-pack", 1},
				{"space-science-pack", 1}	
			},
			time = 60
		},
		order = "a-b-c"
	}
})
--[[
data:extend(
{
	{
		type = "technology",
		name = "rf-asif",
		icon = "__AssemblerUPSGrade-SEFork__/graphics/" .. GRAPHICS_MAP["rf-asif"].icon,
		icon_size = 64,
		effects =
		{
			{type = "unlock-recipe", recipe = "rf-asif" },
			{type = "unlock-recipe", recipe = "rf-asif-recipe" },
			{type = "unlock-recipe", recipe = "sfpg-asif" },
			{type = "unlock-recipe", recipe = "sfpg-asif-recipe" },
			{type = "unlock-recipe", recipe = "sflo-asif" },
			{type = "unlock-recipe", recipe = "sflo-asif-recipe" },
			{type = "unlock-recipe", recipe = "sfho-asif" },
			{type = "unlock-recipe", recipe = "sfho-asif-recipe" },
		},
		prerequisites = {"asif"},
		unit =
		{
			count = 500000,
			ingredients =
			{
				{"automation-science-pack", 1},
				{"logistic-science-pack", 1},
				{"chemical-science-pack", 1},		
				{"production-science-pack", 1},
				{"utility-science-pack", 1},
				{"space-science-pack", 1}	
			},
			time = 60
		},
		order = "a-b-c"
	},
	{
		type = "technology",
		name = "oil-asif",
		icon = "__AssemblerUPSGrade-SEFork__/graphics/oil-asif.png",
		icon_size = 64,
		effects =
		{
			{type = "unlock-recipe", recipe = "oil-asif" },
			{type = "unlock-recipe", recipe = "oil-asif-recipe" },
			{type = "unlock-recipe", recipe = "lightcracking-asif" },
			{type = "unlock-recipe", recipe = "lightcracking-asif-recipe" },
			{type = "unlock-recipe", recipe = "heavycracking-asif" },
			{type = "unlock-recipe", recipe = "heavycracking-asif-recipe" },
			{type = "unlock-recipe", recipe = "asif-oil-block" },
		},
		prerequisites = {"asif"},
		unit =
		{
			count = 4000000,
			ingredients =
			{
				{"automation-science-pack", 1},
				{"logistic-science-pack", 1},
				{"chemical-science-pack", 1},		
				{"production-science-pack", 1},
				{"utility-science-pack", 1},
				{"space-science-pack", 1}	
			},
			time = 60
		},
		order = "a-b-c"
	}
})
]]
function TECH.create_technology(name, CONST)
	if CONST.DEBUG then
		log("Debug addTechnology " .. name)
	end
	--[[
	--Handled elsewhere.
	if name == "rocketfuel-asif" or name == "solidfuel-petroleumgas-asif" or name == "solidfuel-lightoil-asif" or name == "solidfuel-heavyoil-asif" then
		return
	end
	]]
	local tech = {
		type = "technology",
		name = name,
		icon = "__AssemblerUPSGrade-SEFork__/graphics/" .. CONST.GRAPHICS_MAP[name].icon,
		icon_size = 64,
		effects =
		{
			{type = "unlock-recipe", recipe = name },
			{type = "unlock-recipe", recipe = name .. "-recipe" },
		},
		prerequisites = CONST.TECH_DETAILS[name].prereqs,
		unit = {
			count = CONST.TECH_DETAILS[name].cost,
			ingredients = {
				{"automation-science-pack", 1},
				{"logistic-science-pack", 1},
				{"chemical-science-pack", 1},		
				{"production-science-pack", 1},
				{"utility-science-pack", 1},
				{"space-science-pack", 1}	
			},
			time = 60
		},
		order = "a-b-c"
	}
	return tech
end
return TECH