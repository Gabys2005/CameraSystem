--!strict

type ButtonPosition = "Left" | "Center" | "Right"

export type Keybind = {
	Keys: { Enum.KeyCode },
	Action: { any },
}

export type Settings = {
	GuiOwners: { string },
	Theme: "Dark" | "Light",
	AccelerateStart: boolean,
	DecelerateEnd: boolean,
	ToggleGui: { string },
	WatchButtonPosition: ButtonPosition,
	ControlButtonPosition: ButtonPosition,
	Keybinds: { Keybind },
	BarsOffset: {
		Players: { string },
		Offset: number,
	},
	BeforeLoad: () -> (),
	FreeAdmin: "None" | "Owners" | "All",
	LogActions: boolean,
}

return ""
