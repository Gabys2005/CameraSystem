local theme = require(script.Parent.Parent.Themes.Current)

script.Frame.TextLabel.TextColor3 = theme.BaseText
script.Frame.Frame.BackgroundColor3 = theme.Base
script.Frame.Frame.TextColor3 = theme.BaseText

export type CheckboxParams = {
	Name: string,
	Checked: boolean
}

return function(params:CheckboxParams)
	local copy = script.Frame:Clone()
	copy.TextLabel.Text = params.Name
	if params.Checked then
		copy.Frame.Text = "✔"
	end
	return copy
end