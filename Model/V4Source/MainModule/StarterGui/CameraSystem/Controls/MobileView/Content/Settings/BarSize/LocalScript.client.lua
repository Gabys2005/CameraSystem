local holdingDown = false
local replicated = game:GetService("ReplicatedStorage").CameraSystem

local function update(input)
	local position = input.Position.X
	local sliderPos = position - script.Parent.AbsolutePosition.X
	script.Parent.Frame.Size = UDim2.new(0,sliderPos,1,0)
	local scalePos = script.Parent.Frame.Size.X.Offset/script.Parent.AbsoluteSize.X
	local barSize = scalePos * 50
	replicated.Events.SetBarSize:FireServer(barSize)
end

script.Parent.InputBegan:Connect(function(input)
	if input.UserInputState == Enum.UserInputState.Begin and input.UserInputType == Enum.UserInputType.Touch then
		holdingDown = true
		update(input)
	end
end)

script.Parent.InputBegan:Connect(function(input)
	if input.UserInputState == Enum.UserInputState.End and input.UserInputType == Enum.UserInputType.Touch then
		holdingDown = false
	end
end)

script.Parent.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch and holdingDown then
		update(input)
	end
end)

local roundDecimals = function(num, places)
	places = math.pow(10, places or 0)
	num = num * places
	if num >= 0 then 
		num = math.floor(num + 0.5) 
	else 
		num = math.ceil(num - 0.5) 
	end
	return num / places
end

replicated.Server.BarSize.Changed:Connect(function(val)
	script.Parent.Parent.BarSizeInfo.Value.Text = math.round(val) .. "%"
	script.Parent.Frame.Size = UDim2.new(0,(val/50)*script.Parent.AbsoluteSize.X,1,0)
end)

script.Parent.Parent.BarSizeInfo.TextButton.MouseButton1Click:Connect(function()
	replicated.Events.SetBarSize:FireServer(20)
end)

script.Parent.Parent.BarSizeInfo.Value.Text = math.round(replicated.Server.BarSize.Value) .. "%"
script.Parent.Frame.Size = UDim2.new(0,(replicated.Server.BarSize.Value/50)*script.Parent.AbsoluteSize.X,1,0)