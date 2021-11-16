local RECIPE_UTIL = {}
--[[ 
    Format the various result structures to: 
    {
        normal={
            res1={name=res1, amount=amnt1}...resN={name=resN, amount=amntN}
        },
        expensive={
            res1={name=res1, amount=amnt1}...resN={name=resN, amount=amntN}
        }
    }
]]
local function parse_result(recipe_core)
    local res = {}
    -- result is string, name of the item. Accompanies result_count=N or default of 1
    if recipe_core.result then
        res[recipe_core.result] = {
            name = recipe_core.result,
            amount = recipe_core.result_count or 1
        }
    -- Remember: results can have duplicates. In that case, just add to previous amount
    elseif recipe_core.results then
        for i,result in pairs(recipe_core.results) do
            local tmp = {}
            if result.name then
                -- Using named keys, {name, amount/(amount_min,amount_max), ?type} is enforced
                tmp.name = result.name
                tmp.type = result.type or "item"
                if result.amount then
                    tmp.amount = result.amount
                elseif result.amount_min then
                    tmp.amount = result.amount_min
                end
            else
                -- Using numbered keys, {name, amount} is enforced
                -- From Wiki: "For fluids, the full format always has to be used"
                -- Therefore, this is always an item
                tmp.name = result[1]
                tmp.amount = result[2]
                tmp.type = "item"
            end
            -- If item already exists, then add new amount to existing amount
            if res[tmp.name] then
                res[tmp.name].amount = res[tmp.name].amount + tmp.amount
            else
                res[tmp.name] = tmp
            end
        end
    end
    return res
end
local function format_result(recipe)
    local res = {}
    --Separate normal/exp recipe versions
    if recipe.normal then
        res.normal = parse_result(recipe.normal)
    else 
        res.normal = parse_result(recipe)
    end
    if recipe.expensive then
        res.expensive = parse_result(recipe.expensive)
    else 
        -- expensive version doesn't exist, just make it a copy of the normal version
        res.expensive = table.deepcopy(res.normal)
    end
    
    return res
end

--[[
    Format the various ingredient structures to: 
    { 
        normal={
            energy_required=X,
            ingredients={
                res1 = {name=res1, amount=amnt1} ... resN = {name=resN, amount=amntN}
            }
        },
        expensive={
            energy_required=Y,
            ingredients={
                res1 = {name=res1, amount=amnt1} ... resN = {name=resN, amount=amntN}
            }
        }
    }                                          
]]

local function parse_ingredients(recipe_core)
    local ing = {}
    ing.energy_required = recipe_core.energy_required or 0.5
    if recipe_core.ingredients then
        ing.ingredients = {}
        for i,ingredient in pairs(recipe_core.ingredients) do
            table.insert(ing.ingredients, i, {})
            -- Using named keys, {name=foo, amount=1} is enforced
            if ingredient.name then
                ing.ingredients[i].name = ingredient.name
                ing.ingredients[i].amount = ingredient.amount
            -- Using numbered keys, {name, amount} is enforced
            else 
                ing.ingredients[i].name = ingredient[1]
                ing.ingredients[i].amount = ingredient[2]
            end
        end
    end
    return ing
end
local function format_ingredients(recipe)
    local ing = {}
    if recipe.normal then
        ing.normal = parse_ingredients(recipe.normal)
    else 
        ing.normal = parse_ingredients(recipe)
    end
    if recipe.expensive then
        ing.expensive = parse_ingredients(recipe.expensive)
    else
        ing.expensive = table.deepcopy(ing.normal)
    end
    
    return ing
end

-- Create map of items to their recipes
RECIPE_UTIL.item = {}
local recipe_dump = data.raw["recipe"]
for _,rec in pairs(recipe_dump) do
    -- Blacklist SE tech card recipes (cause infinite loops)
    if rec.name:match('^se-.+-data$') then goto continue end
    -- Get products of recipe
    local products = format_result(rec)
    -- Only care about names here, not amounts, so ignoring expensive mode should be fine?
    for _,item in pairs(products.normal) do
        -- Add recipe to product_of for item
        if not RECIPE_UTIL.item[item.name] then
            local item_type = "item"
            if item.type then item_type = item.type end
            RECIPE_UTIL.item[item.name] = {
                product_of={rec.name},
                type = item_type
            }
        else 
            table.insert(RECIPE_UTIL.item[item.name].product_of, rec.name)
        end
    end
    ::continue::
