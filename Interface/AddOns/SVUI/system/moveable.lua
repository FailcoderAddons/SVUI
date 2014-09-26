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
local type 		= _G.type;
local string 	= _G.string;
local math 		= _G.math;
--[[ STRING METHODS ]]--
local format, split = string.format, string.split;
--[[ MATH METHODS ]]--
local min, floor = math.min, math.floor;
local parsefloat = math.parsefloat;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SVUI_ADDON_NAME, SV = ...
local SVLib = LibStub("LibSuperVillain-1.0")
local L = SVLib:Lang();

local Movable = CreateFrame("Frame", nil)
Movable.Frames = {}
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local DraggableFrames = {
	"AchievementFrame",
	"AuctionFrame",
	"ArchaeologyFrame",
	"BattlefieldMinimap",
	"BarberShopFrame",
	"BlackMarketFrame",
	"CalendarFrame",
	"CharacterFrame",
	"ClassTrainerFrame",
	"DressUpFrame",
	"EncounterJournal",
	"FriendsFrame",
	"GameMenuFrame",
	"GMSurveyFrame",
	"GossipFrame",
	"GuildFrame",
	"GuildBankFrame",
	"GuildRegistrarFrame",
	"HelpFrame",
	"InterfaceOptionsFrame",
	"ItemUpgradeFrame",
	"KeyBindingFrame",
	"LFGDungeonReadyPopup",
	"MacOptionsFrame",
	"MacroFrame",
	"MailFrame",
	"MerchantFrame",
	"PlayerTalentFrame",
	"PetJournalParent",
	"PVEFrame",
	"PVPFrame",
	"QuestFrame",
	"QuestLogFrame",
	"RaidBrowserFrame",
	"ReadyCheckFrame",
	"ReforgingFrame",
	"ReportCheatingDialog",
	"ReportPlayerNameDialog",
	"RolePollPopup",
	"ScrollOfResurrectionSelectionFrame",
	"SpellBookFrame",
	"TabardFrame",
	"TaxiFrame",
	"TimeManagerFrame",
	"TradeSkillFrame",
	"TradeFrame",
	"TransmorgifyFrame",
	"TutorialFrame",
	"VideoOptionsFrame",
	"VoidStorageFrame",
	--"WorldStateAlwaysUpFrame"
};
--[[ 
########################################################## 
LOCAL FUNCTIONS
##########################################################
]]--
local BlizzardFrame_OnUpdate = function(self)
	if InCombatLockdown() or self:GetName() == "GameMenuFrame" then return end 
	if self.IsMoving then return end 
	self:ClearAllPoints()
	if self:GetName() == "QuestFrame" then 
		if Movable.Frames["GossipFrame"].Points  ~= nil then 
			self:SetPoint(unpack(Movable.Frames["GossipFrame"].Points))
		end 
	elseif Movable.Frames[self:GetName()].Points  ~= nil then 
		self:SetPoint(unpack(Movable.Frames[self:GetName()].Points))
	end 
end

local BlizzardFrame_OnDragStart = function(self)
	if not self:IsMovable() then return end 
	self:StartMoving()
	self.IsMoving = true
end

local BlizzardFrame_OnDragStop = function(self)
	if not self:IsMovable() then return end 
	self.IsMoving = false;
	self:StopMovingOrSizing()
	if self:GetName() == "GameMenuFrame" then return end 
	local anchor1, parent, anchor2, x, y = self:GetPoint()
	parent = self:GetParent():GetName()
	self:ClearAllPoints()
	self:SetPoint(anchor1, parent, anchor2, x, y)
	if self:GetName() == "QuestFrame" then 
		Movable.Frames["GossipFrame"].Points = {anchor1, parent, anchor2, x, y}
	else 
		Movable.Frames[self:GetName()].Points = {anchor1, parent, anchor2, x, y}
	end 
end

local Movable_OnEvent = function(self) 
	for _, frameName in pairs(DraggableFrames) do
		local frame = _G[frameName] 
		if(frame) then
			if(not frameName == "LossOfControlFrame" and (not Movable.Frames[frameName])) then 
				frame:EnableMouse(true)

				if(frameName == "LFGDungeonReadyPopup") then 
					LFGDungeonReadyDialog:EnableMouse(false)
				end

				frame:SetMovable(true)
				frame:RegisterForDrag("LeftButton")
				frame:SetClampedToScreen(true)
				frame:HookScript("OnUpdate", BlizzardFrame_OnUpdate)
				frame:SetScript("OnDragStart", BlizzardFrame_OnDragStart)
				frame:SetScript("OnDragStop", BlizzardFrame_OnDragStop)
				Movable.Frames[frameName] = {}
			end
		end 
	end
	if(not Movable.Frames["GameMenuFrame"]) then 
		Movable.Frames["GameMenuFrame"] = {}
	end
end

Movable:RegisterEvent("PLAYER_LOGIN")
Movable:RegisterEvent("ADDON_LOADED")
Movable:RegisterEvent("LFG_UPDATE")
Movable:RegisterEvent("ROLE_POLL_BEGIN")
Movable:RegisterEvent("READY_CHECK")
Movable:RegisterEvent("UPDATE_WORLD_STATES")
Movable:RegisterEvent("WORLD_STATE_TIMER_START")
Movable:RegisterEvent("WORLD_STATE_UI_TIMER_UPDATE")

Movable:SetScript("OnEvent", Movable_OnEvent)