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
local SuperVillain, L = unpack(SVUI);
local AddOnName, AddOnObject = ...;

local MOD = SVUI_LIB:SetObject(AddOnName);
local DOCK = SuperVillain.Registry:Expose('SVDock');
local SuperDockWindow = _G["SuperDockWindow"];
local SuperDockletMain = _G["SuperDockletMain"];
local SuperDockletExtra = _G["SuperDockletExtra"];
local NewHook = hooksecurefunc;
--[[ 
########################################################## 
CORE DATA
##########################################################
]]--
MOD.DockedParent = {}
MOD.AddOnQueue = {};
MOD.AddOnEvents = {};
MOD.BlizzardQueue = {};
MOD.CustomQueue = {};
MOD.EventListeners = {};
MOD.PassiveAddons = {};
MOD.OptionsCache = {
	order = 4, 
	type = "group", 
	name = "Addon Styling", 
	get = function(a)return SuperVillain.db.SVStyle.addons[a[#a]] end, 
	set = function(a,b)SuperVillain.db.SVStyle.addons[a[#a]] = b;SuperVillain:StaticPopup_Show("RL_CLIENT")end,
	disabled = function()return not SuperVillain.db.SVStyle.addons.enable end,
	guiInline = true, 
	args = {
		ace3 = {
			type = "toggle",
			order = 1,
			name = "Ace3"
		},
	}
};
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
function MOD:LoadAlert(MainText, Function)
	MOD.Alert.Text:SetText(MainText)
	MOD.Alert.Accept:SetScript('OnClick', Function)
	MOD.Alert:Show()
end

function MOD:ADDON_LOADED(_, addon)
	if MOD.PassiveAddons[addon] then 
		MOD.BlizzardQueue[addon]()
		MOD.BlizzardQueue[addon] = nil;
		return 
	end;
	if not SuperVillain.CoreEnabled or not MOD.BlizzardQueue[addon] then return end;
	MOD.BlizzardQueue[addon]()
	MOD.BlizzardQueue[addon] = nil 
end;

function MOD:IsAddonReady(this, ...)
	for i = 1, select('#', ...) do
		local a = select(i, ...)
		if not a then break end
		if not IsAddOnLoaded(a) then return false end
	end
	return SuperVillain.db.SVStyle.addons[this]
end

function MOD:SaveAddonStyle(addon, fn, force, passive, ...)
	local args,hasEvent = {},false;
	for i=1, select("#",...) do 
		local event = select(i,...)
		if event then
			args[event] = true
			hasEvent = true;
		end; 
	end;
	if passive then MOD.PassiveAddons[addon] = true end;
	if not MOD.AddOnEvents[addon] then 
		MOD.AddOnEvents[addon] = {};
		MOD.AddOnEvents[addon]["complete"] = false;
		if hasEvent then
			MOD.AddOnEvents[addon]["events"] = args;
		end
	end
	if force then 
		fn()
		MOD.AddOnQueue[addon] = nil
	else 
		MOD.AddOnQueue[addon] = fn 
	end
end;

function MOD:SaveBlizzardStyle(addon, fn, force, passive, preload)
	if passive then MOD.PassiveAddons[addon] = true end;
	if force then 
		if(preload and not IsAddOnLoaded(addon)) then
			LoadAddOn(addon)
		end
		fn()
		MOD.BlizzardQueue[addon] = nil
	else 
		MOD.BlizzardQueue[addon] = fn 
	end
end;

function MOD:SaveCustomStyle(fn)
	tinsert(MOD.CustomQueue, fn)
end;

function MOD:DefineEventFunction(event,addon)
	if not self[event] then
		self[event] = function(self, event, ...)
			for addon,fn in pairs(self.AddOnQueue)do 
				if self:IsAddonReady(addon) and self.EventListeners[event][addon] then 
					local t = {}
					for i=1,select('#',...)do 
						local arg = select(i,...)
						if arg then tinsert(t,arg) end;
					end;
					local _,error = pcall(fn, self, event, unpack(t)) 
				end 
			end 
		end;
		self:RegisterEvent(event);
	end
	if addon then
		self.EventListeners[event][addon] = true
	end
end

function MOD:SafeEventRemoval(addon,event)
	if not self.EventListeners[event] then return end;
	if not self.EventListeners[event][addon] then return end;
	self.EventListeners[event][addon] = nil;
	local defined = false;
	for name,_ in pairs(self.EventListeners[event]) do 
		if name then
			defined = true;
			break 
		end 
	end;
	if not defined then 
		self:UnregisterEvent(event) 
	end 
end;

function MOD:RefreshAddonStyles()
	for addon,fn in pairs(self.AddOnQueue) do
		if(SuperVillain.db.SVStyle.addons[addon] == true) then
			if IsAddOnLoaded(addon) then 
				local _,error = pcall(fn, self, "PLAYER_ENTERING_WORLD")
			end
		end
	end
end

function MOD:LoadStyles()
	for addon,fn in pairs(self.BlizzardQueue) do
		if IsAddOnLoaded(addon) then 
			fn()
			self.BlizzardQueue[addon]=nil
		end 
	end;
	for _,fn in pairs(self.CustomQueue)do 
		fn()
	end;
	twipe(self.CustomQueue)
	for addon,fn in pairs(self.AddOnQueue)do
		MOD:AppendAddonOption(addon)
		if IsAddOnLoaded(addon) then
			if(SuperVillain.db.SVStyle.addons[addon] == nil) then
				SuperVillain.db.SVStyle.addons[addon] = true
			end
			if(SuperVillain.db.SVStyle.addons[addon] == true) then
				if(not self.AddOnEvents[addon]["complete"]) then
					if self.AddOnEvents[addon]["events"] then
						for event,_ in pairs(self.AddOnEvents[addon]["events"]) do
							self:DefineEventFunction(event)
						end
					end
					self.AddOnEvents[addon]["complete"] = true
				end
			end
		end 
	end;
	self:RefreshAddonStyles()
end

function MOD:ToggleStyle(addon, value)
	SuperVillain.db.SVStyle.addons[addon] = value
end;
--[[ 
########################################################## 
OPTIONS CREATION
##########################################################
]]--
function MOD:AppendAddonOption(addon)
	MOD.OptionsCache.args[addon] = {
		type = "toggle",
		name = addon,
		desc = L["Addon Styling"],
		get=function(a)return MOD:IsAddonReady(a[#a])end,
		set=function(a,b)SuperVillain.db.SVStyle.addons[a[#a]] = b;SuperVillain:StaticPopup_Show("RL_CLIENT")end,
		disabled = function()
			if addon then
				 return not IsAddOnLoaded(addon)
			else
				 return false 
			end 
		end
	}
end;

function MOD:SetConfigOptions()
	SuperVillain.Options.args.SVStyle={
		type = "group", 
		name = L["UI Styling"], 
		childGroups = "tree", 
		args = {
			intro = {
				order = 1, 
				type = "description", 
				name = L["ART_DESC"]
			},
			blizzardEnable = {
				order = 2, 
				type = "toggle", 
				name = "Standard UI Styling", 
				get = function(a)return SuperVillain.db.SVStyle.blizzard.enable end, 
				set = function(a,b)SuperVillain.db.SVStyle.blizzard.enable = b;SuperVillain:StaticPopup_Show("RL_CLIENT")end
			},
			addonEnable = {
				order = 3, 
				type = "toggle", 
				name = "Addon Styling", 
				get = function(a)return SuperVillain.db.SVStyle.addons.enable end, 
				set = function(a,b)SuperVillain.db.SVStyle.addons.enable = b;SuperVillain:StaticPopup_Show("RL_CLIENT")end
			},
			blizzard = {
				order = 300, 
				type = "group", 
				name = "Individual Mods", 
				get = function(a)return SuperVillain.db.SVStyle.blizzard[a[#a]]end, 
				set = function(a,b)SuperVillain.db.SVStyle.blizzard[a[#a]] = b;SuperVillain:StaticPopup_Show("RL_CLIENT")end, 
				disabled = function()return not SuperVillain.db.SVStyle.blizzard.enable end, 
				guiInline = true, 
				args = {
					bmah = {
						type = "toggle", 
						name = L["Black Market AH"], 
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
			},
			addons = MOD.OptionsCache
		}
	}
end;

local RegisterAddonDocklets = function()
	local main = SuperVillain.db.SVDock.docklets.DockletMain;
  	local alternate = SuperVillain.db.SVDock.docklets.enableExtra and SuperVillain.db.SVDock.docklets.DockletExtra or "";

  	if main == nil or main == "None" then return end;
  	
	if find(main, "Skada") or find(alternate, "Skada") then
		if DOCK:IsDockletReady("Skada") then
			MOD:Docklet_Skada()
			if find(alternate, "Skada") and SuperDockletExtra.FrameName  ~= "SkadaHolder2" then
				DOCK.ExtraToolTip = "Skada";
				DOCK:RegisterExtraDocklet("SkadaHolder2")
				--MOD.DockedParent["Skada"] = SuperDockletExtra
			end
			if find(main, "Skada") and SuperDockletMain.FrameName  ~= "SkadaHolder" then
				DOCK.MainToolTip = "Skada";
				DOCK:RegisterMainDocklet("SkadaHolder")
				--MOD.DockedParent["Skada"] = SuperDockletMain
			end
		end;
	end;
	if main == "Omen" or alternate == "Omen" then
		if DOCK:IsDockletReady("Omen") then
			if alternate == "Omen" and SuperDockletExtra.FrameName ~= "OmenAnchor" then
				DOCK.ExtraToolTip = "Omen";
				DOCK:RegisterExtraDocklet("OmenAnchor")
				MOD:Docklet_Omen(SuperDockletExtra)
				MOD.DockedParent["Omen"] = SuperDockletExtra
			elseif SuperDockletMain.FrameName ~= "OmenAnchor" then
				DOCK.MainToolTip = "Omen";
				DOCK:RegisterMainDocklet("OmenAnchor")
				MOD:Docklet_Omen(SuperDockletMain)
				MOD.DockedParent["Omen"] = SuperDockletMain
			end
		end;
	end;
	if main == "Recount" or alternate == "Recount" then
		if DOCK:IsDockletReady("Recount") then
			if alternate == "Recount" and SuperDockletExtra.FrameName ~= "Recount_MainWindow" then
				DOCK.ExtraToolTip = "Recount";
				DOCK:RegisterExtraDocklet("Recount_MainWindow")
				MOD:Docklet_Recount(SuperDockletExtra)
				MOD.DockedParent["Recount"] = SuperDockletExtra
			elseif SuperDockletMain.FrameName ~= "Recount_MainWindow" then
				DOCK.MainToolTip = "Recount";
				DOCK:RegisterMainDocklet("Recount_MainWindow")
				MOD:Docklet_Recount(SuperDockletMain)
				MOD.DockedParent["Recount"] = SuperDockletMain
			end
		end;
	end;
	if main == "TinyDPS" or alternate == "TinyDPS" then
		if DOCK:IsDockletReady("TinyDPS") then
			if alternate == "TinyDPS" and SuperDockletExtra.FrameName ~= "tdpsFrame" then
				DOCK.ExtraToolTip = "TinyDPS";
				DOCK:RegisterExtraDocklet("tdpsFrame")
				MOD:Docklet_TinyDPS(SuperDockletExtra)
				MOD.DockedParent["TinyDPS"] = SuperDockletExtra
			elseif SuperDockletMain.FrameName ~= "tdpsFrame" then
				DOCK.MainToolTip = "TinyDPS";
				DOCK:RegisterMainDocklet("tdpsFrame")
				MOD:Docklet_TinyDPS(SuperDockletMain)
				MOD.DockedParent["TinyDPS"] = SuperDockletMain
			end
		end;
	end;
	if main == "alDamageMeter" or alternate == "alDamageMeter" then
		if DOCK:IsDockletReady("alDamageMeter") then
			if alternate == "alDamageMeter" and SuperDockletExtra.FrameName ~= "alDamagerMeterFrame" then
				DOCK.ExtraToolTip = "alDamageMeter";
				DOCK:RegisterExtraDocklet("alDamagerMeterFrame")
				MOD:Docklet_alDamageMeter(SuperDockletExtra)
				MOD.DockedParent["alDamageMeter"] = SuperDockletExtra
			elseif SuperDockletMain.FrameName ~= "alDamagerMeterFrame" then
				DOCK.MainToolTip = "alDamageMeter";
				DOCK:RegisterMainDocklet("alDamagerMeterFrame")
				MOD:Docklet_alDamageMeter(SuperDockletMain)
				MOD.DockedParent["alDamageMeter"] = SuperDockletMain
			end
		end;
	end;
end;
--[[ 
########################################################## 
BUILD FUNCTION
##########################################################
]]--
function MOD:Load()
	local alert = CreateFrame('Frame', nil, UIParent);
	alert:SetFixedPanelTemplate('Transparent');
	alert:SetSize(250, 70);
	alert:SetPoint('CENTER', UIParent, 'CENTER');
	alert:SetFrameStrata('DIALOG');
	alert.Text = alert:CreateFontString(nil, "OVERLAY");
	alert.Text:SetFont(SuperVillain.Media.font.default, 12);
	alert.Text:SetPoint('TOP', alert, 'TOP', 0, -10);
	alert.Accept = CreateFrame('Button', nil, alert);
	alert.Accept:SetSize(70, 25);
	alert.Accept:SetPoint('RIGHT', alert, 'BOTTOM', -10, 20);
	alert.Accept.Text = alert.Accept:CreateFontString(nil, "OVERLAY");
	alert.Accept.Text:SetFont(SuperVillain.Media.font.default, 10);
	alert.Accept.Text:SetPoint('CENTER');
	alert.Accept.Text:SetText(YES);
	alert.Close = CreateFrame('Button', nil, alert);
	alert.Close:SetSize(70, 25);
	alert.Close:SetPoint('LEFT', alert, 'BOTTOM', 10, 20);
	alert.Close:SetScript('OnClick', function(self) self:GetParent():Hide() end);
	alert.Close.Text = alert.Close:CreateFontString(nil, "OVERLAY");
	alert.Close.Text:SetFont(SuperVillain.Media.font.default, 10);
	alert.Close.Text:SetPoint('CENTER');
	alert.Close.Text:SetText(NO);
	alert.Accept:SetButtonTemplate();
	alert.Close:SetButtonTemplate();
	alert:Hide();
	self.Alert = alert;

	self:LoadStyles();
	NewHook(DOCK, "ReloadDocklets", RegisterAddonDocklets);
	DOCK:ReloadDocklets();
	SuperVillain.DynamicOptions["SVStyle"] = {key="addons", data=MOD.OptionsCache};
	self:RegisterEvent('ADDON_LOADED');
end

SuperVillain.Registry:NewPackage(MOD, "SVStyle", "post");
SuperVillain.Registry:NewPlugin(AddOnName, MOD.SetConfigOptions);