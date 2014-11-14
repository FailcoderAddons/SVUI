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
local SV = select(2, ...)
local L = SV.L
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local TemplateUpdateFrames = {}; 
--[[ 
########################################################## 
XML TEMPLATE LOOKUP TABLE
##########################################################
]]--
local XML_LOOKUP = {
    ["Default"] = "SVUI_PanelTemplate_Default",
    ["Transparent"] = "SVUI_PanelTemplate_Transparent",
    ["Component"] = "SVUI_PanelTemplate_Component",
    ["Headline"] = "SVUI_PanelTemplate_Headline",
    ["Button"] = "SVUI_PanelTemplate_Button",
    ["FramedTop"] = "SVUI_PanelTemplate_FramedTop",
    ["FramedBottom"] = "SVUI_PanelTemplate_FramedBottom",
    ["Bar"] = "SVUI_PanelTemplate_Bar",
    ["Slot"] = "SVUI_PanelTemplate_Slot",
    ["Inset"] = "SVUI_PanelTemplate_Inset",
    ["Comic"] = "SVUI_PanelTemplate_Comic",
    ["Model"] = "SVUI_PanelTemplate_Model",
    ["Paper"] = "SVUI_PanelTemplate_Paper",
    ["Container"] = "SVUI_PanelTemplate_Container",
    ["Pattern"] = "SVUI_PanelTemplate_Pattern",
    ["Halftone"] = "SVUI_PanelTemplate_Halftone",
    ["Action"] = "SVUI_PanelTemplate_Action",
    ["Blackout"] = "SVUI_PanelTemplate_Blackout",
    ["UnitLarge"] = "SVUI_PanelTemplate_UnitLarge", 
    ["UnitSmall"] = "SVUI_PanelTemplate_UnitSmall" 
};
--[[ 
########################################################## 
INTERNAL HANDLERS
##########################################################
]]--
local HookPanelBorderColor = function(self,r,g,b,a)
    if self.BorderLeft then 
        self.BorderLeft:SetVertexColor(r,g,b,a)
        self.BorderRight:SetVertexColor(r,g,b,a)
        self.BorderTop:SetVertexColor(r,g,b,a)
        self.BorderBottom:SetVertexColor(r,g,b,a) 
    end
    if self.Shadow then
        local alpha = self.Shadow:GetAttribute("shadowAlpha") or 0.5
        self.Shadow:SetBackdropBorderColor(r,g,b,alpha)
    end 
end 

local HookBackdrop = function(self,...)
    if(self.Panel) then
        self.Panel:SetBackdrop(...)
    end
end 

local HookBackdropColor = function(self,...) 
    if(self.Panel) then
        self.Panel:SetBackdropColor(...)
    end
end 

local HookBackdropBorderColor = function(self,...)
    if(self.Panel) then
        self.Panel:SetBackdropBorderColor(...)
    end
end 

local HookVertexColor = function(self,...) 
    if(self.Panel) then
        self.Panel.Skin:SetVertexColor(...)
    end
end 

local HookCustomBackdrop = function(self)
    if(self.Panel) then
        local bgid = self.Panel:GetAttribute("panelID")
        local newBgFile = SV.Media.bg[bgid]
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
end

local HookFrameLevel = function(self, level)
    if(self.Panel) then
        local adjustment = level - 1;
        if(adjustment < 0) then adjustment = 0 end
        self.Panel:SetFrameLevel(adjustment)
    end
end

local Cooldown_ForceUpdate = function(self)
    self.nextUpdate = 0;
    self:Show()
end 

local Cooldown_StopTimer = function(self)
    self.enable = nil;
    self:Hide()
end 

