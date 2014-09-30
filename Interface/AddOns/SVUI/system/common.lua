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
local parsefloat = math.parsefloat;
--[[ STRING METHODS ]]--
local lower = string.lower;
--[[ TABLE METHODS ]]--
local tremove, tcopy, twipe, tsort, tconcat, tdump = table.remove, table.copy, table.wipe, table.sort, table.concat, table.dump;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = select(2, ...)
local L = SV.L
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local SizeScaled, HeightScaled, WidthScaled, PointScaled, WrapOuter, FillInner
local TemplateUpdateFrames = {};
local FontUpdateFrames = {};
local NewFrame = CreateFrame;
local NewHook = hooksecurefunc;
local STANDARD_TEXT_FONT = _G.STANDARD_TEXT_FONT;
local SCREEN_MOD = 1;

local function GetUsableScreen()
    local rez = GetCVar("gxResolution")
    local height = rez:match("%d+x(%d+)")
    local width = rez:match("(%d+)x%d+")
    local gxHeight = tonumber(height)
    local gxWidth = tonumber(width)
    local gxMod = (768 / gxHeight)
    return gxWidth, gxHeight, gxMod
end
--[[ 
########################################################## 
UI SCALING
##########################################################
]]--
-- function SV:ScreenCalibration(event)
--     return
-- end

function SV:ScreenCalibration(event)
    local scale, evalwidth
    local gxWidth, gxHeight, gxMod = GetUsableScreen()

    if(IsMacClient() and self.DisplaySettings and self.DisplaySettings.screenheight and self.DisplaySettings.screenwidth) then
        if(gxHeight ~= self.DisplaySettings.screenheight or gxWidth ~= self.DisplaySettings.screenwidth) then 
            gxHeight = self.DisplaySettings.screenheight;
            gxWidth = self.DisplaySettings.screenwidth 
        end 
    end 
    
    if self.db.general.autoScale then
        scale = max(0.64, min(1.15, gxMod))
    else
        scale = max(0.64, min(1.15, GetCVar("uiScale") or UIParent:GetScale() or gxMod))
    end

    SCREEN_MOD = gxMod / scale;

    self.ghettoMonitor = nil

    if gxWidth < 1600 then
        self.ghettoMonitor = true;
    elseif gxWidth >= 3840 then
        local width = gxWidth;
        local height = gxHeight;
        if(self.db.general.multiMonitor) then
            if width >= 9840 then width = 3280; end
            if width >= 7680 and width < 9840 then width = 2560; end
            if width >= 5760 and width < 7680 then width = 1920; end
            if width >= 5040 and width < 5760 then width = 1680; end
            if width >= 4800 and width < 5760 and height == 900 then width = 1600; end
            if width >= 4320 and width < 4800 then width = 1440; end
            if width >= 4080 and width < 4320 then width = 1360; end
            if width >= 3840 and width < 4080 then width = 1224; end
            if width < 1600 then
                self.ghettoMonitor = true;
            end
        else
            if width >= 9840 then width = 9840; end
            if width >= 7680 and width < 9840 then width = 7680; end
            if width >= 5760 and width < 7680 then width = 5760; end
            if width >= 5040 and width < 5760 then width = 5040; end
            if width >= 4800 and width < 5040 then width = 4800; end
            if width >= 4320 and width < 4800 then width = 4320; end
            if width >= 4080 and width < 4320 then width = 4080; end
            if width >= 3840 and width < 4080 then width = 3840; end
        end
        
        evalwidth = width;
    end

    if(parsefloat(UIParent:GetScale(),5) ~= parsefloat(scale,5) and (event == 'PLAYER_LOGIN')) then 
        SetCVar("useUiScale",1)
        SetCVar("uiScale",scale)
        WorldMapFrame.hasTaint = true;
    end

    if(event == 'PLAYER_LOGIN' or event == 'UI_SCALE_CHANGED') then
        if IsMacClient() then 
            self.DisplaySettings.screenheight = floor(GetScreenHeight() * 100 + .5) / 100
            self.DisplaySettings.screenwidth = floor(GetScreenWidth() * 100 + .5) / 100
        end

        if evalwidth then
            local width = evalwidth
            local height = gxHeight;
            if not self.db.general.autoScale or height > 1200 then
                height = UIParent:GetHeight();
                local ratio = gxHeight / height;
                width = evalwidth / ratio;
            end
            self.UIParent:SetSize(width, height);
        else
            self.UIParent:SetSize(UIParent:GetSize());
        end

        self.UIParent:ClearAllPoints()
        self.UIParent:SetPoint("CENTER")

        local change = abs((parsefloat(UIParent:GetScale(),5) * 100) - (parsefloat(scale,5) * 100))
        if(event == 'UI_SCALE_CHANGED' and change > 1 and self.db.general.autoScale) then
            self:StaticPopup_Show('FAILED_UISCALE')
        elseif(event == 'UI_SCALE_CHANGED' and change > 1) then
            self:StaticPopup_Show('RL_CLIENT')
        end 

        self.UIParent:UnregisterEvent('PLAYER_LOGIN')

        self.EffectiveScale = self.UIParent:GetEffectiveScale()
        self.ActualHeight = self.UIParent:GetHeight()
        self.ActualWidth = self.UIParent:GetWidth()
    end 
end
--[[ 
########################################################## 
APPENDED POSITIONING METHODS
##########################################################
]]-- 
do
    local PARAMS = {}

    local function scaled(value)
        if(not SCREEN_MOD) then
            SV:ScreenCalibration()
        end
        return SCREEN_MOD * floor(value / SCREEN_MOD + .5);
    end

    function SizeScaled(self, width, height)
        if(type(width) == "number") then
            local h = (height and type(height) == "number") and height or width
            self:SetSize(scaled(width), scaled(h))
        end
    end 

    function WidthScaled(self, width)
        if(type(width) == "number") then
            self:SetWidth(scaled(width))
        end
    end 

    function HeightScaled(self, height)
        if(type(height) == "number") then
            self:SetHeight(scaled(height))
        end
    end

    function PointScaled(self, ...)
        local n = select('#', ...) 
        PARAMS = {...}
        local arg
        for i = 1, n do
            arg = PARAMS[i]
            if(arg and type(arg) == "number") then 
                PARAMS[i] = scaled(arg)
            end 
        end 
        self:SetPoint(unpack(PARAMS))
    end

    function WrapOuter(self, parent, x, y)
        x = type(x) == "number" and x or 1
        y = y or x
        local nx = scaled(x);
        local ny = scaled(y);
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
        local nx = scaled(x);
        local ny = scaled(y);
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
local _purgatory = NewFrame("Frame", nil)
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
local function SetFontTemplate(self, font, fontSize, fontStyle, fontJustifyH, fontJustifyV, noUpdate)
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
        FontUpdateFrames[self] = true
    end
