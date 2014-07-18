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
local table     = _G.table;
local format = string.format;
local tcopy = table.copy;
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
local CURRENT_PAGE, MAX_PAGE, XOFF = 0, 8, (GetScreenWidth() * 0.025)
local okToResetMOVE = false
local mungs = false;
local user_music_vol;
local musicIsPlaying;
--[[ 
########################################################## 
LOCAL FUNCTIONS
##########################################################
]]--
local function SetInstallButton(button)
    if(not button) then return end 
    button.Left:SetAlpha(0)
    button.Middle:SetAlpha(0)
    button.Right:SetAlpha(0)
    button:SetNormalTexture("")
    button:SetPushedTexture("")
    button:SetPushedTexture("")
    button:SetDisabledTexture("")
    button:Formula409()
    button:SetFrameLevel(button:GetFrameLevel() + 1)
end 

local function forceCVars()
	SetCVar("alternateResourceText",1)
	SetCVar("statusTextDisplay","BOTH")
	SetCVar("mapQuestDifficulty",1)
	SetCVar("ShowClassColorInNameplate",1)
	SetCVar("screenshotQuality",10)
	SetCVar("chatMouseScroll",1)
	SetCVar("chatStyle","classic")
	SetCVar("WholeChatWindowClickable",0)
	SetCVar("ConversationMode","inline")
	SetCVar("showTutorials",0)
	SetCVar("UberTooltips",1)
	SetCVar("threatWarning",3)
	SetCVar('alwaysShowActionBars',1)
	SetCVar('lockActionBars',1)
	SetCVar('SpamFilter',0)
	InterfaceOptionsActionBarsPanelPickupActionKeyDropDown:SetValue('SHIFT')
	InterfaceOptionsActionBarsPanelPickupActionKeyDropDown:RefreshValue()
end 

local function BarShuffle()
	local bar2 = SuperVillain.db.SVBar.Bar2.enable;
	local base = 30;
	local bS = SuperVillain.db.SVBar.Bar1.buttonspacing;
	local tH = SuperVillain.db.SVBar.Bar1.buttonsize  +  base;
	local b2h = bar2 and tH or base;
	local sph = (400 - b2h);
	if not SuperVillain.db.framelocations then SuperVillain.db.framelocations = {} end
	SuperVillain.db.framelocations.SVUI_SpecialAbility_MOVE = "BOTTOMSVUIParentBOTTOM0"..sph;
	SuperVillain.db.framelocations.SVUI_ActionBar2_MOVE = "BOTTOMSVUI_ActionBar1TOP04";
	SuperVillain.db.framelocations.SVUI_ActionBar3_MOVE = "BOTTOMLEFTSVUI_ActionBar1BOTTOMRIGHT40";
	SuperVillain.db.framelocations.SVUI_ActionBar5_MOVE = "BOTTOMRIGHTSVUI_ActionBar1BOTTOMLEFT-40";
	if bar2 then
		SuperVillain.db.framelocations.SVUI_PetActionBar_MOVE = "BOTTOMLEFTSVUI_ActionBar2TOPLEFT04"
		SuperVillain.db.framelocations.SVUI_StanceBar_MOVE = "BOTTOMRIGHTSVUI_ActionBar2TOPRIGHT04";
	else
		SuperVillain.db.framelocations.SVUI_PetActionBar_MOVE = "BOTTOMLEFTSVUI_ActionBar1TOPLEFT04"
		SuperVillain.db.framelocations.SVUI_StanceBar_MOVE = "BOTTOMRIGHTSVUI_ActionBar1TOPRIGHT04";
	end
end 

local function UFMoveBottomQuadrant(toggle)
	if not SuperVillain.db.framelocations then SuperVillain.db.framelocations = {} end
	if not toggle then
		SuperVillain.db.framelocations.SVUI_Player_MOVE = "BOTTOMSVUIParentBOTTOM-278182"
		SuperVillain.db.framelocations.SVUI_PlayerCastbar_MOVE = "BOTTOMSVUIParentBOTTOM-278122"
		SuperVillain.db.framelocations.SVUI_Target_MOVE = "BOTTOMSVUIParentBOTTOM278182"
		SuperVillain.db.framelocations.SVUI_TargetCastbar_MOVE = "BOTTOMSVUIParentBOTTOM278122"
		SuperVillain.db.framelocations.SVUI_Pet_MOVE = "BOTTOMSVUIParentBOTTOM0182"
		SuperVillain.db.framelocations.SVUI_TargetTarget_MOVE = "BOTTOMSVUIParentBOTTOM0225"
		SuperVillain.db.framelocations.SVUI_Focus_MOVE = "BOTTOMSVUIParentBOTTOM310432"
		SuperVillain.db.framelocations.SVUI_ThreatBar_MOVE = "BOTTOMRIGHTSVUIParentBOTTOMRIGHT-495182"
	elseif toggle == "shift" then
		SuperVillain.db.framelocations.SVUI_Player_MOVE = "BOTTOMSVUIParentBOTTOM-278210"
		SuperVillain.db.framelocations.SVUI_PlayerCastbar_MOVE = "BOTTOMSVUIParentBOTTOM-278150"
		SuperVillain.db.framelocations.SVUI_Target_MOVE = "BOTTOMSVUIParentBOTTOM278210"
		SuperVillain.db.framelocations.SVUI_TargetCastbar_MOVE = "BOTTOMSVUIParentBOTTOM278150"
		SuperVillain.db.framelocations.SVUI_Pet_MOVE = "BOTTOMSVUIParentBOTTOM0210"
		SuperVillain.db.framelocations.SVUI_TargetTarget_MOVE = "BOTTOMSVUIParentBOTTOM0253"
		SuperVillain.db.framelocations.SVUI_Focus_MOVE = "BOTTOMSVUIParentBOTTOM310432"
		SuperVillain.db.framelocations.SVUI_ThreatBar_MOVE = "BOTTOMRIGHTSVUIParentBOTTOMRIGHT-495210"
	else
		local c = 136;
		local d = 135;
		local e = 80;
		SuperVillain.db.framelocations.SVUI_Player_MOVE = "BOTTOMSVUIParentBOTTOM"..-c..""..d;
		SuperVillain.db.framelocations.SVUI_PlayerCastbar_MOVE = "BOTTOMSVUIParentBOTTOM"..-c..""..(d-60);
		SuperVillain.db.framelocations.SVUI_Target_MOVE = "BOTTOMSVUIParentBOTTOM"..c..""..d;
		SuperVillain.db.framelocations.SVUI_TargetCastbar_MOVE = "BOTTOMSVUIParentBOTTOM"..c..""..(d-60);
		SuperVillain.db.framelocations.SVUI_Pet_MOVE = "BOTTOMSVUIParentBOTTOM"..-c..""..e;
		SuperVillain.db.framelocations.SVUI_TargetTarget_MOVE = "BOTTOMSVUIParentBOTTOM"..c..""..e;
		SuperVillain.db.framelocations.SVUI_Focus_MOVE = "BOTTOMSVUIParentBOTTOM"..c..""..(d + 150);
		SuperVillain.db.framelocations.SVUI_ThreatBar_MOVE = "BOTTOMRIGHTSVUIParentBOTTOMRIGHT-495"..d;
	end
end 

