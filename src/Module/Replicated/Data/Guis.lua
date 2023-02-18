local replicated = script.Parent.Parent
local Fusion = require(replicated.Dependencies.Fusion)

local Value = Fusion.Value

local Guis = {}

Guis._cameraSections = {}
Guis._cameraSectionsFusion = Value {}

function Guis:AddCameraSection(name, content)
	table.insert(Guis._cameraSections, { Name = name, Content = content })
	Guis._cameraSectionsFusion:set(Guis._cameraSections)
end

function Guis:GetCameraSectionsFusion()
	return Guis._cameraSectionsFusion
end

return Guis
