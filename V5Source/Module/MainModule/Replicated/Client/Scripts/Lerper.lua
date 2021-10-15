local lerper = {}
local run = game:GetService("RunService")
local utils = require(script.Parent.Utils)

export type LerperParams = {
    LerpTime: number,
    Start: CFrame,
    End: CFrame
}

function lerper.new(params:LerperParams)
    local lerp = {
        startTime = tick(),
        endTime = tick() + params.LerpTime,
        value = {
            CFrame = params.Start,
            Position = params.Start.Position,
            Rotation = utils:CFrameToRotation(params.Start)
        },
        ended = false
    }

    lerp.connection = run.RenderStepped:Connect(function()
        if tick() > lerp.endTime then
            lerp.connection:Disconnect()
            lerp.ended = true
        end
        local progress = utils:Map(tick(),lerp.startTime,lerp.endTime,0,1)
        local cf = params.Start:Lerp(params.End,progress)
        lerp.value = {
            CFrame = cf,
            Position = cf.Position,
            Rotation = utils:CFrameToRotation(cf)
        }
    end)

    return lerp
end

return lerper