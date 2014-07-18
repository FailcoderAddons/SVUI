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
--[[ STRING METHODS ]]--
local lower = string.lower;
--[[ TABLE METHODS ]]--
local tremove, tcopy, twipe, tsort, tconcat, tdump = table.remove, table.copy, table.wipe, table.sort, table.concat, table.dump;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L = unpack(select(2, ...))
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local TemplateUpdateFrames = {};
local FontUpdateFrames = {};

local NewFrame = CreateFrame;
local NewHook = hooksecurefunc;
local screenMod = SuperVillain.mult;
local STANDARD_TEXT_FONT = _G.STANDARD_TEXT_FONT
--[[ 
########################################################## 
APPENDED POSITIONING METHODS
##########################################################
]]--
local function UserScale(value)
    return screenMod * floor(value / screenMod + .5);
end;

local function Size(self,width,height)
    if not self then return end;
    self:SetSize(UserScale(width),UserScale(height or width))
end;

local function Width(self,b)
    if not self then return end;
    self:SetWidth(UserScale(b))
end;

local function Height(self,c)
    if not self then return end;
    self:SetHeight(UserScale(c))
end;

local function Point(self, ...)
    local arg1, arg2, arg3, arg4, arg5 = select(1, ...)
    if not self then return end; 
    local params = { arg1, arg2, arg3, arg4, arg5 }
    for i = 1, #params do 
        if type(params[i]) == "number" then 
            params[i] = UserScale(params[i])
        end 
    end 
    self:SetPoint(unpack(params))
end;

local function WrapOuter(self, target, x, y)
    x = UserScale(x or 1);
    y = UserScale(y or x);
    target = target or self:GetParent()
    if self:GetPoint() then 
        self:ClearAllPoints()
    end;
    self:SetPoint("TOPLEFT", target, "TOPLEFT", -x, y)
    self:SetPoint("BOTTOMRIGHT", target, "BOTTOMRIGHT", x, -y)
end;

local function FillInner(self, target, x, y)
    x = UserScale(x or 1);
    y = UserScale(y or x);
    target = target or self:GetParent()
    if self:GetPoint() then 
        self:ClearAllPoints()
    end;
    self:SetPoint("TOPLEFT", target, "TOPLEFT", x, -y)
    self:SetPoint("BOTTOMRIGHT", target, "BOTTOMRIGHT", -x, y)
end;
--[[ 
########################################################## 
APPENDED DESTROY METHODS
##########################################################
]]--
-- MUNG ( Modify - Until - No - Good )
local Purgatory = NewFrame("Frame", nil)
Purgatory:Hide()

local function MUNG(self)
    if self.UnregisterAllEvents then 
        self:UnregisterAllEvents()
        self:SetParent(Purgatory)
    else 
        self.Show = self.Hide 
    end;
    self:Hide()
end;

local function Formula409(self, option)
    for i = 1, self:GetNumRegions()do 
        local target = select(i, self:GetRegions())
        if(target and (target:GetObjectType() == "Texture")) then 
            if(option and (type(option) == "boolean")) then 
                if target.UnregisterAllEvents then 
                    target:UnregisterAllEvents()
                    target:SetParent(Purgatory)
                else 
                    target.Show = target.Hide 
                end;
                target:Hide()
            elseif(target:GetDrawLayer() == option) then 
                target:SetTexture(nil)
            elseif(option and (type(option) == "string") and (target:GetTexture() ~= option)) then 
                target:SetTexture(nil)
            else 
                target:SetTexture(nil)
            end 
        end 
    end 
end;
--[[ 
########################################################## 
APPENDED FONT TEMPLATING METHODS
##########################################################
]]--
local function SetFontTemplate(self, font, fontSize, fontStyle, fontJustifyH, fontJustifyV, noUpdate)
    local STANDARDFONTSIZE = SuperVillain.db.media.fonts.size
    font = font or STANDARD_TEXT_FONT
    fontSize = fontSize or STANDARDFONTSIZE;
    fontJustifyH = fontJustifyH or "CENTER";
    fontJustifyV = fontJustifyV or "MIDDLE";
    self.font = font;
    self.fontSize = fontSize;
    self.fontStyle = fontStyle;
    self.fontJustifyH = fontJustifyH;
    self.fontJustifyV = fontJustifyV;
    self:SetFont(font, fontSize, fontStyle)
    if(fontStyle and fontStyle  ~= "NONE") then 
        self:SetShadowColor(0, 0, 0, 0)
    else 
        self:SetShadowColor(0, 0, 0, 0.2)
    end;
    self:SetShadowOffset(1, -1)
    self:SetJustifyH(fontJustifyH)
    self:SetJustifyV(fontJustifyV)
    self.useCommon = fontSize and (fontSize == STANDARDFONTSIZE);
    if(not noUpdate) then
        FontUpdateFrames[self] = true
    end