end 
--[[ 
########################################################## 
FONT UPDATE CALLBACK
##########################################################
]]--
local function FontTemplateUpdates()
    local STANDARDFONTSIZE = SV.db.media.fonts.size;
    for i=1, #FontUpdateFrames do
        local frame = FontUpdateFrames[i] 
        if frame then
            local fontSize = frame.useCommon and STANDARDFONTSIZE or frame.fontSize
            frame:SetFont(frame.font, fontSize, frame.fontStyle)
        else 
            FontUpdateFrames[i] = nil 
        end 
    end 
end

function SV:UpdateFontTemplates()
    FontTemplateUpdates()
end

SV:NewCallback(FontTemplateUpdates)
--[[ 
########################################################## 
APPENDED TEMPLATING METHODS
##########################################################
]]--
local _templates = {
    ["Default"] = {
        backdrop = {
            bgFile = [[Interface\BUTTONS\WHITE8X8]], 
            edgeFile = [[Interface\BUTTONS\WHITE8X8]], 
            tile = false, 
            tileSize = 0, 
            edgeSize = 1, 
            insets = 
            {
                left = 0, 
                right = 0, 
                top = 0, 
                bottom = 0, 
            },
        }, 
        color = "default",
        gradient = "default", 
        texture = [[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]], 
        texupdate = false,
        padding = 1, 
        shadow = false, 
        noupdate = false,
    },
    ["Transparent"] = {
        backdrop = {
            bgFile = [[Interface\BUTTONS\WHITE8X8]], 
            edgeFile = [[Interface\BUTTONS\WHITE8X8]], 
            tile = false, 
            tileSize = 0, 
            edgeSize = 1, 
            insets = 
            {
                left = 0, 
                right = 0, 
                top = 0, 
                bottom = 0, 
            }, 
        },
        color = "transparent",
        gradient = false, 
        texture = false, 
        texupdate = false,
        padding = 1, 
        shadow = false, 
        noupdate = true, 
    },
    ["Component"] = {
        backdrop = {
            bgFile = [[Interface\BUTTONS\WHITE8X8]], 
            edgeFile = [[Interface\BUTTONS\WHITE8X8]], 
            tile = false, 
            tileSize = 0, 
            edgeSize = 2, 
            insets = 
            {
                left = 0, 
                right = 0, 
                top = 0, 
                bottom = 0, 
            },
        }, 
        color = "default",
        gradient = "default", 
        texture = [[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]], 
        texupdate = false,
        padding = 1, 
        shadow = true, 
        noupdate = false, 
    },   
    ["Button"] = {
        backdrop = {
            bgFile = [[Interface\AddOns\SVUI\assets\artwork\Template\BUTTON]], 
            edgeFile = [[Interface\BUTTONS\WHITE8X8]], 
            tile = false, 
            tileSize = 0, 
            edgeSize = 1, 
            insets = 
            {
                left = 1, 
                right = 1, 
                top = 1, 
                bottom = 1, 
            }, 
        },
        color = "default",
        gradient = false, 
        texture = false, 
        texupdate = false,
        padding = 1, 
        shadow = true, 
        noupdate = false, 
    },
    ["FramedTop"] = {
        backdrop = {
            bgFile = [[Interface\BUTTONS\WHITE8X8]], 
            edgeFile = [[Interface\BUTTONS\WHITE8X8]], 
            tile = false, 
            tileSize = 0, 
            edgeSize = 1, 
            insets = 
            {
                left = 0, 
                right = 0, 
                top = 0, 
                bottom = 0, 
            },
        }, 
        color = "default",
        gradient = "darkest2", 
        texture = [[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT2]], 
        texupdate = true,
        padding = 1, 
        shadow = false, 
        noupdate = false,
    },
    ["FramedBottom"] = {
        backdrop = {
            bgFile = [[Interface\BUTTONS\WHITE8X8]], 
            edgeFile = [[Interface\BUTTONS\WHITE8X8]], 
            tile = false, 
            tileSize = 0, 
            edgeSize = 1, 
            insets = 
            {
                left = 0, 
                right = 0, 
                top = 0, 
                bottom = 0, 
            },
        }, 
        color = "default",
        gradient = "darkest", 
        texture = [[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]], 
        texupdate = true,
        padding = 1, 
        shadow = false, 
        noupdate = false,
    },
    ["Bar"] = {
        backdrop = {
            bgFile = [[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]], 
            edgeFile = [[Interface\BUTTONS\WHITE8X8]], 
            tile = false, 
            tileSize = 0, 
            edgeSize = 1, 
            insets = 
            {
                left = 0, 
                right = 0, 
                top = 0, 
                bottom = 0, 
            }, 
        }, 
        color = "transparent",
        gradient = false, 
        texture = false, 
        texupdate = false,
        padding = 1, 
        shadow = false, 
        noupdate = true, 
    },
    ["Slot"] = {
        backdrop = {
            bgFile = [[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]], 
            edgeFile = [[Interface\BUTTONS\WHITE8X8]], 
            tile = false, 
            tileSize = 0, 
            edgeSize = 1, 
            insets = 
            {
                left = 1, 
                right = 1, 
                top = 1, 
                bottom = 1, 
            }, 
        }, 
        color = "transparent",
        gradient = false, 
        texture = false, 
        texupdate = false,
        padding = 2, 
        shadow = true, 
        noupdate = true, 
    },
    ["Inset"] = {
        backdrop = {
            bgFile = [[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]], 
            edgeFile = [[Interface\BUTTONS\WHITE8X8]], 
            tile = false, 
            tileSize = 0, 
            edgeSize = 2, 
            insets = 
            {
                left = 0, 
                right = 0, 
                top = 0, 
                bottom = 0, 
            }, 
        }, 
        color = "transparent",
        gradient = false, 
        texture = false, 
        texupdate = false,
        padding = 2, 
        shadow = false, 
        noupdate = true, 
    },
    ["Comic"] = {
        backdrop = {
            bgFile = [[Interface\AddOns\SVUI\assets\artwork\Template\Background\COMIC1]], 
            edgeFile = [[Interface\BUTTONS\WHITE8X8]], 
            tile = false, 
            tileSize = 0, 
            edgeSize = 2, 
            insets = 
            {
                left = 1, 
                right = 1, 
                top = 1, 
                bottom = 1, 
            },  
        }, 
        color = "class",
        gradient = "class", 
        texture = [[Interface\AddOns\SVUI\assets\artwork\Template\Background\COMIC1]], 
        texupdate = true,
        padding = 2, 
        shadow = false, 
        noupdate = false, 
    },
    ["ModelComic"] = {
        backdrop = {
            bgFile = [[Interface\AddOns\SVUI\assets\artwork\Template\Background\COMIC-MODEL]], 
            edgeFile = [[Interface\BUTTONS\WHITE8X8]], 
            tile = false, 
            tileSize = 0, 
            edgeSize = 3, 
            insets = 
            {
                left = 0, 
                right = 0, 
                top = 0, 
                bottom = 0, 
            },  
        }, 
        color = "special",
        gradient = "class", 
        texture = [[Interface\AddOns\SVUI\assets\artwork\Template\Background\COMIC-MODEL]], 
        texupdate = false,
        padding = 3,
        shadow = false, 
        noupdate = true, 
    },
    ["Paper"] = {
        backdrop = {
            bgFile = [[Interface\AddOns\SVUI\assets\artwork\Template\Background\PAPER]], 
            edgeFile = [[Interface\BUTTONS\WHITE8X8]], 
            tile = false, 
            tileSize = 0, 
            edgeSize = 2, 
            insets = 
            {
                left = 1, 
                right = 1, 
                top = 1, 
                bottom = 1, 
            },  
        }, 
        color = "white",
        gradient = "white", 
        texture = [[Interface\AddOns\SVUI\assets\artwork\Template\Background\PAPER]], 
        texupdate = false,
        padding = 2, 
        shadow = false, 
        noupdate = true, 
    },
    ["Container"] = {
        backdrop = {
            bgFile = [[Interface\AddOns\SVUI\assets\artwork\Template\Background\PATTERN3]], 
            edgeFile = [[Interface\BUTTONS\WHITE8X8]], 
            tile = false, 
            tileSize = 0, 
            edgeSize = 2, 
            insets = 
            {
                left = 1, 
                right = 1, 
                top = 1, 
                bottom = 1, 
            },  
        }, 
        color = "special",
        gradient = "special", 
        texture = [[Interface\AddOns\SVUI\assets\artwork\Template\Background\PATTERN3]], 
        texupdate = true,
        padding = 2, 
        shadow = true, 
        noupdate = false, 
    },
    ["Pattern"] = {
        backdrop = {
            bgFile = [[Interface\AddOns\SVUI\assets\artwork\Template\Background\PATTERN1]], 
            edgeFile = [[Interface\BUTTONS\WHITE8X8]], 
            tile = false, 
            tileSize = 0, 
            edgeSize = 2, 
            insets = 
            {
                left = 1, 
                right = 1, 
                top = 1, 
                bottom = 1, 
            }, 
        }, 
        color = "special",
        gradient = "special", 
        texture = [[Interface\AddOns\SVUI\assets\artwork\Template\Background\PATTERN1]], 
        texupdate = true,
        padding = 2, 
        shadow = true, 
        noupdate = false, 
    }, 
    ["Halftone"] = {
        backdrop = {
            bgFile = [[Interface\BUTTONS\WHITE8X8]], 
            edgeFile = [[Interface\BUTTONS\WHITE8X8]], 
            tile = false, 
            tileSize = 0, 
            edgeSize = 2, 
            insets = 
            {
                left = 1, 
                right = 1, 
                top = 1, 
                bottom = 1, 
            }, 
        }, 
        color = "default",
        gradient = "special", 
        texture = [[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]], 
        texupdate = true,
        padding = 2, 
        shadow = true, 
        noupdate = false, 
        extended = [[HALFTONE]], 
    }, 
    ["Action"] = {
        backdrop = {
            bgFile = [[Interface\BUTTONS\WHITE8X8]], 
            edgeFile = [[Interface\BUTTONS\WHITE8X8]], 
            tile = false, 
            tileSize = 0, 
            edgeSize = 2, 
            insets = 
            {
                left = 1, 
                right = 1, 
                top = 1, 
                bottom = 1, 
            },  
        }, 
        color = "default",
        gradient = "special", 
        texture = [[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]], 
        texupdate = true,
        padding = 2, 
        shadow = true, 
        noupdate = false, 
        extended = [[ACTION]], 
    },
    ["Blackout"] = {
        backdrop = {
            bgFile = [[Interface\BUTTONS\WHITE8X8]], 
            edgeFile = [[Interface\BUTTONS\WHITE8X8]], 
            tile = false, 
            tileSize = 0, 
            edgeSize = 2, 
            insets = 
            {
                left = 1, 
                right = 1, 
                top = 1, 
                bottom = 1, 
            },  
        }, 
        color = "transparent",
        gradient = false, 
        texture = [[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]], 
        texupdate = false,
        padding = 2,
        forcedOffset = 2, 
        shadow = true, 
        noupdate = true, 
    }, 
    ["UnitLarge"] = {
        backdrop = false, 
        color = "special",
        gradient = false, 
        texture = [[Interface\AddOns\SVUI\assets\artwork\Unitframe\Background\UNIT-BG1]], 
        texupdate = true,
        padding = 0,
        forcedOffset = 0,
        shadow = false, 
        noupdate = false, 
    }, 
    ["UnitSmall"] = {
        backdrop = false, 
        color = "special",
        gradient = false, 
        texture = [[Interface\AddOns\SVUI\assets\artwork\Unitframe\Background\UNIT-SMALL-BG1]], 
        texupdate = true,
        padding = 0,
        forcedOffset = 0,
        shadow = false, 
        noupdate = false, 
    } 
};
--[[ 
########################################################## 
INTERNAL HANDLERS
##########################################################
]]--
local HookPanelBorderColor = function(self,r,g,b,a)
    if self[1]then 
        self[1]:SetTexture(r,g,b,a)
        self[2]:SetTexture(r,g,b,a)
        self[3]:SetTexture(r,g,b,a)
        self[4]:SetTexture(r,g,b,a)
        if self[5]then 
            self[5]:SetBackdropBorderColor(r,g,b,0.7)
        end 
    end 
