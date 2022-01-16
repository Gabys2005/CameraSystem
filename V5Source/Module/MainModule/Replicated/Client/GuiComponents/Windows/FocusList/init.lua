local points = workspace:FindFirstChild("CameraSystem"):WaitForChild("FocusPoints")
local button = require(script.Parent.Parent.Basic.RoundedButton)
local replicated = game:GetService("ReplicatedStorage"):WaitForChild("CameraSystem")
local smoothGrid = require(script.Parent.Parent.Parent.Scripts.SmoothGrid)

return function()
	local copy = script.Frame:Clone()
	for i, v in pairs(points:GetChildren()) do
		local button = button(v.Name)
		button.MouseButton1Click:Connect(function()
			if v:IsA("BasePart") then
				replicated.Events.ChangeFocus:FireServer(v)
			else
				replicated.Events.ChangeFocus:FireServer(v.Value)
			end
		end)
		button.Parent = copy
	end
	smoothGrid(copy, copy.UIGridLayout)
	return copy
end
