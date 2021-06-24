local UserInputService = game:GetService("UserInputService")

local gui = script.Parent
local minimised = false

local dragging
local dragInput
local dragStart
local startPos

local function update(input)
	local delta = input.Position - dragStart
	gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

gui.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = gui.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

gui.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

script.Parent.Close.MouseButton1Click:Connect(function()
	script.Parent.Visible = false
end)

script.Parent.Minimise.MouseButton1Click:Connect(function()
	if minimised == false then
		script.Parent.Size = UDim2.new(0,80,0,25)
		script.Parent.Content.Visible = false
		script.Parent.Minimise.Text = "+"
	else
		script.Parent.Size = UDim2.new(0,200,0,25)
		script.Parent.Content.Visible = true
		script.Parent.Minimise.Text = "—"
	end
	minimised = not minimised
end)