local Cooldown_OnUpdate = function(self, elapsed)
    if self.nextUpdate > 0 then 
        self.nextUpdate = self.nextUpdate - elapsed;
        return 
    end 
    local expires = (self.duration - (GetTime() - self.start));
    if expires > 0.05 then 
        if (self.fontScale * self:GetEffectiveScale() / UIParent:GetScale()) < 0.5 then 
            self.text:SetText('')
            self.nextUpdate = 500 
        else 
            local timeLeft = 0;
            local calc = 0;
            if expires < 4 then
                self.nextUpdate = 0.051
                self.text:SetFormattedText("|cffff0000%.1f|r", expires)
            elseif expires < 60 then 
                self.nextUpdate = 0.51
                self.text:SetFormattedText("|cffffff00%d|r", floor(expires)) 
            elseif expires < 3600 then
                timeLeft = ceil(expires / 60);
                calc = floor((expires / 60) + .5);
                self.nextUpdate = calc > 1 and ((expires - calc) * 29.5) or (expires - 59.5);
                self.text:SetFormattedText("|cffffffff%dm|r", timeLeft)
            elseif expires < 86400 then
                timeLeft = ceil(expires / 3600);
                calc = floor((expires / 3600) + .5);
                self.nextUpdate = calc > 1 and ((expires - calc) * 1799.5) or (expires - 3570);
                self.text:SetFormattedText("|cff66ffff%dh|r", timeLeft)
            else
                timeLeft = ceil(expires / 86400);
                calc = floor((expires / 86400) + .5);
                self.nextUpdate = calc > 1 and ((expires - calc) * 43199.5) or (expires - 86400);
                self.text:SetFormattedText("|cff6666ff%dd|r", timeLeft)
            end
        end
    else 
        Cooldown_StopTimer(self)
    end 
end

local Cooldown_OnSizeChanged = function(self, width, height)
    local frame = self.timer
    local override = self.SizeOverride
    local newSize = floor(width + .5) / 36;
    override = override or frame:GetParent():GetParent().SizeOverride;
    if override then
        newSize = override / 20 
    end 
    if newSize == frame.fontScale then 
        return 
    end 
    frame.fontScale = newSize;
    if newSize < 0.5 and not override then 
        frame:Hide()
    else 
        frame:Show()
        frame.text:SetFont([[Interface\AddOns\SVUI\assets\fonts\Numbers.ttf]], newSize * 15, 'OUTLINE')
        if frame.enable then 
            Cooldown_ForceUpdate(frame)
        end 
    end
end

local function CreateCooldownTimer(frame)
    local timer = CreateFrame('Frame', nil, frame)
    timer:SetAllPoints()
    timer:SetScript('OnUpdate', Cooldown_OnUpdate)

    local timeText = timer:CreateFontString(nil,'OVERLAY')
    timeText:SetPoint('CENTER',1,1)
    timeText:SetJustifyH("CENTER")
    timer.text = timeText;

    timer:Hide()

    frame.timer = timer;

    local width, height = frame:GetSize()
    Cooldown_OnSizeChanged(frame, width, height)
    frame:SetScript('OnSizeChanged', Cooldown_OnSizeChanged)
    
    return frame.timer 
end 

local _hook_Cooldown_SetCooldown = function(self, start, duration, elapsed)
    if start > 0 and duration > 2.5 then 
        local timer = self.timer or CreateCooldownTimer(self)
        timer.start = start;
        timer.duration = duration;
        timer.enable = true;
        timer.nextUpdate = 0;
        
        if timer.fontScale >= 0.5 then 
            timer:Show()
        end 
    else 
        local timer = self.timer;
        if timer then 
            Cooldown_StopTimer(timer)
        end 
    end 
    if self.timer then 
        if elapsed and elapsed > 0 then 
            self.timer:SetAlpha(0)
        else
            self.timer:SetAlpha(0.8)
        end 
    end 
end
--[[ 
########################################################## 
COOLDOWN HELPER
##########################################################
]]--
local function CreateCooldown(button)
    local cooldown = button:GetName() and _G[button:GetName().."Cooldown"]
    if(cooldown) then
        if(not SV.db.general or (SV.db.general and (not SV.db.general.cooldown))) then return end
        cooldown:ClearAllPoints()
        cooldown:FillInner()
        cooldown:SetSwipeColor(0, 0, 0, 1)
        cooldown:SetHideCountdownNumbers(true)

        if(not cooldown.HookedCooldown) then
            hooksecurefunc(cooldown, "SetCooldown", _hook_Cooldown_SetCooldown)
            cooldown.HookedCooldown = true
        end
    end
