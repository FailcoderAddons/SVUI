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
local select  = _G.select;
local unpack  = _G.unpack;
local pairs   = _G.pairs;
local ipairs  = _G.ipairs;
local type    = _G.type;
local print   = _G.print;
local string  = _G.string;
local math    = _G.math;
local table   = _G.table;
local GetTime = _G.GetTime;
--[[ STRING METHODS ]]--
local format = string.format;
--[[ MATH METHODS ]]--
local floor, modf = math.floor, math.modf;
--[[ TABLE METHODS ]]--
local twipe, tsort = table.wipe, table.sort;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = select(2, ...)
local SVLib = LibSuperVillain("Registry")
local L = SV.L
local LSM = LibStub("LibSharedMedia-3.0")
local SOUND = SV.Sounds;
--[[ 
########################################################## 
LOCALIZED GLOBALS
##########################################################
]]--
local NAMEPLATE_FONT      = _G.NAMEPLATE_FONT
local CHAT_FONT_HEIGHTS   = _G.CHAT_FONT_HEIGHTS
local STANDARD_TEXT_FONT  = _G.STANDARD_TEXT_FONT
local UNIT_NAME_FONT      = _G.UNIT_NAME_FONT
local DAMAGE_TEXT_FONT    = _G.DAMAGE_TEXT_FONT
local CUSTOM_CLASS_COLORS   = _G.CUSTOM_CLASS_COLORS
local RAID_CLASS_COLORS   = _G.RAID_CLASS_COLORS
local UIDROPDOWNMENU_DEFAULT_TEXT_HEIGHT  = _G.UIDROPDOWNMENU_DEFAULT_TEXT_HEIGHT

local DIALOGUE_FONTNAME = "SVUI Dialog Font";
if(GetLocale() ~= "enUS") then
	DIALOGUE_FONTNAME = "SVUI Default Font"
end
--[[ 
########################################################## 
DEFINE SOUND EFFECTS
##########################################################
]]--
SOUND:Register("Buttons", [[sound\interface\uchatscrollbutton.ogg]])

SOUND:Register("Levers", [[sound\interface\ui_blizzardstore_buynow.ogg]])
SOUND:Register("Levers", [[sound\doodad\g_levermetalcustom0.ogg]])
SOUND:Register("Levers", [[sound\item\weapons\gun\gunload01.ogg]])
SOUND:Register("Levers", [[sound\item\weapons\gun\gunload02.ogg]])
SOUND:Register("Levers", [[sound\creature\gyrocopter\gyrocoptergearshift2.ogg]])

SOUND:Register("Gears", [[sound\creature\gyrocopter\gyrocoptergearshift3.ogg]])
SOUND:Register("Gears", [[sound\doodad\g_buttonbigredcustom0.ogg]])

SOUND:Register("Sparks", [[sound\doodad\fx_electricitysparkmedium_02.ogg]])
SOUND:Register("Sparks", [[sound\doodad\fx_electrical_zaps01.ogg]])
SOUND:Register("Sparks", [[sound\doodad\fx_electrical_zaps02.ogg]])
SOUND:Register("Sparks", [[sound\doodad\fx_electrical_zaps03.ogg]])
SOUND:Register("Sparks", [[sound\doodad\fx_electrical_zaps04.ogg]])
SOUND:Register("Sparks", [[sound\doodad\fx_electrical_zaps05.ogg]])

SOUND:Register("Static", [[sound\spells\uni_fx_radiostatic_01.ogg]])
SOUND:Register("Static", [[sound\spells\uni_fx_radiostatic_02.ogg]])
SOUND:Register("Static", [[sound\spells\uni_fx_radiostatic_03.ogg]])
SOUND:Register("Static", [[sound\spells\uni_fx_radiostatic_04.ogg]])
SOUND:Register("Static", [[sound\spells\uni_fx_radiostatic_05.ogg]])
SOUND:Register("Static", [[sound\spells\uni_fx_radiostatic_06.ogg]])
SOUND:Register("Static", [[sound\spells\uni_fx_radiostatic_07.ogg]])
SOUND:Register("Static", [[sound\spells\uni_fx_radiostatic_08.ogg]])

SOUND:Register("Wired", [[sound\doodad\goblin_christmaslight_green_01.ogg]])
SOUND:Register("Wired", [[sound\doodad\goblin_christmaslight_green_02.ogg]])
SOUND:Register("Wired", [[sound\doodad\goblin_christmaslight_green_03.ogg]])

