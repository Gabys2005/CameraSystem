local Themes = {}
local replicated = script.Parent.Parent
local Fusion = require(replicated.Dependencies.Fusion)

local Value = Fusion.Value

local function deepCopy(t)
	local returnedTable = {}
	for i, v in t do
		if typeof(v) == "table" then
			returnedTable[i] = deepCopy(v)
		else
			returnedTable[i] = Value(v)
		end
	end
	return returnedTable
end

Themes._current = {
	Data = {
		General = {
			BackgroundDark = Color3.fromRGB(27, 27, 27),
			Background = Color3.fromRGB(50, 50, 50),
		},
		Button = {
			Primary = Color3.fromRGB(94, 94, 94),
			Error = Color3.fromRGB(161, 0, 0),
			Text = Color3.fromRGB(255, 255, 255),
			Font = Font.fromName("GothamSSm"),
		},
		Label = {
			Text = Color3.fromRGB(255, 255, 255),
			Font = Font.fromName("GothamSSm"),
		},
		CategorySwitcher = {
			Background = Color3.fromRGB(27, 27, 27),
			ScrollBarColor = Color3.fromRGB(255, 255, 255),
		},
		Dropdown = {
			Background = Color3.fromRGB(27, 27, 27),
		},
	},
	Name = "Dark",
}

Themes._themes = {
	Dark = Themes._current.Data,
}

Themes._fusionValues = deepCopy(Themes._current.Data)

function Themes:Get()
	return Themes._current.Data
end

function Themes:GetFusion()
	return Themes._fusionValues
end

function Themes:GetName()
	return Themes._current.Name
end

function Themes:Add(name, data)
	Themes._themes[name] = data
end

function Themes:SetCurrent(name)
	local data = Themes._themes[name]
	Themes._current = { Data = data, Name = name }
	-- TODO: clean this up
	for name, value in data.General do
		Themes._fusionValues.General[name]:set(value)
	end
	for name, value in data.Button do
		Themes._fusionValues.Button[name]:set(value)
	end
	for name, value in data.Label do
		Themes._fusionValues.Label[name]:set(value)
	end
	for name, value in data.CategorySwitcher do
		Themes._fusionValues.CategorySwitcher[name]:set(value)
	end
	for name, value in data.Dropdown do
		Themes._fusionValues.Dropdown[name]:set(value)
	end
end

return Themes
