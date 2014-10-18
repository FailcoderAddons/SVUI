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
GET ADDON DATA
##########################################################
]]--
local SV = select(2, ...)
local L = SV.L
local MOD = SV:NewPackage("SVDock", L["Docks"]);
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local DOCKLET_CACHE, TOOL_CACHE, SAFETY_CACHE = {}, {}, {};
local PREV_TOOL, DEFAULT_DOCKLET;
local AddOnButton = CreateFrame("Button", "SVUI_AddonDocklet", UIParent);
local SuperDockletMain = CreateFrame('Frame', 'SuperDockletMain', UIParent);
local SuperDockletExtra = CreateFrame('Frame', 'SuperDockletExtra', UIParent);
local DockletMenu = CreateFrame("Frame", "SVUI_DockletMenu", UIParent);
SuperDockletMain.FrameName = "None";
SuperDockletExtra.FrameName = "None";
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

local rez = GetCVar("gxResolution");
local gxWidth = tonumber(rez:match("(%d+)x%d+"));
local bw = gxWidth * 0.5
local defaultStatBarWidth = min(bw, 800)
--[[ 
########################################################## 
PRE VARS/FUNCTIONS
##########################################################
]]--
local DD_OnClick = function(self)
	-- DO STUFF
	self:GetParent():Hide()
end

local DD_OnEnter = function(self)
	self.hoverTex:Show()
end

local DD_OnLeave = function(self)
	self.hoverTex:Hide()
end

local function SetFilterMenu(self)    
	DockletMenu:ClearAllPoints()
	DockletMenu:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -8)
	ToggleFrame(DockletMenu)
end

local function CycleDocklets()
	for i=1, #DOCKLET_CACHE do
		local f = DOCKLET_CACHE[i]
		if(not InCombatLockdown() or (InCombatLockdown() and (f.IsProtected and not f:IsProtected()))) then
			local b = _G[f.ToggleName]
			b:Deactivate()
			if f.Hide then
				f:Hide()
			end
		end
	end
end

local function GetDefaultWindow()
	local window = DEFAULT_DOCKLET
	if window and _G[window] then
		SuperDockWindowRight.FrameName = window
		SuperDockWindowRight:Show()
	end
end

local AlertActivate = function(self, child)
	local size = SV.db.SVDock.buttonSize or 22;
	self:Height(size)
	child:ClearAllPoints()
	child:SetAllPoints(self)
end 

local AlertDeactivate = function(self)
	self:Height(1)
end

local leftalert = CreateFrame("Frame", "SuperDockAlertLeft", UIParent)
leftalert.Activate = AlertActivate
leftalert.Deactivate = AlertDeactivate

local rightalert = CreateFrame("Frame", "SuperDockAlertRight", UIParent)
rightalert.Activate = AlertActivate
rightalert.Deactivate = AlertDeactivate

local rightDockSizeHook = function(self,width,height)
	SuperDockWindowRight:Width(width)
	SuperDockWindowRight:Height(height)
	SuperDockWindowRight:SetPoint("BOTTOMLEFT", SuperDockAlertRight, "TOPLEFT", 0, 0)
end

local ToggleDocks = function(self)
	GameTooltip:Hide()
	if SV.cache.Docks.SuperDockFaded then 
		SV.cache.Docks.SuperDockFaded = nil;
		SV:SecureFadeIn(LeftSuperDock, 0.2, LeftSuperDock:GetAlpha(), 1)
		SV:SecureFadeIn(RightSuperDock, 0.2, RightSuperDock:GetAlpha(), 1)
	else 
		SV.cache.Docks.SuperDockFaded = true;
		SV:SecureFadeOut(LeftSuperDock, 0.2, LeftSuperDock:GetAlpha(), 0, true)
		SV:SecureFadeOut(RightSuperDock, 0.2, RightSuperDock:GetAlpha(), 0, true)
	end
end

local Docklet_OnShow = function(self)
	if(_G[SuperDockWindowRight.FrameName]) then
		if(InCombatLockdown() and (_G[SuperDockWindowRight.FrameName].IsProtected and _G[SuperDockWindowRight.FrameName]:IsProtected())) then return end 
		_G[SuperDockWindowRight.FrameName]:Show()
	end 
	if _G[SuperDockWindowRight.SecondName] then
		if(InCombatLockdown() and (_G[SuperDockWindowRight.SecondName].IsProtected and _G[SuperDockWindowRight.SecondName]:IsProtected())) then return end
		_G[SuperDockWindowRight.SecondName]:Show()
	end 
end 

local DockletButton_SaveColors = function(self, pG, iG, locked)
	if(locked and (locked ~= nil) and self._colorLocked) then return end
	self._panelGradient = pG
	self._iconGradient = iG
	self._colorLocked = locked
	self:SetPanelColor(pG)
	self.icon:SetGradient(unpack(SV.Media.gradient[iG]))
end

local DockButtonActivate = function(self)
	self.IsOpen = true;
	self:SaveColors("green", "green")
end 

local DockButtonDeactivate = function(self)
	self.IsOpen = false;
	self:SaveColors("default", "icon")
end