SOUND:Register("Phase", [[sound\doodad\be_scryingorb_explode.ogg]])
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

LSM:Register("font","SVUI Default Font",[[Interface\AddOns\SVUI\assets\fonts\Default.ttf]],LSM.LOCALE_BIT_ruRU+LSM.LOCALE_BIT_western)
LSM:Register("font","SVUI Pixel Font",[[Interface\AddOns\SVUI\assets\fonts\Pixel.ttf]],LSM.LOCALE_BIT_ruRU+LSM.LOCALE_BIT_western)
LSM:Register("font","SVUI Caps Font",[[Interface\AddOns\SVUI\assets\fonts\Caps.ttf]],LSM.LOCALE_BIT_ruRU+LSM.LOCALE_BIT_western)
LSM:Register("font","SVUI Classic Font",[[Interface\AddOns\SVUI\assets\fonts\Classic.ttf]])
LSM:Register("font","SVUI Combat Font",[[Interface\AddOns\SVUI\assets\fonts\Combat.ttf]])
LSM:Register("font","SVUI Dialog Font",[[Interface\AddOns\SVUI\assets\fonts\Dialog.ttf]])
LSM:Register("font","SVUI Number Font",[[Interface\AddOns\SVUI\assets\fonts\Numbers.ttf]])
LSM:Register("font","SVUI Zone Font",[[Interface\AddOns\SVUI\assets\fonts\Zone.ttf]])
LSM:Register("font","SVUI Flash Font",[[Interface\AddOns\SVUI\assets\fonts\Flash.ttf]])
LSM:Register("font","SVUI Alert Font",[[Interface\AddOns\SVUI\assets\fonts\Alert.ttf]])
LSM:Register("font","SVUI Narrator Font",[[Interface\AddOns\SVUI\assets\fonts\Narrative.ttf]])
--[[ 
########################################################## 
CREATE AND POPULATE MEDIA DATA
##########################################################
]]--
SV.Media = {};

SV.defaults["font"] = {
	["default"]     	= {file = "SVUI Default Font",  size = 12,  outline = "OUTLINE"},
	["dialog"]      	= {file = DIALOGUE_FONTNAME,    size = 10,  outline = "OUTLINE"},
	["title"]       	= {file = DIALOGUE_FONTNAME,    size = 16,  outline = "OUTLINE"}, 
	["number"]      	= {file = "SVUI Number Font",   size = 11,  outline = "OUTLINE"},
	["number_big"]    	= {file = "SVUI Number Font",   size = 18,  outline = "OUTLINE"},
	["header"]      	= {file = "SVUI Number Font",   size = 18,  outline = "OUTLINE"},  
	["combat"]      	= {file = "SVUI Combat Font",   size = 64,  outline = "OUTLINE"}, 
	["alert"]       	= {file = "SVUI Alert Font",  	size = 20,  outline = "OUTLINE"},
	["zone"]      		= {file = "SVUI Zone Font",   	size = 16,  outline = "OUTLINE"},
	["caps"]      		= {file = "SVUI Caps Font",   	size = 12,  outline = "OUTLINE"},
	["aura"]      		= {file = "SVUI Number Font",   size = 10,  outline = "OUTLINE"},
	["data"]      		= {file = "SVUI Number Font",   size = 11,  outline = "OUTLINE"},
	["narrator"]    	= {file = "SVUI Narrator Font", size = 12,  outline = "OUTLINE"},
	["pixel"]       	= {file = "SVUI Pixel Font",  	size = 8,   outline = "MONOCHROMEOUTLINE"},
	["chatdialog"]    	= {file = "SVUI Default Font",  size = 12,  outline = "OUTLINE"},
	["chattab"]     	= {file = "SVUI Caps Font",   	size = 12,  outline = "OUTLINE"},
	["lootdialog"]    	= {file = "SVUI Default Font",  size = 14,  outline = "OUTLINE"},
	["lootnumber"]    	= {file = "SVUI Number Font",   size = 11,  outline = "OUTLINE"},
	["rolldialog"]    	= {file = "SVUI Default Font",  size = 14,  outline = "OUTLINE"},
	["rollnumber"]    	= {file = "SVUI Number Font",   size = 11,  outline = "OUTLINE"},
	["bagdialog"]     	= {file = "SVUI Default Font",  size = 11,  outline = "OUTLINE"},
	["bagnumber"]     	= {file = "SVUI Number Font",   size = 11,  outline = "OUTLINE"},
	["tipdialog"]     	= {file = "SVUI Default Font",  size = 12,  outline = "NONE"},
	["tipheader"]     	= {file = "SVUI Default Font",  size = 14,  outline = "NONE"},
	["questdialog"]   	= {file = "SVUI Default Font",  size = 12,  outline = "OUTLINE"},
	["questheader"]   	= {file = "SVUI Caps Font",   	size = 16,  outline = "OUTLINE"}, 
	["questnumber"]   	= {file = "SVUI Number Font",   size = 11,  outline = "OUTLINE"},
	["platename"]     	= {file = "SVUI Caps Font",   	size = 9,   outline = "OUTLINE"},
	["platenumber"]   	= {file = "SVUI Caps Font",   	size = 9,   outline = "OUTLINE"},
	["plateaura"]     	= {file = "SVUI Caps Font",   	size = 9,   outline = "OUTLINE"},
	["unitprimary"]   	= {file = "SVUI Number Font",   size = 11,  outline = "OUTLINE"},
	["unitsecondary"]   = {file = "SVUI Number Font",   size = 11,  outline = "OUTLINE"},
	["unitaurabar"]   	= {file = "SVUI Alert Font",  	size = 10,  outline = "OUTLINE"},
	["unitauramedium"]  = {file = "SVUI Default Font",  size = 10,  outline = "OUTLINE"},
	["unitauralarge"]   = {file = "SVUI Number Font",   size = 10,  outline = "OUTLINE"},
	["unitaurasmall"]   = {file = "SVUI Pixel Font",  	size = 8,   outline = "MONOCHROMEOUTLINE"},
};