local function UFMoveLeftQuadrant(toggle)
	if not SuperVillain.db.framelocations then SuperVillain.db.framelocations = {} end
	if not toggle then
		SuperVillain.db.framelocations.SVUI_Assist_MOVE = "TOPLEFTSVUIParentTOPLEFT"..XOFF.."-250"
		SuperVillain.db.framelocations.SVUI_Tank_MOVE = "TOPLEFTSVUIParentTOPLEFT"..XOFF.."-175"
		SuperVillain.db.framelocations.SVUI_Raidpet_MOVE = "TOPLEFTSVUIParentTOPLEFT"..XOFF.."-325"
		SuperVillain.db.framelocations.SVUI_Party_MOVE = "BOTTOMLEFTSVUIParentBOTTOMLEFT"..XOFF.."400"
		SuperVillain.db.framelocations.SVUI_Raid10_MOVE = "BOTTOMLEFTSVUIParentBOTTOMLEFT"..XOFF.."400"
		SuperVillain.db.framelocations.SVUI_Raid25_MOVE = "BOTTOMLEFTSVUIParentBOTTOMLEFT"..XOFF.."400"
		SuperVillain.db.framelocations.SVUI_Raid40_MOVE = "BOTTOMLEFTSVUIParentBOTTOMLEFT"..XOFF.."400"
	else
		SuperVillain.db.framelocations.SVUI_Assist_MOVE = "TOPLEFTSVUIParentTOPLEFT4-250"
		SuperVillain.db.framelocations.SVUI_Tank_MOVE = "TOPLEFTSVUIParentTOPLEFT4-175"
		SuperVillain.db.framelocations.SVUI_Raidpet_MOVE = "TOPLEFTSVUIParentTOPLEFT4-325"
		SuperVillain.db.framelocations.SVUI_Party_MOVE = "BOTTOMLEFTSVUIParentBOTTOMLEFT4300"
		SuperVillain.db.framelocations.SVUI_Raid40_MOVE = "BOTTOMLEFTSVUIParentBOTTOMLEFT4300"
		SuperVillain.db.framelocations.SVUI_Raid10_MOVE = "BOTTOMLEFTSVUIParentBOTTOMLEFT4300"
		SuperVillain.db.framelocations.SVUI_Raid25_MOVE = "BOTTOMLEFTSVUIParentBOTTOMLEFT4300"
	end
end 

local function UFMoveTopQuadrant(toggle)
	if not SuperVillain.db.framelocations then SuperVillain.db.framelocations = {} end
	if not toggle then
		SuperVillain.db.framelocations.GM_MOVE = "TOPLEFTSVUIParentTOPLEFT250-25"
		SuperVillain.db.framelocations.LootFrame_MOVE = "BOTTOMSVUIParentBOTTOM0350"
		SuperVillain.db.framelocations.AltPowerBar_MOVE = "TOPSVUIParentTOP0-40"
		SuperVillain.db.framelocations.LossOfControlFrame_MOVE = "BOTTOMSVUIParentBOTTOM0350"
		SuperVillain.db.framelocations.BNET_MOVE = "TOPRIGHTSVUIParentTOPRIGHT-4-250"
	else
		SuperVillain.db.framelocations.GM_MOVE = "TOPLEFTSVUIParentTOPLEFT344-25"
		SuperVillain.db.framelocations.LootFrame_MOVE = "BOTTOMSVUIParentBOTTOM0254"
		SuperVillain.db.framelocations.AltPowerBar_MOVE = "TOPSVUIParentTOP0-39"
		SuperVillain.db.framelocations.LossOfControlFrame_MOVE = "BOTTOMSVUIParentBOTTOM0443"
		SuperVillain.db.framelocations.BNET_MOVE = "TOPRIGHTSVUIParentTOPRIGHT-4-248"
	end
end 

local function UFMoveRightQuadrant(toggle)
	if not SuperVillain.db.framelocations then SuperVillain.db.framelocations = {} end
	local dH = SuperVillain.db.SVDock.dockRightHeight  +  60
	if not toggle or toggle == "high" then
		SuperVillain.db.framelocations.SVUI_BossHolder_MOVE = "RIGHTSVUIParentRIGHT-1050"
		SuperVillain.db.framelocations.SVUI_ArenaHolder_MOVE = "RIGHTSVUIParentRIGHT-1050"
		SuperVillain.db.framelocations.Tooltip_MOVE = "BOTTOMRIGHTSVUIParentBOTTOMRIGHT-284"..dH;
	else
		SuperVillain.db.framelocations.SVUI_BossHolder_MOVE = "RIGHTSVUIParentRIGHT-1050"
		SuperVillain.db.framelocations.SVUI_ArenaHolder_MOVE = "RIGHTSVUIParentRIGHT-1050"
		SuperVillain.db.framelocations.Tooltip_MOVE = "BOTTOMRIGHTSVUIParentBOTTOMRIGHT-284"..dH;
	end
end 

local function initChat(mungs)
	forceCVars()
	FCF_ResetChatWindows()
	FCF_SetLocked(ChatFrame1, 1)
	FCF_DockFrame(ChatFrame2)
	FCF_SetLocked(ChatFrame2, 1)
	FCF_OpenNewWindow(LOOT)
	FCF_DockFrame(ChatFrame3)
	FCF_SetLocked(ChatFrame3, 1)
	for i = 1, NUM_CHAT_WINDOWS do
		local chat = _G["ChatFrame"..i]
		local chatID = chat:GetID()
		if i == 1 then 
			chat:ClearAllPoints()
			chat:Point("BOTTOMLEFT", LeftSuperDock, "BOTTOMLEFT", 5, 5)
			chat:Point("TOPRIGHT", LeftSuperDock, "TOPRIGHT", -5, -10)
		end 
		FCF_SavePositionAndDimensions(chat)
		FCF_StopDragging(chat)
		FCF_SetChatWindowFontSize(nil, chat, 12)
		if i == 1 then 
			FCF_SetWindowName(chat, GENERAL)
		elseif i == 2 then 
			FCF_SetWindowName(chat, GUILD_EVENT_LOG)
		elseif i == 3 then 
			FCF_SetWindowName(chat, LOOT)
		end 
	end 
	ChatFrame_RemoveAllMessageGroups(ChatFrame1)
	ChatFrame_AddMessageGroup(ChatFrame1, "SAY")
	ChatFrame_AddMessageGroup(ChatFrame1, "EMOTE")
	ChatFrame_AddMessageGroup(ChatFrame1, "YELL")
	ChatFrame_AddMessageGroup(ChatFrame1, "GUILD")
	ChatFrame_AddMessageGroup(ChatFrame1, "OFFICER")
	ChatFrame_AddMessageGroup(ChatFrame1, "GUILD_ACHIEVEMENT")
	ChatFrame_AddMessageGroup(ChatFrame1, "WHISPER")
	ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_SAY")
	ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_EMOTE")
	ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_YELL")
	ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_BOSS_EMOTE")
	ChatFrame_AddMessageGroup(ChatFrame1, "PARTY")
	ChatFrame_AddMessageGroup(ChatFrame1, "PARTY_LEADER")
	ChatFrame_AddMessageGroup(ChatFrame1, "RAID")
	ChatFrame_AddMessageGroup(ChatFrame1, "RAID_LEADER")
	ChatFrame_AddMessageGroup(ChatFrame1, "RAID_WARNING")
	ChatFrame_AddMessageGroup(ChatFrame1, "INSTANCE_CHAT")
	ChatFrame_AddMessageGroup(ChatFrame1, "INSTANCE_CHAT_LEADER")
	ChatFrame_AddMessageGroup(ChatFrame1, "BATTLEGROUND")
	ChatFrame_AddMessageGroup(ChatFrame1, "BATTLEGROUND_LEADER")
	ChatFrame_AddMessageGroup(ChatFrame1, "BG_HORDE")
	ChatFrame_AddMessageGroup(ChatFrame1, "BG_ALLIANCE")
	ChatFrame_AddMessageGroup(ChatFrame1, "BG_NEUTRAL")
	ChatFrame_AddMessageGroup(ChatFrame1, "SYSTEM")
	ChatFrame_AddMessageGroup(ChatFrame1, "ERRORS")
	ChatFrame_AddMessageGroup(ChatFrame1, "AFK")
	ChatFrame_AddMessageGroup(ChatFrame1, "DND")
	ChatFrame_AddMessageGroup(ChatFrame1, "IGNORED")
	ChatFrame_AddMessageGroup(ChatFrame1, "ACHIEVEMENT")
	ChatFrame_AddMessageGroup(ChatFrame1, "BN_WHISPER")
	ChatFrame_AddMessageGroup(ChatFrame1, "BN_CONVERSATION")
	ChatFrame_AddMessageGroup(ChatFrame1, "BN_INLINE_TOAST_ALERT")
	ChatFrame_AddMessageGroup(ChatFrame1, "COMBAT_FACTION_CHANGE")
	ChatFrame_AddMessageGroup(ChatFrame1, "SKILL")
	ChatFrame_AddMessageGroup(ChatFrame1, "LOOT")
	ChatFrame_AddMessageGroup(ChatFrame1, "MONEY")
	ChatFrame_AddMessageGroup(ChatFrame1, "COMBAT_XP_GAIN")
	ChatFrame_AddMessageGroup(ChatFrame1, "COMBAT_HONOR_GAIN")
	ChatFrame_AddMessageGroup(ChatFrame1, "COMBAT_GUILD_XP_GAIN")
	ChatFrame_RemoveAllMessageGroups(ChatFrame3)
	ChatFrame_AddMessageGroup(ChatFrame3, "COMBAT_FACTION_CHANGE")
	ChatFrame_AddMessageGroup(ChatFrame3, "SKILL")
	ChatFrame_AddMessageGroup(ChatFrame3, "LOOT")
	ChatFrame_AddMessageGroup(ChatFrame3, "MONEY")
	ChatFrame_AddMessageGroup(ChatFrame3, "COMBAT_XP_GAIN")
	ChatFrame_AddMessageGroup(ChatFrame3, "COMBAT_HONOR_GAIN")
	ChatFrame_AddMessageGroup(ChatFrame3, "COMBAT_GUILD_XP_GAIN")
	ChatFrame_AddChannel(ChatFrame1, GENERAL)
	ToggleChatColorNamesByClassGroup(true, "SAY")
	ToggleChatColorNamesByClassGroup(true, "EMOTE")
	ToggleChatColorNamesByClassGroup(true, "YELL")
	ToggleChatColorNamesByClassGroup(true, "GUILD")
	ToggleChatColorNamesByClassGroup(true, "OFFICER")
	ToggleChatColorNamesByClassGroup(true, "GUILD_ACHIEVEMENT")
	ToggleChatColorNamesByClassGroup(true, "ACHIEVEMENT")
	ToggleChatColorNamesByClassGroup(true, "WHISPER")
	ToggleChatColorNamesByClassGroup(true, "PARTY")
	ToggleChatColorNamesByClassGroup(true, "PARTY_LEADER")
	ToggleChatColorNamesByClassGroup(true, "RAID")
	ToggleChatColorNamesByClassGroup(true, "RAID_LEADER")
	ToggleChatColorNamesByClassGroup(true, "RAID_WARNING")
	ToggleChatColorNamesByClassGroup(true, "BATTLEGROUND")
	ToggleChatColorNamesByClassGroup(true, "BATTLEGROUND_LEADER")
	ToggleChatColorNamesByClassGroup(true, "INSTANCE_CHAT")
	ToggleChatColorNamesByClassGroup(true, "INSTANCE_CHAT_LEADER")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL1")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL2")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL3")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL4")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL5")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL6")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL7")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL8")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL9")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL10")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL11")
	ChangeChatColor("CHANNEL1", 195 / 255, 230 / 255, 232 / 255)
	ChangeChatColor("CHANNEL2", 232 / 255, 158 / 255, 121 / 255)
	ChangeChatColor("CHANNEL3", 232 / 255, 228 / 255, 121 / 255)
	if not mungs then
		if SuperVillain.Chat then 
			SuperVillain.Chat:ReLoad(true)
			if SVUI_Cache["Dock"].RightSuperDockFaded  == true then RightSuperDockToggleButton:Click()end 
			if SVUI_Cache["Dock"].LeftSuperDockFaded  == true then LeftSuperDockToggleButton:Click()end 
		end
		SuperVillain:SavedPopup()
	end
