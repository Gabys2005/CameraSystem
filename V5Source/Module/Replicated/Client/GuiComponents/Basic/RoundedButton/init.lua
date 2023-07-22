local theme = require(script.Parent.Parent.Parent.Themes.Current)

script.CameraButtonTemplate.BackgroundColor3 = theme.Base
script.CameraButtonTemplate.TextColor3 = theme.BaseText

return function(name: string)
	local copy = script.CameraButtonTemplate:Clone()
	copy.Text = name
	return copy
end