SV.defaults["media"] = {
	["textures"] = { 
		["pattern"]      = "SVUI Backdrop 1", 
		["premium"]      = "SVUI Comic 1", 
		["unitlarge"]    = "SVUI Unit BG 3", 
		["unitsmall"]    = "SVUI Small BG 3"
	}, 
	["colors"] = {
		["default"]      = {0.2, 0.2, 0.2, 1}, 
		["special"]      = {0.37, 0.32, 0.29, 1}, 
		["specialdark"]  = {0.37, 0.32, 0.29, 1}, 
	}, 
	["unitframes"] = {
		["health"]       = {0.3, 0.5, 0.3}, 
		["power"]        = {
			["MANA"]         = {0.41, 0.85, 1}, 
			["RAGE"]         = {1, 0.31, 0.31}, 
			["FOCUS"]        = {1, 0.63, 0.27}, 
			["ENERGY"]       = {0.85, 0.83, 0.25}, 
			["RUNES"]        = {0.55, 0.57, 0.61}, 
			["RUNIC_POWER"] = {0, 0.82, 1}, 
			["FUEL"]         = {0, 0.75, 0.75}
		}, 
		["reaction"]     = {
			[1] = {0.92, 0.15, 0.15}, 
			[2] = {0.92, 0.15, 0.15}, 
			[3] = {0.92, 0.15, 0.15}, 
			[4] = {0.85, 0.85, 0.13}, 
			[5] = {0.19, 0.85, 0.13}, 
			[6] = {0.19, 0.85, 0.13}, 
			[7] = {0.19, 0.85, 0.13}, 
			[8] = {0.19, 0.85, 0.13}, 
		},
		["tapped"]           = {0.55, 0.57, 0.61}, 
		["disconnected"]     = {0.84, 0.75, 0.65}, 
		["casting"]          = {0, 0.92, 1}, 
		["spark"]            = {0, 0.42, 1}, 
		["interrupt"]        = {0.78, 0, 1}, 
		["shield_bars"]      = {0.56, 0.4, 0.62}, 
		["buff_bars"]        = {0.31, 0.31, 0.31}, 
		["debuff_bars"]      = {0.8, 0.1, 0.1}, 
		["predict"]          = {
			["personal"]         = {0, 1, 0.5, 0.25}, 
			["others"]           = {0, 1, 0, 0.25}, 
			["absorbs"]          = {1, 1, 0, 0.25}
		}
	}
};