end 
--[[ 
########################################################## 
GLOBAL/MODULE FUNCTIONS
##########################################################
]]--
function SuperVillain:SetUserScreen(rez, preserve)
	if not preserve then
		if okToResetMOVE then 
			self:ResetMovables("")
			okToResetMOVE = false;
		end 
		self.db:SetDefault("SVUnit")
	end

	if not SuperVillain.db.framelocations then SuperVillain.db.framelocations = {} end
	if rez == "low" then 
		if not preserve then 
			self.db.SVDock.dockLeftWidth = 350;
			self.db.SVDock.dockLeftHeight = 180;
			self.db.SVDock.dockRightWidth = 350;
			self.db.SVDock.dockRightHeight = 180;
			self.db.SVAura.wrapAfter = 10
			self.db.SVUnit.fontSize = 10;
			self.db.SVUnit.player.width = 200;
			self.db.SVUnit.player.castbar.width = 200;
			self.db.SVUnit.player.classbar.fill = "fill"
			self.db.SVUnit.player.health.tags = "[health:color][health:current]"
			self.db.SVUnit.target.width = 200;
			self.db.SVUnit.target.castbar.width = 200;
			self.db.SVUnit.target.health.tags = "[health:color][health:current]"
			self.db.SVUnit.pet.power.enable = false;
			self.db.SVUnit.pet.width = 200;
			self.db.SVUnit.pet.height = 26;
			self.db.SVUnit.targettarget.debuffs.enable = false;
			self.db.SVUnit.targettarget.power.enable = false;
			self.db.SVUnit.targettarget.width = 200;
			self.db.SVUnit.targettarget.height = 26;
			self.db.SVUnit.boss.width = 200;
			self.db.SVUnit.boss.castbar.width = 200;
			self.db.SVUnit.arena.width = 200;
			self.db.SVUnit.arena.castbar.width = 200 
		end 
		if not mungs then
			UFMoveBottomQuadrant(true)
			UFMoveLeftQuadrant(true)
			UFMoveTopQuadrant(true)
			UFMoveRightQuadrant(true)
		end
		self.ghettoMonitor = true 
	else
		self.db:SetDefault("SVDock")
		self.db:SetDefault("SVAura")
		if not mungs then
			UFMoveBottomQuadrant()
			UFMoveLeftQuadrant()
			UFMoveTopQuadrant()
			UFMoveRightQuadrant()
		end
		self.ghettoMonitor = nil 
	end 

	if(not preserve and not mungs) then
		BarShuffle()
    	self:SetSVMovablesPositions()
		self.Registry:Update('SVDock')
		self.Registry:Update('SVAura')
		self.Registry:Update('SVUnit')
		SuperVillain:SavedPopup()
	end
end 

function SuperVillain:SetColorTheme(style, preserve)
	style = style or "default";

	if not preserve then
		self.db:SetDefault("media")
	end

	local presets = self:LoadPresetData("media", style)
	self.db.SAFEDATA.mediastyle = style;

	if(style == "default") then 
		self.db.SVUnit.healthclass = true;
	else
		self.db.SVUnit.healthclass = false;
	end 
	
	if(not mungs) then
		self:MediaUpdate()
		self.Registry:Update('SVStats')
		self.Registry:Update('SVUnit')
		if(not preserve) then
			SuperVillain:SavedPopup()
		end
	end
end 

function SuperVillain:SetUnitframeLayout(style, preserve)
	style = style or "default";

	if not SuperVillain.db.framelocations then SuperVillain.db.framelocations = {} end

	if not preserve then
		self.db:SetDefault("SVUnit")
		self.db:SetDefault("SVStats")
		if okToResetMOVE then
			self:ResetMovables('')
			okToResetMOVE = false
		end
	end

	local presets = self:LoadPresetData("units", style)
	self.db.SAFEDATA.unitstyle = style

	if(self.db.SAFEDATA.mediastyle == "default") then 
		self.db.SVUnit.healthclass = true;
	end 

	if(not mungs) then
		if(not preserve) then
			if self.db.SAFEDATA.barstyle and (self.db.SAFEDATA.barstyle == "twosmall" or self.db.SAFEDATA.barstyle == "twobig") then 
				UFMoveBottomQuadrant("shift")
			else
				UFMoveBottomQuadrant()
			end
			self:SetSVMovablesPositions()
		end
		self.Registry:Update('SVStats')
		self.Registry:Update('SVUnit')
		if(not preserve) then
			SuperVillain:SavedPopup()
		end
	end
end 

function SuperVillain:SetupBarLayout(style, preserve)
	style = style or "default";

	if not SuperVillain.db.framelocations then SuperVillain.db.framelocations={} end 
	if not preserve then 
		self.db:SetDefault("SVBar")
		if okToResetMOVE then
			self:ResetMovables('')
			okToResetMOVE=false
		end
	end 

	local presets = self:LoadPresetData("bars", style)
	self.db.SAFEDATA.barstyle = style;

	if(not mungs) then
		if(not preserve) then
			if(style == 'twosmall' or style == 'twobig') then 
				UFMoveBottomQuadrant("shift")
			else
				UFMoveBottomQuadrant()
			end
		end
		if(not preserve) then
			BarShuffle()
			self:SetSVMovablesPositions()
		end
		self.Registry:Update('SVStats')
		self.Registry:Update('SVBar')
		if(not preserve) then
			SuperVillain:SavedPopup()
		end
	end
