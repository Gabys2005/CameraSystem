local dataEvent = require(script.Parent.Parent.Scripts.UpdateData)
local data = require(script.Parent.Parent.Parent.Data)
local utils = require(script.Parent.Parent.Scripts.Utils)
local run = game:GetService("RunService")
local currentConnection
local lastChangeTime = tick()
local lerper = require(script.Parent.Parent.Scripts.Lerper)

local function update(pos,rot)
    if not pos then
        pos = data.Shared.CurrentCamera.Model.Position
    end
    if not rot then
        rot = data.Shared.CurrentCamera.Model.Orientation
    end
    data.Shared.CameraData.Position = pos
    data.Shared.CameraData.Rotation = rot
    data.Shared.CameraData.CFrame = CFrame.new(pos) * CFrame.Angles(math.rad(rot.X),math.rad(rot.Y),math.rad(rot.Z))
end

dataEvent:onChange("Shared.CurrentCamera", function(currentCamera)
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
        update(firstCam.Position,firstCam.Orientation)
        for i = 2, cameraCount do -- First point gets skipped while lerping
            if lastChangeTime == currentChangeTime then
                local lerp = lerper.new({LerpTime = 5, Start = currentCamera.Model[i-1].CFrame, End = currentCamera.Model[i].CFrame})
                while not lerp.ended do
                    update(lerp.value.Position, lerp.value.Rotation)
                    task.wait()
                end
            end
        end
    end
end)

return nil