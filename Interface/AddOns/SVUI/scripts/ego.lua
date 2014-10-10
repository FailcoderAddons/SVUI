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

local Sequences = {
	{65, 1000}, --shrug
	{68, 1000}, --cheer
	{70, 1000}, --laugh
	{74, 1000}, --roar
	{77, 1000}, --cry
	{84, 1000}, --point
	{82, 1000}, --flex
};

local EgoFrame = CreateFrame("PlayerModel", "SVUI_EgoModel", UIParent);

local function rng()
	return random(1, #Sequences)
end

local LaunchAnimation = function(self, key)
	key = key or rng()
	local emote = Sequences[key][1]
	self:Show()
	self:SetAnimation(emote)
	self.anim:Play()
end

local LaunchFreezeFrame = function(self, key)
	key = key or rng()
	local animation = Sequences[key]
	local size = SVUIParent:GetHeight()
	self:Show()
	self:SetSequenceTime(unpack(animation))
	self.anim[2]:SetOffset(size, -size)
	self.anim[2]:SetOffset(0, 0)
	self.anim:Play()
end

local ResetPosition = function(self)
	local size = SVUIParent:GetHeight()
	self:SetPoint("TOP", SV.UIParent, "TOP", 0, 0)
	self:SetWidth(size)
	self:SetHeight(size)
	self:SetUnit("player")
end

local Ego_OnEvent = function(self, event)
	if event == "ACHIEVEMENT_EARNED" then 
		self:LaunchAnimation(4)
	else
		self:LaunchAnimation(6)
	end  
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
	EgoFrame:SetUnit("player")
	EgoFrame.LaunchAnimation = LaunchAnimation
	EgoFrame.LaunchFreezeFrame = LaunchFreezeFrame
	EgoFrame.ResetPosition = ResetPosition
	SV.Animate:Slide(EgoFrame, 0, 0, true, 1.5)
	EgoFrame.anim[4]:SetScript("OnFinished", EgoPop_OnUpdate)

	EgoFrame:Hide()
end

_G.SlashCmdList["BADASS"] = function()
	EgoFrame:LaunchAnimation(4)
end
_G.SLASH_BADASS1 = "/badass"

SV:NewScript(LoadSVEgo)