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
local string 	= _G.string;
local math 		= _G.math;
--[[ STRING METHODS ]]--
local find, format, split = string.find, string.format, string.split;
local gsub = string.gsub;
--[[ MATH METHODS ]]--
local ceil = math.ceil;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = select(2, ...)
local L = SV.L;
local SuperButton = _G["SVUI_SuperButtonFrame"];
SuperButton.List = {};
SuperButton.ActionBlackList = {};
SuperButton.SpellBlackList = {};
SuperButton.ItemBlackList = {};
--[[ 
########################################################## 
HELPERS
##########################################################
]]--
local function UpdateActionCooldown(self)
	if(self:IsShown() and self.action) then
		local start, duration, enable = GetActionCooldown(self.action)
		if(duration > 0) then
			self.Cooldown:SetCooldown(start, duration)
			self.Cooldown:Show()
		else
			self.Cooldown:Hide()
		end
	end
end

local function UpdateSpellCooldown(self)
	if(self:IsShown() and self.spellName) then
		local start, duration, enable = GetSpellCooldown(self.spellName)
		if(duration > 0) then
			self.Cooldown:SetCooldown(start, duration)
			self.Cooldown:Show()
		else
			self.Cooldown:Hide()
		end
	end
end

local function UpdateItemCooldown(self)
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
local SuperActionButton_OnEnter = function(self)
	if(self.action) then
		GameTooltip:SetOwner(self, 'ANCHOR_LEFT')
		GameTooltip:SetAction(self.action)
	end
end

local SuperSpellButton_OnEnter = function(self)
	if(self.spellID) then
		GameTooltip:SetOwner(self, 'ANCHOR_LEFT')
		GameTooltip:SetSpellByID(self.spellID)
	end
end

local SuperItemButton_OnEnter = function(self)
	if(self.itemID) then
		GameTooltip:SetOwner(self, 'ANCHOR_LEFT')
		GameTooltip:SetHyperlink(self.itemLink)
	end
end

local SuperButton_OnShow = function(self)
	SuperButton.isActive = true;
end

local SuperButton_OnHide = function(self)
	SuperButton.isActive = false;
end

local IsSuperButtonActive = function(self)
	SuperButton.isActive = false
	for name, frame in pairs(SuperButton.List) do
		if(frame and frame:IsShown()) then
			SuperButton.isActive = true
			break;
		end
	end
	return (not SuperButton.isActive);
end

local UpdateGeneric = function(self)
	return true;
end

local SuperButtonAction_OnEvent = function(self, event)
	if(event == 'PLAYER_REGEN_ENABLED') then
		self:SetAttribute('action', self.attribute)
		self:UnregisterEvent(event)
		UpdateActionCooldown(self)
	elseif(event == 'UPDATE_BINDINGS') then
		if(self:IsShown()) then
			self:SetAbility()
			self:SetAttribute('binding', GetTime())
		end
	else
		self:Update()
	end
end

local SuperButtonSpell_OnEvent = function(self, event)
	if(event == 'PLAYER_REGEN_ENABLED') then
		self:SetAttribute('spell', self.attribute)
		self:UnregisterEvent(event)
		UpdateSpellCooldown(self)
	elseif(event == 'UPDATE_BINDINGS') then
		if(self:IsShown()) then
			self:SetAbility()
			self:SetAttribute('binding', GetTime())
		end
	else
		self:Update()
	end
end

local SuperButtonItem_OnEvent = function(self, event)
	if(event == 'BAG_UPDATE_COOLDOWN') then
		UpdateItemCooldown(self)
	elseif(event == 'PLAYER_REGEN_ENABLED') then
		self:SetAttribute('item', self.attribute)
		self:UnregisterEvent(event)
		UpdateItemCooldown(self)
	elseif(event == 'UPDATE_BINDINGS') then
		if(self:IsShown()) then
			self:SetAbility()
			self:SetAttribute('binding', GetTime())
		end
	else
		self:Update()
	end
end
--[[ 
########################################################## 
EXTRA ACTION SCRIPT HANDLERS
##########################################################
]]--
local ExtraButton_OnEvent = function(self, event)
	if(event == 'UPDATE_EXTRA_ACTIONBAR') then
		local action = ExtraActionButton1:GetAttribute('action')
		self:SetAbility(action)
		UpdateActionCooldown(self)
	elseif(event == 'PLAYER_REGEN_ENABLED') then
		self:SetAttribute('action', self.attribute)
		self:UnregisterEvent(event)
		UpdateActionCooldown(self)
	elseif(event == 'UPDATE_BINDINGS') then
		if(self:IsShown()) then
			self:SetAttribute('binding', GetTime())
			self:SetAbility()
		end
	else
		self:Update()
	end