end
--[[ 
########################################################## 
TEMPLATE HELPERS
##########################################################
]]--
local function CreatePanelTemplate(frame, templateName, underlay, noupdate, padding, xOffset, yOffset, defaultColor)
    local xmlTemplate = XML_LOOKUP[templateName] or "SVUI_PanelTemplate_Default"
    local borderColor = {0,0,0,1}

    frame.Panel = CreateFrame('Frame', nil, frame, xmlTemplate)

    local level = frame:GetFrameLevel()
    if(level == 0 and not InCombatLockdown()) then
        frame:SetFrameLevel(1)
        level = 1
    end

    local adjustment = level - 1;

    if(adjustment < 0) then adjustment = 0 end

    frame.Panel:SetFrameLevel(adjustment)

    hooksecurefunc(frame, "SetFrameLevel", HookFrameLevel)

    if(defaultColor) then
        frame.Panel:SetAttribute("panelColor", defaultColor)
    end
    if(noupdate) then
        frame.Panel:SetAttribute("panelSkipUpdate", noupdate)
    end

    local colorName     = frame.Panel:GetAttribute("panelColor")
    local gradientName  = frame.Panel:GetAttribute("panelGradient")
    local forcedOffset  = frame.Panel:GetAttribute("panelOffset")

    xOffset = forcedOffset or xOffset or 1
    yOffset = forcedOffset or yOffset or 1

    frame.Panel:WrapOuter(frame, xOffset, yOffset)

    padding = padding or frame.Panel:GetAttribute("panelPadding")
    
    if(padding and frame.Panel.BorderLeft) then 
        frame.Panel.BorderLeft:SetWidth(padding)
        frame.Panel.BorderRight:SetWidth(padding)
        frame.Panel.BorderTop:SetHeight(padding)
        frame.Panel.BorderBottom:SetHeight(padding)
    end

    if(frame.Panel.Shadow) then
        frame.Panel.Shadow:SetPoint('TOPLEFT', frame.Panel, 'TOPLEFT', -3, 3)
        frame.Panel.Shadow:SetPoint('BOTTOMRIGHT', frame.Panel, 'BOTTOMRIGHT', 3, -3)

        local alpha = frame.Panel.Shadow:GetAttribute("shadowAlpha") or 0.5
        frame.Panel.Shadow:SetBackdropBorderColor(0,0,0,alpha)

        local level = frame.Panel.Shadow:GetFrameLevel() - 1
        if(level >= 0) then 
            frame.Panel.Shadow:SetFrameLevel(level)
        else 
            frame.Panel.Shadow:SetFrameLevel(0)
        end
    end

    local bgColor = SV.Media.color[colorName] or {0.18,0.18,0.18,1}

    if(not frame.Panel:GetAttribute("panelNoBackdrop")) then
        if(underlay) then
            frame.Panel:SetBackdropColor(bgColor[1],bgColor[2],bgColor[3],bgColor[4] or 1)
            frame.Panel:SetBackdropBorderColor(0,0,0,1)
        else
            local bd = frame.Panel:GetBackdrop()
            frame:SetBackdrop(bd)
            frame:SetBackdropColor(bgColor[1],bgColor[2],bgColor[3],bgColor[4] or 1)
            frame:SetBackdropBorderColor(0,0,0,1)

            frame.Panel:SetBackdrop(nil)
        end

        if(templateName ~= 'Transparent') then
            hooksecurefunc(frame.Panel, "SetBackdropBorderColor", HookPanelBorderColor)
            hooksecurefunc(frame, "SetBackdropBorderColor", HookBackdropBorderColor)
            if(underlay) then
                hooksecurefunc(frame, "SetBackdrop", HookBackdrop)
                hooksecurefunc(frame, "SetBackdropColor", HookBackdropColor)
            end
            frame.BackdropNeedsUpdate = true
            if(templateName == 'Pattern' or templateName == 'Comic') then
                frame.UpdateBackdrop = HookCustomBackdrop
            end
        end
    end

    if(frame.Panel.Skin) then
        if(not underlay) then
            frame.Panel.Skin:SetParent(frame)
            frame.Panel.Skin:FillInner(frame, xOffset, yOffset)
        else
            frame.Panel.Skin:FillInner(frame.Panel, xOffset, yOffset)
        end
        if(gradientName and SV.Media.gradient[gradientName]) then
            frame.Panel.Skin:SetGradient(unpack(SV.Media.gradient[gradientName]))
        else 
            frame.Panel.Skin:SetVertexColor(bgColor[1], bgColor[2], bgColor[3], bgColor[4] or 1)
        end

        if((not frame.Panel:GetAttribute("panelSkipUpdate")) and frame.Panel:GetAttribute("panelTexUpdate")) then
            frame.TextureNeedsUpdate = true
            if(templateName == 'UnitLarge' or templateName == 'UnitSmall') then
                frame.UpdateColor = HookVertexColor
                frame.NoColorUpdate = true
            end
        end
    end
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

    CreateCooldown(frame)
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

        hooksecurefunc(self, "SetFrameLevel", HookFrameLevel)
        hooksecurefunc(self, "SetBackdrop", HookBackdrop)
        hooksecurefunc(self, "SetBackdropColor", HookBackdropColor)
        hooksecurefunc(self, "SetBackdropBorderColor", HookBackdropBorderColor)
    end