end 

local HookBackdrop = function(self,...) 
    self.Panel:SetBackdrop(...) 
end 

local HookBackdropColor = function(self,...) 
    self.Panel:SetBackdropColor(...) 
end 

local HookBackdropBorderColor = function(self,...)
    self.Panel:SetBackdropBorderColor(...)
end 

local HookVertexColor = function(self,...) 
    self._skin:SetVertexColor(...) 
end 

local HookCustomBackdrop = function(self)
    local newBgFile = SV.Media.bg[self._bdtex]
    local bd = {
        bgFile = newBgFile, 
        edgeFile = [[Interface\BUTTONS\WHITE8X8]], 
        tile = false, 
        tileSize = 0, 
        edgeSize = 2, 
        insets = 
        {
            left = 2, 
            right = 2, 
            top = 2, 
            bottom = 2, 
        }, 
    }
    self:SetBackdrop(bd)
end

local HookFrameLevel = function(self, level)
    local adjustment = level - 1;
    if(adjustment < 0) then adjustment = 0 end
    self.Panel:SetFrameLevel(adjustment)
end
--[[ 
########################################################## 
TEMPLATE HELPERS
##########################################################
]]--
local function CreatePanelTemplate(frame, templateName, underlay, noupdate, padding, xOffset, yOffset, defaultColor)
    if(not templateName or not _templates[templateName]) then templateName = frame._template or 'Default' end

    local settings = _templates[templateName]
    local colorName = defaultColor or settings.color or "default"
    local gradientName = settings.gradient
    local texFile = settings.texture
    local hasShadow = settings.shadow
    local bd = settings.backdrop
    local bypass = noupdate or settings.noupdate
    local bgColor = SV.Media.color[colorName] or {0.18,0.18,0.18,1}
    local borderColor = {0,0,0,1}
    local initLevel = 0;
    local needsHooks = false;

    padding = padding or settings.padding or 1

    xOffset = settings.forcedOffset or xOffset or 1
    yOffset = settings.forcedOffset or yOffset or 1

    frame._template = templateName;
    frame._color = colorName;
    frame._gradient = gradientName;
    frame._texture = false;
    frame._noupdate = bypass;

    if(not frame.Panel) then
        needsHooks = true

        local panel = NewFrame('Frame', nil, frame)
        panel:Point('TOPLEFT', frame, 'TOPLEFT', (xOffset * -1), yOffset)
        panel:Point('BOTTOMRIGHT', frame, 'BOTTOMRIGHT', xOffset, (yOffset * -1))

        if(padding > 0 and type(t) == 'table') then 
            panel[1] = panel:CreateTexture(nil,"BORDER")
            panel[1]:SetTexture(0,0,0)
            panel[1]:SetPoint("TOPLEFT")
            panel[1]:SetPoint("BOTTOMLEFT")
            panel[1]:SetWidth(padding)
            panel[2] = panel:CreateTexture(nil,"BORDER")
            panel[2]:SetTexture(0,0,0)
            panel[2]:SetPoint("TOPRIGHT")
            panel[2]:SetPoint("BOTTOMRIGHT")
            panel[2]:SetWidth(padding)
            panel[3] = panel:CreateTexture(nil,"BORDER")
            panel[3]:SetTexture(0,0,0)
            panel[3]:SetPoint("TOPLEFT")
            panel[3]:SetPoint("TOPRIGHT")
            panel[3]:SetHeight(padding)
            panel[4] = panel:CreateTexture(nil,"BORDER")
            panel[4]:SetTexture(0,0,0)
            panel[4]:SetPoint("BOTTOMLEFT")
            panel[4]:SetPoint("BOTTOMRIGHT")
            panel[4]:SetHeight(padding)
        end

        local level = frame:GetFrameLevel()
        if(level == 0 and not InCombatLockdown()) then
            frame:SetFrameLevel(1)
            level = 1
        end

        local adjustment = level - 1;
        if(adjustment < 0) then adjustment = 0 end

        panel:SetFrameLevel(adjustment)

        NewHook(frame, "SetFrameLevel", HookFrameLevel)

        frame.Panel = panel
    end 

    if(hasShadow) then
        if(not frame.Panel[5]) then
            if(underlay) then
                frame.Panel[5] = NewFrame('Frame', nil, frame.Panel)
                frame.Panel[5]:Point('TOPLEFT', frame.Panel, 'TOPLEFT', -3, 3)
                frame.Panel[5]:Point('BOTTOMRIGHT', frame.Panel, 'BOTTOMRIGHT', 3, -3)
            else
                frame.Panel[5] = NewFrame('Frame', nil, frame)
                frame.Panel[5]:Point('TOPLEFT', frame, 'TOPLEFT', -3, 3)
                frame.Panel[5]:Point('BOTTOMRIGHT', frame, 'BOTTOMRIGHT', 3, -3)
            end
        end

        frame.Panel[5]:SetBackdrop({
            edgeFile = [[Interface\AddOns\SVUI\assets\artwork\Template\GLOW]],
            edgeSize = 3,
            insets = {
                left = 0,
                right = 0,
                top = 0,
                bottom = 0
            }
        });

        frame.Panel[5]:SetBackdropBorderColor(0,0,0,0.5)

        local level = frame.Panel[5]:GetFrameLevel() - 1

        if(level >= 0) then 
            frame.Panel[5]:SetFrameLevel(level)
        else 
            frame.Panel[5]:SetFrameLevel(0)
        end
    end


    if(bd) then
        initLevel = 1;
        if(underlay) then
            frame.Panel:SetBackdrop(bd)
            frame.Panel:SetBackdropColor(bgColor[1],bgColor[2],bgColor[3],bgColor[4] or 1)
            frame.Panel:SetBackdropBorderColor(0,0,0,1)
        else
            frame:SetBackdrop(bd)
            frame:SetBackdropColor(bgColor[1],bgColor[2],bgColor[3],bgColor[4] or 1)
            frame:SetBackdropBorderColor(0,0,0,1)
        end

        if(needsHooks and templateName ~= 'Transparent') then
            NewHook(frame.Panel, "SetBackdropBorderColor", HookPanelBorderColor)
            NewHook(frame, "SetBackdropBorderColor", HookBackdropBorderColor)
            if(underlay) then
                NewHook(frame, "SetBackdrop", HookBackdrop)
                NewHook(frame, "SetBackdropColor", HookBackdropColor)
            end
            frame.BackdropNeedsUpdate = true
            if(templateName == 'Pattern' or templateName == 'Comic') then
                frame._bdtex = lower(templateName)
                frame.UpdateBackdrop = HookCustomBackdrop
            end
        end
    end

    if(texFile) then
        if(not frame._skin) then
            if(underlay) then
                frame._skin = frame.Panel:CreateTexture(nil,"BACKGROUND",nil,initLevel)
                frame._skin:SetAllPoints(frame.Panel)
            else
                frame._skin = frame:CreateTexture(nil,"BACKGROUND",nil,initLevel)
                frame._skin:SetAllPoints(frame)
            end
        end
        
        frame._skin:SetTexture(texFile)

        if(gradientName and SV.Media.gradient[gradientName]) then
            frame._skin:SetGradient(unpack(SV.Media.gradient[gradientName]))
        else 
            frame._skin:SetVertexColor(bgColor[1], bgColor[2], bgColor[3], bgColor[4] or 1)
        end

        frame._skin:SetNonBlocking(true)

        if((not bypass) and settings.texupdate) then
            frame._texture = lower(templateName)
            frame.TextureNeedsUpdate = true
            if(templateName == 'UnitLarge' or templateName == 'UnitSmall') then
                frame.UpdateColor = HookVertexColor
                frame.NoColorUpdate = true
            end
        end

        initLevel = 2;
    end

    if(settings.extended) then
        if(not underlay) then
            initLevel = 0
        end

        local name = settings.extended

        if(not frame._extended) then
            frame._extended = {}

            frame._extended[1] = frame.Panel:CreateTexture(nil, "BACKGROUND", nil, initLevel)
            frame._extended[1]:SetPoint("TOPLEFT", frame.Panel, "TOPLEFT", 0, 0)
            frame._extended[1]:SetPoint("TOPRIGHT", frame.Panel, "TOP", 0, 0)
            frame._extended[1]:SetPoint("BOTTOMLEFT", frame.Panel, "LEFT", 0, 0)

            frame._extended[2] = frame.Panel:CreateTexture(nil, "BACKGROUND", nil, initLevel)
            frame._extended[2]:SetPoint("TOPRIGHT", frame.Panel, "TOPRIGHT", 0, 0)
            frame._extended[2]:SetPoint("TOPLEFT", frame.Panel, "TOP", 0, 0)
            frame._extended[2]:SetPoint("BOTTOMRIGHT", frame.Panel, "RIGHT", 0, 0)

            frame._extended[3] = frame.Panel:CreateTexture(nil, "BACKGROUND", nil, initLevel)
            frame._extended[3]:SetPoint("BOTTOMRIGHT", frame.Panel, "BOTTOMRIGHT", 0, 0)
            frame._extended[3]:SetPoint("BOTTOMLEFT", frame.Panel, "BOTTOM", 0, 0)
            frame._extended[3]:SetPoint("TOPRIGHT", frame.Panel, "RIGHT", 0, 0)

            frame._extended[4] = frame.Panel:CreateTexture(nil, "BACKGROUND", nil, initLevel)
            frame._extended[4]:SetPoint("BOTTOMLEFT", frame.Panel, "BOTTOMLEFT", 0, 0)
            frame._extended[4]:SetPoint("BOTTOMRIGHT", frame.Panel, "BOTTOM", 0, 0)
            frame._extended[4]:SetPoint("TOPLEFT", frame.Panel, "LEFT", 0, 0)
        end  

        frame._extended[1]:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Template\Extended\]] .. name .. [[_TOPLEFT]])
        frame._extended[1]:SetVertexColor(0.05, 0.05, 0.05, 0.5)
        frame._extended[1]:SetNonBlocking(true)

        frame._extended[2]:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Template\Extended\]] .. name .. [[_TOPRIGHT]])
        frame._extended[2]:SetVertexColor(0.05, 0.05, 0.05, 0.5)
        frame._extended[2]:SetNonBlocking(true)

        frame._extended[3]:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Template\Extended\]] .. name .. [[_BOTTOMRIGHT]])
        frame._extended[3]:SetVertexColor(0.1, 0.1, 0.1, 0.5)
        frame._extended[3]:SetNonBlocking(true)

        frame._extended[4]:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Template\Extended\]] .. name .. [[_BOTTOMLEFT]])
        frame._extended[4]:SetVertexColor(0.1, 0.1, 0.1, 0.5)
        frame._extended[4]:SetNonBlocking(true)
    end
