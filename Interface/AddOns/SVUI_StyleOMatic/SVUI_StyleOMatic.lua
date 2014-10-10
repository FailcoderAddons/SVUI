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
local tostring 	= _G.tostring;
local print 	= _G.print;
local pcall 	= _G.pcall;
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
local IsAddOnLoaded = _G.IsAddOnLoaded;
local LoadAddOn = _G.LoadAddOn;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local PLUGIN = select(2, ...)
local Schema = PLUGIN.Schema;
local VERSION = PLUGIN.Version;

local SV = _G.SVUI
local L = SV.L
local NewHook = hooksecurefunc;
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
	if not SV.db[Schema].addons then return end
	for i = 1, select('#', ...) do
		local a = select(i, ...)
		if not a then break end
		if not IsAddOnLoaded(a) then return false end
	end

	return SV.db[Schema].addons[addon]
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
	if(SV.db[Schema].addons and SV.db[Schema].addons[addon] == nil) then
		SV.db[Schema].addons[addon] = true
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

function PLUGIN:PLAYER_ENTERING_WORLD(event, ...)
	for addonName,fn in pairs(self.OnLoadAddons) do
		if(SV.db[Schema].blizzard[addonName] == nil) then
			SV.db[Schema].blizzard[addonName] = true
		end
		if(IsAddOnLoaded(addonName) and (SV.db[Schema].blizzard[addonName] or SV.db[Schema].addons[addonName])) then 
			self:Style(addonName, fn, event, ...)
			self.OnLoadAddons[addonName] = nil
		end 
	end

	for _,fn in pairs(self.CustomQueue)do 
		fn(event, ...)
	end

	twipe(self.CustomQueue)

	local listener = self.EventListeners[event]
	for addonName,fn in pairs(self.AddOnQueue)do
		if(not SV.Options.args.plugins.args.pluginOptions.args[Schema].args["addons"].args[addonName]) then
			SV.Options.args.plugins.args.pluginOptions.args[Schema].args["addons"].args[addonName] = {
				type = "toggle",
				name = addonName,
				desc = L["Addon Styling"],
				get = function(key) return PLUGIN:IsAddonReady(key[#key]) end,
				set = function(key,value) PLUGIN:ChangeDBVar(value, key[#key], "addons"); SV:StaticPopup_Show("RL_CLIENT") end,
				disabled = function()
					if addonName then
						 return not IsAddOnLoaded(addonName)
					else
						 return false 
					end 
				end
			}
		end
		if(SV.db[Schema].addons[addonName] == nil) then
			SV.db[Schema].addons[addonName] = true
		end
		if(listener[addonName] and self:IsAddonReady(addonName)) then
			self:Style(addonName, fn, event, ...)
		end 
	end
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
	if(not SV.db[Schema].enable) then return end

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
	alert.Accept.Text:SetText(_G.YES);
	alert.Close = CreateFrame('Button', nil, alert);
	alert.Close:SetSize(70, 25);
	alert.Close:SetPoint('LEFT', alert, 'BOTTOM', 10, 20);
	alert.Close:SetScript('OnClick', function(this) this:GetParent():Hide() end);
	alert.Close.Text = alert.Close:CreateFontString(nil, "OVERLAY");
	alert.Close.Text:SetFont(SV.Media.font.default, 10);
	alert.Close.Text:SetPoint('CENTER');
	alert.Close.Text:SetText(_G.NO);
	alert.Accept:SetButtonTemplate();
	alert.Close:SetButtonTemplate();
	alert:Hide();
	self.Alert = alert;

	NewHook(SV, "ReloadDocklets", RegisterAddonDocklets);
	SV:ReloadDocklets();

	self:RegisterEvent("PLAYER_ENTERING_WORLD");
	self:RegisterEvent("ADDON_LOADED");
end