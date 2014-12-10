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
local ipairs    = _G.ipairs;
local type      = _G.type;
local error     = _G.error;
local pcall     = _G.pcall;
local tostring  = _G.tostring;
local tonumber  = _G.tonumber;
local tinsert 	= _G.tinsert;
local string 	= _G.string;
local math 		= _G.math;
local table 	= _G.table;
--[[ STRING METHODS ]]--
local format = string.format;
--[[ MATH METHODS ]]--
local abs, ceil, floor, round = math.abs, math.ceil, math.floor, math.round;
--[[ TABLE METHODS ]]--
local tremove, twipe = table.remove, table.wipe;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = select(2, ...)
local L = SV.L
local LSM = LibStub("LibSharedMedia-3.0")
local MOD = SV.SVQuest;
--[[ 
########################################################## 
LOCALS
##########################################################
]]--
local blacklist = {
	[113191] = true,
	[110799] = true,
	[109164] = true,
};
--[[ 
########################################################## 
HELPERS
##########################################################
]]--
local function UpdateCooldown(self)
	if(self:IsShown() and self.itemID) then
		local start, duration, enable = GetItemCooldown(self.itemID)
		if(duration > 0) then
			self.Cooldown:SetCooldown(start, duration)
			self.Cooldown:Show()
		else
			self.Cooldown:Hide()
		end
	end
end
--[[ 
########################################################## 
SCRIPT HANDLERS
##########################################################
]]--
local QuestButton_OnEvent = function(self, event)
	if(event == 'BAG_UPDATE_COOLDOWN') then
		UpdateCooldown(self)
	elseif(event == 'PLAYER_REGEN_ENABLED') then
		self:SetAttribute('item', self.attribute)
		self:UnregisterEvent(event)
		UpdateCooldown(self)
	elseif(event == 'UPDATE_BINDINGS') then
		if(self:IsShown()) then
			self:SetItem()
			self:SetAttribute('binding', GetTime())
		end
	else
		self:Update()
	end
end

local QuestButton_OnEnter = function(self)
	if(self.itemID) then
		GameTooltip:SetOwner(self, 'ANCHOR_LEFT')
		GameTooltip:SetHyperlink(self.itemLink)
	end
end

local QuestButton_OnUpdate = function(self, elapsed)
	if(self.rangeTimer > 0.2) then
		local HotKey = self.HotKey
		local inRange = IsItemInRange(self.itemLink, 'target')
		if(HotKey:GetText() == RANGE_INDICATOR) then
			if(inRange == false) then
				HotKey:SetTextColor(1, 0.1, 0.1)
				HotKey:Show()
			elseif(inRange) then
				HotKey:SetTextColor(1, 1, 1)
				HotKey:Show()
			else
				HotKey:Hide()
			end
		else
			if(inRange == false) then
				HotKey:SetTextColor(1, 0.1, 0.1)
			else
				HotKey:SetTextColor(1, 1, 1)
			end
		end

		self.rangeTimer = 0
	else
		self.rangeTimer = self.rangeTimer + elapsed
	end

	if(self.updateTimer > 5) then
		self:Update()
		self.updateTimer = 0
	else
		self.updateTimer = self.updateTimer + elapsed
	end
end
--[[ 
########################################################## 
BUTTON INTERNALS
##########################################################
]]--
local SetButtonItem = function(self, itemLink, texture)
	if(itemLink) then
		if(itemLink == self.itemLink and self:IsShown()) then
			return
		end

		self.Icon:SetTexture(texture)
		self.itemID, self.itemName = string.match(itemLink, '|Hitem:(.-):.-|h%[(.+)%]|h')
		self.itemLink = itemLink

		if(blacklist[self.itemID]) then
			return
		end
	end

	local HotKey = self.HotKey
	local key = GetBindingKey('EXTRAACTIONBUTTON1')
	if(key) then
		HotKey:SetText(GetBindingText(key, 1))
		HotKey:Show()
	elseif(ItemHasRange(self.itemLink)) then
		HotKey:SetText(RANGE_INDICATOR)
		HotKey:Show()
	else
		HotKey:Hide()
	end

	if(InCombatLockdown()) then
		self.attribute = self.itemName
		self:RegisterEvent('PLAYER_REGEN_ENABLED')
	else
		self:SetAttribute('item', self.itemName)
		UpdateCooldown(self)
	end
