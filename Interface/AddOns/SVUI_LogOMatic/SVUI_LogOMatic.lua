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
local type 		= _G.type;
local tinsert 	= _G.tinsert;
local string 	= _G.string;
local math 		= _G.math;
local table 	= _G.table;
--[[ STRING METHODS ]]--
local format = string.format;
--[[ MATH METHODS ]]--
local floor = math.floor;
--[[ TABLE METHODS ]]--
local twipe,tcopy,tsort = table.wipe, table.copy, table.sort;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local PLUGIN = select(2, ...)
local Schema = PLUGIN.Schema;

local SV = _G["SVUI"];
local L = SV.L
local CHAT = SV.SVChat;

local NewHook = hooksecurefunc;
--[[ 
########################################################## 
LOCAL VARIABLES
##########################################################
]]--
local nameKey = UnitName("player");
local realmKey = GetRealmName();
local NewHook = hooksecurefunc;
local LoggingEvents = {
	"CHAT_MSG_CHANNEL",
	"CHAT_MSG_EMOTE",
	"CHAT_MSG_GUILD_ACHIEVEMENT",
	"CHAT_MSG_RAID_WARNING",
	"CHAT_MSG_SAY",
	"CHAT_MSG_YELL",
	"CHAT_MSG_WHISPER_INFORM",
	"CHAT_MSG_WHISPER",
	"CHAT_MSG_GUILD",
	"CHAT_MSG_OFFICER",
	"CHAT_MSG_PARTY",
	"CHAT_MSG_PARTY_LEADER",
	"CHAT_MSG_RAID",
	"CHAT_MSG_RAID_LEADER",
	"CHAT_MSG_INSTANCE_CHAT",
	"CHAT_MSG_INSTANCE_CHAT_LEADER",
	"CHAT_MSG_BN_CONVERSATION",
	"CHAT_MSG_BN_WHISPER",
	"CHAT_MSG_BN_WHISPER_INFORM"
};
--[[ 
########################################################## 
CORE DATA
##########################################################
]]--
PLUGIN.stash = {};
PLUGIN.myStash = {};
PLUGIN.BagItemCache = {};
PLUGIN.HasAltInventory = false;
--[[ 
########################################################## 
LOCAL FUNCTIONS
##########################################################
]]--
local RefreshLoggedSlot = function(self, bag, slotID, save)
	if self.Bags[bag] and self.Bags[bag].numSlots ~= GetContainerNumSlots(bag) or not self.Bags[bag] or not self.Bags[bag][slotID] then return end 
	local slot, _ = self.Bags[bag][slotID], nil;
	local bagType = self.Bags[bag].bagFamily;
	local texture, count, locked = GetContainerItemInfo(bag, slotID)
	local itemLink = GetContainerItemLink(bag, slotID);
	local key;
	slot:Show()
	slot.name, slot.rarity = nil, nil;
	local start, duration, enable = GetContainerItemCooldown(bag, slotID)
	CooldownFrame_SetTimer(slot.cooldown, start, duration, enable)
	if duration > 0 and enable == 0 then 
		SetItemButtonTextureVertexColor(slot, 0.4, 0.4, 0.4)
	else 
		SetItemButtonTextureVertexColor(slot, 1, 1, 1)
	end 
	if bagType then
		local r, g, b = bagType[1], bagType[2], bagType[3];
		slot:SetBackdropColor(r, g, b, 0.5)
		slot:SetBackdropBorderColor(r, g, b, 1)
	elseif itemLink then
		local class, subclass, maxStack;
		key, _, slot.rarity, _, _, class, subclass, maxStack = GetItemInfo(itemLink)
		slot.name = key
		local z, A, C = GetContainerItemQuestInfo(bag, slotID)
		if A and not isActive then 
			slot:SetBackdropBorderColor(1.0, 0.3, 0.3)
		elseif A or z then 
			slot:SetBackdropBorderColor(1.0, 0.3, 0.3)
		elseif slot.rarity and slot.rarity>1 then 
			local D, E, F = GetItemQualityColor(slot.rarity)
			slot:SetBackdropBorderColor(D, E, F)
		else 
			slot:SetBackdropBorderColor(0, 0, 0)
		end
		if (key and save) then
			local id = GetContainerItemID(bag,slotID)
			if id ~= 6948 then PLUGIN.myStash[bag][key] = GetItemCount(id,true) end
		end
	else 
		slot:SetBackdropBorderColor(0, 0, 0)
	end 
	if C_NewItems.IsNewItem(bag, slotID)then 
		ActionButton_ShowOverlayGlow(slot)
	else 
		ActionButton_HideOverlayGlow(slot)
	end 
	SetItemButtonTexture(slot, texture)
	SetItemButtonCount(slot, count)
	SetItemButtonDesaturated(slot, locked, 0.5, 0.5, 0.5)
