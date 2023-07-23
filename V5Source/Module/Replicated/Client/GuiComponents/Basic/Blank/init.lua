--!strict

local main = script.Parent.Parent
local New = require(main.New)
local Types = require(main.Types)
local Component = require(main)

local Blank = {}
Blank.__index = Blank

type Blank = typeof(setmetatable({} :: {
	Instance: Frame,
	Label: TextLabel,
}, Blank))

function Blank.new()
	local self = setmetatable({}, Blank)

	local label = New("TextLabel", {
		Size = UDim2.new(1, -50, 1, -50),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Text = "Blank Component",
		TextScaled = true,
		TextWrapped = true,
		Font = Enum.Font.Gotham,
	})

	local frame = New("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
	}, {
		label,
	})

	self.Instance = frame
	self.Label = label

	Component.apply(self)
	return self
end

function Blank.ApplyTheme(self: Blank, theme: Types.Theme)
	self.Label.TextColor3 = theme.BaseText
end

function Blank.Destroy(self: Blank)
	self.Instance:Destroy()
	Component.cleanup(self)
end

return Blank
