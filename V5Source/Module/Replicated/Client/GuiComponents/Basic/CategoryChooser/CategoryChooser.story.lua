--!strict
return function(target)
	local CategoryChooser = require(script.Parent)
	local frames = {}
	for i = 1, 3 do
		local frame = Instance.new("Frame")
		frame.Size = UDim2.fromScale(1, 1)
		frame.BackgroundColor3 = Color3.fromHSV(math.random(), 1, 1)

		local textLabel = Instance.new("TextLabel")
		textLabel.Size = UDim2.fromScale(1, 1)
		textLabel.BackgroundTransparency = 1
		textLabel.Text = tostring(i)
		textLabel.Font = Enum.Font.GothamBlack
		textLabel.TextScaled = true
		textLabel.Parent = frame

		table.insert(frames, frame)
	end

	local chooser = CategoryChooser.new({
		Categories = {
			{
				Name = "Category 1",
				Instance = frames[1],
			},
			{
				Name = "Category 2",
				Instance = frames[2],
			},
			{
				Name = "Category 3",
				Instance = frames[3],
			},
		},
	})
	chooser.Instance.Parent = target

	return function()
		chooser:Destroy()
	end
end
