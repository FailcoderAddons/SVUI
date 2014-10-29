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
LOCALS
##########################################################
]]--
local ICONFILE = [[Interface\AddOns\SVUI\assets\artwork\Icons\DOCK-BAG-MICRO]];
local TOOL_DATA = {
	[171] 	= {0,0.25,0,0.25}, 				-- PRO-ALCHEMY
    [794] 	= {0.25,0.5,0,0.25,80451}, 		-- PRO-ARCHAELOGY
    [164] 	= {0.5,0.75,0,0.25}, 			-- PRO-BLACKSMITH
    [185] 	= {0.75,1,0,0.25,818,67097}, 	-- PRO-COOKING
    [333] 	= {0,0.25,0.25,0.5,13262}, 		-- PRO-ENCHANTING
    [202] 	= {0.25,0.5,0.25,0.5}, 			-- PRO-ENGINEERING
    [129] 	= {0.5,0.75,0.25,0.5}, 			-- PRO-FIRSTAID
    [773] 	= {0,0.25,0.5,0.75,51005}, 		-- PRO-INSCRIPTION
    [755] 	= {0.25,0.5,0.5,0.75,31252},	-- PRO-JEWELCRAFTING
    [165] 	= {0.5,0.75,0.5,0.75}, 			-- PRO-LEATHERWORKING
    [186] 	= {0.75,1,0.5,0.75}, 			-- PRO-MINING
    [197] 	= {0.25,0.5,0.75,1}, 			-- PRO-TAILORING
}
local HEARTH_SPELLS = {556,50977,18960,126892}
--[[ 
########################################################## 
DOCKING
##########################################################
]]--
local Dock = SV:NewSubClass("Dock", L["Docks"]);

Dock.Registration = {
	Windows = {},
	Buttons = {},
	Options = {}
};

Dock.Border = {};
Dock.Dropdown = CreateFrame("Frame", "SVUI_DockDropdown", UIParent);

-- MAIN REGIONS
Dock.Left = _G["SVUI_DockLeft"]
Dock.Left.Bar = _G["SVUI_DockBarLeft"]
Dock.Left.Bar.Data = {
	Anchor = "LEFT",
	Location = "BarLeft",
	Modifier = 1,
	Default = "",
	Buttons = {},
};
Dock.Left.Bar.Parent = Dock.Left;

Dock.Right = _G["SVUI_DockRight"]
Dock.Right.Bar = _G["SVUI_DockBarRight"]
Dock.Right.Bar.Data = {
	Anchor = "RIGHT",
	Location = "BarRight",
	Modifier = -1,
	Default = "",
	Buttons = {},
};
Dock.Right.Bar.Parent = Dock.Right;

Dock.Top = _G["SVUI_DockTop"]
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

Dock.Left.Bar.Refresh = RefreshDockButtons
Dock.Right.Bar.Refresh = RefreshDockButtons

local GetDefault = function(self)
	local default = self.Data.Default
	local button = _G[default]
	local window = button:GetAttribute("ownerFrame")
	if window and _G[window] then
		self:Refresh()
		self.Parent.Window.FrameLink = _G[window]
		self.Parent.Window:Show()
		_G[window]:Show()
		button:Activate()
	end
end

Dock.Left.Bar.GetDefault = GetDefault
Dock.Right.Bar.GetDefault = GetDefault

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
	if(Dock.Dropdown:IsShown()) then
		ToggleFrame(Dock.Dropdown)
	end
end

Dock.Left.Bar.Toggle = ToggleDockletWindow
Dock.Right.Bar.Toggle = ToggleDockletWindow
--[[ 
########################################################## 
SET ALERT FUNCTIONS
##########################################################
]]--
local AlertActivate = function(self, child)
	local size = SV.db.Dock.buttonSize or 22;
	self:Height(size)
	child:ClearAllPoints()
	child:SetAllPoints(self)
end 

Dock.Left.Alert.Activate = AlertActivate
Dock.Right.Alert.Activate = AlertActivate

