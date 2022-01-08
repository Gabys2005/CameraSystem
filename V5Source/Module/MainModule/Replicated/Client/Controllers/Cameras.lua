--// Services
local run = game:GetService("RunService")
local ts = game:GetService("TweenService")
local players = game:GetService("Players")

--// Variables
local dataEvent = require(script.Parent.Parent.Scripts.UpdateData)
local data = require(script.Parent.Parent.Parent.Data)
local currentConnection
local lastChangeTime = tick()
local lerper = require(script.Parent.Parent.Scripts.Lerper)
local bezier = require(script.Parent.Parent.Dependencies.Bezier)
local utils = require(script.Parent.Parent.Scripts.Utils)
local playerGui = players.LocalPlayer.PlayerGui
local mainGui = playerGui.CameraSystemMain

--// Functions
local function update(pos: Vector3, rot: Vector3)
	if not pos then
		pos = data.Shared.CurrentCamera.Model.Position
	end
	if not rot then
		rot = data.Shared.CurrentCamera.Model.Orientation
	end
	data.Shared.CameraData.Position = pos
	data.Shared.CameraData.Rotation = rot
	data.Shared.CameraData.CFrame = CFrame.new(pos)
		* CFrame.fromOrientation(math.rad(rot.X), math.rad(rot.Y), math.rad(rot.Z))
end

local function resetSpringPosition()
	data.Local.Springs.Focus.Position = utils:CFrameToRotation(
		CFrame.lookAt(data.Shared.CameraData.Position, utils:getFocusPosition())
	)
end

local function hideTransition(transitionType)
	if transitionType == "Black" then
		ts
			:Create(
				mainGui.TransitionFrames.Black,
				TweenInfo.new(data.Shared.Settings.TransitionTimes.Black),
				{ BackgroundTransparency = 1 }
			)
			:Play()
	elseif transitionType == "White" then
		ts
			:Create(
				mainGui.TransitionFrames.White,
				TweenInfo.new(data.Shared.Settings.TransitionTimes.White),
				{ BackgroundTransparency = 1 }
			)
			:Play()
	end
end