end 

local function HasCooldown(n)
    local cd = n and n.."Cooldown"
    return cd and _G[cd]
end

local function CreateButtonPanel(frame, noChecked, brightChecked)
    
    if(frame.Left) then 
        frame.Left:SetAlpha(0)
    end 

    if(frame.Middle) then 
        frame.Middle:SetAlpha(0)
    end 

    if(frame.Right) then 
        frame.Right:SetAlpha(0)
    end 

    if(frame.SetNormalTexture) then 
        frame:SetNormalTexture("")
    end 

    if(frame.SetDisabledTexture) then 
        frame:SetDisabledTexture("")
    end

    if(frame.SetCheckedTexture) then 
        frame:SetCheckedTexture("")
    end

    if(frame.SetHighlightTexture) then
        if(not frame.hover) then
            local hover = frame:CreateTexture(nil, "OVERLAY")
            hover:FillInner(frame.Panel)
            frame.hover = hover;
        end
        local color = SV.Media.color.highlight
        frame.hover:SetTexture(color[1], color[2], color[3], 0.5)
        frame:SetHighlightTexture(frame.hover) 
    end 

    if(frame.SetPushedTexture) then
        if(not frame.pushed) then 
            local pushed = frame:CreateTexture(nil, "OVERLAY")
            pushed:FillInner(frame.Panel)
            frame.pushed = pushed;
        end
        frame.pushed:SetTexture(0.1, 0.8, 0.1, 0.3)
        frame:SetPushedTexture(frame.pushed)
    end 

    if(not noChecked and frame.SetCheckedTexture) then
        if(not frame.checked) then
            local checked = frame:CreateTexture(nil, "OVERLAY")
            checked:FillInner(frame.Panel)
            frame.checked = checked
        end

        if(not brightChecked) then
            frame.checked:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
            frame.checked:SetVertexColor(0, 0.5, 0, 0.2)
        else
            frame.checked:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Bars\GLOSS]])
            frame.checked:SetVertexColor(0, 1, 0, 1)
        end
        
        frame:SetCheckedTexture(frame.checked)
    end

    local cd = HasCooldown(frame:GetName())
    if cd then 
        cd:ClearAllPoints()
        cd:SetAllPoints()
    end
