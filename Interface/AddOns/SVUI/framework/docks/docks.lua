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
local L = SV.L
--[[ 
########################################################## 
DOCKING
##########################################################
]]--
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

local MOVE_LOCATIONS = { "BottomLeft", "BottomRight", "TopLeft" };

local Dock = SV:NewSubClass("Dock", L["Docks"]);

Dock.Border = {};

Dock.Registration = {
	Windows = {},
	Buttons = {},
	Options = {}
};
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
_G.HideSuperDocks = function()
	GameTooltip:Hide()
	if SV.cache.Docks.IsFaded then 
		SV.cache.Docks.IsFaded = nil;
		SV:SecureFadeIn(Dock.BottomLeft, 0.2, Dock.BottomLeft:GetAlpha(), 1)
		SV:SecureFadeIn(Dock.BottomRight, 0.2, Dock.BottomRight:GetAlpha(), 1)
	else 
		SV.cache.Docks.IsFaded = true;
		SV:SecureFadeOut(Dock.BottomLeft, 0.2, Dock.BottomLeft:GetAlpha(), 0, true)
		SV:SecureFadeOut(Dock.BottomRight, 0.2, Dock.BottomRight:GetAlpha(), 0, true)
	end
end

function Dock:EnterFade()
	if SV.cache.Docks.IsFaded then 
		self.BottomLeft:Show()
		SV:SecureFadeIn(self.BottomLeft, 0.2, self.BottomLeft:GetAlpha(), 1)
		self.BottomRight:Show()
		SV:SecureFadeIn(self.BottomRight, 0.2, self.BottomRight:GetAlpha(), 1)
	end
end 

function Dock:ExitFade()
	if SV.cache.Docks.IsFaded then 
		SV:SecureFadeOut(self.BottomLeft, 0.2, self.BottomLeft:GetAlpha(), 0, true)
		SV:SecureFadeOut(self.BottomRight, 0.2, self.BottomRight:GetAlpha(), 0, true)
	end
end
--[[ 
########################################################## 
SET DOCKBAR FUNCTIONS
##########################################################
]]--
local RefreshDockButtons = function(self)
	for name,docklet in pairs(Dock.Registration.Windows) do
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
			button:Activate()
		end
	end
end

local ToggleDockletWindow = function(self, button)
	local frame  = button.FrameLink
	if(frame and frame.Show) then
		self.Parent.Window.FrameLink = frame
		
		if(not frame:IsShown()) then
			self:Refresh()
		end

		if(not self.Parent.Window:IsShown()) then
			self.Parent.Window:Show()
		end

		frame:Show()
		
		button:Activate()
	else
		button:Deactivate()
		self:GetDefault()
	end
	if(SV.Dropdown:IsShown()) then
		ToggleFrame(SV.Dropdown)
	end
end

local AlertActivate = function(self, child)
	local size = SV.db.Dock.buttonSize or 22;
	self:Height(size)
	child:ClearAllPoints()
	child:SetAllPoints(self)
end 

local AlertDeactivate = function(self)
	self:Height(1)
end

local Docklet_OnShow = function(self)
	local frame = self.FrameLink
	if(frame and frame.Show) then
		if(InCombatLockdown() and (frame.IsProtected and frame:IsProtected())) then return end 
		frame:Show()
	end 
end

local DockButtonMakeDefault = function(self)
	self.Parent.Data.Default = self:GetName()
	self.Parent:GetDefault()
end 

local DockButtonActivate = function(self)
	self:SetAttribute("isActive", true)
	self:SetPanelColor("green")
	self.Icon:SetGradient(unpack(SV.Media.gradient.green))
end 

local DockButtonDeactivate = function(self)
	self:SetAttribute("isActive", false)
	self:SetPanelColor("default")
	self.Icon:SetGradient(unpack(SV.Media.gradient.icon))
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
	elseif(SV.Dropdown:IsShown()) then
		ToggleFrame(SV.Dropdown)
	end
end

local DockletEnable = function(self)
	local dock = self.Parent;
	dock.Bar:Add(self.DockButton)
end

local DockletDisable = function(self)
	local dock = self.Parent;
	dock.Bar:Remove(self.DockButton)
end

local GetDockablePositions = function(self)
	local button = self;
	local name = button:GetName();
	local bar = button.Parent;
	local currentLocation = Dock.Registration.Buttons[name];

	local t = {{text = "Disable", func = function() bar:Remove(button) end}};

	for _,location in pairs(MOVE_LOCATIONS) do
		if(currentLocation ~= location) then
		    local key = "Move to " .. location
		    local otherbar = Dock[location].Bar
		    tinsert(t,{text = key, func = function() otherbar:Add(button) end});
		end
	end
	return t;
end

