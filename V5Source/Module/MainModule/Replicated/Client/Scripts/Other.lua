-- This generated buttons for the camera switcher guis, put it in a separete
-- module because both Static and Moving cameras use it
-- TODO move to a completely separate module?
local utils = require(script.Parent.Utils)
local button = require(script.Parent.Parent.GuiComponents.RoundedButton)
local smoothGrid = require(script.Parent.SmoothGrid)
local other = {}

function other:generateButtonsForFolder(folder: Folder, parent: GuiObject, camType: string)
	local frame = utils:NewInstance("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		AutomaticSize = Enum.AutomaticSize.Y,
		Parent = parent,
	})
	local grid = utils:NewInstance("UIGridLayout", {
		CellSize = UDim2.fromOffset(100, 30),
		Parent = frame,
	})
	for i, v in pairs(folder:GetChildren()) do
		local button = button(v.Name)
		button.Parent = frame
		button.MouseButton1Click:Connect(function()
			script.Parent.Parent.Parent.Events.ChangeCam:FireServer(camType, v:GetAttribute("ID"))
		end)
	end
	smoothGrid(frame, grid)
end

return other
