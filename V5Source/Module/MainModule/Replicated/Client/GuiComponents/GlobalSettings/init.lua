local dotslider = require(script.Parent.DotSlider)

return function()
	local copy = script.Frame:Clone()
	--dotslider({Name = "Bar size", Min = 0, Max = 50, Round = 0}).Parent = copy.SomeSlider
	return copy
end