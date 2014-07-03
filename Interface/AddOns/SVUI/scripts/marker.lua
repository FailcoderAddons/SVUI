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
local unpack 	= _G.unpack;
local select 	= _G.select;
local pairs 	= _G.pairs;
local ipairs 	= _G.ipairs;
local type 		= _G.type;
local tinsert 	= _G.tinsert;
local math 		= _G.math;
local cos, deg, rad, sin = math.cos, math.deg, math.rad, math.sin;
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
local ButtonIsDown;
local RaidMarkFrame=CreateFrame("Frame", "SVUI_RaidMarkFrame", UIParent)
RaidMarkFrame:EnableMouse(true)
RaidMarkFrame:SetSize(100,100)
RaidMarkFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
RaidMarkFrame:SetFrameStrata("DIALOG")

local RaidMarkButton_OnEnter = function(self)
	self.Texture:ClearAllPoints()
	self.Texture:Point("TOPLEFT",-10,10)
	self.Texture:Point("BOTTOMRIGHT",10,-10)
end;

local RaidMarkButton_OnLeave = function(self)
	self.Texture:SetAllPoints()
end;

local RaidMarkButton_OnClick = function(self, button)
	PlaySound("UChatScrollButton")
	SetRaidTarget("target",button ~= "RightButton" and self:GetID() or 0)
	self:GetParent():Hide()
end;

for i=1,8 do 
	local raidMark = CreateFrame("Button", "RaidMarkIconButton"..i, RaidMarkFrame)
	raidMark:Size(40)
	raidMark:SetID(i)
	raidMark.Texture = raidMark:CreateTexture(raidMark:GetName().."NormalTexture","ARTWORK")
	raidMark.Texture:SetTexture([[Interface\TargetingFrame\UI-RaidTargetingIcons]])
	raidMark.Texture:SetAllPoints()
	SetRaidTargetIconTexture(raidMark.Texture,i)
	raidMark:RegisterForClicks("LeftbuttonUp","RightbuttonUp")
	raidMark:SetScript("OnClick",RaidMarkButton_OnClick)
	raidMark:SetScript("OnEnter",RaidMarkButton_OnEnter)
	raidMark:SetScript("OnLeave",RaidMarkButton_OnLeave)
	if(i == 8) then 
		raidMark:SetPoint("CENTER")
	else 
		local radian = 360 / 7 * i;
		raidMark:SetPoint("CENTER", sin(radian) * 60, cos(radian) * 60)
	end 
end;

RaidMarkFrame:Hide()
--[[ 
########################################################## 
RAID MARKERS
##########################################################
]]--
local function RaidMarkAllowed()
	if not RaidMarkFrame then
		return false 
	end;
	if GetNumGroupMembers()>0 then
		if UnitIsGroupLeader('player') or UnitIsGroupAssistant("player") then 
			return true 
		elseif IsInGroup() and not IsInRaid() then 
			return true 
		else
			UIErrorsFrame:AddMessage(L["You don't have permission to mark targets."], 1.0, 0.1, 0.1, 1.0, UIERRORS_HOLD_TIME)
			return false 
		end 
	else
		return true 
	end 
end;

local function RaidMarkShowIcons()
	if not UnitExists("target") or UnitIsDead("target") then return end;
	local x,y = GetCursorPosition()
	local scale = SuperVillain.UIParent:GetEffectiveScale()
	RaidMarkFrame:SetPoint("CENTER",SuperVillain.UIParent,"BOTTOMLEFT", (x / scale), (y / scale))
	RaidMarkFrame:Show()
end;
--[[ 
########################################################## 
GLOBAL KEYFUNCTION
##########################################################
]]--
function RaidMark_HotkeyPressed(button)
	ButtonIsDown = button == "down" and RaidMarkAllowed()
	if(RaidMarkFrame) then
		if ButtonIsDown then 
			RaidMarkShowIcons()
		else
			RaidMarkFrame:Hide()
		end
	end
end;
--[[ 
########################################################## 
EVENT HANDLER
##########################################################
]]--
RaidMarkFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
RaidMarkFrame:SetScript("OnEvent",function(self, event)
	if ButtonIsDown then 
		RaidMarkShowIcons()
	end 
end)