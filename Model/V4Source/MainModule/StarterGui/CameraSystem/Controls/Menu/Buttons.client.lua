script.Parent.Cameras.MouseButton1Click:Connect(function()
	script.Parent.Parent.Cameras.Visible = not script.Parent.Parent.Cameras.Visible
end)

script.Parent.Effects.MouseButton1Click:Connect(function()
	script.Parent.Parent.Effects.Visible = not script.Parent.Parent.Effects.Visible
end)

script.Parent.Settings.MouseButton1Click:Connect(function()
	script.Parent.Parent.Settings.Visible = not script.Parent.Parent.Settings.Visible
end)

script.Parent.Macros.MouseButton1Click:Connect(function()
	script.Parent.Parent.Macros.Visible = not script.Parent.Parent.Macros.Visible
end)

script.Parent.Info.MouseButton1Click:Connect(function()
	script.Parent.Parent.Info.Visible = not script.Parent.Parent.Info.Visible
end)

local function updateCameras()
	local color = Color3.fromRGB(0,0,0)
	if script.Parent.Parent.Cameras.Visible == true then
		color = Color3.fromRGB(35,167,28)
	end
	script.Parent.Cameras.BackgroundColor3 = color
end

script.Parent.Parent.Cameras:GetPropertyChangedSignal("Visible"):Connect(updateCameras)

local function updateEffects()
	local color = Color3.fromRGB(0,0,0)
	if script.Parent.Parent.Effects.Visible == true then
		color = Color3.fromRGB(35,167,28)
	end
	script.Parent.Effects.BackgroundColor3 = color
end

script.Parent.Parent.Effects:GetPropertyChangedSignal("Visible"):Connect(updateEffects)

local function updateSettings()
	local color = Color3.fromRGB(0,0,0)
	if script.Parent.Parent.Settings.Visible == true then
		color = Color3.fromRGB(35,167,28)
	end
	script.Parent.Settings.BackgroundColor3 = color
end

script.Parent.Parent.Settings:GetPropertyChangedSignal("Visible"):Connect(updateSettings)

local function updateMacros()
	local color = Color3.fromRGB(0,0,0)
	if script.Parent.Parent.Macros.Visible == true then
		color = Color3.fromRGB(35,167,28)
	end
	script.Parent.Macros.BackgroundColor3 = color
end

script.Parent.Parent.Macros:GetPropertyChangedSignal("Visible"):Connect(updateMacros)

local function updateInfo()
	local color = Color3.fromRGB(0,0,0)
	if script.Parent.Parent.Info.Visible == true then
		color = Color3.fromRGB(35,167,28)
	end
	script.Parent.Info.BackgroundColor3 = color
end

script.Parent.Parent.Info:GetPropertyChangedSignal("Visible"):Connect(updateInfo)