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
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = select(2, ...)

SV.Screen = _G["SVUIParent"];
local BASE_MOD = 0.64;
local SCREEN_MOD = 1;
--[[ 
########################################################## 
UI SCALING
##########################################################
]]--
function SV:UI_SCALE_CHANGED(event)
    local gxWidth, gxHeight, gxScale, customScale = self.Screen:Update();
    local needCalc = true;
    if(self.db.screen.advanced) then
        if(self.db.screen.forcedWidth ~= gxWidth) then
            gxWidth = self.db.screen.forcedWidth
            needCalc = false;
        end
        if(self.db.screen.forcedHeight ~= gxHeight) then
            gxHeight = self.db.screen.forcedHeight
            needCalc = false;
        end
    end
    if(needCalc) then
        if(gxWidth < 1600) then
            self.LowRez = true;
        elseif(gxWidth >= 3840) then
            self.LowRez = nil
            local evalwidth;
            if(self.db.screen.multiMonitor) then
                if(gxWidth < 4080) then 
                    evalwidth = 1224;
                elseif(gxWidth < 4320) then 
                    evalwidth = 1360;
                elseif(gxWidth < 4680) then 
                    evalwidth = 1400;
                elseif(gxWidth < 4800) then 
                    evalwidth = 1440;
                elseif(gxWidth < 5760) then 
                    if(gxHeight == 900) then evalwidth = 1600 else evalwidth = 1680 end 
                elseif(gxWidth < 7680) then 
                    evalwidth = 1920;
                elseif(gxWidth < 9840) then 
                    evalwidth = 2560;
                elseif(gxWidth > 9839) then 
                    evalwidth = 3280; 
                end
            else
                if(gxWidth < 4080) then 
                    evalwidth = 3840;
                elseif(gxWidth < 4320) then 
                    evalwidth = 4080;
                elseif(gxWidth < 4680) then 
                    evalwidth = 4320;
                elseif(gxWidth < 4800) then 
                    evalwidth = 4680;
                elseif(gxWidth < 5040) then 
                    evalwidth = 4800; 
                elseif(gxWidth < 5760) then 
                    evalwidth = 5040; 
                elseif(gxWidth < 7680) then 
                    evalwidth = 5760;
                elseif(gxWidth < 9840) then 
                    evalwidth = 7680;
                elseif(gxWidth > 9839) then 
                    evalwidth = 9840; 
                end
            end

            gxWidth = evalwidth;
        end
    end

    local testScale1 = parsefloat(UIParent:GetScale(), 5)
    local testScale2 = parsefloat(gxScale, 5)
    local ignoreChange = false;
    if(event == "PLAYER_LOGIN" and (testScale1 ~= testScale2)) then 
        SetCVar("useUiScale", 1)
        SetCVar("uiScale", gxScale)
        WorldMapFrame.hasTaint = true;
        ignoreChange = true;
    end

    if(event == 'PLAYER_LOGIN' or event == 'UI_SCALE_CHANGED') then
        self.Screen:ClearAllPoints()
        self.Screen:SetPoint("CENTER")

        if gxWidth then
            local width = gxWidth
            local height = gxHeight;
            if(not self.db.screen.autoScale or height > 1200) then
                height = UIParent:GetHeight();
                local ratio = gxHeight / height;
                width = gxWidth / ratio;
            end
            self.Screen:SetSize(width, height);
        else
            self.Screen:SetSize(UIParent:GetSize());
        end

        if((not customScale) and (not ignoreChange) and (event == 'UI_SCALE_CHANGED')) then
            local change = abs((testScale1 * 100) - (testScale2 * 100))
            if(change > 1) then
                if(self.db.screen.autoScale) then
                    self:StaticPopup_Show('FAILED_UISCALE')
                else
                    self:StaticPopup_Show('RL_CLIENT')
                end
            end
        end
    end
end

function SV:Scale(value)
    return SCREEN_MOD * floor(value / SCREEN_MOD + .5);
end

function SV.Screen:Update()
    local rez = GetCVar("gxResolution")
    local height = rez:match("%d+x(%d+)")
    local width = rez:match("(%d+)x%d+")
    local gxHeight = tonumber(height)
    local gxWidth = tonumber(width)
    local gxMod = (768 / gxHeight)
    local customScale = false;
    if(IsMacClient()) then
        if(not self.MacDisplay) then
            self.MacDisplay = LibSuperVillain("Registry"):NewGlobal("Display");
            if(not self.MacDisplay.Y or (self.MacDisplay.Y and type(self.MacDisplay.Y) ~= "number")) then 
                self.MacDisplay.Y = gxHeight;
            end
            if(not self.MacDisplay.X or (self.MacDisplay.X and type(self.MacDisplay.X) ~= "number")) then 
                self.MacDisplay.X = gxWidth;
            end
        end
        if(self.MacDisplay and self.MacDisplay.Y and self.MacDisplay.X) then
            if(gxHeight ~= self.MacDisplay.Y or gxWidth ~= self.MacDisplay.X) then 
                gxHeight = self.MacDisplay.Y;
                gxWidth = self.MacDisplay.X; 
            end
        end
    end

    local gxScale;
    if(SV.db.screen.advanced) then
        BASE_MOD = 0.64
        local ADJUSTED_SCALE = SV.db.screen.scaleAdjust;
        if(ADJUSTED_SCALE) then
            if(type(ADJUSTED_SCALE) ~= "number") then
                ADJUSTED_SCALE = tonumber(ADJUSTED_SCALE);
            end
            if(ADJUSTED_SCALE and ADJUSTED_SCALE ~= BASE_MOD) then 
                BASE_MOD = ADJUSTED_SCALE;
                customScale = true;
            end
        end

        gxScale = BASE_MOD;
    else
        if(SV.db.screen.autoScale) then
            gxScale = max(0.64, min(1.15, gxMod));
        else
            gxScale = max(0.64, min(1.15, GetCVar("uiScale") or UIParent:GetScale() or gxMod));
        end
    end

    SCREEN_MOD = (gxMod / gxScale);

    return gxWidth, gxHeight, gxScale, customScale
end