local DockletButton_OnEnter = function(self, ...)
	if SV.cache.Docks.SuperDockFaded then 
		LeftSuperDock:Show()
		SV:SecureFadeIn(LeftSuperDock, 0.2, LeftSuperDock:GetAlpha(), 1)
		RightSuperDock:Show()
		SV:SecureFadeIn(RightSuperDock, 0.2, RightSuperDock:GetAlpha(), 1)
	end

	self:SetPanelColor("highlight")
	self.icon:SetGradient(unpack(SV.Media.gradient.bizzaro))

	GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 4)
	GameTooltip:ClearLines()
	if(self.CustomTooltip) then
		self:CustomTooltip()
	else
		GameTooltip:AddLine(self.TText, 1, 1, 1)
	end
	GameTooltip:Show()
end 

local DockletButton_OnLeave = function(self, ...)
	if SV.cache.Docks.SuperDockFaded then 
		SV:SecureFadeOut(LeftSuperDock, 0.2, LeftSuperDock:GetAlpha(), 0, true)
		SV:SecureFadeOut(RightSuperDock, 0.2, RightSuperDock:GetAlpha(), 0, true)
	end

	self:SetPanelColor(self._panelGradient)
	self.icon:SetGradient(unpack(SV.Media.gradient[self._iconGradient]))

	GameTooltip:Hide()
end

local DockletButton_OnClick = function(self, button)
	if InCombatLockdown() then return end
	if button == "RightButton" then
		SetFilterMenu(self);
	else
		local linkedFrame = self.FrameName
		if linkedFrame and _G[linkedFrame] then
			SuperDockWindowRight.FrameName = linkedFrame
			if not _G[linkedFrame]:IsShown() then
				CycleDocklets()
			end
			if not SuperDockWindowRight:IsShown()then
				SuperDockWindowRight:Show()
			end
			_G[linkedFrame]:Show()
			self:Activate()
		else
			self:Deactivate()
			GetDefaultWindow()
		end
	end
end

local DockletFrame_OnShow = function(self)
	local frameName = self.FrameName;
	if (frameName and _G[frameName]) then 
		_G[frameName]:Show()
	end
end 

local AddonDockletToggle = function(self)
	if SuperDockletMain.FrameName and _G[SuperDockletMain.FrameName] then
		if not _G[SuperDockletMain.FrameName]:IsShown() then
			CycleDocklets()
			if not InCombatLockdown() and not SuperDockletMain:IsShown()then
				SuperDockletMain:Show()
			end
			_G[SuperDockletMain.FrameName]:Show()
			self:Activate()
		elseif not SuperDockletMain:IsShown()then
			if not InCombatLockdown() then SuperDockletMain:Show() end
			_G[SuperDockletMain.FrameName]:Show()
			self:Activate()
		end 
	else
		SuperDockletMain.FrameName = "None"
		if InCombatLockdown()then return end 
		if SuperDockletMain:IsShown()then 
			SuperDockletMain:Hide()
		else 
			SuperDockletMain:Show()
		end
		self:Deactivate()
	end 
	if SV.db.SVDock.docklets.enableExtra and SuperDockletExtra.FrameName and _G[SuperDockletExtra.FrameName] then
		if not _G[SuperDockletExtra.FrameName]:IsShown() then
			if not InCombatLockdown() and not SuperDockletExtra:IsShown()then
				SuperDockletExtra:Show()
				SuperDockletMain:Show()
			end
			_G[SuperDockletExtra.FrameName]:Show()
			self:Activate()
		elseif not SuperDockletExtra:IsShown() then
			if not InCombatLockdown() then 
				SuperDockletExtra:Show()
				SuperDockletMain:Show()
			end
			_G[SuperDockletExtra.FrameName]:Show()
			self:Activate()
		else
			if not InCombatLockdown() then 
				SuperDockletExtra:Hide() 
				SuperDockletMain:Hide()
			end
			self:Deactivate()
		end
	else
		SuperDockletExtra.FrameName = "None"
	end
end

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
	backdrop.left:Point("BOTTOMLEFT", -1, 1)
	backdrop.left:Width(4)
	backdrop.left:SetGradientAlpha("VERTICAL", 0, 0, 0, 1, 0, 0, 0, 0)
	backdrop.right = backdrop:CreateTexture(nil, "OVERLAY")
	backdrop.right:SetTexture(1, 1, 1, 1)
	backdrop.right:Point("TOPRIGHT", -1, -1)
	backdrop.right:Point("BOTTOMRIGHT", -1, 1)
	backdrop.right:Width(4)
	backdrop.right:SetGradientAlpha("VERTICAL", 0, 0, 0, 1, 0, 0, 0, 0)
	backdrop.bottom = backdrop:CreateTexture(nil, "OVERLAY")
	backdrop.bottom:SetTexture(0, 0, 0, 1)
	backdrop.bottom:Point("BOTTOMLEFT", 1, 1)
	backdrop.bottom:Point("BOTTOMRIGHT", -1, 1)
	backdrop.bottom:Height(4)
	backdrop.top = backdrop:CreateTexture(nil, "OVERLAY")
	backdrop.top:SetTexture(0,0,0,0)
	backdrop.top:Point("TOPLEFT", 1, -1)
	backdrop.top:Point("TOPRIGHT", -1, 1)
	backdrop.top:SetAlpha(0)
	backdrop.top:Height(1)
	return backdrop 
end

SV.CycleDocklets = CycleDocklets
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
_G.HideSuperDocks = function()
	ToggleDocks(LeftDockToggleButton)
