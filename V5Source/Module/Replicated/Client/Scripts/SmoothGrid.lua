-- This function changes the CellSize property (resizes the children) to make sure there aren't gaps
-- on the right side of the grid
return function(frame: GuiObject, grid: UIGridLayout, maxButtonsPerRow: number?)
	local padding = grid.CellPadding
	local size = grid.CellSize
	local max = maxButtonsPerRow or math.huge

	local function move()
		local buttonsPerRow = math.min(math.round(frame.AbsoluteSize.X / (size.X.Offset + padding.X.Offset)), max)
		local buttonXSize = frame.AbsoluteSize.X / buttonsPerRow - padding.X.Offset - 2
		grid.CellSize = UDim2.new(0, buttonXSize, 0, size.Y.Offset)
	end
	move()
	frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		move()
	end)
end
