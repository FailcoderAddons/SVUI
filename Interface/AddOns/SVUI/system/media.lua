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
local pairs   = _G.pairs;
local ipairs  = _G.ipairs;
local type    = _G.type;
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
local SVLib = LibSuperVillain
local L = SV.L
local LSM = LibStub("LibSharedMedia-3.0")
--[[ 
########################################################## 
LOCALIZED GLOBALS
##########################################################
]]--
local STANDARD_TEXT_FONT = _G.STANDARD_TEXT_FONT
local UNIT_NAME_FONT = _G.UNIT_NAME_FONT
local DAMAGE_TEXT_FONT = _G.DAMAGE_TEXT_FONT
local SVUI_CLASS_COLORS = _G.SVUI_CLASS_COLORS
local RAID_CLASS_COLORS = _G.RAID_CLASS_COLORS
--[[ 
########################################################## 
PRE VARS/FUNCTIONS
##########################################################
]]--
local function SetFont(fontObject, font, fontSize, fontOutline, fontAlpha, color, shadowColor, offsetX, offsetY)
  if not font then return end 
  fontObject:SetFont(font,fontSize,fontOutline);
  if fontAlpha then 
    fontObject:SetAlpha(fontAlpha)
  end 
  if color and type(color) == "table" then 
    fontObject:SetTextColor(unpack(color))
  end 
  if shadowColor and type(shadowColor) == "table" then 
    fontObject:SetShadowColor(unpack(shadowColor))
  end 
  if offsetX and offsetY then 
    fontObject:SetShadowOffset(offsetX,offsetY)
  end 
