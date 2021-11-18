--// Services
local ts = game:GetService("TweenService")
local lighting = game:GetService("Lighting")
local players = game:GetService("Players")

--// Variables
local dataEvent = require(script.Parent.Parent.Scripts.UpdateData)
local playerGui = players.LocalPlayer.PlayerGui
local mainGui = playerGui.CameraSystemMain

--// Functions

--// Connections
dataEvent:onChange("Shared.Effects.Blur", function(newblur)
	ts:Create(lighting.CameraSystemBlur, TweenInfo.new(newblur.Time), { Size = newblur.Value }):Play()
end)

dataEvent:onChange("Shared.Effects.Saturation", function(newsaturation)
	ts
		:Create(
			lighting.CameraSystemColorCorrection,
			TweenInfo.new(newsaturation.Time),
			{ Saturation = newsaturation.Value }
		)
		:Play()
end)

dataEvent:onChange("Shared.Effects.Blackout", function(enabled)
	if enabled then
		ts:Create(mainGui.Blackout, TweenInfo.new(0.5), { BackgroundTransparency = 0 }):Play()
	else
		ts:Create(mainGui.Blackout, TweenInfo.new(0.5), { BackgroundTransparency = 1 }):Play()
	end
end)

dataEvent:onChange("Shared.Effects.BarsEnabled", function(enabled)
	if enabled then
		ts:Create(mainGui.Bars.Top, TweenInfo.new(0.5), { AnchorPoint = Vector2.new(0, 0) }):Play()
		ts:Create(mainGui.Bars.Bottom, TweenInfo.new(0.5), { AnchorPoint = Vector2.new(0, 1) }):Play()
	else
		ts:Create(mainGui.Bars.Top, TweenInfo.new(0.5), { AnchorPoint = Vector2.new(0, 1) }):Play()
		ts:Create(mainGui.Bars.Bottom, TweenInfo.new(0.5), { AnchorPoint = Vector2.new(0, 0) }):Play()
	end
end)

return nil
