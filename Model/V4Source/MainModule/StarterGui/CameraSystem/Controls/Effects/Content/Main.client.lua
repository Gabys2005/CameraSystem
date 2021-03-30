local cameras = workspace.CameraSystem.Cameras
local replicated = game.ReplicatedStorage.CameraSystem

--// Buttons

script.Parent.Buttons.Blackout.MouseButton1Click:Connect(function()
	if (replicated.Shared.BlackoutEnabled.Value == true and replicated.Shared.BlackoutColor.Value ~= Color3.fromRGB(0,0,0)) or replicated.Shared.BlackoutEnabled.Value == false then
		replicated.Events.ChangeBlackout:FireServer(true,Color3.fromRGB(0,0,0))
	else
		replicated.Events.ChangeBlackout:FireServer(false)
	end	
end)

script.Parent.Buttons.Whiteout.MouseButton1Click:Connect(function()
	if (replicated.Shared.BlackoutEnabled.Value == true and replicated.Shared.BlackoutColor.Value ~= Color3.fromRGB(255,255,255)) or replicated.Shared.BlackoutEnabled.Value == false then
		replicated.Events.ChangeBlackout:FireServer(true,Color3.fromRGB(255,255,255))
	else
		replicated.Events.ChangeBlackout:FireServer(false)
	end	
end)

script.Parent.Buttons.Rainbow.MouseButton1Click:Connect(function()
	replicated.Events.ToggleRainbow:FireServer()
end)

script.Parent.Buttons.Bars.MouseButton1Click:Connect(function()
	replicated.Events.ToggleBars:FireServer()
end)

replicated.Server.ShowBars.Changed:Connect(function(val)
	if val == true then
		script.Parent.Buttons.Bars.BackgroundColor3 = Color3.fromRGB(35,167,28)
	else
		script.Parent.Buttons.Bars.BackgroundColor3 = Color3.fromRGB(0,0,0)
	end
end)

replicated.Server.RainbowEnabled.Changed:Connect(function(val)
	if val == true then
		script.Parent.Buttons.Rainbow.BackgroundColor3 = Color3.fromRGB(35,167,28)
	else
		script.Parent.Buttons.Rainbow.BackgroundColor3 = Color3.fromRGB(0,0,0)
	end
end)

local function updateBlackoutButtons()
	local enabled = replicated.Shared.BlackoutEnabled.Value
	local color = replicated.Shared.BlackoutColor.Value
	if not enabled then
		script.Parent.Buttons.Blackout.BackgroundColor3 = Color3.fromRGB(0,0,0)
		script.Parent.Buttons.Whiteout.BackgroundColor3 = Color3.fromRGB(0,0,0)
	else
		if color == Color3.fromRGB(0,0,0) then
			script.Parent.Buttons.Blackout.BackgroundColor3 = Color3.fromRGB(35, 167, 28)
			script.Parent.Buttons.Whiteout.BackgroundColor3 = Color3.fromRGB(0,0,0)
		elseif color == Color3.fromRGB(255,255,255) then
			script.Parent.Buttons.Blackout.BackgroundColor3 = Color3.fromRGB(0,0,0)
			script.Parent.Buttons.Whiteout.BackgroundColor3 = Color3.fromRGB(35, 167, 28)
		else
			script.Parent.Buttons.Blackout.BackgroundColor3 = Color3.fromRGB(0,0,0)
			script.Parent.Buttons.Whiteout.BackgroundColor3 = Color3.fromRGB(0,0,0)
		end
	end
end

replicated.Shared.BlackoutColor.Changed:Connect(updateBlackoutButtons)
replicated.Shared.BlackoutEnabled.Changed:Connect(updateBlackoutButtons)