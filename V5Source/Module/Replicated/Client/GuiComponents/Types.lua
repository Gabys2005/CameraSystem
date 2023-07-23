export type Theme = {
	Base: Color3,
	Underline: Color3,
	TransparentButton: Color3,
	RedButton: Color3,
	DarkerButton: Color3,
	Hightlighted: Color3,

	BaseDarker: Color3,
	BaseDarker2: Color3,

	BaseText: Color3,

	BaseBorder: Color3,
}

export type Component<T, T2> = {
	__index: T,
	ApplyTheme: (T, Theme) -> (),
	Instance: T2,
	Destroy: (T) -> (),
}

return "🧩"
