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
local MOD = SV.SVUnit
if(not MOD) then return end 
local _, ns = ...
--[[
##################################################################################################
##################################################################################################
##################################################################################################
]]
SV.Options.args.SVUnit.args.grid = {
	name = L["Grid"], 
	type = "group", 
	order = 1200, 
	childGroups = "tab", 
	args = {
		configureToggle = {
			order = 1, 
			type = "execute", 
			name = L["Display Frames"], 
			func = function()MOD:ViewGroupFrames(_G["SVUI_Raid"], _G["SVUI_Raid"].forceShow ~= true or nil, "raid")end, 
		},
		gridCommon = {
			order = 2, 
			type = "group", 
			guiInline = true, 
			name = L["General Settings"],
			get = function(key)
				return SV.db.SVUnit.grid[key[#key]] 
			end, 
			set = function(key, value)
				MOD:ChangeDBVar(value, key[#key] , "grid");
				MOD:RefreshUnitFrames();
			end,
			args = {
				enable = {
					order = 1, 
					name = L["Enable Grid Mode"], 
					desc = L["Converts party, party pet, raid, raid pet, tank and assist frames into symmetrical squares. Ideal for healers."], 
					type = "toggle"
				},
				shownames = {
					order = 2, 
					name = L["Show Grid Names"], 
					desc = L["Grid frames will show name texts."],
					type = "toggle",
					set = function(key, value)
						if(SV.db.SVUnit.grid.size < 30) then MOD:ChangeDBVar(30, "size", "grid"); end
						MOD:ChangeDBVar(value, "shownames", "grid");
						MOD:RefreshUnitFrames();
					end
				},
				size = {
					order = 3, 
					name = L["Grid Size"], 
					desc = L["The universal size of grid squares."], 
					type = "range", 
					min = 10, 
					max = 70, 
					step = 1, 
					width = "full"
				},
			}
		},
		gridAllowed = {
			order = 3, 
			type = "group", 
			guiInline = true, 
			name = L["Allowed Frames"],
			get = function(key)
				return SV.db.SVUnit.grid[key[#key]] 
			end, 
			set = function(key, value)
				MOD:ChangeDBVar(value, key[#key] , "grid");
				MOD:RefreshUnitFrames();
			end,
			args = {
				party = {
					type = 'toggle',
					order = 1,
					name = L['Party Grid'],
					desc = L['If grid-mode is enabled, these units will be changed.'],
					get = function(key) return SV.db.SVUnit.party.gridAllowed end,
					set = function(key, value) SV.db.SVUnit.party.gridAllowed = value; MOD:SetGroupFrame() end,
				},
				partypets = {
					type = 'toggle',
					order = 2,
					name = L['Party Pets Grid'],
					desc = L['If grid-mode is enabled, these units will be changed.'],
					get = function(key) return SV.db.SVUnit.party.petsGroup.gridAllowed end,
					set = function(key, value) SV.db.SVUnit.party.petsGroup.gridAllowed = value; MOD:SetGroupFrame() end,
				},
				partytargets = {
					type = 'toggle',
					order = 3,
					name = L['Party Targets Grid'],
					desc = L['If grid-mode is enabled, these units will be changed.'],
					get = function(key) return SV.db.SVUnit.party.targetsGroup.gridAllowed end,
					set = function(key, value) SV.db.SVUnit.party.targetsGroup.gridAllowed = value; MOD:SetGroupFrame() end,
				},
				raid = {
					type = 'toggle',
					order = 4,
					name = L['Raid Grid'],
					desc = L['If grid-mode is enabled, these units will be changed.'],
					get = function(key) return SV.db.SVUnit.raid.gridAllowed end,
					set = function(key, value) SV.db.SVUnit.raid.gridAllowed = value; MOD:SetGroupFrame("raid"); end,
				},
				raidpet = {
					type = 'toggle',
					order = 7,
					name = L['Raid Pet Grid'],
					desc = L['If grid-mode is enabled, these units will be changed.'],
					get = function(key) return SV.db.SVUnit.raidpet.gridAllowed end,
					set = function(key, value) SV.db.SVUnit.raidpet.gridAllowed = value; MOD:SetGroupFrame() end,
				},
			}
		},
	}
}
--[[
##################################################################################################
##################################################################################################
##################################################################################################
]]