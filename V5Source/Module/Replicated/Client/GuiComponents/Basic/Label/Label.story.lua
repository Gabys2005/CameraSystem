--!strict
return function(target)
	local Label = require(script.Parent)

	local label = Label.new({
		Text = "Label!",
	})
	label.Instance.Parent = target

	return function()
		label:Destroy()
	end
end
