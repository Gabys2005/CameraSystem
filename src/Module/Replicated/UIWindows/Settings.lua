local SettingsWindow = {}

local replicated = script.Parent.Parent
local TopbarMenu = require(replicated.Scripts.Control.TopbarMenu)
local Icon = require(replicated.Dependencies.TopbarPlus)
local Fusion = require(replicated.Dependencies.Fusion)
local Gui = require(replicated.Data.Gui):Get()
local Window = require(replicated.UIComponents.Window)
local CategorySwitcher = require(replicated.UIComponents.CategorySwitcher)
local Theme = require(replicated.Data.Themes)
local Dropdown = require(replicated.UIComponents.Dropdown)

local New = Fusion.New
local Value = Fusion.Value
local Children = Fusion.Children

local visible = Value(true)

local topbarButton = Icon.new():setLabel("Settings"):autoDeselect(false)
TopbarMenu:AddIcon(topbarButton)

topbarButton.toggled:Connect(function(isToggled)
	visible:set(isToggled)
end)

local temp_themes = { "Dark", "Light", "Test" }

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
						Dropdown {
							Items = temp_themes,
							SelectionChanged = function(i)
								Theme:SetCurrent(temp_themes[i])
							end,
							Size = UDim2.new(1, 0, 0, 30),
						},
					},
				},
			},
		},
	},
}

return SettingsWindow
