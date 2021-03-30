local cameras = workspace.CameraSystem.Cameras
local replicated = game.ReplicatedStorage.CameraSystem

--// Generate camera buttons
local usesFolders = false
if cameras.Static:FindFirstChildWhichIsA("Folder") or cameras.Static:FindFirstChildWhichIsA("Color3Value") then
	usesFolders = true
end
if usesFolders then
	script.Parent.Categories.Static.UIGridLayout:Destroy()
	script.UIListLayout:Clone().Parent = script.Parent.Categories.Static
	local uncategorised = {}
	for i,v in pairs(cameras.Static:GetChildren()) do
		if v:IsA("Folder") or v:IsA("Color3Value") then
			local category = script.Category:Clone()
			category.Title.Text = v.Name
			category.Parent = script.Parent.Categories.Static
			if v:IsA("Color3Value") then
				category.Title.BackgroundColor3 = v.Value
			elseif v:IsA("Folder") and v:GetAttribute("CategoryColor") then
				category.Title.BackgroundColor3 = v:GetAttribute("CategoryColor")
			end
			for a,b in pairs(v:GetChildren()) do
				local example = script.CameraButtonExample:Clone()
				example.Name = b:WaitForChild("ID").Value
				example.Text = b.Name
				example.Parent = category.Cams
				example.MouseButton1Click:Connect(function()
					replicated.Events.ChangeCamera:FireServer("Static", b.ID.Value)
				end)
				example.MouseButton2Click:Connect(function()
					replicated.Events.ChangeCamera:FireServer("Static", b.ID.Value, true)
				end)
			end
			category.Cams.Size = UDim2.new(1,0,0,math.ceil(#v:GetChildren()/2)*35)
			category.Size = UDim2.new(1,0,0,math.ceil(#v:GetChildren()/2)*35+17)
		else
			table.insert(uncategorised,v)
		end
	end
	if uncategorised[1] then
		local category = script.Category:Clone()
		category.Title.Text = "Uncategorised"
		category.Parent = script.Parent.Categories.Static
		for a,b in pairs(uncategorised) do
			local example = script.CameraButtonExample:Clone()
			example.Name = b:WaitForChild("ID").Value
			example.Text = b.Name
			example.Parent = category.Cams
			example.MouseButton1Click:Connect(function()
				replicated.Events.ChangeCamera:FireServer("Static", b.ID.Value)
			end)
			example.MouseButton2Click:Connect(function()
				replicated.Events.ChangeCamera:FireServer("Static", b.ID.Value, true)
			end)
		end
		category.Cams.Size = UDim2.new(1,0,0,math.ceil(#uncategorised/2)*35)
		category.Size = UDim2.new(1,0,0,math.ceil(#uncategorised/2)*35+17)
	end
else
	for i,v in pairs(cameras.Static:GetChildren()) do
		local example = script.CameraButtonExample:Clone()
		example.Name = v:WaitForChild("ID").Value
		example.Text = v.Name
		example.Parent = script.Parent.Categories.Static
		example.MouseButton1Click:Connect(function()
			replicated.Events.ChangeCamera:FireServer("Static", v.ID.Value)
		end)
		example.MouseButton2Click:Connect(function()
			replicated.Events.ChangeCamera:FireServer("Static", v.ID.Value, true)
		end)
	end
	script.Parent.Categories.Static.CanvasSize = UDim2.new(0,0,0,math.ceil(#cameras.Static:GetChildren()/2)*35)
end

--script.Parent.Categories.Static.CanvasSize = UDim2.new(0,0,0,math.ceil(#cameras.Static:GetChildren()/2)*35)

local usesFolders = false
if cameras.Moving:FindFirstChildWhichIsA("Folder") or cameras.Moving:FindFirstChildWhichIsA("Color3Value") then
	usesFolders = true
end
if usesFolders then
	script.Parent.Categories.Moving.UIGridLayout:Destroy()
	script.UIListLayout:Clone().Parent = script.Parent.Categories.Moving
	local order = {}
	local outOfOrder = {}
	local uncategorised = {}
	for i,v in pairs(cameras.Moving:GetChildren()) do
		if v:GetAttribute("Order") then
			order[v:GetAttribute("Order")] = v
		elseif v:IsA("Folder") or v:IsA("Color3Value") then
			table.insert(outOfOrder,v)
		else
			table.insert(uncategorised,v)
		end
	end
	for i,v in pairs(outOfOrder) do
		for a = 1,#cameras.Moving:GetChildren() do
			if not order[a] then
				order[a] = v
				break
			end
		end
	end
	for i,v in pairs(order) do
		--if v:IsA("Folder") or v:IsA("Color3Value") then
			local category = script.Category:Clone()
			category.Title.Text = v.Name
			category.Parent = script.Parent.Categories.Moving
			if v:IsA("Color3Value") then
				category.Title.BackgroundColor3 = v.Value
			elseif v:IsA("Folder") and v:GetAttribute("CategoryColor") then
				category.Title.BackgroundColor3 = v:GetAttribute("CategoryColor")
			end
			for a,b in pairs(v:GetChildren()) do
				local example = script.CameraButtonExample:Clone()
				example.Name = b:WaitForChild("ID").Value
				example.Text = b.Name
				example.Parent = category.Cams
				example.MouseButton1Click:Connect(function()
					replicated.Events.ChangeCamera:FireServer("Moving", b.ID.Value)
				end)
				example.MouseButton2Click:Connect(function()
					replicated.Events.ChangeCamera:FireServer("Moving", b.ID.Value, true)
				end)
			end
			category.Cams.Size = UDim2.new(1,0,0,math.ceil(#v:GetChildren()/2)*35)
			category.Size = UDim2.new(1,0,0,math.ceil(#v:GetChildren()/2)*35+17)
		--else
		--	table.insert(uncategorised,v)
		--end
	end
	if uncategorised[1] then
		local category = script.Category:Clone()
		category.Title.Text = "Uncategorised"
		category.Parent = script.Parent.Categories.Moving
		for a,b in pairs(uncategorised) do
			local example = script.CameraButtonExample:Clone()
			example.Name = b:WaitForChild("ID").Value
			example.Text = b.Name
			example.Parent = category.Cams
			example.MouseButton1Click:Connect(function()
				replicated.Events.ChangeCamera:FireServer("Moving", b.ID.Value)
			end)
			example.MouseButton2Click:Connect(function()
				replicated.Events.ChangeCamera:FireServer("Moving", b.ID.Value, true)
			end)
		end
		category.Cams.Size = UDim2.new(1,0,0,math.ceil(#uncategorised/2)*35)
		category.Size = UDim2.new(1,0,0,math.ceil(#uncategorised/2)*35+17)
	end
else
	for i,v in pairs(cameras.Moving:GetChildren()) do
		local example = script.CameraButtonExample:Clone()
		example.Name = v:WaitForChild("ID").Value
		example.Text = v.Name
		example.Parent = script.Parent.Categories.Moving
		example.MouseButton1Click:Connect(function()
			replicated.Events.ChangeCamera:FireServer("Moving", v.ID.Value)
		end)
		example.MouseButton2Click:Connect(function()
			replicated.Events.ChangeCamera:FireServer("Moving", v.ID.Value, true)
		end)
	end
	script.Parent.Categories.Moving.CanvasSize = UDim2.new(0,0,0,math.ceil(#cameras.Moving:GetChildren()/2)*35)
end

for i,v in pairs(cameras.Drones:GetChildren()) do
	local example = script.CameraButtonExample:Clone()
	example.Name = v:WaitForChild("ID").Value
	example.Text = v.Name
	example.Parent = script.Parent.Categories.Drones.ScrollingFrame
	example.MouseButton1Click:Connect(function()
		--replicated.Events.ChangeCamera:FireServer("Moving", v.ID.Value)
		for a,b in pairs(script.Parent.Categories.Drones.ScrollingFrame:GetChildren()) do
			if b:IsA("TextButton") then
				b.BackgroundColor3 = Color3.fromRGB(0,0,0)
			end
		end
		example.BackgroundColor3 = Color3.fromRGB(35, 167, 28)
		script.Parent.Categories.Drones.ControlPanel.Visible = true
		if (script.ControlDrone.Start.Value == true and script.ControlDrone.CurrentDrone.Value ~= v) or script.ControlDrone.Start.Value == false then
			script.SelectionBox.Adornee = v
		else
			script.SelectionBox.Adornee = nil
		end
		script.Parent.CurrentDrone.Value = v
	end)
end

script.Parent.Categories.Drones.ScrollingFrame.CanvasSize = UDim2.new(0,0,0,35*#cameras.Drones:GetChildren())

-- // Category navigation

local function hideAllCategories()
	script.SelectionBox.Adornee = nil
	script.Parent.Categories.Static.Visible = false
	script.Parent.Categories.Moving.Visible = false
	script.Parent.Categories.Drones.Visible = false
	script.Parent.CategoryChooser.Static.BackgroundColor3 = Color3.fromRGB(0,0,0)
	script.Parent.CategoryChooser.Moving.BackgroundColor3 = Color3.fromRGB(0,0,0)
	script.Parent.CategoryChooser.Drones.BackgroundColor3 = Color3.fromRGB(0,0,0)
end

script.Parent.CategoryChooser.Static.MouseButton1Click:Connect(function()
	hideAllCategories()
	script.Parent.Categories.Static.Visible = true
	script.Parent.CategoryChooser.Static.BackgroundColor3 = Color3.fromRGB(35,167,28)
end)

script.Parent.CategoryChooser.Moving.MouseButton1Click:Connect(function()
	hideAllCategories()
	script.Parent.Categories.Moving.Visible = true
	script.Parent.CategoryChooser.Moving.BackgroundColor3 = Color3.fromRGB(35,167,28)
end)

script.Parent.CategoryChooser.Drones.MouseButton1Click:Connect(function()
	hideAllCategories()
	script.Parent.Categories.Drones.Visible = true
	script.Parent.CategoryChooser.Drones.BackgroundColor3 = Color3.fromRGB(35,167,28)
end)

--// Focus

script.Parent.Focus.Focus.MouseButton1Click:Connect(function()
	replicated.Events.FocusOn:FireServer(script.Parent.Focus.Username.Text)
end)

script.Parent.Focus.End.MouseButton1Click:Connect(function()
	replicated.Events.FocusOn:FireServer()
end)

replicated.Shared.FocusedOn.Changed:Connect(function(val)
	if val then
		script.Parent.Focus.Focus.BackgroundColor3 = Color3.fromRGB(35,167,28)
		script.Parent.Focus.Username.Text = val.Name
	else
		script.Parent.Focus.Focus.BackgroundColor3 = Color3.fromRGB(0,0,0)
	end
end)

--// Drone menu

script.Parent.Categories.Drones.ControlPanel.SwitchTo.MouseButton1Click:Connect(function()
	replicated.Events.ChangeCamera:FireServer("Drone",script.Parent.CurrentDrone.Value.ID.Value)
end)

script.Parent.Categories.Drones.ControlPanel.Control.MouseButton1Click:Connect(function()
	script.ControlDrone.CurrentDrone.Value = script.Parent.CurrentDrone.Value
	script.ControlDrone.Start.Value = true
end)

script.Parent.Categories.Drones.ControlPanel.StopControlling.MouseButton1Click:Connect(function()
	script.ControlDrone.Start.Value = false
end)

--// Status updater

local function clearIndicators()
	for i,v in pairs(script.Parent.Categories.Static:GetChildren()) do
		if v:IsA("TextButton") then
			v.BackgroundColor3 = Color3.fromRGB(0,0,0)
		elseif v:IsA("Frame") then
			for a,b in pairs(v.Cams:GetChildren()) do
				if b:IsA("TextButton") then
					b.BackgroundColor3 = Color3.fromRGB(0,0,0)
				end
			end
		end
	end
	for i,v in pairs(script.Parent.Categories.Moving:GetChildren()) do
		if v:IsA("TextButton") then
			v.BackgroundColor3 = Color3.fromRGB(0,0,0)
		elseif v:IsA("Frame") then
			for a,b in pairs(v.Cams:GetChildren()) do
				if b:IsA("TextButton") then
					b.BackgroundColor3 = Color3.fromRGB(0,0,0)
				end
			end
		end
	end
	for i,v in pairs(script.Parent.Categories.Drones.ScrollingFrame:GetChildren()) do
		if v:IsA("TextButton") then
			v.Indicator.Visible = false
		end
	end
	script.Parent.CategoryChooser.Static.Indicator.Visible = false
	script.Parent.CategoryChooser.Moving.Indicator.Visible = false
	script.Parent.CategoryChooser.Drones.Indicator.Visible = false
	for i,v in pairs(script.Parent.Parent.Parent.DroneOverlay:GetChildren()) do
		v.BackgroundColor3 = Color3.fromRGB(112, 112, 112)
	end
	script.ControlDrone.CurrentRunningDroneID.Value = 0
end

replicated.Events.ChangeCamera.OnClientEvent:Connect(function(camType,id)
	clearIndicators()
	if camType == "Static" then
		script.Parent.CategoryChooser.Static.Indicator.Visible = true
		if script.Parent.Categories.Static:FindFirstChild(id) then
			script.Parent.Categories.Static[id].BackgroundColor3 = Color3.fromRGB(35, 167, 28)
		else
			for i,v in pairs(script.Parent.Categories.Static:GetChildren()) do
				if v:IsA("Frame") then
					if v.Cams:FindFirstChild(id) then
						v.Cams[id].BackgroundColor3 = Color3.fromRGB(35, 167, 28)
						break
					end
				end
			end
		end
	elseif camType == "Moving" then
		script.Parent.CategoryChooser.Moving.Indicator.Visible = true
		if script.Parent.Categories.Moving:FindFirstChild(id) then
			script.Parent.Categories.Moving[id].BackgroundColor3 = Color3.fromRGB(35, 167, 28)
		else
			for i,v in pairs(script.Parent.Categories.Moving:GetChildren()) do
				if v:IsA("Frame") then
					if v.Cams:FindFirstChild(id) then
						v.Cams[id].BackgroundColor3 = Color3.fromRGB(35, 167, 28)
						break
					end
				end
			end
		end
	elseif camType == "Drone" then
		script.Parent.CategoryChooser.Drones.Indicator.Visible = true
		script.Parent.Categories.Drones.ScrollingFrame[id].Indicator.Visible = true
		script.ControlDrone.CurrentRunningDroneID.Value = id
		if script.ControlDrone.CurrentDrone.Value and id == script.ControlDrone.CurrentDrone.Value.ID.Value then
			for i,v in pairs(script.Parent.Parent.Parent.DroneOverlay:GetChildren()) do
				v.BackgroundColor3 = Color3.fromRGB(35, 167, 28)
			end
		end
	end
end)