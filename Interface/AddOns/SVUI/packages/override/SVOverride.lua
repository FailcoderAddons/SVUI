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
local unpack        = _G.unpack;
local select        = _G.select;
local assert        = _G.assert;
local type          = _G.type;
local error         = _G.error;
local pcall         = _G.pcall;
local print         = _G.print;
local ipairs        = _G.ipairs;
local pairs         = _G.pairs;
local next          = _G.next;
local rawset        = _G.rawset;
local rawget        = _G.rawget;
local tostring      = _G.tostring;
local tonumber      = _G.tonumber;
local tinsert 	= _G.tinsert;
local string 	= _G.string;
local math 		= _G.math;
--[[ STRING METHODS ]]--
local find, format, len, split = string.find, string.format, string.len, string.split;
--[[ MATH METHODS ]]--
local abs, ceil, floor, round, max = math.abs, math.ceil, math.floor, math.round, math.max;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = select(2, ...)
local L = SV.L
local LSM = LibStub("LibSharedMedia-3.0")
local MOD = SV:NewPackage("SVOverride", "Overrides");
MOD.LewtRollz = {};

local MyName = UnitName("player");
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local UIErrorsFrame = UIErrorsFrame;
local interruptMsg = INTERRUPTED.." %s's \124cff71d5ff\124Hspell:%d\124h[%s]\124h\124r!";
local POSITION, ANCHOR_POINT, YOFFSET = "TOP", "BOTTOM", -10
local FORCE_POSITION = false;
local NewHook = hooksecurefunc;
local mirrorYOffset={
	["BREATH"] = 96,
	["EXHAUSTION"] = 119,
	["FEIGNDEATH"] = 142
}
local mirrorTypeColor={
	EXHAUSTION = {1,.9,0},
	BREATH = {0.31,0.45,0.63},
	DEATH = {1,.7,0},
	FEIGNDEATH = {1,.7,0}
}
local RegisteredMirrorBars = {}
local lastQuality,lastID,lastName;
local dead_rollz = {}
local RollTypePresets = {
	[0] = {
		"Interface\\Buttons\\UI-GroupLoot-Pass-Up",
		"",
		"Interface\\Buttons\\UI-GroupLoot-Pass-Down",
		[[0]],
		[[2]]
	},
	[1] = {
		"Interface\\Buttons\\UI-GroupLoot-Dice-Up",
		"Interface\\Buttons\\UI-GroupLoot-Dice-Highlight",
		"Interface\\Buttons\\UI-GroupLoot-Dice-Down",
		[[5]],
		[[-1]]
	},
	[2] = {
		"Interface\\Buttons\\UI-GroupLoot-Coin-Up",
		"Interface\\Buttons\\UI-GroupLoot-Coin-Highlight",
		"Interface\\Buttons\\UI-GroupLoot-Coin-Down",
		[[0]],
		[[-1]]
	},
	[3] = {
		"Interface\\Buttons\\UI-GroupLoot-DE-Up",
		"Interface\\Buttons\\UI-GroupLoot-DE-Highlight",
		"Interface\\Buttons\\UI-GroupLoot-DE-Down",
		[[0]],
		[[-1]]
	}
};
local LootRollType = {[1] = "need", [2] = "greed", [3] = "disenchant", [0] = "pass"};
local LOOT_WIDTH, LOOT_HEIGHT = 328, 28
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
end 

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
	if not SV.db.general.hideErrorFrame then return end
	if event == 'PLAYER_REGEN_DISABLED' then
		UIErrorsFrame:UnregisterEvent('UI_ERROR_MESSAGE')
	else
		UIErrorsFrame:RegisterEvent('UI_ERROR_MESSAGE')
	end
end

local Vehicle_OnSetPoint = function(self,_,parent)
	if(parent == "MinimapCluster" or parent == _G["MinimapCluster"]) then 
		VehicleSeatIndicator:ClearAllPoints()
		if _G.VehicleSeatIndicator_MOVE then
			VehicleSeatIndicator:Point("BOTTOM", VehicleSeatIndicator_MOVE, "BOTTOM", 0, 0)
		else
			VehicleSeatIndicator:Point("TOPLEFT", SV.Dock.TopLeft, "TOPLEFT", 0, 0)
			SV.Mentalo:Add(VehicleSeatIndicator, L["Vehicle Seat Frame"])
		end 
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
			if online and name ~= MyName then
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
--[[ 
########################################################## 
ALERTS
##########################################################
]]--
local _hook_AlertFrame_SetLootAnchors = function(self)
	if MissingLootFrame:IsShown() then
		MissingLootFrame:ClearAllPoints()
		MissingLootFrame:SetPoint(POSITION, self, ANCHOR_POINT)
		if GroupLootContainer:IsShown() then
			GroupLootContainer:ClearAllPoints()
			GroupLootContainer:SetPoint(POSITION, MissingLootFrame, ANCHOR_POINT, 0, YOFFSET)
		end 
	elseif GroupLootContainer:IsShown() or FORCE_POSITION then 
		GroupLootContainer:ClearAllPoints()
		GroupLootContainer:SetPoint(POSITION, self, ANCHOR_POINT)
	end 
end 

local _hook_AlertFrame_SetLootWonAnchors = function(self)
	for i = 1, #LOOT_WON_ALERT_FRAMES do 
		local frame = LOOT_WON_ALERT_FRAMES[i]
		if frame:IsShown() then
			frame:ClearAllPoints()
			frame:SetPoint(POSITION, self, ANCHOR_POINT, 0, YOFFSET)
			self = frame 
		end 
	end 
end 

local _hook_AlertFrame_SetMoneyWonAnchors = function(self)
	for i = 1, #MONEY_WON_ALERT_FRAMES do 
		local frame = MONEY_WON_ALERT_FRAMES[i]
		if frame:IsShown() then
			frame:ClearAllPoints()
			frame:SetPoint(POSITION, self, ANCHOR_POINT, 0, YOFFSET)
			self = frame 
		end 
	end 
