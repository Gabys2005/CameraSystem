local CamerasWindow = {}
local replicated = script.Parent.Parent
local TopbarMenu = require(replicated.Scripts.Control.TopbarMenu)
local Icon = require(replicated.Dependencies.TopbarPlus)
local Fusion = require(replicated.Dependencies.Fusion)
local Gui = require(replicated.Data.Gui):Get()
local Window = require(replicated.UIComponents.Window)
local Button = require(replicated.UIComponents.Button)
local Theme = require(replicated.Data.Themes)

local Value = Fusion.Value
local New = Fusion.New
local Children = Fusion.Children

local visible = Value(true)

local topbarButton = Icon.new():setLabel("Cameras"):autoDeselect(false)
TopbarMenu:AddIcon(topbarButton)

topbarButton.selected:Connect(function()
	visible:set(true)
end)

topbarButton.deselected:Connect(function()
	visible:set(false)
end)

local isLight = false

local window = Window {
	[Children] = Button {
		Text = "Change",
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		OnClick = function()
			if isLight then
				Theme:SetCurrent("Default")
			else
				Theme:SetCurrent("Light")
			end
			isLight = not isLight
		end,
	},
	Visible = visible,
	Parent = Gui,
	Title = "Cameras",
	OnClose = function()
		topbarButton:deselect()
	end,
}

return CamerasWindow
