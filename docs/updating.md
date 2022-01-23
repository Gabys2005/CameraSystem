# Updating from V4 to V5

!!! warning
    If you're not using V4 in your game, you don't need to do this

!!! info
    The updating process will be simplified once the plugin gets released

## Updating cameras

* Run code from [here](https://gist.github.com/Gabys2005/b0494a3b655e4620ae561821fa8ecf03) in the command bar (View > Command Bar)
* Insert V5
* Delete `Static` and `Moving` folders from V5
* Move those folders from V4 to V5
* Move the drones from V4 to V5 (make sure you insert the `SetupDrone` script into every drone)
* Move over the settings
* Delete V4

## Updating keybinds

* Change `Run` to `Action`
* Change `FOV` to `Fov`
* Change `ChangeCam` to `Camera`, additionally you don't need to use the `api:GetCamIdFromName()` thing, just insert the camera's name, for example `{"Camera", "Static", "Test"}`