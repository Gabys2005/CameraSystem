# Keybinds

In the Settings script you can customise your keybinds. To enable them in game, go to the local settings and toggle `Keybinds` on.

## Keybind structure

The basic keybind structure is `{Keys = {KEYS_TO_ACTIVATE}, Action = {ACTION}}`

### Keys
`KEYS_TO_ACTIVATE` is a table of keys that need to be pressed down for the keybind to activate, for example:

* `Keys = {Enum.KeyCode.X}` if you want the keybind to activate when X is pressed
* `Keys = {Enum.KeyCode.LeftShift,Enum.KeyCode.One}` if you want the keybind to activate when Shift is pressed down and you press 1

For a full list of keys you can input, check out the [Developer wiki page](https://developer.roblox.com/en-us/api-reference/enum/KeyCode)

### Actions
`ACTION` is a table that tells the system what should happen when the keys are pressed, here's a full list of actions:

* `{"Fov", FOV, TIME}` to change the fov, for example `{"Fov", 120, 6}` to change the fov to 120 over 6 seconds
* `{"Blackout", BOOL?}` to toggle the blackout, for example `{"Blackout", true}` to enable it and `{"Blackout", false}` to disable it. If the true or false isn't specified, then the keybind will work as a toggle.
* `{"Bars", BOOL?"}` to toggle the bars. Same as above.
* `{"Transition", TRANSITION_NAME}` to change the transition type, currently `TRANSITION_NAME` can only be `None`, `Black` or `White`. For example `{"Transition", "Black"}` to change the transition to black.
* `{"TransitionSpeed", SPEED"}` to change the transition speed, `SPEED` is a number that represents the % of the normal speed, so `{"TransitionSpeed", 100}` for normal speed, `{"TransitionSpeed", 50}` for half the speed (50%), etc.
* `{"Shake, INTENSITY}` to change the intensity of the Shake effect, set to 0 to disable. For example `{"Shake", 5}` to set the shaking to intensity 5.
* `{"Blur", BLUR, TIME}` to change the blur. Same as FOV.
* `{"Saturation", SATURATION, TIME}` to change the saturation. Same as FOV. Saturation = -1 means the image will be black and white
* `{"Tilt", TILT, TIME}` to change the tilt. Same as FOV. Tilt = 0 means no tilt.
* `{"Camera", CAMERA_TYPE, CAMERA_NAME}` to change the camera, for example `{"Camera", "Static", "TEST"}` will change the camera to a static one named `TEST`

!!! example
    By default, the system comes with those keybinds:
    ```lua
    {Keys = {Enum.KeyCode.X}, Action = {"Fov",30,5}};
    {Keys = {Enum.KeyCode.C}, Action = {"Fov",120,5}};
    {Keys = {Enum.KeyCode.V}, Action = {"Camera","Static","Updating"}};
    ```
    This means that:

    * When X is pressed, the fov will change to 30 over 5 seconds
    * When C is pressed, the fov will change to 120 over 5 seconds
    * When V is pressed, the camera will change to the one named `Updating`