end
--[[ 
########################################################## 
DOCKLET HELPERS
##########################################################
]]--
function MOD:ActivateDockletButton(button, clickFunction, tipFunction)
	button._panelGradient = "default"
	button._iconGradient = "icon"
	button.SaveColors = DockletButton_SaveColors
	button:SaveColors("default", "icon")

	button.Activate = DockButtonActivate
	button.Deactivate = DockButtonDeactivate

	if(tipFunction and type(tipFunction) == "function") then
		button.CustomTooltip = tipFunction
	end

	button:SetScript("OnEnter", DockletButton_OnEnter)
	button:SetScript("OnLeave", DockletButton_OnLeave)

	if(clickFunction and type(clickFunction) == "function") then
		button:SetScript("OnClick", clickFunction)
	end
end

function MOD:CreateBasicToolButton(name,texture,onclick,frameName,isdefault)
	local fName = frameName or name;
	local dockIcon = texture or [[Interface\AddOns\SVUI\assets\artwork\Icons\DOCK-ADDON]];
	local clickFunction = (type(onclick)=="function") and onclick or DockletButton_OnClick;
	local size = SuperDockToolBarRight.currentSize;
	local button = _G[fName .. "_ToolBarButton"] or CreateFrame("Button", ("%s_ToolBarButton"):format(fName), SuperDockToolBarRight)
	SV.AddTool(button)
	button:Size(size,size)
	button:SetFramedButtonTemplate()
	button.icon = button:CreateTexture(nil,"OVERLAY")
	button.icon:FillInner(button,2,2)
	button.icon:SetTexture(dockIcon)
	button.TText = "Open " .. name;
	button.FrameName = fName
	MOD:ActivateDockletButton(button, clickFunction)
	_G[fName].ToggleName = fName.."_ToolBarButton";
	if(isdefault and isdefault == true) then
		DEFAULT_DOCKLET = fName
		button:SaveColors("green", "green")
	end

	return button
end
--[[ 
########################################################## 
DOCKS
##########################################################
]]--
function MOD:CreateSuperBorders()
	local texture = [[Interface\AddOns\SVUI\assets\artwork\Template\BUTTON]];

	local TopPanel = CreateFrame("Frame", "SVUITopPanel", SV.UIParent)
	TopPanel:Point("TOPLEFT", SV.UIParent, "TOPLEFT", -1, 1)
	TopPanel:Point("TOPRIGHT", SV.UIParent, "TOPRIGHT", 1, 1)
	TopPanel:Height(14)
	TopPanel:SetBackdrop({
		bgFile = texture, 
		edgeFile = [[Interface\BUTTONS\WHITE8X8]], 
		tile = false, 
		tileSize = 0, 
		edgeSize = 1, 
		insets = {left = 0, right = 0, top = 0, bottom = 0}
	})
	TopPanel:SetBackdropColor(unpack(SV.Media.color.special))
	TopPanel:SetBackdropBorderColor(0,0,0,1)
	TopPanel:SetFrameLevel(0)
	TopPanel:SetFrameStrata('BACKGROUND')
	self.TopPanel = TopPanel;
	self.TopPanel:SetScript("OnShow", function(this)
		this:SetFrameLevel(0)
		this:SetFrameStrata('BACKGROUND')
	end)
	self:TopPanelVisibility()

	local BottomPanel = CreateFrame("Frame", "SVUIBottomPanel", SV.UIParent)
	BottomPanel:Point("BOTTOMLEFT", SV.UIParent, "BOTTOMLEFT", -1, -1)
	BottomPanel:Point("BOTTOMRIGHT", SV.UIParent, "BOTTOMRIGHT", 1, -1)
	BottomPanel:Height(14)
	BottomPanel:SetBackdrop({
		bgFile = texture, 
		edgeFile = [[Interface\BUTTONS\WHITE8X8]], 
		tile = false, 
		tileSize = 0, 
		edgeSize = 1, 
		insets = {left = 0, right = 0, top = 0, bottom = 0}
	})
	BottomPanel:SetBackdropColor(unpack(SV.Media.color.special))
	BottomPanel:SetBackdropBorderColor(0,0,0,1)
	BottomPanel:SetFrameLevel(0)
	BottomPanel:SetFrameStrata('BACKGROUND')
	self.BottomPanel = BottomPanel;
	self.BottomPanel:SetScript("OnShow", function(this)
		this:SetFrameLevel(0)
		this:SetFrameStrata('BACKGROUND')
	end)
	MOD:BottomPanelVisibility()
end

local function BorderColorUpdates()
	SVUITopPanel:SetBackdropColor(unpack(SV.Media.color.special))
	SVUITopPanel:SetBackdropBorderColor(0,0,0,1)
	SVUIBottomPanel:SetBackdropColor(unpack(SV.Media.color.special))
	SVUIBottomPanel:SetBackdropBorderColor(0,0,0,1)
end

SV:NewCallback(BorderColorUpdates)