do
	local myclass = select(2,UnitClass("player"))
	local cColor1 = CUSTOM_CLASS_COLORS[myclass]
	local cColor2 = RAID_CLASS_COLORS[myclass]
	local r1,g1,b1 = cColor1.r,cColor1.g,cColor1.b
	local r2,g2,b2 = cColor2.r*.25, cColor2.g*.25, cColor2.b*.25
	local ir1,ig1,ib1 = (1 - r1), (1 - g1), (1 - b1)
	local ir2,ig2,ib2 = (1 - cColor2.r)*.25, (1 - cColor2.g)*.25, (1 - cColor2.b)*.25

	local DIALOGUE_FONT;
	if(GetLocale() ~= "enUS") then
		DIALOGUE_FONT = LSM:Fetch("font", "SVUI Default Font")
	else
		DIALOGUE_FONT = LSM:Fetch("font", "SVUI Dialog Font")
	end

	SV.Media["color"] = {
		["default"]     = {0.2, 0.2, 0.2, 1}, 
		["special"]     = {.37, .32, .29, 1},
		["specialdark"] = {.23, .22, .21, 1},
		["unique"]      = {0.32, 0.258, 0.21, 1},
		["container"]   = {.28, .27, .26, 1},  
		["class"]       = {r1, g1, b1, 1},
		["bizzaro"]     = {ir1, ig1, ib1, 1},
		["medium"]      = {0.47, 0.47, 0.47},
		["dark"]        = {0, 0, 0, 1},
		["darkest"]     = {0, 0, 0, 1},
		["light"]       = {0.95, 0.95, 0.95, 1},
		["lightgrey"]   = {0.32, 0.35, 0.38, 1},
		["highlight"]   = {0.28, 0.75, 1, 1},
		["green"]       = {0.25, 0.9, 0.08, 1},
		["blue"]        = {0.08, 0.25, 0.82, 1},
		["tan"]         = {0.4, 0.32, 0.23, 1},
		["red"]         = {0.9, 0.08, 0.08, 1},
		["yellow"]      = {1, 1, 0, 1},
		["gold"]        = {1, 0.68, 0.1, 1},
		["transparent"] = {0, 0, 0, 0.5},
		["hinted"]      = {0, 0, 0, 0.35},
		["invisible"]   = {0, 0, 0, 0},
		["white"]       = {1, 1, 1, 1},
	}

	SV.Media["gradient"]  = {
		["default"]   = {"VERTICAL", 0.08, 0.08, 0.08, 0.22, 0.22, 0.22}, 
		["special"]   = {"VERTICAL", 0.33, 0.25, 0.13, 0.47, 0.39, 0.27},
		["specialdark"] = {"VERTICAL", 0.23, 0.15, 0.03, 0.33, 0.25, 0.13},
		["container"] = {"VERTICAL", 0.12, 0.11, 0.1, 0.22, 0.21, 0.2},
		["class"]     = {"VERTICAL", r2, g2, b2, r1, g1, b1}, 
		["bizzaro"]   = {"VERTICAL", ir2, ig2, ib2, ir1, ig1, ib1},
		["medium"]    = {"VERTICAL", 0.22, 0.22, 0.22, 0.47, 0.47, 0.47},
		["dark"]      = {"VERTICAL", 0.02, 0.02, 0.02, 0.22, 0.22, 0.22},
		["darkest"]   = {"VERTICAL", 0.15, 0.15, 0.15, 0, 0, 0},
		["darkest2"]  = {"VERTICAL", 0, 0, 0, 0.12, 0.12, 0.12},
		["light"]     = {"VERTICAL", 0.65, 0.65, 0.65, 0.95, 0.95, 0.95},
		["highlight"] = {"VERTICAL", 0.3, 0.8, 1, 0.1, 0.9, 1},
		["green"]     = {"VERTICAL", 0.08, 0.9, 0.25, 0.25, 0.9, 0.08}, 
		["red"]       = {"VERTICAL", 0.5, 0, 0, 0.9, 0.08, 0.08}, 
		["yellow"]    = {"VERTICAL", 1, 0.3, 0, 1, 1, 0},
		["tan"]       = {"VERTICAL", 0.15, 0.08, 0, 0.37, 0.22, 0.1},
		["inverse"]   = {"VERTICAL", 0.25, 0.25, 0.25, 0.12, 0.12, 0.12},
		["icon"]      = {"VERTICAL", 0.5, 0.53, 0.55, 0.8, 0.8, 1},
		["white"]     = {"VERTICAL", 0.75, 0.75, 0.75, 1, 1, 1},
	}

	SV.Media["font"] = {
		["default"]   = LSM:Fetch("font", "SVUI Default Font"),
		["combat"]    = LSM:Fetch("font", "SVUI Combat Font"),
		["narrator"]  = LSM:Fetch("font", "SVUI Narrator Font"),
		["zones"]     = LSM:Fetch("font", "SVUI Zone Font"),
		["alert"]     = LSM:Fetch("font", "SVUI Alert Font"),
		["numbers"]   = LSM:Fetch("font", "SVUI Number Font"),
		["pixel"]     = LSM:Fetch("font", "SVUI Pixel Font"),
		["caps"]      = LSM:Fetch("font", "SVUI Caps Font"),
		["flash"]     = LSM:Fetch("font", "SVUI Flash Font"),
		["dialog"]    = DIALOGUE_FONT,
	}

	SV.Media["bar"] = { 
		["default"]   = LSM:Fetch("statusbar", "SVUI BasicBar"), 
		["gradient"]  = LSM:Fetch("statusbar", "SVUI MultiColorBar"), 
		["smooth"]    = LSM:Fetch("statusbar", "SVUI SmoothBar"), 
		["flat"]      = LSM:Fetch("statusbar", "SVUI PlainBar"), 
		["textured"]  = LSM:Fetch("statusbar", "SVUI FancyBar"), 
		["gloss"]     = LSM:Fetch("statusbar", "SVUI GlossBar"), 
		["glow"]      = LSM:Fetch("statusbar", "SVUI GlowBar"),
		["lazer"]     = LSM:Fetch("statusbar", "SVUI LazerBar"),
	}

	SV.Media["bg"] = {
		["pattern"]     = LSM:Fetch("background", "SVUI Backdrop 1"),
		["premium"]     = LSM:Fetch("background", "SVUI Comic 1"),
		["unitlarge"]   = LSM:Fetch("background", "SVUI Unit BG 3"), 
		["unitsmall"]   = LSM:Fetch("background", "SVUI Small BG 3")
	}