end 

local _hook_AlertFrame_SetAchievementAnchors = function(self)
	if AchievementAlertFrame1 then
		for i = 1, MAX_ACHIEVEMENT_ALERTS do 
			local frame = _G["AchievementAlertFrame"..i]
			if frame and frame:IsShown() then
				frame:ClearAllPoints()
				frame:SetPoint(POSITION, self, ANCHOR_POINT, 0, YOFFSET)
				self = frame 
			end 
		end 
	end 
end 

local _hook_AlertFrame_SetCriteriaAnchors = function(self)
	if CriteriaAlertFrame1 then
		for i = 1, MAX_ACHIEVEMENT_ALERTS do 
			local frame = _G["CriteriaAlertFrame"..i]
			if frame and frame:IsShown() then
				frame:ClearAllPoints()
				frame:SetPoint(POSITION, self, ANCHOR_POINT, 0, YOFFSET)
				self = frame 
			end 
		end 
	end 
end 

local _hook_AlertFrame_SetChallengeModeAnchors = function(self)
	local frame = ChallengeModeAlertFrame1;
	if frame:IsShown() then
		frame:ClearAllPoints()
		frame:SetPoint(POSITION, self, ANCHOR_POINT, 0, YOFFSET)
	end 
end 

local _hook_AlertFrame_SetDungeonCompletionAnchors = function(self)
	local frame = DungeonCompletionAlertFrame1;
	if frame:IsShown() then
		frame:ClearAllPoints()
		frame:SetPoint(POSITION, self, ANCHOR_POINT, 0, YOFFSET)
	end 
end 

local _hook_AlertFrame_SetStorePurchaseAnchors = function(self)
	local frame = StorePurchaseAlertFrame;
	if frame:IsShown() then
		frame:ClearAllPoints()
		frame:SetPoint(POSITION, self, ANCHOR_POINT, 0, YOFFSET)
	end 
end 

local _hook_AlertFrame_SetScenarioAnchors = function(self)
	local frame = ScenarioAlertFrame1;
	if frame:IsShown() then
		frame:ClearAllPoints()
		frame:SetPoint(POSITION, self, ANCHOR_POINT, 0, YOFFSET)
	end 
end 

local _hook_AlertFrame_SetGuildChallengeAnchors = function(self)
	local frame = GuildChallengeAlertFrame;
	if frame:IsShown() then
		frame:ClearAllPoints()
		frame:SetPoint(POSITION, self, ANCHOR_POINT, 0, YOFFSET)
	end 
end 

local afrm = CreateFrame("Frame", "SVUI_AlertFrame", UIParent);
afrm:SetWidth(180);
afrm:SetHeight(20);

local AlertFramePostMove_Hook = function(forced)
	local b, c = SVUI_AlertFrame_MOVE:GetCenter()
	local d = SV.Screen:GetTop()
	if(c > (d  /  2)) then
		POSITION = "TOP"
		ANCHOR_POINT = "BOTTOM"
		YOFFSET = -10;
		SVUI_AlertFrame_MOVE:SetText(SVUI_AlertFrame_MOVE.textString.." (Grow Down)")
	else
		POSITION = "BOTTOM"
		ANCHOR_POINT = "TOP"
		YOFFSET = 10;
		SVUI_AlertFrame_MOVE:SetText(SVUI_AlertFrame_MOVE.textString.." (Grow Up)")
	end 
	if SV.db.SVOverride.lootRoll then 
		local f, g;
		for h, i in pairs(MOD.LewtRollz) do
			i:ClearAllPoints()
			if h   ~= 1 then
				if POSITION == "TOP" then 
					i:Point("TOP", f, "BOTTOM", 0, -4)
				else
					i:Point("BOTTOM", f, "TOP", 0, 4)
				end 
			else
				if POSITION == "TOP" then
					i:Point("TOP", SVUI_AlertFrame, "BOTTOM", 0, -4)
				else
					i:Point("BOTTOM", SVUI_AlertFrame, "TOP", 0, 4)
				end 
			end 
			f = i;
			if i:IsShown() then
				g = i 
			end 
		end 
		AlertFrame:ClearAllPoints()
		if g then
			AlertFrame:SetAllPoints(g)
		else
			AlertFrame:SetAllPoints(SVUI_AlertFrame)
		end 
	else
		AlertFrame:ClearAllPoints()
		AlertFrame:SetAllPoints(SVUI_AlertFrame)
	end 
	if forced then
		FORCE_POSITION = true;
		AlertFrame_FixAnchors()
		FORCE_POSITION = false 
	end 
end 
--[[ 
########################################################## 
MIRROR BARS
##########################################################
]]--
local SetMirrorPosition = function(bar)
	local yOffset = mirrorYOffset[bar.type]
	return bar:Point("TOP", SV.Screen, "TOP", 0, -yOffset)
end 

local MirrorBar_OnUpdate = function(self, elapsed)
	if self.paused then
		return 
	end 
	self.lastupdate = (self.lastupdate or 0) + elapsed;
	if self.lastupdate < .1 then
		return 
	end 
	self.lastupdate = 0;
	self:SetValue(GetMirrorTimerProgress(self.type) / 1e3)
end 

local MirrorBar_Start = function(self, min, max, s, t, text)
	if t > 0 then
		self.paused = 1 
	elseif self.paused then 
		self.paused = nil 
	end 
	self.text:SetText(text)
	self:SetMinMaxValues(0, max / 1e3)
	self:SetValue(min / 1e3)
	if not self:IsShown() then
		self:Show()
	end 
end 


