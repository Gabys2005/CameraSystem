--!strict

local main = script.Parent.Parent
local events = main.Parent.Parent.Events

local Component = require(main)
local New = require(main.New)
local Types = require(main.Types)

local Switch = require(main.Basic.Switch)
local DotSlider = require(main.Basic.DotSlider)
local Button = require(main.Basic.Button)
local Label = require(main.Basic.Label)

local data = require(main.Parent.Scripts.UpdateData)
local smoothGrid = require(main.Parent.Scripts.SmoothGrid)

local GlobalSettingsWindow = {}
GlobalSettingsWindow.__index = GlobalSettingsWindow

type GlobalSettingsWindow = typeof(setmetatable(
	{} :: {
		Instance: Frame,
		TransitionButtons: { [string]: Button.Button },
		Components: { any },
		Backgrounds: { Frame },
	},
	GlobalSettingsWindow
))

function GlobalSettingsWindow.new()
	local self = setmetatable({}, GlobalSettingsWindow) :: GlobalSettingsWindow
	self.TransitionButtons = {}
	self.Components = {}
	self.Backgrounds = {}

	local mainFrame = New("ScrollingFrame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.fromScale(0, 0),
		ScrollBarThickness = 5,
	}, New("UIListLayout", { Padding = UDim.new(0, 5) }))
	self.Instance = mainFrame

	local switchContainer = New("Frame", {
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Parent = mainFrame,
	}, { New("UICorner"), New("UIPadding", { PaddingBottom = UDim.new(0, 5), PaddingTop = UDim.new(0, 5) }) })
	table.insert(self.Backgrounds, switchContainer)

	local autoFovSwitch = Switch.new({
		Name = "Auto FOV:",
		Setting = "Shared.Settings.AutoFov",
		EventToFire = events.ChangeAutoFov,
	})
	autoFovSwitch:SetParent(switchContainer)
	table.insert(self.Components, autoFovSwitch)

	local barSizeSlider = DotSlider.new({
		Name = "Bar size: ",
		Min = 0,
		Max = 50,
		Round = 0,
		Default = 20,
		Setting = "Shared.Settings.BarSize",
		EventToFire = events.ChangeBarSize,
		Suffix = "%",
	})
	barSizeSlider:SetParent(mainFrame)
	table.insert(self.Components, barSizeSlider)

	local transitionTime = DotSlider.new({
		Name = "Transition time:",
		Min = 50,
		Max = 200,
		Round = 0,
		Default = 100,
		Setting = "Shared.Settings.TransitionTimes.Multiplier",
		EventToFire = events.ChangeTransitionSpeed,
		Suffix = "%",
	})
	transitionTime:SetParent(mainFrame)
	table.insert(self.Components, transitionTime)

	local transitionButtonsContainer = New("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		Parent = mainFrame,
	}, {
		New("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5) }),
		New("UICorner"),
		New(
			"UIPadding",
			{ PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 5), PaddingBottom = UDim.new(0, 10) }
		),
	})
	table.insert(self.Backgrounds, transitionButtonsContainer)

	local transitionEffectLabel = Label.new({ Text = "Transition effect", Size = UDim2.new(1, 0, 0, 30) })
	transitionEffectLabel:SetParent(transitionButtonsContainer)
	table.insert(self.Components, transitionEffectLabel)

	local grid = New("UIGridLayout", {
		CellSize = UDim2.new(0, 100, 0, 30),
		CellPadding = UDim2.fromOffset(7, 7),
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
	})

	local buttonContainer = New("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		BackgroundTransparency = 1,
		Parent = transitionButtonsContainer,
	}, grid)

	for _, name in { "None", "Black", "White" } do
		local button = Button.new({
			Text = name,
			OnClick = function()
				return events.ChangeTransition:FireServer(name)
			end,
		})
		button:SetParent(buttonContainer)
		self.TransitionButtons[name] = button
	end

	data:onChange("Shared.Settings.Transition", function()
		self:_UpdateTransitionButtons()
	end)

	smoothGrid(buttonContainer, grid)

	Component.apply(self)
	return self
end

function GlobalSettingsWindow.ApplyTheme(self: GlobalSettingsWindow, theme: Types.Theme)
	for _, background in self.Backgrounds do
		background.BackgroundColor3 = theme.Background.Dark
	end
	self:_UpdateTransitionButtons(theme)
end

function GlobalSettingsWindow._UpdateTransitionButtons(self: GlobalSettingsWindow, theme: Types.Theme?)
	local actualTheme = theme or Component.getTheme()
	local currentTransition = data:get("Shared.Settings.Transition")
	for name, button in self.TransitionButtons do
		if name == currentTransition then
			button:SetBackgroundColor(actualTheme.Buttons.Primary.Selected)
		else
			button:SetBackgroundColor(actualTheme.Buttons.Primary.Background)
		end
	end
end

function GlobalSettingsWindow.Destroy(self: GlobalSettingsWindow)
	Component.cleanup(self)
	self.Instance:Destroy()
	for _, button in self.TransitionButtons do
		button:Destroy()
	end
	for _, component in self.Components do
		component:Destroy()
	end
end

return GlobalSettingsWindow
