--!strict
local TweenService = game:GetService("TweenService")

local main = script.Parent.Parent
local New = require(main.New)
local Types = require(main.Types)
local Component = require(main)

local BACKGROUND_CHANGE_TWEEN_INFO = TweenInfo.new(0.5)
local TOPBAR_SIZE = 40
local MARGIN = 5

local CategoryChooser = {}
CategoryChooser.__index = CategoryChooser

type CategoryChooserFrame = {
	Instance: any,
	Name: string,
}

type CategoryChooserParams = {
	Categories: { CategoryChooserFrame },
}

export type CategoryChooser = typeof(setmetatable(
	{} :: {
		Instance: Frame,
		Topbar: Frame,
		Buttons: { TextButton },
		SelectedCategory: number,
		Connections: { RBXScriptConnection },
		Instances: { any },
	},
	CategoryChooser
))

function CategoryChooser.new(params: CategoryChooserParams)
	local self = setmetatable({}, CategoryChooser) :: CategoryChooser
	self.Buttons = {}
	self.Connections = {}
	self.Instances = {}
	self.SelectedCategory = 1

	local mainFrame = New("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		ClipsDescendants = true,
	})

	local topbar = New("Frame", {
		Size = UDim2.new(1, 0, 0, TOPBAR_SIZE),
		Parent = mainFrame,
	}, {
		New("UICorner"),
		New("UIPadding", {
			PaddingLeft = UDim.new(0, 5),
			PaddingRight = UDim.new(0, 5),
			PaddingBottom = UDim.new(0, 5),
			PaddingTop = UDim.new(0, 5),
		}),
	})
	self.Topbar = topbar

	local pageLayout = New("UIPageLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		TweenTime = 0.25,
		GamepadInputEnabled = false,
		ScrollWheelInputEnabled = false,
		TouchInputEnabled = false,
	})

	local contentContainer = New("Frame", {
		Size = UDim2.new(1, 0, 1, -TOPBAR_SIZE - MARGIN),
		Position = UDim2.fromOffset(0, TOPBAR_SIZE + MARGIN),
		BackgroundTransparency = 1,
		Parent = mainFrame,
	}, pageLayout)

	local buttonSize = 1 / #params.Categories

	for i, category in params.Categories do
		local button = New("TextButton", {
			Size = UDim2.new(buttonSize, -5, 1, 0),
			Position = UDim2.new((i - 1) * buttonSize, 2.5, 0, 0),
			Font = Enum.Font.Gotham,
			TextSize = 14,
			Text = category.Name,
			Parent = topbar,
		}, New("UICorner"))
		table.insert(self.Buttons, button)
		table.insert(
			self.Connections,
			button.MouseButton1Click:Connect(function()
				self.SelectedCategory = i
				self:_UpdateButtonColors()
				pageLayout:JumpToIndex(i - 1)
			end)
		)

		if category.Instance then
			if typeof(category.Instance) == "Instance" then
				category.Instance.Parent = contentContainer
			else
				if category.Instance.SetParent then
					category.Instance:SetParent(contentContainer)
				elseif category.Instance.Instance then
					category.Instance.Instance.Parent = contentContainer
				end
			end
			table.insert(self.Instances, category.Instance)
		end
	end

	self.Instance = mainFrame

	Component.apply(self)
	return self
end

function CategoryChooser._UpdateButtonColors(self: CategoryChooser, theme: Types.Theme?)
	local actualTheme = theme or Component.getTheme()
	for i, button in self.Buttons do
		button.TextColor3 = actualTheme.Text.Primary
		local backgroundColor = if i == self.SelectedCategory
			then actualTheme.Buttons.Primary.Selected
			else actualTheme.Buttons.Primary.Background
		TweenService:Create(button, BACKGROUND_CHANGE_TWEEN_INFO, { BackgroundColor3 = backgroundColor }):Play()
		if i == self.SelectedCategory then
			button.FontFace.Bold = true
		else
			button.FontFace.Bold = false
		end
	end
end

function CategoryChooser.ApplyTheme(self: CategoryChooser, theme: Types.Theme)
	self.Topbar.BackgroundColor3 = theme.Background.Dark
	self:_UpdateButtonColors(theme)
end

function CategoryChooser.SetParent(self: CategoryChooser, newParent: Instance)
	self.Instance.Parent = newParent
end

function CategoryChooser.Destroy(self: CategoryChooser)
	Component.cleanup(self)
	self.Instance:Destroy()
	for _, instance in self.Instances do
		instance:Destroy()
	end
end

return CategoryChooser
