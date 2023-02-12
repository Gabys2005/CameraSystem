local SettingsWindow = {}

local replicated = script.Parent.Parent
local TopbarMenu = require(replicated.Scripts.Control.TopbarMenu)
local Icon = require(replicated.Dependencies.TopbarPlus)
local Fusion = require(replicated.Dependencies.Fusion)
local Gui = require(replicated.Data.Gui):Get()
local Window = require(replicated.UIComponents.Window)
local CategorySwitcher = require(replicated.UIComponents.CategorySwitcher)
local Button = require(replicated.UIComponents.Button)
local Theme = require(replicated.Data.Themes)

local New = Fusion.New
local Value = Fusion.Value
local Children = Fusion.Children
local ForValues = Fusion.ForValues

local visible = Value(true)

local topbarButton = Icon.new():setLabel("Settings"):autoDeselect(false)
TopbarMenu:AddIcon(topbarButton)

topbarButton.toggled:Connect(function(isToggled)
	visible:set(isToggled)
end)

local window = Window {
	Visible = visible,
	Parent = Gui,
	Title = "Settings",
	OnClose = function()
		topbarButton:deselect()
	end,
	[Children] = CategorySwitcher {
		FullWidth = true,
		Content = {
			{ Name = "Global", Content = New("Frame") {} },
			{
				Name = "Local",
				Content = New("Frame") {
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
					[Children] = {
						New("UIGridLayout") {
							CellSize = UDim2.fromOffset(150, 30),
						},
						ForValues({ "Light", "Default" }, function(theme)
							return Button {
								Text = theme,
								OnClick = function()
									Theme:SetCurrent(theme)
								end,
							}
						end, Fusion.cleanup),
					},
				},
			},
		},
	},
}

return SettingsWindow
