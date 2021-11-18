local roundedButton = require(script.Parent.RoundedButton)
local theme = require(script.Parent.Parent.Themes.Current)
local data = require(script.Parent.Parent.Scripts.UpdateData)

export type ResponsiveButtonParams = {
	Name: string,
	Setting: string,
	EventToFire: RemoteEvent?,
	Size: UDim2?,
}

return function(params: ResponsiveButtonParams): TextButton
	local button = roundedButton(params.Name)

	if params.Size then
		button.Size = params.Size
	end

	button.MouseButton1Click:Connect(function()
		if params.EventToFire then
			params.EventToFire:FireServer(not data:get(params.Setting))
		else
			data:set(params.Setting, not data:get(params.Setting))
		end
	end)

	local function update(newval)
		local newval = newval or data:get(params.Setting)
		if newval then
			button.BackgroundColor3 = theme.Highlighted
		else
			button.BackgroundColor3 = theme.Base
		end
	end
	data:onChange(params.Setting, update)
	update()

	return button
end