end
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
function SV:ColorGradient(perc, ...)
	if perc >= 1 then
		return select(select('#', ...) - 2, ...)
	elseif perc <= 0 then
		return ...
	end
	local num = select('#', ...) / 3
	local segment, relperc = modf(perc*(num-1))
	local r1, g1, b1, r2, g2, b2 = select((segment*3)+1, ...)
	return r1 + (r2-r1)*relperc, g1 + (g2-g1)*relperc, b1 + (b2-b1)*relperc
end

function SV:HexColor(arg1,arg2,arg3)
	local r,g,b;
	if arg1 and type(arg1) == "string" then
		local t
		if(self.Media or self.db.media) then
			t = self.Media.color[arg1] or self.db.media.unitframes[arg1]
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
	local hexString = ("%02x%02x%02x"):format(r,g,b)
	return hexString
end
--[[ 
########################################################## 
ALTERING GLOBAL FONTS
##########################################################
]]--
local function UpdateChatFontSizes()
	_G.CHAT_FONT_HEIGHTS[1] = 8
	_G.CHAT_FONT_HEIGHTS[2] = 9
	_G.CHAT_FONT_HEIGHTS[3] = 10
	_G.CHAT_FONT_HEIGHTS[4] = 11
	_G.CHAT_FONT_HEIGHTS[5] = 12
	_G.CHAT_FONT_HEIGHTS[6] = 13
	_G.CHAT_FONT_HEIGHTS[7] = 14
	_G.CHAT_FONT_HEIGHTS[8] = 15
	_G.CHAT_FONT_HEIGHTS[9] = 16
	_G.CHAT_FONT_HEIGHTS[10] = 17
	_G.CHAT_FONT_HEIGHTS[11] = 18
	_G.CHAT_FONT_HEIGHTS[12] = 19
	_G.CHAT_FONT_HEIGHTS[13] = 20
end

hooksecurefunc("FCF_ResetChatWindows", UpdateChatFontSizes)

