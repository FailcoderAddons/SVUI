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
local tostring      = _G.tostring;
local tonumber      = _G.tonumber;

--STRING
local string        = _G.string;
local upper         = string.upper;
local format        = string.format;
local find          = string.find;
local match         = string.match;
local gsub          = string.gsub;
--TABLE
local table 		= _G.table; 
local tinsert       = _G.tinsert;
local tremove       = _G.tremove;
local twipe 		= _G.wipe;
--MATH
local math      	= _G.math;
local min 			= math.min;
local floor         = math.floor
local ceil          = math.ceil
--BLIZZARD API
local GameTooltip          	= _G.GameTooltip;
local InCombatLockdown     	= _G.InCombatLockdown;
local CreateFrame          	= _G.CreateFrame;
local GetTime         		= _G.GetTime;
local GetItemCooldown       = _G.GetItemCooldown;
local GetItemCount         	= _G.GetItemCount;
local GetItemInfo          	= _G.GetItemInfo;
local GetSpellInfo         	= _G.GetSpellInfo;
local IsSpellKnown         	= _G.IsSpellKnown;
local GetProfessions       	= _G.GetProfessions;
local GetProfessionInfo    	= _G.GetProfessionInfo;
local hooksecurefunc     	= _G.hooksecurefunc;
--[[ 
########################################################## 
ADDON
##########################################################
]]--
local SV = select(2, ...)
local L = SV.L;
local SVLib = LibSuperVillain("Registry");
--[[ 
########################################################## 
DOCKING
##########################################################
]]--
local ORDER_TEMP = {};
local ORDER_TEST = {};

local DOCK_LOCATIONS = {
	["BottomLeft"] = {1, "LEFT", true},
	["BottomRight"] = {-1, "RIGHT", true},
	["TopLeft"] = {1, "LEFT", false},
	["TopRight"] = {-1, "RIGHT", false},
};

local STAT_LOCATIONS = {
	["BottomCenter"] = {1, "LEFT", true},
	["TopCenter"] = {1, "LEFT", false},
};

local Dock = SV:NewSubClass("Dock", L["Docks"]);

Dock.Border = {};
Dock.Registration = {};
Dock.Locations = {};

local DOCK_DROPDOWN_OPTIONS = {};

DOCK_DROPDOWN_OPTIONS["BottomLeft"] = { text = "To BottomLeft", func = function(button) Dock.BottomLeft.Bar:Add(button) end };
DOCK_DROPDOWN_OPTIONS["BottomRight"] = { text = "To BottomRight", func = function(button) Dock.BottomRight.Bar:Add(button) end };
DOCK_DROPDOWN_OPTIONS["TopLeft"] = { text = "To TopLeft", func = function(button) Dock.TopLeft.Bar:Add(button) end };
--DOCK_DROPDOWN_OPTIONS["TopRight"] = { text = "To TopRight", func = function(button) Dock.TopRight.Bar:Add(button) end };
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
_G.HideSuperDocks = function(self, button)
	GameTooltip:Hide()
	if(button and IsAltKeyDown()) then
		SV:StaticPopup_Show('RESETDOCKS_CHECK')
	else
		if SV.cache.Docks.IsFaded then 
			SV.cache.Docks.IsFaded = nil;
			SV:SecureFadeIn(Dock.BottomLeft, 0.2, Dock.BottomLeft:GetAlpha(), 1)
			SV:SecureFadeIn(Dock.BottomRight, 0.2, Dock.BottomRight:GetAlpha(), 1)
			SVLib:Trigger("DOCKS_FADE_IN");
		else 
			SV.cache.Docks.IsFaded = true;
			SV:SecureFadeOut(Dock.BottomLeft, 0.2, Dock.BottomLeft:GetAlpha(), 0, true)
			SV:SecureFadeOut(Dock.BottomRight, 0.2, Dock.BottomRight:GetAlpha(), 0, true)
			SVLib:Trigger("DOCKS_FADE_OUT");
		end
	end
end

function Dock:EnterFade()
	if SV.cache.Docks.IsFaded then
		self.BottomLeft:Show()
		SV:SecureFadeIn(self.BottomLeft, 0.2, self.BottomLeft:GetAlpha(), 1)
		self.BottomRight:Show()
		SV:SecureFadeIn(self.BottomRight, 0.2, self.BottomRight:GetAlpha(), 1)
		SVLib:Trigger("DOCKS_FADE_IN");
	end
end 

function Dock:ExitFade()
	if SV.cache.Docks.IsFaded then
		SV:SecureFadeOut(self.BottomLeft, 0.2, self.BottomLeft:GetAlpha(), 0, true)
		SV:SecureFadeOut(self.BottomRight, 0.2, self.BottomRight:GetAlpha(), 0, true)
		SVLib:Trigger("DOCKS_FADE_OUT");
	end