end;
--[[ 
########################################################## 
FONT UPDATE CALLBACK
##########################################################
]]--
local function FontTemplateUpdates()
    local STANDARDFONTSIZE = SuperVillain.db.media.fonts.size;
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

function SuperVillain:UpdateFontTemplates()
    FontTemplateUpdates()
end

SuperVillain.Registry:SetCallback(FontTemplateUpdates)
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
    ["FramedButton"] = {
        backdrop = {
            bgFile = [[Interface\BUTTONS\WHITE8X8]], 
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
        gradient = "inverse", 
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
    ["UnitLarge"] = {
        backdrop = false, 
        color = "special",
        gradient = false, 
        texture = [[Interface\AddOns\SVUI\assets\artwork\Unitframe\Background\UNIT-BG1]], 
        texupdate = true,
        padding = 0, 
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
            self[5]:SetBackdropBorderColor(r,g,b,0.5)
        end;
    end;
end;

local HookBackdrop = function(self,...) 
    self.Panel:SetBackdrop(...) 
end;

local HookBackdropColor = function(self,...) 
    self.Panel:SetBackdropColor(...) 
end;

local HookBackdropBorderColor = function(self,...)
    self.Panel:SetBackdropBorderColor(...)
end;

local HookVertexColor = function(self,...) 
    self._skin:SetVertexColor(...) 
end;

local HookCustomBackdrop = function(self)
    local newBgFile = SuperVillain.Media.bg[self._bdtex]
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
end;
--[[ 
########################################################## 
TEMPLATE HELPERS
##########################################################
]]--
local function CreatePanelTemplate(frame, templateName, underlay, noupdate, padding, xOffset, yOffset)
    if(not templateName or not _templates[templateName]) then templateName = 'Default' end;
    local settings = _templates[templateName]
    local colorName = settings.color
    local gradientName = settings.gradient
    local texFile = settings.texture
    local hasShadow = settings.shadow
    local bd = settings.backdrop
    local bypass = noupdate or settings.noupdate
    local bgColor = SuperVillain.Media.color[colorName] or {0.18,0.18,0.18,1}
    local borderColor = {0,0,0,1}
    local initLevel = 0;

    padding = padding or settings.padding or 1

    xOffset = xOffset or 1
    yOffset = yOffset or 1

    frame._template = templateName;
    frame._color = colorName;
    frame._gradient = gradientName;
    frame._texture = false;
    frame._noupdate = bypass; 

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
    end;

    if(hasShadow) then
        if(underlay) then
            panel[5] = NewFrame('Frame', nil, panel)
            panel[5]:Point('TOPLEFT', panel, 'TOPLEFT', -3, 3)
            panel[5]:Point('BOTTOMRIGHT', panel, 'BOTTOMRIGHT', 3, -3)
        else
            panel[5] = NewFrame('Frame', nil, frame)
            panel[5]:Point('TOPLEFT', frame, 'TOPLEFT', -3, 3)
            panel[5]:Point('BOTTOMRIGHT', frame, 'BOTTOMRIGHT', 3, -3)
        end
        panel[5]:SetBackdrop({
            edgeFile = [[Interface\AddOns\SVUI\assets\artwork\Template\GLOW]],
            edgeSize = 3,
            insets = {
                left = 0,
                right = 0,
                top = 0,
                bottom = 0
            }
        });
        panel[5]:SetBackdropBorderColor(0,0,0,0.5)
        local level = panel[5]:GetFrameLevel() - 1
        if(level >= 0) then 
            panel[5]:SetFrameLevel(level)
        else 
            panel[5]:SetFrameLevel(0)
        end
    end

    frame.Panel = panel

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
        if(templateName ~= 'Transparent') then
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
        local xyOffset = padding + 1;
        if(underlay) then
            frame._skin = frame.Panel:CreateTexture(nil,"BACKGROUND",nil,initLevel)
            frame._skin:Point('TOPLEFT', frame.Panel, 'TOPLEFT', xyOffset, (xyOffset * -1))
            frame._skin:Point('BOTTOMRIGHT', frame.Panel, 'BOTTOMRIGHT', (xyOffset * -1), xyOffset)
        else
            frame._skin = frame:CreateTexture(nil,"BACKGROUND",nil,initLevel)
            frame._skin:Point('TOPLEFT', frame, 'TOPLEFT', xyOffset, (xyOffset * -1))
            frame._skin:Point('BOTTOMRIGHT', frame, 'BOTTOMRIGHT', (xyOffset * -1), xyOffset)
        end
        
        frame._skin:SetTexture(texFile)
        if(gradientName and SuperVillain.Media.gradient[gradientName]) then
            frame._skin:SetGradient(unpack(SuperVillain.Media.gradient[gradientName]))
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
        local topLeft = frame.Panel:CreateTexture(nil, "BACKGROUND", nil, initLevel)
        topLeft:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Template\Extended\]] .. name .. [[_TOPLEFT]])
        topLeft:SetPoint("TOPLEFT", frame.Panel, "TOPLEFT", 0, 0)
        topLeft:SetPoint("TOPRIGHT", frame.Panel, "TOP", 0, 0)
        topLeft:SetPoint("BOTTOMLEFT", frame.Panel, "LEFT", 0, 0)
        topLeft:SetVertexColor(0.05, 0.05, 0.05, 0.5)
        topLeft:SetNonBlocking(true)

        local topRight = frame.Panel:CreateTexture(nil, "BACKGROUND", nil, initLevel)
        topRight:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Template\Extended\]] .. name .. [[_TOPRIGHT]])
        topRight:SetPoint("TOPRIGHT", frame.Panel, "TOPRIGHT", 0, 0)
        topRight:SetPoint("TOPLEFT", frame.Panel, "TOP", 0, 0)
        topRight:SetPoint("BOTTOMRIGHT", frame.Panel, "RIGHT", 0, 0)
        topRight:SetVertexColor(0.05, 0.05, 0.05, 0.5)
        topRight:SetNonBlocking(true)

        local bottomRight = frame.Panel:CreateTexture(nil, "BACKGROUND", nil, initLevel)
        bottomRight:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Template\Extended\]] .. name .. [[_BOTTOMRIGHT]])
        bottomRight:SetPoint("BOTTOMRIGHT", frame.Panel, "BOTTOMRIGHT", 0, 0)
        bottomRight:SetPoint("BOTTOMLEFT", frame.Panel, "BOTTOM", 0, 0)
        bottomRight:SetPoint("TOPRIGHT", frame.Panel, "RIGHT", 0, 0)
        bottomRight:SetVertexColor(0.1, 0.1, 0.1, 0.5)
        bottomRight:SetNonBlocking(true)

        local bottomLeft = frame.Panel:CreateTexture(nil, "BACKGROUND", nil, initLevel)
        bottomLeft:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Template\Extended\]] .. name .. [[_BOTTOMLEFT]])
        bottomLeft:SetPoint("BOTTOMLEFT", frame.Panel, "BOTTOMLEFT", 0, 0)
        bottomLeft:SetPoint("BOTTOMRIGHT", frame.Panel, "BOTTOM", 0, 0)
        bottomLeft:SetPoint("TOPLEFT", frame.Panel, "LEFT", 0, 0)
        bottomLeft:SetVertexColor(0.1, 0.1, 0.1, 0.5)
        bottomLeft:SetNonBlocking(true)
    end;

    local level = frame:GetFrameLevel() - 1
    if(level >= 0) then 
        frame.Panel:SetFrameLevel(level)
    else 
        frame.Panel:SetFrameLevel(0)
    end
