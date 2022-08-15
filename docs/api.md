# API

!!! warning
    The api is **not** finished yet, a lot more stuff will be added to it in the future. Current functions shouldn't change however.

## Using the API

To use the API, simply require the `Api` module inserted into the main CameraSystem folder:
```lua
local api = require(workspace.CameraSystem:WaitForChild("Api"))
```

## Api documentation

!!! info
    Shared apis can be accessed from local and server scripts. Server-only and Client-only apis can only be accessed from the server or client

## Shared

### Methods
---

#### GetCamsById()
Used to get **all** cameras, indexed by their id
```lua
local cams = api:GetCamsById()
print(cams)
```

---

#### GetCamIdByName(camType: string, camName: string)
Used to get a camera's id by it's name
```lua
local camId = api:GetCamIdByName("Static", "Test")
```

---

#### GetCamById(camType: string, camId: number)
Used to get the camera instance (part or model) by id
```lua
local camPart = api:GetCamById("Static", "Test")
```

---

#### GetDefaultCamPosition()
Used to get the position of the default camera. Returns a Vector3
```lua
local camPos = api:GetDefaultCamPosition()
```

## Server-only

### Methods
---

#### ChangeCam(camType: string, camIdOrName: number|string)
Used to change the current camera
```lua
api:ChangeCam("Static", "Test")
-- Or
api:ChangeCam("Static", 1)
```

#### GetCurrentCamera()
Used to get basic information about the current camera
```lua
print(api:GetCurrentCamera()) -- { Id = 1, Model = <Model>, Type = "Static" }
```

---

#### Focus(whoToFocusOn: BasePart|string|nil)
Used to change the focus. If `whoToFocusOn` is a part, then it'll just focus on it. If it's a string, then it'll try to find a player whose name starts with it. If it's nil, then it will unfocus.
```lua
api:Focus(workspace.Part) -- focus on a part
api:Focus("gabys2005") -- focus on a player
api:Focus(nil) -- unfocus
```

---

#### GetFocus()
Returns the current focus point
```lua
local focus = api:GetFocus()
print(focus) -- { Type = "Player", Instance = HumanoidRootPart } OR { Type = "Part", Instance = Part }
```

---

#### ChangeFov(fov: number, time: number?)
Change the fov. By default time is 0.1
```lua
api:ChangeFov(120) -- Change focus to 120 in 0.1 seconds
api:ChangeFov(30,5) -- Change focus to 30 over 5 seconds
```

---

#### ChangeAutoFov(enable: boolean)
Enable or disable auto fov
```lua
api:ChangeAutoFov(true) -- enable
api:ChangeAutoFov(false) -- disable
```

---

#### ChangeSmoothFocus(enable: boolean)
Enable or disable smooth focus
```lua
api:ChangeSmoothFocus(true) -- enable
api:ChangeSmoothFocus(false) -- disable
```

---

#### ChangeBlur(blur: number, time: number?)
Change the blur. By default time is 0.1
```lua
api:ChangeBlur(20) -- change the blur to 20
api:ChangeBlur(0, 5) -- change the blur to 0 over 5 seconds
```

---

#### ChangeSaturation(saturation: number, time: number?)
Change the saturation. By default time is 0.1
```lua
api:ChangeSaturation(-1) -- change the saturation to -1
api:ChangeSaturation(1, 3) -- change the saturationt to 1 over 3 seconds
```

---

#### ChangeTilt(tilt: number, time: number?)
Change the tilt. By default time is 0.1
```lua
api:ChangeTilt(45) -- change the tilt to 45
api:ChangeTilt(-45, 6) -- change the tilt to -45 over 6 seconds
```

---

#### ChangeBlackout(enabled: boolean?)
Change the blackout. If enabled is not defined then blackout will be toggled.
```lua
api:ChangeBlackout(true) -- enable blackout
api:ChangeBlackout(false) -- disable blackout
api:ChangeBlackout() -- toggle blackout
```

---

#### ChangeBarsEnabled(enabled: boolean?)
Change the bars. If enabled is not defined then blackout will be toggled.
```lua
api:ChangeBarsEnabled(true) -- enable bars
api:ChangeBarsEnabled(false) -- disable bars
api:ChangeBarsEnabled() -- toggle bars
```

---

#### ChangeBarSize(size: number, time: number?)
Change the bar size. By default time is 0.1
```lua
api:ChangeBarSize(10) -- change bar size to 10%
api:ChangeBarSize(30, 5) -- change bar size to 30% over 5 seconds
```

---

