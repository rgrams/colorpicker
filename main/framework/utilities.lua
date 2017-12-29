-- Version 1.5

local M = {}


local PI = math.pi
local TWO_PI = PI * 2
local YVECT = vmath.vector3(0, 1, 0)
local NEG_YVECT = vmath.vector3(0, -1, 0)
local XVECT = vmath.vector3(1, 0, 0)
local NEG_XVECT = vmath.vector3(-1, 0, 0)
local QUAT180 = vmath.quat_rotation_z(PI)


-- Apply torque to a dynamic collision object component
function M.apply_torque(url, worldpos, t)
	local halft = t / 2
	msg.post(url, "apply_force", { force = NEG_XVECT * halft, position = worldpos + NEG_YVECT })
	msg.post(url, "apply_force", { force = XVECT * halft, position = worldpos + YVECT })
end

-- Get the smallest angle between two angles, in radians
function M.anglediff_rad(rad1, rad2)
	local a = rad1 - rad2
	a = (a + PI) % (TWO_PI) - PI
	return a
end

-- Get the smallest angle between two angles, in degrees
function M.anglediff_deg(deg1, deg2)
	local a = deg1 - deg2
	a = (a + 180) % (180 * 2) - 180
	return a
end

function M.round(x)
	local a = x % 1
	x = x - a
	a = a < 0.5 and 0 or 1
	return x + a
end

function M.clamp(x, min, max)
	if x > max then x = max
	elseif x < min then x = min
	end
	return x
end

-- Clamp length of vector
-- 		max and min are switched because min is optional
function M.clamp_vec(v, max, min)
	min = min or 0
	local l = vmath.length(v)
	local l2 = l > max and max or (l < min and min or l)
	if l2 ~= l then v = vmath.normalize(v) * l2 end -- only need to call vmath.normalize if v will actually be changed
	return v, l2 -- also return length so users doesn't have to call that again if they need it
end

function M.sign(x)
	return x >= 0 and 1 or -1
end

-- Find index of value in table
function M.find(t, val)
	for i, v in ipairs(t) do
		if v == val then return i end
	end
end

-- Find & Remove value from table
function M.find_remove(t, val)
	for i, v in ipairs(t) do
		if v == val then
			table.remove(t, i)
			return i
		end
	end
end

-- Make a shallow copy of a table
function M.shallow_copy(t)
	local t2 = {}
	for k,v in pairs(t) do
		t2[k] = v
	end
	return t2
end

-- Make a deep copy of a table
function M.deep_copy(t)
	local t2 = {}
	for k, v in pairs(t) do
		if type(v) == "table" then
			t2[k] = M.deep_copy(v)
		else
			t2[k] = v
		end
	end
	return t2
end

-- Swap two elements in table
function M.swap_elements(t, i1, i2)
	t[i1], t[i2] = t[i2], t[i1]
end

-- Next index in array (looping)
function M.nexti(t, i)
	if #t == 0 then return 0 end
	i = i + 1
	if i > #t then i = 1 end
	return i
end

-- Previous index in array (looping)
function M.previ(t, i)
	if #t == 0 then return 0 end
	i = i - 1
	if i < 1 then i = #t end
	return i
end

-- Next value in array (looping)
function M.nextval(t, i)
	return t[M.nexti(t, i)]
end

-- Previous value in array (looping)
function M.prevval(t, i)
	return t[M.previ(t, i)]
end

-- Quat needed to rotate the local Y axis to the supplied -unit- vector
function M.vec_to_quat_y(vec)
	return vec.y == -1 and QUAT180 or vmath.quat_from_to(YVECT, vec)
end

-- Quat needed to rotate the local X axis to the supplied -unit- vector
function M.vec_to_quat_x(vec)
	return vec.x == -1 and QUAT180 or vmath.quat_from_to(XVECT, vec)
end

-- Get script URL
function M.scripturl(path)
	return msg.url(nil, path, "script")
end

-- Random float from -1 to 1
function M.rand_1_to_1()
	return((math.random() - 0.5) * 2)
end

-- Random float in range
function M.rand_range(min, max)
	return math.random() * (max - min) + min
end

-- Random unit vector on the XY plane
function M.rand_vec_2d()
	return vmath.rotate(vmath.quat_rotation_z(math.random()*TWO_PI), YVECT)
end


return M
