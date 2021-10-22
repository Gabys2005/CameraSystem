local theme = require(script.Parent.Parent.Themes.Current)
local ts = game:GetService("TweenService")
local data = require(script.Parent.Parent.Scripts.UpdateData)

script.Frame.TextLabel.TextColor3 = theme.BaseText
script.Frame.Frame.BackgroundColor3 = theme.BaseDarker
script.Frame.Frame.Frame.BackgroundColor3 = theme.BaseDarker2
script.Frame.Frame.TextColor3 = theme.BaseText

export type CheckboxParams = {
	Name: string,
	Checked: boolean?,
	Setting: string,
	EventToFire: RemoteEvent?,
}

return function(params: CheckboxParams)
	local copy = script.Frame:Clone()
	copy.TextLabel.Text = params.Name
	local function updateColors()
		local position = UDim2.fromScale(0.95, 0.5)
		local anchorpoint = Vector2.new(1, 0.5)
		local ffbackground = theme.Underline
		local fbackground = theme.Base
		if not data:get(params.Setting) then
			position = UDim2.fromScale(0.05, 0.5)
			anchorpoint = Vector2.new(0, 0.5)
			ffbackground = theme.BaseDarker2
			fbackground = theme.BaseDarker
		end
		ts
			:Create(
				copy.Frame.Frame,
				TweenInfo.new(0.2),
				{ Position = position, AnchorPoint = anchorpoint, BackgroundColor3 = ffbackground }
			)
			:Play()
		ts:Create(copy.Frame, TweenInfo.new(0.2), { BackgroundColor3 = fbackground }):Play()
	end
	updateColors()
	copy.Frame.MouseButton1Click:Connect(function()
		local newval = not data:get(params.Setting)
		if params.EventToFire then
			params.EventToFire:FireServer(newval)
		else
			data:set(params.Setting, not data:get(params.Setting))
		end
	end)
	data:onChange(params.Setting, function(newval)
		updateColors()
	end)
	return copy
end
