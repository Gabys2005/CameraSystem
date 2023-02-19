--!strict

local Settings: Settings = {
	Admins = { "gabys2005" },
	FreeAdmin = "Disabled",
	Theme = "Dark",
}

-- Type definitions for better auto completion, don't touch
type Settings = {
	Admins: { string },
	FreeAdmin: "Disabled" | "PrivateServerOwner" | "Always",
	Theme: string,
}

return Settings
