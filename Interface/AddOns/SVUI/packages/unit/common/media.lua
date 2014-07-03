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
local unpack  = _G.unpack;
local select  = _G.select;
local pairs   = _G.pairs;
local ipairs  = _G.ipairs;
local type    = _G.type;
local tinsert   = _G.tinsert;
local string  = _G.string;
local math    = _G.math;
local table   = _G.table;
--[[ STRING METHODS ]]--
local find, format, len, split = string.find, string.format, string.len, string.split;
local gmatch, gsub, join = string.gmatch, string.gsub, string.join;
--[[ MATH METHODS ]]--
local abs, ceil, floor, round, min = math.abs, math.ceil, math.floor, math.round, math.min;
--[[ TABLE METHODS ]]--
local twipe = table.wipe;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L = unpack(select(2, ...));
local MOD = SuperVillain.Registry:Expose('SVUnit');
local _, ns = ...
local oUF_SuperVillain = ns.oUF
--[[ MUNGLUNCH's FASTER ASSERT FUNCTION ]]--
local assert = enforce;
assert(oUF_SuperVillain, "SVUI was unable to locate oUF.")
local LSM = LibStub("LibSharedMedia-3.0");
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local CURRENT_BAR_TEXTURE = [[Interface\AddOns\SVUI\assets\artwork\Bars\DEFAULT]];
local CURRENT_AURABAR_TEXTURE = [[Interface\AddOns\SVUI\assets\artwork\Bars\GLOWING]];
local CURRENT_FONT = [[Interface\AddOns\SVUI\assets\fonts\Names.ttf]];
local CURRENT_FONTSIZE = 10;
local CURRENT_FONTOUTLINE = "OUTLINE";
local CURRENT_AURABAR_FONT = [[Interface\AddOns\SVUI\assets\fonts\Alert.ttf]];
local CURRENT_AURABAR_FONTSIZE = 14
local CURRENT_AURABAR_FONTOUTLINE = "NONE"

local MediaCache = {
	["bars"] = {},
	["aurabars"] = {},
	["fonts"] = {},
	["namefonts"] = {},
	["aurafonts"] = {},
	["aurabarfonts"] = {}
}
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
local function UpdateUnitMediaLocals()
	CURRENT_BAR_TEXTURE = LSM:Fetch("statusbar", MOD.db.statusbar)
	CURRENT_AURABAR_TEXTURE = LSM:Fetch("statusbar", MOD.db.auraBarStatusbar);
	CURRENT_FONT = LSM:Fetch("font", MOD.db.font)
	CURRENT_FONTSIZE = MOD.db.fontSize
	CURRENT_FONTOUTLINE = MOD.db.fontOutline
	CURRENT_AURABAR_FONT = LSM:Fetch("font", MOD.db.auraFont);
	CURRENT_AURABAR_FONTSIZE = MOD.db.auraFontSize
	CURRENT_AURABAR_FONTOUTLINE = MOD.db.auraFontOutline
end 

function MOD:SetUnitFont(element, unit)
	if(not element) then return; end
	if(not unit or not MOD.db[unit] or not MOD.db[unit].name) then
		element:SetFontTemplate(CURRENT_FONT, CURRENT_FONTSIZE, CURRENT_FONTOUTLINE)
		MediaCache["fonts"][element] = true;
	else
		local db = MOD.db[unit].name;
		local font = LSM:Fetch("font", db.font);
		element:SetFontTemplate(font, db.fontSize, db.fontOutline)
		if(not MediaCache["namefonts"][unit]) then
			MediaCache["namefonts"][unit] = {}
		end
		MediaCache["namefonts"][unit][element] = true;
	end
end 

function MOD:UpdateUnitFont(unit)
	if(not unit) then return; end
	local t = MediaCache["namefonts"][unit];
	local db = MOD.db[unit].name;

	if(db and t) then
		for element in pairs(t) do
			local font = LSM:Fetch("font", db.font);
			element:SetFontTemplate(font, db.fontSize, db.fontOutline)
		end
	end
end 

function MOD:RefreshUnitAuraFonts()
	UpdateUnitMediaLocals()
	for element in pairs(MediaCache["aurabarfonts"]) do 
		element.spelltime:SetFontTemplate(CURRENT_AURABAR_FONT, CURRENT_AURABAR_FONTSIZE, CURRENT_AURABAR_FONTOUTLINE, "RIGHT")
		element.spellname:SetFontTemplate(CURRENT_AURABAR_FONT, CURRENT_AURABAR_FONTSIZE, CURRENT_AURABAR_FONTOUTLINE, "LEFT")
	end 
	local i = 1
	for element in pairs(MediaCache["aurafonts"]) do 
		i = 1; 
		while element[i] do 
			local icon = element[i]
			icon.text:SetFont(CURRENT_AURABAR_FONT, CURRENT_AURABAR_FONTSIZE, CURRENT_AURABAR_FONTOUTLINE)
			icon.count:SetFont(CURRENT_AURABAR_FONT, CURRENT_AURABAR_FONTSIZE, CURRENT_AURABAR_FONTOUTLINE)
			i = i + 1 
		end
	end 
end 

function MOD:RefreshUnitFonts()
	UpdateUnitMediaLocals()
	for element in pairs(MediaCache["fonts"]) do 
		element:SetFontTemplate(CURRENT_FONT, CURRENT_FONTSIZE, CURRENT_FONTOUTLINE)
	end  
end 

function MOD:SetUnitStatusbar(element)
	if(not element or element.noupdate or element:GetObjectType()  ~= "StatusBar") then return; end
	element:SetStatusBarTexture(CURRENT_BAR_TEXTURE)
	MediaCache["bars"][element] = true;
end 

function MOD:WatchUnitMedia(key, frame)
	MediaCache[key][frame] = true; 
end 

function MOD:RefreshUnitTextures()
	UpdateUnitMediaLocals()
	for element in pairs(MediaCache["bars"]) do 
		element:SetStatusBarTexture(CURRENT_BAR_TEXTURE)
	end 
	for element in pairs(MediaCache["aurabars"]) do
		element.auraBarTexture = CURRENT_AURABAR_TEXTURE
	end 
end 

function MOD:RefreshUnitColors()
	local db = SuperVillain.db.media.unitframes 
	for i, setting in pairs(db) do
		if setting and type(setting) == "table" then
			if(setting[1]) then
				oUF_SuperVillain.colors[i] = setting
			else
				local bt = {}
				for x, color in pairs(setting) do
					if(color)then
						bt[x] = color
					end
					oUF_SuperVillain.colors[i] = bt
				end
			end
		elseif setting then
			oUF_SuperVillain.colors[i] = setting
		end
	end
	local r, g, b = db.health[1], db.health[2], db.health[3]
	oUF_SuperVillain.colors.smooth = {1, 0, 0, 1, 1, 0, r, g, b}
end