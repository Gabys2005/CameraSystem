--// Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local run = game:GetService("RunService")
local lighting = game:GetService("Lighting")
local players = game:GetService("Players")

--// Variables
local replicated = replicatedStorage:WaitForChild("CameraSystem")
-- local topbarPlusReference = replicatedStorage:FindFirstChild("TopbarPlusReference")
local iconModule = replicated.Client.Dependencies.TopbarPlus
local data = require(replicated.Data)
local dataEvent = require(script.Parent.Parent.Scripts.UpdateData)
local cameraInstance = workspace.CurrentCamera
local utils = require(script.Parent.Parent.Scripts.Utils)
local playerGui = players.LocalPlayer.PlayerGui
local mainGui = playerGui.CameraSystemMain
local CameraShaker = require(script.Parent.Parent.Dependencies.CameraShaker)
local shakeCFGlobal = CFrame.new()
local previousShake
local api = require(workspace.CameraSystem.Api)
local controller = {
	IsWatching = false,
}
local other = require(script.Parent.Parent.Scripts.Other)
local previousFocus = {
	instance = nil,
	position = Vector3.new(0, 2.5, 0),
}

--// Functions
local function getFocusPosition()
	if data.Shared.Focus.Instance then
		local ins = data.Shared.Focus.Instance
		if data.Shared.Focus.Type == "Part" then
			previousFocus.instance = nil
			return ins.Position
		elseif data.Shared.Focus.Type == "Player" then
			if previousFocus.instance ~= ins then
				previousFocus.instance = ins
				local humanoid = ins.Parent
				local rootPart = humanoid.HumanoidRootPart
				local head = humanoid.Head
				local distance = (rootPart.Position - head.Position).Magnitude
				previousFocus.position = Vector3.new(0, distance, 0)
			end
			return ins.Position + previousFocus.position
		end
	end
	return Vector3.new()
end

local function getAutoFov(focusPosition: Vector3)
	local distance = (focusPosition - data.Shared.CameraData.Position).magnitude
	local fov = 48 / (1 / 10 * distance)
	return fov
end

local function setShakeCF(shakeCF: CFrame)
	shakeCFGlobal = shakeCF
end

local camShake = CameraShaker.new(Enum.RenderPriority.Camera.Value + 1, setShakeCF)

local function watchLoop()
	-- For some reason sometimes CameraType doesn't change if you only change it once
	if cameraInstance.CameraType ~= Enum.CameraType.Scriptable then
		cameraInstance.CameraType = Enum.CameraType.Scriptable
	end
	local finalCFrame = data.Shared.CameraData.CFrame
	local focusInstance = data.Shared.Focus.Instance
	if
		focusInstance
		and data.Shared.CurrentCamera.Type ~= "Drones"
		and (
			data.Shared.CurrentCamera.Type == "Default"
			or not data.Shared.CurrentCamera.Model:GetAttribute("DisableFocus")
		)
	then -- If focusing on anything
		local focusPosition = getFocusPosition()
		if data.Shared.Settings.SmoothFocus then
			local spr = data.Local.Springs.Focus
			finalCFrame = CFrame.new(data.Shared.CameraData.Position)
				* CFrame.fromOrientation(math.rad(spr.Position.X), math.rad(spr.Position.Y), math.rad(spr.Position.Z))
		else
			finalCFrame = CFrame.lookAt(data.Shared.CameraData.Position, focusPosition)
		end
	elseif not focusInstance then
		previousFocus.instance = nil
	end
	finalCFrame = finalCFrame * CFrame.fromOrientation(0, 0, math.rad(data.Local.LerpedValues.Tilt)) * shakeCFGlobal
	cameraInstance.CFrame = finalCFrame
end

local function fovLoop()
	if data.Local.Watching or data.Local.ControllingDrone then
		if
			data.Shared.Settings.AutoFov
			and data.Shared.Focus.Instance
			and data.Shared.CurrentCamera.Type ~= "Drones"
		then
			cameraInstance.FieldOfView = getAutoFov(getFocusPosition())
		else
			cameraInstance.FieldOfView = data.Local.LerpedValues.Fov
		end
	end
end

--======= Actual code =======--
if replicatedStorage:FindFirstChild("TopbarPlus") then
	iconModule = replicatedStorage:FindFirstChild("TopbarPlus")
end
local Icon = require(iconModule)
local watchButton =
	Icon.new():setLabel("Watch"):setLabel("Exit", "selected"):setSize(100, 32):setName("CameraSystemWatch")
local watchButtonPosition = data.Local.Settings.WatchButtonPosition
if watchButtonPosition == "Center" then
	watchButton:setMid()
elseif watchButtonPosition == "Left" then
	watchButton:setLeft()
elseif watchButtonPosition == "Right" then
	watchButton:setRight()
end

run:BindToRenderStep("CameraSystemFovLoop", Enum.RenderPriority.Camera.Value - 2, fovLoop)

dataEvent:onChange("Shared.Effects.Shake", function(newValue)
	if previousShake then
		previousShake:StartFadeOut(0)
	end
	previousShake = camShake:StartShake(newValue, newValue)
end)

watchButton.selected:Connect(function()
	run:UnbindFromRenderStep("CameraSystemWatchLoop")
	run:BindToRenderStep("CameraSystemWatchLoop", Enum.RenderPriority.Camera.Value - 1, watchLoop)
	data.Local.Watching = true
	lighting.CameraSystemBlur.Enabled = true
	lighting.CameraSystemColorCorrection.Enabled = true
	mainGui.Enabled = true
	camShake:Start()
	for _, v in pairs(data.Local.Settings.ToggleGui) do
		if playerGui:FindFirstChild(v) then
			playerGui[v].Enabled = true
		end
	end
	api.StartedWatching:Fire()
	controller.IsWatching = true
	other:updateDroneVisibility()
end)

watchButton.deselected:Connect(function()
	run:UnbindFromRenderStep("CameraSystemWatchLoop")
	cameraInstance.CameraType = Enum.CameraType.Custom
	data.Local.Watching = false
	cameraInstance.FieldOfView = 70
	lighting.CameraSystemBlur.Enabled = false
	lighting.CameraSystemColorCorrection.Enabled = false
	mainGui.Enabled = false
	camShake:Stop()
	for _, v in pairs(data.Local.Settings.ToggleGui) do
		if playerGui:FindFirstChild(v) then
			playerGui[v].Enabled = false
		end
	end
	api.StoppedWatching:Fire()
	controller.IsWatching = false
	other:updateDroneVisibility()
end)

run.RenderStepped:Connect(function()
	if data.Shared.Focus.Instance then
		data.Local.Springs.Focus.Target =
			utils:CFrameToRotation(CFrame.lookAt(data.Shared.CameraData.Position, getFocusPosition())) -- TODO find a better way to do that
	end
end)

--======= Exported =======--

function controller:Watch()
	watchButton:select()
end

function controller:Lock()
	watchButton:lock()
end

function controller:Unwatch()
	watchButton:deselect()
end

function controller:Unlock()
	watchButton:unlock()
end

return controller
