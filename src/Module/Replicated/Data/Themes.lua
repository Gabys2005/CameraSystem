local Themes = {}

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

function Themes:Get()
	return Themes._current.Data
end

function Themes:GetName()
	return Themes._current.Name
end

function Themes:Add(name, data)
	Themes._themes[name] = data
end

function Themes:SetCurrent(name)
	Themes._current = { Data = Themes._themes[name], Name = name }
end

--TODO: fusion

return Themes
