local theme = require(script.Parent.Parent.Parent.Themes.Current)
script.Frame.TextLabel.TextColor3 = theme.BaseText

return function()
	return script.Frame:Clone()
end
