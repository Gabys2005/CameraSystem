local TopbarMenu = {}
local replicated = script.Parent.Parent.Parent
local Icon = require(replicated.Dependencies.TopbarPlus)

local topbarMenu = Icon.new():setImage(12417056533):setImageYScale(0.8):setMenu({}):autoDeselect(false)

TopbarMenu.Menu = topbarMenu
TopbarMenu._Icons = {}

function TopbarMenu:AddIcon(icon)
	table.insert(TopbarMenu._Icons, icon)
	TopbarMenu.Menu:setMenu(TopbarMenu._Icons)
end

-- TODO: remove icon

return TopbarMenu
