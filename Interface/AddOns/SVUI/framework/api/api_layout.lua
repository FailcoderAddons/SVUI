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
local ipairs    = _G.ipairs;
local type      = _G.type;
local error     = _G.error;
local pcall     = _G.pcall;
local tostring  = _G.tostring;
local tonumber  = _G.tonumber;
local table     = _G.table;
local string     = _G.string;
local math      = _G.math;
--[[ MATH METHODS ]]--
local floor, abs, min, max = math.floor, math.abs, math.min, math.max;
local parsefloat, ceil = math.parsefloat, math.ceil;
--[[ STRING METHODS ]]--
local lower = string.lower;
--[[ TABLE METHODS ]]--
local tremove, tcopy, twipe, tsort, tconcat, tdump = table.remove, table.copy, table.wipe, table.sort, table.concat, table.dump;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = select(2, ...);
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local ManagedFonts = {};
local STANDARD_TEXT_FONT = _G.STANDARD_TEXT_FONT;
local SizeScaled, HeightScaled, WidthScaled, PointScaled, WrapOuter, FillInner;
--[[ 
########################################################## 
APPENDED POSITIONING METHODS
##########################################################
]]-- 
do
    local PARAMS = {}

    function SizeScaled(self, width, height)
        if(type(width) == "number") then
            local h = (height and type(height) == "number") and height or width
            self:SetSize(SV:Scale(width), SV:Scale(h))
        end
    end 

    function WidthScaled(self, width)
        if(type(width) == "number") then
            self:SetWidth(SV:Scale(width))
        end
    end 

    function HeightScaled(self, height)
        if(type(height) == "number") then
            self:SetHeight(SV:Scale(height))
        end
    end

    function PointScaled(self, ...)
        local n = select('#', ...) 
        PARAMS = {...}
        local arg
        for i = 1, n do
            arg = PARAMS[i]
            if(arg and type(arg) == "number") then 
                PARAMS[i] = SV:Scale(arg)
            end 
        end 
        self:SetPoint(unpack(PARAMS))
    end

    function WrapOuter(self, parent, x, y)
        x = type(x) == "number" and x or 1
        y = y or x
        local nx = SV:Scale(x);
        local ny = SV:Scale(y);
        parent = parent or self:GetParent()
        if self:GetPoint() then 
            self:ClearAllPoints()
        end 
        self:SetPoint("TOPLEFT", parent, "TOPLEFT", -nx, ny)
        self:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", nx, -ny)
    end 

    function FillInner(self, parent, x, y)
        x = type(x) == "number" and x or 1
        y = y or x
        local nx = SV:Scale(x);
        local ny = SV:Scale(y);
        parent = parent or self:GetParent()
        if self:GetPoint() then 
            self:ClearAllPoints()
        end 
        self:SetPoint("TOPLEFT", parent, "TOPLEFT", nx, -ny)
        self:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -nx, ny)
    end
end
--[[ 
########################################################## 
APPENDED DESTROY METHODS
##########################################################
]]--
local _purgatory = CreateFrame("Frame", nil)
_purgatory:Hide()

local function Die(self)
    if self.UnregisterAllEvents then 
        self:UnregisterAllEvents()
        self:SetParent(_purgatory)
    else 
        self:Hide()
        self.Show = SV.fubar
    end 
end

local function RemoveTextures(self, option)
    if(self.Panel) then return end
    local region, layer, texture
    for i = 1, self:GetNumRegions()do 
        region = select(i, self:GetRegions())
        if(region and (region:GetObjectType() == "Texture")) then

            layer = region:GetDrawLayer()
            texture = region:GetTexture()

            if(option) then
                if(type(option) == "boolean") then 
                    if region.UnregisterAllEvents then 
                        region:UnregisterAllEvents()
                        region:SetParent(_purgatory)
                    else 
                        region.Show = region.Hide 
                    end 
                    region:Hide()
                elseif(type(option) == "string" and ((layer == option) or (texture ~= option))) then
                    region:SetTexture(0,0,0,0)
                end
            else 
                region:SetTexture(0,0,0,0)
            end 
        end 
    end 
end 
--[[ 
########################################################## 
APPENDED FONT TEMPLATING METHODS
##########################################################
]]--
local function FontManager(self, font, fontSize, fontStyle, fontJustifyH, fontJustifyV, noUpdate)
    if not self then return end
    local STANDARDFONTSIZE = SV.db.media.fonts and SV.db.media.fonts.size or 12
    font = font or [[Interface\AddOns\SVUI\assets\fonts\Default.ttf]]
    fontSize = fontSize or STANDARDFONTSIZE;
    fontJustifyH = fontJustifyH or "CENTER";
    fontJustifyV = fontJustifyV or "MIDDLE";
    if not font then return end
    self.font = font;
    self.fontSize = fontSize;
    self.fontStyle = fontStyle;
    self.fontJustifyH = fontJustifyH;
    self.fontJustifyV = fontJustifyV;
    self:SetFont(font, fontSize, fontStyle)
    if(fontStyle and fontStyle ~= "NONE") then 
        self:SetShadowColor(0, 0, 0, 0)
    else 
        self:SetShadowColor(0, 0, 0, 0.2)
    end 
    self:SetShadowOffset(1, -1)
    self:SetJustifyH(fontJustifyH)
    self:SetJustifyV(fontJustifyV)
    self.useCommon = fontSize and (fontSize == STANDARDFONTSIZE);
    if(not noUpdate) then
        ManagedFonts[self] = true
    end
end
--[[ 
########################################################## 
FONT UPDATE CALLBACK
##########################################################
]]--
local function UpdateManagedFonts()
    local STANDARDFONTSIZE = SV.db.media.fonts.size;
    for i=1, #ManagedFonts do
        local frame = ManagedFonts[i] 
        if frame then
            local fontSize = frame.useCommon and STANDARDFONTSIZE or frame.fontSize
            frame:SetFont(frame.font, fontSize, frame.fontStyle)
        else 
            ManagedFonts[i] = nil 
        end 
    end 
end

SV.UpdateManagedFonts = UpdateManagedFonts

SV:NewCallback(FontTemplateUpdates)
--[[ 
########################################################## 
ENUMERATION
##########################################################
]]--
local function AppendMethods(OBJECT)
    local META = getmetatable(OBJECT).__index
    if not OBJECT.Size then META.Size = SizeScaled end
    if not OBJECT.Width then META.Width = WidthScaled end
    if not OBJECT.Height then META.Height = HeightScaled end
    if not OBJECT.Point then META.Point = PointScaled end
    if not OBJECT.WrapOuter then META.WrapOuter = WrapOuter end
    if not OBJECT.FillInner then META.FillInner = FillInner end
    if not OBJECT.Die then META.Die = Die end
    if not OBJECT.RemoveTextures then META.RemoveTextures = RemoveTextures end
    if not OBJECT.FontManager then META.FontManager = FontManager end
end

local HANDLER, OBJECT = {["Frame"] = true}, CreateFrame("Frame")
AppendMethods(OBJECT)
AppendMethods(OBJECT:CreateTexture())
AppendMethods(OBJECT:CreateFontString())

OBJECT = EnumerateFrames()
while OBJECT do
    local objType = OBJECT:GetObjectType()
    if not HANDLER[objType] then
		AppendMethods(OBJECT)
		HANDLER[objType] = true
	end
	OBJECT = EnumerateFrames(OBJECT)
end