--// Connections
dataEvent:onChange("Shared.CurrentCamera", function(currentCamera) -- TODO export all types in 1 script for easier use?
	local currentChangeTime = tick()
	lastChangeTime = currentChangeTime
	if currentConnection then
		currentConnection:Disconnect()
		currentConnection = nil
	end
	local transitionType = data.Shared.Settings.Transition
	if transitionType == "Black" then
		local transitionTime = data.Shared.Settings.TransitionTimes.Black
			* (data.Shared.Settings.TransitionTimes.Multiplier / 100)
		ts:Create(mainGui.TransitionFrames.Black, TweenInfo.new(transitionTime), { BackgroundTransparency = 0 }):Play()
		task.wait(transitionTime)
	elseif transitionType == "White" then
		local transitionTime = data.Shared.Settings.TransitionTimes.White
			* (data.Shared.Settings.TransitionTimes.Multiplier / 100)
		ts:Create(mainGui.TransitionFrames.White, TweenInfo.new(transitionTime), { BackgroundTransparency = 0 }):Play()
		task.wait(transitionTime)
	end
	if currentCamera.Type == "Static" then
		update()
		resetSpringPosition()
		hideTransition(transitionType)
		local cameraFov = currentCamera.Model:GetAttribute("Fov")
		if cameraFov then
			dataEvent:set("Shared.Effects.Fov", { Value = cameraFov, Time = data.Shared.Effects.Fov.Time })
			data.Local.LerpedValues.Fov = cameraFov
		end
		if currentCamera.Model:GetAttribute("Update") then
			currentConnection = run.RenderStepped:Connect(function()
				update()
			end)
		end
	elseif currentCamera.Type == "Drones" then
		resetSpringPosition()
		hideTransition(transitionType)
		currentConnection = run.RenderStepped:Connect(function()
			update(currentCamera.Model.CamPos.Position, currentCamera.Model.CamPos.Orientation)
		end)
	elseif currentCamera.Type == "Moving" then
		local cameraCount = #currentCamera.Model:GetChildren()
		local firstCam = currentCamera.Model["1"]
		update(firstCam.Position, firstCam.Orientation)
		resetSpringPosition()
		hideTransition(transitionType)
		if currentCamera.Model:GetAttribute("Bezier") then
			-- Bezier cameras
			local positionPoints = {}
			local rotationPoints = {}
			for i = 1, cameraCount do
				table.insert(positionPoints, currentCamera.Model[i].Position)
				table.insert(rotationPoints, currentCamera.Model[i].Orientation)
			end
			-- The bezier module only works on Vector3s so I have to use 2 of them
			local positionPath = bezier.new(table.unpack(positionPoints))
			local rotationPath = bezier.new(table.unpack(rotationPoints))
			local lerp = lerper.newbezier({
				LerpTime = currentCamera.Model:GetAttribute("Time") or 5,
				Start = currentCamera.Model["1"].CFrame,
				Accelerate = data.Local.Settings.AccelerateStart,
				Decelerate = data.Local.Settings.DecelerateEnd,
				PositionCurve = positionPath,
				RotationCurve = rotationPath,
			})
			local lastPointFov = currentCamera.Model[cameraCount]:GetAttribute("Fov")
			if lastPointFov then
				dataEvent:set("Shared.Effects.Fov", { Value = lastPointFov, Time = data.Shared.Effects.Fov.Time })
				lerper.data({
					LerpTime = currentCamera.Model:GetAttribute("Time") or 5,
					Setting = "Local.LerpedValues.Fov",
					Goal = lastPointFov,
				})
			end
			while not lerp.ended do
				if lastChangeTime ~= currentChangeTime then
					break
				end
				update(lerp.value.Position, lerp.value.Rotation)
				task.wait()
			end
		else
			-- Non bezier cameras
			for i = 2, cameraCount do -- First point gets skipped while lerping
				if lastChangeTime == currentChangeTime then
					local LerpSettings = {
						LerpTime = currentCamera.Model[i - 1]:GetAttribute("Time"),
						Start = currentCamera.Model[i - 1].CFrame,
						End = currentCamera.Model[i].CFrame,
						Accelerate = false,
						Decelerate = false,
					}

					local nextFov = {
						Fov = nil,
						Time = 0,
					}
					for z = i, cameraCount do
						nextFov.Time += currentCamera.Model[z - 1]:GetAttribute("Time")
						if currentCamera.Model[z]:GetAttribute("Fov") then
							nextFov.Fov = currentCamera.Model[z]:GetAttribute("Fov")
							break
						end
					end

					if
						cameraCount == 2
						and data.Local.Settings.AccelerateStart
						and data.Local.Settings.DecelerateEnd
					then
						LerpSettings.Accelerate = true
						LerpSettings.Decelerate = true
					elseif i == 2 and data.Local.Settings.AccelerateStart then
						LerpSettings.Accelerate = true
					elseif i == cameraCount and data.Local.Settings.DecelerateEnd then
						LerpSettings.Decelerate = true
					end

					local lerp = lerper.new(LerpSettings)

					if nextFov.Fov ~= nil then
						dataEvent:set(
							"Shared.Effects.Fov",
							{ Value = nextFov.Fov, Time = data.Shared.Effects.Fov.Time }
						)
						lerper.data({
							LerpTime = nextFov.Time,
							Setting = "Local.LerpedValues.Fov",
							Goal = nextFov.Fov,
						})
					end

					while not lerp.ended do
						if lastChangeTime ~= currentChangeTime then
							break
						end
						update(lerp.value.Position, lerp.value.Rotation)
						task.wait()
					end
				end
			end
		end
	end
end)

return nil
