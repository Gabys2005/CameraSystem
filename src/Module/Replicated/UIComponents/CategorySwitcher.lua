local replicated = script.Parent.Parent
local Fusion = require(replicated.Dependencies.Fusion)
local Theme = require(replicated.Data.Themes):GetFusion()

local Value = Fusion.Value
local Ref = Fusion.Ref
local New = Fusion.New
local Children = Fusion.Children
local ForPairs = Fusion.ForPairs
local OnEvent = Fusion.OnEvent
local Hydrate = Fusion.Hydrate

export type CategorySwitcherProps = {
	Content: {
		Name: string,
		Content: Instance, -- TODO: child
	},
	FullWidth: boolean?,
}

return function(props: CategorySwitcherProps)
	local pageLayout = Value()
	local selectedPage = Value(1)

	return New("Frame") {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		[Children] = {
			New("Frame") {
				Size = UDim2.new(1, 0, 0, 35),
				BackgroundColor3 = Theme.CategorySwitcher.Background,
				[Children] = {
					New("UICorner") {},
					New("UIPadding") {
						PaddingLeft = UDim.new(0, 5),
						PaddingRight = UDim.new(0, 5),
						PaddingTop = UDim.new(0, 5),
						PaddingBottom = UDim.new(0, 5),
					},
					New("ScrollingFrame") {
						Size = UDim2.fromScale(1, 1),
						AutomaticCanvasSize = if props.FullWidth then Enum.AutomaticSize.None else Enum.AutomaticSize.X,
						CanvasSize = UDim2.fromScale(0, 0),
						BackgroundTransparency = 1,
						ScrollBarImageColor3 = Theme.CategorySwitcher.ScrollBarColor,
						ScrollBarThickness = 2,
						[Children] = {
							New("UIListLayout") {
								FillDirection = Enum.FillDirection.Horizontal,
								SortOrder = Enum.SortOrder.LayoutOrder,
								Padding = UDim.new(0, 5),
							},
							ForPairs(props.Content, function(i, data)
								return i,
									New("TextButton") {
										AutomaticSize = if props.FullWidth
											then Enum.AutomaticSize.None
											else Enum.AutomaticSize.X,
										Size = if props.FullWidth
											then UDim2.new(1 / #props.Content, -5, 1, 0)
											else UDim2.new(0, 0, 1, -5), -- TODO: the -5 should be gone when scrollbar isnt visible
										Text = data.Name,
										AutoButtonColor = true,
										LayoutOrder = i,
										BackgroundColor3 = if selectedPage:get() == i
											then Theme.Button.Primary
											else Theme.CategorySwitcher.Background,
										TextColor3 = Theme.Button.Text,
										FontFace = Theme.Button.Font,
										[Children] = {
											New("UIPadding") {
												PaddingRight = UDim.new(0, 20),
												PaddingLeft = UDim.new(0, 20),
											},
											New("UICorner") {},
										},
										[OnEvent("Activated")] = function()
											selectedPage:set(i)
											pageLayout:get():JumpToIndex(i - 1)
										end,
									}
							end, Fusion.cleanup),
						},
					},
				},
			},
			New("Frame") {
				Size = UDim2.new(1, 0, 1, -40),
				Position = UDim2.fromOffset(0, 40),
				BackgroundTransparency = 1,
				ClipsDescendants = true,
				[Children] = {
					New("UIPageLayout") {
						GamepadInputEnabled = false,
						ScrollWheelInputEnabled = false,
						TouchInputEnabled = false,
						TweenTime = 0.5,
						SortOrder = Enum.SortOrder.LayoutOrder,
						[Ref] = pageLayout,
					},
					ForPairs(props.Content, function(i, contentData)
						return i, Hydrate(contentData.Content) {
							LayoutOrder = i,
						}
					end, Fusion.cleanup),
				},
			},
		},
	}
end
