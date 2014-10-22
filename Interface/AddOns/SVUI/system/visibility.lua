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
local tinsert       = _G.tinsert;
local tremove       = _G.tremove;
local twipe         = _G.wipe;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = select(2, ...)
local L = SV.L;
--[[ 
########################################################## 
LOCALS
##########################################################
]]--
local SecureFadeManager = CreateFrame("Frame");
local DisplayFrames, SecureFadeFrames = {}, {};
--[[ 
########################################################## 
FRAME VISIBILITY MANAGEMENT
##########################################################
]]--
function SV:AddToDisplayAudit(frame)
    if frame.IsVisible and frame.GetParent then
        DisplayFrames[frame] = frame:GetParent()
    end 
end 

function SV:FlushDisplayAudit()
    if(InCombatLockdown()) then return end 
    for frame, _ in pairs(DisplayFrames)do 
        frame:SetParent(self.Cloaked) 
    end
    self.NeedsFrameAudit = true 
end 

function SV:PushDisplayAudit()
    if(InCombatLockdown()) then return end
    for frame, parent in pairs(DisplayFrames)do 
        frame:SetParent(parent or self.Screen) 
    end
    self.NeedsFrameAudit = false
end

local function SafeFrameRemoval(table, item)
    local index = 1;
    while table[index] do
        if ( item == table[index] ) then
            tremove(table, index);
        else
            index = index + 1;
        end
    end
end

local function SecureFadeRemoveFrame(frame)
    SafeFrameRemoval(SecureFadeFrames, frame);
end

local SecureFade_OnUpdate = function(self, elasped)
    local i = 1;
    local this, safeFadeState;

    while SecureFadeFrames[i] do
        this = SecureFadeFrames[i]

        safeFadeState = this._secureFade;
        safeFadeState.fadeTimer = (safeFadeState.fadeTimer or 0)  +  elasped;
        safeFadeState.fadeTimer = safeFadeState.fadeTimer  +  elasped;
        if safeFadeState.fadeTimer < safeFadeState.timeToFade then 

            if(safeFadeState.mode == "IN") then 
                this:SetAlpha((safeFadeState.fadeTimer  /  safeFadeState.timeToFade)  *  (safeFadeState.endAlpha - safeFadeState.startAlpha)  +  safeFadeState.startAlpha)
            elseif(safeFadeState.mode == "OUT") then 
                this:SetAlpha(((safeFadeState.timeToFade - safeFadeState.fadeTimer)  /  safeFadeState.timeToFade)  *  (safeFadeState.startAlpha - safeFadeState.endAlpha)  +  safeFadeState.endAlpha)
            end 

        else
            this:SetAlpha(safeFadeState.endAlpha)
            SecureFadeRemoveFrame(this)

            if not this:IsProtected() and safeFadeState.hideOnFinished and this:IsShown() then 
                this:Hide()
            end

            if (safeFadeState.finishedFunc) then
                safeFadeState.finishedFunc(safeFadeState.finishedArg1, safeFadeState.finishedArg2, safeFadeState.finishedArg3, safeFadeState.finishedArg4)
                safeFadeState.finishedFunc = nil
            end
        end
        i = i  +  1
    end
    if #SecureFadeFrames == 0 then 
        SecureFadeManager:SetScript("OnUpdate", nil)
    end 
end 

local function HandleFading(this, safeFadeState)
    if not this then return end 
    if not safeFadeState.mode then 
        safeFadeState.mode = "IN"
    end 

    if safeFadeState.mode == "IN" then
        if not this:IsProtected() and not this:IsShown() then this:Show() end
        if not safeFadeState.startAlpha then 
            safeFadeState.startAlpha = 0 
        end
        if not safeFadeState.endAlpha then 
            safeFadeState.endAlpha = 1.0 
        end
    elseif safeFadeState.mode == "OUT" then 
        if not safeFadeState.startAlpha then 
            safeFadeState.startAlpha = 1.0 
        end
        if not safeFadeState.endAlpha then 
            safeFadeState.endAlpha = 0 
        end
    end 

    this:SetAlpha(safeFadeState.startAlpha)
    this._secureFade = safeFadeState
    local i=1;
    while SecureFadeFrames[i] do 
        if SecureFadeFrames[i] == this then 
            return 
        end 
        i = i + 1;
    end 
    SecureFadeFrames[#SecureFadeFrames + 1] = this;
    SecureFadeManager:SetScript("OnUpdate", SecureFade_OnUpdate)
end 

function SV:SecureFadeIn(this, duration, startAlpha, endAlpha)
    local safeFadeState = {}
    safeFadeState.mode = "IN"
    safeFadeState.timeToFade = duration;
    safeFadeState.startAlpha = startAlpha or 0;
    safeFadeState.endAlpha = endAlpha or 1;
    safeFadeState.hideOnFinished = false;
    safeFadeState.finishedFunc = nil

    this._secureFade = safeFadeState

    HandleFading(this, safeFadeState)
end 

function SV:SecureFadeOut(this, duration, startAlpha, endAlpha, hideOnFinished)
    local safeFadeState = {}
    safeFadeState.mode = "OUT"
    safeFadeState.timeToFade = duration;
    safeFadeState.startAlpha = startAlpha or 1;
    safeFadeState.endAlpha = endAlpha or 0;
    safeFadeState.hideOnFinished = hideOnFinished;
    safeFadeState.finishedFunc = nil

    this._secureFade = safeFadeState

    HandleFading(this, safeFadeState)
end 

function SV:SecureFadeRemoval(this)
    local i = 1;
    while SecureFadeFrames[i] do 
        if this == SecureFadeFrames[i] then 
            tremove(SecureFadeFrames, i)
            break 
        else 
            i = i  +  1;
        end 
    end 
end 