end 
--[[ 
########################################################## 
TEMPLATE API
##########################################################
]]--
local function SetBasicPanel(self, topX, topY, bottomX, bottomY, hasShadow)
    local needsHooks = false;
        
    if(hasShadow) then
        if(not self.Panel) then
            needsHooks = true

            self.Panel = CreateFrame("Frame", nil, self) 
            self.Panel:SetPoint("TOPLEFT", self, "TOPLEFT", -2, 2)
            self.Panel:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 2, -2)
        end

        self.Panel:SetBackdrop({
            bgFile = [[Interface\BUTTONS\WHITE8X8]],  
            tile = false, 
            tileSize = 0,
            edgeFile = [[Interface\AddOns\SVUI\assets\artwork\Template\GLOW]],
            edgeSize = 3,
            insets = 
            {
                left = 0, 
                right = 0, 
                top = 0, 
                bottom = 0, 
            }, 
        })
        self.Panel:SetBackdropColor(0,0,0,0)
        self.Panel:SetBackdropBorderColor(0,0,0)
    else
        if(not self.Panel) then
            needsHooks = true 

            self.Panel = CreateFrame("Frame", nil, self) 
            self.Panel:SetPoint("TOPLEFT", self, "TOPLEFT", topX, topY)
            self.Panel:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", bottomX, bottomY)
        end

        self.Panel:SetBackdrop({
            bgFile = [[Interface\BUTTONS\WHITE8X8]],  
            tile = false, 
            tileSize = 0,
            edgeFile = [[Interface\BUTTONS\WHITE8X8]],
            edgeSize = 1, 
            insets = 
            {
                left = 1, 
                right = 1, 
                top = 1, 
                bottom = 1, 
            }, 
        })
        self.Panel:SetBackdropColor(0,0,0,0.65)
        self.Panel:SetBackdropBorderColor(0,0,0)
    end

    if(needsHooks) then
        local level = self:GetFrameLevel()
        if(level == 0 and not InCombatLockdown()) then
            self:SetFrameLevel(1)
            level = 1
        end

        local adjustment = level - 1;
        if(adjustment < 0) then adjustment = 0 end

        self.Panel:SetFrameLevel(adjustment)

        NewHook(self, "SetFrameLevel", HookFrameLevel)
        NewHook(self, "SetBackdrop", HookBackdrop)
        NewHook(self, "SetBackdropColor", HookBackdropColor)
        NewHook(self, "SetBackdropBorderColor", HookBackdropBorderColor)
    end
