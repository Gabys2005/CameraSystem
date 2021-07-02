local replicated = game:GetService("ReplicatedStorage").CameraSystem
local buttons = {
	Static = {},
	Moving = {},
	Drone = {}
}

local function createCategory(typee, cameras, name)
	local copy = script.CategoryTemplate:Clone()
	copy.CategoryName.Text = name
	copy.Parent = script.Parent.CameraChooser[typee]
	
	for i,v in pairs(cameras) do
		local button = script.CameraButtonTemplate:Clone()
		button.Text = v.Name
		button.Parent = copy.Cameras
		button.Name = v.ID.Value
		button.MouseButton1Click:Connect(function()
			replicated.Events.ChangeCamera:FireServer(typee, v.ID.Value)
		end)
		buttons[typee][v.ID.Value] = button
		--table.insert(buttons[typee],v.ID.Value,button)
	end
end

local cameras = workspace.CameraSystem.Cameras

local uncathegorised = {}
for i,v in pairs(cameras.Static:GetChildren()) do
	if v:IsA("Folder") or v:IsA("Color3Value") then
		createCategory("Static",v:GetChildren(),v.Name)
	else
		table.insert(uncathegorised,v)
	end
end
createCategory("Static",uncathegorised,"Uncathegorised")

local uncathegorised = {}
for i,v in pairs(cameras.Moving:GetChildren()) do
	if v:IsA("Folder") or v:IsA("Color3Value") then
		createCategory("Moving",v:GetChildren(),v.Name)
	else
		table.insert(uncathegorised,v)
	end
end
createCategory("Moving",uncathegorised,"Uncathegorised")

for i,v in pairs(cameras.Drones:GetChildren()) do
	local button = script.CameraButtonTemplate:Clone()
	button.Text = v.Name
	button.Parent = script.Parent.CameraChooser.Drones
	button.MouseButton1Click:Connect(function()
		replicated.Events.ChangeCamera:FireServer("Drone", v.ID.Value)
	end)
	table.insert(buttons.Drone,v.ID.Value,button)
end

local function hideCategories()
	script.Parent.CameraChooser.Static.Visible = false
	script.Parent.CameraChooser.Moving.Visible = false
	script.Parent.CameraChooser.Drones.Visible = false
	script.Parent.CategoryChooser.Static.BackgroundColor3 = Color3.fromRGB(0,0,0)
	script.Parent.CategoryChooser.Moving.BackgroundColor3 = Color3.fromRGB(0,0,0)
	script.Parent.CategoryChooser.Drones.BackgroundColor3 = Color3.fromRGB(0,0,0)
end

script.Parent.CategoryChooser.Static.MouseButton1Click:Connect(function()
	hideCategories()
	script.Parent.CameraChooser.Static.Visible = true
	script.Parent.CategoryChooser.Static.BackgroundColor3 = Color3.fromRGB(35,167,28)
end)
script.Parent.CategoryChooser.Moving.MouseButton1Click:Connect(function()
	hideCategories()
	script.Parent.CameraChooser.Moving.Visible = true
	script.Parent.CategoryChooser.Moving.BackgroundColor3 = Color3.fromRGB(35,167,28)
end)
script.Parent.CategoryChooser.Drones.MouseButton1Click:Connect(function()
	hideCategories()
	script.Parent.CameraChooser.Drones.Visible = true
	script.Parent.CategoryChooser.Drones.BackgroundColor3 = Color3.fromRGB(35,167,28)
end)

replicated.Events.ChangeCamera.OnClientEvent:Connect(function(camType,id)
	for i,v in pairs(buttons) do
		for a,b in pairs(v) do
			b.BackgroundColor3 = Color3.fromRGB(0,0,0)
		end
	end
	script.Parent.CategoryChooser.Static.Indicator.Visible = false
	script.Parent.CategoryChooser.Moving.Indicator.Visible = false
	script.Parent.CategoryChooser.Drones.Indicator.Visible = false
	
	buttons[camType][id].BackgroundColor3 = Color3.fromRGB(35,167,28)
	
	if camType == "Drone" then
		script.Parent.CategoryChooser.Drones.Indicator.Visible = true
	else
		script.Parent.CategoryChooser[camType].Indicator.Visible = true
	end
end)