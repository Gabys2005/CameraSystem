--!strict
local main = script.Parent.Parent

local Component = require(main)
local Types = require(main.Types)
local New = require(main.New)

local Label = {}
Label.__index = Label

type LabelParams = {
	Text: string,
	Size: UDim2?,
	Position: UDim2?,
	AnchorPoint: Vector2?,
	RichText: boolean?,
	Bold: boolean?,
}

type Label = typeof(setmetatable({} :: {
	Instance: TextLabel,
}, Label))

function Label.new(params: LabelParams)
	local self = setmetatable({}, Label)

	local label = New("TextLabel", {
		Text = params.Text,
		BackgroundTransparency = 1,
		FontFace = Font.new(
			"rbxasset://fonts/families/GothamSSm.json",
			if params.Bold then Enum.FontWeight.Bold else Enum.FontWeight.Regular
		),
		TextSize = 14,
		TextWrapped = true,
		Size = params.Size or UDim2.fromOffset(100, 30),
		Position = params.Position or UDim2.fromScale(0, 0),
		RichText = params.RichText,
		AnchorPoint = params.AnchorPoint or Vector2.new(0, 0),
	})

	self.Instance = label

	Component.apply(self)
	return self
end

function Label.SetText(self: Label, text: string)
	self.Instance.Text = text
end

function Label.SetParent(self: Label, newParent: Instance)
	self.Instance.Parent = newParent
end

function Label.ApplyTheme(self: Label, theme: Types.Theme)
	self.Instance.TextColor3 = theme.Text.Primary
end

function Label.Destroy(self: Label)
	self.Instance:Destroy()
	Component.cleanup(self)
end

return Label