function MOD:CreateDockPanels()
	local leftWidth = SV.db.SVDock.dockLeftWidth or 350;
	local leftHeight = SV.db.SVDock.dockLeftHeight or 180;
	local rightWidth = SV.db.SVDock.dockRightWidth or 350;
	local rightHeight = SV.db.SVDock.dockRightHeight or 180;
	local buttonsize = SV.db.SVDock.buttonSize or 22;
	local spacing = SV.db.SVDock.buttonSpacing or 4;
	local statBarWidth = SV.db.SVDock.dockStatWidth or defaultStatBarWidth
	local STATS = SV.SVStats;

	-- [[ CORNER BUTTON ]] --

	local leftbutton = CreateFrame("Button", "LeftSuperDockToggleButton", SV.UIParent)
	leftbutton:Point("BOTTOMLEFT", SV.UIParent, "BOTTOMLEFT", 1, 2)
	leftbutton:Size(buttonsize, buttonsize)
	leftbutton:SetFramedButtonTemplate()
	leftbutton.icon = leftbutton:CreateTexture(nil, "OVERLAY", nil, 0)
	leftbutton.icon:FillInner(leftbutton,2,2)
	leftbutton.icon:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Icons\\SVUI-EMBLEM")
	leftbutton.TText = L["Toggle Docks"]
	leftbutton:RegisterForClicks("AnyUp")
	self:ActivateDockletButton(leftbutton, ToggleDocks)
	-- [[ TOOLBARS AND OTHER NONSENSE ]] --

	local toolbarLeft = CreateFrame("Frame", "SuperDockToolBarLeft", SV.UIParent)
	toolbarLeft:Point("LEFT", leftbutton, "RIGHT", spacing, 0)
	toolbarLeft:Width(1)
	toolbarLeft:Height(buttonsize)
	toolbarLeft.currentSize = buttonsize;

	local leftstation = CreateFrame("Frame", "SuperDockChatTabBar", SV.UIParent)
	leftstation:SetFrameStrata("BACKGROUND")
	leftstation:Size(leftWidth - buttonsize, buttonsize)
	leftstation:Point("LEFT", toolbarLeft, "RIGHT", spacing, 0)
	leftstation:SetFrameLevel(leftstation:GetFrameLevel() + 2)
	leftstation.currentSize = buttonsize;

	local leftdock = CreateFrame("Frame", "LeftSuperDock", SV.UIParent)
	leftdock:SetFrameStrata("BACKGROUND")
	leftdock:Point("BOTTOMLEFT", SV.UIParent, "BOTTOMLEFT", 1, buttonsize + 10)
	leftdock:Size(leftWidth, leftHeight)
	SV.Mentalo:Add(leftdock, L["Left Dock"])

	leftalert:SetParent(leftdock)
	leftalert:SetFrameStrata("BACKGROUND")
	leftalert:Size(leftWidth, 1)
	leftalert:Point("BOTTOMRIGHT", leftdock, "BOTTOMRIGHT",0, 0)
	leftalert:SetFrameLevel(leftalert:GetFrameLevel() + 2)
	leftalert.Activate = AlertActivate
	leftalert.Deactivate = AlertDeactivate

	local leftwindow = CreateFrame("Frame", "SuperDockWindowLeft", leftdock)
	leftwindow:SetFrameStrata("BACKGROUND")
	leftwindow:Point("BOTTOMRIGHT", leftalert, "TOPRIGHT", 0, 0)
	leftwindow:Size(leftWidth, leftHeight)
	leftdock.backdrop = SetSuperDockStyle(leftwindow)

	-- [[ CORNER BUTTON ]] --

	local rightbutton = CreateFrame("Button", "RightSuperDockToggleButton", SV.UIParent)
	rightbutton:Point("BOTTOMRIGHT", SV.UIParent, "BOTTOMRIGHT", -1, 2)
	rightbutton:Size(buttonsize, buttonsize)
	rightbutton:SetFramedButtonTemplate()
	rightbutton.icon = rightbutton:CreateTexture(nil, "OVERLAY")
	rightbutton.icon:FillInner(rightbutton,2,2)
	rightbutton.icon:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Icons\DOCK-HENCHMAN]])
	rightbutton.TText = "Call Henchman!"
	rightbutton:RegisterForClicks("AnyUp")
	self:ActivateDockletButton(rightbutton, SV.ToggleHenchman)
	-- [[ TOOLBARS AND OTHER NONSENSE ]] --

	local toolbarRight = CreateFrame("Frame", "SuperDockToolBarRight", SV.UIParent)
	toolbarRight:Point("RIGHT", rightbutton, "LEFT", -spacing, 0)
	toolbarRight:Size(1, buttonsize)
	toolbarRight.currentSize = buttonsize;

	local macrobar = CreateFrame("Frame", "SuperDockMacroBar", SV.UIParent)
	macrobar:Point("RIGHT", toolbarRight, "LEFT", -spacing, 0)
	macrobar:Size(1, buttonsize)
	macrobar.currentSize = buttonsize;

	local rightdock = CreateFrame("Frame", "RightSuperDock", SV.UIParent)
	rightdock:SetFrameStrata("BACKGROUND")
	rightdock:Point("BOTTOMRIGHT", SV.UIParent, "BOTTOMRIGHT", -1, buttonsize + 10)
	rightdock:Size(rightWidth, rightHeight)
	SV.Mentalo:Add(rightdock, L["Right Dock"])

	rightalert:SetParent(rightdock)
	rightalert:SetFrameStrata("BACKGROUND")
	rightalert:Size(rightWidth, 1)
	rightalert:Point("BOTTOMLEFT", rightdock, "BOTTOMLEFT", 0, 0)
	rightalert:SetFrameLevel(rightalert:GetFrameLevel() + 2)
	rightalert.Activate = AlertActivate
	rightalert.Deactivate = AlertDeactivate

	local rightwindow = CreateFrame("Frame", "SuperDockWindowRight", rightdock)
	rightwindow:SetFrameStrata("BACKGROUND")
	rightwindow:Point("BOTTOMLEFT", rightalert, "TOPLEFT", 0, 0)
	rightwindow:Size(rightWidth, rightHeight)
	rightdock.backdrop = SetSuperDockStyle(rightwindow)

	if SV.cache.Docks.SuperDockFaded then LeftSuperDock:Hide() RightSuperDock:Hide() end

	local toolbarTop = CreateFrame("Frame", "SuperDockToolBarTop", SV.UIParent)
	toolbarTop:Point("TOPLEFT", SV.UIParent, "TOPLEFT", 2, -4)
	toolbarTop:Size(1, buttonsize - 12)
	toolbarTop.openWidth = buttonsize + 12;

	--TOP STAT HOLDERS
	local topWidth = (leftWidth + rightWidth) * 0.8
	local topanchor = CreateFrame("Frame", "SuperDockTopDataAnchor", SV.UIParent)
	topanchor:Size(topWidth - 2, buttonsize - 8)
	topanchor:Point("LEFT", toolbarTop, "RIGHT", spacing, 0)
	SV:AddToDisplayAudit(topanchor)

	local topleftdata = CreateFrame("Frame", "TopLeftDataPanel", topanchor)
	topleftdata:Size((topWidth * 0.5) - 1, buttonsize - 8)
	topleftdata:Point("LEFT", topanchor, "LEFT", 0, 0)
	STATS:NewAnchor(topleftdata, 3, "ANCHOR_CURSOR", true)

	local toprightdata = CreateFrame("Frame", "TopRightDataPanel", topanchor)
	toprightdata:Size((topWidth * 0.5) - 1, buttonsize - 8)
	toprightdata:Point("RIGHT", topanchor, "RIGHT", 0, 0)
	STATS:NewAnchor(toprightdata, 3, "ANCHOR_CURSOR", true)

	--BOTTOM STAT HOLDERS
	local bottomanchor = CreateFrame("Frame", "SuperDockBottomDataAnchor", SV.UIParent)
	bottomanchor:Size(statBarWidth - 2, buttonsize - 8)
	bottomanchor:Point("BOTTOM", SV.UIParent, "BOTTOM", 0, 2)
	--SV:AddToDisplayAudit(bottomanchor)

	local bottomleftdata = CreateFrame("Frame", "BottomLeftDataPanel", bottomanchor)
	bottomleftdata:Size((statBarWidth * 0.5) - 1, buttonsize - 8)
	bottomleftdata:Point("LEFT", bottomanchor, "LEFT", 0, 0)
	STATS:NewAnchor(bottomleftdata, 3, "ANCHOR_CURSOR")

	local bottomrightdata = CreateFrame("Frame", "BottomRightDataPanel", bottomanchor)
	bottomrightdata:Size((statBarWidth * 0.5) - 1, buttonsize - 8)
	bottomrightdata:Point("RIGHT", bottomanchor, "RIGHT", 0, 0)
	STATS:NewAnchor(bottomrightdata, 3, "ANCHOR_CURSOR")

	--RIGHT CLICK MENU
	DockletMenu:SetParent(SV.UIParent)
	DockletMenu:SetPanelTemplate("Default")
	DockletMenu.buttons = {}
	DockletMenu:SetFrameStrata("DIALOG")
	DockletMenu:SetClampedToScreen(true)

	for i = 1, 4 do 
		DockletMenu.buttons[i] = CreateFrame("Button", nil, DockletMenu)

		DockletMenu.buttons[i].hoverTex = DockletMenu.buttons[i]:CreateTexture(nil, 'OVERLAY')
		DockletMenu.buttons[i].hoverTex:SetAllPoints()
		DockletMenu.buttons[i].hoverTex:SetTexture([[Interface\QuestFrame\UI-QuestTitleHighlight]])
		DockletMenu.buttons[i].hoverTex:SetBlendMode("ADD")
		DockletMenu.buttons[i].hoverTex:Hide()

		DockletMenu.buttons[i].activeTex = DockletMenu.buttons[i]:CreateTexture(nil, 'OVERLAY')
		DockletMenu.buttons[i].activeTex:SetAllPoints()
		DockletMenu.buttons[i].activeTex:SetTexture([[Interface\QuestFrame\UI-QuestTitleHighlight]])
		DockletMenu.buttons[i].activeTex:SetVertexColor(0,0.7,0)
		DockletMenu.buttons[i].activeTex:SetBlendMode("ADD")
		DockletMenu.buttons[i].activeTex:Hide()

		DockletMenu.buttons[i].text = DockletMenu.buttons[i]:CreateFontString(nil, 'BORDER')
		DockletMenu.buttons[i].text:SetAllPoints()
		DockletMenu.buttons[i].text:SetFont(SV.Media.font.roboto,12,"OUTLINE")
		DockletMenu.buttons[i].text:SetJustifyH("LEFT")
		DockletMenu.buttons[i].text:SetText(("Option %d"):format(i))

		DockletMenu.buttons[i]:SetHeight(16)
		DockletMenu.buttons[i]:SetWidth(115)

		DockletMenu.buttons[i]:SetScript("OnEnter", DD_OnEnter)
		DockletMenu.buttons[i]:SetScript("OnLeave", DD_OnLeave)
		DockletMenu.buttons[i]:SetScript("OnClick", DD_OnClick)

		if i == 1 then
			DockletMenu.buttons[i]:SetPoint("TOPLEFT", DockletMenu, "TOPLEFT", 10, -10)
		else
			DockletMenu.buttons[i]:SetPoint("TOPLEFT", DockletMenu.buttons[i - 1], "BOTTOMLEFT", 0, 0)
		end

		DockletMenu.buttons[i]:Show()
	end
	DockletMenu:SetSize(135, 94)
	DockletMenu:Hide()
	SV:AddToDisplayAudit(DockletMenu)