local function UpdateCombatFontSizes()
	local fontFile = "Interface\\AddOns\\SVUI\\assets\\fonts\\Combat.ttf"
	_G.DAMAGE_TEXT_FONT = fontFile
	_G.NUM_COMBAT_TEXT_LINES = 20;
	_G.COMBAT_TEXT_SCROLLSPEED = 1.0;
	_G.COMBAT_TEXT_FADEOUT_TIME = 1.0;
	_G.COMBAT_TEXT_HEIGHT = 18;
	_G.COMBAT_TEXT_CRIT_MAXHEIGHT = 2.0;
	_G.COMBAT_TEXT_CRIT_MINHEIGHT = 1.2;
	_G.COMBAT_TEXT_CRIT_SCALE_TIME = 0.7;
	_G.COMBAT_TEXT_CRIT_SHRINKTIME = 0.2;
	_G.COMBAT_TEXT_TO_ANIMATE = {};
	_G.COMBAT_TEXT_STAGGER_RANGE = 20;
	_G.COMBAT_TEXT_SPACING = 7;
	_G.COMBAT_TEXT_MAX_OFFSET = 130;
	_G.COMBAT_TEXT_LOW_HEALTH_THRESHOLD = 0.2;
	_G.COMBAT_TEXT_LOW_MANA_THRESHOLD = 0.2;
	_G.COMBAT_TEXT_LOCATIONS = {};
	
	local fName, fHeight, fFlags = CombatTextFont:GetFont()
	CombatTextFont:SetFont(fontFile, fHeight, fFlags)
end

local function ChangeGlobalFonts()
	local fontsize = SV.db.font.default.size;
	STANDARD_TEXT_FONT = LSM:Fetch("font", SV.db.font.default.file);
	UNIT_NAME_FONT = LSM:Fetch("font", SV.db.font.caps.file);
	DAMAGE_TEXT_FONT = LSM:Fetch("font", SV.db.font.combat.file);
	NAMEPLATE_FONT = STANDARD_TEXT_FONT
	UpdateChatFontSizes()
	UIDROPDOWNMENU_DEFAULT_TEXT_HEIGHT = fontsize
	--UpdateCombatFontSizes()
end
--[[ 
########################################################## 
FONT TEMPLATING METHODS
##########################################################
]]--
local ManagedFonts = {};

function SV:FontManager(obj, template, arg, sizeMod, styleOverride, colorR, colorG, colorB)
	if not obj then return end
	template = template or "default";
	local info = self.db.font[template];
	if(not info) then return end

	local isSystemFont = false;
	if(arg and (arg == 'SYSTEM')) then
		isSystemFont = true;
	end

	local file = LSM:Fetch("font", info.file);
	local size = info.size;
	local outline = info.outline;

	if(styleOverride) then
		obj.___fontOutline = styleOverride;
		outline = styleOverride;
	end

	obj.___fontSizeMod = sizeMod or 0;
	obj:SetFont(file, (size + obj.___fontSizeMod), outline)

	if(not isSystemFont) then
		if(info.outline and info.outline ~= "NONE") then 
			obj:SetShadowColor(0, 0, 0, 0)
		else 
			obj:SetShadowColor(0, 0, 0, 0.2)
		end 
		obj:SetShadowOffset(1, -1)
		obj:SetJustifyH(arg or "CENTER")
		obj:SetJustifyV("MIDDLE")
	end

	if(colorR and colorG and colorB) then
		obj:SetTextColor(colorR, colorG, colorB);
	end

	if(not ManagedFonts[template]) then
		ManagedFonts[template] = {}
	end

	ManagedFonts[template][obj] = true
end

local function _alterFont(globalName, template, sizeMod, styleOverride, cR, cG, cB)
	if(not template) then return end
	if(not _G[globalName]) then return end
	styleOverride = styleOverride or "NONE"
	SV:FontManager(_G[globalName], template, "SYSTEM", sizeMod, styleOverride, cR, cG, cB);
end

local function _defineFont(globalName, template)
	if(not template) then return end
	if(not _G[globalName]) then return end
	SV:FontManager(_G[globalName], template);
end