end
--[[ 
########################################################## 
SET DOCKBAR FUNCTIONS
##########################################################
]]--
local RefreshDockButtons = function(self)
	for name,docklet in pairs(Dock.Registration) do
		if(docklet) then
			if(not InCombatLockdown() or (InCombatLockdown() and (docklet.IsProtected and not docklet:IsProtected()))) then
				if(docklet.DockButton) then
					docklet.DockButton:Deactivate()
				end
				if docklet.Hide then
					docklet:Hide()
				end
			end
		end
	end
end

local GetDefault = function(self)
	local default = self.Data.Default
	local button = _G[default]
	if(button) then
		local window = button:GetAttribute("ownerFrame")
		if window and _G[window] then
			self:Refresh()
			self.Parent.Window.FrameLink = _G[window]
			self.Parent.Window:Show()
			_G[window]:Show()
			button:Activate()
		end
	end
end

local OldDefault = function(self)
	local default = self.Data.OriginalDefault
	local button = _G[default]
	if(button) then
		local window = button:GetAttribute("ownerFrame")
		if window and _G[window] then
			self:Refresh()
			self.Parent.Window.FrameLink = _G[window]
			self.Parent.Window:Show()
			_G[window]:Show()
			button:Activate()
		end
	end
end

local ToggleDockletWindow = function(self, button)
	local frame  = button.FrameLink
	if(frame and frame.Show) then
		self.Parent.Window.FrameLink = frame

		if(not self.Parent.Window:IsShown()) then
			self.Parent.Window:Show()
		end

		if(not frame:IsShown()) then
			self:Refresh()
		end

		frame:Show()
		
		button:Activate()
	else
		button:Deactivate()
		self:GetDefault()
	end
end

local AlertActivate = function(self, child)
	local size = SV.db.Dock.buttonSize or 22;
	self:Height(size)
	self.backdrop:Show()
	child:ClearAllPoints()
	child:SetAllPoints(self)
end 

local AlertDeactivate = function(self)
	self.backdrop:Hide()
	self:Height(1)
end

local Docklet_OnShow = function(self)
	local frame = self.FrameLink
	if(frame and frame.Show) then
		if(InCombatLockdown() and (frame.IsProtected and frame:IsProtected())) then return end 
		frame:Show()
	end 
end

local Docklet_OnHide = function(self)
	local frame = self.FrameLink
	if(frame and frame.Hide) then
		if(InCombatLockdown() and (frame.IsProtected and frame:IsProtected())) then return end 
		frame:Hide()
	end 
end

local DockButtonMakeDefault = function(self)
	self.Parent.Data.Default = self:GetName()
	self.Parent:GetDefault()
	if(not self.Parent.Data.OriginalDefault) then
		self.Parent.Data.OriginalDefault = self:GetName()
	end
end 

local DockButtonActivate = function(self)
	self:SetAttribute("isActive", true)
	self:SetPanelColor("green")
	self.Icon:SetGradient(unpack(SV.Media.gradient.green))
	if(self.FrameLink) then
		self.FrameLink:Show()
	end
end 

local DockButtonDeactivate = function(self)
	self:SetAttribute("isActive", false)
	self:SetPanelColor("default")
	self.Icon:SetGradient(unpack(SV.Media.gradient.icon))
	if(self.FrameLink) then
		self.FrameLink:Hide()
	end
end

local DockButton_OnEnter = function(self, ...)
	Dock:EnterFade()

	self:SetPanelColor("highlight")
	self.Icon:SetGradient(unpack(SV.Media.gradient.bizzaro))

	GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 4)
	GameTooltip:ClearLines()
	local tipText = self:GetAttribute("tipText")
	GameTooltip:AddDoubleLine("[Left-Click]", tipText, 0, 1, 0, 1, 1, 1)
	GameTooltip:AddLine(" ")
	GameTooltip:AddDoubleLine("[Alt + Click]", "Reset Dock Buttons", 0, 0.5, 1, 0.5, 1, 0.5)
	GameTooltip:Show()
end

local DockletButton_OnEnter = function(self, ...)
	Dock:EnterFade()

	self:SetPanelColor("highlight")
	self.Icon:SetGradient(unpack(SV.Media.gradient.bizzaro))

	GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 4)
	GameTooltip:ClearLines()
	if(self.CustomTooltip) then
		self:CustomTooltip()
	else
		local tipText = self:GetAttribute("tipText")
		GameTooltip:AddDoubleLine("[Left-Click]", tipText, 0, 1, 0, 1, 1, 1)
	end
	if(self:GetAttribute("hasDropDown") and self.GetMenuList) then
		GameTooltip:AddLine(" ")
		GameTooltip:AddDoubleLine("[Alt + Click]", "Docking Options", 0, 0.5, 1, 0.5, 1, 0.5)
	end
	GameTooltip:Show()
end 

local DockletButton_OnLeave = function(self, ...)
	Dock:ExitFade()

	if(self:GetAttribute("isActive")) then
		self:SetPanelColor("green")
		self.Icon:SetGradient(unpack(SV.Media.gradient.green))
	else
		self:SetPanelColor("default")
		self.Icon:SetGradient(unpack(SV.Media.gradient.icon))
	end

	GameTooltip:Hide()
