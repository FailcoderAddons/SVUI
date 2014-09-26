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
local SV = SVUI;
local L = LibStub("LibSuperVillain-1.0"):Lang();
local MOD = SV.SVLaborer
SV.Options.args.SVLaborer = {
	type = 'group',
	name = L['Laborer'], 	
	get = function(key)return SV.db.SVLaborer[key[#key]]end,
	set = function(key, value)MOD:ChangeDBVar(value, key[#key]) end, 
	args = {
		intro = {
			order = 1, 
			type = 'description', 
			name = L["Options for laborer modes"]
		},
		enable = {
			type = "toggle", 
			order = 2, 
			name = L['Enable'], 
			desc = L['Enable/Disable the Laborer dock.'], 
			get = function(key)return SV.db.SVLaborer[key[#key]]end, 
			set = function(key, value)SV.db.SVLaborer.enable = value;SV:StaticPopup_Show("RL_CLIENT")end
		},
		fontSize = {
			order = 3,
			name = L["Font Size"],
			desc = L["Set the font size of the log window."],
			type = "range",
			min = 6,
			max = 22,
			step = 1,
			set = function(j,value)MOD:ChangeDBVar(value,j[#j]);MOD:UpdateLogWindow()end
		},
		fishing = {
			order = 4, 
			type = "group", 
			name = L["Fishing Mode Settings"], 
			guiInline = true, 
			args = {
				autoequip = {
					type = "toggle", 
					order = 1, 
					name = L['AutoEquip'], 
					desc = L['Enable/Disable automatically equipping fishing gear.'], 
					get = function(key)return SV.db.SVLaborer.fishing[key[#key]]end,
					set = function(key, value)MOD:ChangeDBVar(value, key[#key], "fishing")end
				}
			}	
		},
		cooking = {
			order = 5, 
			type = "group", 
			name = L["Cooking Mode Settings"], 
			guiInline = true, 
			args = {
				autoequip = {
					type = "toggle", 
					order = 1, 
					name = L['AutoEquip'], 
					desc = L['Enable/Disable automatically equipping cooking gear.'], 
					get = function(key)return SV.db.SVLaborer.cooking[key[#key]]end,
					set = function(key, value)MOD:ChangeDBVar(value, key[#key], "cooking")end
				}
			}
		},
		farming = {
			order = 6, 
			type = "group", 
			name = L["Farming Mode Settings"], 
			guiInline = true, 
			get = function(key)return SV.db.SVLaborer.farming[key[#key]]end, 
			set = function(key, value)SV.db.SVLaborer.farming[key[#key]] = value end, 
			args = {
				buttonsize = {
					type = 'range', 
					name = L['Button Size'], 
					desc = L['The size of the action buttons.'], 
					min = 15, 
					max = 60, 
					step = 1, 
					order = 1, 
					set = function(key, value)
						MOD:ChangeDBVar(value, key[#key],"farming");
						MOD:RefreshFarmingTools()
					end,
				},
				buttonspacing = {
					type = 'range', 
					name = L['Button Spacing'], 
					desc = L['The spacing between buttons.'], 
					min = 1, 
					max = 10, 
					step = 1, 
					order = 2, 
					set = function(key, value)
						MOD:ChangeDBVar(value, key[#key],"farming");
						MOD:RefreshFarmingTools()
					end,
				},
				onlyactive = {
					order = 3, 
					type = 'toggle', 
					name = L['Only active buttons'], 
					desc = L['Only show the buttons for the seeds, portals, tools you have in your bags.'], 
					set = function(key, value)
						MOD:ChangeDBVar(value, key[#key],"farming");
						MOD:RefreshFarmingTools()
					end,
				},
				droptools = {
					order = 4, 
					type = 'toggle', 
					name = L['Drop '], 
					desc = L['Automatically drop tools from your bags when leaving the farming area.'],
				},
				toolbardirection = {
					order = 5, 
					type = 'select', 
					name = L['Bar Direction'], 
					desc = L['The direction of the bar buttons (Horizontal or Vertical).'], 
					set = function(key, value)MOD:ChangeDBVar(value, key[#key],"farming");MOD:RefreshFarmingTools()end,
					values = {
							['VERTICAL'] = L['Vertical'], ['HORIZONTAL'] = L['Horizontal']
					}
				}
			}
		}
	}
}