end 

function SuperVillain:SetupAuralayout(style, preserve)
	style = style or "default";
	local presets = self:LoadPresetData("auras", style)
	self.db.SAFEDATA.aurastyle = style;

	if(not mungs) then
		self.Registry:Update('SVStats')
		self.Registry:Update('SVAura')
		self.Registry:Update('SVUnit')
		if(not preserve) then
			SuperVillain:SavedPopup()
		end
	end
end 

local function PlayThemeSong()
	if(not musicIsPlaying) then
		SetCVar("Sound_MusicVolume", 100)
		SetCVar("Sound_EnableMusic", 1)
		StopMusic()
		PlayMusic([[Interface\AddOns\SVUI\assets\sounds\SuperVillain.mp3]])
		musicIsPlaying = true
	end
end

local function InstallComplete()
	SVUI_Profile.SAFEDATA.install_version = SuperVillain.version;
	StopMusic()
	SetCVar("Sound_MusicVolume",user_music_vol)
	okToResetMOVE = false;
	ReloadUI()
end 

local function InstallMungsChoice()
	mungs = true;
	okToResetMOVE = false;
	initChat(true);
	SuperVillain:SetUserScreen('high');
	SuperVillain:SetColorTheme();
	SuperVillain.db.SAFEDATA.unitstyle = nil;
	SuperVillain:SetUnitframeLayout();
	SuperVillain.db.SAFEDATA.barstyle = nil;
	SuperVillain:SetupBarLayout();
	SuperVillain:SetupAuralayout();
	SVUI_Profile.SAFEDATA.install_version = SuperVillain.version;
	StopMusic()
	SetCVar("Sound_MusicVolume",user_music_vol)
	ReloadUI()
end 

local function ResetAll()
	SVUI_InstallNextButton:Disable()
	SVUI_InstallPrevButton:Disable()
	SVUI_InstallOption01Button:Hide()
	SVUI_InstallOption01Button:SetScript("OnClick",nil)
	SVUI_InstallOption01Button:SetText("")
	SVUI_InstallOption02Button:Hide()
	SVUI_InstallOption02Button:SetScript("OnClick",nil)
	SVUI_InstallOption02Button:SetText("")
	SVUI_InstallOption03Button:Hide()
	SVUI_InstallOption03Button:SetScript("OnClick",nil)
	SVUI_InstallOption03Button:SetText("")
	SVUI_InstallOption1Button:Hide()
	SVUI_InstallOption1Button:SetScript("OnClick",nil)
	SVUI_InstallOption1Button:SetText("")
	SVUI_InstallOption2Button:Hide()
	SVUI_InstallOption2Button:SetScript('OnClick',nil)
	SVUI_InstallOption2Button:SetText('')
	SVUI_InstallOption3Button:Hide()
	SVUI_InstallOption3Button:SetScript('OnClick',nil)
	SVUI_InstallOption3Button:SetText('')
	SVUI_InstallOption4Button:Hide()
	SVUI_InstallOption4Button:SetScript('OnClick',nil)
	SVUI_InstallOption4Button:SetText('')
	SVUI_SetupHolder.SubTitle:SetText("")
	SVUI_SetupHolder.Desc1:SetText("")
	SVUI_SetupHolder.Desc2:SetText("")
	SVUI_SetupHolder.Desc3:SetText("")
	SVUI_SetupHolder:Size(550,400)
end 

