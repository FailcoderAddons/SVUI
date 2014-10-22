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
local _G 		 =  _G;
local unpack 	 =  _G.unpack;
local pairs 	 =  _G.pairs;
local tinsert 	 =  _G.tinsert;
local string 	 =  _G.string;
local upper 	 =  string.upper;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = _G["SVUI"];
local L = SV.L;
local MOD = SV.SVStats;
--[[ 
########################################################## 
SET PACKAGE OPTIONS
##########################################################
]]--
SV.Options.args.SVStats = {
	type = "group", 
	name = MOD.TitleID, 
	childGroups = "tab", 
	get = function(key) return SV.db.SVStats[key[#key]] end, 
	set = function(key, value) MOD:ChangeDBVar(value, key[#key]); MOD:Generate() end, 
	args = {
		intro = {
			order = 1, 
			type = "description", 
			name = L["STATS_DESC"]
		}, 
		time24 = {
			order = 2, 
			type = "toggle", 
			name = L["24-Hour Time"], 
			desc = L["Toggle 24-hour mode for the time datatext."]
		}, 
		localtime = {
			order = 3, 
			type = "toggle", 
			name = L["Local Time"], 
			desc = L["If not set to true then the server time will be displayed instead."]
		}, 
		battleground = {
			order = 4, 
			type = "toggle", 
			name = L["Battleground Texts"], 
			desc = L["When inside a battleground display personal scoreboard information on the main datatext bars."]
		}, 
		showBackground = {
			order = 5, 
			name = "Show Backgrounds", 
			desc = L["Display statistic background textures"], 
			type = "toggle",
			set = function(key, value) MOD:ChangeDBVar(value, key[#key]); SV:StaticPopup_Show("RL_CLIENT") end,
		},
		shortGold = {
			order = 6, 
			type = "toggle", 
			name = L["Shortened Gold Text"], 
		},
		dockStatWidth = {
			order = 7, 
			type = "range", 
			name = L["Stats Width"], 
			desc = L["PANEL_DESC"],  
			min = 150, 
			max = 1200, 
			step = 1,
			width = "full", 
			set = function(key,value)
				MOD:ChangeDBVar(value, key[#key]);
				MOD:UpdateStatSize();
			end,
		},
		fontGroup = {
			order = 8, 
			type = "group", 
			guiInline = true, 
			name = L["Fonts"], 
			set = function(key, value) MOD:ChangeDBVar(value, key[#key]); MOD:Generate() end, 
			args = {
				font = {
					type = "select", 
					dialogControl = "LSM30_Font", 
					order = 4, 
					name = L["Font"], 
					values = AceGUIWidgetLSMlists.font
				}, 
				fontSize = {
					order = 5, 
					name = L["Font Size"], 
					type = "range", 
					min = 6, 
					max = 22, 
					step = 1
				}, 
				fontOutline = {
					order = 6, 
					name = L["Font Outline"], 
					desc = L["Set the font outline."], 
					type = "select", 
					values = {
						["NONE"] = L["None"], 
						["OUTLINE"] = "OUTLINE", 
						["MONOCHROMEOUTLINE"] = "MONOCROMEOUTLINE", 
						["THICKOUTLINE"] = "THICKOUTLINE"
					}
				}
			}
		},
		panels = {
			type = "group", 
			name = L["Panels"], 
			order = 100, 
			args = {}, 
			guiInline = true
		}, 
	}
}

do
	local orderIncrement = 0;
	local statValues = MOD.StatListing
	local configTable = SV.db.SVStats.panels;
	local optionTable = SV.Options.args.SVStats.args.panels.args;

	for panelName, panelPositions in pairs(configTable)do 
		orderIncrement = orderIncrement + 1;
		if(not _G[panelName]) then 
			optionTable[panelName] = nil;
			return 
		end 
		if(type(panelPositions) == "table") then 
			optionTable[panelName] = {
				type = 'group',
				args = {},
				name = L[panelName] or panelName,
				guiInline = true,
				order = (orderIncrement + 10)
			}
			for position,_ in pairs(panelPositions) do 
				optionTable[panelName].args[position] = {
					type = 'select',
					name = L[position] or upper(position),
					values = statValues,
					get = function(key) return SV.db.SVStats.panels[panelName][key[#key]] end,
					set = function(key, value) MOD:ChangeDBVar(value, key[#key], "panels", panelName); MOD:Generate() end
				}
			end 
		end 
	end 
end 