end

local DockletButton_OnClick = function(self, button)
	if InCombatLockdown() then return end
	if(IsAltKeyDown() and self:GetAttribute("hasDropDown") and self.GetMenuList) then
		local list = self:GetMenuList()
		SV.Dropdown:Open(self, list);
	else
		if self.PostClickFunction then
			self:PostClickFunction()
		else
			self.Parent:Toggle(self)
		end
	end
end

local DockletButton_OnPostClick = function(self, button)
	if InCombatLockdown() then return end
	if(IsAltKeyDown() and self:GetAttribute("hasDropDown") and self.GetMenuList) then
		local list = self:GetMenuList()
		SV.Dropdown:Open(self, list);
	end
end

local DockletEnable = function(self)
	local dock = self.Parent;
	if(self.DockButton) then dock.Bar:Add(self.DockButton) end
end

local DockletDisable = function(self)
	local dock = self.Parent;
	if(self.DockButton) then dock.Bar:Remove(self.DockButton) end
end

local DockletButtonSize = function(self)
	local size = self.Bar.ToolBar:GetHeight() or 30;
	return size;
end

local DockletRelocate = function(self, location)
	local newParent = Dock[location];

	if(not newParent) then return end

	if(self.DockButton) then 
		newParent.Bar:Add(self.DockButton) 
	end
	
	if(self.Bar) then 
		local height = newParent.Bar.ToolBar:GetHeight();
		local mod = newParent.Bar.Data[1];
		local barAnchor = newParent.Bar.Data[2];
		local barReverse = SV:GetReversePoint(barAnchor);
		local spacing = SV.db.Dock.buttonSpacing;

		self.Bar:ClearAllPoints();
		self.Bar:Point(barAnchor, newParent.Bar.ToolBar, barReverse, (spacing * mod), 0)
	end
end

local GetDockablePositions = function(self)
	local button = self;
	local name = button:GetName();
	local currentLocation = Dock.Locations[name];

	local t = {{ title = "Move This", divider = true }};

	for location,option in pairs(DOCK_DROPDOWN_OPTIONS) do
		if(currentLocation ~= location) then
		    tinsert(t, option);
		end
	end

	tinsert(t, { title = "Re-Order", divider = true });

	for i=1, #button.Parent.Data.Order do
		if(i ~= button.OrderIndex) then
			local positionText = ("Position #%d"):format(i);
		    tinsert(t, { text = positionText, func = function() button.Parent:ChangeOrder(button, i) end });
		end
	end

	return t;
end

local ChangeBarOrder = function(self, button, targetIndex)
	local targetName = button:GetName();
	local currentIndex = button.OrderIndex;
	wipe(ORDER_TEST);
	wipe(ORDER_TEMP);
	for i = 1, #self.Data.Order do
		local nextName = self.Data.Order[i];
		if(i == targetIndex) then
			if(currentIndex > targetIndex) then
				tinsert(ORDER_TEMP, targetName)
				tinsert(ORDER_TEMP, nextName)
			else
				tinsert(ORDER_TEMP, nextName)
				tinsert(ORDER_TEMP, targetName)
			end
		elseif(targetName ~= nextName) then
			tinsert(ORDER_TEMP, nextName)
		end
	end

	wipe(self.Data.Order);
	local safeIndex = 1;
	for i = 1, #ORDER_TEMP do
		local nextName = ORDER_TEMP[i];
		local nextButton = self.Data.Buttons[nextName];
		if(nextButton and (not ORDER_TEST[nextName])) then
			ORDER_TEST[nextName] = true
			tinsert(self.Data.Order, nextName);
			nextButton.OrderIndex = safeIndex;
			safeIndex = safeIndex + 1;
		end
	end

	self:Update()
end

local RefreshBarOrder = function(self)
	wipe(ORDER_TEST);
	wipe(ORDER_TEMP);
	for i = 1, #self.Data.Order do
		local nextName = self.Data.Order[i];
		tinsert(ORDER_TEMP, nextName)
	end
	wipe(self.Data.Order);
	local safeIndex = 1;
	for i = 1, #ORDER_TEMP do
		local nextName = ORDER_TEMP[i];
		local nextButton = self.Data.Buttons[nextName];
		if(nextButton and (not ORDER_TEST[nextName])) then
			ORDER_TEST[nextName] = true
			tinsert(self.Data.Order, nextName);
			nextButton.OrderIndex = safeIndex;
			safeIndex = safeIndex + 1;
		end
	end
end

local CheckBarOrder = function(self, targetName)
	local found = false;
	for i = 1, #self.Data.Order do
		if(self.Data.Order[i] == targetName) then
			found = true;
		end
	end
	if(not found) then
		tinsert(self.Data.Order, targetName);
		self:UpdateOrder();
	end
end

