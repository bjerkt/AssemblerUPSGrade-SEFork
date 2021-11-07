local CONST = require("prototypes.constants")
require("prototypes.functions")

data:extend({
	{
		name = "asif-assembler-block",
        energy_required = 10,
        ingredients = CONST.assembler_block.ingredients,
        result = "asif-assembler-block",
		enabled = false,
        type = "recipe"
    },
	{
		name = "asif-chem-block",
        energy_required = 10,
        ingredients = CONST.assembler_block.ingredients,
        result = "asif-chem-block",
		enabled = false,
        type = "recipe"
    },
	{
		name = "asif-oil-block",
        energy_required = 10,
        ingredients = CONST.assembler_block.ingredients,
        result = "asif-oil-block",
		enabled = false,
        type = "recipe"
    },
	{
		name = "asif-logi-block",
        energy_required = 1,
        ingredients = {
			{"logistic-chest-requester",1},
			{"logistic-chest-passive-provider",1}
        },
        result = "asif-logi-block",
		enabled = false,
        type = "recipe"
    },
})