local function SetPage(newPage)
	CURRENT_PAGE = newPage;
	ResetAll()
	InstallStatus.text:SetText(CURRENT_PAGE.."  /  "..MAX_PAGE)
	local setupFrame = SVUI_SetupHolder;
	if newPage  ~= MAX_PAGE then  
		SVUI_InstallNextButton:Enable()
		SVUI_InstallNextButton:Show()
	end 
	if newPage  ~= 1 then 
		SVUI_InstallPrevButton:Enable()
		SVUI_InstallPrevButton:Show()
	end 
	--[[
		more useful globalstrings

		CUSTOM 
		SETTINGS 
		DEFAULT 
		DEFAULTS 
		USE 
		UIOPTIONS_MENU 
		LFGWIZARD_TITLE 
		CONTINUE
	]]--

	if newPage == 1 then
		local hasOldConfig = SVUI_Profile.SAFEDATA.install_version
		SVUI_InstallPrevButton:Disable()
		SVUI_InstallPrevButton:Hide()
		okToResetMOVE = true
		setupFrame.SubTitle:SetText(format(L["This is Supervillain UI version %s!"], SuperVillain.version))
		setupFrame.Desc1:SetText(L["Before I can turn you loose, persuing whatever villainy you feel will advance your professional career... I need to ask some questions and turn a few screws first."])
		setupFrame.Desc2:SetText(L["At any time you can get to the config options by typing the command  / sv. For quick changes to frame, bar or color sets, call your henchman by clicking the button on the bottom right of your screen. (Its the one with his stupid face on it)"])
		setupFrame.Desc3:SetText(L["CHOOSE_OR_DIE"])
		SVUI_InstallOption01Button:Show()
		SVUI_InstallOption01Button:SetScript("OnClick", InstallMungsChoice)
		SVUI_InstallOption01Button:SetText(USE.."\n"..DEFAULT.."\n"..SETTINGS)

		SVUI_InstallOption02Button:Show()
		SVUI_InstallOption02Button:SetScript("OnClick", InstallComplete)
		SVUI_InstallOption02Button:SetText("PRETEND YOU\nDID THIS\nALREADY")

		if(hasOldConfig) then
			SVUI_InstallOption03Button:Show()
			SVUI_InstallOption03Button:SetScript("OnClick", InstallComplete)
			SVUI_InstallOption03Button:SetText("Keep\nSaved\n"..SETTINGS)
		end

	elseif newPage == 2 then
		setupFrame.SubTitle:SetText(CHAT)
		setupFrame.Desc1:SetText(L["Whether you want to or not, you will be needing a communicator so other villains can either update you on their doings-of-evil or inform you about the MANY abilities of Chuck Norris"])
		setupFrame.Desc2:SetText(L["The chat windows function the same as standard chat windows, you can right click the tabs and drag them, rename them, slap them around, you know... whatever. Clickity-click to setup your chat windows."])
		setupFrame.Desc3:SetText(L["CHOOSE_OR_DIE"])
		SVUI_InstallOption1Button:Show()
		SVUI_InstallOption1Button:SetScript("OnClick", function()
			initChat(false)
		end)
		SVUI_InstallOption1Button:SetText(CHAT_DEFAULTS)
		
	elseif newPage == 3 then
		local rez = GetCVar("gxResolution")
		setupFrame.SubTitle:SetText(RESOLUTION)
		setupFrame.Desc1:SetText(format(L["Your current resolution is %s, this is considered a %s resolution."], rez, (SuperVillain.ghettoMonitor and LOW or HIGH)))
		if SuperVillain.ghettoMonitor then 
			setupFrame.Desc2:SetText(L["This resolution requires that you change some settings to get everything to fit on your screen."].." "..L["Click the button below to resize your chat frames, unitframes, and reposition your actionbars."].." "..L["You may need to further alter these settings depending how low your resolution is."])
			setupFrame.Desc3:SetText(L["CHOOSE_OR_DIE"])
		else 
			setupFrame.Desc2:SetText(L["This resolution doesn't require that you change settings for the UI to fit on your screen."].." "..L["Click the button below to resize your chat frames, unitframes, and reposition your actionbars."].." "..L["This is completely optional."])
			setupFrame.Desc3:SetText(L["CHOOSE_OR_DIE"])
		end 
		SVUI_InstallOption1Button:Show()
		SVUI_InstallOption1Button:SetScript("OnClick", function()
			SuperVillain:SetUserScreen("high")
			SVUI_SetupHolder.Desc1:SetText(L["|cffFF9F00"..HIGH.." "..RESOLUTION.."!|r"])
			SVUI_SetupHolder.Desc2:SetText(L["So what you think your better than me with your big monitor? HUH?!?!"])
			SVUI_SetupHolder.Desc3:SetText(L["Dont forget whos in charge here! But enjoy the incredible detail."])
		end)
		SVUI_InstallOption1Button:SetText(HIGH)
		SVUI_InstallOption2Button:Show()
		SVUI_InstallOption2Button:SetScript("OnClick", function()
			SuperVillain:SetUserScreen("low")
			SVUI_SetupHolder.Desc1:SetText(L["|cffFF9F00"..LOW" "..RESOLUTION.."|r"])
			SVUI_SetupHolder.Desc2:SetText(L["Why are you playing this on what I would assume is a calculator display?"])
			SVUI_SetupHolder.Desc3:SetText(L["Enjoy the ONE incredible pixel that fits on this screen."])
		end)
		SVUI_InstallOption2Button:SetText(LOW)
		
	elseif newPage == 4 then
		setupFrame.SubTitle:SetText(COLOR.." "..SETTINGS)
		setupFrame.Desc1:SetText(L["Choose a theme layout you wish to use for your initial setup."])
		setupFrame.Desc2:SetText(L["You can always change fonts and colors of any element of Supervillain UI from the in-game configuration."])
		setupFrame.Desc3:SetText(L["CHOOSE_OR_DIE"])
		SVUI_InstallOption1Button:Show()
		SVUI_InstallOption1Button:SetScript("OnClick", function()
			SuperVillain:SetColorTheme("kaboom")
			SVUI_SetupHolder.Desc1:SetText(L["|cffFF9F00KABOOOOM!|r"])
			SVUI_SetupHolder.Desc2:SetText(L["This theme tells the world that you are a villain who can put on a show"]..CONTINUED)
			SVUI_SetupHolder.Desc3:SetText(CONTINUED..L["or better yet, you ARE the show!"])
		end)
		SVUI_InstallOption1Button:SetText(L["Kaboom!"])
		SVUI_InstallOption2Button:Show()
		SVUI_InstallOption2Button:SetScript("OnClick", function()
			SuperVillain:SetColorTheme("dark")
			SVUI_SetupHolder.Desc1:SetText(L["|cffAF30FFThe Darkest Night|r"])
			SVUI_SetupHolder.Desc2:SetText(L["This theme indicates that you have no interest in wasting time"]..CONTINUED)
			SVUI_SetupHolder.Desc3:SetText(CONTINUED..L[" the dying begins NOW!"])
		end)
		SVUI_InstallOption2Button:SetText(L["Darkness"])
		SVUI_InstallOption3Button:Show()
		SVUI_InstallOption3Button:SetScript("OnClick", function()
			SuperVillain:SetColorTheme("classy")
			SVUI_SetupHolder.Desc1:SetText(L["|cffFFFF00"..CLASS_COLORS.."|r"])
			SVUI_SetupHolder.Desc2:SetText(L["This theme is for villains who take pride in their class"]..CONTINUED)
			SVUI_SetupHolder.Desc3:SetText(CONTINUED..L[" villains know how to reprezent!"])
		end)
		SVUI_InstallOption3Button:SetText(L["Class" .. "\n" .. "Colors"])
		SVUI_InstallOption4Button:Show()
		SVUI_InstallOption4Button:SetScript("OnClick", function()
			SuperVillain:SetColorTheme()
			SVUI_SetupHolder.Desc1:SetText(L["|cff00FFFFPlain and Simple|r"])
			SVUI_SetupHolder.Desc2:SetText(L["This theme is for any villain who sticks to their traditions"]..CONTINUED)
			SVUI_SetupHolder.Desc3:SetText(CONTINUED..L["you don't need fancyness to kick some ass!"])
		end)
		SVUI_InstallOption4Button:SetText(L["Vintage"])
		
	elseif newPage == 5 then
		setupFrame.SubTitle:SetText(UNITFRAME_LABEL.." "..SETTINGS)
		setupFrame.Desc1:SetText(L["You can now choose what primary unitframe style you wish to use."])
		setupFrame.Desc2:SetText(L["This will change the layout of your unitframes (ie.. Player, Target, Pet, Party, Raid ...etc)."])
		setupFrame.Desc3:SetText(L["CHOOSE_OR_DIE"])
		SVUI_InstallOption1Button:Show()
		SVUI_InstallOption1Button:SetScript("OnClick", function()
			SuperVillain.db.SAFEDATA.unitstyle = nil;
			SuperVillain:SetUnitframeLayout("super")
			SVUI_SetupHolder.Desc1:SetText(L["|cff00FFFFLets Do This|r"])
			SVUI_SetupHolder.Desc2:SetText(L["This layout is anything but minimal! Using this is like being at a rock concert"]..CONTINUED)
			SVUI_SetupHolder.Desc3:SetText(CONTINUED..L["then annihilating the crowd with frickin lazer beams!"])
		end)
		SVUI_InstallOption1Button:SetText(L["Super"])
		SVUI_InstallOption2Button:Show()
		SVUI_InstallOption2Button:SetScript("OnClick", function()
			SuperVillain.db.SAFEDATA.unitstyle = nil;
			SuperVillain:SetUnitframeLayout("simple")
			SVUI_SetupHolder.Desc1:SetText(L["|cff00FFFFSimply Simple|r"])
			SVUI_SetupHolder.Desc2:SetText(L["This layout is for the villain who just wants to get things done!"]..CONTINUED)
			SVUI_SetupHolder.Desc3:SetText(CONTINUED..L["but he still wants to see your face before he hits you!"])
		end)
		SVUI_InstallOption2Button:SetText(L["Simple"])
		SVUI_InstallOption3Button:Show()
		SVUI_InstallOption3Button:SetScript("OnClick", function()
			SuperVillain.db.SAFEDATA.unitstyle = nil;
			SuperVillain:SetUnitframeLayout("compact")
			SVUI_SetupHolder.Desc1:SetText(L["|cff00FFFFEl Compacto|r"])
			SVUI_SetupHolder.Desc2:SetText(L["Just the necessities so you can see more of the world around you"]..CONTINUED)
			SVUI_SetupHolder.Desc3:SetText(CONTINUED..L["you dont need no fanciness getting in the way of world domination do you?"])
		end)
		SVUI_InstallOption3Button:SetText(L["Compact"])
		
	elseif newPage == 6 then
		setupFrame.SubTitle:SetText(ACTIONBAR_LABEL.." "..SETTINGS)
		setupFrame.Desc1:SetText(L["Choose a layout for your action bars."])
		setupFrame.Desc2:SetText(L["Sometimes you need big buttons, sometimes you don't. Your choice here."])
		setupFrame.Desc3:SetText(L["CHOOSE_OR_DIE"])
		SVUI_InstallOption1Button:Show()
		SVUI_InstallOption1Button:SetScript("OnClick", function()
			SuperVillain.db.SAFEDATA.barstyle = nil;
			SuperVillain:SetupBarLayout("onesmall")
			SVUI_SetupHolder.Desc1:SetText(L["|cff00FFFFLean And Clean|r"])
			SVUI_SetupHolder.Desc2:SetText(L["Lets keep it slim and deadly, not unlike a ninja sword."])
			SVUI_SetupHolder.Desc3:SetText(L["You dont ever even look at your bar hardly, so pick this one!"])
		end)
		SVUI_InstallOption1Button:SetText(L["Small" .. "\n" .. "Row"])
		SVUI_InstallOption2Button:Show()
		SVUI_InstallOption2Button:SetScript("OnClick", function()
			SuperVillain.db.SAFEDATA.barstyle = nil;
			SuperVillain:SetupBarLayout("twosmall")
			SVUI_SetupHolder.Desc1:SetText(L["|cff00FFFFMore For Less|r"])
			SVUI_SetupHolder.Desc2:SetText(L["Granted, you dont REALLY need the buttons due to your hotkey-leetness, you just like watching cooldowns!"])
			SVUI_SetupHolder.Desc3:SetText(L["Sure thing cowboy, your secret is safe with me!"])
		end)
		SVUI_InstallOption2Button:SetText(L["2 Small" .. "\n" .. "Rows"])
		SVUI_InstallOption3Button:Show()
		SVUI_InstallOption3Button:SetScript("OnClick", function()
			SuperVillain.db.SAFEDATA.barstyle = nil;
			SuperVillain:SetupBarLayout("default")
			SVUI_SetupHolder.Desc1:SetText(L["|cff00FFFFWhat Big Buttons You Have|r"])
			SVUI_SetupHolder.Desc2:SetText(L["The better to PEW-PEW you with my dear!"])
			SVUI_SetupHolder.Desc3:SetText(L["When you have little time for mouse accuracy, choose this set!"])
		end)
		SVUI_InstallOption3Button:SetText(L["Big" .. "\n" .. "Row"])
		SVUI_InstallOption4Button:Show()
		SVUI_InstallOption4Button:SetScript("OnClick", function()
			SuperVillain.db.SAFEDATA.barstyle = nil;
			SuperVillain:SetupBarLayout("twobig")
			SVUI_SetupHolder.Desc1:SetText(L["|cff00FFFFThe Double Down|r"])
			SVUI_SetupHolder.Desc2:SetText(L["Lets be honest for a moment. Who doesnt like a huge pair in their face?"])
			SVUI_SetupHolder.Desc3:SetText(L["Double your bars then double their size for maximum button goodness!"])
		end)
		SVUI_InstallOption4Button:SetText(L["2 Big" .. "\n" .. "Rows"])
		
	elseif newPage == 7 then
		setupFrame.SubTitle:SetText(AURAS.." "..SETTINGS)
		setupFrame.Desc1:SetText(L["Select an aura layout. \"Icons\" will display only icons and aurabars won't be used. \"Bars\" will display only aurabars and icons won't be used (duh). \"The Works!\" does just what it says.... icons, bars and awesomeness."])
		setupFrame.Desc2:SetText(L["If you have an aura that you don't want to display simply hold down shift and right click the icon for it to suffer a painful death."])
		setupFrame.Desc3:SetText(L["CHOOSE_OR_DIE"])

		SVUI_InstallOption1Button:Show()
		SVUI_InstallOption1Button:SetScript("OnClick", function()
			SuperVillain:SetupAuralayout()
		end)
		SVUI_InstallOption1Button:SetText(L["Vintage"])

		SVUI_InstallOption2Button:Show()
		SVUI_InstallOption2Button:SetScript("OnClick", function()
			SuperVillain:SetupAuralayout("icons")
		end)
		SVUI_InstallOption2Button:SetText(L["Icons"])

		SVUI_InstallOption3Button:Show()
		SVUI_InstallOption3Button:SetScript("OnClick", function()
			SuperVillain:SetupAuralayout("bars")
		end)
		SVUI_InstallOption3Button:SetText(L["Bars"])

		SVUI_InstallOption4Button:Show()
		SVUI_InstallOption4Button:SetScript("OnClick", function()
			SuperVillain:SetupAuralayout("theworks")
		end)
		SVUI_InstallOption4Button:SetText(L["The" .. "\n" .. "Works!"])
		
	elseif newPage == 8 then
		SVUI_InstallNextButton:Disable()
		SVUI_InstallNextButton:Hide()
		setupFrame.SubTitle:SetText(BASIC_OPTIONS_TOOLTIP..CONTINUED..AUCTION_TIME_LEFT0)
		setupFrame.Desc1:SetText(L["Thats it! All done! Now we just need to hand these choices off to the henchmen so they can get you ready to (..insert evil tasks here..)!"])
		setupFrame.Desc2:SetText(L["Click the button below to reload and get on your way! Good luck villain!"])
		SVUI_InstallOption1Button:Show()
		SVUI_InstallOption1Button:SetScript("OnClick", InstallComplete)
		SVUI_InstallOption1Button:SetText(L["THE_BUTTON_BELOW"])
		SVUI_SetupHolder:Size(550, 350)
	end
