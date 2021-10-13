local utils = {}
local smoothGrid = require(script.Parent.SmoothGrid)

function utils:NewInstance(insName, params)
	local ins = Instance.new(insName)
	for i,v in pairs(params) do
		ins[i] = v
	end
	return ins
end

function utils:Round(num, places)
	places = math.pow(10, places or 0)
	num = num * places
	if num >= 0 then 
		num = math.floor(num + 0.5) 
	else 
		num = math.ceil(num - 0.5) 
	end
	return num / places
end

function utils:Map(n, oldMin, oldMax, min, max)
	return (min + ((max - min) * ((n - oldMin) / (oldMax - oldMin))))
end

return utils