end

local RemoveButtonItem = function(self)
	if(InCombatLockdown()) then
		self.attribute = nil
		self:RegisterEvent('PLAYER_REGEN_ENABLED')
	else
		self:SetAttribute('item', nil)
	end
end

local UpdateButton = function(self)
	MOD:UpdateProximity()
end
--[[ 
########################################################## 
PACKAGE CALL
##########################################################
]]--
function MOD:InitializeQuestItem()
	local buttonSize = SVUI_SpecialAbility:GetSize()

	local Button = CreateFrame('Button', "SVUI_QuestAutoButton", UIParent, 'SecureActionButtonTemplate, SecureHandlerStateTemplate, SecureHandlerAttributeTemplate')
	Button:Size(SVUI_SpecialAbility:GetSize())
	Button:SetPoint('CENTER', SVUI_SpecialAbility, 'CENTER', 0, 0)
	Button:SetSlotTemplate(true)
	Button:SetScript('OnLeave', GameTooltip_Hide)
	Button:SetAttribute('type', 'item')
	Button.updateTimer = 0
	Button.rangeTimer = 0
	RegisterStateDriver(Button, 'visible', '[extrabar] hide; show')
	Button:SetAttribute('_onattributechanged', [[
		if(name == 'item') then
			if(value and not self:IsShown() and not HasExtraActionBar()) then
				self:Show()
			elseif(not value) then
				self:Hide()
				self:ClearBindings()
			end
		elseif(name == 'state-visible') then
			if(value == 'show') then
				self:CallMethod('Update')
			else
				self:Hide()
				self:ClearBindings()
			end
		end

		if(self:IsShown() and (name == 'item' or name == 'binding')) then
			self:ClearBindings()

			local key = GetBindingKey('EXTRAACTIONBUTTON1')
			if(key) then
				self:SetBindingClick(1, key, self, 'LeftButton')
			end
		end
	]])

	local Icon = Button:CreateTexture('$parentIcon', 'BACKGROUND')
	Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	Icon:SetAllPoints()
	Button.Icon = Icon

	local HotKey = Button:CreateFontString('$parentHotKey', nil, 'NumberFontNormal')
	HotKey:SetPoint('BOTTOMRIGHT', -5, 5)
	Button.HotKey = HotKey

	local Cooldown = CreateFrame('Cooldown', '$parentCooldown', Button, 'CooldownFrameTemplate')
	Cooldown:ClearAllPoints()
	Cooldown:SetPoint('TOPRIGHT', -2, -3)
	Cooldown:SetPoint('BOTTOMLEFT', 2, 1)
	Cooldown:Hide()
	Button.Cooldown = Cooldown

	local Artwork = Button:CreateTexture('$parentArtwork', 'OVERLAY')
	Artwork:SetPoint('CENTER', -2, 0)
	Artwork:SetSize(256, 128)
	Artwork:SetTexture([[Interface\ExtraButton\Default]])
	Button.Artwork = Artwork

	Button.SetItem = SetButtonItem
	Button.RemoveItem = RemoveButtonItem
	Button.Update = UpdateButton

	Button:SetScript('OnEnter', QuestButton_OnEnter)
	Button:SetScript('OnUpdate', QuestButton_OnUpdate)
	
	Button:RegisterEvent('UPDATE_BINDINGS')
	Button:RegisterEvent('UPDATE_EXTRA_ACTIONBAR')
	Button:RegisterEvent('BAG_UPDATE_COOLDOWN')
	Button:RegisterEvent('BAG_UPDATE_DELAYED')
	Button:RegisterEvent('WORLD_MAP_UPDATE')
	Button:RegisterEvent('QUEST_LOG_UPDATE')
	Button:RegisterEvent('QUEST_POI_UPDATE')
	Button:SetScript('OnEvent', QuestButton_OnEvent)

	self.QuestItem = Button
end