end

local RefreshLoggedBagSlots = function(self, bag, save)
	if(not bag) then return end 
	for i = 1, GetContainerNumSlots(bag)do 
		local container = self
		if not self.RefreshSlot then 
			container = self:GetParent()
		end 
		RefreshLoggedSlot(container, bag, i, save)
	end
end 

local RefreshLoggedBagsSlots = function(self)
	for _,bag in ipairs(self.BagIDs)do
		local container = self.Bags[bag]
		if container then
			if PLUGIN.myStash[bag] then
				twipe(PLUGIN.myStash[bag])
			else
				PLUGIN.myStash[bag] = {};
			end
			RefreshLoggedBagSlots(container, bag, true)
		end 
	end
	for bag,items in pairs(PLUGIN.myStash) do
		for id,amt in pairs(items) do
			PLUGIN.BagItemCache[id] = PLUGIN.BagItemCache[id] or {}
			PLUGIN.BagItemCache[id][nameKey] = amt
		end
	end
end 

local GameTooltip_LogTooltipSetItem = function(self)
	local key,itemID = self:GetItem()
	if PLUGIN.BagItemCache[key] then
		self:AddLine(" ")
		self:AddDoubleLine("|cFFFFDD3C[Character]|r","|cFFFFDD3C[Count]|r")
		for alt,amt in pairs(PLUGIN.BagItemCache[key]) do
			local hexString = LogOMatic_Data[realmKey]["info"][alt] or "|cffCC1410"
			local name = ("%s%s|r"):format(hexString, alt)
			local result = ("%s%s|r"):format(hexString, amt)
			self:AddDoubleLine(name,result)
		end
		self:AddLine(" ")
	end
	self.itemLogged = true 
end 
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
function CHAT:LoadSavedChatLog()
	local temp, data = {}
	for id, _ in pairs(LogOMatic_Cache["chat"]) do
		tinsert(temp, tonumber(id))
	end
	tsort(temp, function(a, b)
		return a < b
	end)
	for i = 1, #temp do
		data = LogOMatic_Cache["chat"][tostring(temp[i])]
		if type(data) == "table" and data[20] ~= nil then
			self.timeOverride = temp[i]
			ChatFrame_MessageEventHandler(DEFAULT_CHAT_FRAME, data[20], unpack(data))
		end
	end
end

function CHAT:LogCurrentChat(event, ...)
	local temp = {}
	for i = 1, select('#', ...) do	
		temp[i] = select(i, ...) or false
	end
	if #temp > 0 then
	  temp[20] = event
	  local randomTime = select(2, ("."):split(GetTime() or "0."..random(1, 999), 2)) or 0;
	  local timeForMessage = time().."."..randomTime;
	  LogOMatic_Cache["chat"][timeForMessage] = temp
		local c, k = 0
		for id, data in pairs(LogOMatic_Cache["chat"]) do
			c = c + 1
			if (not k) or k > id then
				k = id
			end
		end
		if c > 128 then
			LogOMatic_Cache["chat"][k] = nil
		end	  
	end
end 

function CHAT:PLAYER_ENTERING_WORLD()
	local temp, data = {}
	for id, _ in pairs(LogOMatic_Cache["chat"]) do
		tinsert(temp, tonumber(id))
	end
	tsort(temp, function(a, b)
		return a < b
	end)
	for i = 1, #temp do
		data = LogOMatic_Cache["chat"][tostring(temp[i])]
		if type(data) == "table" and data[20] ~= nil then
			ChatFrame_MessageEventHandler(DEFAULT_CHAT_FRAME, data[20], unpack(data))
		end
	end
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end 

function PLUGIN:AppendBankFunctions()
	local BAGS = SV.SVBag;
	if(BAGS.BankFrame) then
		BAGS.BankFrame.RefreshBagsSlots = RefreshLoggedBagsSlots
	end
end

