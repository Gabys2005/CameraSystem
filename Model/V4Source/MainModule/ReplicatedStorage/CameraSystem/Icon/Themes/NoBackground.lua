-- BlueGradient by ForeverHD
local selectedColor = Color3.fromRGB(0, 170, 255)
local selectedColorDarker = Color3.fromRGB(0, 120, 180)
local neutralColor = Color3.fromRGB(255, 255, 255)
return {
    
    -- Settings which describe how an item behaves or transitions between states
    action =  {},
    
    -- Settings which describe how an item appears when 'deselected' and 'selected'
    toggleable = {
        -- How items appear normally (i.e. when they're 'deselected')
        deselected = {
			iconBackgroundColor = Color3.fromRGB(0,0,0),
			iconBackgroundTransparency = 0.5,
			iconImageColor =Color3.fromRGB(255, 255, 255)
        },
        -- How items appear after the icon has been clicked (i.e. when they're 'selected')
        -- If a selected value is not specified, it will default to the deselected value
		selected = {
			iconBackgroundColor = Color3.fromRGB(0,0,0),
			iconBackgroundTransparency = 0.5,
			iconImageColor =Color3.fromRGB(255, 255, 255)
        }
    },
    
    -- Settings where toggleState doesn't matter (they have a singular state)
    other =  {},
    
}
