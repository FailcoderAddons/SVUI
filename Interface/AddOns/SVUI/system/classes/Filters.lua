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
local unpack    = _G.unpack;
local select    = _G.select;
local pairs     = _G.pairs;
local next 		= _G.next;
local type      = _G.type;
local error 	= _G.error;
local rawset    = _G.rawset;
local rawget    = _G.rawget;
local string    = _G.string;
local math      = _G.math;
local bit       = _G.bit;
local table     = _G.table;
--[[ STRING METHODS ]]--
local lower, upper = string.lower, string.upper;
local find, format, len, split = string.find, string.format, string.len, string.split;
local match, sub, join = string.match, string.sub, string.join;
local gmatch, gsub = string.gmatch, string.gsub;
--[[ MATH METHODS ]]--
local abs, ceil, floor, round = math.abs, math.ceil, math.floor, math.round;  -- Basic
local fmod, modf, sqrt = math.fmod, math.modf, math.sqrt;   -- Algebra
local atan2, cos, deg, rad, sin = math.atan2, math.cos, math.deg, math.rad, math.sin;  -- Trigonometry
local parsefloat, huge, random = math.parsefloat, math.huge, math.random;  -- Uncommon
--[[ BINARY METHODS ]]--
local band, bor = bit.band, bit.bor;
--[[ TABLE METHODS ]]--
local tremove, tcopy, twipe, tsort, tconcat, tdump = table.remove, table.copy, table.wipe, table.sort, table.concat, table.dump;
--[[ MUNGLUNCH's FASTER ASSERT FUNCTION ]]--
local assert = enforce;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L = unpack(select(2, ...));
local CLASS_WATCH_INDEX = {
	PRIEST = {
		{-- Weakened Soul
			["enabled"] = true, 
			["id"] = 6788, 
			["point"] = "TOPRIGHT", 
			["color"] = {["r"] = 1, ["g"] = 0, ["b"] = 0}, 
			["anyUnit"] = true, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
		{-- Prayer of Mending
			["enabled"] = true, 
			["id"] = 41635, 
			["point"] = "BOTTOMRIGHT", 
			["color"] = {["r"] = 0.2, ["g"] = 0.7, ["b"] = 0.2}, 
			["anyUnit"] = false, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
		{-- Renew
			["enabled"] = true, 
			["id"] = 139, 
			["point"] = "BOTTOMLEFT", 
			["color"] = {["r"] = 0.4, ["g"] = 0.7, ["b"] = 0.2}, 
			["anyUnit"] = false, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
		{-- Power Word: Shield
			["enabled"] = true, 
			["id"] = 17, 
			["point"] = "TOPLEFT", 
			["color"] = {["r"] = 0.81, ["g"] = 0.85, ["b"] = 0.1}, 
			["anyUnit"] = true, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
		{-- Power Word: Shield Power Insight
			["enabled"] = true, 
			["id"] = 123258, 
			["point"] = "TOPLEFT", 
			["color"] = {["r"] = 0.81, ["g"] = 0.85, ["b"] = 0.1}, 
			["anyUnit"] = true, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
		{-- Power Infusion
			["enabled"] = true, 
			["id"] = 10060, 
			["point"] = "RIGHT", 
			["color"] = {["r"] = 0.89, ["g"] = 0.09, ["b"] = 0.05}, 
			["anyUnit"] = false, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
		{-- Guardian Spirit
			["enabled"] = true, 
			["id"] = 47788, 
			["point"] = "LEFT", 
			["color"] = {["r"] = 0.86, ["g"] = 0.44, ["b"] = 0}, 
			["anyUnit"] = true, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
		{-- Pain Suppression
			["enabled"] = true, 
			["id"] = 33206, 
			["point"] = "LEFT", 
			["color"] = {["r"] = 0.89, ["g"] = 0.09, ["b"] = 0.05}, 
			["anyUnit"] = true, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
	},
	DRUID = {
		{-- Rejuvenation
			["enabled"] = true, 
			["id"] = 774, 
			["point"] = "TOPRIGHT", 
			["color"] = {["r"] = 0.8, ["g"] = 0.4, ["b"] = 0.8}, 
			["anyUnit"] = false, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
		{-- Regrowth
			["enabled"] = true, 
			["id"] = 8936, 
			["point"] = "BOTTOMLEFT", 
			["color"] = {["r"] = 0.2, ["g"] = 0.8, ["b"] = 0.2}, 
			["anyUnit"] = false, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
		{-- Lifebloom
			["enabled"] = true, 
			["id"] = 33763, 
			["point"] = "TOPLEFT", 
			["color"] = {["r"] = 0.4, ["g"] = 0.8, ["b"] = 0.2}, 
			["anyUnit"] = false, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
		{-- Wild Growth
			["enabled"] = true, 
			["id"] = 48438, 
			["point"] = "BOTTOMRIGHT", 
			["color"] = {["r"] = 0.8, ["g"] = 0.4, ["b"] = 0}, 
			["anyUnit"] = false, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
	},
	PALADIN = {
		{-- Beacon of Light
			["enabled"] = true, 
			["id"] = 53563, 
			["point"] = "TOPRIGHT", 
			["color"] = {["r"] = 0.7, ["g"] = 0.3, ["b"] = 0.7}, 
			["anyUnit"] = false, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
		{-- Hand of Protection
			["enabled"] = true, 
			["id"] = 1022, 
			["point"] = "BOTTOMRIGHT", 
			["color"] = {["r"] = 0.2, ["g"] = 0.2, ["b"] = 1}, 
			["anyUnit"] = true, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
		{-- Hand of Freedom
			["enabled"] = true, 
			["id"] = 1044, 
			["point"] = "BOTTOMRIGHT", 
			["color"] = {["r"] = 0.89, ["g"] = 0.45, ["b"] = 0}, 
			["anyUnit"] = true, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
		{-- Hand of Salvation
			["enabled"] = true, 
			["id"] = 1038, 
			["point"] = "BOTTOMRIGHT", 
			["color"] = {["r"] = 0.93, ["g"] = 0.75, ["b"] = 0}, 
			["anyUnit"] = true, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
		{-- Hand of Sacrifice
			["enabled"] = true, 
			["id"] = 6940, 
			["point"] = "BOTTOMRIGHT", 
			["color"] = {["r"] = 0.89, ["g"] = 0.1, ["b"] = 0.1}, 
			["anyUnit"] = true, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
		{-- Hand of Purity
			["enabled"] = true, 
			["id"] = 114039, 
			["point"] = "BOTTOMRIGHT", 
			["color"] = {["r"] = 0.64, ["g"] = 0.41, ["b"] = 0.72}, 
			["anyUnit"] = false, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
		{-- Sacred Shield
			["enabled"] = true, 
			["id"] = 20925, 
			["point"] = "TOPLEFT", 
			["color"] = {["r"] = 0.93, ["g"] = 0.75, ["b"] = 0},
			["anyUnit"] = false, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
		{-- Eternal Flame
			["enabled"] = true, 
			["id"] = 114163, 
			["point"] = "BOTTOMLEFT", 
			["color"] = {["r"] = 0.87, ["g"] = 0.7, ["b"] = 0.03}, 
			["anyUnit"] = false, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
	},
	SHAMAN = {
		{-- Riptide
			["enabled"] = true, 
			["id"] = 61295, 
			["point"] = "TOPRIGHT", 
			["color"] = {["r"] = 0.7, ["g"] = 0.3, ["b"] = 0.7}, 
			["anyUnit"] = false, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
		{-- Earth Shield
			["enabled"] = true, 
			["id"] = 974, 
			["point"] = "BOTTOMLEFT", 
			["color"] = {["r"] = 0.2, ["g"] = 0.7, ["b"] = 0.2}, 
			["anyUnit"] = true, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
		{-- Earthliving
			["enabled"] = true, 
			["id"] = 51945, 
			["point"] = "BOTTOMRIGHT", 
			["color"] = {["r"] = 0.7, ["g"] = 0.4, ["b"] = 0.4}, 
			["anyUnit"] = false, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
	},
	MONK = {
		{--Renewing Mist
			["enabled"] = true, 
			["id"] = 119611, 
			["point"] = "TOPLEFT", 
			["color"] = {["r"] = 0.8, ["g"] = 0.4, ["b"] = 0.8}, 
			["anyUnit"] = false, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
		{-- Life Cocoon
			["enabled"] = true, 
			["id"] = 116849, 
			["point"] = "TOPRIGHT", 
			["color"] = {["r"] = 0.2, ["g"] = 0.8, ["b"] = 0.2}, 
			["anyUnit"] = false, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
		{-- Enveloping Mist
			["enabled"] = true, 
			["id"] = 132120, 
			["point"] = "BOTTOMLEFT", 
			["color"] = {["r"] = 0.4, ["g"] = 0.8, ["b"] = 0.2}, 
			["anyUnit"] = false, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
		{-- Zen Sphere
			["enabled"] = true, 
			["id"] = 124081, 
			["point"] = "BOTTOMRIGHT", 
			["color"] = {["r"] = 0.7, ["g"] = 0.4, ["b"] = 0}, 
			["anyUnit"] = false, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
	},
	ROGUE = {
		{-- Tricks of the Trade
			["enabled"] = true, 
			["id"] = 57934, 
			["point"] = "TOPRIGHT", 
			["color"] = {["r"] = 0.89, ["g"] = 0.09, ["b"] = 0.05},
			["anyUnit"] = false, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
	},
	MAGE = {
		{-- Ice Ward
			["enabled"] = true, 
			["id"] = 111264, 
			["point"] = "TOPLEFT", 
			["color"] = {["r"] = 0.2, ["g"] = 0.2, ["b"] = 1}, 
			["anyUnit"] = false, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
	},
	WARRIOR = {
		{-- Vigilance
			["enabled"] = true, 
			["id"] = 114030, 
			["point"] = "TOPLEFT", 
			["color"] = {["r"] = 0.2, ["g"] = 0.2, ["b"] = 1},
			["anyUnit"] = false, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
		{-- Intervene
			["enabled"] = true, 
			["id"] = 3411, 
			["point"] = "TOPRIGHT", 
			["color"] = {["r"] = 0.89, ["g"] = 0.09, ["b"] = 0.05},
			["anyUnit"] = false, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
		{-- Safe Guard
			["enabled"] = true, 
			["id"] = 114029, 
			["point"] = "TOPRIGHT", 
			["color"] = {["r"] = 0.89, ["g"] = 0.09, ["b"] = 0.05},
			["anyUnit"] = false, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
	},
	DEATHKNIGHT = {
		{-- Unholy Frenzy
			["enabled"] = true, 
			["id"] = 49016, 
			["point"] = "TOPRIGHT", 
			["color"] = {["r"] = 0.89, ["g"] = 0.09, ["b"] = 0.05},
			["anyUnit"] = false, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},	
	},
	PET = {
		{-- Frenzy
			["enabled"] = true, 
			["id"] = 19615, 
			["point"] = "TOPLEFT", 
			["color"] = {["r"] = 0.89, ["g"] = 0.09, ["b"] = 0.05},
			["anyUnit"] = true, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
		{-- Mend Pet
			["enabled"] = true, 
			["id"] = 136, 
			["point"] = "TOPRIGHT", 
			["color"] = {["r"] = 0.2, ["g"] = 0.8, ["b"] = 0.2}, 
			["anyUnit"] = true, 
			["onlyShowMissing"] = false, 
			['style'] = 'coloredIcon', 
			['displayText'] = false, 
			['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
			['textThreshold'] = -1, 
			['xOffset'] = 0, 
			['yOffset'] = 0
		},
	}
}

local FilterIDs = {
	["Blocked"] = [[36900,36901,36893,114216,97821,36032,132365,8733,57724,25771,57723,36032,58539,26013,6788,71041,41425,55711,8326,23445,24755,25163,80354,95809,95223,124275,124274,124273,117870,123981,15007,113942,89140]],
	["Allowed"] = [[31821,2825,32182,80353,90355,47788,33206,116849,22812,1490,116202,123059,136431,137332,137375,144351,142863,142864,142865,143198]],
	["Strict"] = [[123059,136431,137332,137375,144351,142863,142864,142865,143198]],
	["CC"] = [[47476,91800,91807,91797,108194,115001,33786,2637,339,78675,22570,5211,9005,102359,99,127797,45334,102795,114238,113004,3355,1513,19503,34490,24394,64803,19386,117405,128405,50519,91644,90337,54706,4167,90327,56626,50245,50541,96201,96201,31661,118,55021,122,82691,118271,44572,33395,102051,20066,10326,853,105593,31935,105421,605,64044,8122,9484,15487,114404,88625,113792,87194,2094,1776,6770,1833,51722,1330,408,88611,115197,113953,51514,64695,63685,76780,118905,118345,710,6789,118699,5484,6358,30283,24259,115782,115268,118093,89766,137143,20511,7922,676,105771,107566,132168,107570,118895,18498,116706,117368,115078,122242,119392,119381,120086,116709,123407,140023,25046,20549,107079]],
	["Shield"] = [[17,47515,45243,45438,115610,48797,48792,49039,87256,55233,50461,33206,47788,62618,47585,104773,110913,108359,22812,102342,106922,61336,19263,53480,1966,31224,74001,5277,45182,98007,30823,108271,1022,6940,114039,31821,498,642,86659,31850,118038,55694,97463,12975,114029,871,114030,120954,131523,122783,122278,115213,116849,20594]],
	["Player"] = [[17,47515,45243,45438,45438,115610,110909,12051,12472,80353,12042,32612,110960,108839,111264,108843,48797,48792,49039,87256,49222,55233,50461,49016,51271,96268,33206,47788,62618,47585,6346,10060,114239,119032,27827,104773,110913,108359,113860,113861,113858,88448,22812,102342,106922,61336,117679,102543,102558,102560,16689,132158,106898,1850,106951,29166,52610,69369,112071,124974,19263,53480,51755,54216,34471,3045,3584,131894,90355,90361,31224,74001,5277,45182,51713,114018,2983,121471,11327,108212,57933,79140,13750,98007,30823,108271,16188,2825,79206,16191,8178,58875,108281,108271,16166,114896,1044,1022,1038,6940,114039,31821,498,642,86659,20925,31850,31884,53563,31842,54428,105809,85499,118038,55694,97463,12975,114029,871,114030,18499,1719,23920,114028,46924,3411,107574,120954,131523,122783,122278,115213,116849,125174,116841,20594,59545,20572,26297,68992]],
	["Raid"] = [[116281,116784,116417,116942,116161,117708,118303,118048,118135,117878,117949,116835,116778,116525,122761,122760,122740,123812,123180,123474,122835,123081,122125,121885,121949,117436,118091,117519,122752,123011,116161,123121,119985,119086,119775,122151,138349,137371,136767,137641,137359,137972,136903,136753,137633,137731,133767,133768,136050,138569,134691,137440,137408,137360,135000,143436,143579,147383,146124,144851,144358,144774,147207,144215,143990,144330,143494,142990,143919,143766,143773,146589,143777,143385,143974,145183]]
}

local FilterOverrides = {
	["45438"] = 5, ["48797"] = 5, ["87256"] = 4, 
	["33206"] = 3, ["47585"] = 5, ["22812"] = 2, 
	["102342"] = 2, ["19263"] = 5, ["5277"] = 5, 
	["1022"] = 5, ["31821"] = 3, ["498"] = 2, 
	["642"] = 5, ["86659"] = 4, ["31850"] = 4, 
	["118038"] = 5, ["114029"] = 2, ["871"] = 3, 
	["120954"] = 2, ["131523"] = 5
}

local FilterDefaults = {
	["CC"] = {},
	["Shield"] = {},
	["Player"] = {},
	["Blocked"] = {},
	["Allowed"] = {},
	["Strict"] = {},
	["Raid"] = {},
	['BuffWatch'] = CLASS_WATCH_INDEX[SuperVillain.class],
	['PetBuffWatch'] = CLASS_WATCH_INDEX.PET,
}

local function safename(id)
	local n = GetSpellInfo(id) 	
	if not n then
		if type(id) == "string" then
			n = id
		else
			print('|cffFF9900SVUI:|r Spell not found: (#ID) '..id)
			n = "Voodoo Doll";
		end
	end
	return n
end

local function tablecopy(d, s)
	if type(s) ~= "table" then return end
	if type(d) == "table" then
		for k, v in pairs(s) do
			if type(v) == "table" then
				if not rawget(d, k) then rawset(d, k, {}) end
				if type(d[k]) == "table" then
					tablecopy(d[k], v)
				end
			else
				if rawget(d, k) == nil then
					rawset(d, k, v)
				end
			end
		end
	end
end

local function setdefaults(t, key)
	local sv = _G["SVUI_Filters"]
	local src = FilterDefaults
	local dest = sv[key]
	if(dest) then
		for k,v in pairs(dest) do
			dest[k] = nil
		end
	else
		sv[key] = {}
	end
	tablecopy(sv[key], src[key])
end

local function getdefaults(t, key)
	return FilterDefaults[key] or {}
end

local function resetfilters(t)
	local sv = _G["SVUI_Filters"]
	local src = FilterDefaults
	for k,v in pairs(sv) do
		sv[k] = nil
	end
	tablecopy(sv, src)
end

local function changefilter(t, k, id, v)
	local sv = _G["SVUI_Filters"]
	local name = safename(id)
	rawset(sv[k], name, v)
end

local metadatabase = { 
	__index = function(t, k)
		local sv = rawget(t, "filters")
		local dv = rawget(t, "defaults")
		local src = dv and dv[k]
		if(not sv[k]) then sv[k] = {} end
		if(src) then
			tablecopy(sv[k], src)
		end
		rawset(t, k, sv[k])
		return rawget(t, k) 
	end
}


local METAFILTERS = function(sv)
	local db 		= setmetatable({}, metadatabase)

	db.filters 		= sv
	db.defaults 	= FilterDefaults
	db.Reset 		= resetprofile
	db.SetDefault 	= setdefaults
	db.Change 		= changefilter

	for k, x in pairs(FilterIDs) do
		local src = {};
		for id in gmatch(x, '([^,]+)') do
			if(id) then
				local saved
				local n = safename(id);
				local p = FilterOverrides[tostring(id)] or 0;
				if k == "Strict" then
					saved = {['enable'] = true, ['spellID'] = id, ['priority'] = p}
				else
					saved = {['enable'] = true, ['priority'] = p}
				end
				src[n] = saved
			end 
		end
		tablecopy(db[k], src)
	end

	return db
end

function SuperVillain:SetFilterObjects(init)
	if(init) then
		self.Filters = FilterDefaults
	else
		local sv = _G["SVUI_Filters"]

		twipe(self.Filters)
		
	    self.Filters = METAFILTERS(sv)
	end
end