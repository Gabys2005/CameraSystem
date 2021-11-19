local theme = require(script.Parent.Parent.Parent.Themes.Current)
local data = require(script.Parent.Parent.Parent.Scripts.UpdateData)
local replicated = game:GetService("ReplicatedStorage"):WaitForChild("CameraSystem")
local ts = game:GetService("TweenService")

-- Apply theme
script.FocusBox.UsernameBox.BackgroundColor3 = theme.Base
script.FocusBox.Focus.BackgroundColor3 = theme.Base
script.FocusBox.StopFocus.BackgroundColor3 = theme.Base
script.FocusBox.UsernameBox.TextColor3 = theme.BaseText
script.FocusBox.Focus.TextColor3 = theme.BaseText
script.FocusBox.StopFocus.TextColor3 = theme.BaseText

return function()
	local copy = script.FocusBox:Clone()
	copy.Focus.MouseButton1Click:Connect(function()
		if copy.UsernameBox.Text ~= "" then
			replicated.Events.ChangeFocus:FireServer(copy.UsernameBox.Text)
		end
	end)
	copy.StopFocus.MouseButton1Click:Connect(function()
		replicated.Events.ChangeFocus:FireServer()
	end)
	data:onChange("Shared.Focus", function(newdata)
		if newdata.Type == "Part" then
			copy.UsernameBox.Text = newdata.Instance.Name
		elseif newdata.Type == "Player" then
			copy.UsernameBox.Text = newdata.Instance.Parent.Name
		end
		if newdata.Instance then
			ts:Create(copy.Focus, TweenInfo.new(0.3), { BackgroundColor3 = theme.Highlighted }):Play()
		else
			ts:Create(copy.Focus, TweenInfo.new(0.3), { BackgroundColor3 = theme.Base }):Play()
		end
	end)
	return copy
end
