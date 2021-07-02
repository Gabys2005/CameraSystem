local holdingDown = false
local replicated = game:GetService("ReplicatedStorage").CameraSystem

local function update(input)
	local position = input.Position.X
	local sliderPos = position - script.Parent.AbsolutePosition.X
	script.Parent.Frame.Size = UDim2.new(0,sliderPos,1,0)
	local scalePos = script.Parent.Frame.Size.X.Offset/script.Parent.AbsoluteSize.X
	local blur = scalePos * 56
	replicated.Events.SetBlur:FireServer(blur)
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

replicated.Server.Blur.Changed:Connect(function(val)
	script.Parent.Parent.TextLabel.Text = "Blur: " .. math.round(val)
	script.Parent.Frame.Size = UDim2.new(0,(val/56)*script.Parent.AbsoluteSize.X,1,0)
end)

local val = replicated.Server.Blur.Value
script.Parent.Parent.TextLabel.Text = "Blur: " .. math.round(val)
script.Parent.Frame.Size = UDim2.new(0,(val/56)*script.Parent.AbsoluteSize.X,1,0)

--script.Parent.Parent.TextButton.MouseButton1Click:Connect(function()
--	replicated.Events.SetFov:FireServer(70)
--end)