local AlertDeactivate = function(self)
	self:Height(1)
end

Dock.Left.Alert.Deactivate = AlertDeactivate
Dock.Right.Alert.Deactivate = AlertDeactivate
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
_G.HideSuperDocks = function()
	GameTooltip:Hide()
	if SV.cache.Docks.IsFaded then 
		SV.cache.Docks.IsFaded = nil;
		SV:SecureFadeIn(Dock.Left, 0.2, Dock.Left:GetAlpha(), 1)
		SV:SecureFadeIn(Dock.Right, 0.2, Dock.Right:GetAlpha(), 1)
	else 
		SV.cache.Docks.IsFaded = true;
		SV:SecureFadeOut(Dock.Left, 0.2, Dock.Left:GetAlpha(), 0, true)
		SV:SecureFadeOut(Dock.Right, 0.2, Dock.Right:GetAlpha(), 0, true)
	end
end
--[[ 
########################################################## 
PRE VARS/FUNCTIONS
##########################################################
]]--
local DD_OnClick = function(self)
	self.func()
	self:GetParent():Hide()
end

local DD_OnEnter = function(self)
	self.hoverTex:Show()
end

local DD_OnLeave = function(self)
	self.hoverTex:Hide()
end

local function _locate(parent)
	local centerX, centerY = parent:GetCenter()
	local screenWidth = GetScreenWidth()
	local screenHeight = GetScreenHeight()
	local result;
	if not centerX or not centerY then 
		return "CENTER"
	end 
	local heightTop = screenHeight * 0.75;
	local heightBottom = screenHeight * 0.25;
	local widthLeft = screenWidth * 0.25;
	local widthRight = screenWidth * 0.75;
	if(((centerX > widthLeft) and (centerX < widthRight)) and (centerY > heightTop)) then 
		result = "TOP"
	elseif((centerX < widthLeft) and (centerY > heightTop)) then 
		result = "TOPLEFT"
	elseif((centerX > widthRight) and (centerY > heightTop)) then 
		result = "TOPRIGHT"
	elseif(((centerX > widthLeft) and (centerX < widthRight)) and centerY < heightBottom) then 
		result = "BOTTOM"
	elseif((centerX < widthLeft) and (centerY < heightBottom)) then 
		result = "BOTTOMLEFT"
	elseif((centerX > widthRight) and (centerY < heightBottom)) then 
		result = "BOTTOMRIGHT"
	elseif((centerX < widthLeft) and (centerY > heightBottom) and (centerY < heightTop)) then 
		result = "LEFT"
	elseif((centerX > widthRight) and (centerY < heightTop) and (centerY > heightBottom)) then 
		result = "RIGHT"
	else 
		result = "CENTER"
	end
	return result 
end

