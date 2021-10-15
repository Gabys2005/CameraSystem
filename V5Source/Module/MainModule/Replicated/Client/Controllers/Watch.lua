local replicatedStorage = game:GetService("ReplicatedStorage")
local run = game:GetService("RunService")
local replicated = replicatedStorage:WaitForChild("CameraSystem")
local topbarPlusReference = replicatedStorage:FindFirstChild("TopbarPlusReference")
local iconModule = replicated.Client.Dependencies.TopbarPlus
local data = require(replicated.Data)
local cameraInstance = workspace.CurrentCamera

local function watchLoop()
    if cameraInstance.CameraType ~= Enum.CameraType.Scriptable then
        cameraInstance.CameraType = Enum.CameraType.Scriptable
    end
    cameraInstance.CFrame = data.Shared.CameraData.CFrame
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

local controller = {}

function controller:Watch()
    watchButton:select()
end

function controller:Unwatch()
    watchButton:deselect()
end

return controller