local RefreshBarLayout = function(self)
	local anchor = upper(self.Data.Location)
	local mod = self.Data.Modifier
	local size = self.ToolBar:GetHeight();
	local count = #self.Data.Order;
	local width = count * (size + 6) + 6;
	local offset = 1;

	self.ToolBar:SetWidth(width);
	local safeIndex = 1;
	for i = 1, count do
		local nextName = self.Data.Order[i];
		local nextButton = self.Data.Buttons[nextName];
		if(nextButton) then
			offset = (safeIndex - 1) * (size + 6) + 6
			nextButton:ClearAllPoints();
			nextButton:Size(size, size);
			nextButton:SetPoint(anchor, self.ToolBar, anchor, (offset * mod), 0);
			if(not nextButton:IsShown()) then
				nextButton:Show();
			end
			nextButton.OrderIndex = safeIndex;
			safeIndex = safeIndex + 1;
		end
	end

	if(SV.Dropdown:IsShown()) then
		ToggleFrame(SV.Dropdown)
	end
end

local AddToDock = function(self, button)
	if not button then return end
	local name = button:GetName();
	if(self.Data.Buttons[name]) then return end

	local registeredLocation = Dock.Locations[name]
	local currentLocation = self.Data.Location

	if(registeredLocation) then
		if(registeredLocation ~= currentLocation) then
			if(Dock[registeredLocation].Bar.Data.Buttons[name]) then
				Dock[registeredLocation].Bar:Remove(button);
			else
				Dock[registeredLocation].Bar:Add(button);
				return
			end
		end
	end

	self.Data.Buttons[name] = button;
	self:CheckOrder(name);
	
	Dock.Locations[name] = currentLocation;
	button.Parent = self;
	button:SetParent(self.ToolBar);

	if(button.FrameLink) then
		local frameName = button.FrameLink:GetName()
		Dock.Locations[frameName] = currentLocation;
		button.FrameLink:ClearAllPoints()
		button.FrameLink:SetParent(self.Parent.Window)
		button.FrameLink:FillInner(self.Parent.Window)
	end

	self:Update()
end

local RemoveFromDock = function(self, button)
	if not button then return end 
	local name = button:GetName();
	local registeredLocation = Dock.Locations[name];
	local currentLocation = self.Data.Location

	if(registeredLocation and (registeredLocation == currentLocation)) then 
		Dock.Locations[name] = nil;
	end

	for i = 1, #self.Data.Order do
		local nextName = self.Data.Order[i];
		if(nextName == name) then
			tremove(self.Data.Order, i);
			break;
		end
	end

	if(not self.Data.Buttons[name]) then return end

	button:Hide()
	if(button.FrameLink) then
		local frameName = button.FrameLink:GetName()
		Dock.Locations[frameName] = nil;
		button.FrameLink:Hide()
	end

	button.OrderIndex = 0;
	self.Data.Buttons[name] = nil;
	self:UpdateOrder()
	self:Update()
end

local ActivateDockletButton = function(self, button, clickFunction, tipFunction, isAction)
	button.Activate = DockButtonActivate
	button.Deactivate = DockButtonDeactivate
	button.MakeDefault = DockButtonMakeDefault
	button.GetMenuList = GetDockablePositions

	if(tipFunction and type(tipFunction) == "function") then
		button.CustomTooltip = tipFunction
	end

	button.Parent = self
	button:SetPanelColor("default")
	button.Icon:SetGradient(unpack(SV.Media.gradient.icon))
	button:SetScript("OnEnter", DockletButton_OnEnter)
	button:SetScript("OnLeave", DockletButton_OnLeave)
	if(not isAction) then
		button:SetScript("OnClick", DockletButton_OnClick)
	else
		button:SetScript("PostClick", DockletButton_OnPostClick)
	end

	if(clickFunction and type(clickFunction) == "function") then
		button.PostClickFunction = clickFunction
	end
end

local CreateBasicToolButton = function(self, displayName, texture, onclick, globalName, tipFunction, primaryTemplate)
	local dockIcon = texture or [[Interface\AddOns\SVUI\assets\artwork\Icons\SVUI-ICON]];
	local size = self.ToolBar:GetHeight();
	local template = "SVUI_DockletButtonTemplate"

	if(primaryTemplate) then
		template = primaryTemplate .. ", SVUI_DockletButtonTemplate"
	end

	local button = _G[globalName .. "DockletButton"] or CreateFrame("Button", globalName, self.ToolBar, template)

	button:ClearAllPoints()
	button:Size(size, size)
	button:SetFramedButtonTemplate()
	button.Icon:SetTexture(dockIcon)
	button:SetAttribute("tipText", displayName)
    button:SetAttribute("ownerFrame", globalName)

    button.OrderIndex = 0;

    self:Add(button)
	self:Initialize(button, onclick, tipFunction, primaryTemplate)
	
	return button