end;

local function HasCooldown(n)
    local cd = n and n.."Cooldown"
    return cd and _G[cd]
end

local function CreateButtonPanel(frame, noChecked, brightChecked)
    if(frame.hasPanel) then return end
    
    if(frame.Left) then 
        frame.Left:SetAlpha(0)
    end;

    if(frame.Middle) then 
        frame.Middle:SetAlpha(0)
    end;

    if(frame.Right) then 
        frame.Right:SetAlpha(0)
    end;

    if(frame.SetNormalTexture) then 
        frame:SetNormalTexture("")
    end;

    if(frame.SetDisabledTexture) then 
        frame:SetDisabledTexture("")
    end;

    if(frame.SetHighlightTexture and not frame.hover) then
        local hover = frame:CreateTexture(nil, "OVERLAY")
        local color = SuperVillain.Media.color.highlight
        hover:SetTexture(color[1], color[2], color[3], 0.5)
        hover:FillInner(frame.Panel)
        frame.hover = hover;
        frame:SetHighlightTexture(hover) 
    end;

    if(frame.SetPushedTexture and not frame.pushed) then 
        local pushed = frame:CreateTexture(nil, "OVERLAY")
        pushed:SetTexture(0.1, 0.8, 0.1, 0.3)
        pushed:FillInner(frame.Panel)
        frame.pushed = pushed;
        frame:SetPushedTexture(pushed)
    end;

    if(not noChecked and frame.SetCheckedTexture) then 
        local checked = frame:CreateTexture(nil, "OVERLAY")
        if(not brightChecked) then
            checked:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
            checked:SetVertexColor(0, 0.5, 0, 0.2)
        else
            checked:SetTexture(SuperVillain.Media.bar.gloss)
            checked:SetVertexColor(0, 1, 0, 1)
        end
        checked:FillInner(frame.Panel)
        frame.checked = checked;
        frame:SetCheckedTexture(checked)
    end;

    local cd = HasCooldown(frame:GetName())
    if cd then 
        cd:ClearAllPoints()
        cd:SetAllPoints()
    end;

    frame.hasPanel = true
