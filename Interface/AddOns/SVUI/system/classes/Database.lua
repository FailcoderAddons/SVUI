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
local LSM = LibStub("LibSharedMedia-3.0")
--[[ 
########################################################## 
DEFINE SHARED MEDIA
##########################################################
]]--
LSM:Register("background","SVUI Backdrop 1",[[Interface\AddOns\SVUI\assets\artwork\Template\Background\PATTERN1]])
LSM:Register("background","SVUI Backdrop 2",[[Interface\AddOns\SVUI\assets\artwork\Template\Background\PATTERN2]])
LSM:Register("background","SVUI Backdrop 3",[[Interface\AddOns\SVUI\assets\artwork\Template\Background\PATTERN3]])
LSM:Register("background","SVUI Backdrop 4",[[Interface\AddOns\SVUI\assets\artwork\Template\Background\PATTERN4]])
LSM:Register("background","SVUI Backdrop 5",[[Interface\AddOns\SVUI\assets\artwork\Template\Background\PATTERN5]])
LSM:Register("background","SVUI Comic 1",[[Interface\AddOns\SVUI\assets\artwork\Template\Background\COMIC1]])
LSM:Register("background","SVUI Comic 2",[[Interface\AddOns\SVUI\assets\artwork\Template\Background\COMIC2]])
LSM:Register("background","SVUI Comic 3",[[Interface\AddOns\SVUI\assets\artwork\Template\Background\COMIC3]])
LSM:Register("background","SVUI Comic 4",[[Interface\AddOns\SVUI\assets\artwork\Template\Background\COMIC4]])
LSM:Register("background","SVUI Comic 5",[[Interface\AddOns\SVUI\assets\artwork\Template\Background\COMIC5]])
LSM:Register("background","SVUI Comic 6",[[Interface\AddOns\SVUI\assets\artwork\Template\Background\COMIC6]])
LSM:Register("background","SVUI Unit BG 1",[[Interface\AddOns\SVUI\assets\artwork\Unitframe\Background\UNIT-BG1]])
LSM:Register("background","SVUI Unit BG 2",[[Interface\AddOns\SVUI\assets\artwork\Unitframe\Background\UNIT-BG2]])
LSM:Register("background","SVUI Unit BG 3",[[Interface\AddOns\SVUI\assets\artwork\Unitframe\Background\UNIT-BG3]])
LSM:Register("background","SVUI Unit BG 4",[[Interface\AddOns\SVUI\assets\artwork\Unitframe\Background\UNIT-BG4]])
LSM:Register("background","SVUI Small BG 1",[[Interface\AddOns\SVUI\assets\artwork\Unitframe\Background\UNIT-SMALL-BG1]])
LSM:Register("background","SVUI Small BG 2",[[Interface\AddOns\SVUI\assets\artwork\Unitframe\Background\UNIT-SMALL-BG2]])
LSM:Register("background","SVUI Small BG 3",[[Interface\AddOns\SVUI\assets\artwork\Unitframe\Background\UNIT-SMALL-BG3]])
LSM:Register("background","SVUI Small BG 4",[[Interface\AddOns\SVUI\assets\artwork\Unitframe\Background\UNIT-SMALL-BG4]])
LSM:Register("statusbar","SVUI BasicBar",[[Interface\AddOns\SVUI\assets\artwork\Bars\DEFAULT]])
LSM:Register("statusbar","SVUI MultiColorBar",[[Interface\AddOns\SVUI\assets\artwork\Bars\GRADIENT]])
LSM:Register("statusbar","SVUI SmoothBar",[[Interface\AddOns\SVUI\assets\artwork\Bars\SMOOTH]])
LSM:Register("statusbar","SVUI PlainBar",[[Interface\AddOns\SVUI\assets\artwork\Bars\FLAT]])
LSM:Register("statusbar","SVUI FancyBar",[[Interface\AddOns\SVUI\assets\artwork\Bars\TEXTURED]])
LSM:Register("statusbar","SVUI GlossBar",[[Interface\AddOns\SVUI\assets\artwork\Bars\GLOSS]])
LSM:Register("statusbar","SVUI GlowBar",[[Interface\AddOns\SVUI\assets\artwork\Bars\GLOWING]])
LSM:Register("statusbar","SVUI LazerBar",[[Interface\AddOns\SVUI\assets\artwork\Bars\LAZER]])
LSM:Register("sound", "Whisper Alert", [[Interface\AddOns\SVUI\assets\sounds\whisper.mp3]])
LSM:Register("sound", "Toasty", [[Interface\AddOns\SVUI\assets\sounds\toasty.mp3]])
LSM:Register("font","SVUI Default Font",[[Interface\AddOns\SVUI\assets\fonts\Default.ttf]])
LSM:Register("font","SVUI System Font",[[Interface\AddOns\SVUI\assets\fonts\System.ttf]])
LSM:Register("font","SVUI Dialog Font",[[Interface\AddOns\SVUI\assets\fonts\Dialog.ttf]])
LSM:Register("font","SVUI Narrator Font",[[Interface\AddOns\SVUI\assets\fonts\Narrative.ttf]])
LSM:Register("font","SVUI Number Font",[[Interface\AddOns\SVUI\assets\fonts\Numbers.ttf]])
LSM:Register("font","SVUI Combat Font",[[Interface\AddOns\SVUI\assets\fonts\Combat.ttf]])
LSM:Register("font","SVUI Action Font",[[Interface\AddOns\SVUI\assets\fonts\Action.ttf]])
LSM:Register("font","SVUI Name Font",[[Interface\AddOns\SVUI\assets\fonts\Names.ttf]])
LSM:Register("font","SVUI Alert Font",[[Interface\AddOns\SVUI\assets\fonts\Alert.ttf]])
LSM:Register("font","Roboto",[[Interface\AddOns\SVUI\assets\fonts\Roboto.ttf]],LSM.LOCALE_BIT_ruRU+LSM.LOCALE_BIT_western)
--[[ 
########################################################## 
POPULATE MEDIA TABLE
##########################################################
]]--
do
	local myclass = select(2,UnitClass("player"))
	local cColor1 = SVUI_CLASS_COLORS[myclass]
	local cColor2 = RAID_CLASS_COLORS[myclass]
	local r1,g1,b1 = cColor1.r,cColor1.g,cColor1.b
	local r2,g2,b2 = cColor2.r*.25, cColor2.g*.25, cColor2.b*.25
	local ir1,ig1,ib1 = (1 - r1), (1 - g1), (1 - b1)
	local ir2,ig2,ib2 = (1 - cColor2.r)*.25, (1 - cColor2.g)*.25, (1 - cColor2.b)*.25

	SuperVillain.Media["color"] = {
		["default"] 	= {0.2, 0.2, 0.2, 1}, 
		["special"] 	= {.37, .32, .29, 1},
		["unique"] 		= {0.32, 0.258, 0.21, 1},  
		["class"] 		= {r1, g1, b1, 1},
		["bizzaro"] 	= {ir1, ig1, ib1, 1},
		["dark"] 		= {0, 0, 0, 1}, 
		["light"] 		= {0.95, 0.95, 0.95, 1},
		["highlight"] 	= {0.1, 0.8, 0.8, 1},
		["green"] 		= {0.25, 0.9, 0.08, 1},
		["red"] 		= {0.9, 0.08, 0.08, 1},
		["yellow"] 		= {1, 1, 0, 1},
		["transparent"] = {0, 0, 0, 0.5},
	}

	SuperVillain.Media["font"] = {
		["default"] 	= LSM:Fetch("font", "SVUI Default Font"),
		["system"] 		= LSM:Fetch("font", "SVUI System Font"),
		["combat"] 		= LSM:Fetch("font", "SVUI Combat Font"),
		["dialog"] 		= LSM:Fetch("font", "SVUI Dialog Font"),
		["narrator"] 	= LSM:Fetch("font", "SVUI Narrator Font"),
		["action"] 		= LSM:Fetch("font", "SVUI Action Font"),
		["names"] 		= LSM:Fetch("font", "SVUI Name Font"),
		["alert"] 		= LSM:Fetch("font", "SVUI Alert Font"),
		["numbers"] 	= LSM:Fetch("font", "SVUI Number Font"),
		["roboto"] 		= LSM:Fetch("font", "Roboto")
	}

	SuperVillain.Media["bar"] = { 
		["default"] 	= LSM:Fetch("statusbar", "SVUI BasicBar"), 
		["gradient"] 	= LSM:Fetch("statusbar", "SVUI MultiColorBar"), 
		["smooth"] 		= LSM:Fetch("statusbar", "SVUI SmoothBar"), 
		["flat"] 		= LSM:Fetch("statusbar", "SVUI PlainBar"), 
		["textured"] 	= LSM:Fetch("statusbar", "SVUI FancyBar"), 
		["gloss"] 		= LSM:Fetch("statusbar", "SVUI GlossBar"), 
		["glow"] 		= LSM:Fetch("statusbar", "SVUI GlowBar"),
		["lazer"] 		= LSM:Fetch("statusbar", "SVUI LazerBar"),
	}

	SuperVillain.Media["bg"] = {
		["pattern"] 	= LSM:Fetch("background", "SVUI Backdrop 1"),
		["comic"] 		= LSM:Fetch("background", "SVUI Comic 1"),
		["unitlarge"] 	= LSM:Fetch("background", "SVUI Unit BG 3"), 
		["unitsmall"] 	= LSM:Fetch("background", "SVUI Small BG 3")
	}

	SuperVillain.Media["gradient"] 	= {
		["default"] 	= {"VERTICAL", 0.08, 0.08, 0.08, 0.22, 0.22, 0.22}, 
		["special"] 	= {"VERTICAL", 0.33, 0.25, 0.13, 0.47, 0.39, 0.27}, 
		["class"] 		= {"VERTICAL", r2, g2, b2, r1, g1, b1}, 
		["bizzaro"] 	= {"VERTICAL", ir2, ig2, ib2, ir1, ig1, ib1},
		["dark"] 		= {"VERTICAL", 0.02, 0.02, 0.02, 0.22, 0.22, 0.22}, 
		["light"] 		= {"VERTICAL", 0.65, 0.65, 0.65, 0.95, 0.95, 0.95},
		["highlight"] 	= {"VERTICAL", 0.1, 0.8, 0.8, 0.2, 0.5, 1},
		["green"] 		= {"VERTICAL", 0.08, 0.5, 0, 0.25, 0.9, 0.08}, 
		["red"] 		= {"VERTICAL", 0.5, 0, 0, 0.9, 0.08, 0.08}, 
		["yellow"] 		= {"VERTICAL", 1, 0.3, 0, 1, 1, 0},
		["inverse"] 	= {"VERTICAL", 0.25, 0.25, 0.25, 0.12, 0.12, 0.12},
	}
end
--[[ 
########################################################## 
DB BUILD HELPERS
##########################################################
]]--
local function SpellName(id)
	local name, _, _, _, _, _, _, _, _ = GetSpellInfo(id) 	
	if not name then
		print('|cffFF9900SVUI:|r Spell not found: (#ID) '..id)
		name = "Voodoo Doll";
	end
	return name