local function ChangeSystemFonts()
	--_alterFont("GameFontNormal", "default", fontsize - 2)
	_alterFont("GameFontWhite", "default", 0, 'OUTLINE', 1, 1, 1)
	_alterFont("GameFontWhiteSmall", "default", 0, 'NONE', 1, 1, 1)
	_alterFont("GameFontBlack", "default", 0, 'NONE', 0, 0, 0)
	_alterFont("GameFontBlackSmall", "default", -1, 'NONE', 0, 0, 0)
	_alterFont("GameFontNormalMed2", "default", 2)
	--_alterFont("GameFontNormalMed1", "default", 0)
	_alterFont("GameFontNormalLarge", "default")
	_alterFont("GameFontNormalLargeOutline", "default")
	_alterFont("GameFontHighlightSmall", "default")
	_alterFont("GameFontHighlight", "default", 1)
	_alterFont("GameFontHighlightLeft", "default", 1)
	_alterFont("GameFontHighlightRight", "default", 1)
	_alterFont("GameFontHighlightLarge2", "default", 2)
	_alterFont("SystemFont_Med1", "default")
	_alterFont("SystemFont_Med3", "default")
	_alterFont("SystemFont_Outline_Small", "default", 0, "OUTLINE")
	_alterFont("FriendsFont_Normal", "default")
	_alterFont("FriendsFont_Small", "default")
	_alterFont("FriendsFont_Large", "default", 3)
	_alterFont("FriendsFont_UserText", "default", -1)
	_alterFont("SystemFont_Small", "default", -1)
	_alterFont("GameFontNormalSmall", "default", -1)
	_alterFont("NumberFont_Shadow_Med", "default", -1, "OUTLINE")
	_alterFont("NumberFont_Shadow_Small", "default", -1, "OUTLINE")
	_alterFont("SystemFont_Tiny", "default", -1)
	_alterFont("SystemFont_Shadow_Med1", "default")
	_alterFont("SystemFont_Shadow_Med1_Outline", "default")
	_alterFont("SystemFont_Shadow_Med2", "default")
	_alterFont("SystemFont_Shadow_Med3", "default")
	_alterFont("SystemFont_Large", "default")
	_alterFont("SystemFont_Huge1", "default", 4)
	_alterFont("SystemFont_Huge1_Outline", "default", 4)
	_alterFont("SystemFont_Shadow_Small", "default")
	_alterFont("SystemFont_Shadow_Large", "default", 3)
	_alterFont("QuestFont", "dialog");
	_alterFont("QuestFont_Enormous", "zone", 15, "OUTLINE");
	_alterFont("SpellFont_Small", "dialog", 0, "OUTLINE", 1, 1, 1);
	_alterFont("SystemFont_Shadow_Outline_Large", "title", 0, "OUTLINE");
	_alterFont("SystemFont_Shadow_Outline_Huge2", "title", 8, "OUTLINE");
	_alterFont("GameFont_Gigantic", "alert", 0, "OUTLINE", 32)
	_alterFont("SystemFont_Shadow_Huge1", "alert", 0, "OUTLINE")
	--_alterFont("SystemFont_OutlineThick_Huge2", "alert", 0, "THICKOUTLINE")
	_alterFont("SystemFont_OutlineThick_Huge4", "zone", 6, "OUTLINE");
	_alterFont("SystemFont_OutlineThick_WTF", "zone", 9, "OUTLINE");
	_alterFont("SystemFont_OutlineThick_WTF2", "zone", 15, "OUTLINE");
	_alterFont("QuestFont_Large", "zone", -3);
	_alterFont("QuestFont_Huge", "zone", -2);
	_alterFont("QuestFont_Super_Huge", "zone");
	_alterFont("SystemFont_OutlineThick_Huge2", "zone", 2, "OUTLINE");
	_alterFont("Game18Font", "number", 1)
	_alterFont("Game24Font", "number", 3)
	_alterFont("Game27Font", "number", 5)
	_alterFont("Game30Font", "number_big")
	_alterFont("Game32Font", "number_big", 1)
	_alterFont("NumberFont_OutlineThick_Mono_Small", "number", 0, "OUTLINE")
	_alterFont("NumberFont_Outline_Huge", "number_big", 0, "OUTLINE")
	_alterFont("NumberFont_Outline_Large", "number", 3, "OUTLINE")
	_alterFont("NumberFont_Outline_Med", "number", 1, "OUTLINE")
	_alterFont("NumberFontNormal", "number", 0, "OUTLINE")
	_alterFont("NumberFont_GameNormal", "number", 0, "OUTLINE")
	_alterFont("NumberFontNormalRight", "number", 0, "OUTLINE")
	_alterFont("NumberFontNormalRightRed", "number", 0, "OUTLINE")
	_alterFont("NumberFontNormalRightYellow", "number", 0, "OUTLINE")
	_alterFont("GameTooltipHeader", "tipheader")
	_alterFont("Tooltip_Med", "tipdialog")
	_alterFont("Tooltip_Small", "tipdialog", -1)
	--SVUI CUSTOM FONTS
	_defineFont("SVUI_Font_Default", "default")
	_defineFont("SVUI_Font_Aura", "aura")
	_defineFont("SVUI_Font_Number", "number")
	_defineFont("SVUI_Font_Number_Huge", "number_big")
	_defineFont("SVUI_Font_Header", "header")
	_defineFont("SVUI_Font_Data", "data")
	_defineFont("SVUI_Font_Caps", "caps")
	_defineFont("SVUI_Font_Narrator", "narrator")
	_defineFont("SVUI_Font_Pixel", "pixel")
	_defineFont("SVUI_Font_Quest", "questdialog")
	_defineFont("SVUI_Font_Quest_Header", "questheader")
	_defineFont("SVUI_Font_Quest_Number", "questnumber")
	--_defineFont("SVUI_Font_Chat", "chatdialog", "LEFT")
	--_defineFont("SVUI_Font_ChatTab", "chattab")
	_defineFont("SVUI_Font_NamePlate", "platename")
	_defineFont("SVUI_Font_NamePlate_Aura", "plateaura")
	_defineFont("SVUI_Font_NamePlate_Number", "platenumber")
	_defineFont("SVUI_Font_Bag", "bagdialog")
	_defineFont("SVUI_Font_Bag_Number", "bagnumber")
	_defineFont("SVUI_Font_Roll", "rolldialog")
	_defineFont("SVUI_Font_Roll_Number", "rollnumber")
	_defineFont("SVUI_Font_Loot", "lootdialog")
	_defineFont("SVUI_Font_Loot_Number", "lootnumber")
	_defineFont("SVUI_Font_Unit", "unitprimary")
	_defineFont("SVUI_Font_Unit_Small", "unitsecondary")
	_defineFont("SVUI_Font_UnitAura", "unitauramedium")
	_defineFont("SVUI_Font_UnitAura_Bar", "unitaurabar")
	_defineFont("SVUI_Font_UnitAura_Small", "unitaurasmall")
	_defineFont("SVUI_Font_UnitAura_Large", "unitauralarge")

	_alterFont("SystemFont_Shadow_Huge3", "combat", 0, "OUTLINE")
	_alterFont("CombatTextFont", "combat", 64, "OUTLINE")
