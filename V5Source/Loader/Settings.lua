return {

	--// People that will be able to control the cameras, put in separate quotes, separated by commas,
	--// For example: { "gabys2005", "oxyo_rbx", "SomeoneElse" }
	GuiOwners = { "gabys2005" },

	--// The theme of the control guis, "Light" or "Dark"
	Theme = "Dark",

	--// Set to true if moving cameras should speed up at the beggining
	AccelerateStart = true,

	--// Set to true if moving cameras should slow down at the end
	DecelerateEnd = true,

	--// ScreenGuis that should be toggled on/off when someone presses the Watch button
	ToggleGui = { "TEST" },

	--// Where the Watch button should be, "Left", "Center" or "Right"
	WatchButtonPosition = "Center",

	--// Check website documentation for more info
	Keybinds = {
		{ Keys = { Enum.KeyCode.X }, Action = { "Fov", 30, 5 } },
		{ Keys = { Enum.KeyCode.C }, Action = { "Fov", 120, 5 } },
		{ Keys = { Enum.KeyCode.V }, Action = { "Camera", "Static", "Updating" } },
	},

	--// Move the Bars down by X pixels (useful for streamers)
	BarsOffset = {
		Players = { "SomeRandomPerson" }, --// Who should be affected by the bar offset
		Offset = 36, --// How big should the offset be (36 is the height of Roblox's topbar)
	},

	--// This function will run before the system fully loads
	--// You can use it to insert cameras, add admins, etc.
	BeforeLoad = function() end,

	--// Who should be able to control the cameras even if they're not in the "GuiOwners" setting
	--// "None" = nobody
	--// "Owners" = owners of private servers
	--// "All" = everybody
	FreeAdmin = "None",

	--// When set to true, the system will log every action taken by a player
	--// You can see the logs in the Dev Console (F9 -> Server)
	--// Set to true if you don't trust your camera operators
	LogActions = false,
}