end
--[[ 
########################################################## 
ACTION BUTTON INTERNALS
##########################################################
]]--
local SetSuperButtonAction = function(self, action)
	if(action) then
		if(action == self.action and self:IsShown()) then
			return false
		end
		self.action = action

		if(SuperButton.ActionBlackList[self.action]) then
			return false
		end
	end

	local HotKey = self.HotKey
	local key = GetBindingKey('EXTRAACTIONBUTTON1')
	if(key) then
		HotKey:SetText(GetBindingText(key, 1))
		HotKey:Show()
	elseif(ActionHasRange(self.action)) then
		HotKey:SetText(RANGE_INDICATOR)
		HotKey:Show()
	else
		HotKey:Hide()
	end

	if(InCombatLockdown()) then
		self.attribute = self.action
		self:RegisterEvent('PLAYER_REGEN_ENABLED')
	else
		self:SetAttribute('action', self.action)
		UpdateActionCooldown(self)
	end

	return true
end

local RemoveSuperButtonAction = function(self)
	if(InCombatLockdown()) then
		self.attribute = nil;
		self:RegisterEvent('PLAYER_REGEN_ENABLED')
	else
		self:SetAttribute('action', nil)
	end
end

local SuperActionButton_OnUpdate = function(self, elapsed)
	if(not self.action) then return end
	if(self.rangeTimer > 0.2) then
		local HotKey = self.HotKey
		local inRange = IsActionInRange(self.action, 'target')
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
SPELL BUTTON INTERNALS
##########################################################
]]--
local SetSuperButtonSpell = function(self, spellID, spellName, texture)
	if(spellID and spellName) then
		if(spellID == self.spellID and self:IsShown()) then
			return false
		end

		self.Icon:SetTexture(texture)
		self.spellID = spellID
		self.spellName = spellName

		if(SuperButton.SpellBlackList[self.spellID]) then
			return false
		end
	end

	local HotKey = self.HotKey
	local key = GetBindingKey('EXTRAACTIONBUTTON1')
	if(key) then
		HotKey:SetText(GetBindingText(key, 1))
		HotKey:Show()
	elseif(SpellHasRange(self.spellName)) then
		HotKey:SetText(RANGE_INDICATOR)
		HotKey:Show()
	else
		HotKey:Hide()
	end

	if(InCombatLockdown()) then
		self.attribute = self.spellName
		self:RegisterEvent('PLAYER_REGEN_ENABLED')
	else
		self:SetAttribute('spell', self.spellName)
		UpdateSpellCooldown(self)
	end

	return true
end

local RemoveSuperButtonSpell = function(self)
	if(InCombatLockdown()) then
		self.attribute = nil;
		self:RegisterEvent('PLAYER_REGEN_ENABLED')
	else
		self:SetAttribute('spell', nil)
	end
end

local SuperSpellButton_OnUpdate = function(self, elapsed)
	if(not self.spellName) then return end
	if(self.rangeTimer > 0.2) then
		local HotKey = self.HotKey
		local inRange = IsSpellInRange(self.spellName, 'target')
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
ITEM BUTTON INTERNALS
##########################################################
]]--
local SetSuperButtonItem = function(self, itemLink, texture)
	if(itemLink) then
		if(itemLink == self.itemLink and self:IsShown()) then
			return false
		end

		self.Icon:SetTexture(texture)
		self.itemID, self.itemName = string.match(itemLink, '|Hitem:(.-):.-|h%[(.+)%]|h')
		self.itemLink = itemLink

		if(SuperButton.ItemBlackList[self.itemID]) then
			return false
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
		UpdateItemCooldown(self)
	end

	return true
end

local RemoveSuperButtonItem = function(self)
	if(InCombatLockdown()) then
		self.attribute = nil;
		self:RegisterEvent('PLAYER_REGEN_ENABLED')
	else
		self:SetAttribute('item', nil)
	end
end

