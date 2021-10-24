--// Services
local ts = game:GetService("TweenService")
local lighting = game:GetService("Lighting")

--// Variables
local dataEvent = require(script.Parent.Parent.Scripts.UpdateData)
local data = require(script.Parent.Parent.Parent.Data)
local camera = workspace.CurrentCamera

--// Functions

--// Connections
dataEvent:onChange("Shared.Effects.Blur", function(newblur)
	ts:Create(lighting.CameraSystemBlur, TweenInfo.new(newblur.Time), { Size = newblur.Value }):Play()
end)

return nil
