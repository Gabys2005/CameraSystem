local theme = require(script.Parent.Parent.Themes.Current)
local data = require(script.Parent.Parent.Parent.Data)
script.Frame.TextLabel.TextColor3 = theme.BaseText

return function()
	return script.Frame:Clone()
end
