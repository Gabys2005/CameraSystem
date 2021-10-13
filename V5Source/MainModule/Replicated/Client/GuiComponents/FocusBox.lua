local theme = require(script.Parent.Parent.Themes.Current)

script.FocusBox.UsernameBox.BackgroundColor3 = theme.DarkerButton
script.FocusBox.Focus.BackgroundColor3 = theme.DarkerButton
script.FocusBox.StopFocus.BackgroundColor3 = theme.DarkerButton

return function()
	return script.FocusBox:Clone()
end