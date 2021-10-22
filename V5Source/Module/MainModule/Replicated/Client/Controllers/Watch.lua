--// Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local run = game:GetService("RunService")

--// Variables
local replicated = replicatedStorage:WaitForChild("CameraSystem")
local topbarPlusReference = replicatedStorage:FindFirstChild("TopbarPlusReference")
local iconModule = replicated.Client.Dependencies.TopbarPlus
local data = require(replicated.Data)
local cameraInstance = workspace.CurrentCamera

--// Functions
local function getFocusPosition()
	if data.Shared.Focus.Instance then
		if data.Shared.Focus.Type == "Part" then
			return data.Shared.Focus.Instance.Position
		elseif data.Shared.Focus.Type == "Player" then
			return data.Shared.Focus.Instance.Position + Vector3.new(0, 2.5, 0)
		end
	end
	return Vector3.new()
end

local function getAutoFov(focusPosition: Vector3)
	local distance = (focusPosition - data.Shared.CameraData.Position).magnitude
	local fov = 48 / (1 / 10 * distance)
	return fov
end

local function watchLoop()
	-- For some reason sometimes CameraType doesn't change if you only change it once
	if cameraInstance.CameraType ~= Enum.CameraType.Scriptable then
		cameraInstance.CameraType = Enum.CameraType.Scriptable
	end
	local finalCFrame = data.Shared.CameraData.CFrame
	if data.Shared.Focus.Instance then -- If focusing on anything
		local focusPosition = getFocusPosition()
		finalCFrame = CFrame.lookAt(data.Shared.CameraData.Position, focusPosition)
		if data.Shared.Settings.AutoFov then
			cameraInstance.FieldOfView = getAutoFov(focusPosition)
		else
			cameraInstance.FieldOfView = data.Local.LerpedValues.Fov
		end
	end
	cameraInstance.CFrame = finalCFrame
end

--======= Actual code =======--
if topbarPlusReference then
	iconModule = topbarPlusReference.Value
end
local Icon = require(iconModule)
local watchButton = Icon.new():setLabel("Watch"):setMid():setLabel("Exit", "selected"):setSize(100, 32)
watchButton.selected:Connect(function()
	run:BindToRenderStep("CameraSystemWatchLoop", Enum.RenderPriority.Camera.Value - 1, watchLoop)
	data.Local.Watching = true
end)
watchButton.deselected:Connect(function()
	run:UnbindFromRenderStep("CameraSystemWatchLoop")
	cameraInstance.CameraType = Enum.CameraType.Custom
	data.Local.Watching = false
	cameraInstance.FieldOfView = 70
end)

--======= Exported =======--
local controller = {}

function controller:Watch()
	watchButton:select()
end

function controller:Unwatch()
	watchButton:deselect()
end

return controller
