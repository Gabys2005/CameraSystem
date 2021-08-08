local uis = game:GetService("UserInputService")
local replicated = game.ReplicatedStorage.CameraSystem

local mouseDown = false

local function slide(input)
	local position = input.Position.X
	local sliderPos = position - script.Parent.Slider.AbsolutePosition.X
	script.Parent.Slider.Size = UDim2.new(0,sliderPos,1,0)
	local scalePos = script.Parent.Slider.Size.X.Offset/script.Parent.Size.X.Offset
	local orientation = scalePos * 180 - 90
	replicated.Events.SetOrientation:FireServer(orientation)
end

script.Parent.InputBegan:Connect(function(input,processed)
	if processed then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		mouseDown = true
		slide(input)
	end
end)

script.Parent.InputChanged:Connect(function(input,processed)
	if processed then return end
	if input.UserInputType == Enum.UserInputType.MouseMovement and mouseDown == true then
		slide(input)
	end
end)

script.Parent.InputEnded:Connect(function(input,processed)
	if processed then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		mouseDown = false
	end
end)

script.Parent.Parent.Reset.MouseButton1Click:Connect(function()
	replicated.Events.SetOrientation:FireServer(0)
end)

replicated.Server.CameraOrientation.Changed:Connect(function(val)
	script.Parent.Parent.Value.Text = math.round(val)
	script.Parent.Slider.Size = UDim2.new(0,((val+90)/180)*script.Parent.Size.X.Offset,1,0)
end)