export type Theme = {
	Background: {
		Primary: Color3,
		Dark: Color3,
	},
	Text: {
		Primary: Color3,
	},
	Buttons: {
		Danger: Color3,
		Primary: { Background: Color3, Border: Color3 },
	},
}

export type Component<T, T2> = {
	__index: T,
	ApplyTheme: (T, Theme) -> (),
	Instance: T2,
	Destroy: (T) -> (),
}

return "🧩"
