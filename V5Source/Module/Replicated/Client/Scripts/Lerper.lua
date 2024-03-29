-- This is used as a replacement for TweenService:Create, also works with bezier curves
local lerper = {}
local run = game:GetService("RunService")
local utils = require(script.Parent.Utils)
local data = require(script.Parent.UpdateData)

local lerpFunctions = {
	InSine = function(T)
		return 1 - math.cos(T * 1.5707963267949)
	end,
	OutSine = function(T)
		return math.sin(T * 1.5707963267949)
	end,
	InOutSine = function(T)
		return (1 - math.cos(3.1415926535898 * T)) / 2
	end,
	OutQuad = function(T)
		return T * (2 - T)
	end,
}
export type LerperParams = {
	LerpTime: number,
	Start: CFrame,
	End: CFrame,
	Accelerate: boolean,
	Decelerate: boolean,
}

export type BezierLerperParams = {
	LerpTime: number,
	Accelerate: boolean,
	Decelerate: boolean,
	PositionCurve: table,
	RotationCurve: table,
}

export type DataLerperParams = {
	LerpTime: number,
	Setting: string,
	Goal: any,
}

-- Lerper for normal cameras that just need to move between points
function lerper.new(params: LerperParams)
	local lerp = {
		startTime = tick(),
		endTime = tick() + params.LerpTime,
		value = {
			CFrame = params.Start,
			Position = params.Start.Position,
			Rotation = utils:CFrameToRotation(params.Start),
		},
		ended = false,
	}

	lerp.connection = run.RenderStepped:Connect(function()
		if tick() > lerp.endTime then
			lerp.connection:Disconnect()
			lerp.ended = true
		end
		local timeProgress = utils:Map(tick(), lerp.startTime, lerp.endTime, 0, 1)
		local progress = timeProgress
		if params.Accelerate and params.Decelerate then
			progress = lerpFunctions.InOutSine(timeProgress)
		elseif params.Accelerate then
			progress = lerpFunctions.InSine(timeProgress)
		elseif params.Decelerate then
			progress = lerpFunctions.OutSine(timeProgress)
		end
		local cf = params.Start:Lerp(params.End, progress)
		lerp.value = {
			CFrame = cf,
			Position = cf.Position,
			Rotation = utils:CFrameToRotation(cf),
		}
	end)

	return lerp
end

-- Lerper for cameras that use the Bezier attribute
function lerper.newbezier(params: BezierLerperParams)
	local lerp = {
		startTime = tick(),
		endTime = tick() + params.LerpTime,
		value = {
			Position = params.Start.Position,
			Rotation = utils:CFrameToRotation(params.Start),
		},
		ended = false,
	}

	lerp.connection = run.RenderStepped:Connect(function()
		if tick() > lerp.endTime then
			lerp.connection:Disconnect()
			lerp.ended = true
		end
		local timeProgress = utils:Map(tick(), lerp.startTime, lerp.endTime, 0, 1)
		local progress = timeProgress
		if params.Accelerate and params.Decelerate then
			progress = lerpFunctions.InOutSine(timeProgress)
		elseif params.Accelerate then
			progress = lerpFunctions.InSine(timeProgress)
		elseif params.Decelerate then
			progress = lerpFunctions.OutSine(timeProgress)
		end
		local pos = params.PositionCurve:Get(progress)
		local rot = params.RotationCurve:Get(progress)
		lerp.value.Position = pos
		lerp.value.Rotation = rot
	end)

	return lerp
end

local lastLerpTimes = {}

function lerper.data(params: DataLerperParams)
	local startTime = tick()
	local endTime = tick() + params.LerpTime
	lastLerpTimes[params.Setting] = startTime
	local startValue = data:get(params.Setting)
	local connection
	connection = run.RenderStepped:Connect(function()
		if lastLerpTimes[params.Setting] ~= startTime or tick() > endTime then
			connection:Disconnect()
		else
			local timeProgress = utils:Map(tick(), startTime, endTime, 0, 1)
			local progress = lerpFunctions.OutQuad(timeProgress)
			data:set(params.Setting, utils:Map(progress, 0, 1, startValue, params.Goal))
		end
	end)
end

return lerper
