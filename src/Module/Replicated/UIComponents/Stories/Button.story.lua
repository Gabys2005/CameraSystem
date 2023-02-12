local Button = require(script.Parent.Parent.Button)

return function(target)
	local button = Button {
		Text = "Button",
		OnClick = function()
			print("clicked")
		end,
	}
	button.Parent = target

	return function()
		button:Destroy()
	end
end
