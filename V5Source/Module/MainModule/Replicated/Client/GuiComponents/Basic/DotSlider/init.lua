local theme = require(script.Parent.Parent.Parent.Themes.Current)
local util = require(script.Parent.Parent.Parent.Scripts.Utils)
local data = require(script.Parent.Parent.Parent.Scripts.UpdateData)
local uis = game:GetService("UserInputService")
local ts = game:GetService("TweenService")

export type DotSliderParams = {
	Name: string,
	Min: number,
	Max: number,
	Round: number,
	Default: number,
	Setting: string,
	EventToFire: RemoteEvent?,
	Suffix: string?,
}

script.Frame.Reset.BackgroundColor3 = theme.Base
script.Frame.Reset.TextColor3 = theme.BaseText
script.Frame.Namer.TextColor3 = theme.BaseText
script.Frame.Value.TextColor3 = theme.BaseText
script.Frame.Slider.Frame.BackgroundColor3 = theme.BaseDarker
script.Frame.Slider.Frame.Frame.BackgroundColor3 = theme.Base
script.Frame.Slider.Frame.Frame.Frame.BackgroundColor3 = theme.Base

return function(params: DotSliderParams)
	local copy = script.Frame:Clone()
	params.Round = params.Round or 0
	params.Suffix = params.Suffix or ""

	copy.Namer.Text = params.Name

	copy.Slider.Hitbox.InputBegan:Connect(function(Input: InputObject)
		if Input.UserInputType ~= Enum.UserInputType.MouseButton1 then
			return
		end
		local dragging = true
		local stopDrag
		stopDrag = Input:GetPropertyChangedSignal("UserInputState"):Connect(function()
			if Input.UserInputState == Enum.UserInputState.End then
				dragging = false
				stopDrag:Disconnect()
			end
		end)

		while dragging do
			local relativePositionX = uis:GetMouseLocation().X - copy.Slider.Frame.AbsolutePosition.X
			local scaleX = math.clamp(relativePositionX / copy.Slider.Frame.AbsoluteSize.X, 0, 1)
			local value = scaleX * (params.Max - params.Min) + params.Min
			if params.EventToFire then
				params.EventToFire:FireServer(value)
			else
				data:set(params.Setting, value)
			end
			task.wait()
		end

		Input:Destroy()
	end)

	local function update(newval)
		local newval = newval or data:get(params.Setting)
		if typeof(newval) == "table" and newval.Value then
			newval = newval.Value
		end
		local val = util:Map(newval, params.Min, params.Max, 0, 1)
		ts:Create(copy.Slider.Frame.Frame, TweenInfo.new(0.05), { Size = UDim2.fromScale(val, 1) }):Play()
		copy.Value.Text = util:Round(newval, params.Round) .. params.Suffix
	end
	data:onChange(params.Setting, update)
	update()

	copy.Reset.MouseButton1Click:Connect(function()
		if params.EventToFire then
			params.EventToFire:FireServer(params.Default)
		else
			data:set(params.Setting, params.Default)
		end
	end)

	return copy
end