end
--[[ 
########################################################## 
DB PROFILE
##########################################################
]]--
local DatabaseDefaults = {
	["framelocations"] = {}, 
	["system"] = {
		["cooldown"] = true, 
		["autoScale"] = true, 
		["taintLog"] = false, 
		["stickyFrames"] = true, 
		["loginmessage"] = true, 
		["hideErrorFrame"] = true, 
		["threatbar"] = false, 
		["bubbles"] = true, 
		["comix"] = true, 
		["questWatch"] = true, 
		["woot"] = true, 
		["pvpinterrupt"] = true, 
		["lookwhaticando"] = false, 
		["sharingiscaring"] = false, 
		["arenadrink"] = true, 
		["stupidhat"] = true, 
		["totems"] = {
			["enable"] = true, 
			["showBy"] = "VERTICAL", 
			["sortDirection"] = "ASCENDING", 
			["size"] = 40, 
			["spacing"] = 4
		}, 
	}, 
	["media"] = {
		["fonts"] = {
			["default"] = "SVUI System Font", 
			["name"] = "SVUI Name Font", 
			["number"] = "SVUI Number Font", 
			["combat"] = "SVUI Combat Font", 
			["giant"] = "SVUI Action Font", 
			["size"] = 10, 
			["unicodeSize"] = 12, 
		}, 
		["textures"] = { 
			["pattern"] 	 = "SVUI Backdrop 1", 
			["comic"] 		 = "SVUI Comic 1", 
			["unitlarge"] 	 = "SVUI Unit BG 3", 
			["unitsmall"] 	 = "SVUI Small BG 3"
		}, 
		["colors"] = {
			["default"] 	 = {0.2, 0.2, 0.2, 1}, 
			["special"] 	 = {.37, .32, .29, 1}, 
		}, 
		["unitframes"] = {
			["health"] 		 = {0.3, 0.5, 0.3}, 
			["power"] 		 = {
				["MANA"] 		 = {0.41, 0.85, 1}, 
				["RAGE"] 		 = {1, 0.31, 0.31}, 
				["FOCUS"] 		 = {1, 0.63, 0.27}, 
				["ENERGY"] 		 = {0.85, 0.83, 0.25}, 
				["RUNES"] 		 = {0.55, 0.57, 0.61}, 
				["RUNIC_POWER"] = {0, 0.82, 1}, 
				["FUEL"] 		 = {0, 0.75, 0.75}
			}, 
			["reaction"] 	 = {
				[1] = {0.92, 0.15, 0.15}, 
				[2] = {0.92, 0.15, 0.15}, 
				[3] = {0.92, 0.15, 0.15}, 
				[4] = {0.85, 0.85, 0.13}, 
				[5] = {0.19, 0.85, 0.13}, 
				[6] = {0.19, 0.85, 0.13}, 
				[7] = {0.19, 0.85, 0.13}, 
				[8] = {0.19, 0.85, 0.13}, 
			}, 
			["Runes"] 		 = {
				[1] = {1, 0, 0}, 
				[2] = {0, 0.5, 0}, 
				[3] = {0, 1, 1}, 
				[4] = {0.9, 0.1, 1}
			}, 
			["MonkHarmony"] = {
				[1] = {0.57, 0.87, 0.35}, 
				[2] = {0.47, 0.87, 0.35}, 
				[3] = {0.37, 0.87, 0.35}, 
				[4] = {0.27, 0.87, 0.33}, 
				[5] = {0.17, 0.87, 0.33}
			}, 
			["WarlockShards"] = {
				[1] = {0.58, 0.51, 0.79}, 
				[2] = {0.58, 0.51, 0.79}, 
				[3] = {1, 0.06, 0}
			}, 
			["tapped"] 			 = {0.55, 0.57, 0.61}, 
			["disconnected"] 	 = {0.84, 0.75, 0.65}, 
			["casting"] 		 = {0.8, 0.8, 0}, 
			["spark"] 			 = {1, 0.72, 0}, 
			["interrupt"] 		 = {0.78, 0.25, 0.25}, 
			["shield_bars"] 	 = {0.56, 0.4, 0.62}, 
			["buff_bars"] 		 = {0.31, 0.31, 0.31}, 
			["debuff_bars"] 	 = {0.8, 0.1, 0.1}, 
			["predict"] 		 = {
				["personal"] 		 = {0, 1, 0.5, 0.25}, 
				["others"] 			 = {0, 1, 0, 0.25}, 
				["absorbs"] 		 = {1, 1, 0, 0.25}
			}, 
			["spellcolor"] = {
				[SpellName(2825)] = {0.98, 0.57, 0.11}, 	--Bloodlust
				[SpellName(32182)] = {0.98, 0.57, 0.11}, --Heroism
				[SpellName(80353)] = {0.98, 0.57, 0.11}, --Time Warp
				[SpellName(90355)] = {0.98, 0.57, 0.11}, --Ancient Hysteria
				[SpellName(84963)] = {0.98, 0.57, 0.11}, --Inquisition
				[SpellName(86659)] = {0.98, 0.57, 0.11}, --Guardian of Ancient Kings
			}
		}
	}, 
	["SVAura"] = {
		["enable"] = true, 
		["disableBlizzard"] = true, 
		["font"] = "SVUI Number Font", 
		["fontSize"] = 12, 
		["fontOutline"] = "THINOUTLINE", 
		["countOffsetV"] = 0, 
		["countOffsetH"] = 0, 
		["timeOffsetV"] = -4, 
		["timeOffsetH"] = 0, 
		["hyperBuffs"] = {
			["enable"] = true, 
			["filter"] = true, 
		}, 
		["fadeBy"] = 5, 
		["buffs"] = {
			["showBy"] = "LEFT_DOWN", 
			["wrapAfter"] = 12, 
			["maxWraps"] = 3, 
			["wrapXOffset"] = 6, 
			["wrapYOffset"] = 16, 
			["sortMethod"] = "TIME", 
			["sortDir"] = "-", 
			["isolate"] = 1, 
			["size"] = 32, 
		}, 
		["debuffs"] = {
			["showBy"] = "LEFT_DOWN", 
			["wrapAfter"] = 12, 
			["maxWraps"] = 1, 
			["wrapXOffset"] = 6, 
			["wrapYOffset"] = 16, 
			["sortMethod"] = "TIME", 
			["sortDir"] = "-", 
			["isolate"] = 1, 
			["size"] = 32, 
		}, 
	}, 
	["SVBag"] = {
		["enable"] = true, 
		["sortInverted"] = false, 
		["xOffset"] = 0, 
		["yOffset"] = 0, 
		["bagSize"] = 34, 
		["bankSize"] = 34, 
		["alignToChat"] = false, 
		["bagWidth"] = 450, 
		["bankWidth"] = 450, 
		["currencyFormat"] = "ICON", 
		["ignoreItems"] = "", 
		["bagTools"] = true, 
		["bagBar"] = {
			["enable"] = false, 
			["showBy"] = "VERTICAL", 
			["sortDirection"] = "ASCENDING", 
			["size"] = 30, 
			["spacing"] = 4, 
			["showBackdrop"] = false, 
			["mouseover"] = false, 
		}, 
	}, 
	["SVBar"] = {
		["enable"] = true, 
		["font"] = "SVUI Number Font", 
		["fontSize"] = 10,  
		["fontOutline"] = "OUTLINE", 
		["cooldownSize"] = 18, 
		["rightClickSelf"] = false, 
		["macrotext"] = false, 
		["hotkeytext"] = false, 
		["hotkeyAbbrev"] = true, 
		["showGrid"] = true, 
		["unc"] = {0.8, 0.1, 0.1, 0.7}, 
		["unpc"] = {0.5, 0.5, 1, 0.7}, 
		["keyDown"] = false, 
		["unlock"] = "SHIFT", 
		["Micro"] = {
			["enable"] = true, 
			["mouseover"] = true, 
			["alpha"] = 1, 
			["buttonsize"] = 30, 
			["buttonspacing"] = 4, 
			["yOffset"] = 4
		}, 
		["Bar1"] = {
			["enable"] = true, 
			["buttons"] = 12, 
			["mouseover"] = false, 
			["buttonsPerRow"] = 12, 
			["point"] = "BOTTOMLEFT", 
			["backdrop"] = false, 
			["buttonsize"] = 32, 
			["buttonspacing"] = 2, 
			["useCustomPaging"] = true, 
			["useCustomVisibility"] = false, 
			["customVisibility"] = "[petbattle] hide; show", 
			["customPaging"] = {
			    ["HUNTER"]  	 = "", 
			    ["WARLOCK"] 	 = "[form:2] 10;", 
			    ["PRIEST"]  	 = "[bonusbar:1] 7;", 
			    ["PALADIN"] 	 = "", 
			    ["MAGE"]    	 = "", 
			    ["ROGUE"]   	 = "[stance:1] 7; [stance:2] 7; [stance:3] 7; [bonusbar:1] 7; [form:3] 7;", 
			    ["DRUID"]   	 = "[bonusbar:1, nostealth] 7; [bonusbar:1, stealth] 8; [bonusbar:2] 8; [bonusbar:3] 9; [bonusbar:4] 10;", 
			    ["SHAMAN"]  	 = "", 
			    ["WARRIOR"] 	 = "", 
			    ["DEATHKNIGHT"]  = "", 
			    ["MONK"]    	 = "[bonusbar:1] 7; [bonusbar:2] 8; [bonusbar:3] 9;", 
			}, 
			["alpha"] = 1
		}, 
		["Bar2"] = {
			["enable"] = false, 
			["mouseover"] = false, 
			["buttons"] = 12, 
			["buttonsPerRow"] = 12, 
			["point"] = "BOTTOMLEFT", 
			["backdrop"] = false, 
			["buttonsize"] = 32, 
			["buttonspacing"] = 2, 
			["useCustomPaging"] = false, 
			["useCustomVisibility"] = false, 
			["customVisibility"] = "[vehicleui] hide; [overridebar] hide; [petbattle] hide; show", 
			["customPaging"] = {
			    ["HUNTER"]  	 = "", 
			    ["WARLOCK"] 	 = "", 
			    ["PRIEST"]  	 = "", 
			    ["PALADIN"] 	 = "", 
			    ["MAGE"]    	 = "", 
			    ["ROGUE"]   	 = "", 
			    ["DRUID"]   	 = "", 
			    ["SHAMAN"]  	 = "", 
			    ["WARRIOR"] 	 = "", 
			    ["DEATHKNIGHT"]  = "", 
			    ["MONK"]    	 = "", 
			}, 
			["alpha"] = 1
		}, 
		["Bar3"] = {
			["enable"] = true, 
			["mouseover"] = false, 
			["buttons"] = 6, 
			["buttonsPerRow"] = 6, 
			["point"] = "BOTTOMLEFT", 
			["backdrop"] = false, 
			["buttonsize"] = 32, 
			["buttonspacing"] = 2, 
			["useCustomPaging"] = false, 
			["useCustomVisibility"] = false, 
			["customVisibility"] = "[vehicleui] hide; [overridebar] hide; [petbattle] hide; show", 
			["customPaging"] = {
			    ["HUNTER"]  	 = "", 
			    ["WARLOCK"] 	 = "", 
			    ["PRIEST"]  	 = "", 
			    ["PALADIN"] 	 = "", 
			    ["MAGE"]    	 = "", 
			    ["ROGUE"]   	 = "", 
			    ["DRUID"]   	 = "", 
			    ["SHAMAN"]  	 = "", 
			    ["WARRIOR"] 	 = "", 
			    ["DEATHKNIGHT"]  = "", 
			    ["MONK"]    	 = "", 
			}, 
			["alpha"] = 1
		}, 
		["Bar4"] = {
			["enable"] = true, 
			["mouseover"] = true, 
			["buttons"] = 12, 
			["buttonsPerRow"] = 1, 
			["point"] = "TOPRIGHT", 
			["backdrop"] = false, 
			["buttonsize"] = 32, 
			["buttonspacing"] = 2, 
			["useCustomPaging"] = false, 
			["useCustomVisibility"] = false, 
			["customVisibility"] = "[vehicleui] hide; [overridebar] hide; [petbattle] hide; show", 
			["customPaging"] = {
			    ["HUNTER"]  	 = "", 
			    ["WARLOCK"] 	 = "", 
			    ["PRIEST"]  	 = "", 
			    ["PALADIN"] 	 = "", 
			    ["MAGE"]    	 = "", 
			    ["ROGUE"]   	 = "", 
			    ["DRUID"]   	 = "", 
			    ["SHAMAN"]  	 = "", 
			    ["WARRIOR"] 	 = "", 
			    ["DEATHKNIGHT"]  = "", 
			    ["MONK"]    	 = "", 
			}, 
			["alpha"] = 1
		}, 
		["Bar5"] = {
			["enable"] = true, 
			["mouseover"] = false, 
			["buttons"] = 6, 
			["buttonsPerRow"] = 6, 
			["point"] = "BOTTOMLEFT", 
			["backdrop"] = false, 
			["buttonsize"] = 32, 
			["buttonspacing"] = 2, 
			["useCustomPaging"] = false, 
			["useCustomVisibility"] = false, 
			["customVisibility"] = "[vehicleui] hide; [overridebar] hide; [petbattle] hide; show", 
			["customPaging"] = {
			    ["HUNTER"]  	 = "", 
			    ["WARLOCK"] 	 = "", 
			    ["PRIEST"]  	 = "", 
			    ["PALADIN"] 	 = "", 
			    ["MAGE"]    	 = "", 
			    ["ROGUE"]   	 = "", 
			    ["DRUID"]   	 = "", 
			    ["SHAMAN"]  	 = "", 
			    ["WARRIOR"] 	 = "", 
			    ["DEATHKNIGHT"]  = "", 
			    ["MONK"]    	 = "", 
			}, 
			["alpha"] = 1
		}, 
		["Bar6"] = {
			["enable"] = false, 
			["mouseover"] = false, 
			["buttons"] = 12, 
			["buttonsPerRow"] = 12, 
			["point"] = "BOTTOMLEFT", 
			["backdrop"] = false, 
			["buttonsize"] = 32, 
			["buttonspacing"] = 2, 
			["useCustomPaging"] = false, 
			["useCustomVisibility"] = false, 
			["customVisibility"] = "[vehicleui] hide; [overridebar] hide; [petbattle] hide; show", 
			["customPaging"] = {
			    ["HUNTER"]  	 = "", 
			    ["WARLOCK"] 	 = "", 
			    ["PRIEST"]  	 = "", 
			    ["PALADIN"] 	 = "", 
			    ["MAGE"]    	 = "", 
			    ["ROGUE"]   	 = "", 
			    ["DRUID"]   	 = "", 
			    ["SHAMAN"]  	 = "", 
			    ["WARRIOR"] 	 = "", 
			    ["DEATHKNIGHT"]  = "", 
			    ["MONK"]    	 = "", 
			}, 
			["alpha"] = 1
		}, 
		["Pet"] = {
			["enable"] = true, 
			["mouseover"] = false, 
			["buttons"] = NUM_PET_ACTION_SLOTS, 
			["buttonsPerRow"] = NUM_PET_ACTION_SLOTS, 
			["point"] = "TOPLEFT", 
			["backdrop"] = false, 
			["buttonsize"] = 24, 
			["buttonspacing"] = 3, 
			["useCustomVisibility"] = false, 
			["customVisibility"] = "[petbattle] hide;[pet, novehicleui, nooverridebar, nopossessbar] show;hide", 
			["alpha"] = 1
		}, 
		["Stance"] = {
			["enable"] = true, 
			["style"] = "darkenInactive", 
			["mouseover"] = false, 
			["buttons"] = NUM_STANCE_SLOTS, 
			["buttonsPerRow"] = NUM_STANCE_SLOTS, 
			["point"] = "BOTTOMRIGHT", 
			["backdrop"] = false, 
			["buttonsize"] = 24, 
			["buttonspacing"] = 5, 
			["alpha"] = 1
		}, 
	}, 
	["SVChat"] = {
		["enable"] = true, 
		["tabHeight"] = 20, 
		["tabWidth"] = 75, 
		["tabStyled"] = true, 
		["font"] = "Roboto", 
		["fontOutline"] = "OUTLINE", 
		["tabFont"] = "SVUI Alert Font", 
		["tabFontSize"] = 10, 
		["tabFontOutline"] = "OUTLINE", 
		["url"] = true, 
		["shortChannels"] = true, 
		["hyperlinkHover"] = true, 
		["throttleInterval"] = 45, 
		["fade"] = false, 
		["sticky"] = true, 
		["smileys"] = true, 
		["secretWordTone"] = "None", 
		["psst"] = "Whisper Alert", 
		["noWipe"] = false, 
		["timeStampFormat"] = "NONE", 
		["secretWords"] = "%MYNAME%, SVUI", 
		["basicTools"] = true, 
		["saveChats"] = false, 
	}, 
	["SVDock"] = {
		["enable"] = true, 
		["dockLeftWidth"] = 412, 
		["dockLeftHeight"] = 224, 
		["dockRightWidth"] = 412, 
		["dockRightHeight"] = 224, 
		["buttonSize"] = 30, 
		["buttonSpacing"] = 4, 
		["leftDockBackdrop"] = true, 
		["rightDockBackdrop"] = true, 
		["topPanel"] = true, 
		["bottomPanel"] = true, 
		["docklets"] = {
			["DockletMain"] = "None", 
			["MainWindow"] = "None", 
			["DockletExtra"] = "None", 
			["ExtraWindow"] = "None", 
			["enableExtra"] = false, 
			["DockletCombatFade"] = true
		}, 
	}, 
	["SVGear"] = {
		["enable"] = true, 
		["specialization"] = {
			["enable"] = false, 
		}, 
		["battleground"] = {
			["enable"] = false, 
		}, 
		["primary"] = "none", 
		["secondary"] = "none", 
		["equipmentset"] = "none", 
		["durability"] = {
			["enable"] = true, 
			["onlydamaged"] = true, 
		}, 
		["itemlevel"] = {
			["enable"] = true, 
		}, 
		["misc"] = {
			setoverlay = true, 
		}
	}, 
	["SVHenchmen"] = {
		["enable"] = true, 
		["answeringServiceEnable"] = false, 
		["autoRoll"] = false, 
		["autoRepair"] = "PLAYER", 
		["vendorGrays"] = true, 
		["autoAcceptInvite"] = false, 
		["autorepchange"] = false, 
		["pvpautorelease"] = false, 
		["autoquestcomplete"] = false, 
		["autoquestreward"] = false, 
		["autoquestaccept"] = false, 
		["autodailyquests"] = false, 
		["autopvpquests"] = false, 
		["skipcinematics"] = false, 
		["mailOpener"] = true, 
		["answeringService"] = {
			["autoAnswer"] = false, 
			["prefix"] = true
		}
	}, 
	["SVLaborer"] = {
		["enable"] = true, 
		["fontSize"] = 12, 
		["farming"] = {
			["buttonsize"] = 35, 
			["buttonspacing"] = 3, 
			["onlyactive"] = false, 
			["droptools"] = true, 
			["toolbardirection"] = "HORIZONTAL", 
		}, 
		["fishing"] = {
			["autoequip"] = true, 
		}, 
		["cooking"] = {
			["autoequip"] = true, 
		}, 
	}, 
	["SVMap"] = {
		["enable"] = true, 
		["mapAlpha"] = 1, 
		["tinyWorldMap"] = true, 
		["size"] = 240, 
		["customshape"] = true, 
		["locationText"] = "CUSTOM", 
		["playercoords"] = "CUSTOM", 
		["bordersize"] = 6, 
		["bordercolor"] = "light", 
		["minimapbar"] = {
			["enable"] = true, 
			["styleType"] = "HORIZONTAL", 
			["layoutDirection"] = "NORMAL", 
			["buttonSize"] = 28, 
			["mouseover"] = false, 
		}, 
	}, 
	["SVOverride"] = {
		["enable"] = true, 
		["loot"] = true, 
		["lootRoll"] = true, 
		["lootRollWidth"] = 328, 
		["lootRollHeight"] = 28, 
	}, 
	["SVPlate"] = {
		["enable"] = true, 
		["filter"] = {}, 
		["font"] = "SVUI Name Font", 
		["fontSize"] = 10, 
		["fontOutline"] = "OUTLINE", 
		["comboPoints"] = true, 
		["nonTargetAlpha"] = 0.6, 
		["combatHide"] = false, 
		["colorNameByValue"] = true, 
		["showthreat"] = true, 
		["targetcount"] = true, 
		["pointer"] = {
			["enable"] = true, 
			["colorMatchHealthBar"] = true, 
			["color"] = {0.7, 0, 1}, 
		}, 
		["healthBar"] = {
			["lowThreshold"] = 0.4, 
			["width"] = 108, 
			["height"] = 9, 
			["text"] = {
				["enable"] = false, 
				["format"] = "CURRENT", 
				["xOffset"] = 0, 
				["yOffset"] = 0, 
				["attachTo"] = "CENTER", 
			}, 
		}, 
		["castBar"] = {
			["height"] = 6, 
			["color"] = {1, 0.81, 0}, 
			["noInterrupt"] = {0.78, 0.25, 0.25}, 
		}, 
		["raidHealIcon"] = {
			["xOffset"] =  -4, 
			["yOffset"] = 6, 
			["size"] = 36, 
			["attachTo"] = "LEFT", 
		}, 
		["threat"] = {
			["enable"] = true, 
			["goodScale"] = 1, 
			["badScale"] = 1, 
			["goodColor"] = {0.29, 0.68, 0.3}, 
			["badColor"] = {0.78, 0.25, 0.25}, 
			["goodTransitionColor"] = {0.85, 0.77, 0.36}, 
			["badTransitionColor"] = {0.94, 0.6, 0.06}, 
		}, 
		["auras"] = {
			["font"] = "SVUI Number Font", 
			["fontSize"] = 7, 
			["fontOutline"] = "OUTLINE", 
			["numAuras"] = 5, 
			["additionalFilter"] = "CC"
		}, 
		["reactions"] = {
			["tapped"] = {0.6, 0.6, 0.6}, 
			["friendlyNPC"] = { 0.31, 0.45, 0.63}, 
			["friendlyPlayer"] = {0.29, 0.68, 0.3}, 
			["neutral"] = {0.85, 0.77, 0.36}, 
			["enemy"] = {0.78, 0.25, 0.25}, 
		}, 
	}, 
	["SVStats"] = {
		["enable"] = true, 
		["font"] = "SVUI Number Font", 
		["fontSize"] = 12, 
		["fontOutline"] = "OUTLINE", 
		["panels"] = {
			["BottomRightDataPanel"] = {
				["right"] = "Bags", 
				["left"] = "Friends", 
				["middle"] = "Guild", 
			}, 
			["BottomLeftDataPanel"] = {
				["left"] = "Time", 
				["middle"] = "System", 	
				["right"] = "Gold", 
			}, 
			["TopLeftDataPanel"] = {
				["left"] = "Durability Bar", 
				["middle"] = "Reputation Bar", 
				["right"] = "Experience Bar", 
			}, 
		}, 
		["localtime"] = true, 
		["time24"] = false, 
		["battleground"] = true, 
		["topLeftDockPanel"] = true, 
		["bottomLeftDockPanel"] = true, 
		["bottomRightDockPanel"] = true, 
		["panelTransparency"] = false, 
	}, 
	["SVTip"] = {
		["enable"] = true, 
		["cursorAnchor"] = false, 
		["targetInfo"] = true, 
		["playerTitles"] = true, 
		["guildRanks"] = true, 
		["inspectInfo"] = true, 
		["itemCount"] = true, 
		["spellID"] = true, 
		["progressInfo"] = true, 
		["visibility"] = {
			["unitFrames"] = "NONE", 
			["combat"] = false, 
		}, 
		["healthBar"] = {
			["text"] = true, 
			["height"] = 7, 
			["font"] = "Roboto", 
			["fontSize"] = 10, 
		}, 
	}, 
	["SVUnit"] = {
		["enable"] = true, 
		["disableBlizzard"] = true, 

		["smoothbars"] = false, 
		["statusbar"] = "SVUI BasicBar", 
		["auraBarStatusbar"] = "SVUI GlowBar", 

		["font"] = "SVUI Number Font", 
		["fontSize"] = 12, 
		["fontOutline"] = "OUTLINE", 

		["auraFont"] = "SVUI Alert Font", 
		["auraFontSize"] = 12, 
		["auraFontOutline"] = "OUTLINE", 

		["OORAlpha"] = 0.65, 
		["combatFadeRoles"] = true, 
		["combatFadeNames"] = true, 
		["debuffHighlighting"] = true, 
		["smartRaidFilter"] = true, 
		["fastClickTarget"] = false, 
		["healglow"] = true, 
		["glowtime"] = 0.8, 
		["glowcolor"] = {1, 1, 0}, 
		["autoRoleSet"] = false, 
		["healthclass"] = true, 
		["forceHealthColor"] = false, 
		["overlayAnimation"] = true, 
		["powerclass"] = false, 
		["colorhealthbyvalue"] = true, 
		["customhealthbackdrop"] = true, 
		["classbackdrop"] = false, 
		["auraBarByType"] = true, 
		["auraBarShield"] = true, 
		["castClassColor"] = false, 
		["xrayFocus"] = true, 
		["player"] = {
			["enable"] = true, 
			["width"] = 235, 
			["height"] = 70, 
			["lowmana"] = 30, 
			["combatfade"] = false, 
			["predict"] = true, 
			["threatEnabled"] = true, 
			["playerExpBar"] = false, 
			["playerRepBar"] = false, 
			["formatting"] = {
				["power_colored"] = true, 
				["power_type"] = "none", 
				["power_class"] = false, 
				["power_alt"] = false, 
				["health_colored"] = true, 
				["health_type"] = "current", 
				["name_colored"] = true, 
				["name_length"] = 21, 
				["smartlevel"] = false, 
				["absorbs"] = false, 
				["threat"] = false, 
				["incoming"] = false, 
				["yOffset"] = 0, 
				["xOffset"] = 0, 
			}, 
			["misc"] = {
				["tags"] = ""
			}, 
			["health"] = 
			{
				["tags"] = "[health:color][health:current]", 
				["position"] = "INNERRIGHT", 
				["xOffset"] = 0, 
				["yOffset"] = 0, 
				["reversed"] = false, 
				["font"] = "SVUI Number Font", 
				["fontSize"] = 11, 
				["fontOutline"] = "OUTLINE", 
			}, 
			["power"] = 
			{
				["enable"] = true, 
				["tags"] = "", 
				["height"] = 15, 
				["position"] = "INNERLEFT", 
				["hideonnpc"] = false, 
				["xOffset"] = 0, 
				["yOffset"] = 0, 
				["detachFromFrame"] = false, 
				["detachedWidth"] = 250, 
				["attachTextToPower"] = false, 
				["druidMana"] = true, 
				["font"] = "SVUI Number Font", 
				["fontSize"] = 11, 
				["fontOutline"] = "OUTLINE", 
			}, 
			["name"] = 
			{
				["position"] = "CENTER", 
				["tags"] = "", 
				["xOffset"] = 0, 
				["yOffset"] = 0, 
				["font"] = "SVUI Number Font", 
				["fontSize"] = 13, 
				["fontOutline"] = "OUTLINE", 
			}, 
			["pvp"] = 
			{
				["font"] = "SVUI Number Font", 
				["fontSize"] = 12, 
				["fontOutline"] = "OUTLINE", 
				["position"] = "BOTTOM", 
				["tags"] = "||cFFB04F4F[pvptimer][mouseover]||r", 
				["xOffset"] = 0, 
				["yOffset"] = 0, 
			}, 
			["portrait"] = 
			{
				["enable"] = true, 
				["width"] = 50, 
				["overlay"] = true, 
				["camDistanceScale"] = 1.4, 
				["rotation"] = 0, 
				["style"] = "3D", 
			}, 
			["buffs"] = 
			{
				["enable"] = false, 
				["perrow"] = 8, 
				["numrows"] = 1, 
				["attachTo"] = "DEBUFFS", 
				["anchorPoint"] = "TOPLEFT", 
				["verticalGrowth"] = "UP", 
				["horizontalGrowth"] = "RIGHT", 
				["filterPlayer"] = true, 
				["filterRaid"] = true, 
				["filterBlocked"] = true, 
				["filterAllowed"] = true, 
				["filterInfinite"] = true, 
				["filterDispellable"] = false, 
				["useFilter"] = "", 
				["xOffset"] = 0, 
				["yOffset"] = 8, 
				["sizeOverride"] = 0, 
			}, 
			["debuffs"] = 
			{
				["enable"] = true, 
				["perrow"] = 8, 
				["numrows"] = 1, 
				["attachTo"] = "FRAME", 
				["anchorPoint"] = "TOPLEFT", 
				["verticalGrowth"] = "UP", 
				["horizontalGrowth"] = "RIGHT", 
				["filterPlayer"] = false, 
				["filterBlocked"] = true, 
				["filterAllowed"] = false, 
				["filterInfinite"] = false, 
				["filterDispellable"] = false, 
				["useFilter"] = "", 
				["xOffset"] =  0, 
				["yOffset"] = 8, 
				["sizeOverride"] = 0, 
			}, 
			["aurabar"] = 
			{
				["enable"] = false, 
				["anchorPoint"] = "ABOVE", 
				["attachTo"] = "DEBUFFS", 
				["filterPlayer"] = true, 
				["filterRaid"] = true, 
				["filterBlocked"] = true, 
				["filterAllowed"] = true, 
				["filterInfinite"] = true, 
				["filterDispellable"] = false, 
				["useFilter"] = "", 
				["friendlyAuraType"] = "HELPFUL", 
				["enemyAuraType"] = "HARMFUL", 
				["height"] = 18, 
				["sort"] = "TIME_REMAINING", 
			}, 
			["castbar"] = 
			{
				["enable"] = true, 
				["width"] = 235, 
				["height"] = 20, 
				["detachFromFrame"] = false, 
				["icon"] = true, 
				["latency"] = false, 
				["format"] = "REMAINING", 
				["ticks"] = false, 
				["spark"] = true, 
				["displayTarget"] = false, 
				["useCustomColor"] = false, 
				["castingColor"] = {0.8, 0.8, 0}, 
				["sparkColor"] = {1, 0.72, 0}, 
			}, 
			["classbar"] = 
			{
				["enable"] = true, 
				["slideLeft"] = true, 
				["inset"] = "inset", 
				["height"] = 30, 
				["detachFromFrame"] = false, 
				["detachedWidth"] = 250, 
			}, 
			["icons"] = 
			{
				["raidicon"] = 
				{
					["enable"] = true, 
					["size"] = 30, 
					["attachTo"] = "INNERRIGHT", 
					["xOffset"] = 0, 
					["yOffset"] = 0, 
				}, 
				["combatIcon"] = {
					["enable"] = true, 
					["size"] = 26, 
					["attachTo"] = "INNERTOPRIGHT", 
					["xOffset"] = 0, 
					["yOffset"] = 0, 
				}, 
				["restIcon"] = {
					["enable"] = true, 
					["size"] = 26, 
					["attachTo"] = "INNERTOPRIGHT", 
					["xOffset"] = 0, 
					["yOffset"] = 0, 
				}, 
			}, 
			["stagger"] = 
			{
				["enable"] = true, 
			}, 
		}, 
		["target"] = {
			["enable"] = true, 
			["width"] = 235, 
			["height"] = 70, 
			["threatEnabled"] = true, 
			["rangeCheck"] = true, 
			["predict"] = true, 
			["smartAuraDisplay"] = "DISABLED", 
			["middleClickFocus"] = true, 
			["formatting"] = {
				["power_colored"] = true, 
				["power_type"] = "none", 
				["power_class"] = false, 
				["power_alt"] = false, 
				["health_colored"] = true, 
				["health_type"] = "current", 
				["name_colored"] = true, 
				["name_length"] = 18, 
				["smartlevel"] = false, 
				["absorbs"] = false, 
				["threat"] = false, 
				["incoming"] = false, 
				["yOffset"] = 0, 
				["xOffset"] = 0, 
			}, 
			["misc"] = {
				["tags"] = ""
			}, 
			["health"] = 
			{
				["tags"] = "[health:color][health:current]", 
				["position"] = "INNERLEFT", 
				["xOffset"] = 0, 
				["yOffset"] = 0, 
				["reversed"] = true, 
				["font"] = "SVUI Number Font", 
				["fontSize"] = 11, 
				["fontOutline"] = "OUTLINE", 
			}, 
			["power"] = 
			{
				["enable"] = true, 
				["tags"] = "", 
				["height"] = 13, 
				["position"] = "CENTER", 
				["hideonnpc"] = true, 
				["xOffset"] = 0, 
				["yOffset"] = 0, 
				["attachTextToPower"] = false, 
				["font"] = "SVUI Number Font", 
				["fontSize"] = 11, 
				["fontOutline"] = "OUTLINE", 
			}, 
			["name"] = 
			{
				["position"] = "INNERRIGHT", 
				["tags"] = "[name:color][name:18] [name:level]", 
				["xOffset"] = 0, 
				["yOffset"] = 0, 
				["font"] = "SVUI Number Font", 
				["fontSize"] = 13, 
				["fontOutline"] = "OUTLINE", 
			}, 
			["portrait"] = 
			{
				["enable"] = true, 
				["width"] = 50, 
				["overlay"] = true, 
				["rotation"] = 0, 
				["camDistanceScale"] = 1.4, 
				["style"] = "3D", 
			}, 
			["buffs"] = 
			{
				["enable"] = true, 
				["perrow"] = 8, 
				["numrows"] = 1, 
				["attachTo"] = "FRAME", 
				["anchorPoint"] = "TOPRIGHT", 
				["verticalGrowth"] = "UP", 
				["horizontalGrowth"] = "LEFT", 
				["filterPlayer"] = 
				{
					friendly = false, 
					enemy = false, 
				}, 
				["filterRaid"] = 
				{
					friendly = false, 
					enemy = false, 
				}, 
				["filterBlocked"] = 
				{
					friendly = true, 
					enemy = true, 
				}, 
				["filterAllowed"] = 
				{
					friendly = false, 
					enemy = false, 
				}, 
				["filterInfinite"] = 
				{
					friendly = false, 
					enemy = false, 
				}, 
				["filterDispellable"] = 
				{
					friendly = false, 
					enemy = false, 
				}, 
				["useFilter"] = "", 
				["xOffset"] = 0, 
				["yOffset"] = 8, 
				["sizeOverride"] = 0, 
			}, 
			["debuffs"] = 
			{
				["enable"] = true, 
				["perrow"] = 8, 
				["numrows"] = 1, 
				["attachTo"] = "BUFFS", 
				["anchorPoint"] = "TOPRIGHT", 
				["verticalGrowth"] = "UP", 
				["horizontalGrowth"] = "LEFT", 
				["filterPlayer"] = 
				{
					friendly = false, 
					enemy = true, 
				}, 
				["filterBlocked"] = 
				{
					friendly = true, 
					enemy = true, 
				}, 
				["filterAllowed"] = 
				{
					friendly = false, 
					enemy = false, 
				}, 
				["filterInfinite"] = 
				{
					friendly = false, 
					enemy = false, 
				}, 
				["filterDispellable"] = 
				{
					friendly = false, 
					enemy = false, 
				}, 
				["useFilter"] = "", 
				["xOffset"] = 0, 
				["yOffset"] = 8, 
				["sizeOverride"] = 0, 
			}, 
			["aurabar"] = 
			{
				["enable"] = false, 
				["anchorPoint"] = "ABOVE", 
				["attachTo"] = "DEBUFFS", 
				["filterPlayer"] = 
				{
					friendly = true, 
					enemy = true, 
				}, 
				["filterBlocked"] = 
				{
					friendly = true, 
					enemy = true, 
				}, 
				["filterAllowed"] = 
				{
					friendly = false, 
					enemy = false, 
				}, 
				["filterInfinite"] = 
				{
					friendly = true, 
					enemy = true, 
				}, 
				["filterRaid"] = 
				{
					friendly = true, 
					enemy = true, 
				}, 
				["filterDispellable"] = 
				{
					friendly = false, 
					enemy = false, 
				}, 
				["useFilter"] = "", 
				["friendlyAuraType"] = "HELPFUL", 
				["enemyAuraType"] = "HARMFUL", 
				["height"] = 18, 
				["sort"] = "TIME_REMAINING", 
			}, 
			["castbar"] = 
			{
				["enable"] = true, 
				["width"] = 235, 
				["height"] = 20, 
				["detachFromFrame"] = false, 
				["icon"] = true, 
				["format"] = "REMAINING", 
				["spark"] = true, 
				["useCustomColor"] = false, 
				["castingColor"] = {0.8, 0.8, 0}, 
				["sparkColor"] = {1, 0.72, 0}, 
			}, 
			["combobar"] = 
			{
				["enable"] = true, 
				["height"] = 30, 
				["smallIcons"] = false, 
				["hudStyle"] = false, 
				["hudScale"] = 64, 
				["autoHide"] = true, 
			}, 
			["icons"] = 
			{
				["raidicon"] = 
				{
					["enable"] = true, 
					["size"] = 30, 
					["attachTo"] = "INNERLEFT", 
					["xOffset"] = 0, 
					["yOffset"] = 0, 
				}
			}, 
		}, 
		["targettarget"] = {
			["enable"] = true, 
			["rangeCheck"] = true, 
			["threatEnabled"] = false, 
			["width"] = 150, 
			["height"] = 30, 
			["formatting"] = {
				["power_colored"] = true, 
				["power_type"] = "none", 
				["power_class"] = false, 
				["power_alt"] = false, 
				["health_colored"] = true, 
				["health_type"] = "none", 
				["name_colored"] = true, 
				["name_length"] = 10, 
				["smartlevel"] = false, 
				["absorbs"] = false, 
				["threat"] = false, 
				["incoming"] = false, 
				["yOffset"] = 0, 
				["xOffset"] = 0, 
			}, 
			["misc"] = {
				["tags"] = ""
			}, 
			["health"] = 
			{ 
				["tags"] = "", 
				["position"] = "INNERRIGHT", 
				["xOffset"] = 0, 
				["yOffset"] = 0, 
				["reversed"] = false, 
				["font"] = "SVUI Number Font", 
				["fontSize"] = 9, 
				["fontOutline"] = "OUTLINE", 
			}, 
			["power"] = 
			{
				["enable"] = false, 
				["tags"] = "", 
				["height"] = 7, 
				["position"] = "INNERLEFT", 
				["hideonnpc"] = false, 
				["xOffset"] = 0, 
				["yOffset"] = 0, 
				["font"] = "SVUI Number Font", 
				["fontSize"] = 9, 
				["fontOutline"] = "OUTLINE", 
			}, 
			["name"] = 
			{
				["position"] = "CENTER", 
				["tags"] = "[name:color][name:10]", 
				["xOffset"] = 0, 
				["yOffset"] = 1, 
				["font"] = "SVUI Narrator Font", 
				["fontSize"] = 14, 
				["fontOutline"] = "OUTLINE", 
			}, 
			["portrait"] = 
			{
				["enable"] = true, 
				["width"] = 45, 
				["overlay"] = true, 
				["rotation"] = 0, 
				["camDistanceScale"] = 1, 
				["style"] = "3D", 
			}, 
			["buffs"] = 
			{
				["enable"] = false, 
				["perrow"] = 7, 
				["numrows"] = 1, 
				["attachTo"] = "FRAME", 
				["anchorPoint"] = "BOTTOMLEFT", 
				["verticalGrowth"] = "DOWN", 
				["horizontalGrowth"] = "RIGHT", 
				["filterPlayer"] = 
				{
					friendly = true, 
					enemy = false, 
				}, 
				["filterRaid"] = 
				{
					friendly = true, 
					enemy = false, 
				}, 
				["filterBlocked"] = 
				{
					friendly = true, 
					enemy = true, 
				}, 
				["filterAllowed"] = 
				{
					friendly = false, 
					enemy = false, 
				}, 
				["filterInfinite"] = 
				{
					friendly = true, 
					enemy = false, 
				}, 
				["filterDispellable"] = 
				{
					friendly = false, 
					enemy = false, 
				}, 
				["useFilter"] = "", 
				["xOffset"] =  0, 
				["yOffset"] =  -8, 
				["sizeOverride"] = 0, 
			}, 
			["debuffs"] = 
			{
				["enable"] = false, 
				["perrow"] = 5, 
				["numrows"] = 1, 
				["attachTo"] = "FRAME", 
				["anchorPoint"] = "TOPLEFT", 
				["verticalGrowth"] = "UP", 
				["horizontalGrowth"] = "RIGHT", 
				["filterPlayer"] = 
				{
					friendly = false, 
					enemy = true, 
				}, 
				["filterBlocked"] = 
				{
					friendly = true, 
					enemy = true, 
				}, 
				["filterAllowed"] = 
				{
					friendly = false, 
					enemy = false, 
				}, 
				["filterInfinite"] = 
				{
					friendly = false, 
					enemy = false, 
				}, 
				["filterDispellable"] = 
				{
					friendly = false, 
					enemy = false, 
				}, 
				["useFilter"] = "", 
				["xOffset"] =  0, 
				["yOffset"] =  8, 
				["sizeOverride"] = 0, 
			}, 
			["icons"] = 
			{
				["raidicon"] = 
				{
					["enable"] = true, 
					["size"] = 18, 
					["attachTo"] = "INNERRIGHT", 
					["xOffset"] = 0, 
					["yOffset"] = 0, 
				}, 
			}, 
		}, 
		["focus"] = {
			["enable"] = true, 
			["rangeCheck"] = true, 
			["threatEnabled"] = true, 
			["width"] = 170, 
			["height"] = 30, 
			["predict"] = false, 
			["smartAuraDisplay"] = "DISABLED", 
			["formatting"] = {
				["power_colored"] = true, 
				["power_type"] = "none", 
				["power_class"] = false, 
				["power_alt"] = false, 
				["health_colored"] = true, 
				["health_type"] = "none", 
				["name_colored"] = true, 
				["name_length"] = 15, 
				["smartlevel"] = false, 
				["absorbs"] = false, 
				["threat"] = false, 
				["incoming"] = false, 
				["yOffset"] = 0, 
				["xOffset"] = 0, 
			}, 
			["misc"] = {
				["tags"] = ""
			}, 
			["health"] = 
			{ 
				["tags"] = "", 
				["position"] = "INNERRIGHT", 
				["xOffset"] = 0, 
				["yOffset"] = 0, 
				["reversed"] = false, 
				["font"] = "SVUI Number Font", 
				["fontSize"] = 10, 
				["fontOutline"] = "OUTLINE", 
			}, 
			["power"] = 
			{
				["enable"] = true, 
				["tags"] = "", 
				["height"] = 7, 
				["position"] = "INNERLEFT", 
				["hideonnpc"] = false, 
				["xOffset"] = 0, 
				["yOffset"] = 0, 
				["font"] = "SVUI Number Font", 
				["fontSize"] = 10, 
				["fontOutline"] = "OUTLINE", 
			}, 
			["name"] = 
			{
				["position"] = "CENTER", 
				["tags"] = "[name:color][name:15]", 
				["xOffset"] = 0, 
				["yOffset"] = 0, 
				["font"] = "SVUI Narrator Font", 
				["fontSize"] = 14, 
				["fontOutline"] = "OUTLINE", 
			}, 
			["buffs"] = 
			{
				["enable"] = false, 
				["perrow"] = 7, 
				["numrows"] = 1, 
				["attachTo"] = "FRAME", 
				["anchorPoint"] = "BOTTOMRIGHT", 
				["verticalGrowth"] = "DOWN", 
				["horizontalGrowth"] = "LEFT", 
				["filterPlayer"] = 
				{
					friendly = true, 
					enemy = false, 
				}, 
				["filterRaid"] = 
				{
					friendly = true, 
					enemy = false, 
				}, 
				["filterBlocked"] = 
				{
					friendly = true, 
					enemy = true, 
				}, 
				["filterAllowed"] = 
				{
					friendly = false, 
					enemy = false, 
				}, 
				["filterInfinite"] = 
				{
					friendly = true, 
					enemy = false, 
				}, 
				["filterDispellable"] = 
				{
					friendly = false, 
					enemy = false, 
				}, 
				["useFilter"] = "", 
				["xOffset"] = 0, 
				["yOffset"] = -8, 
				["sizeOverride"] = 0, 
			}, 
			["debuffs"] = 
			{
				["enable"] = true, 
				["perrow"] = 5, 
				["numrows"] = 1, 
				["attachTo"] = "FRAME", 
				["anchorPoint"] = "TOPRIGHT", 
				["verticalGrowth"] = "UP", 
				["horizontalGrowth"] = "LEFT", 
				["filterPlayer"] = 
				{
					friendly = false, 
					enemy = true, 
				}, 
				["filterBlocked"] = 
				{
					friendly = true, 
					enemy = true, 
				}, 
				["filterAllowed"] = 
				{
					friendly = false, 
					enemy = false, 
				}, 
				["filterInfinite"] = 
				{
					friendly = false, 
					enemy = false, 
				}, 
				["filterDispellable"] = 
				{
					friendly = false, 
					enemy = false, 
				}, 
				["useFilter"] = "", 
				["xOffset"] = 0, 
				["yOffset"] = 8, 
				["sizeOverride"] = 0, 
			}, 
			["castbar"] = 
			{
				["enable"] = true, 
				["width"] = 170, 
				["height"] = 18, 
				["icon"] = true, 
				["format"] = "REMAINING", 
				["spark"] = true, 
				["useCustomColor"] = false, 
				["castingColor"] = {0.8, 0.8, 0}, 
				["sparkColor"] = {1, 0.72, 0}, 
			}, 
			["aurabar"] = 
			{
				["enable"] = false, 
				["anchorPoint"] = "ABOVE", 
				["attachTo"] = "FRAME", 
				["filterPlayer"] = 
				{
					friendly = false, 
					enemy = true, 
				}, 
				["filterBlocked"] = 
				{
					friendly = true, 
					enemy = true, 
				}, 
				["filterAllowed"] = 
				{
					friendly = false, 
					enemy = false, 
				}, 
				["filterInfinite"] = 
				{
					friendly = false, 
					enemy = false, 
				}, 
				["filterDispellable"] = 
				{
					friendly = false, 
					enemy = false, 
				}, 
				["filterRaid"] = 
				{
					friendly = true, 
					enemy = true, 
				}, 
				["useFilter"] = "", 
				["friendlyAuraType"] = "HELPFUL", 
				["enemyAuraType"] = "HARMFUL", 
				["height"] = 18, 
				["sort"] = "TIME_REMAINING", 
			}, 
			["icons"] = 
			{
				["raidicon"] = 
				{
					["enable"] = true, 
					["size"] = 18, 
					["attachTo"] = "INNERLEFT", 
					["xOffset"] = 0, 
					["yOffset"] = 0, 
				}, 
			}, 
		}, 
		["focustarget"] = {
			["enable"] = false, 
			["rangeCheck"] = true, 
			["threatEnabled"] = false, 
			["width"] = 150, 
			["height"] = 26, 
			["formatting"] = {
				["power_colored"] = true, 
				["power_type"] = "none", 
				["power_class"] = false, 
				["power_alt"] = false, 
				["health_colored"] = true, 
				["health_type"] = "none", 
				["name_colored"] = true, 
				["name_length"] = 15, 
				["smartlevel"] = false, 
				["absorbs"] = false, 
				["threat"] = false, 
				["incoming"] = false, 
				["yOffset"] = 0, 
				["xOffset"] = 0, 
			}, 
			["misc"] = {
				["tags"] = ""
			}, 
			["health"] = 
			{ 
				["tags"] = "", 
				["position"] = "INNERRIGHT", 
				["xOffset"] = 0, 
				["yOffset"] = 0, 
				["reversed"] = false, 
				["font"] = "SVUI Number Font", 
				["fontSize"] = 10, 
				["fontOutline"] = "OUTLINE", 
			}, 
			["power"] = 
			{
				["enable"] = false, 
				["tags"] = "", 
				["height"] = 7, 
				["position"] = "INNERLEFT", 
				["hideonnpc"] = false, 
				["xOffset"] = 0, 
				["yOffset"] = 0, 
				["font"] = "SVUI Number Font", 
				["fontSize"] = 10, 
				["fontOutline"] = "OUTLINE", 
			}, 
			["name"] = 
			{
				["position"] = "CENTER", 
				["tags"] = "[name:color][name:15]", 
				["yOffset"] = 0, 
				["xOffset"] = 0, 
				["font"] = "SVUI Narrator Font", 
				["fontSize"] = 14, 
				["fontOutline"] = "OUTLINE", 
			}, 
			["buffs"] = 
			{
				["enable"] = false, 
				["perrow"] = 7, 
				["numrows"] = 1, 
				["attachTo"] = "FRAME", 
				["anchorPoint"] = "BOTTOMLEFT", 
				["verticalGrowth"] = "DOWN", 
				["horizontalGrowth"] = "RIGHT", 
				["filterPlayer"] = 
				{
					friendly = true, 
					enemy = false, 
				}, 
				["filterRaid"] = 
				{
					friendly = true, 
					enemy = false, 
				}, 
				["filterBlocked"] = 
				{
					friendly = true, 
					enemy = true, 
				}, 
				["filterAllowed"] = 
				{
					friendly = false, 
					enemy = false, 
				}, 
				["filterInfinite"] = 
				{
					friendly = true, 
					enemy = false, 
				}, 
				["filterDispellable"] = 
				{
					friendly = false, 
					enemy = false, 
				}, 
				["useFilter"] = "", 
				["xOffset"] = 0, 
				["yOffset"] = -8, 
				["sizeOverride"] = 0, 
			}, 
			["debuffs"] = 
			{
				["enable"] = false, 
				["perrow"] = 5, 
				["numrows"] = 1, 
				["attachTo"] = "FRAME", 
				["anchorPoint"] = "TOPLEFT", 
				["verticalGrowth"] = "UP", 
				["horizontalGrowth"] = "RIGHT", 
				["filterPlayer"] = 
				{
					friendly = false, 
					enemy = true, 
				}, 
				["filterBlocked"] = 
				{
					friendly = true, 
					enemy = true, 
				}, 
				["filterAllowed"] = 
				{
					friendly = false, 
					enemy = false, 
				}, 
				["filterInfinite"] = 
				{
					friendly = false, 
					enemy = false, 
				}, 
				["filterDispellable"] = 
				{
					friendly = false, 
					enemy = false, 
				}, 
				["useFilter"] = "", 
				["xOffset"] = 0, 
				["yOffset"] = 8, 
				["sizeOverride"] = 0, 
			}, 
			["icons"] = 
			{
				["raidicon"] = 
				{
					["enable"] = true, 
					["size"] = 18, 
					["attachTo"] = "INNERLEFT", 
					["xOffset"] = 0, 
					["yOffset"] = 0, 
				}, 
			}, 
		}, 
		["pet"] = {
			["enable"] = true, 
			["rangeCheck"] = true, 
			["threatEnabled"] = true, 
			["width"] = 150, 
			["height"] = 30, 
			["predict"] = false, 
			["formatting"] = {
				["power_colored"] = true, 
				["power_type"] = "none", 
				["power_class"] = false, 
				["power_alt"] = false, 
				["health_colored"] = true, 
				["health_type"] = "none", 
				["name_colored"] = true, 
				["name_length"] = 10, 
				["smartlevel"] = false, 
				["absorbs"] = false, 
				["threat"] = false, 
				["incoming"] = false, 
				["yOffset"] = 0, 
				["xOffset"] = 0, 
			}, 
			["misc"] = {
				["tags"] = ""
			}, 
			["health"] = 
			{ 
				["tags"] = "", 
				["position"] = "INNERRIGHT", 
				["yOffset"] = 0, 
				["xOffset"] = 0, 
				["reversed"] = false, 
				["font"] = "SVUI Number Font", 
				["fontSize"] = 10, 
				["fontOutline"] = "OUTLINE", 
			}, 
			["power"] = 
			{
				["enable"] = false, 
				["tags"] = "", 
				["height"] = 7, 
				["position"] = "INNERLEFT", 
				["hideonnpc"] = false, 
				["yOffset"] = 0, 
				["xOffset"] = 0, 
				["font"] = "SVUI Number Font", 
				["fontSize"] = 10, 
				["fontOutline"] = "OUTLINE", 
			}, 
			["name"] = 
			{
				["position"] = "CENTER", 
				["tags"] = "[name:color][name:8]", 
				["yOffset"] = 0, 
				["xOffset"] = 0, 
				["font"] = "SVUI Narrator Font", 
				["fontSize"] = 14, 
				["fontOutline"] = "OUTLINE", 
			}, 
			["portrait"] = 
			{
				["enable"] = true, 
				["width"] = 45, 
				["overlay"] = true, 
				["rotation"] = 0, 
				["camDistanceScale"] = 1, 
				["style"] = "3D", 
			}, 
			["buffs"] = 
			{
				["enable"] = true, 
				["perrow"] = 3, 
				["numrows"] = 1, 
				["attachTo"] = "FRAME", 
				["anchorPoint"] = "LEFT", 
				["verticalGrowth"] = "DOWN", 
				["horizontalGrowth"] = "LEFT", 
				["filterPlayer"] = true, 
				["filterRaid"] = true, 
				["filterBlocked"] = true, 
				["filterAllowed"] = true, 
				["filterInfinite"] = true, 
				["filterDispellable"] = false, 
				["useFilter"] = "", 
				["xOffset"] = -3, 
				["yOffset"] = 0, 
				["sizeOverride"] = 0, 
			}, 
			["debuffs"] = 
			{
				["enable"] = true, 
				["perrow"] = 3, 
				["numrows"] = 1, 
				["attachTo"] = "FRAME", 
				["anchorPoint"] = "RIGHT", 
				["verticalGrowth"] = "DOWN", 
				["horizontalGrowth"] = "RIGHT", 
				["filterPlayer"] = false, 
				["filterBlocked"] = true, 
				["filterAllowed"] = false, 
				["filterInfinite"] = false, 
				["filterDispellable"] = false, 
				["useFilter"] = "", 
				["xOffset"] = 3, 
				["yOffset"] = 0, 
				["sizeOverride"] = 0, 
			}, 
			["castbar"] = 
			{
				["enable"] = true, 
				["width"] = 130, 
				["height"] = 8, 
				["icon"] = false, 
				["format"] = "REMAINING", 
				["spark"] = false, 
				["useCustomColor"] = false, 
				["castingColor"] = {0.8, 0.8, 0}, 
				["sparkColor"] = {1, 0.72, 0}, 
			}, 
			["buffIndicator"] = 
			{
				["enable"] = true, 
				["size"] = 8, 
			}, 
		}, 
		["pettarget"] = {
			["enable"] = false, 
			["rangeCheck"] = true, 
			["threatEnabled"] = false, 
			["width"] = 130, 
			["height"] = 26, 
			["formatting"] = {
				["power_colored"] = true, 
				["power_type"] = "none", 
				["power_class"] = false, 
				["power_alt"] = false, 
				["health_colored"] = true, 
				["health_type"] = "none", 
				["name_colored"] = true, 
				["name_length"] = 15, 
				["smartlevel"] = false, 
				["absorbs"] = false, 
				["threat"] = false, 
				["incoming"] = false, 
				["yOffset"] = 0, 
				["xOffset"] = 0, 
			}, 
			["misc"] = {
				["tags"] = ""
			}, 
			["health"] = 
			{ 
				["tags"] = "", 
				["position"] = "INNERRIGHT", 
				["yOffset"] = 0, 
				["xOffset"] = 0, 
				["reversed"] = false, 
				["font"] = "SVUI Number Font", 
				["fontSize"] = 10, 
				["fontOutline"] = "OUTLINE", 
			}, 
			["power"] = 
			{
				["enable"] = false, 
				["tags"] = "", 
				["height"] = 7, 
				["position"] = "INNERLEFT", 
				["hideonnpc"] = false, 
				["yOffset"] = 0, 
				["xOffset"] = 0, 
				["font"] = "SVUI Number Font", 
				["fontSize"] = 10, 
				["fontOutline"] = "OUTLINE", 
			}, 
			["name"] = 
			{
				["position"] = "CENTER", 
				["tags"] = "[name:color][name:15]", 
				["yOffset"] = 0, 
				["xOffset"] = 0, 
				["font"] = "SVUI Narrator Font", 
				["fontSize"] = 14, 
				["fontOutline"] = "OUTLINE", 
			}, 
			["buffs"] = 
			{
				["enable"] = false, 
				["perrow"] = 7, 
				["numrows"] = 1, 
				["attachTo"] = "FRAME", 
				["anchorPoint"] = "BOTTOMLEFT", 
				["verticalGrowth"] = "DOWN", 
				["horizontalGrowth"] = "RIGHT", 
				["filterPlayer"] = 
				{
					friendly = true, 
					enemy = false, 
				}, 
				["filterRaid"] = 
				{
					friendly = true, 
					enemy = false, 
				}, 
				["filterBlocked"] = 
				{
					friendly = true, 
					enemy = true, 
				}, 
				["filterAllowed"] = 
				{
					friendly = false, 
					enemy = false, 
				}, 
				["filterInfinite"] = 
				{
					friendly = true, 
					enemy = false, 
				}, 
				["filterDispellable"] = 
				{
					friendly = false, 
					enemy = false, 
				}, 
				["useFilter"] = "", 
				["xOffset"] = 0, 
				["yOffset"] = -8, 
				["sizeOverride"] = 0, 
			}, 
			["debuffs"] = 
			{
				["enable"] = false, 
				["perrow"] = 5, 
				["numrows"] = 1, 
				["attachTo"] = "FRAME", 
				["anchorPoint"] = "BOTTOMRIGHT", 
				["verticalGrowth"] = "DOWN", 
				["horizontalGrowth"] = "LEFT", 
				["filterPlayer"] = 
				{
					friendly = false, 
					enemy = true, 
				}, 
				["filterBlocked"] = 
				{
					friendly = true, 
					enemy = true, 
				}, 
				["filterAllowed"] = 
				{
					friendly = false, 
					enemy = false, 
				}, 
				["filterInfinite"] = 
				{
					friendly = false, 
					enemy = false, 
				}, 
				["filterDispellable"] = 
				{
					friendly = false, 
					enemy = false, 
				}, 
				["useFilter"] = "", 
				["xOffset"] = 0, 
				["yOffset"] = 8, 
				["sizeOverride"] = 0, 
			}, 
		}, 
		["boss"] = {
			["enable"] = true, 
			["rangeCheck"] = true, 
			["showBy"] = "UP", 
			["width"] = 200, 
			["height"] = 45, 
			["formatting"] = {
				["power_colored"] = true, 
				["power_type"] = "none", 
				["power_class"] = false, 
				["power_alt"] = false, 
				["health_colored"] = true, 
				["health_type"] = "current", 
				["name_colored"] = true, 
				["name_length"] = 15, 
				["smartlevel"] = false, 
				["absorbs"] = false, 
				["threat"] = false, 
				["incoming"] = false, 
				["yOffset"] = 0, 
				["xOffset"] = 0, 
			}, 
			["misc"] = {
				["tags"] = ""
			}, 
			["health"] = 
			{
				["tags"] = "[health:color][health:current]", 
				["position"] = "INNERTOPRIGHT", 
				["yOffset"] = 0, 
				["xOffset"] = 0, 
				["reversed"] = true, 
				["font"] = "SVUI Number Font", 
				["fontSize"] = 10, 
				["fontOutline"] = "OUTLINE", 
			}, 
			["power"] = 
			{
				["enable"] = true, 
				["tags"] = "[power:color][power:current]", 
				["height"] = 7, 
				["position"] = "INNERBOTTOMRIGHT", 
				["hideonnpc"] = false, 
				["yOffset"] = 7, 
				["xOffset"] = 0, 
				["font"] = "SVUI Number Font", 
				["fontSize"] = 10, 
				["fontOutline"] = "OUTLINE", 
			}, 
			["portrait"] = 
			{
				["enable"] = true, 
				["width"] = 35, 
				["overlay"] = true, 
				["rotation"] = 0, 
				["camDistanceScale"] = 1, 
				["style"] = "3D", 
			}, 
			["name"] = 
			{
				["position"] = "INNERLEFT", 
				["tags"] = "[name:color][name:15]", 
				["yOffset"] = 0, 
				["xOffset"] = 0, 
				["font"] = "SVUI Number Font", 
				["fontSize"] = 12, 
				["fontOutline"] = "OUTLINE", 
			}, 
			["buffs"] = 
			{
				["enable"] = true, 
				["perrow"] = 2, 
				["numrows"] = 1, 
				["attachTo"] = "FRAME", 
				["anchorPoint"] = "LEFT", 
				["verticalGrowth"] = "UP", 
				["horizontalGrowth"] = "LEFT", 
				["filterPlayer"] = false, 
				["filterRaid"] = false, 
				["filterBlocked"] = true, 
				["filterAllowed"] = false, 
				["filterInfinite"] = false, 
				["filterDispellable"] = false, 
				["useFilter"] = "", 
				["xOffset"] =  -8, 
				["yOffset"] =  0, 
				["sizeOverride"] = 40, 
			}, 
			["debuffs"] = 
			{
				["enable"] = true, 
				["perrow"] = 3, 
				["numrows"] = 1, 
				["attachTo"] = "BUFFS", 
				["anchorPoint"] = "LEFT", 
				["verticalGrowth"] = "UP", 
				["horizontalGrowth"] = "LEFT", 
				["filterPlayer"] = true, 
				["filterBlocked"] = true, 
				["filterAllowed"] = false, 
				["filterInfinite"] = false, 
				["filterDispellable"] = false, 
				["useFilter"] = "", 
				["xOffset"] =  -8, 
				["yOffset"] =  0, 
				["sizeOverride"] = 40, 
			}, 
			["castbar"] = 
			{
				["enable"] = true, 
				["width"] = 200, 
				["height"] = 18, 
				["icon"] = true, 
				["format"] = "REMAINING", 
				["spark"] = true, 
				["useCustomColor"] = false, 
				["castingColor"] = {0.8, 0.8, 0}, 
				["sparkColor"] = {1, 0.72, 0}, 
			}, 
			["icons"] = 
			{
				["raidicon"] = 
				{
					["enable"] = true, 
					["size"] = 22, 
					["attachTo"] = "CENTER", 
					["xOffset"] = 0, 
					["yOffset"] = 0, 
				}, 
			}, 
		}, 
		["arena"] = {
			["enable"] = true, 
			["rangeCheck"] = true, 
			["showBy"] = "UP", 
			["width"] = 215, 
			["height"] = 45, 
			["pvpSpecIcon"] = true, 
			["predict"] = false, 
			["colorOverride"] = "USE_DEFAULT", 
			["formatting"] = {
				["power_colored"] = true, 
				["power_type"] = "none", 
				["power_class"] = false, 
				["power_alt"] = false, 
				["health_colored"] = true, 
				["health_type"] = "current", 
				["name_colored"] = true, 
				["name_length"] = 15, 
				["smartlevel"] = false, 
				["absorbs"] = false, 
				["threat"] = false, 
				["incoming"] = false, 
				["yOffset"] = 0, 
				["xOffset"] = 0, 
			}, 
			["misc"] = {
				["tags"] = ""
			}, 
			["health"] = 
			{
				["tags"] = "[health:color][health:current]", 
				["position"] = "INNERTOPRIGHT", 
				["yOffset"] = 0, 
				["xOffset"] = 0, 
				["reversed"] = true, 
				["font"] = "SVUI Number Font", 
				["fontSize"] = 10, 
				["fontOutline"] = "OUTLINE", 
			}, 
			["power"] = 
			{
				["enable"] = true, 
				["tags"] = "[power:color][power:current]", 
				["height"] = 7, 
				["position"] = "INNERBOTTOMRIGHT", 
				["hideonnpc"] = false, 
				["yOffset"] = 7, 
				["xOffset"] = 0, 
				["font"] = "SVUI Number Font", 
				["fontSize"] = 10, 
				["fontOutline"] = "OUTLINE", 
			}, 
			["name"] = 
			{
				["position"] = "INNERLEFT", 
				["tags"] = "[name:color][name:15]", 
				["yOffset"] = 0, 
				["xOffset"] = 0, 
				["font"] = "SVUI Number Font", 
				["fontSize"] = 12, 
				["fontOutline"] = "OUTLINE", 
			}, 
			["portrait"] = 
			{
				["enable"] = true, 
				["width"] = 45, 
				["overlay"] = true, 
				["rotation"] = 0, 
				["camDistanceScale"] = 1, 
				["style"] = "3D", 
			}, 
			["buffs"] = 
			{
				["enable"] = true, 
				["perrow"] = 3, 
				["numrows"] = 1, 
				["attachTo"] = "FRAME", 
				["anchorPoint"] = "LEFT", 
				["verticalGrowth"] = "UP", 
				["horizontalGrowth"] = "LEFT", 
				["filterPlayer"] = 
				{
					friendly = false, 
					enemy = false, 
				}, 
				["filterRaid"] = 
				{
					friendly = false, 
					enemy = false, 
				}, 
				["filterBlocked"] = 
				{
					friendly = false, 
					enemy = false, 
				}, 
				["filterAllowed"] = 
				{
					friendly = false, 
					enemy = false, 
				}, 
				["filterInfinite"] = 
				{
					friendly = false, 
					enemy = false, 
				}, 
				["useFilter"] = "Shield", 
				["filterDispellable"] = 
				{
					friendly = false, 
					enemy = false, 
				}, 
				["xOffset"] = -8, 
				["yOffset"] = 0, 
				["sizeOverride"] = 40, 
			}, 
			["debuffs"] = 
			{
				["enable"] = true, 
				["perrow"] = 3, 
				["numrows"] = 1, 
				["attachTo"] = "FRAME", 
				["anchorPoint"] = "LEFT", 
				["verticalGrowth"] = "UP", 
				["horizontalGrowth"] = "LEFT", 
				["filterPlayer"] = 
				{
					friendly = false, 
					enemy = false, 
				}, 
				["filterBlocked"] = 
				{
					friendly = false, 
					enemy = false, 
				}, 
				["filterAllowed"] = 
				{
					friendly = false, 
					enemy = false, 
				}, 
				["filterInfinite"] = 
				{
					friendly = false, 
					enemy = false, 
				}, 
				["useFilter"] = "CC", 
				["filterDispellable"] = 
				{
					friendly = false, 
					enemy = false, 
				}, 
				["xOffset"] = -8, 
				["yOffset"] = 0, 
				["sizeOverride"] = 40, 
			}, 
			["castbar"] = 
			{
				["enable"] = true, 
				["width"] = 215, 
				["height"] = 18, 
				["icon"] = true, 
				["format"] = "REMAINING", 
				["spark"] = true, 
				["useCustomColor"] = false, 
				["castingColor"] = {0.8, 0.8, 0}, 
				["sparkColor"] = {1, 0.72, 0}, 
			}, 
			["pvpTrinket"] = 
			{
				["enable"] = true, 
				["position"] = "LEFT", 
				["size"] = 45, 
				["xOffset"] = 0, 
				["yOffset"] = 0, 
			}, 
		}, 
		["party"] = {
			["enable"] = true, 
			["rangeCheck"] = true, 
			["threatEnabled"] = true, 
			["visibility"] = "[@raid6, exists][nogroup] hide;show", 
			["showBy"] = "UP_RIGHT", 
			["wrapXOffset"] = 9, 
			["wrapYOffset"] = 13, 
			["gCount"] = 1, 
			["gRowCol"] = 1, 
			["sortMethod"] = "GROUP", 
			["sortDir"] = "ASC", 
			["rSort"] = false, 
			["invertGroupingOrder"] = false, 
			["startFromCenter"] = false, 
			["showPlayer"] = true, 
			["predict"] = false, 
			["colorOverride"] = "USE_DEFAULT", 
			["gridMode"] = false, 
			["width"] = 70, 
			["height"] = 70, 
			["formatting"] = {
				["power_colored"] = true, 
				["power_type"] = "none", 
				["power_class"] = false, 
				["power_alt"] = false, 
				["health_colored"] = true, 
				["health_type"] = "none", 
				["name_colored"] = true, 
				["name_length"] = 10, 
				["smartlevel"] = false, 
				["absorbs"] = false, 
				["threat"] = false, 
				["incoming"] = false, 
				["yOffset"] = 0, 
				["xOffset"] = 0, 
			}, 
			["misc"] = {
				["tags"] = ""
			}, 
			["health"] = 
			{ 
				["tags"] = "", 
				["position"] = "BOTTOM", 
				["orientation"] = "HORIZONTAL", 
				["frequentUpdates"] = false, 
				["yOffset"] = 0, 
				["xOffset"] = 0, 
				["reversed"] = false, 
				["font"] = "SVUI Number Font", 
				["fontSize"] = 10, 
				["fontOutline"] = "OUTLINE", 
			}, 
			["power"] = 
			{
				["enable"] = true, 
				["tags"] = "", 
				["frequentUpdates"] = false, 
				["height"] = 7, 
				["position"] = "BOTTOMRIGHT", 
				["hideonnpc"] = false, 
				["yOffset"] = 0, 
				["xOffset"] = 0, 
				["font"] = "SVUI Number Font", 
				["fontSize"] = 10, 
				["fontOutline"] = "OUTLINE", 
			}, 
			["name"] = 
			{
				["position"] = "INNERTOPLEFT", 
				["tags"] = "[name:color][name:10]", 
				["yOffset"] = 0, 
				["xOffset"] = 0, 
				["font"] = "SVUI Narrator Font", 
				["fontSize"] = 13, 
				["fontOutline"] = "OUTLINE", 
			}, 
			["buffs"] = 
			{
				["enable"] = false, 
				["perrow"] = 2, 
				["numrows"] = 2, 
				["attachTo"] = "FRAME", 
				["anchorPoint"] = "RIGHTTOP", 
				["verticalGrowth"] = "DOWN", 
				["horizontalGrowth"] = "RIGHT", 
				["filterPlayer"] = true, 
				["filterRaid"] = true, 
				["filterBlocked"] = true, 
				["filterAllowed"] = false, 
				["filterInfinite"] = true, 
				["filterDispellable"] = false, 
				["useFilter"] = "", 
				["xOffset"] = 8, 
				["yOffset"] = 0, 
				["sizeOverride"] = 0, 
			}, 
			["debuffs"] = 
			{
				["enable"] = true, 
				["perrow"] = 2, 
				["numrows"] = 2, 
				["attachTo"] = "FRAME", 
				["anchorPoint"] = "RIGHTTOP", 
				["verticalGrowth"] = "DOWN", 
				["horizontalGrowth"] = "RIGHT", 
				["filterPlayer"] = false, 
				["filterBlocked"] = true, 
				["filterAllowed"] = false, 
				["filterInfinite"] = false, 
				["filterDispellable"] = false, 
				["useFilter"] = "", 
				["xOffset"] = 8, 
				["yOffset"] = 0, 
				["sizeOverride"] = 0, 
			}, 
			["buffIndicator"] = 
			{
				["enable"] = true, 
				["size"] = 8, 
				["fontSize"] = 11, 
			}, 
			["petsGroup"] = 
			{
				["enable"] = false, 
				["width"] = 30, 
				["height"] = 30, 
				["anchorPoint"] = "BOTTOMLEFT", 
				["xOffset"] =  - 1, 
				["yOffset"] = 0, 
				["name_length"] = 3, 
				["tags"] = "[name:3]", 
			}, 
			["targetsGroup"] = 
			{
				["enable"] = false, 
				["width"] = 30, 
				["height"] = 30, 
				["anchorPoint"] = "TOPLEFT", 
				["xOffset"] =  - 1, 
				["yOffset"] = 0, 
				["name_length"] = 3, 
				["tags"] = "[name:3]", 
			}, 
			["icons"] = 
			{
				["raidicon"] = 
				{
					["enable"] = true, 
					["size"] = 25, 
					["attachTo"] = "INNERBOTTOMLEFT", 
					["xOffset"] = 0, 
					["yOffset"] = 0, 
				}, 
				["roleIcon"] = 
				{
					["enable"] = true, 
					["size"] = 18, 
					["attachTo"] = "INNERBOTTOMRIGHT", 
					["xOffset"] = 0, 
					["yOffset"] = 0, 
				}, 
				["raidRoleIcons"] = 
				{
					["enable"] = true, 
					["size"] = 18, 
					["attachTo"] = "TOPLEFT", 
					["xOffset"] = 0, 
					["yOffset"] = -4, 
				}, 
			}, 
			["portrait"] = 
			{
				["enable"] = true, 
				["width"] = 45, 
				["overlay"] = true, 
				["rotation"] = 0, 
				["camDistanceScale"] = 1, 
				["style"] = "3D", 
			}, 
		}, 
		["raid10"] = {
			["enable"] = true, 
			["rangeCheck"] = true, 
			["threatEnabled"] = true, 
			["visibility"] = "[@raid6, noexists][@raid11, exists][nogroup] hide;show", 
			["showBy"] = "RIGHT_DOWN", 
			["wrapXOffset"] = 8, 
			["wrapYOffset"] = 8, 
			["gCount"] = 2, 
			["gRowCol"] = 1, 
			["sortMethod"] = "GROUP", 
			["sortDir"] = "ASC", 
			["showPlayer"] = true, 
			["predict"] = false, 
			["colorOverride"] = "USE_DEFAULT", 
			["gridMode"] = false, 
			["width"] = 75, 
			["height"] = 34, 
			["formatting"] = {
				["power_colored"] = true, 
				["power_type"] = "none", 
				["power_class"] = false, 
				["power_alt"] = false, 
				["health_colored"] = true, 
				["health_type"] = "none", 
				["name_colored"] = true, 
				["name_length"] = 4, 
				["smartlevel"] = false, 
				["absorbs"] = false, 
				["threat"] = false, 
				["incoming"] = false, 
				["yOffset"] = 0, 
				["xOffset"] = 0, 
			}, 
			["misc"] = {
				["tags"] = ""
			}, 
			["health"] = 
			{ 
				["tags"] = "", 
				["position"] = "BOTTOM", 
				["orientation"] = "HORIZONTAL", 
				["frequentUpdates"] = false, 
				["yOffset"] = 0, 
				["xOffset"] = 0, 
				["reversed"] = false, 
				["font"] = "SVUI Default Font", 
				["fontSize"] = 10, 
				["fontOutline"] = "OUTLINE", 
			}, 
			["power"] = 
			{
				["enable"] = true, 
				["tags"] = "", 
				["frequentUpdates"] = false, 
				["height"] = 4, 
				["position"] = "BOTTOMRIGHT", 
				["hideonnpc"] = false, 
				["yOffset"] = 0, 
				["xOffset"] = 0, 
				["font"] = "SVUI Default Font", 
				["fontSize"] = 10, 
				["fontOutline"] = "OUTLINE", 
			}, 
			["name"] = 
			{
				["position"] = "INNERTOPLEFT", 
				["tags"] = "[name:color][name:4]", 
				["yOffset"] = 0, 
				["xOffset"] = 0, 
				["font"] = "SVUI Default Font", 
				["fontSize"] = 10, 
				["fontOutline"] = "OUTLINE", 
			}, 
			["buffs"] = 
			{
				["enable"] = false, 
				["perrow"] = 3, 
				["numrows"] = 1, 
				["attachTo"] = "FRAME", 
				["anchorPoint"] = "RIGHT", 
				["verticalGrowth"] = "UP", 
				["horizontalGrowth"] = "RIGHT", 
				["filterPlayer"] = true, 
				["filterRaid"] = true, 
				["filterBlocked"] = true, 
				["filterAllowed"] = false, 
				["filterInfinite"] = true, 
				["filterDispellable"] = false, 
				["useFilter"] = "", 
				["xOffset"] = 8, 
				["yOffset"] = 0, 
				["sizeOverride"] = 0, 
			}, 
			["debuffs"] = 
			{
				["enable"] = false, 
				["perrow"] = 3, 
				["numrows"] = 1, 
				["attachTo"] = "FRAME", 
				["anchorPoint"] = "RIGHT", 
				["verticalGrowth"] = "UP", 
				["horizontalGrowth"] = "RIGHT", 
				["filterPlayer"] = false, 
				["filterBlocked"] = true, 
				["filterAllowed"] = false, 
				["filterInfinite"] = false, 
				["filterDispellable"] = false, 
				["useFilter"] = "", 
				["xOffset"] = 8, 
				["yOffset"] = 0, 
				["sizeOverride"] = 0, 
			}, 
			["buffIndicator"] = 
			{
				["enable"] = true, 
				["size"] = 8, 
			}, 
			["rdebuffs"] = 
			{
				["enable"] = true, 
				["size"] = 26, 
				["xOffset"] = 0, 
				["yOffset"] = 2, 
			}, 
			["icons"] = 
			{
				["raidicon"] = 
				{
					["enable"] = true, 
					["size"] = 15, 
					["attachTo"] = "INNERBOTTOMRIGHT", 
					["xOffset"] = 0, 
					["yOffset"] = 0, 
				}, 
				["roleIcon"] = 
				{
					["enable"] = true, 
					["size"] = 12, 
					["attachTo"] = "INNERBOTTOMLEFT", 
					["xOffset"] = 0, 
					["yOffset"] = 0, 
				}, 
				["raidRoleIcons"] = 
				{
					["enable"] = true, 
					["size"] = 18, 
					["attachTo"] = "TOPLEFT", 
					["xOffset"] = 0, 
					["yOffset"] = -4, 
				}, 
			}, 
		}, 
		["raid25"] = {
			["enable"] = true, 
			["rangeCheck"] = true, 
			["threatEnabled"] = true, 
			["visibility"] = "[@raid6, noexists][@raid11, noexists][@raid26, exists][nogroup] hide;show", 
			["showBy"] = "RIGHT_DOWN", 
			["wrapXOffset"] = 8, 
			["wrapYOffset"] = 8, 
			["gCount"] = 5, 
			["gRowCol"] = 1, 
			["sortMethod"] = "GROUP", 
			["sortDir"] = "ASC", 
			["showPlayer"] = true, 
			["predict"] = false, 
			["colorOverride"] = "USE_DEFAULT", 
			["gridMode"] = false, 
			["width"] = 50, 
			["height"] = 30, 
			["formatting"] = {
				["power_colored"] = true, 
				["power_type"] = "none", 
				["power_class"] = false, 
				["power_alt"] = false, 
				["health_colored"] = true, 
				["health_type"] = "none", 
				["name_colored"] = true, 
				["name_length"] = 4, 
				["smartlevel"] = false, 
				["absorbs"] = false, 
				["threat"] = false, 
				["incoming"] = false, 
				["yOffset"] = 0, 
				["xOffset"] = 0, 
			}, 
			["misc"] = {
				["tags"] = ""
			}, 
			["health"] = 
			{ 
				["tags"] = "", 
				["position"] = "BOTTOM", 
				["orientation"] = "HORIZONTAL", 
				["frequentUpdates"] = false, 
				["yOffset"] = 0, 
				["xOffset"] = 0, 
				["reversed"] = false, 
				["font"] = "SVUI Default Font", 
				["fontSize"] = 10, 
				["fontOutline"] = "OUTLINE", 
			}, 
			["power"] = 
			{
				["enable"] = true, 
				["tags"] = "", 
				["height"] = 4, 
				["position"] = "BOTTOMRIGHT", 
				["hideonnpc"] = false, 
				["yOffset"] = 0, 
				["xOffset"] = 0, 
				["font"] = "SVUI Default Font", 
				["fontSize"] = 10, 
				["fontOutline"] = "OUTLINE", 
			}, 
			["name"] = 
			{
				["position"] = "INNERTOPLEFT", 
				["tags"] = "[name:color][name:4]", 
				["yOffset"] = 0, 
				["xOffset"] = 0, 
				["font"] = "SVUI Default Font", 
				["fontSize"] = 10, 
				["fontOutline"] = "OUTLINE", 
			}, 
			["buffs"] = 
			{
				["enable"] = false, 
				["perrow"] = 3, 
				["numrows"] = 1, 
				["attachTo"] = "FRAME", 
				["anchorPoint"] = "RIGHT", 
				["verticalGrowth"] = "UP", 
				["horizontalGrowth"] = "RIGHT", 
				["filterPlayer"] = true, 
				["filterRaid"] = true, 
				["filterBlocked"] = true, 
				["filterAllowed"] = false, 
				["filterInfinite"] = true, 
				["filterDispellable"] = false, 
				["useFilter"] = "", 
				["xOffset"] = 8, 
				["yOffset"] = 0, 
				["sizeOverride"] = 0, 
			}, 
			["debuffs"] = 
			{
				["enable"] = false, 
				["perrow"] = 3, 
				["numrows"] = 1, 
				["attachTo"] = "FRAME", 
				["anchorPoint"] = "RIGHT", 
				["verticalGrowth"] = "UP", 
				["horizontalGrowth"] = "RIGHT", 
				["filterPlayer"] = false, 
				["filterBlocked"] = true, 
				["filterAllowed"] = false, 
				["filterInfinite"] = false, 
				["filterDispellable"] = false, 
				["useFilter"] = "", 
				["xOffset"] = 8, 
				["yOffset"] = 0, 
				["sizeOverride"] = 0, 
			}, 
			["buffIndicator"] = 
			{
				["enable"] = true, 
				["size"] = 8, 
			}, 
			["rdebuffs"] = 
			{
				["enable"] = true, 
				["size"] = 26, 
				["xOffset"] = 0, 
				["yOffset"] = 2, 
			}, 
			["icons"] = 
			{
				["raidicon"] = 
				{
					["enable"] = true, 
					["size"] = 15, 
					["attachTo"] = "INNERBOTTOMRIGHT", 
					["xOffset"] = 0, 
					["yOffset"] = 0, 
				}, 
				["roleIcon"] = 
				{
					["enable"] = true, 
					["size"] = 12, 
					["attachTo"] = "INNERBOTTOMLEFT", 
					["xOffset"] = 0, 
					["yOffset"] = 0, 
				}, 
				["raidRoleIcons"] = 
				{
					["enable"] = true, 
					["size"] = 18, 
					["attachTo"] = "TOPLEFT", 
					["xOffset"] = 0, 
					["yOffset"] = -4, 
				}, 
			}, 
		}, 
		["raid40"] = {
			["enable"] = true, 
			["rangeCheck"] = true, 
			["threatEnabled"] = true, 
			["visibility"] = "[@raid6, noexists][@raid11, noexists][@raid26, noexists][nogroup] hide;show", 
			["showBy"] = "RIGHT_DOWN", 
			["wrapXOffset"] = 8, 
			["wrapYOffset"] = 8, 
			["gCount"] = 8, 
			["gRowCol"] = 1, 
			["sortMethod"] = "GROUP", 
			["sortDir"] = "ASC", 
			["showPlayer"] = true, 
			["predict"] = false, 
			["colorOverride"] = "USE_DEFAULT", 
			["gridMode"] = false, 
			["width"] = 50, 
			["height"] = 30, 
			["formatting"] = {
				["power_colored"] = true, 
				["power_type"] = "none", 
				["power_class"] = false, 
				["power_alt"] = false, 
				["health_colored"] = true, 
				["health_type"] = "none", 
				["name_colored"] = true, 
				["name_length"] = 4, 
				["smartlevel"] = false, 
				["absorbs"] = false, 
				["threat"] = false, 
				["incoming"] = false, 
				["yOffset"] = 0, 
				["xOffset"] = 0, 
			}, 
			["misc"] = {
				["tags"] = ""
			}, 
			["health"] = 
			{ 
				["tags"] = "", 
				["position"] = "BOTTOM", 
				["orientation"] = "HORIZONTAL", 
				["frequentUpdates"] = false, 
				["yOffset"] = 0, 
				["xOffset"] = 0, 
				["reversed"] = false, 
				["font"] = "SVUI Default Font", 
				["fontSize"] = 10, 
				["fontOutline"] = "OUTLINE", 
			}, 
			["power"] = 
			{
				["enable"] = false, 
				["tags"] = "", 
				["frequentUpdates"] = false, 
				["height"] = 4, 
				["position"] = "BOTTOMRIGHT", 
				["hideonnpc"] = false, 
				["yOffset"] = 0, 
				["xOffset"] = 0, 
				["font"] = "SVUI Default Font", 
				["fontSize"] = 10, 
				["fontOutline"] = "OUTLINE", 
			}, 
			["name"] = 
			{
				["position"] = "INNERTOPLEFT", 
				["tags"] = "[name:color][name:4]", 
				["yOffset"] = 0, 
				["xOffset"] = 0, 
				["font"] = "SVUI Default Font", 
				["fontSize"] = 10, 
				["fontOutline"] = "OUTLINE", 
			}, 
			["buffs"] = 
			{
				["enable"] = false, 
				["perrow"] = 3, 
				["numrows"] = 1, 
				["attachTo"] = "FRAME", 
				["anchorPoint"] = "RIGHT", 
				["verticalGrowth"] = "UP", 
				["horizontalGrowth"] = "RIGHT", 
				["filterPlayer"] = true, 
				["filterRaid"] = true, 
				["filterBlocked"] = true, 
				["filterAllowed"] = false, 
				["filterInfinite"] = true, 
				["filterDispellable"] = false, 
				["useFilter"] = "", 
				["xOffset"] = 8, 
				["yOffset"] = 0, 
				["sizeOverride"] = 0, 
			}, 
			["debuffs"] = 
			{
				["enable"] = false, 
				["perrow"] = 3, 
				["numrows"] = 1, 
				["attachTo"] = "FRAME", 
				["anchorPoint"] = "RIGHT", 
				["verticalGrowth"] = "UP", 
				["horizontalGrowth"] = "RIGHT", 
				["filterPlayer"] = false, 
				["filterBlocked"] = true, 
				["filterAllowed"] = false, 
				["filterInfinite"] = false, 
				["filterDispellable"] = false, 
				["useFilter"] = "", 
				["xOffset"] = 8, 
				["yOffset"] = 0, 
				["sizeOverride"] = 0, 
			}, 
			["rdebuffs"] = 
			{
				["enable"] = true, 
				["size"] = 22, 
				["xOffset"] = 0, 
				["yOffset"] = 2, 
			}, 
			["buffIndicator"] = 
			{
				["enable"] = true, 
				["size"] = 8, 
			}, 
			["icons"] = 
			{
				["raidicon"] = 
				{
					["enable"] = true, 
					["size"] = 15, 
					["attachTo"] = "INNERBOTTOMRIGHT", 
					["xOffset"] = 0, 
					["yOffset"] = 0, 
				}, 
				["roleIcon"] = 
				{
					["enable"] = true, 
					["size"] = 12, 
					["attachTo"] = "INNERBOTTOMLEFT", 
					["xOffset"] = 0, 
					["yOffset"] = 0, 
				}, 
				["raidRoleIcons"] = 
				{
					["enable"] = true, 
					["size"] = 18, 
					["attachTo"] = "TOPLEFT", 
					["xOffset"] = 0, 
					["yOffset"] = -4, 
				}, 
			}, 
		}, 
		["raidpet"] = {
			["enable"] = false, 
			["rangeCheck"] = true, 
			["threatEnabled"] = true, 
			["visibility"] = "[group:raid] show; hide", 
			["showBy"] = "DOWN_RIGHT", 
			["wrapXOffset"] = 3, 
			["wrapYOffset"] = 3, 
			["gCount"] = 2, 
			["gRowCol"] = 1, 
			["sortMethod"] = "PETNAME", 
			["sortDir"] = "ASC", 
			["rSort"] = true, 
			["invertGroupingOrder"] = false, 
			["startFromCenter"] = false, 
			["predict"] = false, 
			["colorOverride"] = "USE_DEFAULT", 
			["gridMode"] = false, 
			["width"] = 80, 
			["height"] = 30, 
			["formatting"] = {
				["power_colored"] = true, 
				["power_type"] = "none", 
				["power_class"] = false, 
				["power_alt"] = false, 
				["health_colored"] = true, 
				["health_type"] = "deficit", 
				["name_colored"] = true, 
				["name_length"] = 4, 
				["smartlevel"] = false, 
				["absorbs"] = false, 
				["threat"] = false, 
				["incoming"] = false, 
				["yOffset"] = 0, 
				["xOffset"] = 0, 
			}, 
			["misc"] = {
				["tags"] = ""
			}, 
			["health"] = 
			{
				["tags"] = "[health:color][health:deficit]", 
				["position"] = "BOTTOM", 
				["orientation"] = "HORIZONTAL", 
				["frequentUpdates"] = false, 
				["yOffset"] = 0, 
				["xOffset"] = 0, 
				["reversed"] = false, 
				["font"] = "SVUI Default Font", 
				["fontSize"] = 10, 
				["fontOutline"] = "OUTLINE", 
			}, 
			["name"] = 
			{
				["position"] = "INNERTOPLEFT", 
				["tags"] = "[name:color][name:4]", 
				["yOffset"] = 4, 
				["xOffset"] = -4, 
				["font"] = "SVUI Default Font", 
				["fontSize"] = 10, 
				["fontOutline"] = "OUTLINE", 
			}, 
			["buffs"] = 
			{
				["enable"] = false, 
				["perrow"] = 3, 
				["numrows"] = 1, 
				["attachTo"] = "FRAME", 
				["anchorPoint"] = "RIGHT", 
				["verticalGrowth"] = "UP", 
				["horizontalGrowth"] = "RIGHT", 
				["filterPlayer"] = true, 
				["filterRaid"] = true, 
				["filterBlocked"] = true, 
				["filterAllowed"] = false, 
				["filterInfinite"] = true, 
				["filterDispellable"] = false, 
				["useFilter"] = "", 
				["xOffset"] = 8, 
				["yOffset"] = 0, 
				["sizeOverride"] = 0, 
			}, 
			["debuffs"] = 
			{
				["enable"] = false, 
				["perrow"] = 3, 
				["numrows"] = 1, 
				["attachTo"] = "FRAME", 
				["anchorPoint"] = "RIGHT", 
				["verticalGrowth"] = "UP", 
				["horizontalGrowth"] = "RIGHT", 
				["filterPlayer"] = false, 
				["filterBlocked"] = true, 
				["filterAllowed"] = false, 
				["filterInfinite"] = false, 
				["filterDispellable"] = false, 
				["useFilter"] = "", 
				["xOffset"] = 8, 
				["yOffset"] = 0, 
				["sizeOverride"] = 0, 
			}, 
			["buffIndicator"] = 
			{
				["enable"] = true, 
				["size"] = 8, 
			}, 
			["rdebuffs"] = 
			{
				["enable"] = true, 
				["size"] = 26, 
				["xOffset"] = 0, 
				["yOffset"] = 2, 
			}, 
			["icons"] = 
			{
				["raidicon"] = 
				{
					["enable"] = true, 
					["size"] = 18, 
					["attachTo"] = "INNERTOPLEFT", 
					["xOffset"] = 0, 
					["yOffset"] = 0, 
				}, 
			}, 
		}, 
		["tank"] = {
			["enable"] = true, 
			["threatEnabled"] = true, 
			["rangeCheck"] = true, 
			["gridMode"] = false, 
			["width"] = 120, 
			["height"] = 28, 
			["formatting"] = {
				["power_colored"] = true, 
				["power_type"] = "none", 
				["power_class"] = false, 
				["power_alt"] = false, 
				["health_colored"] = true, 
				["health_type"] = "deficit", 
				["name_colored"] = true, 
				["name_length"] = 8, 
				["smartlevel"] = false, 
				["absorbs"] = false, 
				["threat"] = false, 
				["incoming"] = false, 
				["yOffset"] = 0, 
				["xOffset"] = 0, 
			}, 
			["misc"] = {
				["tags"] = ""
			}, 
			["health"] = 
			{
				["tags"] = "[health:color][health:deficit]", 
				["position"] = "INNERRIGHT", 
				["orientation"] = "HORIZONTAL", 
				["frequentUpdates"] = false, 
				["yOffset"] = 0, 
				["xOffset"] = 0, 
				["reversed"] = false, 
				["font"] = "SVUI Default Font", 
				["fontSize"] = 10, 
				["fontOutline"] = "OUTLINE", 
			}, 
			["name"] = 
			{
				["position"] = "INNERLEFT", 
				["tags"] = "[name:color][name:8]", 
				["yOffset"] = 0, 
				["xOffset"] = 0, 
				["font"] = "SVUI Default Font", 
				["fontSize"] = 10, 
				["fontOutline"] = "OUTLINE", 
			}, 
			["targetsGroup"] = 
			{
				["enable"] = false, 
				["anchorPoint"] = "RIGHT", 
				["xOffset"] = 1, 
				["yOffset"] = 0, 
				["width"] = 120, 
				["height"] = 28, 
			}, 
		}, 
		["assist"] = {
			["enable"] = true, 
			["threatEnabled"] = true, 
			["rangeCheck"] = true, 
			["gridMode"] = false, 
			["width"] = 120, 
			["height"] = 28, 
			["formatting"] = {
				["power_colored"] = true, 
				["power_type"] = "none", 
				["power_class"] = false, 
				["power_alt"] = false, 
				["health_colored"] = true, 
				["health_type"] = "deficit", 
				["name_colored"] = true, 
				["name_length"] = 8, 
				["smartlevel"] = false, 
				["absorbs"] = false, 
				["threat"] = false, 
				["incoming"] = false, 
				["yOffset"] = 0, 
				["xOffset"] = 0, 
			}, 
			["misc"] = {
				["tags"] = ""
			}, 
			["health"] = 
			{
				["tags"] = "[health:color][health:deficit]", 
				["position"] = "INNERRIGHT", 
				["orientation"] = "HORIZONTAL", 
				["frequentUpdates"] = false, 
				["yOffset"] = 0, 
				["xOffset"] = 0, 
				["reversed"] = false, 
				["font"] = "SVUI Default Font", 
				["fontSize"] = 10, 
				["fontOutline"] = "OUTLINE", 
			}, 
			["name"] = 
			{
				["position"] = "INNERLEFT", 
				["tags"] = "[name:color][name:8]", 
				["yOffset"] = 0, 
				["xOffset"] = 0, 
				["font"] = "SVUI Default Font", 
				["fontSize"] = 10, 
				["fontOutline"] = "OUTLINE", 
			}, 
			["targetsGroup"] = 
			{
				["enable"] = false, 
				["anchorPoint"] = "RIGHT", 
				["xOffset"] = 1, 
				["yOffset"] = 0, 
				["width"] = 120, 
				["height"] = 28, 
			}, 
		}
	}, 
	["SVStyle"] = {
		["blizzard"] = {
			["enable"] = true, 
			["bags"] = true, 
			["bmah"] = true, 
			["reforge"] = true, 
			["calendar"] = true, 
			["achievement"] = true, 
			["lfguild"] = true, 
			["inspect"] = true, 
			["binding"] = true, 
			["gbank"] = true, 
			["archaeology"] = true, 
			["guildcontrol"] = true, 
			["gossip"] = true, 
			["guild"] = true, 
			["tradeskill"] = true, 
			["raid"] = false, 
			["talent"] = true, 
			["auctionhouse"] = true, 
			["barber"] = true, 
			["macro"] = true, 
			["debug"] = true, 
			["trainer"] = true, 
			["socket"] = true, 
			["loot"] = true, 
			["alertframes"] = true, 
			["bgscore"] = true, 
			["merchant"] = true, 
			["mail"] = true, 
			["help"] = true, 
			["trade"] = true, 
			["gossip"] = true, 
			["greeting"] = true, 
			["worldmap"] = true, 
			["taxi"] = true, 
			["quest"] = true, 
			["petition"] = true, 
			["dressingroom"] = true, 
			["pvp"] = true, 
			["lfg"] = true, 
			["nonraid"] = true, 
			["friends"] = true, 
			["spellbook"] = true, 
			["character"] = true, 
			["misc"] = true, 
			["tabard"] = true, 
			["guildregistrar"] = true, 
			["timemanager"] = true, 
			["encounterjournal"] = true, 
			["voidstorage"] = true, 
			["transmogrify"] = true, 
			["stable"] = true, 
			["bgmap"] = true, 
			["mounts"] = true, 
			["petbattleui"] = true, 
			["losscontrol"] = true, 
			["itemUpgrade"] = true, 
		}, 
		["addons"] = {
			["enable"] = true, 
			["ace3"] = true, 
			["Skada"] = true, 
			["Recount"] = true, 
			["AtlasLoot"] = true, 
			["SexyCooldown"] = true, 
			["Lightheaded"] = true, 
			["Outfitter"] = true, 
			["WeakAuras"] = true, 
			["Quartz"] = true, 
			["TomTom"] = true, 
			["TinyDPS"] = true, 
			["Clique"] = true, 
			["CoolLine"] = true, 
			["ACP"] = true, 
			["DXE"] = true, 
			["MogIt"] = true, 
			["alDamageMeter"] = true, 
			["Omen"] = true, 
			["TradeSkillDW"] = true, 
		}
	}, 
}
--[[ 
########################################################## 
CREATE DB
##########################################################
]]--
local function tablecopy(d, s)
	if type(s) ~= "table" then return end
	if type(d) == "table" then
		for k, v in pairs(s) do
			if(k ~= "SAFEDATA") then
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
end

