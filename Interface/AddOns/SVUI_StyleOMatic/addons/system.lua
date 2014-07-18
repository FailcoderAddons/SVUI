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
--]]
local SuperVillain, L = unpack(SVUI);
local MOD = SuperVillain.Registry:Expose('SVStyle');
local ceil = math.ceil
--[[ 
########################################################## 
MASSIVE LIST OF LISTS
##########################################################
]]--
local SystemPopList = {
	"StaticPopup1",
	"StaticPopup2",
	"StaticPopup3"
};
local SystemFrameList1 = {
	"GameMenuFrame",
	"TicketStatusFrameButton",
	"DropDownList1MenuBackdrop",
	"DropDownList2MenuBackdrop",
	"DropDownList1Backdrop",
	"DropDownList2Backdrop",
	"AutoCompleteBox",
	"ConsolidatedBuffsTooltip",
	"ReadyCheckFrame",
	"StackSplitFrame",
	"QueueStatusFrame",
};
local SystemFrameList2 = {
	"InterfaceOptionsFrame",
	"VideoOptionsFrame",
	"AudioOptionsFrame",
};
local SystemFrameList3 = {
	"ChatMenu",
	"EmoteMenu",
	"LanguageMenu",
	"VoiceMacroMenu",		
};
local SystemFrameList4 = {
	"Options",
	"Store",
	"SoundOptions", 
	"UIOptions", 
	"Keybindings", 
	"Macros",
	"Ratings",
	"AddOns", 
	"Logout", 
	"Quit", 
	"Continue", 
	"MacOptions",
	"Help"
};
local SystemFrameList5 = {
	"GameMenuFrame", 
	"InterfaceOptionsFrame", 
	"AudioOptionsFrame", 
	"VideoOptionsFrame",
};
local SystemFrameList6 = {
	"VideoOptionsFrameOkay", 
	"VideoOptionsFrameCancel", 
	"VideoOptionsFrameDefaults", 
	"VideoOptionsFrameApply", 
	"AudioOptionsFrameOkay", 
	"AudioOptionsFrameCancel", 
	"AudioOptionsFrameDefaults", 
	"InterfaceOptionsFrameDefaults", 
	"InterfaceOptionsFrameOkay", 
	"InterfaceOptionsFrameCancel",
	"ReadyCheckFrameYesButton",
	"ReadyCheckFrameNoButton",
	"StackSplitOkayButton",
	"StackSplitCancelButton",
	"RolePollPopupAcceptButton"
};
local SystemFrameList7 = {
	"ChatConfigFrame",
	"ChatConfigBackgroundFrame",
	"ChatConfigCategoryFrame",
	"ChatConfigChatSettingsClassColorLegend",
	"ChatConfigChatSettingsLeft",
	"ChatConfigChannelSettingsLeft",
	"ChatConfigChannelSettingsClassColorLegend",
	"ChatConfigOtherSettingsCombat",
	"ChatConfigOtherSettingsPVP",
	"ChatConfigOtherSettingsSystem",
	"ChatConfigOtherSettingsCreature",
	"ChatConfigCombatSettingsFilters",
	"CombatConfigMessageSourcesDoneBy",
	"CombatConfigMessageSourcesDoneTo",
	"CombatConfigColorsUnitColors",
	"CombatConfigColorsHighlighting",
	"CombatConfigColorsColorizeUnitName",
	"CombatConfigColorsColorizeSpellNames",
	"CombatConfigColorsColorizeDamageNumber",
	"CombatConfigColorsColorizeDamageSchool",
	"CombatConfigColorsColorizeEntireLine",
};
local SystemFrameList8 = {
	"ChatConfigFrameDefaultButton",
	"ChatConfigFrameOkayButton",
	"CombatLogDefaultButton",
	"ChatConfigCombatSettingsFiltersCopyFilterButton",
	"ChatConfigCombatSettingsFiltersAddFilterButton",
	"ChatConfigCombatSettingsFiltersDeleteButton",
	"CombatConfigSettingsSaveButton",
	"ChatConfigFrameCancelButton",
};
local SystemFrameList9 = {
	"ChatConfigCategoryFrame",
	"ChatConfigBackgroundFrame",
	"ChatConfigChatSettingsClassColorLegend",
	"ChatConfigChannelSettingsClassColorLegend",
	"ChatConfigCombatSettingsFilters",
	"ChatConfigCombatSettingsFiltersScrollFrame",
	"CombatConfigColorsHighlighting",
	"CombatConfigColorsColorizeUnitName",
	"CombatConfigColorsColorizeSpellNames",
	"CombatConfigColorsColorizeDamageNumber",
	"CombatConfigColorsColorizeDamageSchool",
	"CombatConfigColorsColorizeEntireLine",
	"ChatConfigChatSettingsLeft",
	"ChatConfigOtherSettingsCombat",
	"ChatConfigOtherSettingsPVP",
	"ChatConfigOtherSettingsSystem",
	"ChatConfigOtherSettingsCreature",
	"ChatConfigChannelSettingsLeft",
	"CombatConfigMessageSourcesDoneBy",
	"CombatConfigMessageSourcesDoneTo",
	"CombatConfigColorsUnitColors",
};
local SystemFrameList10 = {
	"CombatConfigColorsColorizeSpellNames",
	"CombatConfigColorsColorizeDamageNumber",
	"CombatConfigColorsColorizeDamageSchool",
	"CombatConfigColorsColorizeEntireLine",
};
local SystemFrameList11 = {
	"ChatConfigFrameOkayButton",
	"ChatConfigFrameDefaultButton",
	"CombatLogDefaultButton",
	"ChatConfigCombatSettingsFiltersDeleteButton",
	"ChatConfigCombatSettingsFiltersAddFilterButton",
	"ChatConfigCombatSettingsFiltersCopyFilterButton",
	"CombatConfigSettingsSaveButton",
};
local SystemFrameList12 = {
	"CombatConfigColorsHighlightingLine",
	"CombatConfigColorsHighlightingAbility",
	"CombatConfigColorsHighlightingDamage",
	"CombatConfigColorsHighlightingSchool",
	"CombatConfigColorsColorizeUnitNameCheck",
	"CombatConfigColorsColorizeSpellNamesCheck",
	"CombatConfigColorsColorizeSpellNamesSchoolColoring",
	"CombatConfigColorsColorizeDamageNumberCheck",
	"CombatConfigColorsColorizeDamageNumberSchoolColoring",
	"CombatConfigColorsColorizeDamageSchoolCheck",
	"CombatConfigColorsColorizeEntireLineCheck",
	"CombatConfigFormattingShowTimeStamp",
	"CombatConfigFormattingShowBraces",
	"CombatConfigFormattingUnitNames",
	"CombatConfigFormattingSpellNames",
	"CombatConfigFormattingItemNames",
	"CombatConfigFormattingFullText",
	"CombatConfigSettingsShowQuickButton",
	"CombatConfigSettingsSolo",
	"CombatConfigSettingsParty",
	"CombatConfigSettingsRaid",
};
local SystemFrameList13 = {
	"VideoOptionsFrameCategoryFrame",
	"VideoOptionsFramePanelContainer",
	"InterfaceOptionsFrameCategories",
	"InterfaceOptionsFramePanelContainer",
	"InterfaceOptionsFrameAddOns",
	"AudioOptionsSoundPanelPlayback",
	"AudioOptionsSoundPanelVolume",
	"AudioOptionsSoundPanelHardware",
	"AudioOptionsVoicePanelTalking",
	"AudioOptionsVoicePanelBinding",
	"AudioOptionsVoicePanelListening",
};
local SystemFrameList14 = {
	"InterfaceOptionsFrameTab1",
	"InterfaceOptionsFrameTab2",
};
local SystemFrameList15 = {
	"ControlsPanelBlockChatChannelInvites",
	"ControlsPanelStickyTargeting",
	"ControlsPanelAutoDismount",
	"ControlsPanelAutoClearAFK",
	"ControlsPanelBlockTrades",
	"ControlsPanelBlockGuildInvites",
	"ControlsPanelLootAtMouse",
	"ControlsPanelAutoLootCorpse",
	"ControlsPanelInteractOnLeftClick",
	"ControlsPanelAutoOpenLootHistory",
	"CombatPanelEnemyCastBarsOnOnlyTargetNameplates",
	"CombatPanelEnemyCastBarsNameplateSpellNames",
	"CombatPanelAttackOnAssist",
	"CombatPanelStopAutoAttack",
	"CombatPanelNameplateClassColors",
	"CombatPanelTargetOfTarget",
	"CombatPanelShowSpellAlerts",
	"CombatPanelReducedLagTolerance",
	"CombatPanelActionButtonUseKeyDown",
	"CombatPanelEnemyCastBarsOnPortrait",
	"CombatPanelEnemyCastBarsOnNameplates",
	"CombatPanelAutoSelfCast",
	"CombatPanelLossOfControl",
	"DisplayPanelShowCloak",
	"DisplayPanelShowHelm",
	"DisplayPanelShowAggroPercentage",
	"DisplayPanelPlayAggroSounds",
	"DisplayPanelDetailedLootInfo",
	"DisplayPanelShowSpellPointsAvg",
	"DisplayPanelemphasizeMySpellEffects",
	"DisplayPanelShowFreeBagSpace",
	"DisplayPanelCinematicSubtitles",
	"DisplayPanelRotateMinimap",
	"DisplayPanelScreenEdgeFlash",
	"DisplayPanelShowAccountAchievments",
	"ObjectivesPanelAutoQuestTracking",
	"ObjectivesPanelAutoQuestProgress",
	"ObjectivesPanelMapQuestDifficulty",
	"ObjectivesPanelAdvancedWorldMap",
	"ObjectivesPanelWatchFrameWidth",
	"SocialPanelProfanityFilter",
	"SocialPanelSpamFilter",
	"SocialPanelChatBubbles",
	"SocialPanelPartyChat",
	"SocialPanelChatHoverDelay",
	"SocialPanelGuildMemberAlert",
	"SocialPanelChatMouseScroll",
	"ActionBarsPanelLockActionBars",
	"ActionBarsPanelSecureAbilityToggle",
	"ActionBarsPanelAlwaysShowActionBars",
	"ActionBarsPanelBottomLeft",
	"ActionBarsPanelBottomRight",
	"ActionBarsPanelRight",
	"ActionBarsPanelRightTwo",
	"NamesPanelMyName",
	"NamesPanelFriendlyPlayerNames",
	"NamesPanelFriendlyPets",
	"NamesPanelFriendlyGuardians",
	"NamesPanelFriendlyTotems",
	"NamesPanelUnitNameplatesFriends",
	"NamesPanelUnitNameplatesFriendlyGuardians",
	"NamesPanelUnitNameplatesFriendlyPets",
	"NamesPanelUnitNameplatesFriendlyTotems",
	"NamesPanelGuilds",
	"NamesPanelGuildTitles",
	"NamesPanelTitles",
	"NamesPanelNonCombatCreature",
	"NamesPanelEnemyPlayerNames",
	"NamesPanelEnemyPets",
	"NamesPanelEnemyGuardians",
	"NamesPanelEnemyTotems",
	"NamesPanelUnitNameplatesEnemyPets",
	"NamesPanelUnitNameplatesEnemies",
	"NamesPanelUnitNameplatesEnemyGuardians",
	"NamesPanelUnitNameplatesEnemyTotems",
	"CombatTextPanelTargetDamage",
	"CombatTextPanelPeriodicDamage",
	"CombatTextPanelPetDamage",
	"CombatTextPanelHealing",
	"CombatTextPanelHealingAbsorbTarget",
	"CombatTextPanelHealingAbsorbSelf",
	"CombatTextPanelTargetEffects",
	"CombatTextPanelOtherTargetEffects",
	"CombatTextPanelEnableFCT",
	"CombatTextPanelDodgeParryMiss",
	"CombatTextPanelDamageReduction",
	"CombatTextPanelRepChanges",
	"CombatTextPanelReactiveAbilities",
	"CombatTextPanelFriendlyHealerNames",
	"CombatTextPanelCombatState",
	"CombatTextPanelComboPoints",
	"CombatTextPanelLowManaHealth",
	"CombatTextPanelEnergyGains",
	"CombatTextPanelPeriodicEnergyGains",
	"CombatTextPanelHonorGains",
	"CombatTextPanelAuras",
	"BuffsPanelBuffDurations",
	"BuffsPanelDispellableDebuffs",
	"BuffsPanelCastableBuffs",
	"BuffsPanelConsolidateBuffs",
	"BuffsPanelShowAllEnemyDebuffs",
	"CameraPanelFollowTerrain",
	"CameraPanelHeadBob",
	"CameraPanelWaterCollision",
	"CameraPanelSmartPivot",
	"MousePanelInvertMouse",
	"MousePanelClickToMove",
	"MousePanelWoWMouse",
	"HelpPanelShowTutorials",
	"HelpPanelLoadingScreenTips",
	"HelpPanelEnhancedTooltips",
	"HelpPanelBeginnerTooltips",
	"HelpPanelShowLuaErrors",
	"HelpPanelColorblindMode",
	"HelpPanelMovePad",
	"BattlenetPanelOnlineFriends",
	"BattlenetPanelOfflineFriends",
	"BattlenetPanelBroadcasts",
	"BattlenetPanelFriendRequests",
	"BattlenetPanelConversations",
	"BattlenetPanelShowToastWindow",
	"StatusTextPanelPlayer",
	"StatusTextPanelPet",
	"StatusTextPanelParty",
	"StatusTextPanelTarget",
	"StatusTextPanelAlternateResource",
	"StatusTextPanelPercentages",
	"StatusTextPanelXP",
	"UnitFramePanelPartyBackground",
	"UnitFramePanelPartyPets",
	"UnitFramePanelArenaEnemyFrames",
	"UnitFramePanelArenaEnemyCastBar",
	"UnitFramePanelArenaEnemyPets",
	"UnitFramePanelFullSizeFocusFrame",
	"NamesPanelUnitNameplatesNameplateClassColors",
};
local SystemFrameList16 ={
	"ControlsPanelAutoLootKeyDropDown",
	"CombatPanelTOTDropDown",
	"CombatPanelFocusCastKeyDropDown",
	"CombatPanelSelfCastKeyDropDown",
	"CombatPanelLossOfControlFullDropDown",
	"CombatPanelLossOfControlSilenceDropDown",
	"CombatPanelLossOfControlInterruptDropDown",
	"CombatPanelLossOfControlDisarmDropDown",
	"CombatPanelLossOfControlRootDropDown",
	"DisplayPanelAggroWarningDisplay",
	"DisplayPanelWorldPVPObjectiveDisplay",
	"SocialPanelChatStyle",
	"SocialPanelWhisperMode",
	"SocialPanelTimestamps",
	"SocialPanelBnWhisperMode",
	"SocialPanelConversationMode",
	"ActionBarsPanelPickupActionKeyDropDown",
	"NamesPanelNPCNamesDropDown",
	"NamesPanelUnitNameplatesMotionDropDown",
	"CombatTextPanelFCTDropDown",
	"CameraPanelStyleDropDown",
	"MousePanelClickMoveStyleDropDown",
	"LanguagesPanelLocaleDropDown",
	"StatusTextPanelDisplayDropDown"
};
local SystemFrameList17 = {
	"Advanced_MaxFPSCheckBox",
	"Advanced_MaxFPSBKCheckBox",
	"Advanced_UseUIScale",
	"AudioOptionsSoundPanelEnableSound",
	"AudioOptionsSoundPanelSoundEffects",
	"AudioOptionsSoundPanelErrorSpeech",
	"AudioOptionsSoundPanelEmoteSounds",
	"AudioOptionsSoundPanelPetSounds",
	"AudioOptionsSoundPanelMusic",
	"AudioOptionsSoundPanelLoopMusic",
	"AudioOptionsSoundPanelAmbientSounds",
	"AudioOptionsSoundPanelSoundInBG",
	"AudioOptionsSoundPanelReverb",
	"AudioOptionsSoundPanelHRTF",
	"AudioOptionsSoundPanelEnableDSPs",
	"AudioOptionsSoundPanelUseHardware",
	"AudioOptionsVoicePanelEnableVoice",
	"AudioOptionsVoicePanelEnableMicrophone",
	"AudioOptionsVoicePanelPushToTalkSound",
	"AudioOptionsSoundPanelPetBattleMusic",
	"NetworkOptionsPanelOptimizeSpeed",
	"NetworkOptionsPanelUseIPv6",
};
local SystemFrameList18 = {
	"Graphics_DisplayModeDropDown",
	"Graphics_ResolutionDropDown",
	"Graphics_RefreshDropDown",
	"Graphics_PrimaryMonitorDropDown",
	"Graphics_MultiSampleDropDown",
	"Graphics_VerticalSyncDropDown",
	"Graphics_TextureResolutionDropDown",
	"Graphics_FilteringDropDown",
	"Graphics_ProjectedTexturesDropDown",
	"Graphics_ViewDistanceDropDown",
	"Graphics_EnvironmentalDetailDropDown",
	"Graphics_GroundClutterDropDown",
	"Graphics_ShadowsDropDown",
	"Graphics_LiquidDetailDropDown",
	"Graphics_SunshaftsDropDown",
	"Graphics_ParticleDensityDropDown",
	"Graphics_SSAODropDown",
	"Advanced_BufferingDropDown",
	"Advanced_LagDropDown",
	"Advanced_HardwareCursorDropDown",
	"Advanced_GraphicsAPIDropDown",
	"AudioOptionsSoundPanelHardwareDropDown",
	"AudioOptionsSoundPanelSoundChannelsDropDown",
	"AudioOptionsVoicePanelInputDeviceDropDown",
	"AudioOptionsVoicePanelChatModeDropDown",
	"AudioOptionsVoicePanelOutputDeviceDropDown",
	"CompactUnitFrameProfilesProfileSelector",
	"CompactUnitFrameProfilesGeneralOptionsFrameHealthTextDropdown",
	"CompactUnitFrameProfilesGeneralOptionsFrameSortByDropdown",
};
local SystemFrameList19 = {
	"RecordLoopbackSoundButton",
	"PlayLoopbackSoundButton",
	"AudioOptionsVoicePanelChatMode1KeyBindingButton",
	"CompactUnitFrameProfilesSaveButton",
	"CompactUnitFrameProfilesDeleteButton",
};
local SystemFrameList20 = {
	"KeepGroupsTogether",
	"DisplayIncomingHeals",
	"DisplayPowerBar",
	"DisplayAggroHighlight",
	"UseClassColors",
	"DisplayPets",
	"DisplayMainTankAndAssist",
	"DisplayBorder",
	"ShowDebuffs",
	"DisplayOnlyDispellableDebuffs",
	"AutoActivate2Players",
	"AutoActivate3Players",
	"AutoActivate5Players",
	"AutoActivate10Players",
	"AutoActivate15Players",
	"AutoActivate25Players",
	"AutoActivate40Players",
	"AutoActivateSpec1",
	"AutoActivateSpec2",
	"AutoActivatePvP",
	"AutoActivatePvE",
};
local SystemFrameList21 = {
	"Graphics_Quality",
	"Advanced_UIScaleSlider",
	"Advanced_MaxFPSSlider",
	"Advanced_MaxFPSBKSlider",
	"AudioOptionsSoundPanelSoundQuality",
	"AudioOptionsSoundPanelMasterVolume",
	"AudioOptionsSoundPanelSoundVolume",
	"AudioOptionsSoundPanelMusicVolume",
	"AudioOptionsSoundPanelAmbienceVolume",
	"AudioOptionsVoicePanelMicrophoneVolume",
	"AudioOptionsVoicePanelSpeakerVolume",
	"AudioOptionsVoicePanelSoundFade",
	"AudioOptionsVoicePanelMusicFade",
	"AudioOptionsVoicePanelAmbienceFade",
	"InterfaceOptionsCombatPanelSpellAlertOpacitySlider",
	"InterfaceOptionsCombatPanelMaxSpellStartRecoveryOffset",
	"InterfaceOptionsBattlenetPanelToastDurationSlider",
	"InterfaceOptionsCameraPanelMaxDistanceSlider",
	"InterfaceOptionsCameraPanelFollowSpeedSlider",
	"InterfaceOptionsMousePanelMouseSensitivitySlider",
	"InterfaceOptionsMousePanelMouseLookSpeedSlider",
	"OpacityFrameSlider",
};
--[[ 
########################################################## 
HELPER FUNCTIONS
##########################################################
]]--
local function forceBackdropColor(self, r, g, b, a)
	if r ~= 0 or g ~= 0 or b ~= 0 or a ~= 0 then
		GhostFrame:SetBackdropColor(0,0,0,0)
		GhostFrame:SetBackdropBorderColor(0,0,0,0)
	end