end

local function UpdateFontTemplate(template)
	template = template or "default";
	local info = SV.db.font[template];
	local file = LSM:Fetch("font", info.file);
	local size = info.size;
	local line = info.outline;
	local list = ManagedFonts[template];
	--local count = 0;
	if(not list) then return end
	for object in pairs(list) do
		if object then
			if(object.___fontOutline) then
				object:SetFont(file, (size + object.___fontSizeMod), object.___fontOutline);
			else
				object:SetFont(file, (size + object.___fontSizeMod), line);
			end
		else
			ManagedFonts[template][object] = nil;
		end
			--count = count + 1;
		end
	--print(template .. " = " .. count)
end

local function UpdateAllFontTemplates()
	for template, _ in pairs(ManagedFonts) do
		UpdateFontTemplate(template)
	end
end

local function UpdateFontGroup(...)
	for i = 1, select('#', ...) do
		local template = select(i, ...)
		if not template then break end
		UpdateFontTemplate(template)
	end
end

SV.Events:On("SVUI_ALLFONTS_UPDATED", "UpdateAllFontTemplates", UpdateAllFontTemplates);
SV.Events:On("SVUI_FONTGROUP_UPDATED", "UpdateFontGroup", UpdateFontGroup);

--UpdateCombatFontSizes()
--[[ 
########################################################## 
MEDIA UPDATES
##########################################################
]]--
function SV:MediaUpdate()
	self.Media.color.default      = self.db.media.colors.default
	self.Media.color.special      = self.db.media.colors.special
	self.Media.color.specialdark  = self.db.media.colors.specialdark
	self.Media.bg.pattern         = LSM:Fetch("background", self.db.media.textures.pattern)
	self.Media.bg.premium           = LSM:Fetch("background", self.db.media.textures.premium)
	self.Media.bg.unitlarge       = LSM:Fetch("background", self.db.media.textures.unitlarge)
	self.Media.bg.unitsmall       = LSM:Fetch("background", self.db.media.textures.unitsmall)

	local cColor1 = self.Media.color.special
	local cColor2 = self.Media.color.default
	local r1,g1,b1 = cColor1[1], cColor1[2], cColor1[3]
	local r2,g2,b2 = cColor2[1], cColor2[2], cColor2[3]

	self.Media.gradient.special = {"VERTICAL",r1,g1,b1,r2,g2,b2}

	self.Events:Trigger("SVUI_COLORS_UPDATED");
end

function SV:RefreshAllSystemMedia()
	self:MediaUpdate();
	ChangeGlobalFonts();
	ChangeSystemFonts();
	self.Events:Trigger("SVUI_ALLFONTS_UPDATED");
	self.MediaInitialized = true;
end