end
--[[ 
########################################################## 
DOCKS
##########################################################
]]--
for location, settings in pairs(DOCK_LOCATIONS) do
	Dock[location] = _G["SVUI_Dock" .. location];
	Dock[location].Bar = _G["SVUI_DockBar" .. location];

	Dock[location].Alert.Activate = AlertActivate;
	Dock[location].Alert.Deactivate = AlertDeactivate;

	Dock[location].Bar.Parent = Dock[location];
	Dock[location].Bar.Refresh = RefreshDockButtons;
	Dock[location].Bar.GetDefault = GetDefault;
	Dock[location].Bar.UnsetDefault = OldDefault;
	Dock[location].Bar.Toggle = ToggleDockletWindow;
	Dock[location].Bar.Update = RefreshBarLayout;
	Dock[location].Bar.UpdateOrder = RefreshBarOrder;
	Dock[location].Bar.ChangeOrder = ChangeBarOrder;
	Dock[location].Bar.CheckOrder = CheckBarOrder;
	Dock[location].Bar.Add = AddToDock;
	Dock[location].Bar.Remove = RemoveFromDock;
	Dock[location].Bar.Initialize = ActivateDockletButton;
	Dock[location].Bar.Create = CreateBasicToolButton;
	Dock[location].Bar.Data = {
		Location = location,
		Anchor = settings[2],
		Modifier = settings[1],
		Default = "",
		Buttons = {},
		Order = {},
	};
end

for location, settings in pairs(STAT_LOCATIONS) do
	Dock[location] = _G["SVUI_Dock" .. location];
end

local function SetSuperDockStyle(dock, isBottom)
	if dock.backdrop then return end

	local leftGradient = {}

	local backdrop = CreateFrame("Frame", nil, dock)
	backdrop:SetAllPoints(dock)
	backdrop:SetFrameStrata("BACKGROUND")

	backdrop.bg = backdrop:CreateTexture(nil, "BORDER")
	backdrop.bg:FillInner(backdrop)
	backdrop.bg:SetTexture(1, 1, 1, 1)
	backdrop.bg:SetGradientAlpha("VERTICAL", 0, 0, 0, 0.8, 0, 0, 0, 0)

	backdrop.left = backdrop:CreateTexture(nil, "OVERLAY")
	backdrop.left:SetTexture(1, 1, 1, 1)
	backdrop.left:Point("TOPLEFT", 1, -1)
	backdrop.left:Point("BOTTOMLEFT", -1, -1)
	backdrop.left:Width(4)
	if(isBottom) then
		backdrop.left:SetGradientAlpha("VERTICAL", 0, 0, 0, 1, 0, 0, 0, 0)
	else
		backdrop.left:SetGradientAlpha("VERTICAL", 0, 0, 0, 0, 0, 0, 0, 1)
	end

	backdrop.right = backdrop:CreateTexture(nil, "OVERLAY")
	backdrop.right:SetTexture(1, 1, 1, 1)
	backdrop.right:Point("TOPRIGHT", -1, -1)
	backdrop.right:Point("BOTTOMRIGHT", -1, -1)
	backdrop.right:Width(4)
	if(isBottom) then
		backdrop.right:SetGradientAlpha("VERTICAL", 0, 0, 0, 1, 0, 0, 0, 0)
	else
		backdrop.right:SetGradientAlpha("VERTICAL", 0, 0, 0, 0, 0, 0, 0, 1)
	end

	backdrop.bottom = backdrop:CreateTexture(nil, "OVERLAY")
	backdrop.bottom:Point("BOTTOMLEFT", 1, -1)
	backdrop.bottom:Point("BOTTOMRIGHT", -1, -1)
	if(isBottom) then
		backdrop.bottom:SetTexture(0, 0, 0, 1)
		backdrop.bottom:Height(4)
	else
		backdrop.bottom:SetTexture(0, 0, 0, 0)
		backdrop.bottom:SetAlpha(0)
		backdrop.bottom:Height(1)
	end

	backdrop.top = backdrop:CreateTexture(nil, "OVERLAY")
	backdrop.top:Point("TOPLEFT", 1, -1)
	backdrop.top:Point("TOPRIGHT", -1, 1)
	if(isBottom) then
		backdrop.top:SetTexture(0, 0, 0, 0)
		backdrop.top:SetAlpha(0)
		backdrop.top:Height(1)
	else
		backdrop.top:SetTexture(0, 0, 0, 1)
		backdrop.top:Height(4)
	end

	return backdrop 
end

local function InitDockButton(button)
	button:SetPanelColor("default")
	button.Icon:SetGradient(unpack(SV.Media.gradient.icon))
	button:SetScript("OnEnter", DockButton_OnEnter)
	button:SetScript("OnLeave", DockletButton_OnLeave)
	button:SetScript("OnClick", HideSuperDocks)
end

local function BorderColorUpdates()
	Dock.Border.Top:SetBackdropColor(unpack(SV.Media.color.specialdark))
	Dock.Border.Top:SetBackdropBorderColor(0,0,0,1)
	Dock.Border.Bottom:SetBackdropColor(unpack(SV.Media.color.special))
	Dock.Border.Bottom:SetBackdropBorderColor(0,0,0,1)
end

