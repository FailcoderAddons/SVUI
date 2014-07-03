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
local floor = math.floor;  -- Basic
--[[ TABLE METHODS ]]--
local twipe, tsort = table.wipe, table.sort;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L = unpack(select(2, ...));
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
  if not font then return end;
  fontObject:SetFont(font,fontSize,fontOutline);
  if fontAlpha then 
    fontObject:SetAlpha(fontAlpha)
  end;
  if color and type(color) == "table" then 
    fontObject:SetTextColor(unpack(color))
  end;
  if shadowColor and type(shadowColor) == "table" then 
    fontObject:SetShadowColor(unpack(shadowColor))
  end;
  if offsetX and offsetY then 
    fontObject:SetShadowOffset(offsetX,offsetY)
  end;
end;
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
function SuperVillain:MediaUpdate()
  self.Media.color.default  = SuperVillain.db.media.colors.default
  self.Media.color.special  = SuperVillain.db.media.colors.special
  self.Media.bg.pattern     = LSM:Fetch("background", SuperVillain.db.media.textures.pattern)
  self.Media.bg.comic       = LSM:Fetch("background", SuperVillain.db.media.textures.comic)
  self.Media.bg.unitlarge   = LSM:Fetch("background", SuperVillain.db.media.textures.unitlarge)
  self.Media.bg.unitsmall   = LSM:Fetch("background", SuperVillain.db.media.textures.unitsmall)

  local cColor1 = self.Media.color.special
    local cColor2 = self.Media.color.default
    local r1,g1,b1 = cColor1[1], cColor1[2], cColor1[3]
    local r2,g2,b2 = cColor2[1], cColor2[2], cColor2[3]
  
    self.Media.gradient.special = {"VERTICAL",r1,g1,b1,r2,g2,b2}

    self.Registry:RunCallbacks()
end

function SuperVillain:RefreshSystemFonts()
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

  SetFont(GameFont_Gigantic, GIANT_TEXT_FONT, fontsize*3, "THICKOUTLINE", 32)
  SetFont(SystemFont_Shadow_Huge1, GIANT_TEXT_FONT, fontsize*1.8, "OUTLINE")
  SetFont(SystemFont_OutlineThick_Huge2, GIANT_TEXT_FONT, fontsize*1.8, "THICKOUTLINE")

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
end;

function SuperVillain:RefreshAllSystemMedia()
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

  SetFont(GameFont_Gigantic, GIANT_TEXT_FONT, fontsize*3, "THICKOUTLINE", 32)
  SetFont(SystemFont_Shadow_Huge1, GIANT_TEXT_FONT, fontsize*1.8, "OUTLINE")
  SetFont(SystemFont_OutlineThick_Huge2, GIANT_TEXT_FONT, fontsize*1.8, "THICKOUTLINE")

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
end;