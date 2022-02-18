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