local CategorySwitcher = require(script.Parent.Parent.CategorySwitcher)
local replicated = script.Parent.Parent.Parent
local Fusion = require(replicated.Dependencies.Fusion)

local New = Fusion.New
local Cleanup = Fusion.Cleanup
local Children = Fusion.Children

local function randomFrame(props)
	return New("Frame") {
		BackgroundColor3 = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)),
		Size = UDim2.fromScale(1, 1),
		[Cleanup] = function()
			print("destroying random frame")
		end,
	}
end

return function(target)
	local switcher1 = New("Frame") {
		Size = UDim2.fromScale(0.49, 0.9),
		BackgroundTransparency = 1,
		[Children] = CategorySwitcher {
			Content = {
				{ Name = "Name1", Content = randomFrame {} },
				{ Name = "Cameras", Content = randomFrame {} },
				{ Name = "Settings", Content = randomFrame {} },
				{ Name = "Info", Content = randomFrame {} },
				{ Name = "Something Else", Content = randomFrame {} },
			},
		},
	}
	switcher1.Parent = target
	local switcher2 = New("Frame") {
		Size = UDim2.fromScale(0.49, 0.9),
		Position = UDim2.fromScale(0.5, 0),
		BackgroundTransparency = 1,
		[Children] = CategorySwitcher {
			-- Position = UDim2.fromOffset(0, 50),
			Content = {
				{ Name = "Name1", Content = randomFrame {} },
				{ Name = "Cameras", Content = randomFrame {} },
				{ Name = "Settings", Content = randomFrame {} },
				{ Name = "Info", Content = randomFrame {} },
				{ Name = "Something Else", Content = randomFrame {} },
			},
			FullWidth = true,
		},
	}
	switcher2.Parent = target

	return function()
		switcher1:Destroy()
		switcher2:Destroy()
	end
end
