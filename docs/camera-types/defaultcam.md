# Default Camera

This camera will be selected when the game starts, and can't be selected after selecting a different one. By default it's color is pink. It's name has to be `Default` and it has to be directly in the `Cameras` folder.

You can get the position of the default camera through the API by using the `GetDefaultCamPosition()` method like this:
```lua
local api = require(workspace.CameraSystem:WaitForChild("Api"))
local defaultCamPosition = api:GetDefaultCamPosition()
```