LibSuperVillain("Registry"):NewCallback("CORE_MEDIA_UPDATED", "BorderColorUpdates", BorderColorUpdates)
--[[ 
########################################################## 
EXTERNALLY ACCESSIBLE METHODS
##########################################################
]]--
function Dock:SetDockButton(location, displayName, texture, onclick, globalName, tipFunction, primaryTemplate)
	if(self.Locations[globalName]) then
		location = self.Locations[globalName];
	else
		self.Locations[globalName] = location;
	end
	local parent = self[location]
	return parent.Bar:Create(displayName, texture, onclick, globalName, tipFunction, primaryTemplate)
end

function Dock:GetDimensions(location)
	local width, height;

	if(location:find("Left")) then
		width = SV.db.Dock.dockLeftWidth;
		height = SV.db.Dock.dockLeftHeight;
	else
		width = SV.db.Dock.dockRightWidth;
		height = SV.db.Dock.dockRightHeight;
	end

	return width, height;
end

function Dock:NewDocklet(location, globalName, readableName, texture, onclick)
	if(self.Registration[globalName]) then return end;
	
	if(self.Locations[globalName]) then
		location = self.Locations[globalName];
	else
		self.Locations[globalName] = location;
	end

	local newParent = self[location];
	if(not newParent) then return end
	local frame = CreateFrame("Frame", globalName, UIParent, "SVUI_DockletWindowTemplate");
	frame:SetParent(newParent.Window);
	frame:SetSize(newParent.Window:GetSize());
	frame:SetAllPoints(newParent.Window);
	frame:SetFrameStrata("BACKGROUND");
	frame.Parent = newParent
	frame.Disable = DockletDisable;
	frame.Enable = DockletEnable;
	frame.Relocate = DockletRelocate;
	frame.GetButtonSize = DockletButtonSize;

	local buttonName = ("%sButton"):format(globalName)
	frame.DockButton = newParent.Bar:Create(readableName, texture, onclick, buttonName);
	frame.DockButton.FrameLink = frame
	self.Registration[globalName] = frame;

	return frame
end

function Dock:NewAdvancedDocklet(location, globalName)
	if(self.Registration[globalName]) then return end;

	if(self.Locations[globalName]) then
		location = self.Locations[globalName];
	else
		self.Locations[globalName] = location;
	end

	local newParent = self[location];
	if(not newParent) then return end

	local frame = CreateFrame("Frame", globalName, UIParent, "SVUI_DockletWindowTemplate");
	frame:SetParent(newParent.Window);
	frame:SetSize(newParent.Window:GetSize());
	frame:SetAllPoints(newParent.Window);
	frame:SetFrameStrata("BACKGROUND");
	frame.Parent = newParent
	frame.Disable = DockletDisable;
	frame.Enable = DockletEnable;
	frame.Relocate = DockletRelocate;
	frame.GetButtonSize = DockletButtonSize;

	local height = newParent.Bar.ToolBar:GetHeight();
	local mod = newParent.Bar.Data.Modifier;
	local barAnchor = newParent.Bar.Data.Anchor;
	local barReverse = SV:GetReversePoint(barAnchor);
	local spacing = SV.db.Dock.buttonSpacing;

	frame.Bar = CreateFrame("Frame", nil, newParent);
	frame.Bar:Size(1, height);
	frame.Bar:Point(barAnchor, newParent.Bar.ToolBar, barReverse, (spacing * mod), 0)
	SV.Mentalo:Add(frame.Bar, globalName .. " Dock Bar");

	self.Registration[globalName] = frame;
	return frame
end
--[[ 
########################################################## 
BUILD/UPDATE
##########################################################
]]--
function Dock:UpdateDockBackdrops()
	if SV.db.Dock.rightDockBackdrop then
		Dock.BottomRight.backdrop:Show()
		Dock.BottomRight.backdrop:ClearAllPoints()
		Dock.BottomRight.backdrop:WrapOuter(Dock.BottomRight.Window, 4, 4)

		Dock.BottomRight.Alert.backdrop:ClearAllPoints()
		Dock.BottomRight.Alert.backdrop:WrapOuter(Dock.BottomRight.Alert, 4, 4)
	else
		Dock.BottomRight.backdrop:Hide()
	end
	if SV.db.Dock.leftDockBackdrop then
		Dock.BottomLeft.backdrop:Show()
		Dock.BottomLeft.backdrop:ClearAllPoints()
		Dock.BottomLeft.backdrop:WrapOuter(Dock.BottomLeft.Window, 4, 4)

		Dock.BottomLeft.Alert.backdrop:ClearAllPoints()
		Dock.BottomLeft.Alert.backdrop:WrapOuter(Dock.BottomLeft.Alert, 4, 4)
	else
		Dock.BottomLeft.backdrop:Hide()
	end
end 

function Dock:BottomBorderVisibility()
	if SV.db.Dock.bottomPanel then 
		self.Border.Bottom:Show()
	else 
		self.Border.Bottom:Hide()
	end 
end 

function Dock:TopBorderVisibility()
	if SV.db.Dock.topPanel then 
		self.Border.Top:Show()
	else 
		self.Border.Top:Hide()
	end 
end

