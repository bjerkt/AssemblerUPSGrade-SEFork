local REC_UTIL = {}
REC_UTIL.item = {}
-- Format the various result structures to: {{name=res1, amount=amnt1}...{name=resN, amount=amntN}}
--                                      or: { normal={{name=res1, amount=amnt1}...{name=resN, amount=amntN}},
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
    end
    return res
end
local recipe_dump = data.raw["recipe"]
for i,rec in pairs(recipe_dump) do
    -- Get products of recipe
    local res = format_result(rec, rec.name)
    -- Only care about names here, not amounts, so ignoring expensive mode should be fine?
    if res.normal then res = res.normal end
    for j,item in pairs(res) do
        -- Add recipe to product_of for item
        if not REC_UTIL.item[item.name] then
            REC_UTIL.item[item.name] = {product_of={rec.name}}
        else 
            table.insert(REC_UTIL.item[item.name].product_of, rec.name)
        end
    end
end
log("ItemToRecipeMap:")
log(serpent.block(REC_UTIL.item))
function REC_UTIL.recurse_ingredient_chain(recipe)
end
return REC_UTIL