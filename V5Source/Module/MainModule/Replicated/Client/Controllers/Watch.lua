--// Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local run = game:GetService("RunService")

--// Variables
local replicated = replicatedStorage:WaitForChild("CameraSystem")
local topbarPlusReference = replicatedStorage:FindFirstChild("TopbarPlusReference")
local iconModule = replicated.Client.Dependencies.TopbarPlus
local data = require(replicated.Data)
local cameraInstance = workspace.CurrentCamera
local spring = data.Local.Springs.Focus
local utils = require(script.Parent.Parent.Scripts.Utils)

--// Functions
local function getFocusPosition()
	if data.Shared.Focus.Instance then
		if data.Shared.Focus.Type == "Part" then
			return data.Shared.Focus.Instance.Position
		elseif data.Shared.Focus.Type == "Player" then
			return data.Shared.Focus.Instance.Position + Vector3.new(0, 3, 0)
		end
	end
	return Vector3.new()
end

local function watchLoop()
	if cameraInstance.CameraType ~= Enum.CameraType.Scriptable then
		cameraInstance.CameraType = Enum.CameraType.Scriptable
	end
	local finalCFrame = data.Shared.CameraData.CFrame
	if data.Shared.Focus.Instance then
		if data.Local.Settings.UseSprings then
			spring.Target = utils:CFrameToRotation(CFrame.lookAt(data.Shared.CameraData.Position, getFocusPosition())) -- TODO find a better way to do that
			finalCFrame = CFrame.new(data.Shared.CameraData.Position)
				* CFrame.fromOrientation(
					math.rad(spring.Position.X),
					math.rad(spring.Position.Y),
					math.rad(spring.Position.Z)
				)
		else
			finalCFrame = CFrame.lookAt(data.Shared.CameraData.Position, getFocusPosition())
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
end)
watchButton.deselected:Connect(function()
	run:UnbindFromRenderStep("CameraSystemWatchLoop")
	cameraInstance.CameraType = Enum.CameraType.Custom
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
