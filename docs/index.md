# Installation

## Downloading and inserting the model

Installing the Camera System is very simple. Here are the steps:

-   Get the model on Roblox from [this](https://www.roblox.com/library/7734733797/Cameras-v5) link
-   Insert it into **Workspace**
-   Change the settings

## Settings

-   `GuiOwners` - This setting tells the system who should have access to the control panel. If you want to add more people then do it like `{"Username1","Username2"}`
-   `Theme` - The color theme of the control panel, either `Light` or `Dark`
-   `AccelerateStart` - If set to `true`, moving cameras will start slow and speed up
-   `DecelerateEnd` - If set to `true`, moving cameras will start slowing down at the end of their path
-   `ToggleGui` - What `ScreenGui`s should be toggled when someone presses the Watch button
-   `WatchButtonPosition` - Where the button should be positioned on the topbar, either `Left`, `Center` or `Right`
-   `Keybinds` - Check out the Keybinds section for an explanation
-   `BarOffsets` - This setting will move the bars down by X pixels for specified people, this is mainly for streamers to keep the bars even
-   `BeforeLoad` - This function will run before the clients load, useful for adding cameras by other scripts etc.