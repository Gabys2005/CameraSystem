local Gui = {}

Gui._gui = nil

function Gui:Set(gui: ScreenGui)
	Gui._gui = gui
end

function Gui:Get()
	return Gui._gui
end

return Gui
