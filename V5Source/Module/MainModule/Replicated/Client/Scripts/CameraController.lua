local controller = {}
local replicatedStorage = game:GetService("ReplicatedStorage")
local run = game:GetService("RunService")
local replicated = replicatedStorage:WaitForChild("CameraSystem")
local topbarPlusReference = replicatedStorage:FindFirstChild("TopbarPlusReference")
local iconModule = replicated.Client.Dependencies.TopbarPlus
local api = require(workspace:WaitForChild("CameraSystem"):WaitForChild("Api"))
local directData = require(replicated.Data)
local cameraInstance = workspace.CurrentCamera

local function controlLoop()
    local cameraType = directData.Shared.CurrentCamera.Type
	local cameraModel = directData.Shared.CurrentCamera.Model
	if cameraType == "Default" then
		directData.Shared.CameraData.Position = api:GetDefaultCamPosition().Position
	elseif cameraType == "Static" then
		directData.Shared.CameraData.Position = cameraModel.Position
		directData.Shared.CameraData.Rotation = cameraModel.Orientation
	end
end

local function watchLoop()
	local rot = directData.Shared.CameraData.Rotation
	directData.Shared.CameraData.CFrame = CFrame.new(directData.Shared.CameraData.Position) * CFrame.Angles(math.rad(rot.X),math.rad(rot.Y),math.rad(rot.Z))

	if cameraInstance.CameraType ~= Enum.CameraType.Scriptable then
		cameraInstance.CameraType = Enum.CameraType.Scriptable
	end
	cameraInstance.CFrame = directData.Shared.CameraData.CFrame
end

if topbarPlusReference then
	iconModule = topbarPlusReference.Value
end
local Icon = require(iconModule)
local watchButton = Icon.new():setLabel("Watch"):setMid():setLabel("Exit","selected"):setSize(100,32)
watchButton.selected:Connect(function()
	run:BindToRenderStep("CameraSystemWatchLoop", Enum.RenderPriority.Camera.Value - 1, watchLoop)
end)
watchButton.deselected:Connect(function()
	run:UnbindFromRenderStep("CameraSystemWatchLoop")
    cameraInstance.CameraType = Enum.CameraType.Custom
end)

run.Heartbeat:Connect(controlLoop)

function controller:Watch()
    watchButton:select()
end

function controller:Unwatch()
    watchButton:deselect()
end

return controller