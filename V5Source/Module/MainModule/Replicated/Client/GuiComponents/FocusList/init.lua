local points = workspace:FindFirstChild("CameraSystem"):WaitForChild("FocusPoints")
local button = require(script.Parent.RoundedButton)
local replicated = game:GetService("ReplicatedStorage"):WaitForChild("CameraSystem")
local smoothGrid = require(script.Parent.Parent.Scripts.SmoothGrid)

return function()
	local copy = script.Frame:Clone()
	for i, v in pairs(points:GetChildren()) do
		local button = button(v.Name)
		button.MouseButton1Click:Connect(function()
			replicated.Events.ChangeFocus:FireServer(v)
		end)
		button.Parent = copy
	end
	smoothGrid(copy, copy.UIGridLayout)
	return copy
end