end

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
		if not self.TText2 then
			GameTooltip:AddLine("Open " .. self.TText, 1, 1, 1)
		else
			GameTooltip:AddDoubleLine("[Left-Click]", "Open " .. self.TText, 0, 1, 0, 1, 1, 1)
			GameTooltip:AddDoubleLine("[Right-Click]", "Use " .. self.TText2, 0, 1, 0, 1, 1, 1)
			if InCombatLockdown() then return end
			if(self.IsItem) then
				GameTooltip:AddLine(" ", 1, 1, 1)
				local remaining = GetMacroCooldown(self.IsItem)
				GameTooltip:AddDoubleLine(self.TText2, remaining, 1, 0.5, 0, 0, 1, 1)
			end
		end
	end

	local SetHearthTooltip = function(self)
		GameTooltip:AddLine(L["Hearthstone"], 1, 1, 1)
		if InCombatLockdown() then return end
		local remaining = GetMacroCooldown(6948)
		GameTooltip:AddDoubleLine(L["Time Remaining"], remaining, 1, 1, 1, 0, 1, 1)
		if(self.ExtraSpell) then
			GameTooltip:AddLine(" ", 1, 1, 1)
			GameTooltip:AddDoubleLine(self.ExtraSpell, "[Right Click]", 1, 1, 1, 0, 1, 0)
		end
	end

	local function AddMacroTool(frame)
		local width;
		local height = SuperDockToolBarRight.currentSize;
		if not LastAddedMacro then
			frame:Point("RIGHT", SuperDockMacroBar, "RIGHT", -6, 0);
		else
			frame:Point("RIGHT", LastAddedMacro, "LEFT", -6, 0);
		end
		LastAddedMacro = frame;
		MacroCount = MacroCount + 1;
		width = MacroCount * (height + 6)
		SuperDockMacroBar:Size(width, height)
	end 

	local function CreateMacroToolButton(proName, proID, itemID, size) 
		local data = TOOL_DATA[proID]
		if(not data) then return end
		local button = CreateFrame("Button", ("%s_MacroBarButton"):format(itemID), SuperDockMacroBar, "SecureActionButtonTemplate")
		button:Size(size, size)
		AddMacroTool(button)
		button:SetFramedButtonTemplate()
		button.icon = button:CreateTexture(nil, "OVERLAY")
		button.icon:FillInner(button, 2, 2)
		button.icon:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Icons\PROFESSIONS]])
		button.icon:SetTexCoord(data[1], data[2], data[3], data[4])
		button.icon:SetGradient("VERTICAL", 0.5, 0.53, 0.55, 0.8, 0.8, 1)
		button.skillName = proName;
		button.itemId = itemID;
		button.TText = proName;

		if proID == 186 then proName = "Smelting" end

		if(data[5]) then
			local rightClick
			button:RegisterForClicks("AnyDown")
			if(data[6] and GetItemCount(data[6], true) > 0) then
				rightClick = GetItemInfo(data[6])
				button.IsItem = data[6]
			else
				rightClick = GetSpellInfo(data[5])
			end
			button:SetAttribute("type", "macro")
			button:SetAttribute("macrotext", "/cast [button:2] " .. rightClick .. ";" .. proName)
			button.TText2 = rightClick
		else
			button:SetAttribute("type", "macro")
			button:SetAttribute("macrotext", "/cast " .. proName)
		end

		MOD:ActivateDockletButton(button, nil, SetMacroTooltip)
	end 

	function MOD:LoadToolBarProfessions()
		if(MOD.ToolBarLoaded) then return end
		if(InCombatLockdown()) then MOD:RegisterEvent("PLAYER_REGEN_ENABLED"); return end
		local size = SuperDockMacroBar.currentSize
		local hearth = CreateFrame("Button", "RightSuperDockHearthButton", SuperDockMacroBar, "SecureActionButtonTemplate")
		hearth:Size(size, size)
		AddMacroTool(hearth)
		hearth:SetFramedButtonTemplate()
		hearth.icon = hearth:CreateTexture(nil, "OVERLAY", nil, 0)
		hearth.icon:FillInner(hearth,2,2)
		hearth.icon:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Icons\\DOCK-HEARTH")
		hearth.icon:SetTexCoord(0,0.5,0,1)

		hearth:RegisterForClicks("AnyUp")
		hearth:SetAttribute("type", "item")
		hearth:SetAttribute("item", "Hearthstone")

		MOD:ActivateDockletButton(hearth, nil, SetHearthTooltip)

		for i = 1, #HEARTH_SPELLS do
			if(IsSpellKnown(HEARTH_SPELLS[i])) then
				local rightClickSpell = GetSpellInfo(HEARTH_SPELLS[i])
				hearth:SetAttribute("type2", "spell")
				hearth:SetAttribute("spell", rightClickSpell)
				hearth.ExtraSpell = rightClickSpell
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

		MOD.ToolBarLoaded = true
	end
