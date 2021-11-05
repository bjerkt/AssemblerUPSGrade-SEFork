local CONST = require("prototypes.constants")
local RECIPE_UTIL = {}
RECIPE_UTIL.item = {}
-- Format the various result structures to: { normal={{name=res1, amount=amnt1}...{name=resN, amount=amntN}},
--                                            expensive={{name=res1, amount=amnt1}...{name=resN, amount=amntN}}
--                                           }
local function format_result(recipe, name)
    local res = {}
    -- Recurse for normal/exp recipe variants
    if recipe.normal then
        res.normal = format_result(recipe.normal, name)
    end
    if recipe.expensive then
        res.expensive = format_result(recipe.expensive, name)
    end
    if recipe.result then
        table.insert(res, {})
        res[1].name = recipe.result
        res[1].amount = recipe.result_count or 1
        local tmp = {normal=table.deepcopy(res), expensive=table.deepcopy(res)}
        res = tmp
    elseif recipe.results then
        for i,result in pairs(recipe.results) do
            table.insert(res, i, {})
            if result.name then
                -- Using named keys, {name, amount/(amount_min,amount_max)} is enforced
                res[i].name = result.name
                if result.amount then
                    res[i].amount = result.amount
                elseif result.amount_min then
                    res[i].amount = result.amount_min
                end
            else
                -- Using numbered keys, {name, amount} is enforced
                res[i].name = result[1]
                res[i].amount = result[2]
            end
        end
        local tmp = {normal=table.deepcopy(res), expensive=table.deepcopy(res)}
        res = tmp
    end
    return res
end
-- Format the various ingredient structures to: { normal={{name=res1, amount=amnt1}...{name=resN, amount=amntN}},
--                                                expensive={{name=res1, amount=amnt1}...{name=resN, amount=amntN}}                                          
local function format_ingredients(recipe)
    local ing = {}
    if recipe.normal then
        ing.normal = format_ingredients(recipe.normal)
    end
    if recipe.expensive then
        ing.expensive = format_ingredients(recipe.expensive)
    end
    if recipe.ingredients then
        for i,ingredient in pairs(recipe.ingredients) do
            table.insert(ing, i, {})
            -- Using named keys, {name=foo, amount=1} is enforced
            if ingredient.name then
                ing[i].name = ingredient.name
                ing[i].amount = ingredient.amount
            -- Using numbered keys, {name, amount} is enforced
            else 
                ing[i].name = ingredient[1]
                ing[i].amount = ingredient[2]
            end
        end
        local tmp = {normal=table.deepcopy(ing), expensive=table.deepcopy(ing)}
        ing = tmp
    end
    return ing
end
local recipe_dump = data.raw["recipe"]
for i,rec in pairs(recipe_dump) do
    -- Get products of recipe
    local res = format_result(rec, rec.name)
    -- Only care about names here, not amounts, so ignoring expensive mode should be fine?
    if res.normal then res = res.normal end
    for j,item in pairs(res) do
        -- Add recipe to product_of for item
        if not RECIPE_UTIL.item[item.name] then
            RECIPE_UTIL.item[item.name] = {product_of={rec.name}}
        else 
            table.insert(RECIPE_UTIL.item[item.name].product_of, rec.name)
        end
    end
end
log("ItemToRecipeMap:")
log(serpent.block(RECIPE_UTIL.item))
function RECIPE_UTIL.get_ingredient_list(recipe, list, recipe_mode)
    -- get ingredients of recipe
    local ingredients = format_ingredients(recipe)
    for i,ingredient in pairs(ingredients[recipe_mode]) do
        -- If ingredient is a base item, add it to the list.
        -- Else, we need to go deeper
        if CONST.
    end
end
return RECIPE_UTIL