end 

local function NextPage()
	if CURRENT_PAGE ~= MAX_PAGE then 
		CURRENT_PAGE = CURRENT_PAGE + 1;
		SetPage(CURRENT_PAGE)
	end
end 

local function PreviousPage()
	if CURRENT_PAGE ~= 1 then 
		CURRENT_PAGE = CURRENT_PAGE - 1;
		SetPage(CURRENT_PAGE)
	end 
end 

function SuperVillain:ResetInstallation()
	mungs = true;
	okToResetMOVE = false;
	initChat(true);
	SuperVillain.db:Reset()
	SuperVillain:SetUserScreen();

	if SuperVillain.db.SAFEDATA.mediastyle then
        SuperVillain:SetColorTheme(SuperVillain.db.SAFEDATA.mediastyle)
    else
    	SuperVillain.db.SAFEDATA.mediastyle = nil;
    	SuperVillain:SetColorTheme()
    end

    if SuperVillain.db.SAFEDATA.unitstyle then 
        SuperVillain:SetUnitframeLayout(SuperVillain.db.SAFEDATA.unitstyle)
    else
    	SuperVillain.db.SAFEDATA.unitstyle = nil;
    	SuperVillain:SetUnitframeLayout()
    end

    if SuperVillain.db.SAFEDATA.barstyle then 
        SuperVillain:SetupBarLayout(SuperVillain.db.SAFEDATA.barstyle)
    else
    	SuperVillain.db.SAFEDATA.barstyle = nil;
    	SuperVillain:SetupBarLayout()
    end

    if SuperVillain.db.SAFEDATA.aurastyle then 
        SuperVillain:SetupAuralayout(SuperVillain.db.SAFEDATA.aurastyle)
    else
    	SuperVillain.db.SAFEDATA.aurastyle = nil;
    	SuperVillain:SetupAuralayout()
    end

	SVUI_Profile.SAFEDATA.install_version = SuperVillain.version;
	SuperVillain:ResetMovables('')
	ReloadUI()
end 

