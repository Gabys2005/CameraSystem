-- This generates buttons for the camera switcher guis, put it in a separete
-- module because both Static and Moving cameras use it
local utils = require(script.Parent.Utils)
local button = require(script.Parent.Parent.GuiComponents.Basic.RoundedButton)
local data = require(script.Parent.Parent.Parent.Data)
local theme = require(script.Parent.Parent.Themes.Current)
local api = require(workspace.CameraSystem:WaitForChild("Api"))
local drones = api:GetCamsById().Drones
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
		LayoutOrder = data.Order,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
	})
	local categoryTitle = utils:NewInstance("TextLabel", {
		BackgroundColor3 = data.Color,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 20),
		TextColor3 = theme.BaseText,
		Text = data.Name,
		Parent = frame,
	})
	local categoryTitleUiCorner = utils:NewInstance("UICorner", {
		CornerRadius = UDim.new(0, 8),
		Parent = categoryTitle,
	})
	local buttonsFrame = utils:NewInstance("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 0),
		Position = UDim2.fromOffset(0, 25),
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
	smoothGrid(buttonsFrame, uigridlayout)
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
		Padding = UDim.new(0, 5),
		Parent = frame,
	})
	local uncategorised = getCamerasInFolder(folder)
	local categorised = {}
	for i, v in pairs(folder:GetChildren()) do
		if v:IsA("Folder") or v:IsA("Color3Value") then
			local color = theme.Base
			if v:IsA("Color3Value") then
				color = v.Value
			end
			if v:GetAttribute("Color") then
				color = v:GetAttribute("Color")
			end
			table.insert(categorised, {
				Name = v.Name,
				Order = v:GetAttribute("Order") or 998,
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
		Color = theme.Base,
		Order = 999,
		Cameras = uncategorised,
	}, camType).Parent =
		frame
end

function other:updateDroneVisibility()
	if data.Local.Watching or data.Local.ControllingDrone then
		for i, v in pairs(drones) do
			v.Transparency = 1
		end
	else
		for i, v in pairs(drones) do
			v.Transparency = 0
		end
	end
end

return other