local AddToDock = function(self, button)
	local name = button:GetName();
	local registeredLocation = Dock.Registration.Buttons[name]
	local currentLocation = self.Data.Location
	if(registeredLocation) then
		if(registeredLocation == currentLocation) then 
			return 
		else
			Dock[registeredLocation].Bar:Remove(button)
		end
	end
	Dock.Registration.Buttons[name] = currentLocation;
	local anchor = upper(currentLocation)
	local mod = self.Data.Modifier
	local height = self.ToolBar:GetHeight();
	local xOffset = #self.Data.Buttons * (height + 6) + 6
	button:ClearAllPoints()
	button:SetParent(self.ToolBar);
	button:SetPoint(anchor, self.ToolBar, anchor, (xOffset * mod), 0);
	tinsert(self.Data.Buttons, button)
 	button.listIndex = #self.Data.Buttons;
	button:Show()
	local newWidth = xOffset + height
	self.ToolBar:SetWidth(newWidth)

	if(button.FrameLink) then
		button.FrameLink:ClearAllPoints()
		button.FrameLink:SetParent(self.Parent.Window)
		button.FrameLink:FillInner(self.Parent.Window, 4, 4)
	end
end

local RemoveFromDock = function(self, button)
	if not button or not button.listIndex then return end 
	local name = button:GetName();
	local registeredLocation = Dock.Registration.Buttons[name];
	local currentLocation = self.Data.Location
	if(not registeredLocation or (registeredLocation and (registeredLocation ~= currentLocation))) then return end 
	Dock.Registration.Buttons[name] = nil;
	local index = button.listIndex;
	tremove(self.Data.Buttons, index)
	button:Hide()
	if(button.FrameLink) then
		button.FrameLink:Hide()
	end
	local height = self.ToolBar:GetHeight();
	local anchor = upper(currentLocation)
	local mod = self.Data.Modifier
	local xOffset = 0
	for i = 1, #self.Data.Buttons do
		local nextButton = self.Data.Buttons[i]
		xOffset = (i - 1) * (height + 6) + 6
		nextButton:ClearAllPoints()
		nextButton:SetPoint(anchor, self.ToolBar, anchor, (xOffset * mod), 0);
	end
	local newWidth = xOffset + 1
	self.ToolBar:SetWidth(newWidth)
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

local CreateBasicToolButton = function(self, displayName, texture, onclick, frameName, tipFunction, primaryTemplate)
	local globalName = frameName or displayName;
	local dockIcon = texture or [[Interface\AddOns\SVUI\assets\artwork\Icons\SVUI-ICON]];
	local size = self.ToolBar:GetHeight();
	local template = "SVUI_DockletButtonTemplate"

	if(primaryTemplate) then
		template = primaryTemplate .. ", SVUI_DockletButtonTemplate"
	end

	local button = _G[globalName .. "DockletButton"] or CreateFrame("Button", ("%sDockletButton"):format(globalName), self.ToolBar, template)

	button:ClearAllPoints()
	button:Size(size, size)
	button:SetFramedButtonTemplate()
	button.Icon:SetTexture(dockIcon)
	button:SetAttribute("tipText", displayName)
    button:SetAttribute("ownerFrame", globalName)

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
	Dock[location].Bar.Toggle = ToggleDockletWindow;
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

local function BorderColorUpdates()
	Dock.Border.Top:SetBackdropColor(unpack(SV.Media.color.specialdark))
	Dock.Border.Top:SetBackdropBorderColor(0,0,0,1)
	Dock.Border.Bottom:SetBackdropColor(unpack(SV.Media.color.special))
	Dock.Border.Bottom:SetBackdropBorderColor(0,0,0,1)
end

SV:NewCallback(BorderColorUpdates)
--[[ 
########################################################## 
EXTERNALLY ACCESSIBLE METHODS
##########################################################
]]--
function Dock:GetDimensions()
	local leftWidth = SV.Screen.Estimates.width;
	if(SV.db.Dock.dockLeftWidth and (SV.db.Dock.dockLeftWidth ~= leftWidth)) then
		leftWidth = SV.db.Dock.dockLeftWidth;
	end

	local leftHeight = SV.Screen.Estimates.height;
	if(SV.db.Dock.dockLeftHeight and (SV.db.Dock.dockLeftHeight ~= leftHeight)) then
		leftHeight = SV.db.Dock.dockLeftHeight;
	end

	local rightWidth = SV.Screen.Estimates.width;
	if(SV.db.Dock.dockRightWidth and (SV.db.Dock.dockRightWidth ~= rightWidth)) then
		rightWidth = SV.db.Dock.dockRightWidth;
	end

	local rightHeight = SV.Screen.Estimates.height;
	if(SV.db.Dock.dockRightHeight and (SV.db.Dock.dockRightHeight ~= rightHeight)) then
		rightHeight = SV.db.Dock.dockRightHeight;
	end

	local centerWidth = SV.Screen.Estimates.center;
	if(SV.db.Dock.dockCenterWidth and (SV.db.Dock.dockCenterWidth ~= centerWidth)) then
		centerWidth = SV.db.Dock.dockCenterWidth;
	end

	local buttonsize = SV.Screen.Estimates.button;
	if(SV.db.Dock.buttonSize and (SV.db.Dock.buttonSize ~= buttonsize)) then
		buttonsize = SV.db.Dock.buttonSize;
	end

	local spacing = 4;
	if(SV.db.Dock.buttonSpacing and (SV.db.Dock.buttonSpacing ~= spacing)) then
		spacing = SV.db.Dock.buttonSpacing;
	end

	return leftWidth, leftHeight, rightWidth, rightHeight, centerWidth, buttonsize, spacing;