end;
--[[ 
########################################################## 
TEMPLATE API
##########################################################
]]--
local function SetPanelTemplate(self, templateName, noupdate, overridePadding, xOffset, yOffset)
    if(self.Panel) then return; end
    if(not templateName or not _templates[templateName]) then templateName = 'Default' end;

    local padding = false
    if(overridePadding and type(overridePadding) == "number") then
        padding = overridePadding
    end

    CreatePanelTemplate(self, templateName, true, noupdate, padding, xOffset, yOffset)

    if(not self._noupdate) then
        TemplateUpdateFrames[self] = true
    end
end;

local function SetFixedPanelTemplate(self, templateName, noupdate, overridePadding, xOffset, yOffset)
    if(self.Panel) then return; end
    if(not templateName or not _templates[templateName]) then templateName = 'Default' end;

    local padding = false
    if(overridePadding and type(overridePadding) == "number") then
        padding = overridePadding
    end

    CreatePanelTemplate(self, templateName, false, noupdate, padding, xOffset, yOffset)

    if(not self._noupdate) then
        TemplateUpdateFrames[self] = true
    end
end;

local function SetPanelColor(self, ...)
    local arg1,arg2,arg3,arg4,arg5,arg6,arg7 = select(1, ...)
    if(not self.Panel or not arg1) then return; end 
    if(self._skin and self._gradient) then
        if(type(arg1) == "string") then
            if(arg1 == "VERTICAL" or arg1 == "HORIZONTAL") then
                self._skin:SetGradient(...)
            elseif(SuperVillain.Media.gradient[arg1]) then
                if self.BorderPanel then
                    local d,r,g,b,r2,g2,b2 = unpack(SuperVillain.Media.gradient[arg1])
                    --self._skin:SetGradient(d,r,g,b,r2,g2,b2)
                    self.BorderPanel[1]:SetTexture(r2,g2,b2)
                    self.BorderPanel[2]:SetTexture(r2,g2,b2)
                    self.BorderPanel[3]:SetTexture(r2,g2,b2)
                    self.BorderPanel[4]:SetTexture(r2,g2,b2)
                else
                    self._skin:SetGradient(unpack(SuperVillain.Media.gradient[arg1]))
                    if(SuperVillain.Media.color[arg1]) then
                        local t = SuperVillain.Media.color[arg1]
                        local r,g,b,a = t[1], t[2], t[3], t[4] or 1;
                        self:SetBackdropColor(r,g,b,a)
                    end
                end
            end;
        end;
    elseif(type(arg1) == "string" and SuperVillain.Media.color[arg1]) then
        local t = SuperVillain.Media.color[arg1]
        local r,g,b,a = t[1], t[2], t[3], t[4] or 1;
        if self.BorderPanel then
            self.BorderPanel[1]:SetTexture(r,g,b)
            self.BorderPanel[2]:SetTexture(r,g,b)
            self.BorderPanel[3]:SetTexture(r,g,b)
            self.BorderPanel[4]:SetTexture(r,g,b)
        else
            self:SetBackdropColor(r,g,b)
        end
    elseif(arg1 and type(arg1) == "number") then
        self:SetBackdropColor(...)
    end;
