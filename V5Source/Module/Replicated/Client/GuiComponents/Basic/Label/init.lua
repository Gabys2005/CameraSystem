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
	RichText: boolean?,
}

type Label = typeof(setmetatable({} :: {
	Instance: TextLabel,
}, Label))

function Label.new(params: LabelParams)
	local self = setmetatable({}, Label)

	local label = New("TextLabel", {
		Text = params.Text,
		BackgroundTransparency = 1,
		Font = Enum.Font.Gotham,
		TextSize = 14,
		TextWrapped = true,
		Size = params.Size or UDim2.fromOffset(100, 30),
		RichText = params.RichText,
	})

	self.Instance = label

	Component.apply(self)
	return self
end

function Label.SetText(self: Label, text: string)
	self.Instance.Text = text
end

function Label.ApplyTheme(self: Label, theme: Types.Theme)
	self.Instance.TextColor3 = theme.Text.Primary
end

function Label.Destroy(self: Label)
	self.Instance:Destroy()
	Component.cleanup(self)
end

return Label
