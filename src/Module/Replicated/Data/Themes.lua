local Themes = {}
local replicated = script.Parent.Parent
local Fusion = require(replicated.Dependencies.Fusion)

local Value = Fusion.Value
local Spring = Fusion.Spring

Themes._current = {
	Data = {
		General = {
			BackgroundDark = Color3.fromRGB(27, 27, 27),
			Background = Color3.fromRGB(50, 50, 50),
		},
		Button = {
			Primary = Color3.fromRGB(94, 94, 94),
			Error = Color3.fromRGB(161, 0, 0),
			Text = Color3.fromRGB(255, 255, 255),
			Font = Enum.Font.Gotham,
		},
		Label = {
			Text = Color3.fromRGB(255, 255, 255),
		},
	},
	Name = "Default",
}

Themes._themes = {
	Default = Themes._current.Data,
}

Themes._fusionValues = {
	General = {
		BackgroundDark = Value(Themes._current.Data.General.BackgroundDark),
		Background = Value(Themes._current.Data.General.Background),
	},
	Button = {
		Primary = Value(Themes._current.Data.Button.Primary),
		Error = Value(Themes._current.Data.Button.Error),
		Text = Value(Themes._current.Data.Button.Text),
		Font = Value(Themes._current.Data.Button.Font),
	},
	Label = {
		Text = Value(Themes._current.Data.Label.Text),
	},
}

function Themes:Get()
	return Themes._current.Data
end

function Themes:GetFusion()
	return Themes._fusionValues
end

function Themes:GetName()
	return Themes._current.Name
end

function Themes:Add(name, data)
	Themes._themes[name] = data
end

function Themes:SetCurrent(name)
	local data = Themes._themes[name]
	Themes._current = { Data = data, Name = name }
	-- TODO: clean this up
	for name, value in data.General do
		Themes._fusionValues.General[name]:set(value)
	end
	for name, value in data.Button do
		Themes._fusionValues.Button[name]:set(value)
	end
	for name, value in data.Label do
		Themes._fusionValues.Label[name]:set(value)
	end
end

return Themes
