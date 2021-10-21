local utils = {}
local data = require(script.Parent.Parent.Parent.Data)

function utils:NewInstance(insName: string, params: table)
	local ins = Instance.new(insName)
	for i, v in pairs(params) do
		ins[i] = v
	end
	return ins
end

-- TODO replace with better function
function utils:Round(num: number, places: number)
	places = math.pow(10, places or 0)
	num = num * places
	if num >= 0 then
		num = math.floor(num + 0.5)
	else
		num = math.ceil(num - 0.5)
	end
	return num / places
end

function utils:Map(n: number, oldMin: number, oldMax: number, min: number, max: number)
	return (min + ((max - min) * ((n - oldMin) / (oldMax - oldMin))))
end

function utils:CFrameToRotation(cf: CFrame)
	local x, y, z = cf:ToEulerAnglesYXZ()
	local rotation = Vector3.new(math.deg(x), math.deg(y), math.deg(z))
	return rotation
end

function utils:resetSpringPosition()
	local spring = data.Local.Springs.Focus
	spring.Position = data.Shared.CameraData.Rotation
end

return utils