local function importdata(s, d)
	if type(d) ~= "table" then d = {} end
	if type(s) == "table" then
		for k,v in pairs(s) do
			if(k ~= "SAFEDATA") then
				if type(v) == "table" then
					v = importdata(v, d[k])
				end
				d[k] = v
			end
		end
	end
	return d
end

local function setdefaults(t, key, sub, sub2)
	local sv = _G["SVUI_Profile"]
	local src = DatabaseDefaults
	local savedProfile = sv[key]
	if(sub2 and sv[key] and sv[key][sub]) then
		savedProfile = sv[key][sub][sub2]
	elseif(sub and sv[key]) then
		savedProfile = sv[key][sub]
	else
		savedProfile = sv[key]
	end
	if(savedProfile) then
		for k,v in pairs(savedProfile) do
			savedProfile[k] = nil
		end
	else
		sv[key] = {}
	end
	tablecopy(sv[key], src[key])
end

local function getdefaults(t, key)
	return DatabaseDefaults[key] or {}
end

local function resetprofile(t)
	local sv = _G["SVUI_Profile"]
	local src = DatabaseDefaults
	for k,v in pairs(sv) do
		if(k ~= "SAFEDATA") then
			sv[k] = nil
		end
	end
	tablecopy(sv, src)
	SuperVillain:StaticPopup_Show("RESET_PROFILE_PROMPT")
