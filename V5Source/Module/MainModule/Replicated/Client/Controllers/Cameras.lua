local dataEvent = require(script.Parent.Parent.Scripts.UpdateData)
local data = require(script.Parent.Parent.Parent.Data)

dataEvent:onChange("Shared.CurrentCamera", function(currentCamera)
    if currentCamera.Type == "Static" then
        local pos = currentCamera.Model.Position
        local rot = currentCamera.Model.Orientation
        data.Shared.CameraData.Position = pos
        data.Shared.CameraData.Rotation = rot
        data.Shared.CameraData.CFrame = CFrame.new(pos) * CFrame.Angles(math.rad(rot.X),math.rad(rot.Y),math.rad(rot.Z))
    end
end)

return nil