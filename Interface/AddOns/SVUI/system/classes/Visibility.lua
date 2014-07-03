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
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L = unpack(select(2, ...));
--[[ 
########################################################## 
LOCALS
##########################################################
]]--
local SecureFadeManager = CreateFrame("Frame");
local SecureFadeFrames = {};
local StealthFrame = CreateFrame("Frame");
StealthFrame:Hide();
--[[ 
########################################################## 
FRAME VISIBILITY MANAGEMENT
##########################################################
]]--
function SuperVillain:AddToDisplayAudit(frame)
    if frame.IsVisible and frame:GetName() then
        self.DisplayAudit[frame:GetName()] = true
    end 
end;

function SuperVillain:FlushDisplayAudit()
    if InCombatLockdown() then return end;
    for frame,_ in pairs(self.DisplayAudit)do 
        if _G[frame] then 
            _G[frame]:SetParent(StealthFrame)
        end 
    end;
    self:RegisterEvent("PLAYER_REGEN_DISABLED","PushDisplayAudit")
end;

function SuperVillain:PushDisplayAudit()
    if InCombatLockdown() then return end;
    for frame,_ in pairs(self.DisplayAudit)do 
        if _G[frame] then 
            _G[frame]:SetParent(UIParent)
        end 
    end;
    self:UnregisterEvent("PLAYER_REGEN_DISABLED")
end;

function SuperVillain:SecureFade_OnUpdate(value)
    local i = 1;
    local this, safeFadeState;
    while SecureFadeFrames[i] do 
        this = SecureFadeFrames[i]
        safeFadeState = this._secureFade;
        safeFadeState.fadeTimer = (safeFadeState.fadeTimer or 0)  +  value;
        safeFadeState.fadeTimer = safeFadeState.fadeTimer  +  value;
        if safeFadeState.fadeTimer < safeFadeState.timeToFade then 
            if safeFadeState.mode == "IN" then 
                this:SetAlpha(safeFadeState.fadeTimer  /  safeFadeState.timeToFade  *  safeFadeState.endAlpha - safeFadeState.startAlpha  +  safeFadeState.startAlpha)
            elseif safeFadeState.mode == "OUT" then 
                this:SetAlpha((safeFadeState.timeToFade - safeFadeState.fadeTimer)  /  safeFadeState.timeToFade  *  safeFadeState.startAlpha - safeFadeState.endAlpha  +  safeFadeState.endAlpha)
            end 
        else 
            this:SetAlpha(safeFadeState.endAlpha)
            if not this:IsProtected() and safeFadeState.hideOnFinished and this:IsShown() then 
                this:Hide()
            end 
        end;
        i = i  +  1; 
    end;
    if #SecureFadeFrames == 0 then 
        SecureFadeManager:SetScript("OnUpdate", nil)
    end 
end;

function SuperVillain:SecureFade(this, safeFadeState)
    if not this then return end;
    local safeFadeState = this._secureFade
    if not safeFadeState.mode then 
        safeFadeState.mode = "IN"
    end;

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
    end;

    this:SetAlpha(safeFadeState.startAlpha)
    
    local i=1;
    while SecureFadeFrames[i] do 
        if SecureFadeFrames[i]==this then 
            return 
        end;
        i = i + 1;
    end;
    SecureFadeFrames[#SecureFadeFrames + 1] = this;
    SecureFadeManager:SetScript("OnUpdate", SuperVillain.SecureFade_OnUpdate)
end;

function SuperVillain:SecureFadeIn(this, duration, startAlpha, endAlpha)
    if(not this._secureFade) then
        this._secureFade = {}
    end
    this._secureFade.mode = "IN"
    this._secureFade.timeToFade = duration;
    this._secureFade.startAlpha = startAlpha or 0;
    this._secureFade.endAlpha = endAlpha or 1;
    this._secureFade.hideOnFinished = false;
    SuperVillain:SecureFade(this)
end;

function SuperVillain:SecureFadeOut(this, duration, startAlpha, endAlpha, hideOnFinished)
    if(not this._secureFade) then
        this._secureFade = {}
    end
    this._secureFade.mode = "OUT"
    this._secureFade.timeToFade = duration;
    this._secureFade.startAlpha = startAlpha or 1;
    this._secureFade.endAlpha = endAlpha or 0;
    this._secureFade.hideOnFinished = hideOnFinished;
    SuperVillain:SecureFade(this)
end;

function SuperVillain:SecureFadeRemoval(this)
    local i = 1;
    while SecureFadeFrames[i] do 
        if this == SecureFadeFrames[i] then 
            tremove(SecureFadeFrames, i)
            break 
        else 
            i = i  +  1;
        end 
    end 
end;