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
local tinsert 	= _G.tinsert;
local string 	= _G.string;
local math 		= _G.math;
--[[ STRING METHODS ]]--
local find, format, len, split = string.find, string.format, string.len, string.split;
--[[ MATH METHODS ]]--
local abs, ceil, floor, round = math.abs, math.ceil, math.floor, math.round;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L = unpack(select(2, ...));
local MOD = {};
MOD.LewtRollz = {};
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local UIErrorsFrame = UIErrorsFrame;
local interruptMsg = INTERRUPTED.." %s's \124cff71d5ff\124Hspell:%d\124h[%s]\124h\124r!";
local NewHook = hooksecurefunc;
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
local PVPRaidNoticeHandler = function(self, event, msg)
	local _, instanceType = IsInInstance()
	if instanceType == 'pvp' or instanceType == 'arena' then
		RaidNotice_AddMessage(RaidBossEmoteFrame, msg, ChatTypeInfo["RAID_BOSS_EMOTE"]);
	end 
end;

local CaptureBarHandler = function()
	if NUM_EXTENDED_UI_FRAMES then
		local captureBar
		for i=1, NUM_EXTENDED_UI_FRAMES do
			captureBar = _G["WorldStateCaptureBar" .. i]

			if captureBar and captureBar:IsVisible() then
				captureBar:ClearAllPoints()
				
				if( i == 1 ) then
					captureBar:Point("TOP", SVUI_WorldStateHolder, "TOP", 0, 0)
				else
					captureBar:Point("TOPLEFT", _G["WorldStateCaptureBar" .. i - 1], "TOPLEFT", 0, -45)
				end
			end	
		end	
	end
end

local ErrorFrameHandler = function(self, event)
	if not SuperVillain.db.system.hideErrorFrame then return end
	if event == 'PLAYER_REGEN_DISABLED' then
		UIErrorsFrame:UnregisterEvent('UI_ERROR_MESSAGE')
	else
		UIErrorsFrame:RegisterEvent('UI_ERROR_MESSAGE')
	end
end

local Vehicle_OnSetPoint = function(self,_,parent)
	if(parent == "MinimapCluster" or parent == _G["MinimapCluster"]) then 
		VehicleSeatIndicator:ClearAllPoints()
		if VehicleSeat_MOVE then 
			VehicleSeatIndicator:Point("TOPLEFT",VehicleSeat_MOVE,"TOPLEFT",0,0)
		else 
			VehicleSeatIndicator:Point("TOPLEFT",SuperVillain.UIParent,"TOPLEFT",22,-45)
			SuperVillain:SetSVMovable(VehicleSeatIndicator,"VehicleSeat_MOVE",L["Vehicle Seat Frame"])
		end;
		VehicleSeatIndicator:SetScale(0.8)
	end 
end
local Dura_OnSetPoint = function(_, _, anchor)
	if anchor == "MinimapCluster"or anchor == _G["MinimapCluster"] then
		DurabilityFrame:ClearAllPoints()
		DurabilityFrame:Point("RIGHT", Minimap, "RIGHT")
		DurabilityFrame:SetScale(0.6)
	end 
end

function MOD:DisbandRaidGroup()
	if InCombatLockdown() then return end -- Prevent user error in combat

	if UnitInRaid("player") then
		for i = 1, GetNumGroupMembers() do
			local name, _, _, _, _, _, _, online = GetRaidRosterInfo(i)
			if online and name ~= E.myname then
				UninviteUnit(name)
			end
		end
	else
		for i = MAX_PARTY_MEMBERS, 1, -1 do
			if UnitExists("party"..i) then
				UninviteUnit(UnitName("party"..i))
			end
		end
	end
	LeaveParty()
end

function MOD:ConstructThisPackage()
	HelpOpenTicketButtonTutorial:MUNG()
	TalentMicroButtonAlert:MUNG()
	HelpPlate:MUNG()
	HelpPlateTooltip:MUNG()
	CompanionsMicroButtonAlert:MUNG()
	UIPARENT_MANAGED_FRAME_POSITIONS["GroupLootContainer"] = nil;
	
	DurabilityFrame:SetFrameStrata("HIGH")
	NewHook(DurabilityFrame, "SetPoint", Dura_OnSetPoint)
	
	TicketStatusFrame:ClearAllPoints()
	TicketStatusFrame:SetPoint("TOPLEFT", SuperVillain.UIParent, "TOPLEFT", 250, -5)
	SuperVillain:SetSVMovable(TicketStatusFrame, "GM_MOVE", L["GM Ticket Frame"])
	HelpOpenTicketButton:SetParent(Minimap)
	HelpOpenTicketButton:ClearAllPoints()
	HelpOpenTicketButton:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT")

	NewHook(VehicleSeatIndicator, "SetPoint", Vehicle_OnSetPoint)
	VehicleSeatIndicator:SetPoint("TOPLEFT", MinimapCluster, "TOPLEFT", 2, 2)
	
	self:RegisterEvent("CHAT_MSG_BG_SYSTEM_HORDE", PVPRaidNoticeHandler)
	self:RegisterEvent("CHAT_MSG_BG_SYSTEM_ALLIANCE", PVPRaidNoticeHandler)
	self:RegisterEvent("CHAT_MSG_BG_SYSTEM_NEUTRAL", PVPRaidNoticeHandler)
	self:RegisterEvent('PLAYER_REGEN_DISABLED', ErrorFrameHandler)
	self:RegisterEvent('PLAYER_REGEN_ENABLED', ErrorFrameHandler)

	SuperVillain.Registry:RunTemp("SVOverride");

	local altPower = CreateFrame("Frame", "AltPowerBarHolder", UIParent)
	altPower:SetPoint("TOP", SuperVillain.UIParent, "TOP", 0, -18)
	altPower:Size(128, 50)
	PlayerPowerBarAlt:ClearAllPoints()
	PlayerPowerBarAlt:SetPoint("CENTER", altPower, "CENTER")
	PlayerPowerBarAlt:SetParent(altPower)
	PlayerPowerBarAlt.ignoreFramePositionManager = true;
	SuperVillain:SetSVMovable(altPower, "AltPowerBar_MOVE", L["Alternative Power"])

	local wsc = CreateFrame("Frame", "SVUI_WorldStateHolder", SuperVillain.UIParent)
	wsc:SetSize(200, 45)
	wsc:SetPoint("TOP", SuperVillain.UIParent, "TOP", 0, -100)
	SuperVillain:SetSVMovable(wsc, "SVUI_WorldStateHolder_MOVE", L["Capture Bars"])
	NewHook("UIParent_ManageFramePositions", CaptureBarHandler)

	SuperVillain:SetSVMovable(LossOfControlFrame, "LossOfControlFrame_MOVE", L["Loss Control Icon"])
end

SuperVillain.Registry:NewPackage(MOD, "SVOverride");