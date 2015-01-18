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
local SV = _G["SVUI"];
local L = SV.L;

SV.Options.args.Screen = {
	type = 'group',
	name = 'Screen',
	order = 3,
	get = function(a)return SV.db.screen[a[#a]] end,
	set = function(a,b) SV.db.screen[a[#a]] = b; end,
	args = {
		commonGroup = {
			order = 1, 
			type = 'group', 
			name = L['Basic Options'], 
			guiInline = true,
			args = {
				autoScale = {
					order = 1,
					name = L["Auto Scale"],
					desc = L["Automatically scale the User Interface based on your screen resolution"],
					type = "toggle",
					get = function(j)return SV.db.screen.autoScale end,
					set = function(j,value) 
						SV.db.screen.autoScale = value;
						if(value) then
							SV.db.screen.scaleAdjust = 0.64;
						end
						SV:StaticPopup_Show("RL_CLIENT") 
					end
				},
				multiMonitor = {
					order = 2,
					name = L["Multi Monitor"],
					desc = L["Adjust UI dimensions to accomodate for multiple monitor setups"],
					type = "toggle",
					get = function(j)return SV.db.screen.multiMonitor end,
					set = function(j,value) SV.db.screen.multiMonitor = value; SV:StaticPopup_Show("RL_CLIENT") end
				},
			}
		},
		advancedGroup = {
			order = 2, 
			type = 'group', 
			name = L['Advanced Options'], 
			guiInline = true,
			args = {
				advanced = {
					order = 1,
					name = L["Enable"],
					desc = L["These settings are for advanced users only!"],
					type = "toggle",
					get = function(j)return SV.db.screen.advanced end,
					set = function(j,value) SV.db.screen.advanced = value; SV:StaticPopup_Show("RL_CLIENT"); end
				},
				forcedWidth = {	
					order = 2,
					name = L["Forced Width"],
					desc = function() return L["Setting your resolution height here will bypass all evaluated measurements. Current: "] .. SV.db.screen.forcedWidth; end,
					type = "input",
					disabled = function() return not SV.db.screen.advanced end,
					get = function(key) return SV.db.screen.forcedWidth end,
					set = function(key, value)
						local w = tonumber(value);
						if(not w) then 
							SV:AddonMessage(L["Value must be a number"])
						elseif(w < 800) then 
							SV:AddonMessage(L["Less than 800 is not allowed"])
						else
							SV.db.screen.forcedWidth = w;
							SV:StaticPopup_Show("RL_CLIENT");
						end
					end
				},
				forcedHeight = {	
					order = 3,
					name = L["Forced Height"],
					desc = function() return L["Setting your resolution height here will bypass all evaluated measurements. Current: "] .. SV.db.screen.forcedHeight; end,
					type = "input",
					disabled = function() return not SV.db.screen.advanced end,
					get = function(key) return SV.db.screen.forcedHeight end,
					set = function(key, value)
						local h = tonumber(value);
						if(not h) then 
							SV:AddonMessage(L["Value must be a number"])
						elseif(h < 600) then 
							SV:AddonMessage(L["Less than 600 is not allowed"])
						else
							SV.db.screen.forcedHeight = h;
							SV:StaticPopup_Show("RL_CLIENT");
						end
					end
				},
				scaleAdjust = {
					order = 4,
					name = L["Base Scale"],
					desc = L["You can use this to adjust the base value applied to scale calculations."],
					type = "range",
					width = 'full',
					min = 0.25,
					max = 1,
					step = 0.01,
					disabled = function() return not SV.db.screen.advanced end,
					get = function(j)return SV.db.screen.scaleAdjust end,
					set = function(j,value) 
						SV.db.screen.scaleAdjust = value; 
						if(value ~= 0.64) then
							SV.db.screen.autoScale = false;
						end
						SV:StaticPopup_Show("RL_CLIENT") 
					end
				},
			}
		},
	}
}