end

function Dock:IsDockletReady(arg)
	local addon = arg;
	if(SV.db.Dock.docklets[arg]) then
		addon = SV.db.Dock.docklets[arg]
	end
	if(addon == nil or addon == "None") then 
		return false 
	end
	if(addon and (not _G[addon])) then 
		return false 
	end 
	return true
end

function Dock:NewDocklet(location, name, readableName, texture, onclick)
	local newParent = self[location]
	if(not newParent) then return end
	local frame = CreateFrame("Frame", name, UIParent, "SVUI_DockletWindowTemplate");
	frame:SetParent(newParent.Window);
	frame:FillInner(newParent.Window, 4, 4);
	frame:SetFrameStrata("BACKGROUND");
	frame.Parent = newParent
	frame.Disable = DockletDisable;
	frame.Enable = DockletEnable;
	frame.DockButton = newParent.Bar:Create(readableName, texture, onclick, name);
	frame.DockButton.FrameLink = frame
	self.Registration.Windows[name] = frame;
	return frame
end

function Dock:MoveDocklet(name, location)
	local newParent = self[location]
	if(not newParent) then return end
	local frame = _G[name];
	if(not frame) then return end
	frame:SetParent(newParent.Window);
	frame:FillInner(newParent.Window, 4, 4);
	newParent.Bar:Add(frame.DockButton)
	self.Registration.Windows[name] = frame;
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
	else
		Dock.BottomRight.backdrop:Hide()
	end
	if SV.db.Dock.leftDockBackdrop then
		Dock.BottomLeft.backdrop:Show()
		Dock.BottomLeft.backdrop:ClearAllPoints()
		Dock.BottomLeft.backdrop:WrapOuter(Dock.BottomLeft.Window, 4, 4)
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

function Dock:Refresh()
	local leftWidth, leftHeight, rightWidth, rightHeight, centerWidth, buttonsize, spacing = self:GetDimensions();
	local centerHeight = buttonsize * 0.5

	self.BottomLeft.Bar:Size(leftWidth, buttonsize)
	self.BottomLeft:Size(leftWidth, leftHeight)
	self.BottomRight.Bar:Size(rightWidth, buttonsize)
	self.BottomRight:Size(rightWidth, rightHeight)

	self.BottomCenter:SetSize(centerWidth, centerHeight)
	self.BottomCenter.Left:SetSize((centerWidth * 0.5), centerHeight)
	self.BottomCenter.Right:SetSize((centerWidth * 0.5), centerHeight)

	self.TopCenter:SetSize(centerWidth, centerHeight)
	self.TopCenter.Left:SetSize((centerWidth * 0.5), centerHeight)
	self.TopCenter.Right:SetSize((centerWidth * 0.5), centerHeight)

	self:BottomBorderVisibility();
	self:TopBorderVisibility();
	self:UpdateDockBackdrops();
end 

function Dock:Initialize()
	SV.cache.Docks = SV.cache.Docks	or {}

	if(not SV.cache.Docks.IsFaded) then 
		SV.cache.Docks.IsFaded = false
	end

	local leftWidth, leftHeight, rightWidth, rightHeight, centerWidth, buttonsize, spacing = self:GetDimensions();
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
		dock.Bar:Size(leftWidth, buttonsize)
		dock.Bar:SetPoint(anchor, SV.Screen, anchor, (2 * mod), (2 * vertMod))

		if(dock.Bar.Button) then
	    	dock.Bar.Button:Size(buttonsize, buttonsize)
	    	dock.Bar.Button:SetFramedButtonTemplate()
	    	dock.Bar.ToolBar:Point(barAnchor, dock.Bar.Button, barReverse, (spacing * mod), 0)
	    	dock.Bar:Initialize(dock.Bar.Button, HideSuperDocks)
	    end

	    dock.Bar.ToolBar:Size(1, buttonsize)
		
		if(dock.Bar.ExtraBar) then
	    	dock.Bar.ExtraBar:Point(barAnchor, dock.Bar.ToolBar, barReverse, (spacing * mod), 0)
		    dock.Bar.ExtraBar:Size(leftWidth, buttonsize)
		    SV.Mentalo:Add(dock.Bar.ExtraBar, location .. " Dock Extended Bar")
	    end

	    dock:SetParent(SV.Screen)
	    dock:ClearAllPoints()
	    dock:SetPoint(anchor, dock.Bar, reverse, 0, (12 * vertMod))
	    dock:Size(leftWidth, leftHeight)
	    dock:SetAttribute("buttonSize", buttonsize)
	    dock:SetAttribute("spacingSize", spacing)

	    SV.Mentalo:Add(dock.Bar, location .. " Dock ToolBar")

		if(isBottom) then 
			dock.backdrop = SetSuperDockStyle(dock.Window, isBottom)
		end
		dock.Window:SetScript("OnShow", Docklet_OnShow)
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

	local centerHeight = buttonsize * 0.5

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