end
-- Add new item to list, or add amount to existing item
-- Clamp amounts to max 65535, as game engine will throw error if using more
function merge_or_append(list, ingredient, CONST)
    if list[ingredient.name] then
        list[ingredient.name].amount = list[ingredient.name].amount + ingredient.amount
        if ingredient.name ~= "energy_required" and list[ingredient.name].amount > 65535 then
            if CONST.DEBUG then log("Ingredient "..ingredient.name.." exceeded limit with amount of "..list[ingredient.name].amount) end
            list[ingredient.name].amount = 65535 
        end
    else
        list[ingredient.name] = ingredient
        if ingredient.name ~= "energy_required" and list[ingredient.name].amount > 65535 then
            if CONST.DEBUG then log("Ingredient "..ingredient.name.." exceeded limit with amount of "..list[ingredient.name].amount) end
            list[ingredient.name].amount = 65535 
        end
    end
    --return list
end
-- Main function, recurses through the ingredients of a given recipe, adding base ingredients to a list that *should* make it back up to the top of the stack
-- result_name_desired is used for recipes that give more than one output
function RECIPE_UTIL.get_ingredient_list(recipe, list, recipe_mode, result_name_desired, result_amount_desired, CONST)
    -- Get recipe ingredients and results
    local ingredients = format_ingredients(recipe)
    local results = format_result(recipe)
    -- How many crafts will we need to satisfy desired result amount? (amount_desired)/(amount_produced)
    -- Use math.floor() because ASIFS should be more efficient than a regular factory, not less
    local craft_multiplier = math.floor(result_amount_desired/(results[recipe_mode][result_name_desired].amount))
    if craft_multiplier == 0 then craft_multiplier = 1 end
    -- Add energy needed to running total
    merge_or_append(list, {name="energy_required", amount=craft_multiplier*ingredients[recipe_mode].energy_required}, CONST)
    for i,ingredient in pairs(ingredients[recipe_mode].ingredients) do
        -- Set type (defaults to item, which is bad when using fluids)
        ingredient.type = RECIPE_UTIL.item[ingredient.name].type
        -- Scale ingredient by number of crafts we're doing
        ingredient.amount = craft_multiplier*ingredient.amount
        -- If ingredient is a base item, add it to the list.
        if CONST.BASE_ITEMS[ingredient.name] then
            merge_or_append(list, ingredient)
        else
            -- Get a (random?) recipe/its variant override for the ingredient
            local next_recipe_name = CONST.RECIPE_VARIANT_OVERRIDE[ingredient.name] or RECIPE_UTIL.item[ingredient.name].product_of[1] or nil
            if next_recipe_name then
                next_recipe = data.raw["recipe"][next_recipe_name]
                -- Pass list down
                RECIPE_UTIL.get_ingredient_list(next_recipe, list, recipe_mode, ingredient.name, ingredient.amount, CONST)
            end
        end
    end
end
function RECIPE_UTIL.scale_ingredients(ingredients, scale_factor, productivity_factor)
    for _,ingredient in pairs(ingredients) do
        ingredient.amount = ingredient.amount * (1 - productivity_factor) * scale_factor
    end
end
function RECIPE_UTIL.create_assembler_entity_recipe(name, number_assembler_blocks)
    local recipe = {
        type = "recipe",
        name = name,
        category = "advanced-crafting",
        enabled = false,
        normal = {
            ingredients = {
                {name = "asif-assembler-block", amount = number_assembler_blocks["normal"]}
            },
            result = name,
            energy_required = number_assembler_blocks["normal"]*10
        },
        expensive = {
            ingredients = {
                {name = "asif-assembler-block", amount = number_assembler_blocks["expensive"]}
            },
            result = name,
            energy_required = number_assembler_blocks["expensive"]*10
        }
    }
    return recipe
end
function RECIPE_UTIL.create_asif_working_recipe(recipe_prefix, result_item, result_amount, ingredient_list)
    local stripped_ingredients = {
        normal = {},
        expensive = {}
    }
    -- Strip keys from ingredient_list
    for _,recipe_mode in pairs({"normal", "expensive"}) do
        for _,ingredient in pairs(ingredient_list[recipe_mode]) do
            table.insert(stripped_ingredients[recipe_mode], ingredient)
        end
    end
    local recipe = {
        type = "recipe",
        category = "asif-crafting",
        name = recipe_prefix.."-recipe",
        enabled = false,
        normal = {
            ingredients = ingredient_list["normal"],
            results = {{name = result_item, amount = result_amount}}
        },
        expensive = {
            ingredients = ingredient_list["expensive"],
            results = {{name = result_item, amount = result_amount}}
        }
    }
    return recipe
end
return RECIPE_UTIL