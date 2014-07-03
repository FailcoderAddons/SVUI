--[[
##############################################################################
_____/\\\\\\\\\\\____/\\\________/\\\__/\\\________/\\\__/\\\\\\\\\\\_       #
 ___/\\\/////////\\\_\/\\\_______\/\\\_\/\\\_______\/\\\_\/////\\\///__      #
  __\//\\\______\///__\//\\\______/\\\__\/\\\_______\/\\\_____\/\\\_____     #
   ___\////\\\__________\//\\\____/\\\___\/\\\_______\/\\\_____\/\\\_____    #
    ______\////\\\________\//\\\__/\\\____\/\\\_______\/\\\_____\/\\\_____   #
     _________\////\\\______\//\\\/\\\_____\/\\\_______\/\\\_____\/\\\_____  #
      __/\\\______\//\\\______\//\\\\\______\//\\\______/\\\______\/\\\_____ #
       _\///\\\\\\\\\\\/________\//\\\________\///\\\\\\\\\/____/\\\\\\\\\\\_#
        ___\///////////___________\///___________\/////////_____\///////////_#
##############################################################################
S U P E R - V I L L A I N - U I   By: Munglunch                              #
##############################################################################
########################################################## 
LOCALIZED LUA FUNCTIONS
##########################################################
]]--
--[[ GLOBALS ]]--
local _G = _G;
local unpack 	 =  _G.unpack;
local pairs 	 =  _G.pairs;
local tinsert 	 =  _G.tinsert;
local table 	 =  _G.table;
--[[ TABLE METHODS ]]--
local tsort = table.sort;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L = unpack(SVUI);

SuperVillain.Options.args.profiles = {
	order = 9999,
	type = "group", 
	name = L["profiles"], 
	childGroups = "tab", 
	args = {
		desc = {
			order = 1,
			type = "description",
			name = L["intro"] .. "\n",
		},
		spacer1 = {
			order = 2,
			type = "description",
			name = "",
			width = "full",
		},
		importdesc = {
			order = 3,
			type = "description",
			name = "\n" .. L["import_desc"],
			width = "full"
		},
		save = {
			order = 4,
			type = "execute",
			name = SAVE,
			desc = function() return SAVE .. " " .. L["current"] .. " " .. NORMAL_FONT_COLOR_CODE .. SuperVillain.db.profileKey .. FONT_COLOR_CODE_CLOSE end,
			func = function() SuperVillain.db:Export(SuperVillain.db.profileKey) end,
		},
		export = {
			name = L["export"],
			desc = L["export_sub"],
			type = "input",
			order = 5,
			get = false,
			set = function(key, value) SuperVillain.db:Export(value) end,
		},
		import = {
			name = L["import"],
			desc = L["import_sub"],
			type = "select",
			order = 6,
			get = function() return SuperVillain.db.profileKey end,
			set = function(key, value) SuperVillain.db:Import(value) end,
			values = SuperVillain.db:GetAll(),
		},
		spacer2 = {
			order = 7,
			type = "description",
			name = "",
			width = "full",
		},
		deldesc = {
			order = 8,
			type = "description",
			name = "\n" .. L["delete_desc"],
		},
		delete = {
			order = 9,
			type = "select",
			name = L["delete"],
			desc = L["delete_sub"],
			get = false,
			set = function(key, value) SuperVillain.db:Remove(value) end,
			values = SuperVillain.db:GetAll(),
			disabled = function() local t = SuperVillain.db:GetAll() return (not t) end,
			confirm = true,
			confirmText = L["delete_confirm"],
		},
		spacer3 = {
			order = 10,
			type = "description",
			name = "",
			width = "full",
		},
		descreset = {
			order = 11,
			type = "description",
			name = L["reset_desc"],
		},
		reset = {
			order = 12,
			type = "execute",
			name = function() return L["reset"] .. " " .. NORMAL_FONT_COLOR_CODE .. SuperVillain.db.profileKey .. FONT_COLOR_CODE_CLOSE end,
			desc = L["reset_sub"],
			func = function() SuperVillain.db:Reset() end,
			width = "full",
		},
	}
}