#### ChangeTransition(name: string)
Change the transition type. `name` is either `None`, `Black` or `White`
```lua
api:ChangeTransition("Black")
```

---

#### ChangeTransitionSpeed(speed: number)
Change the transition speed. Speed is the % of the base speed, so speed = 50 means half the speed
```lua
api:ChangeTransitionSpeed(50)
```

---

#### ChangeShake(shake: number)
Change the shake intensity.
```lua
api:ChangeShake(5)
```

---

#### GetFov()
Returns the current FOV
```lua
print(api:GetFov()) -- { Value = 70, Time = 0.1 }
```

---

#### GetBlur()
Returns the current blur
```lua
print(api:GetBlur()) -- { Value = 0, Time = 0.1 }
```

---

#### GetSaturation()
Returns the current saturation
```lua
print(api:GetSaturation()) -- { Value = 0, Time = 0.1 }
```

---

#### GetTilt()
Returns the current tilt
```lua
print(api:GetTilt()) -- { Value = 0, Time = 0.1 }
```

---

#### GetBarsEnabled()
Returns a boolean indicating whether or not bars are enabled
```lua
print(api:GetBarsEnabled()) -- false
```

---

#### GetBarSize()
Returns the current bar size
```lua
print(api:GetBarSize()) -- 0
```

---

#### GetTransition()
Returns the current transition's name
```lua
print(api:GetTransition()) -- "Black"
```

---

#### GetTransitionSpeed()
Returns the current transition speed
```lua
print(api:GetTransitionSpeed()) -- 100
```

---

#### GetShake()
Returns the current shake intensity
```lua
print(api:GetShake()) -- 0
```

### Events
---

#### api.CameraChanged
Fired when the camera changes
```lua
api.CameraChanged:Connect(function(camType, camId)
    print("Camera changed to a " .. camType .. " camera with an id of " .. camId)
end)
```

---

#### api.FocusChanged
Fired when the focus changes
```lua
api.FocusChanged:Connect(function(focusData)
    print("Focus changed:", focusData)
end)
```

---

#### api.FovChanged
Fired when the fov changes
```lua
api.FovChanged:Connect(function(newFov, changeTime)
    print("Fov changed to:", newFov, "in", changeTime, "seconds")
end)
```

---


#### api.BlurChanged
Fired when the blur changes
```lua
api.BlurChanged:Connect(function(newBlur, changeTime)
    print("Blur changed to:", newBlur, "in", changeTime, "seconds")
end)
```

---

#### api.SaturationChanged
Fired when the saturation changes
```lua
api.SaturationChanged:Connect(function(newSaturation, changeTime)
    print("Saturation changed to:", newSaturation, "in", changeTime, "seconds")
end)
```

---

#### api.TiltChanged
Fired when the blur changes
```lua
api.TiltChanged:Connect(function(newTilt, changeTime)
    print("Tilt changed to:", newTilt, "in", changeTime, "seconds")
end)
```

---

#### api.BlackoutChanged
Fired when the blackout gets enabled or disabled
```lua
api.BlackoutChanged:Connect(function(isEnabled)
    print("Blackout is now", if isEnabled then "Enabled" else "Disabled")
end)
```

---

#### api.BarsEnabledChanged
Fired when the bars get enabled or disabled
```lua
api.BarsEnabledChanged:Connect(function(isEnabled)
    print("Bars are now", if isEnabled then "Enabled" else "Disabled")
end)
```

---

#### api.BarSizeChanged
Fired when the bar size changes
```lua
api.BarSizeChanged:Connect(function(newSize, changeTime)
    print("Bar size changed to:", newSize, "in", changeTime, "seconds")
end)
```

---

#### api.TransitionChanged
Fired when the transition type changes
```lua
api.TransitionChanged:Connect(function(transitionName)
    print("Bar size changed to:", transitionName)
end)
```

---

#### api.TransitionSpeedChanged
Fired when the transition speed changes
```lua
api.TransitionSpeedChanged:Connect(function(newSpeed)
    print("Transition speed changed to:", newSpeed)
end)
```

---

#### api.ShakeChanged
Fired when the shake intensity changes
```lua
api.ShakeChanged:Connect(function(newIntensity)
    print("Shake intensity changed to:", newIntensity)
end)
```

## Client-only

### Events
---

#### api.StartedWatching
Fired when the local player pressed the "Watch" button
```lua
api.StartedWatching:Connect(function()
    print("Player started watching")
end)
```

---

#### api.StoppedWatching
Fired when the local player stopped watching (unpressed the "Watch" button)
```lua
api.StoppedWatching:Connect(function()
    print("Player stopped watching")
end)
```