end

local function SetPanelTemplate(self, templateName, noupdate, overridePadding, xOffset, yOffset, defaultColor)
    if(not self or (self and self.Panel)) then return end
    local padding = false
    if(overridePadding and type(overridePadding) == "number") then
        padding = overridePadding
    end

    CreatePanelTemplate(self, templateName, true, noupdate, padding, xOffset, yOffset, defaultColor)

    if(not self.Panel:GetAttribute("panelSkipUpdate") and not self.__registered) then
        TemplateUpdateFrames[self] = true
        self.__registered = true
    end
end 

local function SetFixedPanelTemplate(self, templateName, noupdate, overridePadding, xOffset, yOffset, defaultColor)
    if(not self or (self and self.Panel)) then return end
    local padding = false
    if(overridePadding and type(overridePadding) == "number") then
        padding = overridePadding
    end

    CreatePanelTemplate(self, templateName, false, noupdate, padding, xOffset, yOffset, defaultColor)

    if(not self.Panel:GetAttribute("panelSkipUpdate") and not self.__registered) then
        TemplateUpdateFrames[self] = true
        self.__registered = true
    end
end 

local function SetPanelColor(self, ...)
    local arg1,arg2,arg3,arg4,arg5,arg6,arg7 = select(1, ...)
    if(not self.Panel or not arg1) then return; end 
    if(self.Panel.Skin and self.Panel:GetAttribute("panelGradient")) then
        if(type(arg1) == "string") then
            if(arg1 == "VERTICAL" or arg1 == "HORIZONTAL") then
                self.Panel.Skin:SetGradient(...)
            elseif(SV.Media.gradient[arg1]) then
                if self.__border then
                    local d,r,g,b,r2,g2,b2 = unpack(SV.Media.gradient[arg1])
                    --self.Panel.Skin:SetGradient(d,r,g,b,r2,g2,b2)
                    self.__border[1]:SetTexture(r2,g2,b2)
                    self.__border[2]:SetTexture(r2,g2,b2)
                    self.__border[3]:SetTexture(r2,g2,b2)
                    self.__border[4]:SetTexture(r2,g2,b2)
                else
                    self.Panel.Skin:SetGradient(unpack(SV.Media.gradient[arg1]))
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
    if(not self or (self and self.Panel)) then return end

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
        if(self.Panel.BorderLeft) then 
            self.Panel.BorderLeft:SetVertexColor(0,0,0,0)
            self.Panel.BorderRight:SetVertexColor(0,0,0,0)
            self.Panel.BorderTop:SetVertexColor(0,0,0,0)
            self.Panel.BorderBottom:SetVertexColor(0,0,0,0)
        end
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
            hover:FillInner(self.Panel, 2, 2)
            self.hover = hover;
        end
        self.hover:SetTexture(0.1, 0.8, 0.8, 0.5)
        self:SetHighlightTexture(self.hover) 
    end 

    if(self.SetPushedTexture) then
        if(not self.pushed) then 
            local pushed = self:CreateTexture(nil, "OVERLAY")
            pushed:FillInner(self.Panel)
            self.pushed = pushed;
        end

        self.pushed:SetTexture(0.1, 0.8, 0.1, 0.3)

        self:SetPushedTexture(self.pushed)
    end 

    if(self.SetCheckedTexture) then
        if(not self.checked) then 
            local checked = self:CreateTexture(nil, "OVERLAY")
            checked:FillInner(self.Panel)
            self.checked = checked;
        end

        self.checked:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
        self.checked:SetVertexColor(0, 0.5, 0, 0.2)

        self:SetCheckedTexture(self.checked)
    end 

    CreateCooldown(self) 
end 

local function SetSlotTemplate(self, underlay, padding, x, y, shadowAlpha)
    if(not self or (self and self.Panel)) then return end
    padding = padding or 1
    CreatePanelTemplate(self, "Slot", underlay, true, padding, x, y)
    CreateButtonPanel(self, true)
    if(shadowAlpha) then
        self.Panel.Shadow:SetAttribute("shadowAlpha", shadowAlpha)
    end
end 