end

local function SetPanelTemplate(self, templateName, noupdate, overridePadding, xOffset, yOffset, defaultColor)
    local padding = false
    if(overridePadding and type(overridePadding) == "number") then
        padding = overridePadding
    end

    CreatePanelTemplate(self, templateName, true, noupdate, padding, xOffset, yOffset, defaultColor)

    if(not self._noupdate and not self.__registered) then
        TemplateUpdateFrames[self] = true
        self.__registered = true
    end
end 

local function SetFixedPanelTemplate(self, templateName, noupdate, overridePadding, xOffset, yOffset, defaultColor)
    local padding = false
    if(overridePadding and type(overridePadding) == "number") then
        padding = overridePadding
    end

    CreatePanelTemplate(self, templateName, false, noupdate, padding, xOffset, yOffset, defaultColor)

    if(not self._noupdate and not self.__registered) then
        TemplateUpdateFrames[self] = true
        self.__registered = true
    end
end 

local function SetPanelColor(self, ...)
    local arg1,arg2,arg3,arg4,arg5,arg6,arg7 = select(1, ...)
    if(not self.Panel or not arg1) then return; end 
    if(self._skin and self._gradient) then
        if(type(arg1) == "string") then
            if(arg1 == "VERTICAL" or arg1 == "HORIZONTAL") then
                self._skin:SetGradient(...)
            elseif(SV.Media.gradient[arg1]) then
                if self.__border then
                    local d,r,g,b,r2,g2,b2 = unpack(SV.Media.gradient[arg1])
                    --self._skin:SetGradient(d,r,g,b,r2,g2,b2)
                    self.__border[1]:SetTexture(r2,g2,b2)
                    self.__border[2]:SetTexture(r2,g2,b2)
                    self.__border[3]:SetTexture(r2,g2,b2)
                    self.__border[4]:SetTexture(r2,g2,b2)
                else
                    self._skin:SetGradient(unpack(SV.Media.gradient[arg1]))
                    if(SV.Media.color[arg1]) then
                        local t = SV.Media.color[arg1]
                        local r,g,b,a = t[1], t[2], t[3], t[4] or 1;
                        self:SetBackdropColor(r,g,b,a)
                    end
                end
            end 
        end 
    elseif(type(arg1) == "string" and SV.Media.color[arg1]) then
        local t = SV.Media.color[arg1]
        local r,g,b,a = t[1], t[2], t[3], t[4] or 1;
        if self.__border then
            self.__border[1]:SetTexture(r,g,b)
            self.__border[2]:SetTexture(r,g,b)
            self.__border[3]:SetTexture(r,g,b)
            self.__border[4]:SetTexture(r,g,b)
        else
            self:SetBackdropColor(r,g,b)
        end
    elseif(arg1 and type(arg1) == "number") then
        self:SetBackdropColor(...)
    end 