function PLUGIN:AppendChatFunctions()
	if SV.db.SVChat.enable and SV.db[Schema].saveChats then
		for _,event in pairs(LoggingEvents) do
			SV.SVChat:RegisterEvent(event, "LogCurrentChat")
		end
		SV.SVChat:RegisterEvent("PLAYER_ENTERING_WORLD")
	end
end
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
local function ResetAllLogs()
	if LogOMatic_Data[realmKey] then
		if LogOMatic_Data[realmKey]["bags"] and LogOMatic_Data[realmKey]["bags"][nameKey] then LogOMatic_Data[realmKey]["bags"][nameKey] = {} end 
		if LogOMatic_Data[realmKey]["gold"] and LogOMatic_Data[realmKey]["gold"][nameKey] then LogOMatic_Data[realmKey]["gold"][nameKey] = 0 end
	end 
	if LogOMatic_Cache then LogOMatic_Cache = {} end 
end
--[[ 
########################################################## 
BUILD FUNCTION
##########################################################
]]--
function PLUGIN:Load()
	if SVLOG_Data then SVLOG_Data = nil end
	if SVLOG_Cache then SVLOG_Cache = nil end
	
	if IsAddOnLoaded("Altoholic") or not SV.db[Schema].enable then return end
	
	local toonClass = select(2,UnitClass("player"));
	local r,g,b = RAID_CLASS_COLORS[toonClass].r, RAID_CLASS_COLORS[toonClass].g, RAID_CLASS_COLORS[toonClass].b
	local hexString = ("|cff%02x%02x%02x"):format(r * 255, g * 255, b * 255)
	if not LogOMatic_Cache then LogOMatic_Cache = {} end
	LogOMatic_Data = LogOMatic_Data or {}
	LogOMatic_Data[realmKey] = LogOMatic_Data[realmKey] or {}
	LogOMatic_Data[realmKey]["bags"] = LogOMatic_Data[realmKey]["bags"] or {};
	LogOMatic_Data[realmKey]["info"] = LogOMatic_Data[realmKey]["info"] or {};
	LogOMatic_Data[realmKey]["info"][nameKey] = hexString;
	LogOMatic_Data[realmKey]["bags"][nameKey] = LogOMatic_Data[realmKey]["bags"][nameKey] or {};

	self.stash = LogOMatic_Data[realmKey]["bags"];
	self.myStash = LogOMatic_Data[realmKey]["bags"][nameKey];

	LogOMatic_Data[realmKey]["quests"] = LogOMatic_Data[realmKey]["quests"] or {};
	LogOMatic_Data[realmKey]["quests"][nameKey] = LogOMatic_Data[realmKey]["quests"][nameKey] or {};

	self.chronicle = LogOMatic_Data[realmKey]["quests"][nameKey];

	NewHook(SV, "ResetAllUI", ResetAllLogs);

	if not LogOMatic_Cache["chat"] then LogOMatic_Cache["chat"] = {} end 
	
	for alt,_ in pairs(LogOMatic_Data[realmKey]["bags"]) do
		for bag,items in pairs(LogOMatic_Data[realmKey]["bags"][alt]) do
			for id,amt in pairs(items) do
				self.BagItemCache[id] = self.BagItemCache[id] or {}
				self.BagItemCache[id][alt] = amt
			end
		end
	end

	--[[ OVERRIDE DEFAULT FUNCTIONS ]]--
	if SV.db.SVBag.enable then
		local BAGS = SV.SVBag;
		if BAGS.BagFrame then
			BAGS.BagFrame.RefreshBagsSlots = RefreshLoggedBagsSlots;
			NewHook(BAGS, "MakeBankOrReagent", self.AppendBankFunctions);
			RefreshLoggedBagsSlots(BAGS.BagFrame)
		end
	end
	if SV.db.SVTip.enable then
		GameTooltip:HookScript("OnTooltipSetItem", GameTooltip_LogTooltipSetItem)
	end

	--[[ APPLY HOOKS ]]--
	self:AppendChatFunctions()
	NewHook(CHAT, "ReLoad", self.AppendChatFunctions)

	local saveChats = {
		order = 2, 
		type = "toggle", 
		name = L["Save Chats"], 
		desc = L["Retain chat messages even after logging out."],
		get = function(a)return SV.db[Schema].saveChats end, 
		set = function(a,b) SV.db[Schema].saveChats = b; SV:StaticPopup_Show("RL_CLIENT") end
	}
	self:AddOption("saveChats", saveChats)
end