--[[
Script Name: ThemeScriptExecutor
Purpose: Execute module scripts based on the current theme.
Created by Rawblocky
--]]

-- ==========================
--> SERVICES
-- ==========================
local ChangeHistoryService = game:GetService("ChangeHistoryService")
local RunService = game:GetService("RunService")
local ScriptEditorService = game:GetService("ScriptEditorService")
local PluginGuiService = game:GetService("PluginGuiService")
-- <-

-- ==========================
--> MODULES
-- ==========================
local Configuration = require(script.Configuration)
local ThemeIcons = require(script.ThemeIcons)
-- <-

-- ==========================
--> VARIABLES
-- ==========================
local pluginId = Configuration.PluginId

local defaultSource = 'return function(isInitialLaunch: boolean)\n\tprint("%s")\nend'
local modes = {
	Light = {
		source = string.format(defaultSource, "Good morning!"),
		scriptName = "🌞 Light",
	},
	Dark = {
		source = string.format(defaultSource, "Good evening!"),
		scriptName = "🌚 Dark",
	},
}
-- <-

if not RunService:IsEdit() then
	-- This plugin should only run in edit mode
	return
end

--> Wait for script permissions
local function checkForScriptPermissions()
	return pcall(function()
		local temporaryScript = Instance.new("Script")
		temporaryScript.Parent = PluginGuiService
		temporaryScript:Destroy()
	end)
end

local hasScriptPermissions, _ = checkForScriptPermissions()
if not hasScriptPermissions then
	warn(
		"ThemeScriptExecutor: Script permissions are required to run this plugin. Restart Studio after giving permissions."
	)
	return
end
-- <-

--> Save/Load functions
local settingCache = {}
local function getSetting(settingName: string)
	if settingCache[settingName] ~= nil then
		return settingCache[settingName]
	end
	local setting = plugin:GetSetting(pluginId .. "-" .. settingName)
	settingCache[settingName] = setting
	return setting
end
local function setSetting(settingName: string, ...)
	plugin:SetSetting(pluginId .. "-" .. settingName, ...)
	settingCache[settingName] = ...
end
-- <-

local function getTheme()
	return tostring(settings().Studio.Theme)
end

local function getButtonImage(buttonName: string)
	return ThemeIcons[buttonName][getTheme()]
end

local toolbar = plugin:CreateToolbar("ThemeScriptExecutor")
local scripts = {}
local pluginButtons = {}
local isInitialLaunch = true

local moduleScriptContainer = Instance.new("Folder")
moduleScriptContainer.Archivable = false
moduleScriptContainer.Name = pluginId
moduleScriptContainer.Parent = PluginGuiService

local function themeChanged()
	for mode, button in pluginButtons do
		button.Icon = getButtonImage(mode .. "Button")
	end

	local currentTheme = getTheme()
	local ranScript
	for mode, moduleScript in scripts do
		if mode == currentTheme then
			ranScript = moduleScript
			break
		end
	end
	if not ranScript then
		return
	end

	-- Clone the script because the script could've been edited and
	-- the original function was cached
	local ranScriptClone = ranScript:Clone()
	task.spawn(require(ranScriptClone), isInitialLaunch)
	if isInitialLaunch then
		isInitialLaunch = false
	end
	ChangeHistoryService:SetWaypoint("Executed theme script")
end
for mode, data in modes do
	local moduleScript = Instance.new("ModuleScript")
	moduleScript.Name = data.scriptName
	moduleScript.Source = getSetting(mode) or data.source
	moduleScript.Parent = moduleScriptContainer
	scripts[mode] = moduleScript

	local pluginButton = toolbar:CreateButton(
		mode,
		string.format("Edit '%s' theme module", data.scriptName),
		getButtonImage(mode .. "Button")
	)
	pluginButtons[mode] = pluginButton
	pluginButton.ClickableWhenViewportHidden = true

	pluginButton.Click:Connect(function()
		plugin:OpenScript(moduleScript)
	end)
end

ScriptEditorService.TextDocumentDidChange:Connect(function(document: ScriptDocument, changes: table)
	local changedScript = document:GetScript()
	local mode
	for mode2, moduleScript in scripts do
		if moduleScript == changedScript then
			mode = mode2
			break
		end
	end
	if not mode then
		return
	end
	local newText = document:GetText()
	setSetting(mode, newText)
end)

settings().Studio.ThemeChanged:Connect(themeChanged)
themeChanged()