end

local function listprofiles(t)
	local globals = _G["SVUI_Global"]
	return globals.profileKeys
end

local function firstprofile(t)
	local globals = _G["SVUI_Global"]
	for key in pairs(globals.profileKeys) do
		return key
	end
end

local function importprofile(t, key)
	local sv = _G["SVUI_Profile"]
	local globals = _G["SVUI_Global"]
	local src = globals.profiles[key]
	if(not src) then return end
	importdata(src, sv)
	t.profileKey = key
	sv.profileKey = key
	SuperVillain:RefreshEverything()
end

local function exportprofile(t, key)
	local sv = _G["SVUI_Profile"]
	local globals = _G["SVUI_Global"]
	if(not globals.profiles[key]) then
		globals.profiles[key] = {}
	end
	local dest = globals.profiles[key]
	tablecopy(dest, src)
	globals.profileKeys[key] = key
end

local function removeprofile(t, key)
	local globals = _G["SVUI_Global"]
	if(globals.profiles[key]) then globals.profiles[key] = nil end
	if(globals.profileKeys[key]) then globals.profileKeys[key] = nil end
end

local SanitizeDatabase = function(self, event)
	if event == "PLAYER_LOGOUT" then
		local sv = _G["SVUI_Profile"]
		local src = DatabaseDefaults
		for k,v in pairs(sv) do
			if(k ~= "SAFEDATA") then 
				if(rawget(src, k)) then
					for key in pairs(sv[k]) do
						if not next(sv[k][key]) then
							sv[k][key] = nil
						end
					end
					if not next(sv[k]) then
						sv[k] = nil
					end
				else
					sv[k] = nil
				end
			end
		end
	end
