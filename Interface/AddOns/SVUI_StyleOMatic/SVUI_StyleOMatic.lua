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
local format,find = string.format, string.find;
--[[ MATH METHODS ]]--
local floor = math.floor;
--[[ TABLE METHODS ]]--
local twipe, tcopy = table.wipe, table.copy;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SVUIAddOnName, PLUGIN = ...;
local SV = _G.SVUI
local SVLib = LibStub("LibSuperVillain-1.0")
local L = SVLib:Lang()
local NewHook = hooksecurefunc;

PLUGIN = SVLib:NewPrototype(SVUIAddOnName)
local Schema = PLUGIN.Schema;
local VERSION = PLUGIN.Version;

_G["StyleVillain"] = PLUGIN;
--[[ 
########################################################## 
CORE DATA
##########################################################
]]--
PLUGIN.DockedParent = {}
PLUGIN.AddOnQueue = {};
PLUGIN.AddOnEvents = {};
PLUGIN.CustomQueue = {};
PLUGIN.EventListeners = {};
PLUGIN.OnLoadAddons = {};
PLUGIN.StyledAddons = {};
PLUGIN.OptionsCache = {
	order = 4, 
	type = "group", 
	name = "Addon Styling", 
	get = function(a)return PLUGIN.db.addons[a[#a]] end, 
	set = function(a,b) PLUGIN.db.addons[a[#a]] = b; SV:StaticPopup_Show("RL_CLIENT")end,
	disabled = function()return not PLUGIN.db.addons.enable end,
	guiInline = true, 
	args = {
		ace3 = {
			type = "toggle",
			order = 1,
			name = "Ace3"
		},
	}
}
PLUGIN.Debugging = false
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
local charming = {"Spiffy", "Pimped Out", "Fancy", "Awesome", "Bad Ass", "Sparkly", "Gorgeous", "Handsome", "Shiny"}
local errorMessage = '%s: |cffff0000There was an error in the|r |cff0affff%s|r |cffff0000skin|r. |cffFF0000[[|r%s|cffFF0000]]|r'
local styleMessage = '|cff00FF77%s|r Is Now %s!'

local function SendAddonMessage(msg, prefix)
	if(type(msg) == "table") then 
        msg = tostring(msg) 
    end

    if(not msg) then return end

    if(prefix) then
    	local outbound = ("%s %s"):format(prefix, msg);
    	print(outbound)
    else
    	print(msg)
    end
end

function PLUGIN:AddonMessage(msg) 
    local outbound = ("|cffFF2F00%s:|r"):format("Style-O-Matic")
    SendAddonMessage(msg, outbound) 
end

function PLUGIN:LoadAlert(MainText, Function)
	self.Alert.Text:SetText(MainText)
	self.Alert.Accept:SetScript('OnClick', Function)
	self.Alert:Show()
end

function PLUGIN:Style(style, fn, ...)
	local pass, error = pcall(fn, ...)
	if(self.Debugging and error) then
		SV:Debugger(errorMessage:format(VERSION, style, error))
		return
	end
	if(pass and (not style:find("Blizzard")) and not self.StyledAddons[style]) then
		self.StyledAddons[style] = true
		local verb = charming[math.random(1,#charming)]
		self:AddonMessage(styleMessage:format(style, verb))
	end
	self.Debugging = false
end

function PLUGIN:IsAddonReady(addon, ...)
	if not self.db.addons then return end
	for i = 1, select('#', ...) do
		local a = select(i, ...)
		if not a then break end
		if not IsAddOnLoaded(a) then return false end
	end

	return self.db.addons[addon]
end

function PLUGIN:SaveAddonStyle(addon, fn, force, passive, ...)
	self:DefineEventFunction("PLAYER_ENTERING_WORLD", addon)
	if(passive) then
		self:DefineEventFunction("ADDON_LOADED", addon)
	end
	for i=1, select("#",...) do 
		local event = select(i,...)
		if(event) then
			self:DefineEventFunction(event, addon)
		end  
	end
	if(self.db.addons and self.db.addons[addon] == nil) then
		self.db.addons[addon] = true
	end

	if force then
		fn()
	else
		self.AddOnQueue[addon] = fn
	end
end 

function PLUGIN:SaveBlizzardStyle(addon, fn, force)
	if force then 
		if(not IsAddOnLoaded(addon)) then
			LoadAddOn(addon)
		end
		fn()
	else
		self.OnLoadAddons[addon] = fn
	end
end 

function PLUGIN:SaveCustomStyle(fn)
	tinsert(PLUGIN.CustomQueue, fn)
end 

function PLUGIN:DefineEventFunction(addonEvent, addon)
	if(not addon) then return end
	if(not self.EventListeners[addonEvent]) then
		self.EventListeners[addonEvent] = {}
	end
	self.EventListeners[addonEvent][addon] = true
	if(not self[addonEvent]) then
		self[addonEvent] = function(self, event, ...)
			for name,fn in pairs(self.AddOnQueue) do 
				if self:IsAddonReady(name) and self.EventListeners[event] and self.EventListeners[event][name] then
					self:Style(name, fn, event, ...)
				end 
			end 
		end 
		self:RegisterEvent(addonEvent);
	end
end

function PLUGIN:SafeEventRemoval(addon, event)
	if not self.EventListeners[event] then return end 
	if not self.EventListeners[event][addon] then return end 
	self.EventListeners[event][addon] = nil;
	local defined = false;
	for name,_ in pairs(self.EventListeners[event]) do 
		if name then
			defined = true;
			break 
		end 
	end 
	if not defined then 
		self:UnregisterEvent(event) 
	end 
end 

function PLUGIN:RefreshAddonStyles()
	for addon,fn in pairs(self.AddOnQueue) do
		if(self:IsAddonReady(addon)) then
			self:Style(addon, fn)
		end
	end
end

function PLUGIN:AppendAddonOption(addon)
	if(not self.OptionsCache.args[addon]) then
		self.OptionsCache.args[addon] = {
			type = "toggle",
			name = addon,
			desc = L["Addon Styling"],
			get = function(key) return self:IsAddonReady(key[#key]) end,
			set = function(key,value) self:ChangeDBVar(value, key[#key], "addons"); SV:StaticPopup_Show("RL_CLIENT") end,
			disabled = function()
				if addon then
					 return not IsAddOnLoaded(addon)
				else
					 return false 
				end 
			end
		}
	end
end

function PLUGIN:PLAYER_ENTERING_WORLD(event, ...)
	for name,fn in pairs(self.OnLoadAddons) do
		if(self.db.blizzard[name] == nil) then
			self.db.blizzard[name] = true
		end
		if(IsAddOnLoaded(name) and (self.db.blizzard[name] or self.db.addons[name])) then 
			self:Style(name, fn, event, ...)
			self.OnLoadAddons[name] = nil
		end 
	end

	for _,fn in pairs(self.CustomQueue)do 
		fn(event, ...)
	end

	twipe(self.CustomQueue)

	local listener = self.EventListeners[event]
	for name,fn in pairs(self.AddOnQueue)do
		self:AppendAddonOption(name)
		if(self.db.addons[name] == nil) then
			self.db.addons[name] = true
		end
		if(listener[name] and self:IsAddonReady(name)) then
			self:Style(name, fn, event, ...)
		end 
	end

	collectgarbage("collect")
end

function PLUGIN:ADDON_LOADED(event, addon)
	-- print(addon)
	for name, fn in pairs(self.OnLoadAddons) do
		if(addon:find(name)) then
			self:Style(name, fn, event, addon)
			self.OnLoadAddons[name] = nil
		end
	end

	local listener = self.EventListeners[event]
	if(listener) then
		for name, fn in pairs(self.AddOnQueue) do 
			if(listener[name] and self:IsAddonReady(name)) then
				self:Style(name, fn, event, addon)
			end 
		end
	end
end
--[[ 
########################################################## 
OPTIONS CREATION
##########################################################
]]--
local RegisterAddonDocklets = function()
	local MAIN = _G["SuperDockletMain"];
	local EXTRA = _G["SuperDockletExtra"];
	local main = SV.db.SVDock.docklets.DockletMain;
  	local alternate = SV.db.SVDock.docklets.enableExtra and SV.db.SVDock.docklets.DockletExtra or "";
  	local tipLeft, tipRight = "", "";
  	if main == nil or main == "None" then return end 
  	
	if find(main, "Skada") or find(alternate, "Skada") then
		if SV:IsDockletReady("Skada") then
			PLUGIN:Docklet_Skada()
			if find(alternate, "Skada") and EXTRA.FrameName  ~= "SkadaHolder2" then
				tipRight = "and Skada";
				SV:RegisterExtraDocklet("SkadaHolder2")
				--PLUGIN.DockedParent["Skada"] = EXTRA
			end
			if find(main, "Skada") and MAIN.FrameName  ~= "SkadaHolder" then
				tipLeft = "Skada";
				SV:RegisterMainDocklet("SkadaHolder")
				--PLUGIN.DockedParent["Skada"] = MAIN
			end
		end 
	end 
	if main == "Omen" or alternate == "Omen" then
		if SV:IsDockletReady("Omen") then
			if alternate == "Omen" and EXTRA.FrameName ~= "OmenAnchor" then
				tipRight = "and Omen";
				SV:RegisterExtraDocklet("OmenAnchor")
				PLUGIN:Docklet_Omen(EXTRA)
				PLUGIN.DockedParent["Omen"] = EXTRA
			elseif MAIN.FrameName ~= "OmenAnchor" then
				tipLeft = "Omen";
				SV:RegisterMainDocklet("OmenAnchor")
				PLUGIN:Docklet_Omen(MAIN)
				PLUGIN.DockedParent["Omen"] = MAIN
			end
		end 
	end 
	if main == "Recount" or alternate == "Recount" then
		if SV:IsDockletReady("Recount") then
			if alternate == "Recount" and EXTRA.FrameName ~= "Recount_MainWindow" then
				tipRight = "and Recount";
				SV:RegisterExtraDocklet("Recount_MainWindow")
				PLUGIN:Docklet_Recount(EXTRA)
				PLUGIN.DockedParent["Recount"] = EXTRA
			elseif MAIN.FrameName ~= "Recount_MainWindow" then
				tipLeft = "Recount";
				SV:RegisterMainDocklet("Recount_MainWindow")
				PLUGIN:Docklet_Recount(MAIN)
				PLUGIN.DockedParent["Recount"] = MAIN
			end
		end 
	end 
	if main == "TinyDPS" or alternate == "TinyDPS" then
		if SV:IsDockletReady("TinyDPS") then
			if alternate == "TinyDPS" and EXTRA.FrameName ~= "tdpsFrame" then
				tipRight = "and TinyDPS";
				SV:RegisterExtraDocklet("tdpsFrame")
				PLUGIN:Docklet_TinyDPS(EXTRA)
				PLUGIN.DockedParent["TinyDPS"] = EXTRA
			elseif MAIN.FrameName ~= "tdpsFrame" then
				tipLeft = "TinyDPS";
				SV:RegisterMainDocklet("tdpsFrame")
				PLUGIN:Docklet_TinyDPS(MAIN)
				PLUGIN.DockedParent["TinyDPS"] = MAIN
			end
		end 
	end 
	if main == "alDamageMeter" or alternate == "alDamageMeter" then
		if SV:IsDockletReady("alDamageMeter") then
			if alternate == "alDamageMeter" and EXTRA.FrameName ~= "alDamagerMeterFrame" then
				tipRight = "and alDamageMeter";
				SV:RegisterExtraDocklet("alDamagerMeterFrame")
				PLUGIN:Docklet_alDamageMeter(EXTRA)
				PLUGIN.DockedParent["alDamageMeter"] = EXTRA
			elseif MAIN.FrameName ~= "alDamagerMeterFrame" then
				tipLeft = "alDamageMeter";
				SV:RegisterMainDocklet("alDamagerMeterFrame")
				PLUGIN:Docklet_alDamageMeter(MAIN)
				PLUGIN.DockedParent["alDamageMeter"] = MAIN
			end
		end 
	end 

	if(_G["SVUI_AddonDocklet"]) then
		_G["SVUI_AddonDocklet"].TText = ("%s%s"):format(tipLeft, tipRight)
	end
end 
--[[ 
########################################################## 
BUILD FUNCTION
##########################################################
]]--
function PLUGIN:Load()
	if(not self.db.enable) then return end

	local alert = CreateFrame('Frame', nil, UIParent);
	alert:SetFixedPanelTemplate('Transparent');
	alert:SetSize(250, 70);
	alert:SetPoint('CENTER', UIParent, 'CENTER');
	alert:SetFrameStrata('DIALOG');
	alert.Text = alert:CreateFontString(nil, "OVERLAY");
	alert.Text:SetFont(SV.Media.font.default, 12);
	alert.Text:SetPoint('TOP', alert, 'TOP', 0, -10);
	alert.Accept = CreateFrame('Button', nil, alert);
	alert.Accept:SetSize(70, 25);
	alert.Accept:SetPoint('RIGHT', alert, 'BOTTOM', -10, 20);
	alert.Accept.Text = alert.Accept:CreateFontString(nil, "OVERLAY");
	alert.Accept.Text:SetFont(SV.Media.font.default, 10);
	alert.Accept.Text:SetPoint('CENTER');
	alert.Accept.Text:SetText(YES);
	alert.Close = CreateFrame('Button', nil, alert);
	alert.Close:SetSize(70, 25);
	alert.Close:SetPoint('LEFT', alert, 'BOTTOM', 10, 20);
	alert.Close:SetScript('OnClick', function(this) this:GetParent():Hide() end);
	alert.Close.Text = alert.Close:CreateFontString(nil, "OVERLAY");
	alert.Close.Text:SetFont(SV.Media.font.default, 10);
	alert.Close.Text:SetPoint('CENTER');
	alert.Close.Text:SetText(NO);
	alert.Accept:SetButtonTemplate();
	alert.Close:SetButtonTemplate();
	alert:Hide();
	self.Alert = alert;

	NewHook(SV, "ReloadDocklets", RegisterAddonDocklets);
	SV:ReloadDocklets();
	SV.DynamicOptions[Schema] = {key = "addons", data = self.OptionsCache};

	local option = {
		order = 2, 
		type = "toggle", 
		name = "Standard UI Styling", 
		get = function(a)return self.db.blizzard.enable end, 
		set = function(a,b) self.db.blizzard.enable = b; SV:StaticPopup_Show("RL_CLIENT") end
	}
	self:AddOption("blizzardEnable", option)

	option = {
		order = 3, 
		type = "toggle", 
		name = "Addon Styling", 
		get = function(a)return self.db.addons.enable end, 
		set = function(a,b) self.db.addons.enable = b; SV:StaticPopup_Show("RL_CLIENT") end
	}
	self:AddOption("addonEnable", option)

	option = {
		order = 300, 
		type = "group", 
		name = "Individual Mods", 
		get = function(a)return self.db.blizzard[a[#a]]end, 
		set = function(a,b) self.db.blizzard[a[#a]] = b; SV:StaticPopup_Show("RL_CLIENT") end, 
		disabled = function() return not self.db.blizzard.enable end, 
		guiInline = true, 
		args = {
			bmah = {
				type = "toggle", 
				name = L["Black Market AH"], 
				desc = L["TOGGLEART_DESC"]
			},
			chat = {
				type = "toggle", 
				name = L["Chat Menus"], 
				desc = L["TOGGLEART_DESC"]
			},
			transmogrify = {
				type = "toggle", 
				name = L["Transmogrify Frame"], 
				desc = L["TOGGLEART_DESC"]
			},
			encounterjournal = {
				type = "toggle", 
				name = L["Encounter Journal"], 
				desc = L["TOGGLEART_DESC"]
			},
			reforge = {
				type = "toggle", 
				name = L["Reforge Frame"], 
				desc = L["TOGGLEART_DESC"]
			},
			calendar = {
				type = "toggle", 
				name = L["Calendar Frame"], 
				desc = L["TOGGLEART_DESC"]
			},
			achievement = {
				type = "toggle", 
				name = L["Achievement Frame"], 
				desc = L["TOGGLEART_DESC"]
			},
			lfguild = {
				type = "toggle", 
				name = L["LF Guild Frame"], 
				desc = L["TOGGLEART_DESC"]
			},
			inspect = {
				type = "toggle", 
				name = L["Inspect Frame"], 
				desc = L["TOGGLEART_DESC"]
			},
			binding = {
				type = "toggle", 
				name = L["KeyBinding Frame"], 
				desc = L["TOGGLEART_DESC"]
			},
			gbank = {
				type = "toggle", 
				name = L["Guild Bank"], 
				desc = L["TOGGLEART_DESC"]
			},
			archaeology = {
				type = "toggle", 
				name = L["Archaeology Frame"], 
				desc = L["TOGGLEART_DESC"]
			},
			guildcontrol = {
				type = "toggle", 
				name = L["Guild Control Frame"], 
				desc = L["TOGGLEART_DESC"]
			},
			guild = {
				type = "toggle", 
				name = L["Guild Frame"], 
				desc = L["TOGGLEART_DESC"]
			},
			tradeskill = {
				type = "toggle", 
				name = L["TradeSkill Frame"], 
				desc = L["TOGGLEART_DESC"]
			},
			raid = {
				type = "toggle", 
				name = L["Raid Frame"], 
				desc = L["TOGGLEART_DESC"]
			},
			talent = {
				type = "toggle", 
				name = L["Talent Frame"], 
				desc = L["TOGGLEART_DESC"]
			},
			auctionhouse = {
				type = "toggle", 
				name = L["Auction Frame"], 
				desc = L["TOGGLEART_DESC"]
			},
			timemanager = {
				type = "toggle", 
				name = L["Time Manager"], 
				desc = L["TOGGLEART_DESC"]
			},
			barber = {
				type = "toggle", 
				name = L["Barbershop Frame"], 
				desc = L["TOGGLEART_DESC"]
			},
			macro = {
				type = "toggle", 
				name = L["Macro Frame"], 
				desc = L["TOGGLEART_DESC"]
			},
			debug = {
				type = "toggle", 
				name = L["Debug Tools"], 
				desc = L["TOGGLEART_DESC"]
			},
			trainer = {
				type = "toggle", 
				name = L["Trainer Frame"], 
				desc = L["TOGGLEART_DESC"]
			},
			socket = {
				type = "toggle", 
				name = L["Socket Frame"], 
				desc = L["TOGGLEART_DESC"]
			},
			alertframes = {
				type = "toggle", 
				name = L["Alert Frames"], 
				desc = L["TOGGLEART_DESC"]
			},
			loot = {
				type = "toggle", 
				name = L["Loot Frames"], 
				desc = L["TOGGLEART_DESC"]
			},
			bgscore = {
				type = "toggle", 
				name = L["BG Score"], 
				desc = L["TOGGLEART_DESC"]
			},
			merchant = {
				type = "toggle", 
				name = L["Merchant Frame"], 
				desc = L["TOGGLEART_DESC"]
			},
			mail = {
				type = "toggle", 
				name = L["Mail Frame"], 
				desc = L["TOGGLEART_DESC"]
			},
			help = {
				type = "toggle", 
				name = L["Help Frame"], 
				desc = L["TOGGLEART_DESC"]
			},
			trade = {
				type = "toggle", 
				name = L["Trade Frame"], 
				desc = L["TOGGLEART_DESC"]
			},
			gossip = {
				type = "toggle", 
				name = L["Gossip Frame"], 
				desc = L["TOGGLEART_DESC"]
			},
			greeting = {
				type = "toggle", 
				name = L["Greeting Frame"], 
				desc = L["TOGGLEART_DESC"]
			},
			worldmap = {
				type = "toggle", 
				name = L["World Map"], 
				desc = L["TOGGLEART_DESC"]
			},
			taxi = {
				type = "toggle", 
				name = L["Taxi Frame"], 
				desc = L["TOGGLEART_DESC"]
			},
			lfg = {
				type = "toggle", 
				name = L["LFG Frame"], 
				desc = L["TOGGLEART_DESC"]
			},
			mounts = {
				type = "toggle", 
				name = L["Mounts & Pets"], 
				desc = L["TOGGLEART_DESC"]
			},
			quest = {
				type = "toggle", 
				name = L["Quest Frames"], 
				desc = L["TOGGLEART_DESC"]
			},
			petition = {
				type = "toggle", 
				name = L["Petition Frame"], 
				desc = L["TOGGLEART_DESC"]
			},
			dressingroom = {
				type = "toggle", 
				name = L["Dressing Room"], 
				desc = L["TOGGLEART_DESC"]
			},
			pvp = {
				type = "toggle", 
				name = L["PvP Frames"], 
				desc = L["TOGGLEART_DESC"]
			},
			nonraid = {
				type = "toggle", 
				name = L["Non-Raid Frame"], 
				desc = L["TOGGLEART_DESC"]
			},
			friends = {
				type = "toggle", 
				name = L["Friends"], 
				desc = L["TOGGLEART_DESC"]
			},
			spellbook = {
				type = "toggle", 
				name = L["Spellbook"], 
				desc = L["TOGGLEART_DESC"]
			},
			character = {
				type = "toggle", 
				name = L["Character Frame"], 
				desc = L["TOGGLEART_DESC"]
			},
			misc = {
				type = "toggle", 
				name = L["Misc Frames"], 
				desc = L["TOGGLEART_DESC"]
			},
			tabard = {
				type = "toggle", 
				name = L["Tabard Frame"], 
				desc = L["TOGGLEART_DESC"]
			},
			guildregistrar = {
				type = "toggle", 
				name = L["Guild Registrar"], 
				desc = L["TOGGLEART_DESC"]
			},
			bags = {
				type = "toggle", 
				name = L["Bags"], 
				desc = L["TOGGLEART_DESC"]
			},
			stable = {
				type = "toggle", 
				name = L["Stable"], 
				desc = L["TOGGLEART_DESC"]
			},
			bgmap = {
				type = "toggle", 
				name = L["BG Map"], 
				desc = L["TOGGLEART_DESC"]
			},
			petbattleui = {
				type = "toggle", 
				name = L["Pet Battle"], 
				desc = L["TOGGLEART_DESC"]
			},
			losscontrol = {
				type = "toggle", 
				name = L["Loss Control"], 
				desc = L["TOGGLEART_DESC"]
			},
			voidstorage = {
				type = "toggle", 
				name = L["Void Storage"], 
				desc = L["TOGGLEART_DESC"]
			},
			itemUpgrade = {
				type = "toggle", 
				name = L["Item Upgrade"], 
				desc = L["TOGGLEART_DESC"]
			}
		}
	}
	self:AddOption("blizzard", option)
	self:AddOption("addons", self.OptionsCache)

	self:RegisterEvent("PLAYER_ENTERING_WORLD");
	self:RegisterEvent("ADDON_LOADED");
end

SV.configs[Schema] = {
	["enable"] = true,
	["blizzard"] = {
		["enable"] = true, 
		["bags"] = true, 
		["bmah"] = true,
		["chat"] = true, 
		["reforge"] = true, 
		["calendar"] = true, 
		["achievement"] = true, 
		["lfguild"] = true, 
		["inspect"] = true, 
		["binding"] = true, 
		["gbank"] = true, 
		["archaeology"] = true, 
		["guildcontrol"] = true, 
		["gossip"] = true, 
		["guild"] = true, 
		["tradeskill"] = true, 
		["raid"] = false, 
		["talent"] = true, 
		["auctionhouse"] = true, 
		["barber"] = true, 
		["macro"] = true, 
		["debug"] = true, 
		["trainer"] = true, 
		["socket"] = true, 
		["loot"] = true, 
		["alertframes"] = true, 
		["bgscore"] = true, 
		["merchant"] = true, 
		["mail"] = true, 
		["help"] = true, 
		["trade"] = true, 
		["gossip"] = true, 
		["greeting"] = true, 
		["worldmap"] = true, 
		["taxi"] = true, 
		["quest"] = true, 
		["petition"] = true, 
		["dressingroom"] = true, 
		["pvp"] = true, 
		["lfg"] = true, 
		["nonraid"] = true, 
		["friends"] = true, 
		["spellbook"] = true, 
		["character"] = true, 
		["misc"] = true, 
		["tabard"] = true, 
		["guildregistrar"] = true, 
		["timemanager"] = true, 
		["encounterjournal"] = true, 
		["voidstorage"] = true, 
		["transmogrify"] = true, 
		["stable"] = true, 
		["bgmap"] = true, 
		["mounts"] = true, 
		["petbattleui"] = true, 
		["losscontrol"] = true, 
		["itemUpgrade"] = true, 
	}, 
	["addons"] = {
		["enable"] = true,
		["Skada"] = true, 
		["Recount"] = true,
		["AuctionLite"] = true,  
		["AtlasLoot"] = true, 
		["SexyCooldown"] = true, 
		["Lightheaded"] = true, 
		["Outfitter"] = true,
		["Quartz"] = true, 
		["TomTom"] = true, 
		["TinyDPS"] = true, 
		["Clique"] = true, 
		["CoolLine"] = true, 
		["ACP"] = true, 
		["DXE"] = true,
		["DBM-Core"] = true,
		["VEM"] = true,
		["MogIt"] = true, 
		["alDamageMeter"] = true, 
		["Omen"] = true, 
		["TradeSkillDW"] = true, 
	}
};

SVLib:NewPlugin(PLUGIN)