end
--[[ 
########################################################## 
DEFINE SHARED MEDIA
##########################################################
]]--
local LSM = LibStub("LibSharedMedia-3.0")

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
LSM:Register("font","SVUI Pixel Font",[[Interface\AddOns\SVUI\assets\fonts\Pixel.ttf]],LSM.LOCALE_BIT_ruRU+LSM.LOCALE_BIT_western)
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
  local Shared = LSM
  
  SV.Media["color"] = {
    ["default"]     = {0.2, 0.2, 0.2, 1}, 
    ["special"]     = {.37, .32, .29, 1},
    ["unique"]      = {0.32, 0.258, 0.21, 1},  
    ["class"]       = {r1, g1, b1, 1},
    ["bizzaro"]     = {ir1, ig1, ib1, 1},
    ["dark"]        = {0, 0, 0, 1}, 
    ["light"]       = {0.95, 0.95, 0.95, 1},
    ["highlight"]   = {0.1, 0.8, 0.8, 1},
    ["green"]       = {0.25, 0.9, 0.08, 1},
    ["red"]         = {0.9, 0.08, 0.08, 1},
    ["yellow"]      = {1, 1, 0, 1},
    ["transparent"] = {0, 0, 0, 0.5},
    ["white"]       = {1, 1, 1, 1},
  }

  SV.Media["font"] = {
    ["default"]   = Shared:Fetch("font", "SVUI Default Font"),
    ["system"]    = Shared:Fetch("font", "SVUI System Font"),
    ["combat"]    = Shared:Fetch("font", "SVUI Combat Font"),
    ["dialog"]    = Shared:Fetch("font", "SVUI Dialog Font"),
    ["narrator"]  = Shared:Fetch("font", "SVUI Narrator Font"),
    ["action"]    = Shared:Fetch("font", "SVUI Action Font"),
    ["names"]     = Shared:Fetch("font", "SVUI Name Font"),
    ["alert"]     = Shared:Fetch("font", "SVUI Alert Font"),
    ["numbers"]   = Shared:Fetch("font", "SVUI Number Font"),
    ["pixel"]     = Shared:Fetch("font", "SVUI Pixel Font"),
    ["roboto"]    = Shared:Fetch("font", "Roboto")
  }

  SV.Media["bar"] = { 
    ["default"]   = Shared:Fetch("statusbar", "SVUI BasicBar"), 
    ["gradient"]  = Shared:Fetch("statusbar", "SVUI MultiColorBar"), 
    ["smooth"]    = Shared:Fetch("statusbar", "SVUI SmoothBar"), 
    ["flat"]      = Shared:Fetch("statusbar", "SVUI PlainBar"), 
    ["textured"]  = Shared:Fetch("statusbar", "SVUI FancyBar"), 
    ["gloss"]     = Shared:Fetch("statusbar", "SVUI GlossBar"), 
    ["glow"]      = Shared:Fetch("statusbar", "SVUI GlowBar"),
    ["lazer"]     = Shared:Fetch("statusbar", "SVUI LazerBar"),
  }

  SV.Media["bg"] = {
    ["pattern"]     = Shared:Fetch("background", "SVUI Backdrop 1"),
    ["comic"]       = Shared:Fetch("background", "SVUI Comic 1"),
    ["unitlarge"]   = Shared:Fetch("background", "SVUI Unit BG 3"), 
    ["unitsmall"]   = Shared:Fetch("background", "SVUI Small BG 3")
  }

  SV.Media["gradient"]  = {
    ["default"]   = {"VERTICAL", 0.08, 0.08, 0.08, 0.22, 0.22, 0.22}, 
    ["special"]   = {"VERTICAL", 0.33, 0.25, 0.13, 0.47, 0.39, 0.27}, 
    ["class"]     = {"VERTICAL", r2, g2, b2, r1, g1, b1}, 
    ["bizzaro"]   = {"VERTICAL", ir2, ig2, ib2, ir1, ig1, ib1},
    ["dark"]      = {"VERTICAL", 0.02, 0.02, 0.02, 0.22, 0.22, 0.22},
    ["darkest"]   = {"VERTICAL", 0.15, 0.15, 0.15, 0, 0, 0},
    ["darkest2"]  = {"VERTICAL", 0, 0, 0, 0.12, 0.12, 0.12},
    ["light"]     = {"VERTICAL", 0.65, 0.65, 0.65, 0.95, 0.95, 0.95},
    ["highlight"] = {"VERTICAL", 0.1, 0.8, 0.8, 0.2, 0.5, 1},
    ["green"]     = {"VERTICAL", 0.08, 0.5, 0, 0.25, 0.9, 0.08}, 
    ["red"]       = {"VERTICAL", 0.5, 0, 0, 0.9, 0.08, 0.08}, 
    ["yellow"]    = {"VERTICAL", 1, 0.3, 0, 1, 1, 0},
    ["inverse"]   = {"VERTICAL", 0.25, 0.25, 0.25, 0.12, 0.12, 0.12},
    ["icon"]      = {"VERTICAL", 0.5, 0.53, 0.55, 0.8, 0.8, 1},
    ["white"]     = {"VERTICAL", 0.75, 0.75, 0.75, 1, 1, 1},
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

function SV:MediaUpdate()
  self.Media.color.default  = self.db.media.colors.default
  self.Media.color.special  = self.db.media.colors.special
  self.Media.bg.pattern     = LSM:Fetch("background", self.db.media.textures.pattern)
  self.Media.bg.comic       = LSM:Fetch("background", self.db.media.textures.comic)
  self.Media.bg.unitlarge   = LSM:Fetch("background", self.db.media.textures.unitlarge)
  self.Media.bg.unitsmall   = LSM:Fetch("background", self.db.media.textures.unitsmall)

  local cColor1 = self.Media.color.special
  local cColor2 = self.Media.color.default
  local r1,g1,b1 = cColor1[1], cColor1[2], cColor1[3]
  local r2,g2,b2 = cColor2[1], cColor2[2], cColor2[3]

  self.Media.gradient.special = {"VERTICAL",r1,g1,b1,r2,g2,b2}

  SVLib:RunCallbacks()
end

function SV:RefreshSystemFonts()
  local fontsize = self.db.media.fonts.size
  local unicodesize = self.db.media.fonts.unicodeSize

  local NUMBER_TEXT_FONT = LSM:Fetch("font", self.db.media.fonts.number);
  local GIANT_TEXT_FONT = LSM:Fetch("font", self.db.media.fonts.giant);
  STANDARD_TEXT_FONT = LSM:Fetch("font", self.db.media.fonts.default);
  UNIT_NAME_FONT = LSM:Fetch("font", self.db.media.fonts.name);
  DAMAGE_TEXT_FONT = LSM:Fetch("font", self.db.media.fonts.combat);
  NAMEPLATE_FONT = STANDARD_TEXT_FONT
  CHAT_FONT_HEIGHTS = {8,9,10,11,12,13,14,15,16,17,18,19,20}
  UIDROPDOWNMENU_DEFAULT_TEXT_HEIGHT = fontsize

  -- SetFont(GameFont_Gigantic, GIANT_TEXT_FONT, fontsize*3, "THICKOUTLINE", 32)
  -- SetFont(SystemFont_Shadow_Huge1, GIANT_TEXT_FONT, fontsize*1.8, "OUTLINE")
  -- SetFont(SystemFont_OutlineThick_Huge2, GIANT_TEXT_FONT, fontsize*1.8, "THICKOUTLINE")

  SetFont(QuestFont_Large, UNIT_NAME_FONT, fontsize+4)
  SetFont(ZoneTextString, UNIT_NAME_FONT, fontsize*4.2, "OUTLINE")
  SetFont(SubZoneTextString, UNIT_NAME_FONT, fontsize*3.2, "OUTLINE")
  SetFont(PVPInfoTextString, UNIT_NAME_FONT, fontsize*1.9, "OUTLINE")
  SetFont(PVPArenaTextString, UNIT_NAME_FONT, fontsize*1.9, "OUTLINE")
  SetFont(SystemFont_Shadow_Outline_Huge2, UNIT_NAME_FONT, fontsize*1.8, "OUTLINE")

  SetFont(NumberFont_OutlineThick_Mono_Small, NUMBER_TEXT_FONT, fontsize, "OUTLINE")
  SetFont(NumberFont_Outline_Huge, NUMBER_TEXT_FONT, fontsize*2, "THICKOUTLINE", 28)
  SetFont(NumberFont_Outline_Large, NUMBER_TEXT_FONT, fontsize+4, "OUTLINE")
  SetFont(NumberFont_Outline_Med, NUMBER_TEXT_FONT, fontsize+2, "OUTLINE")
  SetFont(NumberFontNormal, NUMBER_TEXT_FONT, fontsize, "OUTLINE")

  SetFont(GameFontHighlight, STANDARD_TEXT_FONT, fontsize)
  SetFont(GameFontWhite, STANDARD_TEXT_FONT, fontsize, 'OUTLINE', 1, {1,1,1})
  SetFont(GameFontWhiteSmall, STANDARD_TEXT_FONT, fontsize, 'NONE', 1, {1,1,1})
  SetFont(GameFontBlack, STANDARD_TEXT_FONT, fontsize, 'NONE', 1, {0,0,0})
  SetFont(GameFontBlackSmall, STANDARD_TEXT_FONT, fontsize, 'NONE', 1, {0,0,0})
  SetFont(GameFontNormal, STANDARD_TEXT_FONT, fontsize)
  SetFont(QuestFont, STANDARD_TEXT_FONT, fontsize)
  SetFont(SystemFont_Large, STANDARD_TEXT_FONT, fontsize+2)
  SetFont(GameFontNormalMed3, STANDARD_TEXT_FONT, fontsize+1)
  SetFont(SystemFont_Med1, STANDARD_TEXT_FONT, fontsize)
  SetFont(SystemFont_Med3, STANDARD_TEXT_FONT, fontsize)
  SetFont(SystemFont_Outline_Small, STANDARD_TEXT_FONT, fontsize, "OUTLINE")
  SetFont(SystemFont_Shadow_Large, STANDARD_TEXT_FONT, fontsize+2)
  SetFont(SystemFont_Shadow_Med1, STANDARD_TEXT_FONT, fontsize)
  SetFont(SystemFont_Shadow_Med3, STANDARD_TEXT_FONT, fontsize)
  SetFont(SystemFont_Shadow_Small, STANDARD_TEXT_FONT, fontsize)
  SetFont(SystemFont_Small, STANDARD_TEXT_FONT, fontsize)
  SetFont(FriendsFont_Normal, STANDARD_TEXT_FONT, fontsize)
  SetFont(FriendsFont_Small, STANDARD_TEXT_FONT, fontsize-2)
  SetFont(FriendsFont_Large, STANDARD_TEXT_FONT, fontsize)
  SetFont(FriendsFont_UserText, STANDARD_TEXT_FONT, fontsize)

  SetFont(GameFont_Gigantic, GIANT_TEXT_FONT, 200, "THICKOUTLINE", 32)
  SetFont(SystemFont_Shadow_Huge1, GIANT_TEXT_FONT, 200, "OUTLINE")
  SetFont(SystemFont_OutlineThick_Huge2, GIANT_TEXT_FONT, 200, "THICKOUTLINE")

  SetFont(SystemFont_Shadow_Huge3, DAMAGE_TEXT_FONT, 200, "THICKOUTLINE")
  SetFont(CombatTextFont, DAMAGE_TEXT_FONT, 200, "THICKOUTLINE")

  local UNICODE_FONT = self.Media.font.roboto;

  SetFont(GameTooltipHeader, UNICODE_FONT, unicodesize+2)
  SetFont(Tooltip_Med, UNICODE_FONT, unicodesize)
  SetFont(Tooltip_Small, UNICODE_FONT, unicodesize)
  SetFont(GameFontNormalSmall, UNICODE_FONT, unicodesize)
  SetFont(GameFontHighlightSmall, UNICODE_FONT, unicodesize)
  SetFont(NumberFont_Shadow_Med, UNICODE_FONT, unicodesize)
  SetFont(NumberFont_Shadow_Small, UNICODE_FONT, unicodesize)
  SetFont(SystemFont_Tiny, UNICODE_FONT, unicodesize)

  self:UpdateFontTemplates()
end 

function SV:RefreshAllSystemMedia()
  local fontsize = self.db.media.fonts.size
  local unicodesize = self.db.media.fonts.unicodeSize

  local NUMBER_TEXT_FONT = LSM:Fetch("font", self.db.media.fonts.number);
  local GIANT_TEXT_FONT = LSM:Fetch("font", self.db.media.fonts.giant);
  STANDARD_TEXT_FONT = LSM:Fetch("font", self.db.media.fonts.default);
  UNIT_NAME_FONT = LSM:Fetch("font", self.db.media.fonts.name);
  DAMAGE_TEXT_FONT = LSM:Fetch("font", self.db.media.fonts.combat);
  NAMEPLATE_FONT = STANDARD_TEXT_FONT
  CHAT_FONT_HEIGHTS = {8,9,10,11,12,13,14,15,16,17,18,19,20}
  UIDROPDOWNMENU_DEFAULT_TEXT_HEIGHT = fontsize

  -- SetFont(GameFont_Gigantic, GIANT_TEXT_FONT, fontsize*3, "THICKOUTLINE", 32)
  -- SetFont(SystemFont_Shadow_Huge1, GIANT_TEXT_FONT, fontsize*1.8, "OUTLINE")
  -- SetFont(SystemFont_OutlineThick_Huge2, GIANT_TEXT_FONT, fontsize*1.8, "THICKOUTLINE")

  SetFont(QuestFont_Large, UNIT_NAME_FONT, fontsize+4)
  SetFont(ZoneTextString, UNIT_NAME_FONT, fontsize*4.2, "OUTLINE")
  SetFont(SubZoneTextString, UNIT_NAME_FONT, fontsize*3.2, "OUTLINE")
  SetFont(PVPInfoTextString, UNIT_NAME_FONT, fontsize*1.9, "OUTLINE")
  SetFont(PVPArenaTextString, UNIT_NAME_FONT, fontsize*1.9, "OUTLINE")
  SetFont(SystemFont_Shadow_Outline_Huge2, UNIT_NAME_FONT, fontsize*1.8, "OUTLINE")

  SetFont(NumberFont_OutlineThick_Mono_Small, NUMBER_TEXT_FONT, fontsize, "OUTLINE")
  SetFont(NumberFont_Outline_Huge, NUMBER_TEXT_FONT, fontsize*2, "THICKOUTLINE", 28)
  SetFont(NumberFont_Outline_Large, NUMBER_TEXT_FONT, fontsize+4, "OUTLINE")
  SetFont(NumberFont_Outline_Med, NUMBER_TEXT_FONT, fontsize+2, "OUTLINE")
  SetFont(NumberFontNormal, NUMBER_TEXT_FONT, fontsize, "OUTLINE")

  SetFont(GameFontHighlight, STANDARD_TEXT_FONT, fontsize)
  SetFont(GameFontWhite, STANDARD_TEXT_FONT, fontsize, 'OUTLINE', 1, {1,1,1})
  SetFont(GameFontWhiteSmall, STANDARD_TEXT_FONT, fontsize, 'NONE', 1, {1,1,1})
  SetFont(GameFontBlack, STANDARD_TEXT_FONT, fontsize, 'NONE', 1, {0,0,0})
  SetFont(GameFontBlackSmall, STANDARD_TEXT_FONT, fontsize, 'NONE', 1, {0,0,0})
  SetFont(GameFontNormal, STANDARD_TEXT_FONT, fontsize)
  SetFont(QuestFont, STANDARD_TEXT_FONT, fontsize)
  SetFont(SystemFont_Large, STANDARD_TEXT_FONT, fontsize+2)
  SetFont(GameFontNormalMed3, STANDARD_TEXT_FONT, fontsize+1)
  SetFont(SystemFont_Med1, STANDARD_TEXT_FONT, fontsize)
  SetFont(SystemFont_Med3, STANDARD_TEXT_FONT, fontsize)
  SetFont(SystemFont_Outline_Small, STANDARD_TEXT_FONT, fontsize, "OUTLINE")
  SetFont(SystemFont_Shadow_Large, STANDARD_TEXT_FONT, fontsize+2)
  SetFont(SystemFont_Shadow_Med1, STANDARD_TEXT_FONT, fontsize)
  SetFont(SystemFont_Shadow_Med3, STANDARD_TEXT_FONT, fontsize)
  SetFont(SystemFont_Shadow_Small, STANDARD_TEXT_FONT, fontsize)
  SetFont(SystemFont_Small, STANDARD_TEXT_FONT, fontsize)
  SetFont(FriendsFont_Normal, STANDARD_TEXT_FONT, fontsize)
  SetFont(FriendsFont_Small, STANDARD_TEXT_FONT, fontsize-2)
  SetFont(FriendsFont_Large, STANDARD_TEXT_FONT, fontsize)
  SetFont(FriendsFont_UserText, STANDARD_TEXT_FONT, fontsize)

  SetFont(GameFont_Gigantic, GIANT_TEXT_FONT, 200, "THICKOUTLINE", 32)
  SetFont(SystemFont_Shadow_Huge1, GIANT_TEXT_FONT, 200, "OUTLINE")
  SetFont(SystemFont_OutlineThick_Huge2, GIANT_TEXT_FONT, 200, "THICKOUTLINE")

  SetFont(SystemFont_Shadow_Huge3, DAMAGE_TEXT_FONT, 200, "THICKOUTLINE")
  SetFont(CombatTextFont, DAMAGE_TEXT_FONT, 200, "THICKOUTLINE")

  local UNICODE_FONT = self.Media.font.roboto;

  SetFont(GameTooltipHeader, UNICODE_FONT, unicodesize+2)
  SetFont(Tooltip_Med, UNICODE_FONT, unicodesize)
  SetFont(Tooltip_Small, UNICODE_FONT, unicodesize)
  SetFont(GameFontNormalSmall, UNICODE_FONT, unicodesize)
  SetFont(GameFontHighlightSmall, UNICODE_FONT, unicodesize)
  SetFont(NumberFont_Shadow_Med, UNICODE_FONT, unicodesize)
  SetFont(NumberFont_Shadow_Small, UNICODE_FONT, unicodesize)
  SetFont(SystemFont_Tiny, UNICODE_FONT, unicodesize)

  self:MediaUpdate()
  self.MediaInitialized = true
end
--[[ 
########################################################## 
INIT SOME COMBAT FONTS
##########################################################
]]--
do
  local fontFile = "Interface\\AddOns\\SVUI\\assets\\fonts\\Combat.ttf"

  DAMAGE_TEXT_FONT = fontFile
  NUM_COMBAT_TEXT_LINES = 20;
  COMBAT_TEXT_SCROLLSPEED = 1.0;
  COMBAT_TEXT_FADEOUT_TIME = 1.0;
  COMBAT_TEXT_HEIGHT = 18;
  COMBAT_TEXT_CRIT_MAXHEIGHT = 2.0;
  COMBAT_TEXT_CRIT_MINHEIGHT = 1.2;
  COMBAT_TEXT_CRIT_SCALE_TIME = 0.7;
  COMBAT_TEXT_CRIT_SHRINKTIME = 0.2;
  COMBAT_TEXT_TO_ANIMATE = {};
  COMBAT_TEXT_STAGGER_RANGE = 20;
  COMBAT_TEXT_SPACING = 7;
  COMBAT_TEXT_MAX_OFFSET = 130;
  COMBAT_TEXT_LOW_HEALTH_THRESHOLD = 0.2;
  COMBAT_TEXT_LOW_MANA_THRESHOLD = 0.2;
  COMBAT_TEXT_LOCATIONS = {};
  
  local fName, fHeight, fFlags = CombatTextFont:GetFont()
  
  CombatTextFont:SetFont(fontFile, 24, fFlags)
end