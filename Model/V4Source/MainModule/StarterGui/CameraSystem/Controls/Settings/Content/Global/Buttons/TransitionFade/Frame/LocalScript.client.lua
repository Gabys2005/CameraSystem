local replicated = game.ReplicatedStorage.CameraSystem

for i,v in pairs(script.Parent:GetChildren()) do
	if v:IsA("TextButton") then
		v.MouseButton1Click:Connect(function()
			replicated.Events.SetTransitionFade:FireServer(v.Name)
		end)
	end
end

local function updateButtons()
	local mode = replicated.Shared.TransitionMode.Value
	script.Parent.None.BackgroundColor3 = Color3.fromRGB(0,0,0)
	script.Parent.Black.BackgroundColor3 = Color3.fromRGB(0,0,0)
	script.Parent.White.BackgroundColor3 = Color3.fromRGB(0,0,0)
	script.Parent.Bars.BackgroundColor3 = Color3.fromRGB(0,0,0)
	script.Parent.Blur.BackgroundColor3 = Color3.fromRGB(0,0,0)
	script.Parent[mode].BackgroundColor3 = Color3.fromRGB(35, 167, 28)
end

replicated.Shared.TransitionMode.Changed:Connect(updateButtons)