end

local metadatabase = { 
	__index = function(t, k)
		local sv = rawget(t, "profile")
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

local METAPROFILE = function(sv, pkey)
	local db 		= setmetatable({}, metadatabase)

	db.profile 		= sv
	db.profileKey 	= pkey
	db.defaults 	= DatabaseDefaults
	db.Reset 		= resetprofile
	db.SetDefault 	= setdefaults
	db.GetDefault 	= getdefaults
	db.GetAll 		= listprofiles
	db.GetFirst 	= firstprofile
	db.Import 		= importprofile
	db.Export 		= exportprofile
	db.Remove 		= removeprofile

	local logout = CreateFrame("Frame",nil)
	logout:RegisterEvent("PLAYER_LOGOUT")
	logout:SetScript("OnEvent", SanitizeDatabase)

	return db
end

function SuperVillain:HexColor(arg1,arg2,arg3)
	local r,g,b;
	if arg1 and type(arg1) == "string" then
		local t
		if(self.Media or self.db.media) then
			t = self.Media.color[arg1] or self.db.media.unitframes[arg1]
		else
			t = DatabaseDefaults.media.colors[arg1] or DatabaseDefaults.media.unitframes[arg1]
		end
		if t then
			r,g,b = t[1],t[2],t[3]
		else
			r,g,b = 0,0,0
		end
	else
		r = type(arg1) == "number" and arg1 or 0;
		g = type(arg2) == "number" and arg2 or 0;
		b = type(arg3) == "number" and arg3 or 0;
	end
	r = (r < 0 or r > 1) and 0 or (r * 255)
	g = (g < 0 or g > 1) and 0 or (g * 255)
	b = (b < 0 or b > 1) and 0 or (b * 255)
	local hexString = format("|cff%02x%02x%02x",r,g,b)
	return hexString
end

function SuperVillain:SetDatabaseObjects(init)
	if(init) then
		self.db = tcopy(DatabaseDefaults, true)
	else
		local realm = GetRealmName()
		local name = UnitName("player")
		local pkey = name .. " - " .. realm
	    local sv = _G["SVUI_Profile"]

	    twipe(self.db)

		self.db = METAPROFILE(sv, pkey)
	end
	self:SetFilterObjects(init)
end