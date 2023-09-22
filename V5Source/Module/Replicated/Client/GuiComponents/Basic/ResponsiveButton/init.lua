--!strict

local main = script.Parent.Parent

local Component = require(main)
local Types = require(main.Types)

local Button = require(script.Parent.Button)
local theme = require(script.Parent.Parent.Parent.Themes.Current)
local data = require(script.Parent.Parent.Parent.Scripts.UpdateData)

type ResponsiveButtonParams = {
	Text: string,
	Setting: string,
	EventToFire: RemoteEvent?,
	Size: UDim2?,
}

local ResponsiveButton = {}
ResponsiveButton.__index = ResponsiveButton

export type ResponsiveButton = typeof(setmetatable(
	{} :: {
		Button: Button.Button,
		Setting: string,
	},
	ResponsiveButton
))

function ResponsiveButton.new(params: ResponsiveButtonParams)
	local self = setmetatable({}, ResponsiveButton)
	self.Setting = params.Setting

	local button = Button.new({
		Text = params.Text,
		Size = params.Size,
		OnClick = function()
			if params.EventToFire then
				params.EventToFire:FireServer(not data:get(params.Setting))
			else
				data:set(params.Setting, not data:get(params.Setting))
			end
			return
		end,
	})

	self.Button = button

	local function update(newval)
		local actualValue = newval or data:get(params.Setting)
		if actualValue then
			button:SetBackgroundColor(theme.Buttons.Primary.Selected)
		else
			button:SetBackgroundColor(theme.Buttons.Primary.Background)
		end
	end
	data:onChange(params.Setting, update)
	update()

	Component.apply(self)
	return self
end

function ResponsiveButton.ApplyTheme(self: ResponsiveButton, theme: Types.Theme)
	local currentValue = data:get(self.Setting)
	if currentValue then
		self.Button:SetBackgroundColor(theme.Buttons.Primary.Selected)
	else
		self.Button:SetBackgroundColor(theme.Buttons.Primary.Background)
	end
end

function ResponsiveButton.SetParent(self: ResponsiveButton, newParent: Instance)
	self.Button.Instance.Parent = newParent
end

function ResponsiveButton.Destroy(self: ResponsiveButton)
	Component.cleanup(self)
	self.Button:Destroy()
end

return ResponsiveButton
