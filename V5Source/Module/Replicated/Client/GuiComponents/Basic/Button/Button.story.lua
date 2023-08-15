--!strict
return function(target)
	local Button = require(script.Parent)

	local button = Button.new({
		Text = "Button!",
	})
	button.Instance.Parent = target

	return function()
		button:Destroy()
	end
end