function Dock:ResetAllButtons()
	wipe(SV.cache.Docks.Order)
	wipe(SV.cache.Docks.Locations)
	ReloadUI()
end

function Dock:Refresh()
	local buttonsize = SV.db.Dock.buttonSize;
	local spacing = SV.db.Dock.buttonSpacing;
	local centerWidth = SV.db.Dock.dockCenterWidth;
	local centerHeight = buttonsize * 0.7;

	for location, settings in pairs(DOCK_LOCATIONS) do
		if(location ~= "TopRight") then
			local width, height = self:GetDimensions(location);
			local dock = self[location];

			dock.Bar:Size(width, buttonsize)
		    dock.Bar.ToolBar:SetHeight(buttonsize)
		    dock:Size(width, height)
		    dock.Alert:Size(width, 1)
		    dock.Window:Size(width, height)

		    if(dock.Bar.Button) then
		    	dock.Bar.Button:Size(buttonsize, buttonsize)
		    end

		    dock.Bar:Update()
		end
	end

	self.BottomCenter:Size(centerWidth, centerHeight)
	self.BottomCenter.Left:Size((centerWidth * 0.5), centerHeight)
	self.BottomCenter.Right:Size((centerWidth * 0.5), centerHeight)

	self.TopCenter:Size(centerWidth, centerHeight)
	self.TopCenter.Left:Size((centerWidth * 0.5), centerHeight)
	self.TopCenter.Right:Size((centerWidth * 0.5), centerHeight)

	self:BottomBorderVisibility();
	self:TopBorderVisibility();
	self:UpdateDockBackdrops();

	SVLib:Trigger("DOCKS_UPDATED");
end 