end;
--[[ 
########################################################## 
SYSTEM WIDGET STYLERS
##########################################################
]]--
local ChatGeneric_OnShow = function(self) if(not self.Panel) then self:SetPanelTemplate("Halftone") end end
local ChatMenu_OnShow = function(self) if(not self.Panel) then self:SetPanelTemplate("Halftone") end self:ClearAllPoints() self:Point("BOTTOMLEFT", ChatFrame1, "TOPLEFT", 0, 30) end

local function SystemPanelQue()
	if SuperVillain.db.SVStyle.blizzard.enable ~= true or SuperVillain.db.SVStyle.blizzard.misc ~= true then return end
	QueueStatusFrame:Formula409()
	for i = 1, #SystemPopList do
		local this = _G[SystemPopList[i]]
		if(this) then
			this:Formula409()
			MOD:ApplyAlertStyle(this)
			this:SetBackdropColor(0.8, 0.2, 0.2)
		end
	end
	for i = 1, #SystemFrameList1 do
		local this = _G[SystemFrameList1[i]]
		if(this) then
			this:Formula409()
			this:SetPanelTemplate("Pattern")
		end
	end
	for i = 1, #SystemFrameList2 do
		local this = _G[SystemFrameList2[i]]
		if(this) then
			this:Formula409()
			this:SetPanelTemplate("Halftone")
		end
	end
	for i = 1, #SystemFrameList3 do
		local name = SystemFrameList3[i]
		local this = _G[name]
		if(this) then
			if(name == "ChatMenu") then
				this:HookScript("OnShow", ChatMenu_OnShow)
			else
				this:HookScript("OnShow", ChatGeneric_OnShow)
			end
		end
	end
	LFDRoleCheckPopup:Formula409()
	LFDRoleCheckPopup:SetFixedPanelTemplate()
	LFDRoleCheckPopupAcceptButton:SetButtonTemplate()
	LFDRoleCheckPopupDeclineButton:SetButtonTemplate()
	LFDRoleCheckPopupRoleButtonTank.checkButton:SetCheckboxTemplate(true)
	LFDRoleCheckPopupRoleButtonDPS.checkButton:SetCheckboxTemplate(true)
	LFDRoleCheckPopupRoleButtonHealer.checkButton:SetCheckboxTemplate(true)
	LFDRoleCheckPopupRoleButtonTank.checkButton:SetFrameLevel(LFDRoleCheckPopupRoleButtonTank.checkButton:GetFrameLevel() + 1)
	LFDRoleCheckPopupRoleButtonDPS.checkButton:SetFrameLevel(LFDRoleCheckPopupRoleButtonDPS.checkButton:GetFrameLevel() + 1)
	LFDRoleCheckPopupRoleButtonHealer.checkButton:SetFrameLevel(LFDRoleCheckPopupRoleButtonHealer.checkButton:GetFrameLevel() + 1)
	for i = 1, 3 do
		for j = 1, 3 do
			_G["StaticPopup"..i.."Button"..j]:SetButtonTemplate()
			_G["StaticPopup"..i.."EditBox"]:SetEditboxTemplate()
			_G["StaticPopup"..i.."MoneyInputFrameGold"]:SetEditboxTemplate()
			_G["StaticPopup"..i.."MoneyInputFrameSilver"]:SetEditboxTemplate()
			_G["StaticPopup"..i.."MoneyInputFrameCopper"]:SetEditboxTemplate()
			_G["StaticPopup"..i.."EditBox"].Panel:Point("TOPLEFT", -2, -4)
			_G["StaticPopup"..i.."EditBox"].Panel:Point("BOTTOMRIGHT", 2, 4)
			_G["StaticPopup"..i.."ItemFrameNameFrame"]:MUNG()
			_G["StaticPopup"..i.."ItemFrame"]:GetNormalTexture():MUNG()
			_G["StaticPopup"..i.."ItemFrame"]:SetFixedPanelTemplate("Default")
			_G["StaticPopup"..i.."ItemFrame"]:SetButtonTemplate()
			_G["StaticPopup"..i.."ItemFrameIconTexture"]:SetTexCoord(0.1,0.9,0.1,0.9 )
			_G["StaticPopup"..i.."ItemFrameIconTexture"]:FillInner()
		end
	end
	for i = 1, #SystemFrameList4 do
		local this = _G["GameMenuButton"..SystemFrameList4[i]]
		if(this) then
			this:SetButtonTemplate()
		end
	end
	if IsAddOnLoaded("OptionHouse") then
		GameMenuButtonOptionHouse:SetButtonTemplate()
	end
	do
		GhostFrame:SetButtonTemplate()
		GhostFrame:SetBackdropColor(0,0,0,0)
		GhostFrame:SetBackdropBorderColor(0,0,0,0)
		hooksecurefunc(GhostFrame, "SetBackdropColor", forceBackdropColor)
		hooksecurefunc(GhostFrame, "SetBackdropBorderColor", forceBackdropColor)
		GhostFrame:ClearAllPoints()
		GhostFrame:SetPoint("TOP", SuperVillain.UIParent, "TOP", 0, -150)
		GhostFrameContentsFrame:SetButtonTemplate()
		GhostFrameContentsFrameIcon:SetTexture(nil)
		local x = CreateFrame("Frame", nil, GhostFrame)
		x:SetFrameStrata("MEDIUM")
		x:SetFixedPanelTemplate("Default")
		x:WrapOuter(GhostFrameContentsFrameIcon)
		local tex = x:CreateTexture(nil, "OVERLAY")
		tex:SetTexture("Interface\\Icons\\spell_holy_guardianspirit")
		tex:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		tex:FillInner()
	end
	for i = 1, #SystemFrameList5 do
		local this = _G[SystemFrameList5[i].."Header"]			
		if(this) then
			this:SetTexture("")
			this:ClearAllPoints()
			if this == _G["GameMenuFrameHeader"] then
				this:SetPoint("TOP", GameMenuFrame, 0, 7)
			else
				this:SetPoint("TOP", SystemFrameList5[i], 0, 0)
			end
		end
	end
	for i = 1, #SystemFrameList6 do
		local this = _G[SystemFrameList6[i]]
		if(this) then
			this:SetButtonTemplate()
		end
	end
	VideoOptionsFrameCancel:ClearAllPoints()
	VideoOptionsFrameCancel:SetPoint("RIGHT",VideoOptionsFrameApply,"LEFT",-4,0)		 
	VideoOptionsFrameOkay:ClearAllPoints()
	VideoOptionsFrameOkay:SetPoint("RIGHT",VideoOptionsFrameCancel,"LEFT",-4,0)	
	AudioOptionsFrameOkay:ClearAllPoints()
	AudioOptionsFrameOkay:SetPoint("RIGHT",AudioOptionsFrameCancel,"LEFT",-4,0)
	InterfaceOptionsFrameOkay:ClearAllPoints()
	InterfaceOptionsFrameOkay:SetPoint("RIGHT",InterfaceOptionsFrameCancel,"LEFT", -4,0)
	ReadyCheckFrameYesButton:SetParent(ReadyCheckFrame)
	ReadyCheckFrameNoButton:SetParent(ReadyCheckFrame) 
	ReadyCheckFrameYesButton:SetPoint("RIGHT", ReadyCheckFrame, "CENTER", -1, 0)
	ReadyCheckFrameNoButton:SetPoint("LEFT", ReadyCheckFrameYesButton, "RIGHT", 3, 0)
	ReadyCheckFrameText:SetParent(ReadyCheckFrame)	
	ReadyCheckFrameText:ClearAllPoints()
	ReadyCheckFrameText:SetPoint("TOP", 0, -12)
	ReadyCheckListenerFrame:SetAlpha(0)
	ReadyCheckFrame:HookScript("OnShow", function(self) if UnitIsUnit("player", self.initiator) then self:Hide() end end)
	StackSplitFrame:GetRegions():Hide()
	RolePollPopup:SetFixedPanelTemplate("Transparent", true)
	InterfaceOptionsFrame:SetClampedToScreen(true)
	InterfaceOptionsFrame:SetMovable(true)
	InterfaceOptionsFrame:EnableMouse(true)
	InterfaceOptionsFrame:RegisterForDrag("LeftButton", "RightButton")
	InterfaceOptionsFrame:SetScript("OnDragStart", function(self) 
		if InCombatLockdown() then return end
		if IsShiftKeyDown() then
			self:StartMoving() 
		end
	end)
	InterfaceOptionsFrame:SetScript("OnDragStop", function(self) 
		self:StopMovingOrSizing()
	end)
	if IsMacClient() then
		MacOptionsFrame:SetFixedPanelTemplate("Default")
		MacOptionsFrameHeader:SetTexture("")
		MacOptionsFrameHeader:ClearAllPoints()
		MacOptionsFrameHeader:SetPoint("TOP", MacOptionsFrame, 0, 0)
		MacOptionsFrameMovieRecording:SetFixedPanelTemplate("Default")
		MacOptionsITunesRemote:SetFixedPanelTemplate("Default")
		MacOptionsFrameCancel:SetButtonTemplate()
		MacOptionsFrameOkay:SetButtonTemplate()
		MacOptionsButtonKeybindings:SetButtonTemplate()
		MacOptionsFrameDefaults:SetButtonTemplate()
		MacOptionsButtonCompress:SetButtonTemplate()
		local tPoint, tRTo, tRP, tX, tY = MacOptionsButtonCompress:GetPoint()
		MacOptionsButtonCompress:SetWidth(136)
		MacOptionsButtonCompress:ClearAllPoints()
		MacOptionsButtonCompress:Point(tPoint, tRTo, tRP, 4, tY)
		MacOptionsFrameCancel:SetWidth(96)
		MacOptionsFrameCancel:SetHeight(22)
		tPoint, tRTo, tRP, tX, tY = MacOptionsFrameCancel:GetPoint()
		MacOptionsFrameCancel:ClearAllPoints()
		MacOptionsFrameCancel:Point(tPoint, tRTo, tRP, -14, tY)
		MacOptionsFrameOkay:ClearAllPoints()
		MacOptionsFrameOkay:SetWidth(96)
		MacOptionsFrameOkay:SetHeight(22)
		MacOptionsFrameOkay:Point("LEFT",MacOptionsFrameCancel, -99,0)
		MacOptionsButtonKeybindings:ClearAllPoints()
		MacOptionsButtonKeybindings:SetWidth(96)
		MacOptionsButtonKeybindings:SetHeight(22)
		MacOptionsButtonKeybindings:Point("LEFT",MacOptionsFrameOkay, -99,0)
		MacOptionsFrameDefaults:SetWidth(96)
		MacOptionsFrameDefaults:SetHeight(22)
	end
	OpacityFrame:Formula409()
	OpacityFrame:SetFixedPanelTemplate("Transparent", true)
	for i = 1, #SystemFrameList7 do
		local this = _G[SystemFrameList7[i]]
		if(this) then
			this:Formula409()
		end
	end
	for i = 1, #SystemFrameList8 do
		local this = _G[SystemFrameList8[i]]
		if(this) then
			this:SetButtonTemplate()
		end
	end	
	ChatConfigFrameOkayButton:Point("RIGHT", ChatConfigFrameCancelButton, "RIGHT", -11, -1)
	ChatConfigCombatSettingsFiltersDeleteButton:Point("TOPRIGHT", ChatConfigCombatSettingsFilters, "BOTTOMRIGHT", 0, -1)
	ChatConfigCombatSettingsFiltersAddFilterButton:Point("RIGHT", ChatConfigCombatSettingsFiltersDeleteButton, "LEFT", -1, 0)
	ChatConfigCombatSettingsFiltersCopyFilterButton:Point("RIGHT", ChatConfigCombatSettingsFiltersAddFilterButton, "LEFT", -1, 0)
	for i=1, 5 do
		local this = _G["CombatConfigTab"..i]
		if(this) then
			this:Formula409()
		end
	end
	CombatConfigSettingsNameEditBox:SetEditboxTemplate()
	ChatConfigFrame:SetPanelTemplate("Pattern", true)
	for i = 1, #SystemFrameList9 do
		local this = _G[SystemFrameList9[i]]
		if(this) then
			this:Formula409()
			this:SetFixedPanelTemplate("Inset", true)
		end
	end
	for i = 1, #SystemFrameList10 do
		local this = _G[SystemFrameList10[i]]
		if(this) then
			this:ClearAllPoints()
			if this == CombatConfigColorsColorizeSpellNames then
				this:Point("TOP",CombatConfigColorsColorizeUnitName,"BOTTOM",0,-2)
			else
				this:Point("TOP",_G[SystemFrameList10[i-1]],"BOTTOM",0,-2)
			end
		end
	end
	ChatConfigChannelSettingsLeft:RegisterEvent("PLAYER_ENTERING_WORLD")
	ChatConfigChannelSettingsLeft:SetScript("OnEvent", function(self, event)
		ChatConfigChannelSettingsLeft:UnregisterEvent("PLAYER_ENTERING_WORLD")
		for i = 1,#ChatConfigChannelSettingsLeft.checkBoxTable do
			_G["ChatConfigChannelSettingsLeftCheckBox"..i]:Formula409()
			_G["ChatConfigChannelSettingsLeftCheckBox"..i]:SetPanelTemplate()
			_G["ChatConfigChannelSettingsLeftCheckBox"..i].Panel:Point("TOPLEFT",3,-1)
			_G["ChatConfigChannelSettingsLeftCheckBox"..i].Panel:Point("BOTTOMRIGHT",-3,1)
			_G["ChatConfigChannelSettingsLeftCheckBox"..i]:SetHeight(ChatConfigOtherSettingsCombatCheckBox1:GetHeight())
			_G["ChatConfigChannelSettingsLeftCheckBox"..i.."Check"]:SetCheckboxTemplate(true)
			_G["ChatConfigChannelSettingsLeftCheckBox"..i.."ColorClasses"]:SetCheckboxTemplate(true)
			_G["ChatConfigChannelSettingsLeftCheckBox"..i.."ColorClasses"]:SetHeight(ChatConfigChatSettingsLeftCheckBox1Check:GetHeight())
		end
	end)
	CreateChatChannelList(self, GetChannelList())
	ChatConfig_CreateCheckboxes(ChatConfigChannelSettingsLeft, CHAT_CONFIG_CHANNEL_LIST, "ChatConfigCheckBoxWithSwatchAndClassColorTemplate", CHANNELS)
	ChatConfig_UpdateCheckboxes(ChatConfigChannelSettingsLeft)
	ChatConfigBackgroundFrame:SetScript("OnShow", function(self)
		for i = 1,#CHAT_CONFIG_CHAT_LEFT do
			_G["ChatConfigChatSettingsLeftCheckBox"..i]:Formula409()
			_G["ChatConfigChatSettingsLeftCheckBox"..i]:SetPanelTemplate()
			_G["ChatConfigChatSettingsLeftCheckBox"..i].Panel:Point("TOPLEFT",3,-1)
			_G["ChatConfigChatSettingsLeftCheckBox"..i].Panel:Point("BOTTOMRIGHT",-3,1)
			_G["ChatConfigChatSettingsLeftCheckBox"..i]:SetHeight(ChatConfigOtherSettingsCombatCheckBox1:GetHeight())
			_G["ChatConfigChatSettingsLeftCheckBox"..i.."Check"]:SetCheckboxTemplate(true)
			_G["ChatConfigChatSettingsLeftCheckBox"..i.."ColorClasses"]:SetCheckboxTemplate(true)
			_G["ChatConfigChatSettingsLeftCheckBox"..i.."ColorClasses"]:SetHeight(ChatConfigChatSettingsLeftCheckBox1Check:GetHeight())
		end
		for i = 1,#CHAT_CONFIG_OTHER_COMBAT do
			_G["ChatConfigOtherSettingsCombatCheckBox"..i]:Formula409()
			_G["ChatConfigOtherSettingsCombatCheckBox"..i]:SetPanelTemplate()
			_G["ChatConfigOtherSettingsCombatCheckBox"..i].Panel:Point("TOPLEFT",3,-1)
			_G["ChatConfigOtherSettingsCombatCheckBox"..i].Panel:Point("BOTTOMRIGHT",-3,1)
			_G["ChatConfigOtherSettingsCombatCheckBox"..i.."Check"]:SetCheckboxTemplate(true)
		end
		for i = 1,#CHAT_CONFIG_OTHER_PVP do
			_G["ChatConfigOtherSettingsPVPCheckBox"..i]:Formula409()
			_G["ChatConfigOtherSettingsPVPCheckBox"..i]:SetPanelTemplate()
			_G["ChatConfigOtherSettingsPVPCheckBox"..i].Panel:Point("TOPLEFT",3,-1)
			_G["ChatConfigOtherSettingsPVPCheckBox"..i].Panel:Point("BOTTOMRIGHT",-3,1)
			_G["ChatConfigOtherSettingsPVPCheckBox"..i.."Check"]:SetCheckboxTemplate(true)
		end
		for i = 1,#CHAT_CONFIG_OTHER_SYSTEM do
			_G["ChatConfigOtherSettingsSystemCheckBox"..i]:Formula409()
			_G["ChatConfigOtherSettingsSystemCheckBox"..i]:SetPanelTemplate()
			_G["ChatConfigOtherSettingsSystemCheckBox"..i].Panel:Point("TOPLEFT",3,-1)
			_G["ChatConfigOtherSettingsSystemCheckBox"..i].Panel:Point("BOTTOMRIGHT",-3,1)
			_G["ChatConfigOtherSettingsSystemCheckBox"..i.."Check"]:SetCheckboxTemplate(true)
		end
		for i = 1,#CHAT_CONFIG_CHAT_CREATURE_LEFT do
			_G["ChatConfigOtherSettingsCreatureCheckBox"..i]:Formula409()
			_G["ChatConfigOtherSettingsCreatureCheckBox"..i]:SetPanelTemplate()
			_G["ChatConfigOtherSettingsCreatureCheckBox"..i].Panel:Point("TOPLEFT",3,-1)
			_G["ChatConfigOtherSettingsCreatureCheckBox"..i].Panel:Point("BOTTOMRIGHT",-3,1)
			_G["ChatConfigOtherSettingsCreatureCheckBox"..i.."Check"]:SetCheckboxTemplate(true)
		end
		for i = 1,#COMBAT_CONFIG_MESSAGESOURCES_BY do
			_G["CombatConfigMessageSourcesDoneByCheckBox"..i]:Formula409()
			_G["CombatConfigMessageSourcesDoneByCheckBox"..i]:SetPanelTemplate()
			_G["CombatConfigMessageSourcesDoneByCheckBox"..i].Panel:Point("TOPLEFT",3,-1)
			_G["CombatConfigMessageSourcesDoneByCheckBox"..i].Panel:Point("BOTTOMRIGHT",-3,1)
			_G["CombatConfigMessageSourcesDoneByCheckBox"..i.."Check"]:SetCheckboxTemplate(true)
		end
		for i = 1,#COMBAT_CONFIG_MESSAGESOURCES_TO do
			_G["CombatConfigMessageSourcesDoneToCheckBox"..i]:Formula409()
			_G["CombatConfigMessageSourcesDoneToCheckBox"..i]:SetPanelTemplate()
			_G["CombatConfigMessageSourcesDoneToCheckBox"..i].Panel:Point("TOPLEFT",3,-1)
			_G["CombatConfigMessageSourcesDoneToCheckBox"..i].Panel:Point("BOTTOMRIGHT",-3,1)
			_G["CombatConfigMessageSourcesDoneToCheckBox"..i.."Check"]:SetCheckboxTemplate(true)
		end
		for i = 1,#COMBAT_CONFIG_UNIT_COLORS do
			_G["CombatConfigColorsUnitColorsSwatch"..i]:Formula409()
			_G["CombatConfigColorsUnitColorsSwatch"..i]:SetPanelTemplate()
			_G["CombatConfigColorsUnitColorsSwatch"..i].Panel:Point("TOPLEFT",3,-1)
			_G["CombatConfigColorsUnitColorsSwatch"..i].Panel:Point("BOTTOMRIGHT",-3,1)
		end
		for i=1,4 do
			for j=1,4 do
				if _G["CombatConfigMessageTypesLeftCheckBox"..i] and _G["CombatConfigMessageTypesLeftCheckBox"..i.."_"..j] then
					_G["CombatConfigMessageTypesLeftCheckBox"..i]:SetCheckboxTemplate(true)
					_G["CombatConfigMessageTypesLeftCheckBox"..i.."_"..j]:SetCheckboxTemplate(true)
				end
			end
			for j=1,10 do
				if _G["CombatConfigMessageTypesRightCheckBox"..i] and _G["CombatConfigMessageTypesRightCheckBox"..i.."_"..j] then
					_G["CombatConfigMessageTypesRightCheckBox"..i]:SetCheckboxTemplate(true)
					_G["CombatConfigMessageTypesRightCheckBox"..i.."_"..j]:SetCheckboxTemplate(true)
				end
			end
			_G["CombatConfigMessageTypesMiscCheckBox"..i]:SetCheckboxTemplate(true)
		end
	end)
	for i = 1,#COMBAT_CONFIG_TABS do
		local this = _G["CombatConfigTab"..i]
		if(this) then
			MOD:ApplyTabStyle(this)
			this:SetHeight(this:GetHeight()-2)
			this:SetWidth(ceil(this:GetWidth()+1.6))
			_G["CombatConfigTab"..i.."Text"]:SetPoint("BOTTOM",0,10)
		end
	end
	CombatConfigTab1:ClearAllPoints()
	CombatConfigTab1:SetPoint("BOTTOMLEFT",ChatConfigBackgroundFrame,"TOPLEFT",6,-2)
	for i = 1, #SystemFrameList11 do
		local this = _G[SystemFrameList11[i]]
		if(this) then
			this:SetButtonTemplate()
		end
	end
	ChatConfigFrameOkayButton:SetPoint("TOPRIGHT",ChatConfigBackgroundFrame,"BOTTOMRIGHT",-3,-5)
	ChatConfigFrameDefaultButton:SetPoint("TOPLEFT",ChatConfigCategoryFrame,"BOTTOMLEFT",1,-5)
	CombatLogDefaultButton:SetPoint("TOPLEFT",ChatConfigCategoryFrame,"BOTTOMLEFT",1,-5)
	ChatConfigCombatSettingsFiltersDeleteButton:SetPoint("TOPRIGHT",ChatConfigCombatSettingsFilters,"BOTTOMRIGHT",-3,-1)
	ChatConfigCombatSettingsFiltersCopyFilterButton:SetPoint("RIGHT",ChatConfigCombatSettingsFiltersDeleteButton,"LEFT",-2,0)
	ChatConfigCombatSettingsFiltersAddFilterButton:SetPoint("RIGHT",ChatConfigCombatSettingsFiltersCopyFilterButton,"LEFT",-2,0)
	for i = 1, #SystemFrameList12 do
		local this = _G[SystemFrameList12[i]]
		if(this) then
			this:SetCheckboxTemplate(true)
		end
	end
	MOD:ApplyPaginationStyle(ChatConfigMoveFilterUpButton,true)
	MOD:ApplyPaginationStyle(ChatConfigMoveFilterDownButton,true)
	ChatConfigMoveFilterUpButton:ClearAllPoints()
	ChatConfigMoveFilterDownButton:ClearAllPoints()
	ChatConfigMoveFilterUpButton:SetPoint("TOPLEFT",ChatConfigCombatSettingsFilters,"BOTTOMLEFT",3,0)
	ChatConfigMoveFilterDownButton:SetPoint("LEFT",ChatConfigMoveFilterUpButton,24,0)
	CombatConfigSettingsNameEditBox:SetEditboxTemplate()
	ChatConfigFrame:Size(680,596)
	ChatConfigFrameHeader:ClearAllPoints()
	ChatConfigFrameHeader:SetPoint("TOP", ChatConfigFrame, 0, -5)
	hooksecurefunc("UIDropDownMenu_InitializeHelper", function(frame)
		for i = 1, UIDROPDOWNMENU_MAXLEVELS do
			_G["DropDownList"..i.."Backdrop"]:SetFixedPanelTemplate("Transparent", true)
			_G["DropDownList"..i.."MenuBackdrop"]:SetFixedPanelTemplate("Transparent", true)
		end
	end)	
	GuildInviteFrame:Formula409()
	GuildInviteFrame:SetFixedPanelTemplate('Transparent')
	GuildInviteFrameLevel:Formula409()
	GuildInviteFrameLevel:ClearAllPoints()
	GuildInviteFrameLevel:Point('TOP', GuildInviteFrame, 'CENTER', -15, -25)
	GuildInviteFrameJoinButton:SetButtonTemplate()
	GuildInviteFrameDeclineButton:SetButtonTemplate()
	GuildInviteFrame:Height(225)
	GuildInviteFrame:HookScript("OnEvent", function()
		GuildInviteFrame:Height(225)
	end)
	GuildInviteFrameWarningText:MUNG()
	BattleTagInviteFrame:Formula409()
	BattleTagInviteFrame:SetFixedPanelTemplate('Transparent')
	BattleTagInviteFrameScrollFrame:SetEditboxTemplate()
	for i=1, BattleTagInviteFrame:GetNumChildren() do
		local child = select(i, BattleTagInviteFrame:GetChildren())
		if child:GetObjectType() == 'Button' then
			child:SetButtonTemplate()
		end
	end
	for i = 1, #SystemFrameList13 do
		local this = _G[SystemFrameList13[i]]
		if(this) then
			this:Formula409()
			this:SetFixedPanelTemplate("Inset")
			if this ~= _G["VideoOptionsFramePanelContainer"] and this ~= _G["InterfaceOptionsFramePanelContainer"] then
				this.Panel:Point("TOPLEFT",-1,0)
				this.Panel:Point("BOTTOMRIGHT",0,1)
			else
				this.Panel:Point("TOPLEFT", 0, 0)
				this.Panel:Point("BOTTOMRIGHT", 0, 0)
			end
		end
	end
	for i = 1, #SystemFrameList14 do
		local this = _G[SystemFrameList14[i]]
		if(this) then
			this:Formula409()
			MOD:ApplyTabStyle(this)
		end
	end
	InterfaceOptionsFrameTab1:ClearAllPoints()
	InterfaceOptionsFrameTab1:SetPoint("BOTTOMLEFT",InterfaceOptionsFrameCategories,"TOPLEFT",-11,-2)
	VideoOptionsFrameDefaults:ClearAllPoints()
	InterfaceOptionsFrameDefaults:ClearAllPoints()
	InterfaceOptionsFrameCancel:ClearAllPoints()
	VideoOptionsFrameDefaults:SetPoint("TOPLEFT",VideoOptionsFrameCategoryFrame,"BOTTOMLEFT",-1,-5)
	InterfaceOptionsFrameDefaults:SetPoint("TOPLEFT",InterfaceOptionsFrameCategories,"BOTTOMLEFT",-1,-5)
	InterfaceOptionsFrameCancel:SetPoint("TOPRIGHT",InterfaceOptionsFramePanelContainer,"BOTTOMRIGHT",0,-6)
	for i = 1, #SystemFrameList15 do
		local this = _G["InterfaceOptions"..SystemFrameList15[i]]
		if(this) then
			this:SetCheckboxTemplate(true)
		end
	end
	for i = 1, #SystemFrameList16 do
		local this = _G["InterfaceOptions"..SystemFrameList16[i]]
		if(this) then
			MOD:ApplyDropdownStyle(this)
			DropDownList1:SetFixedPanelTemplate("Default", true)
		end
	end
	InterfaceOptionsHelpPanelResetTutorials:SetButtonTemplate()
	for i = 1, #SystemFrameList17 do
		local this = _G[SystemFrameList17[i]]
		if(this) then
			this:SetCheckboxTemplate(true)
		end
	end
	for i = 1, #SystemFrameList18 do
		local this = _G[SystemFrameList18[i]]
		if(this) then
			MOD:ApplyDropdownStyle(this,165)
			DropDownList1:SetFixedPanelTemplate("Default", true)
		end
	end
	for i = 1, #SystemFrameList19 do
		local this = _G[SystemFrameList19[i]]
		if(this) then
			this:SetButtonTemplate()
		end
	end
	AudioOptionsVoicePanelChatMode1KeyBindingButton:ClearAllPoints()
	AudioOptionsVoicePanelChatMode1KeyBindingButton:Point("CENTER", AudioOptionsVoicePanelBinding, "CENTER", 0, -10)
	CompactUnitFrameProfilesRaidStylePartyFrames:SetCheckboxTemplate(true)
	CompactUnitFrameProfilesGeneralOptionsFrameResetPositionButton:SetButtonTemplate()
	for i = 1, #SystemFrameList20 do
		local this = _G["CompactUnitFrameProfilesGeneralOptionsFrame"..SystemFrameList20[i]]
		if(this) then
			this:SetCheckboxTemplate(true)
			this:SetFrameLevel(40)
		end
	end	
	Graphics_RightQuality:MUNG()
	for i = 1, #SystemFrameList21 do
		local this = _G[SystemFrameList21[i]]
		if(this) then
			MOD:ApplyScrollbarStyle(this)
		end
	end
	MacOptionsFrame:Formula409()
	MacOptionsFrame:SetFixedPanelTemplate()
	MacOptionsButtonCompress:SetButtonTemplate()
	MacOptionsButtonKeybindings:SetButtonTemplate()
	MacOptionsFrameDefaults:SetButtonTemplate()
	MacOptionsFrameOkay:SetButtonTemplate()
	MacOptionsFrameCancel:SetButtonTemplate()
	MacOptionsFrameMovieRecording:Formula409()
	MacOptionsITunesRemote:Formula409()
	MacOptionsFrameMisc:Formula409()
	MOD:ApplyDropdownStyle(MacOptionsFrameResolutionDropDown)
	MOD:ApplyDropdownStyle(MacOptionsFrameFramerateDropDown)
	MOD:ApplyDropdownStyle(MacOptionsFrameCodecDropDown)
	MOD:ApplyScrollbarStyle(MacOptionsFrameQualitySlider)
	for i = 1, 11 do
		local this = _G["MacOptionsFrameCheckButton"..i]
		if(this) then
			this:SetCheckboxTemplate(true)
		end
	end
	MacOptionsButtonKeybindings:ClearAllPoints()
	MacOptionsButtonKeybindings:SetPoint("LEFT", MacOptionsFrameDefaults, "RIGHT", 2, 0)
	MacOptionsFrameOkay:ClearAllPoints()
	MacOptionsFrameOkay:SetPoint("LEFT", MacOptionsButtonKeybindings, "RIGHT", 2, 0)
	MacOptionsFrameCancel:ClearAllPoints()
	MacOptionsFrameCancel:SetPoint("LEFT", MacOptionsFrameOkay, "RIGHT", 2, 0)
	MacOptionsFrameCancel:SetWidth(MacOptionsFrameCancel:GetWidth() - 6)	
	ReportCheatingDialog:Formula409()
	ReportCheatingDialogCommentFrame:Formula409()
	ReportCheatingDialogReportButton:SetButtonTemplate()
	ReportCheatingDialogCancelButton:SetButtonTemplate()
	ReportCheatingDialog:SetFixedPanelTemplate("Transparent", true)
	ReportCheatingDialogCommentFrameEditBox:SetEditboxTemplate()
	ReportPlayerNameDialog:Formula409()
	ReportPlayerNameDialogCommentFrame:Formula409()
	ReportPlayerNameDialogCommentFrameEditBox:SetEditboxTemplate()
	ReportPlayerNameDialog:SetFixedPanelTemplate("Transparent", true)
	ReportPlayerNameDialogReportButton:SetButtonTemplate()
	ReportPlayerNameDialogCancelButton:SetButtonTemplate()	
	MOD:ApplyCloseButtonStyle(SideDressUpModelCloseButton)
	SideDressUpFrame:Formula409()
	SideDressUpFrame.BGTopLeft:Hide()
	SideDressUpFrame.BGBottomLeft:Hide()
	SideDressUpModelResetButton:SetButtonTemplate()
end
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
MOD:SaveCustomStyle( SystemPanelQue)