local function SetCheckboxTemplate(self, underlay, x, y)
    if(not self or (self and self.Panel)) then return end

    if(underlay) then
        x = x or -7
        y = y or -7
    end

    CreatePanelTemplate(self, "Slot", underlay, true, 1, x, y)
    CreateButtonPanel(self, false, true)

    hooksecurefunc(self, "SetChecked", function(self,checked)
        local r,g,b = 0,0,0
        if(checked == 1 or checked == true) then
            r,g,b = self:GetCheckedTexture():GetVertexColor()
        end
        self:SetBackdropBorderColor(r,g,b) 
    end)
end 

local function SetEditboxTemplate(self, x, y, fixed)
    if(not self or (self and self.Panel)) then return end

    if self.TopLeftTex then self.TopLeftTex:Die() end 
    if self.TopRightTex then self.TopRightTex:Die() end 
    if self.TopTex then self.TopTex:Die() end 
    if self.BottomLeftTex then self.BottomLeftTex:Die() end 
    if self.BottomRightTex then self.BottomRightTex:Die() end 
    if self.BottomTex then self.BottomTex:Die() end 
    if self.LeftTex then self.LeftTex:Die() end 
    if self.RightTex then self.RightTex:Die() end 
    if self.MiddleTex then self.MiddleTex:Die() end 
    local underlay = true
    if(fixed ~= nil) then underlay = fixed end
    CreatePanelTemplate(self, "Inset", underlay, true, 1, x, y)

    local globalName = self:GetName();
    if globalName then 
        if _G[globalName.."Left"] then _G[globalName.."Left"]:Die() end 
        if _G[globalName.."Middle"] then _G[globalName.."Middle"]:Die() end 
        if _G[globalName.."Right"] then _G[globalName.."Right"]:Die() end 
        if _G[globalName.."Mid"] then _G[globalName.."Mid"]:Die() end

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

    template = template or "FramedBottom"

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
            local panelID = frame.Panel:GetAttribute("panelID")
            local colorID = frame.Panel:GetAttribute("panelColor")
            local panelColor = SV.Media.color[colorID];
            if(frame.BackdropNeedsUpdate) then
                if(frame.UpdateBackdrop) then
                    frame:UpdateBackdrop()
                end
                if(panelColor) then
                    frame:SetBackdropColor(panelColor[1], panelColor[2], panelColor[3], panelColor[4] or 1)
                end
                frame:SetBackdropBorderColor(0,0,0,1)
            end
            if(frame.TextureNeedsUpdate and frame.Panel.Skin) then
                local tex = SV.Media.bg[panelID]
                if(tex) then
                    frame.Panel.Skin:SetTexture(tex)
                end 
                if(not frame.NoColorUpdate) then
                    local gradient = frame.Panel:GetAttribute("panelGradient")
                    if(gradient and SV.Media.gradient[gradient]) then
                        local g = SV.Media.gradient[gradient]
                        frame.Panel.Skin:SetGradient(g[1], g[2], g[3], g[4], g[5], g[6], g[7])
                    elseif(panelColor) then
                        frame.Panel.Skin:SetVertexColor(panelColor[1], panelColor[2], panelColor[3], panelColor[4] or 1)
                    end
                end
            end
        end
    end
end

LibSuperVillain("Registry"):NewCallback("CORE_MEDIA_UPDATED", "FrameTemplateUpdates", FrameTemplateUpdates)
--[[ 
########################################################## 
ENUMERATION
##########################################################
]]--
local function AppendMethods(OBJECT)
    local META = getmetatable(OBJECT).__index
    if not OBJECT.SetBasicPanel then META.SetBasicPanel = SetBasicPanel end
    if not OBJECT.SetPanelTemplate then META.SetPanelTemplate = SetPanelTemplate end
    if not OBJECT.SetFixedPanelTemplate then META.SetFixedPanelTemplate = SetFixedPanelTemplate end
    if not OBJECT.SetPanelColor then META.SetPanelColor = SetPanelColor end
    if not OBJECT.SetButtonTemplate then META.SetButtonTemplate = SetButtonTemplate end
    if not OBJECT.SetSlotTemplate then META.SetSlotTemplate = SetSlotTemplate end
    if not OBJECT.SetCheckboxTemplate then META.SetCheckboxTemplate = SetCheckboxTemplate end
    if not OBJECT.SetEditboxTemplate then META.SetEditboxTemplate = SetEditboxTemplate end
    if not OBJECT.SetFramedButtonTemplate then META.SetFramedButtonTemplate = SetFramedButtonTemplate end
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