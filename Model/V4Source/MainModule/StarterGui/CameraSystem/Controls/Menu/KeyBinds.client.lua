local Settings = require(workspace.CameraSystem.Settings)
local keybinds = Settings.KeyBinds
local uis = game:GetService("UserInputService")
local replicated = game.ReplicatedStorage.CameraSystem
local enabled = script.Parent.Parent.KeybindsEnabled

local checkKeys = {}

for i,v in pairs(keybinds) do
	for a,b in pairs(v.Keys) do
		checkKeys[b] = true
	end
end

uis.InputBegan:Connect(function(input,processed)
	if not processed and enabled.Value then
		local keycode = input.KeyCode
		if checkKeys[keycode] then
			for i,v in pairs(keybinds) do
				if #v.Keys == 1 then
					if keycode == v.Keys[1] then
						replicated.Events.RunKeybind:FireServer(v.Run)
					end
				else
					local canRun = true
					for a,b in pairs(v.Keys) do
						if not uis:IsKeyDown(b) then
							canRun = false
							break
						end
					end
					if canRun then
						replicated.Events.RunKeybind:FireServer(v.Run)
					end
				end
			end
		end
	end
end)