function Dock:Initialize()
	SV.cache.Docks = SV.cache.Docks	or {}

	if(not SV.cache.Docks.IsFaded) then 
		SV.cache.Docks.IsFaded = false
	end

	if(not SV.cache.Docks.Order) then 
		SV.cache.Docks.Order = {}
	end

	if(not SV.cache.Docks.Locations) then 
		SV.cache.Docks.Locations = {}
	end

	self.Locations = SV.cache.Docks.Locations;

	local buttonsize = SV.db.Dock.buttonSize;
	local spacing = SV.db.Dock.buttonSpacing;
	local centerWidth = SV.db.Dock.dockCenterWidth;
	local centerHeight = buttonsize * 0.7;
	local texture = [[Interface\AddOns\SVUI\assets\artwork\Template\BUTTON]];

	-- [[ TOP AND BOTTOM BORDERS ]] --

	self.Border.Top = CreateFrame("Frame", "SVUITopBorder", SV.Screen)
	self.Border.Top:Point("TOPLEFT", SV.Screen, "TOPLEFT", -1, 1)
	self.Border.Top:Point("TOPRIGHT", SV.Screen, "TOPRIGHT", 1, 1)
	self.Border.Top:Height(14)
	self.Border.Top:SetBackdrop({
		bgFile = texture, 
		edgeFile = [[Interface\BUTTONS\WHITE8X8]], 
		tile = false, 
		tileSize = 0, 
		edgeSize = 1, 
		insets = {left = 0, right = 0, top = 0, bottom = 0}
	})
	self.Border.Top:SetBackdropColor(unpack(SV.Media.color.specialdark))
	self.Border.Top:SetBackdropBorderColor(0,0,0,1)
	self.Border.Top:SetFrameLevel(0)
	self.Border.Top:SetFrameStrata('BACKGROUND')
	self.Border.Top:SetScript("OnShow", function(this)
		this:SetFrameLevel(0)
		this:SetFrameStrata('BACKGROUND')
	end)
	self:TopBorderVisibility()

	self.Border.Bottom = CreateFrame("Frame", "SVUIBottomBorder", SV.Screen)
	self.Border.Bottom:Point("BOTTOMLEFT", SV.Screen, "BOTTOMLEFT", -1, -1)
	self.Border.Bottom:Point("BOTTOMRIGHT", SV.Screen, "BOTTOMRIGHT", 1, -1)
	self.Border.Bottom:Height(14)
	self.Border.Bottom:SetBackdrop({
		bgFile = texture, 
		edgeFile = [[Interface\BUTTONS\WHITE8X8]], 
		tile = false, 
		tileSize = 0, 
		edgeSize = 1, 
		insets = {left = 0, right = 0, top = 0, bottom = 0}
	})
	self.Border.Bottom:SetBackdropColor(unpack(SV.Media.color.special))
	self.Border.Bottom:SetBackdropBorderColor(0,0,0,1)
	self.Border.Bottom:SetFrameLevel(0)
	self.Border.Bottom:SetFrameStrata('BACKGROUND')
	self.Border.Bottom:SetScript("OnShow", function(this)
		this:SetFrameLevel(0)
		this:SetFrameStrata('BACKGROUND')
	end)
	self:BottomBorderVisibility()

	for location, settings in pairs(DOCK_LOCATIONS) do
		local width, height = self:GetDimensions(location);
		local dock = self[location];
		local mod = settings[1];
		local anchor = upper(location);
		local reverse = SV:GetReversePoint(anchor);
		local barAnchor = settings[2];
		local barReverse = SV:GetReversePoint(barAnchor);
		local isBottom = settings[3];
		local vertMod = isBottom and 1 or -1

		dock.Bar:SetParent(SV.Screen)
		dock.Bar:ClearAllPoints()
		dock.Bar:Size(width, buttonsize)
		dock.Bar:SetPoint(anchor, SV.Screen, anchor, (2 * mod), (2 * vertMod))

		if(not SV.cache.Docks.Order[location]) then 
			SV.cache.Docks.Order[location] = {}
		end

		dock.Bar.Data.Order = SV.cache.Docks.Order[location];

		dock.Bar.ToolBar:ClearAllPoints()

		if(dock.Bar.Button) then
	    	dock.Bar.Button:Size(buttonsize, buttonsize)
	    	dock.Bar.Button:SetFramedButtonTemplate()
	    	dock.Bar.ToolBar:Size(1, buttonsize)
	    	dock.Bar.ToolBar:Point(barAnchor, dock.Bar.Button, barReverse, (spacing * mod), 0)
	    	InitDockButton(dock.Bar.Button)
	    else
	    	dock.Bar.ToolBar:Size(1, buttonsize)
	    	dock.Bar.ToolBar:Point(barAnchor, dock.Bar, barAnchor, 0, 0)
	    end

	    dock:SetParent(SV.Screen)
	    dock:ClearAllPoints()
	    dock:SetPoint(anchor, dock.Bar, reverse, 0, (12 * vertMod))
	    dock:Size(width, height)
	    dock:SetAttribute("buttonSize", buttonsize)
	    dock:SetAttribute("spacingSize", spacing)

	    dock.Alert:ClearAllPoints()
	    dock.Alert:Size(width, 1)
	    dock.Alert:SetPoint(anchor, dock, anchor, 0, 0)

	    dock.Window:ClearAllPoints()
	    dock.Window:Size(width, height)
	    dock.Window:SetPoint(anchor, dock.Alert, reverse, 0, (4 * vertMod))

	    SV.Mentalo:Add(dock.Bar, location .. " Dock ToolBar");

		if(isBottom) then
			dock.backdrop = SetSuperDockStyle(dock.Window, isBottom)
			dock.Alert.backdrop = SetSuperDockStyle(dock.Alert, isBottom)
			dock.Alert.backdrop:Hide()
			dock.Window:SetScript("OnShow", Docklet_OnShow)
			dock.Window:SetScript("OnHide", Docklet_OnHide)
		end
		
		SV.Mentalo:Add(dock, location .. " Dock Window")
	end

	if SV.cache.Docks.IsFaded then Dock.BottomLeft:Hide() Dock.BottomRight:Hide() end

	SV:AddToDisplayAudit(self.BottomRight.Window)
	SV:AddToDisplayAudit(self.TopLeft.Window)
	SV:AddToDisplayAudit(self.TopRight.Window)

	if not InCombatLockdown() then 
		self.BottomLeft.Bar:Refresh()
		self.BottomRight.Bar:Refresh()
		self.TopLeft.Bar:Refresh()
		self.TopRight.Bar:Refresh()
	end

	--BOTTOM CENTER BAR
	self.BottomCenter:SetParent(SV.Screen)
	self.BottomCenter:ClearAllPoints()
	self.BottomCenter:SetSize(centerWidth, centerHeight)
	self.BottomCenter:SetPoint("BOTTOM", SV.Screen, "BOTTOM", 0, 2)

	self.BottomCenter.Left:SetSize((centerWidth * 0.5), centerHeight)
	self.BottomCenter.Left:SetPoint("LEFT")
	SV.Mentalo:Add(self.BottomCenter.Left, L["BottomCenter Dock Left"])

	self.BottomCenter.Right:SetSize((centerWidth * 0.5), centerHeight)
	self.BottomCenter.Right:SetPoint("RIGHT")
	SV.Mentalo:Add(self.BottomCenter.Right, L["BottomCenter Dock Right"])

	--TOP CENTER BAR
	self.TopCenter:SetParent(SV.Screen)
	self.TopCenter:ClearAllPoints()
	self.TopCenter:SetSize(centerWidth, centerHeight)
	self.TopCenter:SetPoint("TOP", SV.Screen, "TOP", 0, -2)

	self.TopCenter.Left:SetSize((centerWidth * 0.5), centerHeight)
	self.TopCenter.Left:SetPoint("LEFT", self.TopCenter, "LEFT")
	SV.Mentalo:Add(self.TopCenter.Left, L["TopCenter Dock Left"])

	self.TopCenter.Right:SetSize((centerWidth * 0.5), centerHeight)
	self.TopCenter.Right:SetPoint("LEFT", self.TopCenter.Left, "RIGHT")
	SV.Mentalo:Add(self.TopCenter.Right, L["TopCenter Dock Right"])

	self:UpdateDockBackdrops()
end

SV.Dock = Dock