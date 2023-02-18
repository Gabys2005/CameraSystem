local Dropdown = require(script.Parent.Parent.Dropdown)

return function(target)
	local dropdown = Dropdown {
		Items = { "test", "test2", "test3" },
		SelectionChanged = function(id)
			print(`changed to id: {id}`)
		end,
	}
	dropdown.Parent = target

	return function()
		dropdown:Destroy()
	end
end
