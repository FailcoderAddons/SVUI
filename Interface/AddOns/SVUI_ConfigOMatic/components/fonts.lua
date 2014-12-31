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
local _, ns = ...;

local AceGUIWidgetLSMlists = AceGUIWidgetLSMlists;

local FONT_GROUP_SORT = {
	{"Default", 1, {"default"}},
	{"General", 2, {"name", "number", "aura"}},
	{"Large", 3, {"combat", "alert", "zone", "title"}},
	{"Docking", 4, {"data"}},
	{"Misc", 5, {"narrator", "caps"}},
	{"NamePlate", 6, {"platename", "plateaura"}},
	{"UnitFrame", 7, {"unitprimary", "unitsecondary", "unitaurabar", "unitaurasmall", "unitauramedium", "unitauralarge"}},
}

local function GenerateFontGroup()
    local fontGroupArgs = {};

    for _, listData in pairs(FONT_GROUP_SORT) do
    	local orderCount = 1;
    	local groupName = listData[1];
    	local groupCount = listData[2];
    	local groupList = listData[3];
    	fontGroupArgs[groupName] = {
			order = groupCount, 
			type = "group", 
			name = groupName,
			args = {}, 
		};
    	for _, template in pairs(groupList) do
    		local data = SV.db.font[template]
	    	fontGroupArgs[groupName].args[template] = {
	    		order = orderCount, 
				type = "group",
				guiInline = true,
				name = data.optionName,
				get = function(key)
					return SV.db.font[template][key[#key]]
				end,
				set = function(key,value)
					SV.db.font[template][key[#key]] = value; 
					SV:RefreshSystemFonts();
				end,
				args = {
					description = {
						order = 1, 
						name = data.optionDesc, 
						type = "description", 
						width = "full", 
					},
					spacer1 = {
						order = 2, 
						name = "", 
						type = "description", 
						width = "full", 
					},
					spacer2 = {
						order = 3, 
						name = "", 
						type = "description", 
						width = "full", 
					},
					file = {
						type = "select",
						dialogControl = 'LSM30_Font',
						order = 4,
						name = L["Font File"],
						desc = L["Set the font file to use with this font-type."],
						values = AceGUIWidgetLSMlists.font,
					},
					outline = {
						order = 5, 
						name = L["Font Outline"], 
						desc = L["Set the outlining to use with this font-type."], 
						type = "select", 
						values = {
							["NONE"] = L["None"], 
							["OUTLINE"] = "OUTLINE", 
							["MONOCHROMEOUTLINE"] = "MONOCROMEOUTLINE",
							["THICKOUTLINE"] = "THICKOUTLINE"
						},
					},
					size = {
						order = 6,
						name = L["Font Size"],
						desc = L["Set the font size to use with this font-type."],
						type = "range",
						min = 6,
						max = 22,
						step = 1,
						width = 'full',
					},
				}
	    	}
	    	orderCount = orderCount + 1;
	    end
    end

    return fontGroupArgs;
end 

SV.Options.args.fonts = {
	order = 3, 
	type = "group", 
	name = L['Fonts'],
	childGroups = "tab", 
	args = {
		commonGroup = {
			order = 1, 
			type = 'group', 
			name = L['Font Options'], 
			childGroups = "tree", 
			args = GenerateFontGroup()
		}
	}
};

function ns:SetToFontConfig(font)
	font = font or "Default";
	_G.LibStub("AceConfigDialog-3.0"):SelectGroup(SV.NameID, "fonts", "commonGroup", font);
end