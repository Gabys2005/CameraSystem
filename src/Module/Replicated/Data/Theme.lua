local Theme = {}

Theme._theme = {
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
}

function Theme:Get()
	return Theme._theme
end

return Theme
