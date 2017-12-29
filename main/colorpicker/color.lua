
local M = {}


local util = require "main.framework.utilities"


function M.rgba_to_hsva(rgb)
	local hsv = vmath.vector4(rgb)
	local mx = math.max(rgb.x, rgb.y, rgb.z)
	local mn = math.min(rgb.x, rgb.y, rgb.z)
	local diff = mx - mn
	-- Hue
	if mx == mn then
		hsv.x = 0
	elseif mx == rgb.x then
		hsv.x = (60 * ((rgb.y-rgb.z)/diff) + 360) % 360
	elseif mx == rgb.y then
		hsv.x = (60 * ((rgb.z-rgb.x)/diff) + 360) % 360
	elseif mx == rgb.z then
		hsv.x = (60 * ((rgb.x-rgb.y)/diff) + 360) % 360
	end
	-- Saturation
	if mx == 0 then
		hsv.y = 0
	else
		hsv.y = diff/mx
	end
	-- Value
	hsv.z = mx
	return hsv
end

function M.hsva_to_rgba(hsv)
	local rgb

	local i = math.floor(hsv.x * 6);
	local f = hsv.x * 6 - i;
	local p = hsv.z * (1 - hsv.y);
	local q = hsv.z * (1 - f * hsv.y);
	local t = hsv.z * (1 - (1 - f) * hsv.y);

	i = i % 6

	if i == 0 then rgb = vmath.vector4(hsv.z, t, p, hsv.w)
	elseif i == 1 then rgb = vmath.vector4(q, hsv.z, p, hsv.w)
	elseif i == 2 then rgb = vmath.vector4(p, hsv.z, t, hsv.w)
	elseif i == 3 then rgb = vmath.vector4(p, q, hsv.z, hsv.w)
	elseif i == 4 then rgb = vmath.vector4(t, p, hsv.z, hsv.w)
	elseif i == 5 then rgb = vmath.vector4(hsv.z, p, q, hsv.w)
	end

	return rgb
end


return M
