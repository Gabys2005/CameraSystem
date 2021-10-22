--// Services
local ts = game:GetService("TweenService")

--// Variables
local dataEvent = require(script.Parent.Parent.Scripts.UpdateData)
local data = require(script.Parent.Parent.Parent.Data)
local camera = workspace.CurrentCamera

--// Functions

--// Connections
dataEvent:onChange("Shared.Effects.Fov", function(newval)
	if data.Local.Watching then
		ts:Create(camera, TweenInfo.new(newval.Time), { FieldOfView = newval.Value }):Play()
	end
end)

return nil
