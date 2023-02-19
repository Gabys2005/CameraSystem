local replicated = script.Parent.Parent
local Fusion = require(replicated.Dependencies.Fusion)
local Theme = require(replicated.Data.Themes):GetFusion()

local New = Fusion.New
local Children = Fusion.Children
local ForPairs = Fusion.ForPairs
local Value = Fusion.Value
local OnEvent = Fusion.OnEvent
local Computed = Fusion.Computed

export type DropdownProps = {
	Items: { string },
	Size: UDim2?,
	SelectionChanged: (number) -> any,
}

local itemHeight = 30

return function(props: DropdownProps)
	local dropdownOpen = Value(false)
	local selectedItemIndex = Value(1)

	return New("Frame") {
		Size = props.Size or UDim2.fromOffset(200, 30),
		BackgroundTransparency = 1,

		[Children] = {
			New("TextButton") {
				Name = "Current",
				Size = UDim2.fromScale(1, 1),
				BackgroundColor3 = Theme.Dropdown.Background,
				TextColor3 = Theme.Button.Text,
				FontFace = Theme.Button.Font,
				AutoButtonColor = true,
				Text = Computed(function()
					return props.Items[selectedItemIndex:get()]
				end),

				[OnEvent("Activated")] = function()
					dropdownOpen:set(not dropdownOpen:get())
				end,

				[Children] = New("UICorner") {},
			},

			New("Frame") {
				Name = "List",
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.fromScale(1, 0),
				Position = UDim2.fromScale(0, 1),
				Visible = dropdownOpen,

				[Children] = ForPairs(props.Items, function(i, itemName)
					return i,
						New("TextButton") {
							Size = UDim2.new(1, 0, 0, itemHeight),
							Position = UDim2.fromOffset(0, itemHeight * (i - 1)),
							BackgroundColor3 = Theme.Button.Primary,
							TextColor3 = Theme.Button.Text,
							FontFace = Theme.Button.Font,
							Text = itemName,
							AutoButtonColor = true,
							[OnEvent("Activated")] = function()
								if dropdownOpen:get() then
									selectedItemIndex:set(i)
									props.SelectionChanged(i)
								end
								dropdownOpen:set(not dropdownOpen:get())
							end,
						}
				end, Fusion.cleanup),
			},
		},
	}
end
