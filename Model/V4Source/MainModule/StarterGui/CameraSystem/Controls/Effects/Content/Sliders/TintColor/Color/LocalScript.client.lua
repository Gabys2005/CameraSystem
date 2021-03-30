local uis = game:GetService("UserInputService")
local replicated = game.ReplicatedStorage.CameraSystem

local mouseDown = false
local mouseDownSaturation = false
local mouseDownDarkness = false

function getColor(percentage, ColorKeyPoints)
	if (percentage < 0) or (percentage>1) then
		--error'getColor percentage out of bounds!'
		warn'getColor got out of bounds percentage (less than 0 or greater than 1'
	end

	local closestToLeft = ColorKeyPoints[1]
	local closestToRight = ColorKeyPoints[#ColorKeyPoints]
	local LocalPercentage = .5
	local color = closestToLeft.Value

	-- This loop can probably be improved by doing something like a Binary search instead
	-- This should work fine though
	for i=1,#ColorKeyPoints-1 do
		if (ColorKeyPoints[i].Time <= percentage) and (ColorKeyPoints[i+1].Time >= percentage) then
			closestToLeft = ColorKeyPoints[i]
			closestToRight = ColorKeyPoints[i+1]
			LocalPercentage = (percentage-closestToLeft.Time)/(closestToRight.Time-closestToLeft.Time)
			color = closestToLeft.Value:lerp(closestToRight.Value,LocalPercentage)
			return color
		end
	end
	warn('Color not found!')
	return color
end

local function sendColor()
	local colorScalePos = script.Parent.Slider.Position.X.Offset/script.Parent.Size.X.Offset
	local saturationScalePos = script.Parent.Parent.Saturation.Slider.Position.X.Offset/script.Parent.Parent.Saturation.Size.X.Offset
	local darknessScalePos = script.Parent.Parent.Darkness.Slider.Position.X.Offset/script.Parent.Parent.Darkness.Size.X.Offset
	local hue = getColor(colorScalePos,script.Parent.UIGradient.Color.Keypoints):ToHSV()
	local _,saturation = getColor(saturationScalePos,script.Parent.Parent.Saturation.UIGradient.Color.Keypoints):ToHSV()
	local _,_,value  = getColor(darknessScalePos,script.Parent.Parent.Darkness.UIGradient.Color.Keypoints):ToHSV()
	replicated.Events.SetTintColor:FireServer(Color3.fromHSV(hue,saturation,value),hue,saturation,value)
end

local function slide(input)
	local position = input.Position.X
	local sliderPos = position - script.Parent.AbsolutePosition.X
	script.Parent.Slider.Position = UDim2.new(0,sliderPos,0,0)
	local scalePos = script.Parent.Slider.Position.X.Offset/script.Parent.Size.X.Offset
	local color = getColor(scalePos, script.Parent.UIGradient.Color.Keypoints)
	local hue, saturation, value = color:ToHSV()
	script.Parent.Parent.Saturation.UIGradient.Color = ColorSequence.new(Color3.fromHSV(hue,0,value), Color3.fromHSV(hue,1,value))
	sendColor()
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

-- Saturation
local function slideSaturation(input)
	local position = input.Position.X
	local sliderPos = position - script.Parent.Parent.Saturation.AbsolutePosition.X
	script.Parent.Parent.Saturation.Slider.Position = UDim2.new(0,sliderPos,0,0)
	--local scalePos = script.Parent.Parent.Saturation.Slider.Position.X.Offset/script.Parent.Parent.Saturation.Size.X.Offset
	--local color = getColor(scalePos, script.Parent.Parent.Saturation.UIGradient.Color.Keypoints)
	--local hue, saturation, value = color:ToHSV()
	--script.Parent.Parent.Saturation.UIGradient.Color = ColorSequence.new(Color3.fromHSV(hue,0,value), Color3.fromHSV(hue,1,value))
	sendColor()
end

script.Parent.Parent.Saturation.InputBegan:Connect(function(input,processed)
	if processed then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		mouseDownSaturation = true
		slideSaturation(input)
	end
end)

script.Parent.Parent.Saturation.InputChanged:Connect(function(input,processed)
	if processed then return end
	if input.UserInputType == Enum.UserInputType.MouseMovement and mouseDownSaturation == true then
		slideSaturation(input)
	end
end)

script.Parent.Parent.Saturation.InputEnded:Connect(function(input,processed)
	if processed then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		mouseDownSaturation = false
	end
end)

-- Value / Darkness
local function slideDarkness(input)
	local position = input.Position.X
	local sliderPos = position - script.Parent.Parent.Darkness.AbsolutePosition.X
	script.Parent.Parent.Darkness.Slider.Position = UDim2.new(0,sliderPos,0,0)
	--local scalePos = script.Parent.Parent.Saturation.Slider.Position.X.Offset/script.Parent.Parent.Saturation.Size.X.Offset
	--local color = getColor(scalePos, script.Parent.Parent.Saturation.UIGradient.Color.Keypoints)
	--local hue, saturation, value = color:ToHSV()
	--script.Parent.Parent.Saturation.UIGradient.Color = ColorSequence.new(Color3.fromHSV(hue,0,value), Color3.fromHSV(hue,1,value))
	sendColor()
end

script.Parent.Parent.Darkness.InputBegan:Connect(function(input,processed)
	if processed then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		mouseDownDarkness = true
		slideDarkness(input)
	end
end)

script.Parent.Parent.Darkness.InputChanged:Connect(function(input,processed)
	if processed then return end
	if input.UserInputType == Enum.UserInputType.MouseMovement and mouseDownDarkness == true then
		slideDarkness(input)
	end
end)

script.Parent.Parent.Darkness.InputEnded:Connect(function(input,processed)
	if processed then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		mouseDownDarkness = false
	end
end)

script.Parent.Parent.Reset.MouseButton1Click:Connect(function()
	replicated.Events.SetTintColor:FireServer(Color3.fromRGB(255,255,255),0,0,0)
end)

--local roundDecimals = function(num, places)

--	places = math.pow(10, places or 0)
--	num = num * places

--	if num >= 0 then 
--		num = math.floor(num + 0.5) 
--	else 
--		num = math.ceil(num - 0.5) 
--	end

--	return num / places

--end

replicated.Server.TintColor.Changed:Connect(function(val)
	script.Parent.Parent.Value.BackgroundColor3 = val
	--local hue = replicated.Server.TintColorValues.Hue.Value
	--local saturation = replicated.Server.TintColorValues.Saturation.Value
	--local value = replicated.Server.TintColorValues.Value.Value
	--script.Parent.Slider.Position = UDim2.new(0,(1-hue)*190,0,0)
end)