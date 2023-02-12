--!strict

local Settings: Settings = {
	Admins = { "gabys2005" },
	FreeAdmin = "Disabled",
}

-- Type definitions for better auto completion, don't touch
type Settings = {
	Admins: { string },
	FreeAdmin: "Disabled" | "PrivateServerOwner" | "Always",
}

return Settings
