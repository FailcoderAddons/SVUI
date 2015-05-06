--[[
##############################################################################
S V U I   By: Munglunch
############################################################################## ]]--
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
local wipe 			= _G.wipe;
--MATH
local math      	= _G.math;
local random 		= math.random;
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
local ReloadUI              = _G.ReloadUI;
local IsAltKeyDown          = _G.IsAltKeyDown;
local IsShiftKeyDown        = _G.IsShiftKeyDown;
local IsControlKeyDown      = _G.IsControlKeyDown;
local IsModifiedClick       = _G.IsModifiedClick;
local PlaySound             = _G.PlaySound;
local PlaySoundFile         = _G.PlaySoundFile;
local UnitName              = _G.UnitName;
local ToggleFrame           = _G.ToggleFrame;
local ERR_NOT_IN_COMBAT     = _G.ERR_NOT_IN_COMBAT;
--[[
##########################################################
ADDON
##########################################################
]]--
local SV = select(2, ...);
local L = SV.L;
local MOD = SV:NewPackage("Dock", L["Docks"]);
MOD.Border = {};
--[[
##########################################################
LOCALS
##########################################################
]]--
local DOCK_CHECK,DRAGGING_TARGET;
local ORDER_TEMP, ORDER_TEST, DOCK_REGISTRY, DOCK_DROPDOWN_OPTIONS = {}, {}, {}, {};
local DOCK_LOCATIONS = {
	["BottomLeft"] = {1, "LEFT", true, "ANCHOR_TOPLEFT"},
	["BottomRight"] = {-1, "RIGHT", true, "ANCHOR_TOPLEFT"},
	["TopLeft"] = {1, "LEFT", false, "ANCHOR_BOTTOMLEFT"},
	["TopRight"] = {-1, "RIGHT", false, "ANCHOR_BOTTOMLEFT"},
};
--DOCK_DROPDOWN_OPTIONS["BottomLeft"] = { text = "To BottomLeft", func = function(button) button:MoveTo("BottomLeft"); end };
--DOCK_DROPDOWN_OPTIONS["BottomRight"] = { text = "To BottomRight", func = function(button) button:MoveTo("BottomRight"); end };
--DOCK_DROPDOWN_OPTIONS["TopLeft"] = { text = "To TopLeft", func = function(button) button:MoveTo("TopLeft"); end };
--DOCK_DROPDOWN_OPTIONS["TopRight"] = { text = "To TopRight", func = function(button) MOD.TopRight.Bar:Add(button) end };
--[[
##########################################################
THEMEABLE ITEMS
##########################################################
]]--
MOD.ButtonSound = SV.Sounds:Blend("DockButton", "Buttons", "Levers");
MOD.ErrorSound = SV.Sounds:Blend("Malfunction", "Sparks", "Wired");

local function GetDockDimensions(location)
	local width, height;
	local isTop = location:find("Top")
	local isLeft = location:find("Left")
	if(isTop) then
		if(isLeft) then
			width = SV.db.Dock.dockTopLeftWidth;
			height = SV.db.Dock.dockTopLeftHeight;
		else
			width = SV.db.Dock.dockTopRightWidth;
			height = SV.db.Dock.dockTopRightHeight;
		end
	else
		if(isLeft) then
			width = SV.db.Dock.dockLeftWidth;
			height = SV.db.Dock.dockLeftHeight;
			if(MOD.private.LeftExpanded) then
				height = height + 300
			end
		else
			width = SV.db.Dock.dockRightWidth;
			height = SV.db.Dock.dockRightHeight;
			if(MOD.private.RightExpanded) then
				height = height + 300
			end
		end
	end

	return width, height;
end

local function SetDockDimensions(location, width, height, buttonSize)
	local isTop = location:find("Top")
	local isLeft = location:find("Left")
	if(isTop) then
		if(isLeft) then
			SV.db.Dock.dockTopLeftWidth = width;
			if(not buttonSize) then
				SV.db.Dock.dockTopLeftHeight = height;
			end
		else
			SV.db.Dock.dockTopRightWidth = width;
			if(not buttonSize) then
				SV.db.Dock.dockTopRightHeight = height;
			end
		end
	else
		if(isLeft) then
			SV.db.Dock.dockLeftWidth = width;
			if(not buttonSize) then
				SV.db.Dock.dockLeftHeight = height;
			end
		else
			SV.db.Dock.dockRightWidth = width;
			if(not buttonSize) then
				SV.db.Dock.dockRightHeight = height;
			end
		end
	end

	if(buttonSize) then
		SV.db.Dock.buttonSize = height;
	end
end

local dockPostSizeFunc = function(self, width, height)
	local name = self:GetName()
	SetDockDimensions(name, width, height)
end

local dockBarPostSizeFunc = function(self, width, height)
	local name = self:GetName()
	SetDockDimensions(name, width, height, true)
end

local function ScreenBorderVisibility()
	if SV.db.Dock.bottomPanel then
		SVUIDock_BottomBorder:Show()
	else
		SVUIDock_BottomBorder:Hide()
	end

	if SV.db.Dock.topPanel then
		SVUIDock_TopBorder:Show()
	else
		SVUIDock_TopBorder:Hide()
	end
end

function MOD.SetThemeDockStyle(frame, isBottom)
	local backdrop = CreateFrame("Frame", nil, frame)
	backdrop:SetAllPoints(frame)
	backdrop:SetFrameStrata("BACKGROUND")

	local bg = backdrop:CreateTexture(nil, "BORDER")
	bg:InsetPoints(backdrop)
	bg:SetTexture(1, 1, 1, 1)

	if(isBottom) then
		bg:SetGradientAlpha("VERTICAL", 0, 0, 0, 0.8, 0, 0, 0, 0)
	else
		bg:SetGradientAlpha("VERTICAL", 0, 0, 0, 0, 0, 0, 0, 0.8)
	end

	local left = backdrop:CreateTexture(nil, "OVERLAY")
	left:SetTexture(1, 1, 1, 1)
	left:SetPoint("TOPLEFT", 1, -1)
	left:SetPoint("BOTTOMLEFT", -1, -1)
	left:SetWidth(2)
	if(isBottom) then
		left:SetGradientAlpha("VERTICAL", 0, 0, 0, 1, 0, 0, 0, 0)
	else
		left:SetGradientAlpha("VERTICAL", 0, 0, 0, 0, 0, 0, 0, 1)
	end

	local right = backdrop:CreateTexture(nil, "OVERLAY")
	right:SetTexture(1, 1, 1, 1)
	right:SetPoint("TOPRIGHT", -1, -1)
	right:SetPoint("BOTTOMRIGHT", -1, -1)
	right:SetWidth(2)
	if(isBottom) then
		right:SetGradientAlpha("VERTICAL", 0, 0, 0, 1, 0, 0, 0, 0)
	else
		right:SetGradientAlpha("VERTICAL", 0, 0, 0, 0, 0, 0, 0, 1)
	end

	local bottom = backdrop:CreateTexture(nil, "OVERLAY")
	bottom:SetPoint("BOTTOMLEFT", 1, -1)
	bottom:SetPoint("BOTTOMRIGHT", -1, -1)
	if(isBottom) then
		bottom:SetTexture(0, 0, 0, 1)
		bottom:SetHeight(2)
	else
		bottom:SetTexture(0, 0, 0, 0)
		bottom:SetAlpha(0)
		bottom:SetHeight(1)
	end

	local top = backdrop:CreateTexture(nil, "OVERLAY")
	top:SetPoint("TOPLEFT", 1, -1)
	top:SetPoint("TOPRIGHT", -1, 1)
	if(isBottom) then
		top:SetTexture(0, 0, 0, 0)
		top:SetAlpha(0)
		top:SetHeight(1)
	else
		top:SetTexture(0, 0, 0, 1)
		top:SetHeight(2)
	end

	return backdrop
end

function MOD:SetBorderTheme()
	self.Border.Top:SetPoint("TOPLEFT", SV.Screen, "TOPLEFT", -1, 1)
	self.Border.Top:SetPoint("TOPRIGHT", SV.Screen, "TOPRIGHT", 1, 1)
	self.Border.Top:SetHeight(10)
	self.Border.Top:SetBackdrop({
		bgFile = SV.media.background.button,
		edgeFile = [[Interface\BUTTONS\WHITE8X8]],
		tile = false,
		tileSize = 0,
		edgeSize = 1,
		insets = {left = 0, right = 0, top = 0, bottom = 0}
	})
	self.Border.Top:SetBackdropColor(unpack(SV.media.color.dark))
	self.Border.Top:SetBackdropBorderColor(0,0,0,1)
	self.Border.Top:SetFrameLevel(0)
	self.Border.Top:SetFrameStrata('BACKGROUND')
	self.Border.Top:SetScript("OnShow", function(self)
		self:SetFrameLevel(0)
		self:SetFrameStrata('BACKGROUND')
	end)

	self.Border.Bottom:SetPoint("BOTTOMLEFT", SV.Screen, "BOTTOMLEFT", -1, -1)
	self.Border.Bottom:SetPoint("BOTTOMRIGHT", SV.Screen, "BOTTOMRIGHT", 1, -1)
	self.Border.Bottom:SetHeight(10)
	self.Border.Bottom:SetBackdrop({
		bgFile = SV.media.background.button,
		edgeFile = [[Interface\BUTTONS\WHITE8X8]],
		tile = false,
		tileSize = 0,
		edgeSize = 1,
		insets = {left = 0, right = 0, top = 0, bottom = 0}
	})
	self.Border.Bottom:SetBackdropColor(unpack(SV.media.color.dark))
	self.Border.Bottom:SetBackdropBorderColor(0,0,0,1)
	self.Border.Bottom:SetFrameLevel(0)
	self.Border.Bottom:SetFrameStrata('BACKGROUND')
	self.Border.Bottom:SetScript("OnShow", function(self)
		self:SetFrameLevel(0)
		self:SetFrameStrata('BACKGROUND')
	end)
end

function MOD:SetButtonTheme(button, size)
	local sparkSize = size * 5;
    local sparkOffset = size * 0.5;

    button:SetStyle("DockButton")

	local sparks = button:CreateTexture(nil, "OVERLAY", nil, 2)
	sparks:SetSize(sparkSize, sparkSize)
	sparks:SetPoint("CENTER", button, "BOTTOMRIGHT", -sparkOffset, 4)
	sparks:SetTexture(SV.media.dock.sparks[1])
	sparks:SetVertexColor(0.7, 0.6, 0.5)
	sparks:SetBlendMode("ADD")
	sparks:SetAlpha(0)

	SV.Animate:Sprite8(sparks, 0.08, 2, false, true)

	button.Sparks = sparks;

	button.ClickTheme = function(self)
		self.Sparks:SetTexture(SV.media.dock.sparks[random(1,3)])
		self.Sparks.anim:Play()
	end
end
--[[
##########################################################
CORE FUNCTIONS
##########################################################
]]--
_G.ToggleSuperDockLeft = function(self, button)
	GameTooltip:Hide()
	if(button and IsAltKeyDown()) then
		SV:StaticPopup_Show('RESETDOCKS_CHECK')
	elseif(button and button == 'RightButton') then
		if(InCombatLockdown()) then
			MOD.ErrorSound()
			SV:AddonMessage(ERR_NOT_IN_COMBAT)
			return
		end
		MOD.ButtonSound()
		local userSize = SV.db.Dock.dockLeftHeight
		if(not MOD.private.LeftExpanded) then
			MOD.private.LeftExpanded = true
			MOD.BottomLeft.Window:SetHeight(userSize + 300)
		else
			MOD.private.LeftExpanded = nil
			MOD.BottomLeft.Window:SetHeight(userSize)
		end
		MOD.BottomLeft.Bar:Update()
		MOD:UpdateDockBackdrops()
		SV.Events:Trigger("DOCK_LEFT_EXPANDED");
	else
		if MOD.private.LeftFaded then
			MOD.private.LeftFaded = nil;
			MOD.BottomLeft:FadeIn(0.2, MOD.BottomLeft:GetAlpha(), 1)
			MOD.BottomLeft.Bar:FadeIn(0.2, MOD.BottomLeft.Bar:GetAlpha(), 1)
			SV.Events:Trigger("DOCK_LEFT_FADE_IN");
			PlaySoundFile([[sound\doodad\be_scryingorb_explode.ogg]])
		else
			MOD.private.LeftFaded = true;
			MOD.BottomLeft:FadeOut(0.2, MOD.BottomLeft:GetAlpha(), 0)
			MOD.BottomLeft.Bar:FadeOut(0.2, MOD.BottomLeft.Bar:GetAlpha(), 0)
			SV.Events:Trigger("DOCK_LEFT_FADE_OUT");
			PlaySoundFile([[sound\doodad\be_scryingorb_explode.ogg]])
		end
	end
end

_G.ToggleSuperDockRight = function(self, button)
	GameTooltip:Hide()
	if(button and IsAltKeyDown()) then
		SV:StaticPopup_Show('RESETDOCKS_CHECK')
	elseif(button and button == 'RightButton') then
		if(InCombatLockdown()) then
			MOD.ErrorSound()
			SV:AddonMessage(ERR_NOT_IN_COMBAT)
			return
		end
		MOD.ButtonSound()
		local userSize = SV.db.Dock.dockRightHeight
		if(not MOD.private.RightExpanded) then
			MOD.private.RightExpanded = true
			MOD.BottomRight.Window:SetHeight(userSize + 300)
		else
			MOD.private.RightExpanded = nil
			MOD.BottomRight.Window:SetHeight(userSize)
		end
		MOD.BottomRight.Bar:Update()
		MOD:UpdateDockBackdrops()
		SV.Events:Trigger("DOCK_RIGHT_EXPANDED");
	else
		if MOD.private.RightFaded then
			MOD.private.RightFaded = nil;
			MOD.BottomRight:FadeIn(0.2, MOD.BottomRight:GetAlpha(), 1)
			MOD.BottomRight.Bar:FadeIn(0.2, MOD.BottomRight.Bar:GetAlpha(), 1)
			SV.Events:Trigger("DOCK_RIGHT_FADE_IN");
			PlaySoundFile([[sound\doodad\be_scryingorb_explode.ogg]])
		else
			MOD.private.RightFaded = true;
			MOD.BottomRight:FadeOut(0.2, MOD.BottomRight:GetAlpha(), 0)
			MOD.BottomRight.Bar:FadeOut(0.2, MOD.BottomRight.Bar:GetAlpha(), 0)
			SV.Events:Trigger("DOCK_RIGHT_FADE_OUT");
			PlaySoundFile([[sound\doodad\be_scryingorb_explode.ogg]])
		end
	end
end

_G.ToggleSuperDocks = function()
	if(MOD.private.AllFaded) then
		MOD.private.AllFaded = nil;
		MOD.private.LeftFaded = nil;
		MOD.private.RightFaded = nil;
		MOD.BottomLeft:FadeIn(0.2, MOD.BottomLeft:GetAlpha(), 1)
		MOD.BottomLeft.Bar:FadeIn(0.2, MOD.BottomLeft.Bar:GetAlpha(), 1)
		SV.Events:Trigger("DOCK_LEFT_FADE_IN");
		MOD.BottomRight:FadeIn(0.2, MOD.BottomRight:GetAlpha(), 1)
		MOD.BottomRight.Bar:FadeIn(0.2, MOD.BottomRight.Bar:GetAlpha(), 1)
		SV.Events:Trigger("DOCK_RIGHT_FADE_IN");
		PlaySoundFile([[sound\doodad\be_scryingorb_explode.ogg]])
	else
		MOD.private.AllFaded = true;
		MOD.private.LeftFaded = true;
		MOD.private.RightFaded = true;
		MOD.BottomLeft:FadeOut(0.2, MOD.BottomLeft:GetAlpha(), 0)
		MOD.BottomLeft.Bar:FadeOut(0.2, MOD.BottomLeft.Bar:GetAlpha(), 0)
		SV.Events:Trigger("DOCK_LEFT_FADE_OUT");
		MOD.BottomRight:FadeOut(0.2, MOD.BottomRight:GetAlpha(), 0)
		MOD.BottomRight.Bar:FadeOut(0.2, MOD.BottomRight.Bar:GetAlpha(), 0)
		SV.Events:Trigger("DOCK_RIGHT_FADE_OUT");
		PlaySoundFile([[sound\doodad\be_scryingorb_explode.ogg]])
	end
end

function MOD:EnterFade()
	if MOD.private.LeftFaded then
		self.BottomLeft:FadeIn(0.2, self.BottomLeft:GetAlpha(), 1)
		self.BottomLeft.Bar:FadeIn(0.2, self.BottomLeft.Bar:GetAlpha(), 1)
		SV.Events:Trigger("DOCK_LEFT_FADE_IN");
	end
	if MOD.private.RightFaded then
		self.BottomRight:FadeIn(0.2, self.BottomRight:GetAlpha(), 1)
		self.BottomRight.Bar:FadeIn(0.2, self.BottomRight.Bar:GetAlpha(), 1)
		SV.Events:Trigger("DOCK_RIGHT_FADE_IN");
	end
end

function MOD:ExitFade()
	if MOD.private.LeftFaded then
		self.BottomLeft:FadeOut(2, self.BottomLeft:GetAlpha(), 0)
		self.BottomLeft.Bar:FadeOut(2, self.BottomLeft.Bar:GetAlpha(), 0)
		SV.Events:Trigger("DOCK_LEFT_FADE_OUT");
	end
	if MOD.private.RightFaded then
		self.BottomRight:FadeOut(2, self.BottomRight:GetAlpha(), 0)
		self.BottomRight.Bar:FadeOut(2, self.BottomRight.Bar:GetAlpha(), 0)
		SV.Events:Trigger("DOCK_RIGHT_FADE_OUT");
	end
end
--[[
##########################################################
DRAGGING HIGHLIGHT FUNCTIONS
##########################################################
]]--
local HighLight_OnUpdate = function(self)
	local highlight = self.Highlight;
	if(not highlight) then
		self:SetScript("OnUpdate", nil)
		return
	end
	if(highlight:IsMouseOver(50, -50, -50, 50)) then
		DRAGGING_TARGET = self.Data.Location;
		highlight:SetAlpha(1)
	else
		highlight:SetAlpha(0.2)
	end
end

local function AnchorInsertHighlight(dockbar)
	local location = dockbar.Data.Location;
	local lastTab = dockbar.Data.Order[#dockbar.Data.Order];
	local isLeft = (location:find('Left'));
	local anchor1 = isLeft and 'LEFT' or 'RIGHT';
	local anchor2 = isLeft and 'RIGHT' or 'LEFT';
	local xOff = isLeft and 2 or -2;
	dockbar.Highlight:ClearAllPoints();
	if(not lastTab) then
		dockbar.Highlight:SetPoint(anchor1, dockbar, anchor1, xOff, 0);
	else
		dockbar.Highlight:SetPoint(anchor1, _G[lastTab], anchor2, xOff, 0);
	end
end

local function ToggleBarHighlights(isShown)
	for location, settings in pairs(DOCK_LOCATIONS) do
		local dock = MOD[location];
		local dockbar = dock.Bar;
		if(dockbar) then
			--AnchorInsertHighlight(dockbar)
			if(isShown) then
				dockbar.Highlight:Show()
				dockbar.Highlight:SetAlpha(0.2)
				dockbar:SetScript("OnUpdate", HighLight_OnUpdate)
			else
				DRAGGING_TARGET = nil;
				dockbar.Highlight:Hide()
				dockbar:SetScript("OnUpdate", nil)
			end
		end
	end
end
--[[
##########################################################
DOCKBAR FUNCTIONS
##########################################################
]]--
local function DeactivateDockletButton(button)
	button:SetAttribute("isActive", false)
	button:SetPanelColor("default")
	if(button.Icon) then
		button.Icon:SetGradient(unpack(SV.media.gradient.icon));
	end
end

local function DeactivateAllDockletButtons(dockbar)
	local location = dockbar.Data.Location;
	local buttonList = dockbar.Data.Buttons;
	for nextName,nextButton in pairs(buttonList) do
		DeactivateDockletButton(nextButton)
	end
end

local function ActivateDockletButton(button)
	DeactivateAllDockletButtons(button.Parent);
	button:SetAttribute("isActive", true);
	button:SetPanelColor("default");
	if(button.Icon) then
		button.Icon:SetGradient(unpack(SV.media.gradient.checked));
	end
end

local function ShowDockletWindow(button, location)
	if((not button) or (not button.FrameLink)) then return end
	local window = button.FrameLink
	if((not window) or (not window.SetFrameLevel)) then return end
	if(not window:IsShown()) then
		if(not InCombatLockdown()) then
			window:SetFrameLevel(10)
			window:Show()
		end
	end
	window:FadeIn()
	SV.Events:Trigger("DOCKLET_SHOWN", location, button.LinkKey);
	return true;
end

local function HideDockletWindow(button, location)
	if((not button) or (not button.FrameLink)) then return end
	local window = button.FrameLink
	if((not window) or (not window.SetFrameLevel)) then return end
	if(not InCombatLockdown()) then
		window:SetFrameLevel(0)
		window:Hide()
	end
	window:FadeOut(0.1, 1, 0, true)
	SV.Events:Trigger("DOCKLET_HIDDEN", location, button.LinkKey);
	return true;
end

local function ResetAllDockletWindows(dockbar, button)
	local location = dockbar.Data.Location;
	local buttonList = dockbar.Data.Buttons;
	local currentButton = "";
	if(button and button.GetName) then
		currentButton = button:GetName()
	else
		dockbar.Parent.backdrop:Hide();
	end
	for nextName,nextButton in pairs(buttonList) do
		if(nextName ~= currentButton) then
			if(nextButton.FrameLink) then
				HideDockletWindow(nextButton, location)
			end
		end
	end
	SV.Events:Trigger("DOCKLET_RESET", location);
end

local DockBar_ResetAll = function(self)
	ResetAllDockletWindows(self);
	DeactivateAllDockletButtons(self);
end

local DockBar_SetDefault = function(self, button, isAdvanced)
	local location = self.Data.Location;
	if(button) then
		if(isAdvanced and button.ShowAdvancedDock) then
			DockBar_ResetAll(self)
			MOD.private.DefaultDocklets[location] = button:GetName();
		elseif(button.FrameLink) then
			MOD.private.DefaultDocklets[location] = button:GetName();
		end
	end

	if((not button) or (not button.FrameLink)) then
		local defaultButton = MOD.private.DefaultDocklets[location];
		button = _G[defaultButton];
	end

	if(button) then
		if(isAdvanced and button.ShowAdvancedDock) then
			button:ShowAdvancedDock()
			return true;
		elseif(button.FrameLink) then
			ResetAllDockletWindows(self, button);
			self.Parent.Window.FrameLink = button.FrameLink;
			self.Parent.Window:Show();
			self.Parent.Window:FadeIn();
			if(ShowDockletWindow(button, location)) then
				self.Parent.backdrop:Show();
				ActivateDockletButton(button);
				return true;
			end
		end
	end

	return false
end

local DockBar_NextDefault = function(self)
	local location = self.Data.Location;
	local buttonList = self.Data.Buttons;
	for name,button in pairs(buttonList) do
		if(button.FrameLink) then
			MOD.private.DefaultDocklets[location] = name;
			ResetAllDockletWindows(self, button);
			self.Parent.Window.FrameLink = button.FrameLink;
			self.Parent.Window:Show();
			self.Parent.Window:FadeIn();
			if(ShowDockletWindow(button, location)) then
				self.Parent.backdrop:Show();
				ActivateDockletButton(button);
				return;
			end
		end
	end
	SV.Events:Trigger("DOCKLET_LIST_EMPTY", location);
end

local DockBar_ChangeOrder = function(self, button, targetIndex)
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

local DockBar_UpdateOrder = function(self)
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

local DockBar_CheckOrder = function(self, targetName)
	local found = false;
	for i = 1, #self.Data.Order do
		if(self.Data.Order[i] == targetName) then
			found = true;
		end
	end
	if(not found) then
		tinsert(self.Data.Order, targetName);
		DockBar_UpdateOrder(self);
	end
end

local DockBar_UpdateLayout = function(self)
	local anchor = upper(self.Data.Location)
	local mod = self.Data.Modifier
	local size = self.ToolBar:GetHeight();
	local count = #self.Data.Order;
	local offset = 1;
	local safeIndex = 1;
	if(count > 0) then
		for i = 1, count do
			local nextName = self.Data.Order[i];
			local nextButton = self.Data.Buttons[nextName];
			if(nextButton) then
				offset = (safeIndex - 1) * (size + 6) + 6
				nextButton:ClearAllPoints();
				nextButton:SetSize(size, size);
				nextButton:SetPoint(anchor, self.ToolBar, anchor, (offset * mod), 0);
				if(not nextButton:IsShown()) then
					nextButton:Show();
				end
				nextButton.OrderIndex = safeIndex;
				safeIndex = safeIndex + 1;
			end
		end
	end

	self.ToolBar:SetWidth(offset + size);
end

local DockBar_AddButton = function(self, button, forced)
	if not button then return end
	local name = button:GetName();
	local currentLocation = self.Data.Location
	if(self.Data.Buttons[name] and (not forced)) then return end

	local registeredLocation = MOD.private.Locations[name]

	if(registeredLocation) then
		if(registeredLocation ~= currentLocation) then
			if(MOD[registeredLocation].Bar.Data.Buttons[name]) then
				MOD[registeredLocation].Bar:Remove(button, true);
			else
				MOD[registeredLocation].Bar:Add(button);
				return
			end
		end
	end

	self.Data.Buttons[name] = button;
	DockBar_CheckOrder(self, name);

	MOD.private.Locations[name] = currentLocation;
	button.Parent = self;
	button:SetParent(self.ToolBar);

	if(button.FrameLink) then
		local frame = button.FrameLink
		local frameName = frame:GetName()
		self.Data.Windows[frameName] = frame;
		MOD.private.Locations[frameName] = currentLocation;
		frame:Show()
		frame:ClearAllPoints()
		frame:SetParent(self.Parent.Window)
		frame:InsetPoints(self.Parent.Window)
		frame.Parent = self.Parent
		frame:FadeIn()
		if(not MOD.private.DefaultDocklets[currentLocation]) then
			DockBar_SetDefault(self, button)
		end
	end

	self:SetDefault()
	self:Update()
end

local DockBar_RemoveButton = function(self, button, isMoving)
	if not button then return end
	local name = button:GetName();
	local registeredLocation = MOD.private.Locations[name];
	local currentLocation = self.Data.Location

	if(registeredLocation and (registeredLocation == currentLocation)) then
		MOD.private.Locations[name] = nil;
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
	button.OrderIndex = 0;
	if(button.FrameLink) then
		local frameName = button.FrameLink:GetName()
		MOD.private.Locations[frameName] = nil;
		if(not isMoving) then
			button.FrameLink:FadeOut(0.2, 1, 0, true)
		end
		self.Data.Windows[frameName] = nil;
	end

	if(#self.Data.Order == 0) then
		MOD.private.DefaultDocklets[currentLocation] = nil;
		self.Parent.backdrop:Hide()
	end

	self.Data.Buttons[name] = nil;
	DockBar_UpdateOrder(self);
	if(MOD.private.DefaultDocklets[currentLocation] == name or (not MOD.private.DefaultDocklets[currentLocation]) or (MOD.private.DefaultDocklets[currentLocation] == "")) then
		self:NextDefault()
	else
		self:SetDefault()
	end
	self:Update()
end
--[[
##########################################################
DOCKBUTTON FUNCTIONS
##########################################################
]]--
local DockButton_OnDragStart = function(self)
	if(IsShiftKeyDown() and (not InCombatLockdown())) then
		self:SetMovable(true);
		self:StartMoving();
		ToggleBarHighlights(true);
	end
end

local DockButton_OnDragStop = function(self)
	self:StopMovingOrSizing();
	self:SetMovable(false);
	if(DRAGGING_TARGET) then
		self:MoveTo(DRAGGING_TARGET);
	else
		self:MoveTo(MOD.private.Locations[self:GetName()]);
	end
	DRAGGING_TARGET = nil;
	ToggleBarHighlights(false)
end

local DockButton_OnEnter = function(self, ...)
	MOD:EnterFade()
	self:SetPanelColor("highlight")
	self.Icon:SetGradient(unpack(SV.media.gradient.highlight))
	local tipAnchor = self:GetAttribute("tipAnchor")
	GameTooltip:SetOwner(self, tipAnchor, 0, 4)
	GameTooltip:ClearLines()
	if(self.CustomTooltip) then
		self:CustomTooltip()
	else
		local tipText = self:GetAttribute("tipText")
		GameTooltip:AddDoubleLine("[Left-Click]", tipText, 0, 1, 0, 1, 1, 1)
		GameTooltip:AddDoubleLine("[Right-Click]", "Hide", 0, 1, 0, 1, 1, 1)
		GameTooltip:AddDoubleLine("[Shift+Click+Drag]", "Move To Another Dock", 0, 1, 0, 1, 1, 1)
	end
	if(self:GetAttribute("hasDropDown") and self.GetMenuList) then
		GameTooltip:AddLine(" ")
		GameTooltip:AddDoubleLine("[Alt+Click]", "Docking Options", 0, 0.5, 1, 0.5, 1, 0.5)
	end
	GameTooltip:Show()
end

local DockButton_OnLeave = function(self, ...)
	MOD:ExitFade()
	self:SetPanelColor("default")
	if(self:GetAttribute("isActive")) then
		self.Icon:SetGradient(unpack(SV.media.gradient.checked))
	else
		self.Icon:SetGradient(unpack(SV.media.gradient.icon))
	end
	GameTooltip:Hide()
end

local DockButton_OnClick = function(self, button)
	if(self.ClickTheme) then
		self:ClickTheme()
	end
	MOD.ButtonSound()
	if(button and (button == "RightButton") and (not IsShiftKeyDown())) then
		self.Parent.Parent.backdrop:Hide()
		self:SetAttribute("isActive", false)
		self:SetPanelColor("default")
		if(self.Icon) then
			self.Icon:SetGradient(unpack(SV.media.gradient.icon));
		end
		if(self.FrameLink) then
			local registeredLocation = MOD.private.Locations[self.LocationKey];
			HideDockletWindow(self, registeredLocation)
		end
	else
		if(IsAltKeyDown() and (not InCombatLockdown()) and self:GetAttribute("hasDropDown") and self.GetMenuList) then
			local list = self:GetMenuList();
			SV.Dropdown:Open(self, list, "Dock Options");
		else
			local clickAllowed = false;
			if(self.FrameLink) then
				clickAllowed = DockBar_SetDefault(self.Parent, self)
			else
				clickAllowed = true;
			end
			if(self.PostClickFunction and clickAllowed) then
				self:PostClickFunction(button)
			end
		end
	end
end

local DockButton_OnPostClick = function(self, ...)
	if InCombatLockdown() then
		MOD.ErrorSound()
		return
	end
	if(self.ClickTheme) then
		self:ClickTheme()
	end
	MOD.ButtonSound()
	if(IsAltKeyDown() and self:GetAttribute("hasDropDown") and self.GetMenuList) then
		local list = self:GetMenuList();
		SV.Dropdown:Open(self, list, "Dock Options");
	end
end

local DockButton_GetMenuList = function(self)
	local button = self;
	local name = button:GetName();
	local currentLocation = MOD.private.Locations[name];
	local t;

	if(self.ExternalMenuList) then
		t = self:ExternalMenuList();
	else
		t = {}
	end

	tinsert(t, { title = "Re-Order", divider = true });

	for i=1, #button.Parent.Data.Order do
		if(i ~= button.OrderIndex) then
			local positionText = ("Position #%d"):format(i);
		    tinsert(t, { text = positionText, func = function() DockBar_ChangeOrder(button.Parent, button, i) end });
		end
	end

	return t;
end

local DockButton_SetDocked = function(self, attach)
	if(not self.Parent) then return end
	if(attach) then
		if(not self.Parent.Add) then return end
		self.Parent:Add(self)
	else
		if(not self.Parent.Remove) then return end
		self.Parent:Remove(self)
	end
end

local DockButton_MoveTo = function(self, location)
	if(not MOD[location]) then return end
	local previousLocation = MOD.private.Locations[self.LocationKey];
	MOD[location].Bar:Add(self, true);
	SV.Events:Trigger("DOCKLET_LIST_DECREASED", previousLocation);
	SV.Events:Trigger("DOCKLET_LIST_INCREASED", location);
	SV.Events:Trigger("DOCKLET_MOVED", self.LocationKey);
end
--[[
##########################################################
REMAINING DOCKBAR FUNCTIONS
##########################################################
]]--
local DockBar_CreateButton = function(self, displayName, globalName, texture, clickFunction, tipFunction, primaryTemplate, frameLink)
	local dockIcon = texture or [[Interface\AddOns\SVUI_!Core\assets\textures\Dock\DOCK-ICON-ADDON]];
	local size = self.ToolBar:GetHeight();
	local template = "SVUI_DockletButtonTemplate"
	local isAction = false;

	if(primaryTemplate) then
		template = primaryTemplate .. ", SVUI_DockletButtonTemplate";
		isAction = true;
	end

	local button = _G[globalName .. "DockletButton"] or CreateFrame("Button", globalName, self.ToolBar, template)

	button:ClearAllPoints()
	button:SetSize(size, size)
	MOD:SetButtonTheme(button, size)
	button:SetPanelColor("default")
	button.Icon:SetTexture(dockIcon)
	button.Icon:SetGradient(unpack(SV.media.gradient.icon))

	button:SetAttribute("tipText", displayName)
	button:SetAttribute("tipAnchor", self.Data.TipAnchor)
	button:SetScript("OnEnter", DockButton_OnEnter)
	button:SetScript("OnLeave", DockButton_OnLeave)
	button:RegisterForDrag("LeftButton");
	button:SetScript("OnDragStart", DockButton_OnDragStart);
	button:SetScript("OnDragStop", DockButton_OnDragStop);
	if(not isAction) then
		button:SetScript("OnClick", DockButton_OnClick)
	else
		button:SetScript("PostClick", DockButton_OnPostClick)
	end

	button.Parent 			= self;
  button.OrderIndex 	= 0;
	button.LocationKey  = globalName;
	button.MoveTo				= DockButton_MoveTo
	button.GetMenuList 	= DockButton_GetMenuList
	button.SetDocked 		= DockButton_SetDocked

	if(clickFunction and type(clickFunction) == "function") then
		button.PostClickFunction = clickFunction
	end

	if(tipFunction and type(tipFunction) == "function") then
		button.CustomTooltip = tipFunction
	end

	if(frameLink) then
		button.FrameLink = frameLink
		button.LinkKey   = frameLink:GetName();
	end

  self:Add(button)

	return button
end

function MOD:SetDockButton(location, displayName, globalName, texture, clickFunction, tipFunction, primaryTemplate)
	if(not self.private) then return end
	if(self.private.Locations[globalName]) then
		location = self.private.Locations[globalName];
	else
		self.private.Locations[globalName] = location;
	end
	local parent = self[location]
	return DockBar_CreateButton(parent.Bar, displayName, globalName, texture, clickFunction, tipFunction, primaryTemplate)
end
--[[
##########################################################
DOCKS
##########################################################
]]--
MOD.TopCenter = _G["SVUI_DockTopCenter"];
MOD.BottomCenter = _G["SVUI_DockBottomCenter"];

local DockBar_OnEvent = function(self, event)
    if(event == 'PLAYER_REGEN_ENABLED') then
        self:UnregisterEvent("PLAYER_REGEN_ENABLED")
				DockBar_SetDefault(self)
    end
end

local DockAlert_Activate = function(self, child)
	local size = SV.db.Dock.buttonSize or 22;
	self:SetHeight(size)
	self.backdrop:Show()
	child:ClearAllPoints()
	child:SetAllPoints(self)
end

local DockAlert_Deactivate = function(self)
	self.backdrop:Hide()
	self:SetHeight(1)
end

for location, settings in pairs(DOCK_LOCATIONS) do
	MOD[location] = _G["SVUI_Dock" .. location];
	MOD[location].Bar = _G["SVUI_DockBar" .. location];

	MOD[location].Alert.Activate 		= DockAlert_Activate;
	MOD[location].Alert.Deactivate 	= DockAlert_Deactivate;

	MOD[location].Bar.Parent 			= MOD[location];
	MOD[location].Bar.SetDefault 	= DockBar_SetDefault;
	MOD[location].Bar.NextDefault = DockBar_NextDefault;
	MOD[location].Bar.Reset 			= DockBar_ResetAll;
	MOD[location].Bar.Update 			= DockBar_UpdateLayout;
	MOD[location].Bar.Add 				= DockBar_AddButton;
	MOD[location].Bar.Remove 			= DockBar_RemoveButton;
	MOD[location].Bar.Create 			= DockBar_CreateButton;
	MOD[location].Bar.Data = {
		Location = location,
		Anchor = settings[2],
		Modifier = settings[1],
		TipAnchor = settings[4],
		Buttons = {},
		Windows = {},
		Order = {},
	};
	--MOD[location].Bar:SetScript("OnEvent", DockBar_OnEvent)
end
--[[
##########################################################
DOCKLETS (DOCK BUTTONS WITH ASSOCIATED WINDOWS)
##########################################################
]]--
local Docklet_Enable = function(self)
	local dock = self.Parent;
	if(self.Button) then dock.Bar:Add(self.Button) end
end

local Docklet_Disable = function(self)
	local dock = self.Parent;
	if(self.Button) then dock.Bar:Remove(self.Button) end
end

local Docklet_ButtonSize = function(self)
	local size = self.Bar.ToolBar:GetHeight() or 30;
	return size;
end

local Docklet_Relocate = function(self, location)
	local newParent = MOD[location];

	if(not newParent) then return end

	if(self.Button) then
		newParent.Bar:Add(self.Button)
	end

	if(self.Bar) then
		local height = newParent.Bar.ToolBar:GetHeight();
		local mod = newParent.Bar.Data[1];
		local barAnchor = newParent.Bar.Data[2];
		local barReverse = SV:GetReversePoint(barAnchor);
		local spacing = SV.db.Dock.buttonSpacing;

		self.Bar:ClearAllPoints();
		self.Bar:SetPoint(barAnchor, newParent.Bar.ToolBar, barReverse, (spacing * mod), 0)
	end
end

function MOD:NewDocklet(location, globalName, readableName, texture, onclick)
	if(DOCK_REGISTRY[globalName]) then return end;

	if(self.private.Locations[globalName]) then
		location = self.private.Locations[globalName];
	else
		self.private.Locations[globalName] = location;
	end

	local newParent = self[location];
	if(not newParent) then return end
	newParent.backdrop:Show()
	local frame = _G[globalName] or CreateFrame("Frame", globalName, UIParent, "SVUI_DockletWindowTemplate");
	frame:SetParent(newParent.Window);
	frame:SetSize(newParent.Window:GetSize());
	frame:SetAllPoints(newParent.Window);
	frame:SetFrameStrata("BACKGROUND");
	frame.Parent = newParent
	frame.Disable = Docklet_Disable;
	frame.Enable = Docklet_Enable;
	frame.Relocate = Docklet_Relocate;
	frame.GetButtonSize = Docklet_ButtonSize;

	newParent.Bar.Data.Windows[globalName] = frame;

	local buttonName = ("%sButton"):format(globalName)
	frame.Button = newParent.Bar:Create(readableName, buttonName, texture, onclick, false, false, frame);
	DOCK_REGISTRY[globalName] = frame;
	frame:SetAlpha(0)
	DOCK_CHECK = true
	return frame
end

function MOD:NewAdvancedDocklet(location, globalName)
	if(DOCK_REGISTRY[globalName]) then return end;

	if(self.private.Locations[globalName]) then
		location = self.private.Locations[globalName];
	else
		self.private.Locations[globalName] = location;
	end

	local newParent = self[location];
	if(not newParent) then return end
	newParent.backdrop:Show()
	local frame = CreateFrame("Frame", globalName, UIParent, "SVUI_DockletWindowTemplate");
	frame:SetParent(newParent.Window);
	frame:SetSize(newParent.Window:GetSize());
	frame:SetAllPoints(newParent.Window);
	frame:SetFrameStrata("BACKGROUND");
	frame.Parent = newParent;
	frame.Disable = Docklet_Disable;
	frame.Enable = Docklet_Enable;
	frame.Relocate = Docklet_Relocate;
	frame.GetButtonSize = Docklet_ButtonSize;

	newParent.Bar.Data.Windows[globalName] = frame;

	local height = newParent.Bar.ToolBar:GetHeight();
	local mod = newParent.Bar.Data.Modifier;
	local barAnchor = newParent.Bar.Data.Anchor;
	local barReverse = SV:GetReversePoint(barAnchor);
	local spacing = SV.db.Dock.buttonSpacing;

	frame.Bar = CreateFrame("Frame", globalName.."Bar", newParent);
	frame.Bar:SetSize(1, height);
	frame.Bar:SetPoint(barAnchor, newParent.Bar.ToolBar, barReverse, (spacing * mod), 0)
	SV:NewAnchor(frame.Bar, globalName .. " Dock Bar");

	DOCK_REGISTRY[globalName] = frame;
	DOCK_CHECK = true
	return frame
end
--[[
##########################################################
BUILD/UPDATE
##########################################################
]]--
local CornerButton_OnEnter = function(self, ...)
	MOD:EnterFade()

	self:SetPanelColor("highlight")
	self.Icon:SetGradient(unpack(SV.media.gradient.highlight))

	GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 4)
	GameTooltip:ClearLines()
	local tipText = self:GetAttribute("tipText")
	GameTooltip:AddDoubleLine("[Left-Click]", tipText, 0, 1, 0, 1, 1, 1)
	local tipExtraText = self:GetAttribute("tipExtraText")
	GameTooltip:AddDoubleLine("[Right-Click]", tipExtraText, 0, 1, 0, 1, 1, 1)
	GameTooltip:AddLine(" ")
	GameTooltip:AddDoubleLine("[Alt + Click]", "Reset Dock Buttons", 0, 0.5, 1, 0.5, 1, 0.5)
	GameTooltip:Show()
end

local CornerButton_OnLeave = function(self, ...)
	MOD:ExitFade()
	self:SetPanelColor("default")
	if(self:GetAttribute("isActive")) then
		self.Icon:SetGradient(unpack(SV.media.gradient.checked))
	else
		self.Icon:SetGradient(unpack(SV.media.gradient.icon))
	end
	GameTooltip:Hide()
end

function MOD:UpdateDockBackdrops()
	if(DOCK_CHECK and SV.db.Dock.rightDockBackdrop) then
		MOD.BottomRight.backdrop:Show()
		MOD.BottomRight.backdrop:ClearAllPoints()
		MOD.BottomRight.backdrop:WrapPoints(MOD.BottomRight.Window, 4, 4)

		MOD.BottomRight.Alert.backdrop:ClearAllPoints()
		MOD.BottomRight.Alert.backdrop:WrapPoints(MOD.BottomRight.Alert, 4, 4)
	else
		MOD.BottomRight.backdrop:Hide()
	end
	if(DOCK_CHECK and SV.db.Dock.leftDockBackdrop) then
		MOD.BottomLeft.backdrop:Show()
		MOD.BottomLeft.backdrop:ClearAllPoints()
		MOD.BottomLeft.backdrop:WrapPoints(MOD.BottomLeft.Window, 4, 4)

		MOD.BottomLeft.Alert.backdrop:ClearAllPoints()
		MOD.BottomLeft.Alert.backdrop:WrapPoints(MOD.BottomLeft.Alert, 4, 4)
	else
		MOD.BottomLeft.backdrop:Hide()
	end
end

function MOD:ResetAllButtons()
	wipe(MOD.private.Order)
	wipe(MOD.private.Locations)
	ReloadUI()
end

function MOD:Refresh()
	local buttonsize = SV.db.Dock.buttonSize;
	local spacing = SV.db.Dock.buttonSpacing;

	for location, settings in pairs(DOCK_LOCATIONS) do
		local width, height = GetDockDimensions(location);
		local dock = self[location];

		dock.Bar:SetSize(width, buttonsize)
    dock.Bar.ToolBar:SetHeight(buttonsize)
    dock:SetSize(width, height)
    dock.Alert:SetSize(width, 1)
    dock.Window:SetSize(width, height)

    if(dock.Bar.Button) then
    	dock.Bar.Button:SetSize(buttonsize, buttonsize)
    end

    dock.Bar:Update()
	end

	local centerWidth = SV.db.Dock.dockCenterWidth;
	local dockWidth = centerWidth * 0.5;
	local dockHeight = SV.db.Dock.dockCenterHeight;

	self.BottomCenter:SetSize(centerWidth, dockHeight);
	self.TopCenter:SetSize(centerWidth, dockHeight);

	ScreenBorderVisibility();

	self:UpdateDockBackdrops();

	self:UpdateProfessionTools();
	self:UpdateMiscTools();
	self:UpdateGarrisonTool();
	self:UpdateRaidLeader();

	SV.Events:Trigger("DOCKS_UPDATED");
end

function MOD:PLAYER_REGEN_ENABLED()
	self:UnregisterEvent('PLAYER_REGEN_ENABLED')

	if(self.ProfessionNeedsUpdate) then
		self.ProfessionNeedsUpdate = nil;
		self:UpdateProfessionTools()
	end

	if(self.MiscNeedsUpdate) then
		self.MiscNeedsUpdate = nil;
		self:UpdateMiscTools()
	end

	if(self.GarrisonNeedsUpdate) then
		self.GarrisonNeedsUpdate = nil;
		self:UpdateGarrisonTool()
	end

	if(self.RaidLeaderNeedsUpdate) then
		self.RaidLeaderNeedsUpdate = nil;
		self:UpdateRaidLeader()
	end
end

function MOD:Load()
	if(not SV.private.Docks) then
		SV.private.Docks = {}
	end

	self.private = SV.private.Docks;

	if(not self.private.AllFaded) then
		self.private.AllFaded = false
	end

	if(not self.private.LeftFaded) then
		self.private.LeftFaded = false
	end

	if(not self.private.RightFaded) then
		self.private.RightFaded = false
	end

	if(not self.private.LeftExpanded) then
		self.private.LeftExpanded = false
	end

	if(not self.private.RightExpanded) then
		self.private.RightExpanded = false
	end

	if(not self.private.Order) then
		self.private.Order = {}
	end

	if(not self.private.DefaultDocklets) then
		self.private.DefaultDocklets = {}
	end

	if(not self.private.Locations) then
		self.private.Locations = {}
	end

	local buttonsize = SV.db.Dock.buttonSize;
	local spacing = SV.db.Dock.buttonSpacing;

	-- [[ TOP AND BOTTOM BORDERS ]] --

	self.Border.Top = CreateFrame("Frame", "SVUIDock_TopBorder", SV.Screen);
	self.Border.Bottom = CreateFrame("Frame", "SVUIDock_BottomBorder", SV.Screen);
	self:SetBorderTheme();
	ScreenBorderVisibility();

	for location, settings in pairs(DOCK_LOCATIONS) do
		local width, height = GetDockDimensions(location);
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
		dock.Bar:SetSize(width, buttonsize)
		dock.Bar:SetPoint(anchor, SV.Screen, anchor, (2 * mod), (2 * vertMod))

		local highlight = CreateFrame("Frame", nil, dock.Bar)
		if(location:find('Top')) then
			highlight:SetPoint("TOPLEFT", dock.Bar, "TOPLEFT", 0, 0)
			highlight:SetPoint("TOPRIGHT", dock.Bar, "TOPRIGHT", 0, 0)
			highlight:SetHeight(buttonsize * 2)
			highlight.texture = highlight:CreateTexture(nil, "OVERLAY")
			highlight.texture:SetAllPoints()
			highlight.texture:SetTexture(SV.media.statusbar.default);
			highlight.texture:SetGradientAlpha("VERTICAL",0,0.3,0.3,0,0,1,1,0.8)
		else
			highlight:SetPoint("BOTTOMLEFT", dock.Bar, "BOTTOMLEFT", 0, 0)
			highlight:SetPoint("BOTTOMRIGHT", dock.Bar, "BOTTOMRIGHT", 0, 0)
			highlight:SetHeight(buttonsize * 2)
			highlight.texture = highlight:CreateTexture(nil, "OVERLAY")
			highlight.texture:SetAllPoints()
			highlight.texture:SetTexture(SV.media.statusbar.default);
			highlight.texture:SetGradientAlpha("VERTICAL",0,1,1,0.8,0,0.3,0.3,0)
		end
		highlight:Hide()

		dock.Bar.Highlight = highlight

		if(not MOD.private.Order[location]) then
			MOD.private.Order[location] = {}
		end

		dock.Bar.Data.Order = MOD.private.Order[location];

		dock.Bar.ToolBar:ClearAllPoints()

		if(dock.Bar.Button) then
    	dock.Bar.Button:SetSize(buttonsize, buttonsize)
    	self:SetButtonTheme(dock.Bar.Button, buttonsize)
    	dock.Bar.Button.Icon:SetTexture(SV.media.icon.default)
    	dock.Bar.ToolBar:SetSize(1, buttonsize)
    	dock.Bar.ToolBar:SetPoint(barAnchor, dock.Bar.Button, barReverse, (spacing * mod), 0)
			dock.Bar.Button:SetPanelColor("default")
			dock.Bar.Button.Icon:SetGradient(unpack(SV.media.gradient.icon))
			dock.Bar.Button:SetScript("OnEnter", CornerButton_OnEnter)
			dock.Bar.Button:SetScript("OnLeave", CornerButton_OnLeave)
			if(location == "BottomLeft") then
				dock.Bar.Button:SetScript("OnClick", ToggleSuperDockLeft)
			else
				dock.Bar.Button:SetScript("OnClick", ToggleSuperDockRight)
			end
    else
    	dock.Bar.ToolBar:SetSize(1, buttonsize)
    	dock.Bar.ToolBar:SetPoint(barAnchor, dock.Bar, barAnchor, 0, 0)
    end

    dock:SetParent(SV.Screen)
    dock:ClearAllPoints()
    dock:SetPoint(anchor, dock.Bar, reverse, 0, (12 * vertMod))
    dock:SetSize(width, height)
    dock:SetAttribute("buttonSize", buttonsize)
    dock:SetAttribute("spacingSize", spacing)

    dock.Alert:ClearAllPoints()
    dock.Alert:SetSize(width, 1)
    dock.Alert:SetPoint(anchor, dock, anchor, 0, 0)

    dock.Window:ClearAllPoints()
    dock.Window:SetSize(width, height)
    dock.Window:SetPoint(anchor, dock.Alert, reverse, 0, 4)
		dock.backdrop = self.SetThemeDockStyle(dock.Window, isBottom)
		dock.backdrop:Hide()
		dock.Alert.backdrop = self.SetThemeDockStyle(dock.Alert, isBottom)
		dock.Alert.backdrop:Hide()

		SV:NewAnchor(dock.Bar, location .. " Dock ToolBar");
		SV:SetAnchorResizing(dock.Bar, dockBarPostSizeFunc, 10, 500, 10, 80);
		SV:NewAnchor(dock, location .. " Dock Window");
		SV:SetAnchorResizing(dock, dockPostSizeFunc, 10, 500);
	end

	if MOD.private.LeftFaded then MOD.BottomLeft:Hide() end
	if MOD.private.RightFaded then MOD.BottomRight:Hide() end

	SV:ManageVisibility(self.BottomRight.Window)
	SV:ManageVisibility(self.TopLeft)
	SV:ManageVisibility(self.TopRight)
	--SV:ManageVisibility(self.BottomCenter)
	SV:ManageVisibility(self.TopCenter)

	local centerWidth = SV.db.Dock.dockCenterWidth;
	local dockHeight = SV.db.Dock.dockCenterHeight;

	self.TopCenter:SetParent(SV.Screen)
	self.TopCenter:ClearAllPoints()
	self.TopCenter:SetSize(centerWidth, dockHeight)
	self.TopCenter:SetPoint("TOP", SV.Screen, "TOP", 0, 0)

	self.BottomCenter:SetParent(SV.Screen)
	self.BottomCenter:ClearAllPoints()
	self.BottomCenter:SetSize(centerWidth, dockHeight)
	self.BottomCenter:SetPoint("BOTTOM", SV.Screen, "BOTTOM", 0, 0)

	DockBar_SetDefault(self.BottomLeft.Bar)
	DockBar_SetDefault(self.BottomRight.Bar)
	DockBar_SetDefault(self.TopLeft.Bar)
	DockBar_SetDefault(self.TopRight.Bar)

	self:LoadProfessionTools();
	self:LoadAllMiscTools();
	self:LoadGarrisonTool();
	self:LoadRaidLeaderTools();
	self:LoadBreakStuff();
end

local function UpdateAllDocks()
	for location, settings in pairs(DOCK_LOCATIONS) do
		local dock = MOD[location];
		DockBar_SetDefault(dock.Bar)
	end

	MOD:UpdateDockBackdrops()
end

SV:NewScript(UpdateAllDocks)