function SuperVillain:Install(autoLoaded)
	if(not user_music_vol) then
		user_music_vol = GetCVar("Sound_MusicVolume") 
	end
	
	-- frame
	if not SVUI_SetupHolder then 
		local frame = CreateFrame("Button", "SVUI_SetupHolder", UIParent)
		frame.SetPage = SetPage;
		frame:Size(550, 400)
		frame:SetPanelTemplate("Action")
		frame:SetPoint("CENTER")
		frame:SetFrameStrata("TOOLTIP")
		frame.Title = frame:CreateFontString(nil, "OVERLAY")
		frame.Title:SetFont(SuperVillain.Media.font.narrator, 22, "OUTLINE")
		frame.Title:Point("TOP", 0, -5)
		frame.Title:SetText(L["Supervillain UI Installation"])

		frame.Next = CreateFrame("Button", "SVUI_InstallNextButton", frame, "UIPanelButtonTemplate")
		frame.Next:Formula409()
		frame.Next:Size(110, 25)
		frame.Next:Point("BOTTOMRIGHT", 50, 5)
		SetInstallButton(frame.Next)
		frame.Next.texture = frame.Next:CreateTexture(nil, "BORDER")
		frame.Next.texture:Size(110, 75)
		frame.Next.texture:Point("RIGHT")
		frame.Next.texture:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Template\\OPTION-ARROW")
		frame.Next.texture:SetVertexColor(1, 0.5, 0)
		frame.Next.text = frame.Next:CreateFontString(nil, "OVERLAY")
		frame.Next.text:SetFont(SuperVillain.Media.font.action, 18, "OUTLINE")
		frame.Next.text:SetPoint("CENTER")
		frame.Next.text:SetText(CONTINUE)
		frame.Next:Disable()
		frame.Next:SetScript("OnClick", NextPage)
		frame.Next:SetScript("OnEnter", function(this)
			this.texture:SetVertexColor(1, 1, 0)
		end)
		frame.Next:SetScript("OnLeave", function(this)
			this.texture:SetVertexColor(1, 0.5, 0)
		end)

		frame.Prev = CreateFrame("Button", "SVUI_InstallPrevButton", frame, "UIPanelButtonTemplate")
		frame.Prev:Formula409()
		frame.Prev:Size(110, 25)
		frame.Prev:Point("BOTTOMLEFT", -50, 5)
		SetInstallButton(frame.Prev)
		frame.Prev.texture = frame.Prev:CreateTexture(nil, "BORDER")
		frame.Prev.texture:Size(110, 75)
		frame.Prev.texture:Point("LEFT")
		frame.Prev.texture:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Template\\OPTION-ARROW")
		frame.Prev.texture:SetTexCoord(1, 0, 1, 1, 0, 0, 0, 1)
		frame.Prev.texture:SetVertexColor(1, 0.5, 0)
		frame.Prev.text = frame.Prev:CreateFontString(nil, "OVERLAY")
		frame.Prev.text:SetFont(SuperVillain.Media.font.action, 18, "OUTLINE")
		frame.Prev.text:SetPoint("CENTER")
		frame.Prev.text:SetText(PREVIOUS)
		frame.Prev:Disable()
		frame.Prev:SetScript("OnClick", PreviousPage)
		frame.Prev:SetScript("OnEnter", function(this)
			this.texture:SetVertexColor(1, 1, 0)
		end)
		frame.Prev:SetScript("OnLeave", function(this)
			this.texture:SetVertexColor(1, 0.5, 0)
		end)
		frame.Status = CreateFrame("Frame", "InstallStatus", frame)
		frame.Status:SetFrameLevel(frame.Status:GetFrameLevel() + 2)
		frame.Status:Size(150, 30)
		frame.Status:Point("BOTTOM", frame, "TOP", 0, 2)
		frame.Status.text = frame.Status:CreateFontString(nil, "OVERLAY")
		frame.Status.text:SetFont(SuperVillain.Media.font.numbers, 22, "OUTLINE")
		frame.Status.text:SetPoint("CENTER")
		frame.Status.text:SetText(CURRENT_PAGE.."  /  "..MAX_PAGE)

		frame.Option01 = CreateFrame("Button", "SVUI_InstallOption01Button", frame, "UIPanelButtonTemplate")
		frame.Option01:Formula409()
		frame.Option01:Size(160, 30)
		frame.Option01:Point("BOTTOM", 0, 15)
		frame.Option01:SetText("")
		SetInstallButton(frame.Option01)
		frame.Option01.texture = frame.Option01:CreateTexture(nil, "BORDER")
		frame.Option01.texture:Size(160, 160)
		frame.Option01.texture:Point("CENTER", frame.Option01, "BOTTOM", 0, -15)
		frame.Option01.texture:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Template\\OPTION")
		frame.Option01.texture:SetGradient("VERTICAL", 0, 0.3, 0, 0, 0.7, 0)
		frame.Option01:SetScript("OnEnter", function(this)
			this.texture:SetVertexColor(0.5, 1, 0.4)
		end)
		frame.Option01:SetScript("OnLeave", function(this)
			this.texture:SetGradient("VERTICAL", 0, 0.3, 0, 0, 0.7, 0)
		end)
		hooksecurefunc(frame.Option01, "SetWidth", function(g, h)
			g.texture:Size(h, h)
			g.texture:Point("CENTER", g, "BOTTOM", 0, -(h * 0.09))
		end)
		frame.Option01:SetFrameLevel(frame.Option01:GetFrameLevel() + 10)
		frame.Option01:Hide()

		frame.Option02 = CreateFrame("Button", "SVUI_InstallOption02Button", frame, "UIPanelButtonTemplate")
		frame.Option02:Formula409()
		frame.Option02:Size(130, 30)
		frame.Option02:Point("BOTTOMLEFT", frame, "BOTTOM", 4, 15)
		frame.Option02:SetText("")
		SetInstallButton(frame.Option02)
		frame.Option02.texture = frame.Option02:CreateTexture(nil, "BORDER")
		frame.Option02.texture:Size(130, 110)
		frame.Option02.texture:Point("CENTER", frame.Option02, "BOTTOM", 0, -15)
		frame.Option02.texture:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Template\\OPTION")
		frame.Option02.texture:SetGradient("VERTICAL", 0.3, 0, 0, 0.7, 0, 0)
		frame.Option02:SetScript("OnEnter", function(this)
			this.texture:SetVertexColor(0.5, 1, 0.4)
		end)
		frame.Option02:SetScript("OnLeave", function(this)
			this.texture:SetGradient("VERTICAL", 0.3, 0, 0, 0.7, 0, 0)
		end)
		hooksecurefunc(frame.Option02, "SetWidth", function(g, h)
			g.texture:Size(h, h)
			g.texture:Point("CENTER", g, "BOTTOM", 0, -(h * 0.09))
		end)
		frame.Option02:SetScript("OnShow", function()
			frame.Option01:SetWidth(130)
			frame.Option01:ClearAllPoints()
			frame.Option01:Point("BOTTOMRIGHT", frame, "BOTTOM", -4, 15)
		end)
		frame.Option02:SetScript("OnHide", function()
			frame.Option01:SetWidth(160)
			frame.Option01:ClearAllPoints()
			frame.Option01:Point("BOTTOM", 0, 15)
		end)
		frame.Option02:SetFrameLevel(frame.Option01:GetFrameLevel() + 10)
		frame.Option02:Hide()

		frame.Option03 = CreateFrame("Button", "SVUI_InstallOption03Button", frame, "UIPanelButtonTemplate")
		frame.Option03:Formula409()
		frame.Option03:Size(130, 30)
		frame.Option03:Point("BOTTOM", frame, "BOTTOM", 0, 15)
		frame.Option03:SetText("")
		SetInstallButton(frame.Option03)
		frame.Option03.texture = frame.Option03:CreateTexture(nil, "BORDER")
		frame.Option03.texture:Size(130, 110)
		frame.Option03.texture:Point("CENTER", frame.Option03, "BOTTOM", 0, -15)
		frame.Option03.texture:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Template\\OPTION")
		frame.Option03.texture:SetGradient("VERTICAL", 0, 0.1, 0.3, 0, 0.5, 0.7)
		frame.Option03:SetScript("OnEnter", function(this)
			this.texture:SetVertexColor(0.2, 0.5, 1)
		end)
		frame.Option03:SetScript("OnLeave", function(this)
			this.texture:SetGradient("VERTICAL", 0, 0.1, 0.3, 0, 0.5, 0.7)
		end)
		hooksecurefunc(frame.Option03, "SetWidth", function(g, h)
			g.texture:Size(h, h)
			g.texture:Point("CENTER", g, "BOTTOM", 0, -(h * 0.09))
		end)
		frame.Option03:SetScript("OnShow", function(self)
			self:SetWidth(130)
			frame.Option01:SetWidth(130)
			frame.Option01:ClearAllPoints()
			frame.Option01:Point("RIGHT", self, "LEFT", -8, 0)
			frame.Option02:SetWidth(130)
			frame.Option02:ClearAllPoints()
			frame.Option02:Point("LEFT", self, "RIGHT", 8, 0)
		end)
		frame.Option03:SetScript("OnHide", function()
			frame.Option01:SetWidth(160)
			frame.Option01:ClearAllPoints()
			frame.Option01:Point("BOTTOM", 0, 15)
			frame.Option02:ClearAllPoints()
			frame.Option02:Point("BOTTOMLEFT", frame, "BOTTOM", 4, 15)
		end)
		frame.Option03:SetFrameLevel(frame.Option01:GetFrameLevel() + 10)
		frame.Option03:Hide()

		frame.Option1 = CreateFrame("Button", "SVUI_InstallOption1Button", frame, "UIPanelButtonTemplate")
		frame.Option1:Formula409()
		frame.Option1:Size(160, 30)
		frame.Option1:Point("BOTTOM", 0, 15)
		frame.Option1:SetText("")
		SetInstallButton(frame.Option1)
		frame.Option1.texture = frame.Option1:CreateTexture(nil, "BORDER")
		frame.Option1.texture:Size(160, 160)
		frame.Option1.texture:Point("CENTER", frame.Option1, "BOTTOM", 0, -15)
		frame.Option1.texture:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Template\\OPTION")
		frame.Option1.texture:SetGradient("VERTICAL", 0.3, 0.3, 0.3, 0.7, 0.7, 0.7)
		frame.Option1:SetScript("OnEnter", function(this)
			this.texture:SetVertexColor(0.5, 1, 0.4)
		end)
		frame.Option1:SetScript("OnLeave", function(this)
			this.texture:SetGradient("VERTICAL", 0.3, 0.3, 0.3, 0.7, 0.7, 0.7)
		end)
		hooksecurefunc(frame.Option1, "SetWidth", function(g, h)
			g.texture:Size(h, h)
			g.texture:Point("CENTER", g, "BOTTOM", 0, -(h * 0.09))
		end)
		frame.Option1:SetFrameLevel(frame.Option1:GetFrameLevel() + 10)
		frame.Option1:Hide()
		
		frame.Option2 = CreateFrame("Button", "SVUI_InstallOption2Button", frame, "UIPanelButtonTemplate")
		frame.Option2:Formula409()
		frame.Option2:Size(120, 30)
		frame.Option2:Point("BOTTOMLEFT", frame, "BOTTOM", 4, 15)
		frame.Option2:SetText("")
		SetInstallButton(frame.Option2)
		frame.Option2.texture = frame.Option2:CreateTexture(nil, "BORDER")
		frame.Option2.texture:Size(120, 110)
		frame.Option2.texture:Point("CENTER", frame.Option2, "BOTTOM", 0, -15)
		frame.Option2.texture:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Template\\OPTION")
		frame.Option2.texture:SetGradient("VERTICAL", 0.3, 0.3, 0.3, 0.7, 0.7, 0.7)
		frame.Option2:SetScript("OnEnter", function(this)
			this.texture:SetVertexColor(0.5, 1, 0.4)
		end)
		frame.Option2:SetScript("OnLeave", function(this)
			this.texture:SetGradient("VERTICAL", 0.3, 0.3, 0.3, 0.7, 0.7, 0.7)
		end)
		hooksecurefunc(frame.Option2, "SetWidth", function(g, h)
			g.texture:Size(h, h)
			g.texture:Point("CENTER", g, "BOTTOM", 0, -(h * 0.09))
		end)
		frame.Option2:SetScript("OnShow", function()
			frame.Option1:SetWidth(120)
			frame.Option1:ClearAllPoints()
			frame.Option1:Point("BOTTOMRIGHT", frame, "BOTTOM", -4, 15)
		end)
		frame.Option2:SetScript("OnHide", function()
			frame.Option1:SetWidth(160)
			frame.Option1:ClearAllPoints()
			frame.Option1:Point("BOTTOM", 0, 15)
		end)
		frame.Option2:SetFrameLevel(frame.Option1:GetFrameLevel() + 10)
		frame.Option2:Hide()

		frame.Option3 = CreateFrame("Button", "SVUI_InstallOption3Button", frame, "UIPanelButtonTemplate")
		frame.Option3:Formula409()
		frame.Option3:Size(110, 30)
		frame.Option3:Point("LEFT", frame.Option2, "RIGHT", 4, 0)
		frame.Option3:SetText("")
		SetInstallButton(frame.Option3)
		frame.Option3.texture = frame.Option3:CreateTexture(nil, "BORDER")
		frame.Option3.texture:Size(110, 100)
		frame.Option3.texture:Point("CENTER", frame.Option3, "BOTTOM", 0, -9)
		frame.Option3.texture:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Template\\OPTION")
		frame.Option3.texture:SetGradient("VERTICAL", 0.3, 0.3, 0.3, 0.7, 0.7, 0.7)
		frame.Option3:SetScript("OnEnter", function(this)
			this.texture:SetVertexColor(0.5, 1, 0.4)
		end)
		frame.Option3:SetScript("OnLeave", function(this)
			this.texture:SetGradient("VERTICAL", 0.3, 0.3, 0.3, 0.7, 0.7, 0.7)
		end)
		frame.Option3:SetScript("OnShow", function()
			frame.Option1:SetWidth(110)
			frame.Option1:ClearAllPoints()
			frame.Option1:Point("RIGHT", frame.Option2, "LEFT", -4, 0)
			frame.Option2:SetWidth(110)
			frame.Option2:ClearAllPoints()
			frame.Option2:Point("BOTTOM", frame, "BOTTOM", 0, 15)
		end)
		frame.Option3:SetScript("OnHide", function()
			frame.Option1:SetWidth(160)
			frame.Option1:ClearAllPoints()
			frame.Option1:Point("BOTTOM", 0, 15)
			frame.Option2:SetWidth(120)
			frame.Option2:ClearAllPoints()
			frame.Option2:Point("BOTTOMLEFT", frame, "BOTTOM", 4, 15)
		end)
		frame.Option3:SetFrameLevel(frame.Option1:GetFrameLevel() + 10)
		frame.Option3:Hide()

		frame.Option4 = CreateFrame("Button", "SVUI_InstallOption4Button", frame, "UIPanelButtonTemplate")
		frame.Option4:Formula409()
		frame.Option4:Size(110, 30)
		frame.Option4:Point("LEFT", frame.Option3, "RIGHT", 4, 0)
		frame.Option4:SetText("")
		SetInstallButton(frame.Option4)
		frame.Option4.texture = frame.Option4:CreateTexture(nil, "BORDER")
		frame.Option4.texture:Size(110, 100)
		frame.Option4.texture:Point("CENTER", frame.Option4, "BOTTOM", 0, -9)
		frame.Option4.texture:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Template\\OPTION")
		frame.Option4.texture:SetGradient("VERTICAL", 0.3, 0.3, 0.3, 0.7, 0.7, 0.7)
		frame.Option4:SetScript("OnEnter", function(this)
			this.texture:SetVertexColor(0.5, 1, 0.4)
		end)
		frame.Option4:SetScript("OnLeave", function(this)
			this.texture:SetGradient("VERTICAL", 0.3, 0.3, 0.3, 0.7, 0.7, 0.7)
		end)
		frame.Option4:SetScript("OnShow", function()
			frame.Option1:Width(110)
			frame.Option2:Width(110)
			frame.Option1:ClearAllPoints()
			frame.Option1:Point("RIGHT", frame.Option2, "LEFT", -4, 0)
			frame.Option2:ClearAllPoints()
			frame.Option2:Point("BOTTOMRIGHT", frame, "BOTTOM", -4, 15)
		end)
		frame.Option4:SetScript("OnHide", function()
			frame.Option1:SetWidth(160)
			frame.Option1:ClearAllPoints()
			frame.Option1:Point("BOTTOM", 0, 15)
			frame.Option2:SetWidth(120)
			frame.Option2:ClearAllPoints()
			frame.Option2:Point("BOTTOMLEFT", frame, "BOTTOM", 4, 15)
		end)

		frame.Option4:SetFrameLevel(frame.Option1:GetFrameLevel() + 10)
		frame.Option4:Hide()

		frame.SubTitle = frame:CreateFontString(nil, "OVERLAY")
		frame.SubTitle:SetFont(SuperVillain.Media.font.roboto, 16, "OUTLINE")
		frame.SubTitle:Point("TOP", 0, -40)
		frame.Desc1 = frame:CreateFontString(nil, "OVERLAY")
		frame.Desc1:SetFont(SuperVillain.Media.font.roboto, 14, "OUTLINE")
		frame.Desc1:Point("TOPLEFT", 20, -75)
		frame.Desc1:Width(frame:GetWidth()-40)
		frame.Desc2 = frame:CreateFontString(nil, "OVERLAY")
		frame.Desc2:SetFont(SuperVillain.Media.font.roboto, 14, "OUTLINE")
		frame.Desc2:Point("TOPLEFT", 20, -125)
		frame.Desc2:Width(frame:GetWidth()-40)
		frame.Desc3 = frame:CreateFontString(nil, "OVERLAY")
		frame.Desc3:SetFont(SuperVillain.Media.font.roboto, 14, "OUTLINE")
		frame.Desc3:Point("TOPLEFT", 20, -175)
		frame.Desc3:Width(frame:GetWidth()-40)
		local closeButton = CreateFrame("Button", "SVUI_InstallCloseButton", frame, "UIPanelCloseButton")
		closeButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT")
		closeButton:SetScript("OnClick", function()frame:Hide()end)
		frame.tutorialImage = frame:CreateTexture("InstallTutorialImage", "OVERLAY")
		frame.tutorialImage:Size(256, 128)
		frame.tutorialImage:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\SPLASH")
		frame.tutorialImage:Point("BOTTOM", 0, 70)
	end 

	SVUI_SetupHolder:SetScript("OnHide", function()
		StopMusic()
		SetCVar("Sound_MusicVolume", user_music_vol)
		musicIsPlaying = nil
	end)
	
	SVUI_SetupHolder:Show()
	NextPage()
	if(not autoLoaded) then
		PlayThemeSong()
	else
		SuperVillain:ExecuteTimer(PlayThemeSong, 5)
	end
end 