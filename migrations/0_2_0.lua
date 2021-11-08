for index, force in pairs(game.forces) do
    local technologies = force.technologies
    local recipes = force.recipes
    --[[
    recipes["rail-chain-signal"].enabled = technologies["rail-signals"].researched
  
    if technologies["tank"].researched then
      recipes["explosive-cannon-shell"].enabled = true
    end
    ]]
  end