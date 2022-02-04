local ts = game:GetService("TweenService")
local data = require(script.Parent.Parent.Parent.Scripts.UpdateData)
local theme = require(script.Parent.Parent.Parent.Themes.Current)

script.Frame.Type.TextColor3 = theme.BaseText
script.Frame.Namer.TextColor3 = theme.BaseText
script.Frame.MoveProgress.TextColor3 = theme.BaseText
script.Frame.MoveProgressBar.BackgroundColor3 = theme.Base
script.Frame.MoveProgressBar.Move.BackgroundColor3 = theme.Highlighted

return function()
	local barTween
	local copy = script.Frame:Clone()
	local function update()
		local currentCameraData = data:get("Shared.CurrentCamera")
		copy.Type.Text = "Type: " .. currentCameraData.Type
		copy.Namer.Text = "Name: "
			.. if currentCameraData.Type == "Default" then "Default" else currentCameraData.Model.Name
		if barTween then
			barTween:Cancel()
			barTween = nil
		end
		if currentCameraData.Type == "Moving" then
			local cameraCount = #currentCameraData.Model:GetChildren()
			local totalTime = 0
			for i = 1, cameraCount - 1 do
				totalTime += currentCameraData.Model[i]:GetAttribute("Time")
			end
			copy.TimeProgress.Value = 0
			barTween = ts:Create(copy.TimeProgress, TweenInfo.new(totalTime, Enum.EasingStyle.Linear), { Value = 100 })
			barTween:Play()
		else
			copy.TimeProgress.Value = 100
		end
	end
	copy.TimeProgress.Changed:Connect(function(value)
		copy.MoveProgress.Text = "Move Progress: " .. math.floor(value) .. "%"
		copy.MoveProgressBar.Move.Position = UDim2.fromScale(value / 100, 0)
	end)
	update()
	data:onChange("Shared.CurrentCamera", update)
	return copy
end
