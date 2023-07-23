-- This module is here so we don't have to check the Theme setting every time we want to get the theme colors
local replicated = script.Parent.Parent.Parent
local data = require(replicated.Data)
local consts = require(replicated.Shared.Constants)

local theme = data.Local.Settings.Theme or consts.DEFAULT_THEME
local themeScript = require(script.Parent[theme])
return themeScript
