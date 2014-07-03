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
local type      = _G.type;
local tonumber  = _G.tonumber;
local string    = _G.string;
local math      = _G.math;
--[[ STRING METHODS ]]--
local match = string.match;
--[[ MATH METHODS ]]--
local floor, abs, min, max = math.floor, math.abs, math.min, math.max;
local parsefloat = math.parsefloat;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L = unpack(select(2, ...));
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local scale;
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
function SuperVillain:UIScale(event)
    self.ghettoMonitor = nil;
    if IsMacClient() and self.db.screenheight and self.db.screenwidth then 
        if self.screenheight ~= self.db.screenheight or self.screenwidth ~= self.db.screenwidth then 
            self.screenheight = self.db.screenheight;
            self.screenwidth = self.db.screenwidth 
        end 
    end;
    
    if self.db.system.autoScale then
        scale = max(0.64, min(1.15, 768 / self.screenheight))
    else
        scale = max(0.64, min(1.15, GetCVar("uiScale") or UIParent:GetScale() or 768 / self.screenheight))
    end
    if self.screenwidth < 1600 then
            self.ghettoMonitor = true;
    elseif self.screenwidth >= 3840 then
        local width = self.screenwidth;
        local height = self.screenheight;
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
        self.evaluatedWidth = width;
    end

    self.mult = 768 / match(GetCVar("gxResolution"), "%d+x(%d+)") / scale;

    if(parsefloat(UIParent:GetScale(),5) ~= parsefloat(scale,5) and (event == 'PLAYER_LOGIN')) then 
        SetCVar("useUiScale",1)
        SetCVar("uiScale",scale)
        WorldMapFrame.hasTaint = true;
    end;

    if(event == 'PLAYER_LOGIN' or event == 'UI_SCALE_CHANGED') then
        if IsMacClient() then 
            self.db.screenheight = floor(GetScreenHeight() * 100 + .5) / 100
            self.db.screenwidth = floor(GetScreenWidth() * 100 + .5) / 100
        end;

        if self.evaluatedWidth then
            local width = self.evaluatedWidth;
            local height = self.screenheight;
            if not self.db.system.autoScale or height > 1200 then
                local h = UIParent:GetHeight();
                local ratio = self.screenheight / h;
                local w = self.evaluatedWidth / ratio;
                
                width = w;
                height = h; 
            end
            self.UIParent:SetSize(width, height);
        else
            self.UIParent:SetSize(UIParent:GetSize());
        end

        self.UIParent:ClearAllPoints()
        self.UIParent:SetPoint("CENTER")

        local change = abs((parsefloat(UIParent:GetScale(),5) * 100) - (parsefloat(scale,5) * 100))
        if(event == 'UI_SCALE_CHANGED' and change > 1 and self.db.system.autoScale) then
            SuperVillain:StaticPopup_Show('FAILED_UISCALE')
        elseif(event == 'UI_SCALE_CHANGED' and change > 1) then
            SuperVillain:StaticPopup_Show('RL_CLIENT')
        end;

        SVUISystemEventHandler:UnregisterEvent('PLAYER_LOGIN')
    end 
end;

function SuperVillain:Scale(value)
    return self.mult * floor(value / self.mult + .5);
end;