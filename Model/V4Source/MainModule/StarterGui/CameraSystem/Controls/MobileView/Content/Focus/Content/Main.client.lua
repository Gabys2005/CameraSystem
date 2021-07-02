local replicated = game.ReplicatedStorage.CameraSystem

local function onPlrAdded(plr)
	local template = script.Template:Clone()
	template.Text = plr.DisplayName
	template.Name = plr.UserId
	template.Parent = script.Parent	
	template.MouseButton1Click:Connect(function()
		replicated.Events.FocusOn:FireServer(plr.Name)
	end)
end

local function onPlrRemoving(plr)
	if script.Parent:FindFirstChild(plr.UserId) then
		script.Parent:FindFirstChild(plr.UserId):Destroy()
	end
end

local function onValChange(val)
	script.Parent.Parent.None.BackgroundColor3 = Color3.fromRGB(0,0,0)
	for i,v in pairs(script.Parent:GetChildren()) do
		if v:IsA("TextButton") then
			v.BackgroundColor3 = Color3.fromRGB(0,0,0)
		end
	end
	if not val then
		script.Parent.Parent.None.BackgroundColor3 = Color3.fromRGB(12, 120, 0)
	else
		script.Parent[game.Players:GetPlayerFromCharacter(val).UserId].BackgroundColor3 = Color3.fromRGB(12,120,0)
	end
end

for i,v in pairs(game.Players:GetPlayers()) do
	onPlrAdded(v)
end
game.Players.PlayerAdded:Connect(onPlrAdded)
game.Players.PlayerRemoving:Connect(onPlrRemoving)
replicated.Shared.FocusedOn.Changed:Connect(onValChange)
onValChange(replicated.Shared.FocusedOn.Value)

script.Parent.Parent.None.MouseButton1Click:Connect(function()
	replicated.Events.FocusOn:FireServer(nil)
end)