local function MirrorBarRegistry(barType)
	if RegisteredMirrorBars[barType] then
		return RegisteredMirrorBars[barType]
	end 
	local bar = CreateFrame('StatusBar', nil, SV.Screen)
	bar:SetPanelTemplate("Bar", false, 3, 3, 3)
	bar:SetScript("OnUpdate", MirrorBar_OnUpdate)
	local r, g, b = unpack(mirrorTypeColor[barType])
	bar.text = bar:CreateFontString(nil, 'OVERLAY')
	bar.text:FontManager(SV.Media.font.roboto, 12, 'OUTLINE')
	bar.text:SetJustifyH('CENTER')
	bar.text:SetTextColor(1, 1, 1)
	bar.text:SetPoint('LEFT', bar)
	bar.text:SetPoint('RIGHT', bar)
	bar.text:Point('TOP', bar, 0, 2)
	bar.text:SetPoint('BOTTOM', bar)
	bar:Size(222, 18)
	bar:SetStatusBarTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
	bar:SetStatusBarColor(r, g, b)
	bar.type = barType;
	bar.Start = MirrorBar_Start;
	-- bar.Stop = nil;
	SetMirrorPosition(bar)
	RegisteredMirrorBars[barType] = bar;
	return bar 
end 

local function SetTimerStyle(bar)
	for i=1, bar:GetNumRegions()do 
		local child = select(i, bar:GetRegions())
		if child:GetObjectType() == "Texture"then
			child:SetTexture(0,0,0,0)
		elseif child:GetObjectType() == "FontString" then 
			child:FontManager(SV.Media.font.roboto, 12, 'OUTLINE')
		end 
	end 
	bar:SetStatusBarTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
	bar:SetStatusBarColor(0.37, 0.92, 0.08)
	bar:SetPanelTemplate("Bar", false, 3, 3, 3)
end 

local MirrorBarToggleHandler = function(_, event, arg, ...)
	if(event == "START_TIMER") then
		for _,timer in pairs(TimerTracker.timerList)do 
			if timer["bar"] and not timer["bar"].styled then
				SetTimerStyle(timer["bar"])
				timer["bar"].styled = true 
			end 
		end 
	elseif(event == "MIRROR_TIMER_START") then
		return MirrorBarRegistry(arg):Start(...)
	elseif(event == "MIRROR_TIMER_STOP") then
		return MirrorBarRegistry(arg):Hide()
	elseif(event == "MIRROR_TIMER_PAUSE") then
		local pausedValue = (arg > 0 and arg or nil);
		for barType,bar in next,RegisteredMirrorBars do 
			bar.paused = pausedValue; 
		end 
	end
end

local MirrorBarUpdateHandler = function(_, event)
	if not GetCVarBool("lockActionBars") and SV.db.SVBar.enable then
		SetCVar("lockActionBars", 1)
	end 
	if(event == "PLAYER_ENTERING_WORLD") then
		for i = 1, MIRRORTIMER_NUMTIMERS do 
			local v, q, r, s, t, u = GetMirrorTimerInfo(i)
			if v ~= "UNKNOWN"then 
				MirrorBarRegistry(v):Start(q, r, s, t, u)
			end 
		end
	end
end
--[[ 
########################################################## 
LOOTING
##########################################################
]]--
local function UpdateLootUpvalues()
	LOOT_WIDTH = SV.db.SVOverride.lootRollWidth
	LOOT_HEIGHT = SV.db.SVOverride.lootRollHeight
end 

local Loot_OnHide = function(self)
	SV:StaticPopup_Hide("CONFIRM_LOOT_DISTRIBUTION");
	CloseLoot()
end

local SVUI_LootFrameHolder = CreateFrame("Frame","SVUI_LootFrameHolder",SV.Screen);
local SVUI_LootFrame = CreateFrame('Button', 'SVUI_LootFrame', SVUI_LootFrameHolder);
SVUI_LootFrameHolder:SetPoint("BOTTOMRIGHT", SVUI_DockTopLeft, "BOTTOMRIGHT", 0, 0);
SVUI_LootFrameHolder:SetWidth(150);
SVUI_LootFrameHolder:SetHeight(22);

SVUI_LootFrame:SetClampedToScreen(true);
SVUI_LootFrame:SetPoint('TOPLEFT');
SVUI_LootFrame:SetSize(256,64);
SVUI_LootFrame:SetFrameStrata("FULLSCREEN_DIALOG");
SVUI_LootFrame:SetToplevel(true);
SVUI_LootFrame.title = SVUI_LootFrame:CreateFontString(nil,'OVERLAY');
SVUI_LootFrame.title:SetPoint('BOTTOMLEFT',SVUI_LootFrame,'TOPLEFT',0,1);
SVUI_LootFrame.slots = {};
SVUI_LootFrame:SetScript("OnHide", Loot_OnHide);

local function HideItemTip()
	GameTooltip:Hide()
end 

local function HideRollTip()
	GameTooltip:Hide()
	ResetCursor()
end 