local SuperItemButton_OnUpdate = function(self, elapsed)
	if(not self.itemID) then return end
	if(self.rangeTimer > 0.2) then
		local HotKey = self.HotKey
		local inRange = IsItemInRange(self.itemID, 'target')
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
CONSTRUCTS
##########################################################
]]--
function SuperButton:AddAction(buttonName, updateFunc, eventFunc)
	local special = CreateFrame('Button', buttonName, UIParent, 'SecureActionButtonTemplate, SecureHandlerStateTemplate, SecureHandlerAttributeTemplate');
	special:SetSizeToScale(50,50);
	special:SetPointToScale("CENTER", self, "CENTER", 0, 0);
	special:SetStylePanel("Icon");
	special:SetScript('OnEnter', SuperActionButton_OnEnter);
	special:SetScript('OnLeave', GameTooltip_Hide);
	special:SetScript('OnShow', SuperButton_OnShow);
	special:SetScript('OnHide', SuperButton_OnHide);

	special.updateTimer = 0;
	special.rangeTimer = 0;

	special.IsReady = IsSuperButtonActive;
	special.SetAbility = SetSuperButtonAction;
	special.RemoveAbility = RemoveSuperButtonAction;
	if(updateFunc and type(updateFunc) == 'function') then
		special.Update = updateFunc;
	else
		special.Update = UpdateGeneric;
	end
	if(eventFunc and type(eventFunc) == 'function') then
		special:SetScript('OnEvent', eventFunc)
	else
		special:SetScript('OnEvent', SuperButtonAction_OnEvent)
	end

	local Icon = special:CreateTexture('$parentIcon', 'BACKGROUND')
	Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	Icon:SetAllPoints()
	special.Icon = Icon

	local HotKey = special:CreateFontString('$parentHotKey', nil, 'NumberFontNormal')
	HotKey:SetPoint('BOTTOMRIGHT', -5, 5)
	special.HotKey = HotKey

	local Cooldown = CreateFrame('Cooldown', '$parentCooldown', special, 'CooldownFrameTemplate')
	Cooldown:ClearAllPoints()
	Cooldown:SetPoint('TOPRIGHT', -2, -3)
	Cooldown:SetPoint('BOTTOMLEFT', 2, 1)
	Cooldown:Hide()
	special.Cooldown = Cooldown

	local Count = Cooldown:CreateFontString(nil, 'OVERLAY', 'NumberFontNormal')
	Count:SetPoint('BOTTOMLEFT', 5, 5)
	special.Count = Count

	special:SetScript('OnUpdate', SuperActionButton_OnUpdate)
	special:RegisterEvent('UPDATE_BINDINGS')

	special:SetAttribute('type', 'action');
	RegisterStateDriver(special, 'visible', [[
		local isReady = self:CallMethod('IsReady');
		if(isReady) then
			return 'show'
		else
			return 'hide'
		end
	]]);
	special:SetAttribute('_onattributechanged', [[
		if(name == 'action') then
			if(value and not self:IsShown()) then
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
		if(self:IsShown() and (name == 'action' or name == 'binding')) then
			self:ClearBindings()
			local key = GetBindingKey('EXTRAACTIONBUTTON1')
			if(key) then
				self:SetBindingClick(1, key, self, 'LeftButton')
			end
		end
	]]);

	self.List[buttonName] = special;

	return special
end

function SuperButton:AddSpell(buttonName, updateFunc, eventFunc)
	local special = CreateFrame('Button', buttonName, UIParent, 'SecureActionButtonTemplate, SecureHandlerStateTemplate, SecureHandlerAttributeTemplate');
	special:SetSizeToScale(50,50);
	special:SetPointToScale("CENTER", self, "CENTER", 0, 0);
	special:SetStylePanel("Icon");
	special:SetScript('OnEnter', SuperSpellButton_OnEnter);
	special:SetScript('OnLeave', GameTooltip_Hide);
	special:SetScript('OnShow', SuperButton_OnShow);
	special:SetScript('OnHide', SuperButton_OnHide);

	special.updateTimer = 0;
	special.rangeTimer = 0;

	special.IsReady = IsSuperButtonActive;
	special.SetAbility = SetSuperButtonSpell
	special.RemoveAbility = RemoveSuperButtonSpell
	if(updateFunc and type(updateFunc) == 'function') then
		special.Update = updateFunc
	else
		special.Update = UpdateGeneric
	end
	if(eventFunc and type(eventFunc) == 'function') then
		special:SetScript('OnEvent', eventFunc)
	else
		special:SetScript('OnEvent', SuperButtonSpell_OnEvent)
	end

	local Icon = special:CreateTexture('$parentIcon', 'BACKGROUND')
	Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	Icon:SetAllPoints()
	special.Icon = Icon

	local HotKey = special:CreateFontString('$parentHotKey', nil, 'NumberFontNormal')
	HotKey:SetPoint('BOTTOMRIGHT', -5, 5)
	special.HotKey = HotKey

	local Cooldown = CreateFrame('Cooldown', '$parentCooldown', special, 'CooldownFrameTemplate')
	Cooldown:ClearAllPoints()
	Cooldown:SetPoint('TOPRIGHT', -2, -3)
	Cooldown:SetPoint('BOTTOMLEFT', 2, 1)
	Cooldown:Hide()
	special.Cooldown = Cooldown

	special:SetScript('OnUpdate', SuperSpellButton_OnUpdate)
	special:RegisterEvent('UPDATE_BINDINGS')

	special:SetAttribute('type', 'spell');
	RegisterStateDriver(special, 'visible', [[
		local isReady = self:CallMethod('IsReady');
		if(isReady) then
			return 'show'
		else
			return 'hide'
		end
	]]);
	special:SetAttribute('_onattributechanged', [[
		if(name == 'spell') then
			if(value and not self:IsShown()) then
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
		if(self:IsShown() and (name == 'spell' or name == 'binding')) then
			self:ClearBindings()
			local key = GetBindingKey('EXTRAACTIONBUTTON1')
			if(key) then
				self:SetBindingClick(1, key, self, 'LeftButton')
			end
		end
	]]);

	self.List[buttonName] = special;

	return special