end;
--[[ 
########################################################## 
APPENDED BUTTON TEMPLATING METHODS
##########################################################
]]--
local function SetButtonTemplate(self)
    if self.styled then return end;
    
    CreatePanelTemplate(self, "Button", false, true, 1)

    if(self.Left) then 
        self.Left:SetAlpha(0)
    end;

    if(self.Middle) then 
        self.Middle:SetAlpha(0)
    end;

    if(self.Right) then 
        self.Right:SetAlpha(0)
    end;

    if(self.SetNormalTexture) then 
        self:SetNormalTexture("")
    end;

    if(self.SetDisabledTexture) then 
        self:SetDisabledTexture("")
    end;

    if(self.SetHighlightTexture and not self.hover) then
        local hover = self:CreateTexture(nil, "HIGHLIGHT")
        local color = SuperVillain.Media.color.highlight
        hover:SetTexture(color[1], color[2], color[3], 0.5)
        FillInner(hover, self.Panel)
        self.hover = hover;
        self:SetHighlightTexture(hover) 
    end;

    if(self.SetPushedTexture and not self.pushed) then 
        local pushed = self:CreateTexture(nil, "OVERLAY")
        pushed:SetTexture(0.1, 0.8, 0.1, 0.3)
        FillInner(pushed, self.Panel)
        self.pushed = pushed;
        self:SetPushedTexture(pushed)
    end;

    if(self.SetCheckedTexture and not self.checked) then 
        local checked = self:CreateTexture(nil, "OVERLAY")
        checked:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
        checked:SetVertexColor(0, 0.5, 0, 0.2)
        FillInner(checked, self.Panel)
        self.checked = checked;
        self:SetCheckedTexture(checked)
    end;

    self.styled = true
end;

local function SetSlotTemplate(self, underlay, padding, x, y, noChecked)
    if self.styled then return end;
    padding = padding or 1
    CreatePanelTemplate(self, "Slot", underlay, true, padding, x, y)
    CreateButtonPanel(self, noChecked)
    self.styled = true
end;

local function SetCheckboxTemplate(self, underlay, x, y)
    if self.styled then return end;
    if(underlay) then
        x = -7
        y = -7
    end
    CreatePanelTemplate(self, "Slot", underlay, true, 1, x, y)
    CreateButtonPanel(self, false, true)

    NewHook(self, "SetChecked",function(self,checked)
        local r,g,b = 0,0,0
        if(checked == 1) then
            r,g,b = self:GetCheckedTexture():GetVertexColor()
        end
        self:SetBackdropBorderColor(r,g,b) 
    end)
    
    self.styled = true
end;

local function SetEditboxTemplate(self, x, y)
    if self.styled then return end;
    
    if self.TopLeftTex then MUNG(self.TopLeftTex) end;
    if self.TopRightTex then MUNG(self.TopRightTex) end;
    if self.TopTex then MUNG(self.TopTex) end;
    if self.BottomLeftTex then MUNG(self.BottomLeftTex) end;
    if self.BottomRightTex then MUNG(self.BottomRightTex) end;
    if self.BottomTex then MUNG(self.BottomTex) end;
    if self.LeftTex then MUNG(self.LeftTex) end;
    if self.RightTex then MUNG(self.RightTex) end;
    if self.MiddleTex then MUNG(self.MiddleTex) end;

    CreatePanelTemplate(self, "Inset", true, true, 1, x, y)

    local globalName = self:GetName();
    if globalName then 
        if _G[globalName.."Left"] then MUNG(_G[globalName.."Left"]) end;
        if _G[globalName.."Middle"] then MUNG(_G[globalName.."Middle"]) end;
        if _G[globalName.."Right"] then MUNG(_G[globalName.."Right"]) end;
        if _G[globalName.."Mid"] then MUNG(_G[globalName.."Mid"]) end;
        if globalName:find("Silver") or globalName:find("Copper") then 
            self.Panel:SetPoint("BOTTOMRIGHT", -12, -2) 
        end 
    end
    self.styled = true
end;

