--// Services
local run = game:GetService("RunService")

--// Variables
local dataEvent = require(script.Parent.Parent.Scripts.UpdateData)
local data = require(script.Parent.Parent.Parent.Data)
local currentConnection
local lastChangeTime = tick()
local lerper = require(script.Parent.Parent.Scripts.Lerper)
local bezier = require(script.Parent.Parent.Dependencies.Bezier)
local utils = require(script.Parent.Parent.Scripts.Utils)

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

--// Connections
dataEvent:onChange("Shared.CurrentCamera", function(currentCamera) -- TODO export all types in 1 script for easier use?
	local currentChangeTime = tick()
	lastChangeTime = currentChangeTime
	if currentConnection then
		currentConnection:Disconnect()
		currentConnection = nil
	end
	if currentCamera.Type == "Static" then
		update()
		if currentCamera.Model:GetAttribute("Update") then
			currentConnection = run.RenderStepped:Connect(function()
				update()
			end)
		end
	elseif currentCamera.Type == "Moving" then
		local cameraCount = #currentCamera.Model:GetChildren()
		local firstCam = currentCamera.Model["1"]
		update(firstCam.Position, firstCam.Orientation)
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
			while not lerp.ended do
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
					while not lerp.ended do
						update(lerp.value.Position, lerp.value.Rotation)
						task.wait()
					end
				end
			end
		end
	end
end)

return nil