local function LootRoll_SetTooltip(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetText(self.tiptext)
	if self:IsEnabled() == 0 then
		GameTooltip:AddLine("|cffff3333"..L["Can't Roll"])
	end 
	for r, s in pairs(self.parent.rolls)do 
		if LootRollType[s] == LootRollType[self.rolltype] then
			GameTooltip:AddLine(r, 1, 1, 1)
		end 
	end 
	GameTooltip:Show()
end 

local function LootItem_SetTooltip(self)
	if not self.link then
		return 
	end 
	GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
	GameTooltip:SetHyperlink(self.link)
	if IsShiftKeyDown() then
		GameTooltip_ShowCompareItem()
	end 
	if IsModifiedClick("DRESSUP") then
		ShowInspectCursor()
	else
		ResetCursor()
	end 
end 

local function LootItem_OnUpdate(v)
	if IsShiftKeyDown() then
		GameTooltip_ShowCompareItem()
	end 
	CursorOnUpdate(v)
end 

local function LootRoll_OnClick(self)
	if IsControlKeyDown() then
		DressUpItemLink(self.link)
	elseif IsShiftKeyDown() then 
		ChatEdit_InsertLink(self.link)
	end 
end 

local function LootRoll_OnEvent(self, event, value)
	dead_rollz[value] = true;
	if self.rollID ~= value then
		return 
	end 
	self.rollID = nil;
	self.time = nil;
	self:Hide()
end 

local function LootRoll_OnUpdate(self)
	if not self.parent.rollID then return end 
	local remaining = GetLootRollTimeLeft(self.parent.rollID)
	local mu = remaining / self.parent.time;
	self.spark:Point("CENTER", self, "LEFT", mu * self:GetWidth(), 0)
	self:SetValue(remaining)
	if remaining > 1000000000 then
		self:GetParent():Hide()
	end 
end 

local DoDaRoll = function(self)
	RollOnLoot(self.parent.rollID, self.rolltype)
end 

local LootSlot_OnEnter = function(self)
	local slotID = self:GetID()
	if LootSlotHasItem(slotID) then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetLootItem(slotID)
		CursorUpdate(self)
	end 
	self.drop:Show()
	self.drop:SetVertexColor(1, 1, 0)
end 

local LootSlot_OnLeave = function(self)
	if self.quality and self.quality > 1 then 
		local color = ITEM_QUALITY_COLORS[self.quality]
		self.drop:SetVertexColor(color.r, color.g, color.b)
	else
		self.drop:Hide()
	end 
	GameTooltip:Hide()
	ResetCursor()
end 

local LootSlot_OnClick = function(self)
	LootFrame.selectedQuality = self.quality;
	LootFrame.selectedItemName = self.name:GetText()
	LootFrame.selectedSlot = self:GetID()
	LootFrame.selectedLootButton = self:GetName()
	LootFrame.selectedTexture = self.icon:GetTexture()
	if IsModifiedClick() then
		HandleModifiedItemClick(GetLootSlotLink(self:GetID()))
	else
		StaticPopup_Hide("CONFIRM_LOOT_DISTRIBUTION")
		lastID = self:GetID()
		lastQuality = self.quality;
		lastName = self.name:GetText()
		LootSlot(lastID)
	end 
end 

local LootSlot_OnShow = function(self)
	if GameTooltip:IsOwned(self) then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetLootItem(self:GetID())
		CursorOnUpdate(self)
	end 
end 

local function HandleSlots(frame)
	local scale = 30;
	local counter = 0;
	for i = 1, #frame.slots do 
		local slot = frame.slots[i]
		if slot:IsShown() then
			counter = counter + 1;
			slot:Point("TOP", SVUI_LootFrame, 4, (-8 + scale) - (counter * scale))
		end 
	end 
	frame:Height(max(counter * scale + 16, 20))
end 

local function MakeSlots(id)
	local size = LOOT_HEIGHT;
	local slot = CreateFrame("Button", "SVUI_LootSlot"..id, SVUI_LootFrame)
	slot:Point("LEFT", 8, 0)
	slot:Point("RIGHT", -8, 0)
	slot:Height(size)
	slot:SetID(id)
	slot:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	slot:SetScript("OnEnter", LootSlot_OnEnter)
	slot:SetScript("OnLeave", LootSlot_OnLeave)
	slot:SetScript("OnClick", LootSlot_OnClick)
	slot:SetScript("OnShow", LootSlot_OnShow)

	slot.iconFrame = CreateFrame("Frame", nil, slot)
	slot.iconFrame:Height(size)
	slot.iconFrame:Width(size)
	slot.iconFrame:SetPoint("RIGHT", slot)
	slot.iconFrame:SetPanelTemplate("Transparent")

	slot.icon = slot.iconFrame:CreateTexture(nil, "ARTWORK")
	slot.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	slot.icon:FillInner()

	slot.count = slot.iconFrame:CreateFontString(nil, "OVERLAY")
	slot.count:SetJustifyH("RIGHT")
	slot.count:Point("BOTTOMRIGHT", slot.iconFrame, -2, 2)
	slot.count:SetFont(LSM:Fetch("font", "Roboto"), 12, "OUTLINE")
	slot.count:SetText(1)

	slot.name = slot:CreateFontString(nil, "OVERLAY")
	slot.name:SetJustifyH("LEFT")
	slot.name:SetPoint("LEFT", slot)
	slot.name:SetPoint("RIGHT", slot.icon, "LEFT")
	slot.name:SetNonSpaceWrap(true)
	slot.name:SetFont(LSM:Fetch("font", "Roboto"), 12, "OUTLINE")

	slot.drop = slot:CreateTexture(nil, "ARTWORK")
	slot.drop:SetTexture("Interface\\QuestFrame\\UI-QuestLogTitleHighlight")
	slot.drop:SetPoint("LEFT", slot.icon, "RIGHT", 0, 0)
	slot.drop:SetPoint("RIGHT", slot)
	slot.drop:SetAllPoints(slot)
	slot.drop:SetAlpha(.3)

	slot.questTexture = slot.iconFrame:CreateTexture(nil, "OVERLAY")
	slot.questTexture:FillInner()
	slot.questTexture:SetTexture(TEXTURE_ITEM_QUEST_BANG)
	slot.questTexture:SetTexCoord(0.1, 0.9, 0.1, 0.9)

	SVUI_LootFrame.slots[id] = slot;
	return slot 
end 

local function CreateRollButton(rollFrame, type, locale, anchor)
	local preset = RollTypePresets[type];
	local rollButton = CreateFrame("Button", nil, rollFrame)
	rollButton:Point("LEFT", anchor, "RIGHT", tonumber(preset[4]), tonumber(preset[5]))
	rollButton:Size(LOOT_HEIGHT - 4)
	rollButton:SetNormalTexture(preset[1])
	if preset[2] and preset[2] ~= "" then
		rollButton:SetPushedTexture(preset[2])
	end 
	rollButton:SetHighlightTexture(preset[3])
	rollButton.rolltype = type;
	rollButton.parent = rollFrame;
	rollButton.tiptext = locale;
	rollButton:SetScript("OnEnter", LootRoll_SetTooltip)
	rollButton:SetScript("OnLeave", HideItemTip)
	rollButton:SetScript("OnClick", DoDaRoll)
	rollButton:SetMotionScriptsWhileDisabled(true)
	local text = rollButton:CreateFontString(nil, nil)
	text:SetFont(LSM:Fetch("font", "Roboto"),14,"OUTLINE")
	text:Point("CENTER", 0, ((type == 2 and 1) or (type == 0 and -1.2) or 0))
	return rollButton, text 
end 

local function CreateRollFrame()
	UpdateLootUpvalues()
	local rollFrame = CreateFrame("Frame",nil,SV.Screen)
	rollFrame:Size(LOOT_WIDTH,LOOT_HEIGHT)
	rollFrame:SetFixedPanelTemplate('Default')
	rollFrame:SetScript("OnEvent",LootRoll_OnEvent)
	rollFrame:RegisterEvent("CANCEL_LOOT_ROLL")
	rollFrame:Hide()
	rollFrame.button = CreateFrame("Button",nil,rollFrame)
	rollFrame.button:Point("RIGHT",rollFrame,'LEFT',0,0)
	rollFrame.button:Size(LOOT_HEIGHT - 2)
	rollFrame.button:SetPanelTemplate('Default')
	rollFrame.button:SetScript("OnEnter",LootItem_SetTooltip)
	rollFrame.button:SetScript("OnLeave",HideRollTip)
	rollFrame.button:SetScript("OnUpdate",LootItem_OnUpdate)
	rollFrame.button:SetScript("OnClick",LootRoll_OnClick)
	rollFrame.button.icon = rollFrame.button:CreateTexture(nil,'OVERLAY')
	rollFrame.button.icon:SetAllPoints()
	rollFrame.button.icon:SetTexCoord(0.1,0.9,0.1,0.9 )
	local border = rollFrame:CreateTexture(nil,"BORDER")
	border:Point("TOPLEFT",rollFrame,"TOPLEFT",4,0)
	border:Point("BOTTOMRIGHT",rollFrame,"BOTTOMRIGHT",-4,0)
	border:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
	border:SetBlendMode("ADD")
	border:SetGradientAlpha("VERTICAL",.1,.1,.1,0,.1,.1,.1,0)
	rollFrame.status=CreateFrame("StatusBar",nil,rollFrame)
	rollFrame.status:FillInner()
	rollFrame.status:SetScript("OnUpdate",LootRoll_OnUpdate)
	rollFrame.status:SetFrameLevel(rollFrame.status:GetFrameLevel() - 1)
	rollFrame.status:SetStatusBarTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
	rollFrame.status:SetStatusBarColor(.8,.8,.8,.9)
	rollFrame.status.parent = rollFrame;
	rollFrame.status.bg = rollFrame.status:CreateTexture(nil,'BACKGROUND')
	rollFrame.status.bg:SetAlpha(0.1)
	rollFrame.status.bg:SetAllPoints()
	rollFrame.status.bg:SetDrawLayer('BACKGROUND',2)
	rollFrame.status.spark = rollFrame:CreateTexture(nil,"OVERLAY")
	rollFrame.status.spark:Size(LOOT_HEIGHT * 0.5, LOOT_HEIGHT)
	rollFrame.status.spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
	rollFrame.status.spark:SetBlendMode("ADD")

	local needButton,needText = CreateRollButton(rollFrame,1,NEED,rollFrame.button)
	local greedButton,greedText = CreateRollButton(rollFrame,2,GREED,needButton,"RIGHT")
	local deButton,deText = CreateRollButton(rollFrame,3,ROLL_DISENCHANT,greedButton)
	local passButton,passText = CreateRollButton(rollFrame,0,PASS,deButton or greedButton)
	rollFrame.NeedIt,rollFrame.WantIt,rollFrame.BreakIt = needButton,greedButton,deButton;
	rollFrame.need,rollFrame.greed,rollFrame.pass,rollFrame.disenchant = needText,greedText,passText,deText;
	rollFrame.bindText = rollFrame:CreateFontString()
	rollFrame.bindText:Point("LEFT",passButton,"RIGHT",3,1)
	rollFrame.bindText:SetFont(LSM:Fetch("font", "SVUI Number Font"),14,"OUTLINE")
	rollFrame.lootText = rollFrame:CreateFontString(nil,"ARTWORK")
	rollFrame.lootText:SetFont(LSM:Fetch("font", "SVUI Number Font"),14,"OUTLINE")
	rollFrame.lootText:Point("LEFT",rollFrame.bindText,"RIGHT",0,0)
	rollFrame.lootText:Point("RIGHT",rollFrame,"RIGHT",-5,0)
	rollFrame.lootText:Size(200,10)
	rollFrame.lootText:SetJustifyH("LEFT")

	rollFrame.yourRoll = rollFrame:CreateFontString(nil,"ARTWORK")
	rollFrame.yourRoll:SetFont(LSM:Fetch("font", "SVUI Number Font"),18,"OUTLINE")
	rollFrame.yourRoll:Size(22,22)
	rollFrame.yourRoll:Point("LEFT",rollFrame,"RIGHT",5,0)
	rollFrame.yourRoll:SetJustifyH("CENTER")

	rollFrame.rolls = {}
	return rollFrame 
end 
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
local AutoConfirmLoot = function(_, event, arg1, arg2, ...)
	if event == "CONFIRM_LOOT_ROLL" or event == "CONFIRM_DISENCHANT_ROLL" then
		ConfirmLootRoll(arg1, arg2)
		StaticPopup_Hide("CONFIRM_LOOT_ROLL")
		return
	elseif event == "LOOT_BIND_CONFIRM" then
		ConfirmLootSlot(arg1, arg2)
		StaticPopup_Hide("LOOT_BIND",...)
		return
	end
end

local LootSimpleEventsHandler = function(_, event, slot)
	if(event == 'LOOT_SLOT_CLEARED') then
		if not SVUI_LootFrame:IsShown() then return; end
		SVUI_LootFrame.slots[slot]:Hide()
		HandleSlots(SVUI_LootFrame)
	elseif(event == 'LOOT_CLOSED') then
		StaticPopup_Hide("LOOT_BIND")
		SVUI_LootFrame:Hide()
		for _,slot in pairs(SVUI_LootFrame.slots)do
			slot:Hide()
		end
	elseif(event == 'OPEN_MASTER_LOOT_LIST') then
		ToggleDropDownMenu(1, nil, GroupLootDropDown, SVUI_LootFrame.slots[lastID], 0, 0)
	elseif(event == 'UPDATE_MASTER_LOOT_LIST') then
		MasterLooterFrame_UpdatePlayers()
	end
end

local OpenedLootHandler = function(_, event, autoLoot)
	local drops = GetNumLootItems()
	if drops > 0 then
		SVUI_LootFrame:Show()
	else
		CloseLoot(autoLoot == 0)
	end

	if IsFishingLoot() then
		SVUI_LootFrame.title:SetText(L["Fishy Loot"])
	elseif not UnitIsFriend("player", "target") and UnitIsDead"target" then 
		SVUI_LootFrame.title:SetText(UnitName("target"))
	else
		SVUI_LootFrame.title:SetText(LOOT)
	end 

	if GetCVar("lootUnderMouse") == "1" then 
		local cursorX,cursorY = GetCursorPosition()
		cursorX = cursorX / SVUI_LootFrame:GetEffectiveScale()
		cursorY = (cursorY  /  (SVUI_LootFrame:GetEffectiveScale()));
		SVUI_LootFrame:ClearAllPoints()
		SVUI_LootFrame:SetPoint("TOPLEFT", nil, "BOTTOMLEFT", cursorX - 40, cursorY + 20)
		SVUI_LootFrame:GetCenter()
	else
		SVUI_LootFrame:ClearAllPoints()
		SVUI_LootFrame:SetPoint("TOPLEFT", SVUI_LootFrameHolder, "TOPLEFT")
	end

	SVUI_LootFrame:Raise()

	local iQuality, nameWidth, titleWidth = 0, 0, SVUI_LootFrame.title:GetStringWidth()
	UpdateLootUpvalues()
	if drops > 0 then
		for i = 1, drops do 
			local slot = SVUI_LootFrame.slots[i] or MakeSlots(i)
			local texture, item, quantity, quality, locked, isQuestItem, questId, isActive = GetLootSlotInfo(i)
			local color = ITEM_QUALITY_COLORS[quality]
			if texture and texture:find("INV_Misc_Coin") then
				item = item:gsub("\n", ", ")
			end 
			if quantity and quantity > 1 then
				slot.count:SetText(quantity)
				slot.count:Show()
			else
				slot.count:Hide()
			end 
			if quality and quality > 1 then
				slot.drop:SetVertexColor(color.r, color.g, color.b)
				slot.drop:Show()
			else
				slot.drop:Hide()
			end 
			slot.quality = quality;
			slot.name:SetText(item)
			if color then
				slot.name:SetTextColor(color.r, color.g, color.b)
			end 
			slot.icon:SetTexture(texture)
			if quality then
				iQuality = max(iQuality, quality)
			end 
			nameWidth = max(nameWidth, slot.name:GetStringWidth())
			local qTex = slot.questTexture;
			if questId and not isActive then
				qTex:Show()
				ActionButton_ShowOverlayGlow(slot.iconFrame)
			elseif questId or isQuestItem then 
				qTex:Hide()
				ActionButton_ShowOverlayGlow(slot.iconFrame)
			else
				qTex:Hide()
				ActionButton_HideOverlayGlow(slot.iconFrame)
			end 
			slot:Enable()
			slot:Show()
			ConfirmLootSlot(i)
		end 
	else
		local slot = SVUI_LootFrame.slots[1] or MakeSlots(1)
		local color = ITEM_QUALITY_COLORS[0]
		slot.name:SetText(L["Empty Slot"])
		if color then
			slot.name:SetTextColor(color.r, color.g, color.b)
		end 
		slot.icon:SetTexture[[Interface\Icons\INV_Misc_Herb_AncientLichen]]
		drops = 1;
		nameWidth = max(nameWidth, slot.name:GetStringWidth())
		slot.count:Hide()
		slot.drop:Hide()
		slot:Disable()
		slot:Show()
	end 

	HandleSlots(SVUI_LootFrame)
	nameWidth = nameWidth + 60;
	titleWidth = titleWidth + 5;
	local color = ITEM_QUALITY_COLORS[iQuality]
	SVUI_LootFrame:SetBackdropBorderColor(color.r, color.g, color.b, .8)
	SVUI_LootFrame:Width(max(nameWidth, titleWidth))
end 

local function rollz()
	for _,roll in ipairs(MOD.LewtRollz)do 
		if not roll.rollID then
			return roll 
		end 
	end 
	local roll = CreateRollFrame()
	roll:Point("TOP", next(MOD.LewtRollz) and MOD.LewtRollz[#MOD.LewtRollz] or SVUI_AlertFrame, "BOTTOM", 0, -4);
	tinsert(MOD.LewtRollz, roll)
	return roll 
end 

local LootComplexEventsHandler = function(_, event, arg1, arg2)
	if(event == "START_LOOT_ROLL") then
		if dead_rollz[arg1] then return end 
		local texture,name,count,quality,bindOnPickUp,canNeed,canGreed,canBreak = GetLootRollItemInfo(arg1);
		local color = ITEM_QUALITY_COLORS[quality];
		local rollFrame = rollz();
		rollFrame.rollID = arg1;
		rollFrame.time = arg2;
		for i in pairs(rollFrame.rolls)do 
			rollFrame.rolls[i] = nil 
		end 
		rollFrame.need:SetText(0)
		rollFrame.greed:SetText(0)
		rollFrame.pass:SetText(0)
		rollFrame.disenchant:SetText(0)
		rollFrame.button.icon:SetTexture(texture)
		rollFrame.button.link = GetLootRollItemLink(arg1)
		if canNeed then 
			rollFrame.NeedIt:Enable()
			rollFrame.NeedIt:SetAlpha(1)
		else
			rollFrame.NeedIt:SetAlpha(0.2)
			rollFrame.NeedIt:Disable()
		end 
		if canGreed then 
			rollFrame.WantIt:Enable()
			rollFrame.WantIt:SetAlpha(1)
		else
			rollFrame.WantIt:SetAlpha(0.2)
			rollFrame.WantIt:Disable()
		end 
		if canBreak then 
			rollFrame.BreakIt:Enable()
			rollFrame.BreakIt:SetAlpha(1)
		else
			rollFrame.BreakIt:SetAlpha(0.2)
			rollFrame.BreakIt:Disable()
		end 
		SetDesaturation(rollFrame.NeedIt:GetNormalTexture(),not canNeed)
		SetDesaturation(rollFrame.WantIt:GetNormalTexture(),not canGreed)
		SetDesaturation(rollFrame.BreakIt:GetNormalTexture(),not canBreak)
		rollFrame.bindText:SetText(bindOnPickUp and "BoP" or "BoE")
		rollFrame.bindText:SetVertexColor(bindOnPickUp and 1 or 0.3, bindOnPickUp and 0.3 or 1, bindOnPickUp and 0.1 or 0.3)
		rollFrame.lootText:SetText(name)
		rollFrame.yourRoll:SetText("")
		rollFrame.status:SetStatusBarColor(color.r,color.g,color.b,0.7)
		rollFrame.status.bg:SetTexture(color.r,color.g,color.b)
		rollFrame.status:SetMinMaxValues(0,arg2)
		rollFrame.status:SetValue(arg2)
		rollFrame:SetPoint("CENTER",WorldFrame,"CENTER")
		rollFrame:Show()
		AlertFrame_FixAnchors()
		if SV.db.SVHenchmen.autoRoll and UnitLevel('player') == MAX_PLAYER_LEVEL and quality == 2 and not bindOnPickUp then 
			if canBreak then 
				RollOnLoot(arg1,3)
			else 
				RollOnLoot(arg1,2)
			end 
		end
	elseif(event == "LOOT_HISTORY_ROLL_CHANGED") then
		local rollID,_,_,_,_,_ = C_LootHistory.GetItem(arg1);
		local name,_,rollType,rollResult,_ = C_LootHistory.GetPlayerInfo(arg1,arg2);
		if name and rollType then 
			for _,roll in ipairs(MOD.LewtRollz)do 
				if roll.rollID == rollID then 
					roll.rolls[name] = rollType;
					roll[LootRollType[rollType]]:SetText(tonumber(roll[LootRollType[rollType]]:GetText()) + 1);
					return 
				end 
				if rollResult then
					roll.yourRoll:SetText(tostring(rollResult))
				end
			end
		end
	end
end 

_G.GroupLootDropDown_GiveLoot = function(self)
	if lastQuality >= MASTER_LOOT_THREHOLD then 
		local confirmed = SV:StaticPopup_Show("CONFIRM_LOOT_DISTRIBUTION",ITEM_QUALITY_COLORS[lastQuality].hex..lastName..FONT_COLOR_CODE_CLOSE,self:GetText());
		if confirmed then confirmed.data = self.value end 
	else 
		GiveMasterLoot(lastID, self.value)
	end 
	CloseDropDownMenus()
	SV.SystemAlert["CONFIRM_LOOT_DISTRIBUTION"].OnAccept = function(self,index) GiveMasterLoot(lastID,index) end 
end

local BailOut_OnEvent = function(self, event, ...)
	if((event == "UNIT_ENTERED_VEHICLE" and CanExitVehicle()) or UnitControllingVehicle("player") or UnitInVehicle("player")) then
 		self:Show()
 	else
 		self:Hide()
 	end
end
--[[ 
########################################################## 
LOAD / UPDATE
##########################################################
]]--
function MOD:Load()
	HelpOpenTicketButtonTutorial:Die()
	TalentMicroButtonAlert:Die()
	HelpPlate:Die()
	HelpPlateTooltip:Die()
	CompanionsMicroButtonAlert:Die()
	UIPARENT_MANAGED_FRAME_POSITIONS["GroupLootContainer"] = nil;
	
	DurabilityFrame:SetFrameStrata("HIGH")
	NewHook(DurabilityFrame, "SetPoint", Dura_OnSetPoint)
	
	TicketStatusFrame:ClearAllPoints()
	TicketStatusFrame:SetPoint("TOPRIGHT", SV.Dock.TopLeft, "TOPRIGHT", 0, 0)
	SV.Mentalo:Add(TicketStatusFrame, L["GM Ticket Frame"], nil, nil, "GM")
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

	local wsc = CreateFrame("Frame", "SVUI_WorldStateHolder", SV.Screen)
	wsc:SetSize(200, 45)
	wsc:SetPoint("TOP", SV.Dock.TopCenter, "BOTTOM", 0, -10)
	SV.Mentalo:Add(wsc, L["Capture Bars"])
	NewHook("UIParent_ManageFramePositions", CaptureBarHandler)

	local altPower = CreateFrame("Frame", "SVUI_AltPowerBar", UIParent)
	altPower:SetPoint("TOP", SV.Dock.TopCenter, "BOTTOM", 0, -60)
	altPower:Size(128, 50)
	PlayerPowerBarAlt:ClearAllPoints()
	PlayerPowerBarAlt:SetPoint("CENTER", altPower, "CENTER")
	PlayerPowerBarAlt:SetParent(altPower)
	PlayerPowerBarAlt.ignoreFramePositionManager = true;
	SV.Mentalo:Add(altPower, L["Alternative Power"])

	SVUI_AlertFrame:SetParent(SV.Screen)
	SVUI_AlertFrame:SetPoint("TOP", SV.Dock.TopCenter, "BOTTOM", 0, -115);
	SV.Mentalo:Add(SVUI_AlertFrame, L["Loot / Alert Frames"], nil, AlertFramePostMove_Hook)
	NewHook('AlertFrame_FixAnchors', AlertFramePostMove_Hook)
	NewHook('AlertFrame_SetLootAnchors', _hook_AlertFrame_SetLootAnchors)
	NewHook('AlertFrame_SetLootWonAnchors', _hook_AlertFrame_SetLootWonAnchors)
	NewHook('AlertFrame_SetMoneyWonAnchors', _hook_AlertFrame_SetMoneyWonAnchors)
	NewHook('AlertFrame_SetAchievementAnchors', _hook_AlertFrame_SetAchievementAnchors)
	NewHook('AlertFrame_SetCriteriaAnchors', _hook_AlertFrame_SetCriteriaAnchors)
	NewHook('AlertFrame_SetChallengeModeAnchors', _hook_AlertFrame_SetChallengeModeAnchors)
	NewHook('AlertFrame_SetDungeonCompletionAnchors', _hook_AlertFrame_SetDungeonCompletionAnchors)
	NewHook('AlertFrame_SetScenarioAnchors', _hook_AlertFrame_SetScenarioAnchors)
	NewHook('AlertFrame_SetGuildChallengeAnchors', _hook_AlertFrame_SetGuildChallengeAnchors)
	NewHook('AlertFrame_SetStorePurchaseAnchors', _hook_AlertFrame_SetStorePurchaseAnchors)

	LootFrame:UnregisterAllEvents();
	SVUI_LootFrame:SetFixedPanelTemplate('Transparent');
	SVUI_LootFrame.title:SetFont(LSM:Fetch("font", "SVUI Number Font"),18,"OUTLINE")
	SV.Mentalo:Add(SVUI_LootFrameHolder, L["Loot Frame"], nil, nil, "SVUI_LootFrame");
	SV:AddToDisplayAudit(SVUI_LootFrame);
	SVUI_LootFrame:Hide();

	UIParent:UnregisterEvent("LOOT_BIND_CONFIRM")
	UIParent:UnregisterEvent("CONFIRM_DISENCHANT_ROLL")
	UIParent:UnregisterEvent("CONFIRM_LOOT_ROLL")
	self:RegisterEvent("CONFIRM_DISENCHANT_ROLL", AutoConfirmLoot)
	self:RegisterEvent("CONFIRM_LOOT_ROLL", AutoConfirmLoot)
	self:RegisterEvent("LOOT_BIND_CONFIRM", AutoConfirmLoot)

	self:RegisterEvent("LOOT_READY", OpenedLootHandler)
	
	self:RegisterEvent("LOOT_SLOT_CLEARED", LootSimpleEventsHandler);
	self:RegisterEvent("LOOT_CLOSED", LootSimpleEventsHandler);
	self:RegisterEvent("OPEN_MASTER_LOOT_LIST", LootSimpleEventsHandler);
	self:RegisterEvent("UPDATE_MASTER_LOOT_LIST", LootSimpleEventsHandler);
	if SV.db.SVOverride.lootRoll then 
		self:RegisterEvent("LOOT_HISTORY_ROLL_CHANGED", LootComplexEventsHandler);
		self:RegisterEvent("START_LOOT_ROLL", LootComplexEventsHandler);
		UIParent:UnregisterEvent("START_LOOT_ROLL");
		UIParent:UnregisterEvent("CANCEL_LOOT_ROLL");
	end 

	UIParent:UnregisterEvent("MIRROR_TIMER_START")
	self:RegisterEvent("CVAR_UPDATE", MirrorBarUpdateHandler)
	self:RegisterEvent("PLAYER_ENTERING_WORLD", MirrorBarUpdateHandler)
	self:RegisterEvent("MIRROR_TIMER_START", MirrorBarToggleHandler)
	self:RegisterEvent("MIRROR_TIMER_STOP", MirrorBarToggleHandler)
	self:RegisterEvent("MIRROR_TIMER_PAUSE", MirrorBarToggleHandler)
	self:RegisterEvent("START_TIMER", MirrorBarToggleHandler)

	local exitSize = ExtraActionBarFrame:GetSize()

	local exit = CreateFrame("Button", "SVUI_BailOut", SV.Screen)
	exit:Size(exitSize)
	exit:Point("BOTTOM", SV.Screen, "BOTTOM", 0, 275)
	exit:SetNormalTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Icons\\EXIT")
	exit:SetPushedTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Icons\\EXIT")
	exit:SetHighlightTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Icons\\EXIT")
	exit:SetFixedPanelTemplate("Transparent")
	exit:RegisterForClicks("AnyUp")
	exit:SetScript("OnClick", VehicleExit)
	
	exit:RegisterEvent("UNIT_ENTERED_VEHICLE")
 	exit:RegisterEvent("UNIT_EXITED_VEHICLE")
 	exit:RegisterEvent("VEHICLE_UPDATE")
 	exit:RegisterEvent("PLAYER_ENTERING_WORLD")
 	exit:SetScript("OnEvent", BailOut_OnEvent)
 	exit:Hide()

	SV.Mentalo:Add(exit, L["Bail Out"])

	LossOfControlFrame:ClearAllPoints()
	LossOfControlFrame:SetPoint("TOP", SV.Screen, "TOP", 0, -225)
	SV.Mentalo:Add(LossOfControlFrame, L["Loss Control Icon"], nil, nil, "LoC")
end