end 
--[[ 
########################################################## 
APPENDED BUTTON TEMPLATING METHODS
##########################################################
]]--
local function SetButtonTemplate(self, invisible, overridePadding, xOffset, yOffset, keepNormal, defaultColor)
    if(not self) then return end

    local padding = 1
    if(overridePadding and type(overridePadding) == "number") then
        padding = overridePadding
    end

    local x,y = -1,-1
    local underlay = false
    if(xOffset or yOffset) then
        x = xOffset or -1
        y = yOffset or -1
        underlay = true
    end

    if(invisible) then
        CreatePanelTemplate(self, "Transparent", underlay, true, padding, x, y, defaultColor)
        self:SetBackdropColor(0,0,0,0)
        self:SetBackdropBorderColor(0,0,0,0)
    else
        CreatePanelTemplate(self, "Button", underlay, true, padding, x, y, defaultColor)
    end

    if(self.Left) then 
        self.Left:SetAlpha(0)
    end 

    if(self.Middle) then 
        self.Middle:SetAlpha(0)
    end 

    if(self.Right) then 
        self.Right:SetAlpha(0)
    end 

    if(self.SetNormalTexture and not keepNormal) then
        self:SetNormalTexture("")
    end 

    if(self.SetDisabledTexture) then 
        self:SetDisabledTexture("")
    end 

    if(self.SetHighlightTexture) then
        if(not self.hover) then
            local hover = self:CreateTexture(nil, "HIGHLIGHT")
            FillInner(hover, self.Panel)
            self.hover = hover;
        end

        local color = SV.Media.color.highlight
        self.hover:SetTexture(color[1], color[2], color[3], 0.5)

        self:SetHighlightTexture(self.hover) 
    end 

    if(self.SetPushedTexture) then
        if(not self.pushed) then 
            local pushed = self:CreateTexture(nil, "OVERLAY")
            FillInner(pushed, self.Panel)
            self.pushed = pushed;
        end

        self.pushed:SetTexture(0.1, 0.8, 0.1, 0.3)

        self:SetPushedTexture(self.pushed)
    end 

    if(self.SetCheckedTexture) then
        if(not self.checked) then 
            local checked = self:CreateTexture(nil, "OVERLAY")
            FillInner(checked, self.Panel)
            self.checked = checked;
        end

        self.checked:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
        self.checked:SetVertexColor(0, 0.5, 0, 0.2)

        self:SetCheckedTexture(self.checked)
    end 

    local cd = HasCooldown(self:GetName())
    if cd then 
        cd:ClearAllPoints()
        cd:SetAllPoints()
    end 
end 

local function SetSlotTemplate(self, underlay, padding, x, y, noChecked)
    if(not self) then return end

    padding = padding or 1
    CreatePanelTemplate(self, "Slot", underlay, true, padding, x, y)
    CreateButtonPanel(self, true)
end 

local function SetCheckboxTemplate(self, underlay, x, y)
    if(not self or (self and self.__hooked)) then return end

    if(underlay) then
        x = x or -7
        y = y or -7
    end

    CreatePanelTemplate(self, "Slot", underlay, true, 1, x, y)
    CreateButtonPanel(self, false, true)

    NewHook(self, "SetChecked", function(self,checked)
        local r,g,b = 0,0,0
        if(checked == 1) then
            r,g,b = self:GetCheckedTexture():GetVertexColor()
        end
        self:SetBackdropBorderColor(r,g,b) 
    end)
    self.__hooked = true
end 

local function SetEditboxTemplate(self, x, y)
    if(not self or (self and self.Panel)) then return end

    if self.TopLeftTex then Die(self.TopLeftTex) end 
    if self.TopRightTex then Die(self.TopRightTex) end 
    if self.TopTex then Die(self.TopTex) end 
    if self.BottomLeftTex then Die(self.BottomLeftTex) end 
    if self.BottomRightTex then Die(self.BottomRightTex) end 
    if self.BottomTex then Die(self.BottomTex) end 
    if self.LeftTex then Die(self.LeftTex) end 
    if self.RightTex then Die(self.RightTex) end 
    if self.MiddleTex then Die(self.MiddleTex) end 

    CreatePanelTemplate(self, "Inset", true, true, 1, x, y)

    local globalName = self:GetName();
    if globalName then 
        if _G[globalName.."Left"] then Die(_G[globalName.."Left"]) end 
        if _G[globalName.."Middle"] then Die(_G[globalName.."Middle"]) end 
        if _G[globalName.."Right"] then Die(_G[globalName.."Right"]) end 
        if _G[globalName.."Mid"] then Die(_G[globalName.."Mid"]) end

        if globalName:find("Silver") or globalName:find("Copper") or globalName:find("Gold") then
            self.Panel:SetPoint("TOPLEFT", -3, 1)
            if globalName:find("Silver") or globalName:find("Copper") then
                self.Panel:SetPoint("BOTTOMRIGHT", -12, -2)
            else
                self.Panel:SetPoint("BOTTOMRIGHT", -2, -2) 
            end 
        end 
    end
end 