function Dock:SetFilterMenu(parent, list)
	if not self.Dropdown.buttons then
		self.Dropdown.buttons = {}
		self.Dropdown:SetFrameStrata("DIALOG")
		self.Dropdown:SetClampedToScreen(true)
		tinsert(UISpecialFrames, self.Dropdown:GetName())
		self.Dropdown:Hide()
	end
	local maxPerColumn = 25
	local cols = 1
	for i=1, #self.Dropdown.buttons do
		self.Dropdown.buttons[i]:Hide()
	end

	for i=1, #list do 
		if not self.Dropdown.buttons[i] then
			self.Dropdown.buttons[i] = CreateFrame("Button", nil, Dock.Dropdown)
			self.Dropdown.buttons[i].hoverTex = self.Dropdown.buttons[i]:CreateTexture(nil, 'OVERLAY')
			self.Dropdown.buttons[i].hoverTex:SetAllPoints()
			self.Dropdown.buttons[i].hoverTex:SetTexture([[Interface\QuestFrame\UI-QuestTitleHighlight]])
			self.Dropdown.buttons[i].hoverTex:SetBlendMode("ADD")
			self.Dropdown.buttons[i].hoverTex:Hide()
			self.Dropdown.buttons[i].text = self.Dropdown.buttons[i]:CreateFontString(nil, 'BORDER')
			self.Dropdown.buttons[i].text:SetAllPoints()
			self.Dropdown.buttons[i].text:SetFont(SV.Media.font.roboto,12,"OUTLINE")
			self.Dropdown.buttons[i].text:SetJustifyH("LEFT")
			self.Dropdown.buttons[i]:SetScript("OnEnter", DD_OnEnter)
			self.Dropdown.buttons[i]:SetScript("OnLeave", DD_OnLeave)           
		end
		self.Dropdown.buttons[i]:Show()
		self.Dropdown.buttons[i]:SetHeight(16)
		self.Dropdown.buttons[i]:SetWidth(135)
		self.Dropdown.buttons[i].text:SetText(list[i].text)
		self.Dropdown.buttons[i].func = list[i].func
		self.Dropdown.buttons[i]:SetScript("OnClick", DD_OnClick)
		if i == 1 then
			self.Dropdown.buttons[i]:SetPoint("TOPLEFT", self.Dropdown, "TOPLEFT", 10, -10)
		elseif((i -1) % maxPerColumn == 0) then
			self.Dropdown.buttons[i]:SetPoint("TOPLEFT", self.Dropdown.buttons[i - maxPerColumn], "TOPRIGHT", 10, 0)
			cols = cols + 1
		else
			self.Dropdown.buttons[i]:SetPoint("TOPLEFT", self.Dropdown.buttons[i - 1], "BOTTOMLEFT")
		end
	end

	local maxHeight = (min(maxPerColumn, #list) * 16) + 20
	local maxWidth = (135 * cols) + (10 * cols)
	self.Dropdown:SetSize(maxWidth, maxHeight)    
	self.Dropdown:ClearAllPoints()
	local point = _locate(parent:GetParent()) 
	if point:find("BOTTOM") then
		self.Dropdown:SetPoint("BOTTOMLEFT", parent, "TOPLEFT", 10, 10)
	else
		self.Dropdown:SetPoint("TOPLEFT", parent, "BOTTOMLEFT", 10, -10)
	end
	ToggleFrame(self.Dropdown)
end

function Dock:EnterFade()
	if SV.cache.Docks.IsFaded then 
		self.Left:Show()
		SV:SecureFadeIn(self.Left, 0.2, self.Left:GetAlpha(), 1)
		self.Right:Show()
		SV:SecureFadeIn(self.Right, 0.2, self.Right:GetAlpha(), 1)
	end
end 

function Dock:ExitFade()
	if SV.cache.Docks.IsFaded then 
		SV:SecureFadeOut(self.Left, 0.2, self.Left:GetAlpha(), 0, true)
		SV:SecureFadeOut(self.Right, 0.2, self.Right:GetAlpha(), 0, true)
	end
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
		GameTooltip:AddLine(tipText, 1, 1, 1)
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
	if(button == "RightButton" and self:GetAttribute("hasDropDown") and self.GetMenuList) then
		local list = self:GetMenuList()
		Dock:SetFilterMenu(self, list);
	else
		if self.PostClickFunction then
			self:PostClickFunction()
		else
			self.Parent:Toggle(self)
		end
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
--[[ 
########################################################## 
DOCKLET HELPERS
##########################################################
]]--
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
	local anchor = self.Data.Anchor
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

Dock.Left.Bar.Add = AddToDock
Dock.Right.Bar.Add = AddToDock

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
	local anchor = self.Data.Anchor
	local mod = self.Data.Modifier
	local xOffset = 0
	for i = 1, #self.Data.Buttons do
		local nextButton = self.Data.Buttons[i]
		xOffset = (i - 1) * (height + 6) + 6
		nextButton:ClearAllPoints()
		nextButton:SetPoint(anchor, self.ToolBar, anchor, (xOffset * mod), 0);
	end
	local newWidth = xOffset + height
	self.ToolBar:SetWidth(newWidth)
end

Dock.Left.Bar.Remove = RemoveFromDock
Dock.Right.Bar.Remove = RemoveFromDock

local ActivateDockletButton = function(self, button, clickFunction, tipFunction)
	button.Activate = DockButtonActivate
	button.Deactivate = DockButtonDeactivate
	button.MakeDefault = DockButtonMakeDefault

	if(tipFunction and type(tipFunction) == "function") then
		button.CustomTooltip = tipFunction
	end

	button.Parent = self
	button:SetPanelColor("default")
	button.Icon:SetGradient(unpack(SV.Media.gradient.icon))
	button:SetScript("OnEnter", DockletButton_OnEnter)
	button:SetScript("OnLeave", DockletButton_OnLeave)
	button:SetScript("OnClick", DockletButton_OnClick)

	if(clickFunction and type(clickFunction) == "function") then
		button.PostClickFunction = clickFunction
	end
end

Dock.Left.Bar.Initialize = ActivateDockletButton
Dock.Right.Bar.Initialize = ActivateDockletButton

local CreateBasicToolButton = function(self, name, texture, onclick, frameName)
	local fName = frameName or name;
	local dockIcon = texture or [[Interface\AddOns\SVUI\assets\artwork\Icons\SVUI-ICON]];
	local size = self.ToolBar:GetHeight();
	local button = _G[fName .. "DockletButton"] or CreateFrame("Button", ("%sDockletButton"):format(fName), self.ToolBar, "SVUI_DockletButtonTemplate")

	button:RegisterForClicks("AnyUp")
	button:ClearAllPoints()
	button:Size(size, size)
	button:SetFramedButtonTemplate()
	button.Icon:SetTexture(dockIcon)
	button:SetAttribute("tipText", name)
    button:SetAttribute("ownerFrame", fName)
    button.IsRegistered = false;

    self:Add(button)
	self:Initialize(button, onclick)
	
	return button
end

Dock.Left.Bar.Create = CreateBasicToolButton
Dock.Right.Bar.Create = CreateBasicToolButton
--[[ 
########################################################## 
DOCKS
##########################################################
]]--
local function SetSuperDockStyle(dock)
	if dock.backdrop then return end 
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
	backdrop.left:SetGradientAlpha("VERTICAL", 0, 0, 0, 1, 0, 0, 0, 0)
	backdrop.right = backdrop:CreateTexture(nil, "OVERLAY")
	backdrop.right:SetTexture(1, 1, 1, 1)
	backdrop.right:Point("TOPRIGHT", -1, -1)
	backdrop.right:Point("BOTTOMRIGHT", -1, -1)
	backdrop.right:Width(4)
	backdrop.right:SetGradientAlpha("VERTICAL", 0, 0, 0, 1, 0, 0, 0, 0)
	backdrop.bottom = backdrop:CreateTexture(nil, "OVERLAY")
	backdrop.bottom:SetTexture(0, 0, 0, 1)
	backdrop.bottom:Point("BOTTOMLEFT", 1, -1)
	backdrop.bottom:Point("BOTTOMRIGHT", -1, -1)
	backdrop.bottom:Height(4)
	backdrop.top = backdrop:CreateTexture(nil, "OVERLAY")
	backdrop.top:SetTexture(0,0,0,0)
	backdrop.top:Point("TOPLEFT", 1, -1)
	backdrop.top:Point("TOPRIGHT", -1, 1)
	backdrop.top:SetAlpha(0)
	backdrop.top:Height(1)
	return backdrop 
end

function Dock:CreateDockPanels()
	local leftWidth = SV.db.Dock.dockLeftWidth or 350;
	local leftHeight = SV.db.Dock.dockLeftHeight or 180;
	local rightWidth = SV.db.Dock.dockRightWidth or 350;
	local rightHeight = SV.db.Dock.dockRightHeight or 180;
	local buttonsize = SV.db.Dock.buttonSize or 22;
	local spacing = SV.db.Dock.buttonSpacing or 4;
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
	self.Border.Top:SetBackdropColor(unpack(SV.Media.color.special))
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

	-- [[ BOTTOM LEFT DOCK ]] --

	self.Left.Bar:SetParent(SV.Screen)
	self.Left.Bar:Size(leftWidth, buttonsize)
	self.Left.Bar:SetPoint("BOTTOMLEFT", SV.Screen, "BOTTOMLEFT", 2, 2)
    self.Left.Bar.Button:Size(buttonsize, buttonsize)
    self.Left.Bar.Button:SetFramedButtonTemplate()
    self.Left.Bar.ToolBar:Point("LEFT", self.Left.Bar.Button, "RIGHT", spacing, 0)
    self.Left.Bar.ToolBar:Size(1, buttonsize)
    self.Left.Bar.ExtraBar:Point("LEFT", self.Left.Bar.ToolBar, "RIGHT", spacing, 0)
    self.Left.Bar.ExtraBar:Size(leftWidth, buttonsize)

    self.Left:SetParent(SV.Screen)
    self.Left:SetPoint("BOTTOMLEFT", self.Left.Bar, "TOPLEFT", 0, 12)
    self.Left:Size(leftWidth, leftHeight)
    self.Left:SetAttribute("buttonSize", buttonsize)
    self.Left:SetAttribute("spacingSize", spacing)

	self.Left.Alert.Activate = AlertActivate
	self.Left.Alert.Deactivate = AlertDeactivate
	self.Left.backdrop = SetSuperDockStyle(self.Left.Window)

	self.Left.Bar:Initialize(self.Left.Bar.Button, HideSuperDocks)

	SV.Mentalo:Add(self.Left.Bar, L["Left Dock ToolBar"])
	SV.Mentalo:Add(self.Left, L["Left Dock Window"])

	-- [[ BOTTOM RIGHT DOCK ]] --

	self.Right.Bar:SetParent(SV.Screen)
	self.Right.Bar:Size(rightWidth, buttonsize)
	self.Right.Bar:Point("BOTTOMRIGHT", SV.Screen, "BOTTOMRIGHT", -2, 2)
	self.Right.Bar.Button:Size(buttonsize, buttonsize)
	self.Right.Bar.Button:SetFramedButtonTemplate()
	-- self.Right.Bar.Button.Icon:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Icons\DOCK-HENCHMAN]])
	-- self.Right.Bar.Button:SetAttribute("tipText", "Call Henchman!")
	-- self.Right.Bar.Button:SetAttribute("hasDropDown", true)
	-- self.Right.Bar.Button:RegisterForClicks("AnyUp")
	-- SV.ToggleHenchman
	self.Right.Bar.ToolBar:Point("RIGHT", self.Right.Bar.Button, "LEFT", -spacing, 0)
	self.Right.Bar.ToolBar:Size(1, buttonsize)
	self.Right.Bar.ExtraBar:Point("RIGHT", self.Right.Bar.ToolBar, "LEFT", -spacing, 0)
    self.Right.Bar.ExtraBar:Size(rightWidth, buttonsize)

	self.Right:SetParent(SV.Screen)
	self.Right:Point("BOTTOMRIGHT", self.Right.Bar, "TOPRIGHT", 0, 12)
	self.Right:Size(rightWidth, rightHeight)
	self.Right:SetAttribute("buttonSize", buttonsize)
    self.Right:SetAttribute("spacingSize", spacing)
	self.Right.Window:Size(rightWidth, rightHeight - (buttonsize + 4))
	self.Right.Alert.Activate = AlertActivate
	self.Right.Alert.Deactivate = AlertDeactivate
	self.Right.backdrop = SetSuperDockStyle(self.Right.Window)

	self.Right.Bar:Initialize(self.Right.Bar.Button, HideSuperDocks)

	SV.Mentalo:Add(self.Right.Bar, L["Right Dock ToolBar"])
	SV.Mentalo:Add(self.Right, L["Right Dock Window"])

	if SV.cache.Docks.IsFaded then Dock.Left:Hide() Dock.Right:Hide() end

	-- [[ TOP LEFT DOCK ]] --

	self.Top:SetParent(SV.Screen)
	self.Top:Point("TOPLEFT", SV.Screen, "TOPLEFT", 1, -2)
	self.Top:Size(leftWidth, leftHeight)
	self.Top:SetAttribute("buttonSize", buttonsize)
    self.Top:SetAttribute("spacingSize", spacing)
	self.Top.ToolBar:Size(1, buttonsize)

	SV.Mentalo:Add(self.Top, L["Top Dock"])

	--RIGHT CLICK MENU

	self.Dropdown:SetParent(SV.Screen)
	self.Dropdown:SetPanelTemplate("Default")
	self.Dropdown.buttons = {}
	self.Dropdown:SetFrameStrata("DIALOG")
	self.Dropdown:SetClampedToScreen(true)
	self.Dropdown:SetSize(135, 94)
	self.Dropdown:Hide()

	SV:AddToDisplayAudit(self.Right.Window)
	SV:AddToDisplayAudit(self.Dropdown)

	self.Left.Window:SetScript("OnShow", Docklet_OnShow)
	self.Right.Window:SetScript("OnShow", Docklet_OnShow)

	if not InCombatLockdown()then 
		self.Left.Bar:Refresh()
		self.Right.Bar:Refresh()
	end
