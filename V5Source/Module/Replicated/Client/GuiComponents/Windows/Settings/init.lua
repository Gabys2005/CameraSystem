local windowComponents = script.Parent.Parent.WindowComponents

local main = script.Parent.Parent
local Component = require(main)
local New = require(main.New)

local CategoryChooser = require(main.Basic.CategoryChooser)
local LocalSettingsWindow = require(main.WindowComponents.LocalSettings)
local GlobalSettingsWindow = require(main.WindowComponents.GlobalSettings)

local SettingsWindow = {}
SettingsWindow.__index = SettingsWindow

type SettingsWindow = typeof(setmetatable(
	{} :: {
		Instance: Frame,
		Chooser: CategoryChooser.CategoryChooser,
	},
	SettingsWindow
))

function SettingsWindow.new()
	local self = setmetatable({}, SettingsWindow)

	local mainFrame = New("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
	})

	local chooser = CategoryChooser.new({
		Categories = {
			{
				Name = "Local",
				Instance = LocalSettingsWindow.new(),
			},
			{
				Name = "Global",
				Instance = GlobalSettingsWindow.new(),
			},
		},
	})
	chooser:SetParent(mainFrame)
	self.Chooser = chooser
	self.Instance = mainFrame

	Component.apply(self)
	return self
end

function SettingsWindow.ApplyTheme() end

function SettingsWindow.Destroy(self: SettingsWindow)
	Component.cleanup(self)
	self.Chooser:Destroy()
	self.Instance:Destroy()
end

return SettingsWindow
