-- This generates buttons for the camera switcher guis, put it in a separete
-- module because both Static and Moving cameras use it
local utils = require(script.Parent.Utils)
local button = require(script.Parent.Parent.GuiComponents.Basic.RoundedButton)
local smoothGrid = require(script.Parent.SmoothGrid)
local other = {}

local function getCamerasInFolder(folder: Folder | Color3Value)
	local cameras = {}
	for _, child in pairs(folder:GetChildren()) do
		if child:IsA("Part") or child:IsA("Model") then
			table.insert(cameras, child)
		end
	end
	return cameras
end

local function makeCategory(data, camType: string)
	local frame = utils:NewInstance("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
	})
	local categoryTitle = utils:NewInstance("TextLabel", {
		BackgroundColor3 = data.Color,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 20),
		Text = data.Name,
		Parent = frame,
	})
	local buttonsFrame = utils:NewInstance("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 0),
		Position = UDim2.fromOffset(0, 20),
		AutomaticSize = Enum.AutomaticSize.Y,
		Parent = frame,
	})
	local uigridlayout = utils:NewInstance("UIGridLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		CellPadding = UDim2.new(0, 5, 0, 5),
		CellSize = UDim2.new(0, 100, 0, 30),
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		Parent = buttonsFrame,
	})
	for i, v in pairs(data.Cameras) do
		local button = button(v.Name)
		button.Parent = buttonsFrame
		button.MouseButton1Click:Connect(function()
			script.Parent.Parent.Parent.Events.ChangeCam:FireServer(camType, v:GetAttribute("ID"))
		end)
	end
	return frame
end

function other:generateButtonsForFolder(folder: Folder, parent: GuiObject, camType: string)
	local frame = utils:NewInstance("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		AutomaticSize = Enum.AutomaticSize.Y,
		Parent = parent,
	})
	local uilistlayout = utils:NewInstance("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = frame,
	})
	local uncategorised = getCamerasInFolder(folder)
	local categorised = {}
	for i, v in pairs(folder:GetChildren()) do
		if v:IsA("Folder") or v:IsA("Color3Value") then
			local color = Color3.fromRGB(255, 255, 255)
			if v:IsA("Color3Value") then
				color = v.Value
			end
			if v:GetAttribute("Color") then
				color = v:GetAttribute("Color")
			end
			table.insert(categorised, {
				Name = v.Name,
				Color = color,
				Cameras = getCamerasInFolder(v),
			})
		end
	end
	for i, v in pairs(categorised) do
		local category = makeCategory(v, camType)
		category.Parent = frame
	end
	makeCategory({
		Name = "Uncategorised",
		Color = Color3.fromRGB(255, 255, 255),
		Cameras = uncategorised,
	}, camType).Parent =
		frame
end

return other
