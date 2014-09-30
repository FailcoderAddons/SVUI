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
local math 		= _G.math;
--[[ MATH METHODS ]]--
local random = math.random;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = select(2, ...)
local L = SV.L

local EgoFrame = CreateFrame("Frame", "EgoFrame", UIParent);

local LaunchPopup = function(self, emote)
	local size = SVUIParent:GetHeight()
	self.Model:Show()
	self.anim[2]:SetOffset(size, -size)
	self.anim[2]:SetOffset(0, 0)
	self.anim:Play()
	self.Model:SetAnimation(emote)
end 

local Ego_OnEvent = function(self, event)
	if event == "ACHIEVEMENT_EARNED" then 
		self:LaunchPopup(74)
	else
		self:LaunchPopup(84)
	end  
end

function BeAwesome()
	EgoFrame:LaunchPopup(74)
end

function SV:ToggleEgo()
	if not SV.db.general.ego then 
		EgoFrame:UnregisterEvent("ACHIEVEMENT_EARNED")
		EgoFrame:UnregisterEvent("SCREENSHOT_SUCCEEDED")
		EgoFrame:SetScript("OnEvent", nil)
	else 
		EgoFrame:RegisterEvent("ACHIEVEMENT_EARNED")
		EgoFrame:RegisterEvent("SCREENSHOT_SUCCEEDED")
		EgoFrame:SetScript("OnEvent", Ego_OnEvent)
	end 
end

local EgoPop_OnUpdate = function(self) self.parent:SetAlpha(0) end

local function LoadSVEgo()
	local size = UIParent:GetWidth()
	EgoFrame:SetParent(SV.UIParent)
	EgoFrame:SetPoint("TOP", SV.UIParent, "TOP", 0, 0)
	EgoFrame:SetWidth(size)
	EgoFrame:SetHeight(size)
	EgoFrame.LaunchPopup = LaunchPopup

	local model = CreateFrame("PlayerModel", "EgoFrameModel", EgoFrame)
	model:SetAllPoints(EgoFrame)
	model:SetUnit("player")
	model:Hide()

	EgoFrame.Model = model

	SV.Animate:Slide(EgoFrame, size, -size, true, 1.5)
	EgoFrame:SetAlpha(0)
	EgoFrame.anim[4]:SetScript("OnFinished", EgoPop_OnUpdate)

	SLASH_SVUI_BADASS1="/badass"
	SlashCmdList["SVUI_BADASS"] = BeAwesome;
end

SV:NewScript(LoadSVEgo)