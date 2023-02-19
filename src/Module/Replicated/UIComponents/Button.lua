local replicated = script.Parent.Parent
local Fusion = require(replicated.Dependencies.Fusion)
local Theme = require(replicated.Data.Themes):GetFusion()

local New = Fusion.New
local Children = Fusion.Children
local OnEvent = Fusion.OnEvent

export type ButtonProps = {
	Text: string,
	TextScaled: boolean?,
	TextSize: number?,
	AnchorPoint: Vector2?,
	Position: UDim2?,
	Size: UDim2?,
	OnClick: () -> any,
}

return function(props: ButtonProps)
	return New("TextButton") {
		Size = props.Size or UDim2.fromOffset(100, 30),
		Text = props.Text,
		BackgroundColor3 = Theme.Button.Primary,
		TextColor3 = Theme.Button.Text,
		FontFace = Theme.Button.Font,
		AutoButtonColor = true,
		TextScaled = props.TextScaled,
		TextSize = props.TextSize,
		AnchorPoint = props.AnchorPoint,
		Position = props.Position,

		[Children] = {
			New("UICorner") {},
			New("UIPadding") {
				PaddingBottom = UDim.new(0, 5),
				PaddingTop = UDim.new(0, 5),
				PaddingLeft = UDim.new(0, 5),
				PaddingRight = UDim.new(0, 5),
			},
		},

		[OnEvent("Activated")] = props.OnClick,
	}
end