end

local function BorderColorUpdates()
	Dock.Border.Top:SetBackdropColor(unpack(SV.Media.color.special))
	Dock.Border.Top:SetBackdropBorderColor(0,0,0,1)
	Dock.Border.Bottom:SetBackdropColor(unpack(SV.Media.color.special))
	Dock.Border.Bottom:SetBackdropBorderColor(0,0,0,1)
end

SV:NewCallback(BorderColorUpdates)

do
	local LastAddedMacro;
	local MacroCount = 0;

	local function GetMacroCooldown(itemID)
		local start,duration = GetItemCooldown(itemID)
		local expires = duration - (GetTime() - start)
		if expires > 0.05 then 
			local timeLeft = 0;
			local calc = 0;
			if expires < 4 then
				return format("|cffff0000%.1f|r", expires)
			elseif expires < 60 then 
				return format("|cffffff00%d|r", floor(expires)) 
			elseif expires < 3600 then
				timeLeft = ceil(expires / 60);
				calc = floor((expires / 60) + .5);
				return format("|cffff9900%dm|r", timeLeft)
			elseif expires < 86400 then
				timeLeft = ceil(expires / 3600);
				calc = floor((expires / 3600) + .5);
				return format("|cff66ffff%dh|r", timeLeft)
			else
				timeLeft = ceil(expires / 86400);
				calc = floor((expires / 86400) + .5);
				return format("|cff6666ff%dd|r", timeLeft)
			end
		else 
			return "|cff6666ffReady|r"
		end 
	end

	local SetMacroTooltip = function(self)
		local text1 = self:GetAttribute("tipText")
		local text2 = self:GetAttribute("tipExtraText")
		if(not text2) then
			GameTooltip:AddLine(text1, 1, 1, 1)
		else
			GameTooltip:AddDoubleLine("[Left-Click]", text1, 0, 1, 0, 1, 1, 1)
			GameTooltip:AddDoubleLine("[Right-Click]", "Use " .. text2, 0, 1, 0, 1, 1, 1)
			if InCombatLockdown() then return end
			if(self.ItemToUse) then
				GameTooltip:AddLine(" ", 1, 1, 1)
				local remaining = GetMacroCooldown(self.ItemToUse)
				GameTooltip:AddDoubleLine(text2, remaining, 1, 0.5, 0, 0, 1, 1)
			end
		end
	end

	local SetHearthTooltip = function(self)
		GameTooltip:AddLine(L["Hearthstone"], 1, 1, 1)
		if InCombatLockdown() then return end
		local remaining = GetMacroCooldown(6948)
		GameTooltip:AddDoubleLine(L["Time Remaining"], remaining, 1, 1, 1, 0, 1, 1)
		local extraText = self:GetAttribute("tipExtraText")
		if(extraText) then
			GameTooltip:AddLine(" ", 1, 1, 1)
			GameTooltip:AddDoubleLine(extraText, "[Right Click]", 1, 1, 1, 0, 1, 0)
		end
	end

	local function CreateMacroToolButton(proName, proID, itemID, size) 
		local data = TOOL_DATA[proID]
		if(not data) then return end
		local button = CreateFrame("Button", ("%s_MacroBarButton"):format(itemID), Dock.Right.Bar.ToolBar, "SecureActionButtonTemplate,SVUI_DockletButtonTemplate")
		button:Size(size, size)
		Dock.Right.Bar:Add(button)
		button:SetFramedButtonTemplate()
		button.Icon:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Icons\PROFESSIONS]])
		button.Icon:SetTexCoord(data[1], data[2], data[3], data[4])
		button.Icon:SetGradient("VERTICAL", 0.5, 0.53, 0.55, 0.8, 0.8, 1)
		button:SetAttribute("tipText", "Open " .. proName)

		if proID == 186 then proName = "Smelting" end

		if(data[5]) then
			local rightClick
			button:RegisterForClicks("AnyDown")
			if(data[6] and GetItemCount(data[6], true) > 0) then
				rightClick = GetItemInfo(data[6])
				button.ItemToUse = data[6]
			else
				rightClick = GetSpellInfo(data[5])
			end
			button:SetAttribute("tipExtraText", rightClick)
			button:SetAttribute("type", "macro")
			button:SetAttribute("macrotext", "/cast [button:2] " .. rightClick .. ";" .. proName)
		else
			button:SetAttribute("type", "macro")
			button:SetAttribute("macrotext", "/cast " .. proName)
		end

		button.CustomTooltip = SetMacroTooltip
		button:SetPanelColor("default")
		button.Icon:SetGradient(unpack(SV.Media.gradient.icon))
		button:SetScript("OnEnter", DockletButton_OnEnter)
		button:SetScript("OnLeave", DockletButton_OnLeave)
	end 

	function Dock:LoadToolBarProfessions()
		if(Dock.ToolBarLoaded) then return end
		if(InCombatLockdown()) then Dock:RegisterEvent("PLAYER_REGEN_ENABLED"); return end
		local size = Dock.Right.Bar.ToolBar:GetHeight()
		local hearth = CreateFrame("Button", "SVUI_HearthButton", Dock.Right.Bar.ToolBar, "SecureActionButtonTemplate, SVUI_DockletButtonTemplate")
		hearth:Size(size, size)
		Dock.Right.Bar:Add(hearth)
		hearth:SetFramedButtonTemplate()
		hearth.Icon:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Icons\\DOCK-HEARTH")
		hearth.Icon:SetTexCoord(0,0.5,0,1)
		hearth:RegisterForClicks("AnyUp")
		hearth:SetAttribute("type", "item")
		hearth:SetAttribute("item", GetItemInfo(6948))

		hearth.CustomTooltip = SetHearthTooltip
		hearth:SetPanelColor("default")
		hearth.Icon:SetGradient(unpack(SV.Media.gradient.icon))
		hearth:SetScript("OnEnter", DockletButton_OnEnter)
		hearth:SetScript("OnLeave", DockletButton_OnLeave)

		for i = 1, #HEARTH_SPELLS do
			if(IsSpellKnown(HEARTH_SPELLS[i])) then
				local rightClickSpell = GetSpellInfo(HEARTH_SPELLS[i])
				hearth:SetAttribute("type2", "spell")
				hearth:SetAttribute("spell", rightClickSpell)
				hearth:SetAttribute("tipExtraText", rightClickSpell)
			end
		end

		local proName, proID
		local prof1, prof2, archaeology, _, cooking, firstAid = GetProfessions()
		if(firstAid ~= nil) then 
			proName, _, _, _, _, _, proID = GetProfessionInfo(firstAid)
			CreateMacroToolButton(proName, proID, firstAid, size)
		end 
		if(archaeology ~= nil) then 
			proName, _, _, _, _, _, proID = GetProfessionInfo(archaeology)
			CreateMacroToolButton(proName, proID, archaeology, size)
		end 
		if(cooking ~= nil) then 
			proName, _, _, _, _, _, proID = GetProfessionInfo(cooking)
			CreateMacroToolButton(proName, proID, cooking, size)
		end 
		if(prof2 ~= nil) then 
			proName, _, _, _, _, _, proID = GetProfessionInfo(prof2)
			if(proID ~= 182 and proID ~= 393) then
				CreateMacroToolButton(proName, proID, prof2, size)
			end
		end 
		if(prof1 ~= nil) then 
			proName, _, _, _, _, _, proID = GetProfessionInfo(prof1)
			if(proID ~= 182 and proID ~= 393) then
				CreateMacroToolButton(proName, proID, prof1, size)
			end
		end
		Dock.ToolBarLoaded = true
	end
