--// Services
local ts = game:GetService("TweenService")
local lighting = game:GetService("Lighting")
local players = game:GetService("Players")

--// Variables
local dataEvent = require(script.Parent.Parent.Scripts.UpdateData)
local playerGui = players.LocalPlayer.PlayerGui
local mainGui = playerGui.CameraSystemMain

--// Functions
local function updateBlackoutTransparency()
	local blackoutEnabled = dataEvent:get("Shared.Effects.Blackout")
	local transparentOverlays = dataEvent:get("Local.Settings.TransparentOverlays")
	local transparency = 1
	if blackoutEnabled then
		if transparentOverlays then
			transparency = 0.5
		else
			transparency = 0
		end
	end
	ts:Create(mainGui.Blackout, TweenInfo.new(0.5), { BackgroundTransparency = transparency }):Play()
end

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

dataEvent:onChange("Shared.Effects.Blackout", updateBlackoutTransparency)
dataEvent:onChange("Local.Settings.TransparentOverlays", updateBlackoutTransparency)

dataEvent:onChange("Shared.Effects.BarsEnabled", function(enabled)
	if enabled then
		ts:Create(mainGui.Bars.Top, TweenInfo.new(0.5), { AnchorPoint = Vector2.new(0, 0) }):Play()
		ts:Create(mainGui.Bars.Bottom, TweenInfo.new(0.5), { AnchorPoint = Vector2.new(0, 1) }):Play()
	else
		ts:Create(mainGui.Bars.Top, TweenInfo.new(0.5), { AnchorPoint = Vector2.new(0, 1) }):Play()
		ts:Create(mainGui.Bars.Bottom, TweenInfo.new(0.5), { AnchorPoint = Vector2.new(0, 0) }):Play()
	end
end)

dataEvent:onChange("Local.Settings.TransparentOverlays", function(enabled)
	if enabled then
		ts:Create(mainGui.Bars.Top, TweenInfo.new(0.5), { BackgroundTransparency = 0.5 }):Play()
		ts:Create(mainGui.Bars.Bottom, TweenInfo.new(0.5), { BackgroundTransparency = 0.5 }):Play()
	else
		ts:Create(mainGui.Bars.Top, TweenInfo.new(0.5), { BackgroundTransparency = 0 }):Play()
		ts:Create(mainGui.Bars.Bottom, TweenInfo.new(0.5), { BackgroundTransparency = 0 }):Play()
	end
end)

return nil