end

function SuperButton:AddItem(buttonName, updateFunc, eventFunc)
	local special = CreateFrame('Button', buttonName, UIParent, 'SecureActionButtonTemplate, SecureHandlerStateTemplate, SecureHandlerAttributeTemplate');
	special:SetSizeToScale(50,50);
	special:SetPointToScale("CENTER", self, "CENTER", 0, 0);
	special:SetStylePanel("Icon");
	special:SetScript('OnEnter', SuperItemButton_OnEnter);
	special:SetScript('OnLeave', GameTooltip_Hide);
	special:SetScript('OnShow', SuperButton_OnShow);
	special:SetScript('OnHide', SuperButton_OnHide);

	special.updateTimer = 0;
	special.rangeTimer = 0;

	special.IsReady = IsSuperButtonActive;
	special.SetAbility = SetSuperButtonItem
	special.RemoveAbility = RemoveSuperButtonItem
	if(updateFunc and type(updateFunc) == 'function') then
		special.Update = updateFunc
	else
		special.Update = UpdateGeneric
	end
	if(eventFunc and type(eventFunc) == 'function') then
		special:SetScript('OnEvent', eventFunc)
	else
		special:SetScript('OnEvent', SuperButtonItem_OnEvent)
	end

	local Icon = special:CreateTexture('$parentIcon', 'BACKGROUND')
	Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	Icon:SetAllPoints()
	special.Icon = Icon

	local HotKey = special:CreateFontString('$parentHotKey', nil, 'NumberFontNormal')
	HotKey:SetPoint('BOTTOMRIGHT', -5, 5)
	special.HotKey = HotKey

	local Cooldown = CreateFrame('Cooldown', '$parentCooldown', special, 'CooldownFrameTemplate')
	Cooldown:ClearAllPoints()
	Cooldown:SetPoint('TOPRIGHT', -2, -3)
	Cooldown:SetPoint('BOTTOMLEFT', 2, 1)
	Cooldown:Hide()
	special.Cooldown = Cooldown

	special:RegisterEvent('UPDATE_BINDINGS')

	special:SetAttribute('type', 'item');
	RegisterStateDriver(special, 'visible', [[
		local isReady = self:CallMethod('IsReady');
		if(isReady) then
			return 'show'
		else
			return 'hide'
		end
	]]);
	special:SetAttribute('_onattributechanged', [[
		if(name == 'item') then
			if(value and not self:IsShown()) then
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
	]]);

	self.List[buttonName] = special;

	return special
end
--[[ 
########################################################## 
PACKAGE CALL
##########################################################
]]--
function SuperButton:Initialize()
	self:SetParent(SV.Screen)
	self:SetPointToScale("BOTTOM", SV.Screen, "BOTTOM", 0, 325)
	self:SetSizeToScale(50,50)

	local extra = self:AddAction("SVUI_ExtraActionButton", nil, ExtraButton_OnEvent);
	extra:RegisterEvent('UPDATE_EXTRA_ACTIONBAR')
	ExtraActionBarFrame:UnregisterAllEvents()

	SV.Mentalo:Add(self, L["Special Ability Button"])
end

SV.SuperButton = SuperButton;