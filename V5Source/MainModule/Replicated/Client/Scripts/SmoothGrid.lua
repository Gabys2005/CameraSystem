return function(frame:GuiObject,grid:UIGridLayout,max:number)
	local padding = grid.CellPadding
	local size = grid.CellSize
	max = max or math.huge
	
	local function move(children)
		local buttonsPerRow = math.min(math.round(frame.AbsoluteSize.X / (size.X.Offset + padding.X.Offset)),max)
		local buttonXSize = frame.AbsoluteSize.X / buttonsPerRow - padding.X.Offset
		grid.CellSize = UDim2.new(0,buttonXSize,0,size.Y.Offset)
	end
	
	local children = frame:GetChildren()
	move(children)
	frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		move(children)
	end)
end