local function SetFramedButtonTemplate(self)
    if self.styled then return end;

    CreatePanelTemplate(self, "FramedButton", false, false, 1)

    if(self.Left) then 
        self.Left:SetAlpha(0)
    end;

    if(self.Middle) then 
        self.Middle:SetAlpha(0)
    end;

    if(self.Right) then 
        self.Right:SetAlpha(0)
    end;

    if(self.SetNormalTexture) then 
        self:SetNormalTexture("")
    end;

    if(self.SetDisabledTexture) then 
        self:SetDisabledTexture("")
    end;

    local border = NewFrame('Frame',nil,self)
    border:Point('TOPLEFT', self, 'TOPLEFT', -2, 2)
    border:Point('BOTTOMRIGHT', self, 'BOTTOMRIGHT', 2, -2)
    local t = SuperVillain.Media.color.default
    local r,g,b = t[1], t[2], t[3]
    border[1] = border:CreateTexture(nil,"BORDER")
    border[1]:SetTexture(r,g,b)
    border[1]:SetPoint("TOPLEFT")
    border[1]:SetPoint("BOTTOMLEFT")
    border[1]:SetWidth(3)
    border[2] = border:CreateTexture(nil,"BORDER")
    border[2]:SetTexture(r,g,b)
    border[2]:SetPoint("TOPRIGHT")
    border[2]:SetPoint("BOTTOMRIGHT")
    border[2]:SetWidth(3)
    border[3] = border:CreateTexture(nil,"BORDER")
    border[3]:SetTexture(r,g,b)
    border[3]:SetPoint("TOPLEFT")
    border[3]:SetPoint("TOPRIGHT")
    border[3]:SetHeight(3)
    border[4] = border:CreateTexture(nil,"BORDER")
    border[4]:SetTexture(r,g,b)
    border[4]:SetPoint("BOTTOMLEFT")
    border[4]:SetPoint("BOTTOMRIGHT")
    border[4]:SetHeight(3)

    border[5] = NewFrame('Frame',nil,border)
    border[5]:Point('TOPLEFT',border,'TOPLEFT',-2,2)
    border[5]:Point('BOTTOMRIGHT',border,'BOTTOMRIGHT',2,-2)
    border[5]:SetBackdrop({
        edgeFile = [[Interface\AddOns\SVUI\assets\artwork\Template\GLOW]], 
        edgeSize = 3, 
        insets = {
            left = 2, 
            right = 2, 
            top = 2, 
            bottom = 2
        }
    })
    border[5]:SetBackdropBorderColor(0,0,0,0.6)

    if(not self.hover) then
        local hover = border:CreateTexture(nil, "HIGHLIGHT")
        local color = SuperVillain.Media.color.highlight
        hover:SetTexture(color[1], color[2], color[3], 0.5)
        hover:SetAllPoints(border)
        self.hover = hover;
        if(self.SetHighlightTexture) then
            self:SetHighlightTexture(hover)
        end
    end;

    self.BorderPanel = border
    self.styled = true
    TemplateUpdateFrames[self] = true
end;
--[[ 
########################################################## 
TEMPLATE UPDATE CALLBACK
##########################################################
]]--
local function FrameTemplateUpdates()
    for frame in pairs(TemplateUpdateFrames) do
        if(frame) then
            local p = SuperVillain.Media.color[frame._color];
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
                local tex = SuperVillain.Media.bg[frame._texture]
                if(tex) then
                    frame._skin:SetTexture(tex)
                end;
                if(not frame.NoColorUpdate) then
                    if(frame._gradient and SuperVillain.Media.gradient[frame._gradient]) then
                        local g = SuperVillain.Media.gradient[frame._gradient]
                        frame._skin:SetGradient(g[1], g[2], g[3], g[4], g[5], g[6], g[7])
                    elseif(p) then
                        frame._skin:SetVertexColor(p[1], p[2], p[3], p[4] or 1)
                    end
                end
            end
        end
    end
end
SuperVillain.Registry:SetCallback(FrameTemplateUpdates)
--[[ 
########################################################## 
ENUMERATION
##########################################################
]]--
local function AppendMethods(OBJECT)
    local META = getmetatable(OBJECT).__index
    if not OBJECT.Size then META.Size = Size end
    if not OBJECT.Width then META.Width = Width end
    if not OBJECT.Height then META.Height = Height end
    if not OBJECT.Point then META.Point = Point end
    if not OBJECT.WrapOuter then META.WrapOuter = WrapOuter end
    if not OBJECT.FillInner then META.FillInner = FillInner end
    if not OBJECT.MUNG then META.MUNG = MUNG end
    if not OBJECT.Formula409 then META.Formula409 = Formula409 end
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
    if not HANDLER[OBJECT:GetObjectType()] then
		AppendMethods(OBJECT)
		HANDLER[OBJECT:GetObjectType()] = true
	end
	OBJECT = EnumerateFrames(OBJECT)
end