local function SetFramedButtonTemplate(self, template, borderSize)
    if(not self or (self and self.Panel)) then return end

    borderSize = borderSize or 2

    template = template or self._template or "FramedBottom"

    CreatePanelTemplate(self, template, false, false, 0, -borderSize, -borderSize)

    if(self.Left) then 
        self.Left:SetAlpha(0)
    end 

    if(self.Middle) then 
        self.Middle:SetAlpha(0)
    end 

    if(self.Right) then 
        self.Right:SetAlpha(0)
    end 

    if(self.SetNormalTexture) then 
        self:SetNormalTexture("")
    end 

    if(self.SetDisabledTexture) then 
        self:SetDisabledTexture("")
    end 

    if(not self.__border) then
        local t = SV.Media.color.default
        local r,g,b = t[1], t[2], t[3]

        local border = {}

        border[1] = self:CreateTexture(nil,"BORDER")
        border[1]:SetTexture(r,g,b)
        border[1]:SetPoint("TOPLEFT", -1, 1)
        border[1]:SetPoint("BOTTOMLEFT", -1, -1)
        border[1]:SetWidth(borderSize)

        local leftoutline = self:CreateTexture(nil,"BORDER")
        leftoutline:SetTexture(0,0,0)
        leftoutline:SetPoint("TOPLEFT", -2, 2)
        leftoutline:SetPoint("BOTTOMLEFT", -2, -2)
        leftoutline:SetWidth(1)

        border[2] = self:CreateTexture(nil,"BORDER")
        border[2]:SetTexture(r,g,b)
        border[2]:SetPoint("TOPRIGHT", 1, 1)
        border[2]:SetPoint("BOTTOMRIGHT", 1, -1)
        border[2]:SetWidth(borderSize)

        local rightoutline = self:CreateTexture(nil,"BORDER")
        rightoutline:SetTexture(0,0,0)
        rightoutline:SetPoint("TOPRIGHT", 2, 2)
        rightoutline:SetPoint("BOTTOMRIGHT", 2, -2)
        rightoutline:SetWidth(1)

        border[3] = self:CreateTexture(nil,"BORDER")
        border[3]:SetTexture(r,g,b)
        border[3]:SetPoint("TOPLEFT", -1, 1)
        border[3]:SetPoint("TOPRIGHT", 1, 1)
        border[3]:SetHeight(borderSize)

        local topoutline = self:CreateTexture(nil,"BORDER")
        topoutline:SetTexture(0,0,0)
        topoutline:SetPoint("TOPLEFT", -2, 2)
        topoutline:SetPoint("TOPRIGHT", 2, 2)
        topoutline:SetHeight(1)

        border[4] = self:CreateTexture(nil,"BORDER")
        border[4]:SetTexture(r,g,b)
        border[4]:SetPoint("BOTTOMLEFT", -1, -1)
        border[4]:SetPoint("BOTTOMRIGHT", 1, -1)
        border[4]:SetHeight(borderSize)

        local bottomoutline = self:CreateTexture(nil,"BORDER")
        bottomoutline:SetTexture(0,0,0)
        bottomoutline:SetPoint("BOTTOMLEFT", -2, -2)
        bottomoutline:SetPoint("BOTTOMRIGHT", 2, -2)
        bottomoutline:SetHeight(1)

        self.__border = border
    end

    if(not self.hover) then
        self.hover = self:CreateTexture(nil, "HIGHLIGHT")
    end

    local color = SV.Media.color.highlight
    self.hover:SetTexture(color[1], color[2], color[3], 0.5)
    self.hover:SetAllPoints()
    if(self.SetHighlightTexture) then
        self:SetHighlightTexture(self.hover)
    end

    if(not self.__registered) then
        TemplateUpdateFrames[self] = true
        self.__registered = true
    end
end 
--[[ 
########################################################## 
TEMPLATE UPDATE CALLBACK
##########################################################
]]--
local function FrameTemplateUpdates()
    for frame in pairs(TemplateUpdateFrames) do
        if(frame) then
            local p = SV.Media.color[frame._color];
            if(frame.BackdropNeedsUpdate) then
                if(frame.UpdateBackdrop) then
                    frame:UpdateBackdrop()
                end
                if(p) then
                    frame:SetBackdropColor(p[1], p[2], p[3], p[4] or 1)
                end
                frame:SetBackdropBorderColor(0,0,0,1)
            end
            if(frame.TextureNeedsUpdate and frame._texture) then
                local tex = SV.Media.bg[frame._texture]
                if(tex) then
                    frame._skin:SetTexture(tex)
                end 
                if(not frame.NoColorUpdate) then
                    if(frame._gradient and SV.Media.gradient[frame._gradient]) then
                        local g = SV.Media.gradient[frame._gradient]
                        frame._skin:SetGradient(g[1], g[2], g[3], g[4], g[5], g[6], g[7])
                    elseif(p) then
                        frame._skin:SetVertexColor(p[1], p[2], p[3], p[4] or 1)
                    end
                end
            end
        end
    end
end

SV:NewCallback(FrameTemplateUpdates)
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
    if not OBJECT.SetBasicPanel then META.SetBasicPanel = SetBasicPanel end
    if not OBJECT.SetPanelTemplate then META.SetPanelTemplate = SetPanelTemplate end
    if not OBJECT.SetFixedPanelTemplate then META.SetFixedPanelTemplate = SetFixedPanelTemplate end
    if not OBJECT.SetPanelColor then META.SetPanelColor = SetPanelColor end
    if not OBJECT.SetButtonTemplate then META.SetButtonTemplate = SetButtonTemplate end
    if not OBJECT.SetSlotTemplate then META.SetSlotTemplate = SetSlotTemplate end
    if not OBJECT.SetCheckboxTemplate then META.SetCheckboxTemplate = SetCheckboxTemplate end
    if not OBJECT.SetEditboxTemplate then META.SetEditboxTemplate = SetEditboxTemplate end
    if not OBJECT.SetFramedButtonTemplate then META.SetFramedButtonTemplate = SetFramedButtonTemplate end
    if not OBJECT.SetFontTemplate then META.SetFontTemplate = SetFontTemplate end
end

local HANDLER, OBJECT = {["Frame"] = true}, NewFrame("Frame")
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