end
--[[ 
########################################################## 
EXTERNALLY ACCESSIBLE METHODS
##########################################################
]]--
SV.CurrentlyDocked = {};

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
		Dock.Right.backdrop:Show()
		Dock.Right.backdrop:ClearAllPoints()
		Dock.Right.backdrop:WrapOuter(Dock.Right.Window, 4, 4)
	else
		Dock.Right.backdrop:Hide()
	end
	if SV.db.Dock.leftDockBackdrop then
		Dock.Left.backdrop:Show()
		Dock.Left.backdrop:ClearAllPoints()
		Dock.Left.backdrop:WrapOuter(Dock.Left.Window, 4, 4)
	else
		Dock.Left.backdrop:Hide()
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

function Dock:PLAYER_REGEN_ENABLED()
	self:UnregisterEvent('PLAYER_REGEN_ENABLED')
	self:LoadToolBarProfessions()
end

function Dock:Refresh()
	local leftWidth = SV.db.Dock.dockLeftWidth or 350;
	local leftHeight = SV.db.Dock.dockLeftHeight or 180;
	local rightWidth = SV.db.Dock.dockRightWidth or 350;
	local rightHeight = SV.db.Dock.dockRightHeight or 180;
	local buttonsize = SV.db.Dock.buttonSize or 22;
	local spacing = SV.db.Dock.buttonSpacing or 4;

	self.Left.Bar:Size(leftWidth, buttonsize)
	self.Left:Size(leftWidth, leftHeight)
	self.Left.Window:Size(leftWidth, leftHeight - (buttonsize + 4))
	self.Right.Bar:Size(rightWidth, buttonsize)
	self.Right:Size(rightWidth, rightHeight)
	self.Right.Window:Size(rightWidth, rightHeight - (buttonsize + 4))

	self:BottomBorderVisibility();
	self:TopBorderVisibility();
	self:UpdateDockBackdrops();
end 

function Dock:Initialize()
	SV.cache.Docks = SV.cache.Docks	or {}

	if(not SV.cache.Docks.IsFaded) then 
		SV.cache.Docks.IsFaded = false
	end

	if(not SV.cache.Docks.defaults) then 
		SV.cache.Docks.defaults = {}
	end

	if(not SV.cache.Docks.defaults.left) then 
		SV.cache.Docks.defaults.left = "None"
	end

	Dock.Left.Bar.Data.Default = SV.cache.Docks.defaults.left

	if(not SV.cache.Docks.defaults.right) then 
		SV.cache.Docks.defaults.right = "None"
	end

	Dock.Right.Bar.Data.Default = SV.cache.Docks.defaults.right

	self:CreateDockPanels() 
	self:UpdateDockBackdrops()
	SV.Timers:ExecuteTimer(self.LoadToolBarProfessions, 5)
end