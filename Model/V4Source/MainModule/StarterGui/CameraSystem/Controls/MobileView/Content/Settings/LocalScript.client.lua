local replicated = game:GetService("ReplicatedStorage").CameraSystem

for i,v in pairs(script.Parent.TransitionType:GetChildren()) do
	if v:IsA("TextButton") then
		v.MouseButton1Click:Connect(function()
			replicated.Events.SetTransitionFade:FireServer(v.Name)
		end)
	end
end

local function updateButtons()
	local mode = replicated.Shared.TransitionMode.Value
	for i,v in pairs(script.Parent.TransitionType:GetChildren()) do
		if v:IsA("TextButton") then
			v.BackgroundColor3 = Color3.fromRGB(0,0,0)
		end
	end
	script.Parent.TransitionType[mode].BackgroundColor3 = Color3.fromRGB(35, 167, 28)
end

replicated.Shared.TransitionMode.Changed:Connect(updateButtons)

script.Parent.TransparentBlackout.MouseButton1Click:Connect(function()
	if script.Parent.Parent.Parent.Parent.Parent.BlackoutTransparency.Value == 0 then
		script.Parent.Parent.Parent.Parent.Parent.BlackoutTransparency.Value = 0.5
		script.Parent.TransparentBlackout.BackgroundColor3 = Color3.fromRGB(35, 167, 28)
	else
		script.Parent.Parent.Parent.Parent.Parent.BlackoutTransparency.Value = 0
		script.Parent.TransparentBlackout.BackgroundColor3 = Color3.fromRGB(0,0,0)
	end
end)