end
--[[ 
########################################################## 
EXTERNALLY ACCESSIBLE METHODS
##########################################################
]]--
SV.CurrentlyDocked = {};
function SV:IsDockletReady(arg)
	local addon = arg;
	if arg == "DockletMain" or arg == "DockletExtra" then
		addon = self.db.SVDock.docklets[arg]
	end
	if addon == nil or addon == "None" then 
		return false 
	end 
	return true
end

function SV:RemoveTool()
	if not self or not self.listIndex then return end 
	local name = self:GetName();
	if not SAFETY_CACHE[name] then return end 
	SAFETY_CACHE[name] = false;
	local i = self.listIndex;
	tremove(TOOL_CACHE, i)
	local width;
	local height = SuperDockToolBarRight.currentSize;
	local PREV_TOOL = TOOL_CACHE[#TOOL_CACHE]
	local xOffset = (#TOOL_CACHE - 1) * (height + 6) + 6
	PREV_TOOL:SetPoint("RIGHT", SuperDockToolBarRight, "RIGHT", (xOffset * -1), 0);
	width = #TOOL_CACHE * (height + 6)
	SuperDockToolBarRight:Size(width, height)
	self:Hide()
end 

function SV:AddTool()
	local name = self:GetName();
	if SAFETY_CACHE[name] then return end 
	SAFETY_CACHE[name] = true;
	local width;
	local height = SuperDockToolBarRight.currentSize;
	local xOffset = #TOOL_CACHE * (height + 6) + 6
	self:SetPoint("RIGHT", SuperDockToolBarRight, "RIGHT", (xOffset * -1), 0);
	tinsert(TOOL_CACHE, self)
 	self.listIndex = #TOOL_CACHE;
	width = #TOOL_CACHE * (height + 6)
	SuperDockToolBarRight:Size(width, height)
	self:Show()
end

do
	local function UnregisterDocklet(name)
		local frame = _G[name];
		if not frame or not frame.listIndex then return end 
		local i = frame.listIndex;
		tremove(DOCKLET_CACHE, i)
	end

	function SV:ReloadDocklets(alert)
		if InCombatLockdown() then return end

		local frame, i;
		twipe(self.CurrentlyDocked);
		if self:IsDockletReady("DockletMain") then
			frame = self.db.SVDock.docklets.MainWindow
			if frame ~= nil and frame ~= "None" and _G[frame] then
				UnregisterDocklet(frame)
				self.db.SVDock.docklets.MainWindow = "None"
			end
		elseif AddOnButton.IsRegistered then
			self.RemoveTool(AddOnButton)
			AddOnButton.TText = "";
			AddOnButton.IsRegistered = false;
		end
		if self:IsDockletReady("DockletExtra") then
			frame = self.db.SVDock.docklets.ExtraWindow
			if frame ~= nil and frame ~= "None" and _G[frame] then
				UnregisterDocklet(frame)
				self.db.SVDock.docklets.ExtraWindow = "None"
			end
		end
		SuperDockletMain.FrameName = "None"
		SuperDockletExtra.FrameName = "None"

		local width = self.db.SVDock.dockRightWidth or 350;
		local height = (self.db.SVDock.dockRightHeight or 180) - 22

		if self:IsDockletReady('DockletMain') then
			if self:IsDockletReady("DockletExtra") and self.db.SVDock.docklets.enableExtra then
				width = width * 0.5;
			end
			SuperDockletMain:ClearAllPoints()
			SuperDockletMain:Size(width,height)
			SuperDockletMain:Point('BOTTOMLEFT',RightSuperDock,'BOTTOMLEFT',1,1)
			SuperDockletExtra:ClearAllPoints()
			SuperDockletExtra:Size(width,height)
			SuperDockletExtra:Point('BOTTOMLEFT',SuperDockletMain,'BOTTOMRIGHT',0,0)
		end
	end 
end

function SV:RegisterDocklet(name, tooltip, texture, onclick, isdefault)
	local frame = _G[name];
	if frame and (frame.IsObjectType and frame:IsObjectType("Frame")) and (frame.IsProtected and not frame:IsProtected()) then 
		frame:ClearAllPoints()
		frame:SetParent(SuperDockWindowRight)
		frame:FillInner(SuperDockWindowRight, 4, 4)
		frame.FrameName = name;
		tinsert(DOCKLET_CACHE, frame);
		frame.listIndex = #DOCKLET_CACHE;
		frame.ToolbarButton = self.SVDock:CreateBasicToolButton(tooltip, texture, onclick, name, isdefault)
	end
end

function SV:RegisterMainDocklet(name)
	local frame = _G[name];
	if (frame and (frame.IsObjectType and frame:IsObjectType("Frame")) and (frame.IsProtected and not frame:IsProtected())) then 
		SuperDockletMain.FrameName = name;
		SV.db.SVDock.docklets.MainWindow = name;
		frame:ClearAllPoints()
		frame:SetParent(SuperDockletMain)
		frame:SetAllPoints(SuperDockletMain)
		frame.ToggleName = "SVUI_AddonDocklet";
		tinsert(DOCKLET_CACHE, frame);
		frame.listIndex = #DOCKLET_CACHE;
		self.AddTool(AddOnButton)
		AddOnButton.TText = "";
		AddOnButton.IsRegistered = true
		self.CurrentlyDocked[name] = true
		if not InCombatLockdown() and frame:IsShown() then frame:Hide() end 
	end
end 

function SV:RegisterExtraDocklet(name)
	local frame = _G[name];
	if (frame and (frame.IsObjectType and frame:IsObjectType("Frame")) and (frame.IsProtected and not frame:IsProtected())) then 
		SuperDockletExtra.FrameName = name;
		SV.db.SVDock.docklets.ExtraWindow = name;
		frame:ClearAllPoints()
		frame:SetParent(SuperDockletExtra)
		frame:SetAllPoints(SuperDockletExtra)
		frame.ToggleName = "SVUI_AddonDocklet";
		tinsert(DOCKLET_CACHE, frame);
		frame.listIndex = #DOCKLET_CACHE;
		AddOnButton.TText = "";
		self.CurrentlyDocked[name] = true;
		if not InCombatLockdown() and frame:IsShown() then frame:Hide() end 
	end
end
--[[ 
########################################################## 
BUILD/UPDATE
##########################################################
]]--
function MOD:UpdateSuperDock()
	local leftWidth = SV.db.SVDock.dockLeftWidth or 350;
	local leftHeight = SV.db.SVDock.dockLeftHeight or 180;
	local rightWidth = SV.db.SVDock.dockRightWidth or 350;
	local rightHeight = SV.db.SVDock.dockRightHeight or 180;
	local buttonsize = SV.db.SVDock.buttonSize or 22;
	local spacing = SV.db.SVDock.buttonSpacing or 4;
	local statBarWidth = SV.db.SVDock.dockStatWidth or defaultStatBarWidth

	_G["LeftSuperDock"]:Size(leftWidth, leftHeight)
	_G["SuperDockAlertLeft"]:Width(leftWidth)
	_G["SuperDockWindowLeft"]:Size(leftWidth, leftHeight)
	_G["RightSuperDock"]:Size(rightWidth, rightHeight)
	_G["SuperDockAlertRight"]:Width(rightWidth)
	_G["SuperDockWindowRight"]:Size(rightWidth, rightHeight)
	_G["SuperDockBottomDataAnchor"]:Size(statBarWidth - 2, buttonsize - 8)
	_G["BottomLeftDataPanel"]:Size((statBarWidth * 0.5) - 1, buttonsize - 8)
	_G["BottomRightDataPanel"]:Size((statBarWidth * 0.5) - 1, buttonsize - 8)

	self:BottomPanelVisibility();
	self:TopPanelVisibility();
	self:UpdateDockBackdrops();
	SV:ReloadDocklets()
end  

function MOD:UpdateDockBackdrops()
	if SV.db.SVDock.rightDockBackdrop then
		RightSuperDock.backdrop:Show()
		RightSuperDock.backdrop:ClearAllPoints()
		RightSuperDock.backdrop:WrapOuter(RightSuperDock, 4, 4)
	else
		RightSuperDock.backdrop:Hide()
	end
	if SV.db.SVDock.leftDockBackdrop then
		LeftSuperDock.backdrop:Show()
		LeftSuperDock.backdrop:ClearAllPoints()
		LeftSuperDock.backdrop:WrapOuter(LeftSuperDock, 4, 4)
	else
		LeftSuperDock.backdrop:Hide()
	end
end 

function MOD:BottomPanelVisibility()
	if SV.db.SVDock.bottomPanel then 
		self.BottomPanel:Show()
	else 
		self.BottomPanel:Hide()
	end 
end 

function MOD:TopPanelVisibility()
	if SV.db.SVDock.topPanel then 
		self.TopPanel:Show()
	else 
		self.TopPanel:Hide()
	end 
end

function MOD:PLAYER_REGEN_ENABLED()
	self:UnregisterEvent('PLAYER_REGEN_ENABLED')
	self:LoadToolBarProfessions()
end

function MOD:ReLoad()
	self:UpdateSuperDock();
end 

function MOD:Load()
	SV.cache.Docks = SV.cache.Docks	or {}

	if(not SV.cache.Docks.SuperDockFaded) then 
		SV.cache.Docks.SuperDockFaded = false
	end

	self:CreateSuperBorders()
	self:CreateDockPanels()
	local width = RightSuperDock:GetWidth();
	local height = RightSuperDock:GetHeight() - 22
	SuperDockWindowRight:Size(width, height)
	SuperDockWindowRight:SetPoint("BOTTOMLEFT", SuperDockAlertRight, "TOPLEFT", 0, 0)
	SuperDockWindowRight:SetScript("OnShow", Docklet_OnShow)
	--SuperDockWindowRight:SetScript("OnHide", CycleDocklets)

	if not InCombatLockdown()then 
		CycleDocklets()
	end 

	hooksecurefunc(RightSuperDock, "SetSize", rightDockSizeHook)
	self:UpdateDockBackdrops()
	SuperDockletMain:SetFrameLevel(SuperDockWindowRight:GetFrameLevel() + 50)
	SuperDockletExtra:SetFrameLevel(SuperDockWindowRight:GetFrameLevel() + 50)

	local size = SuperDockToolBarRight.currentSize;

	AddOnButton:SetParent(SuperDockToolBarRight)
	AddOnButton:Size(size, size)
	AddOnButton:SetFramedButtonTemplate()
	AddOnButton.icon = AddOnButton:CreateTexture(nil, "OVERLAY")
	AddOnButton.icon:FillInner()
	AddOnButton.icon:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Icons\DOCK-ADDON]])
	AddOnButton.TText = "";
	AddOnButton.IsRegistered = false;

	MOD:ActivateDockletButton(AddOnButton, AddonDockletToggle)

	AddOnButton:Hide()

	SuperDockletMain:SetScript("OnShow", DockletFrame_OnShow)
	SuperDockletExtra:SetScript("OnShow", DockletFrame_OnShow)
	SV:ReloadDocklets(true)
	SV.Timers:ExecuteTimer(self.LoadToolBarProfessions, 5)
end