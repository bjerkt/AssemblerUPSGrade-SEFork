local SCALE_UTIL = {}
function round(num)
	return num + (2^52 + 2^51) - (2^52 + 2^51)
end
function scale_animation(anim, scale_factor, shift_offset_factor)
	-- Scaled sprites still don't expand to the edges like we want, need additional tweaking
	local SCALE_TWEAK = 1.18
	-- Lua's pass by value/ref is confusing, so just make a whole new table to modify and return that
	local animation = table.deepcopy(anim)
	-- Scale standard resolution animation
	if animation.scale then
		animation.scale = animation.scale * scale_factor * SCALE_TWEAK
	else
		animation.scale = scale_factor * SCALE_TWEAK
	end
	-- Don't need an else here, shift defaults to {0,0} and we're multiplying
	if animation.shift then
		animation.shift[1] = animation.shift[1] * scale_factor * SCALE_TWEAK * shift_offset_factor
		animation.shift[2] = animation.shift[2] * scale_factor * SCALE_TWEAK * shift_offset_factor
	end
	--animation.animation_speed = 1
	-- High resolution animation exists, scale it
	if animation.hr_version then
		animation.hr_version.scale = animation.hr_version.scale * scale_factor * SCALE_TWEAK
		animation.hr_version.shift[1] = animation.hr_version.shift[1] * scale_factor * SCALE_TWEAK * shift_offset_factor
		animation.hr_version.shift[2] = animation.hr_version.shift[2] * scale_factor * SCALE_TWEAK * shift_offset_factor
		--animation.hr_version.animation_speed = 1
	end
	return animation
end

function SCALE_UTIL.scale_graphics(entity, scale_factor)
	-- This might not be needed any more
	local OFFSET_SCALING_FACTOR = 1
	-- Animation is table of layers
	-- Use indexes, generic for loop doesn't seem to work
	if entity.animation and entity.animation.layers then
		for i,_ in pairs(entity.animation.layers) do
			entity.animation.layers[i] = scale_animation(entity.animation.layers[i], scale_factor, OFFSET_SCALING_FACTOR)
		end
	-- Animation is single entry
	elseif entity.animation then
		entity.animation = scale_animation(entity.animation, scale_factor, OFFSET_SCALING_FACTOR)
	end
	-- horizontal_animation
	if entity.horizontal_animation and entity.horizontal_animation.layers then
		for i,_ in pairs(entity.horizontal_animation.layers) do
			entity.horizontal_animation.layers[i] = scale_animation(entity.horizontal_animation.layers[i], scale_factor, OFFSET_SCALING_FACTOR)
		end
	end
	-- vertical_animation
	if entity.vertical_animation and entity.vertical_animation.layers then
		for i,_ in pairs(entity.vertical_animation.layers) do
			entity.vertical_animation.layers[i] = scale_animation(entity.vertical_animation.layers[i], scale_factor, OFFSET_SCALING_FACTOR)
		end
	end
	-- working_visualisations is always a table
	if entity.working_visualisations then
		for i,_ in pairs(entity.working_visualisations) do
			-- Animation is table of layers
			if entity.working_visualisations[i].animation and entity.working_visualisations[i].animation.layers then
				for j,_ in pairs(entity.working_visualisations[i].animation.layers) do
					entity.working_visualisations[i].animation.layers[j] = scale_animation(entity.working_visualisations[i].animation.layers[j], scale_factor, OFFSET_SCALING_FACTOR)
				end
			-- Animation is single entry
			elseif entity.working_visualisations[i].animation then
				entity.working_visualisations[i].animation = scale_animation(entity.working_visualisations[i].animation, scale_factor, OFFSET_SCALING_FACTOR)
			end
		end
	end
end
return SCALE_UTIL