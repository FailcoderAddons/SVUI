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
--]]
local SuperVillain, L = unpack(select(2, ...));
local MOD = {}
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local tinsert, wipe, pairs, ipairs, unpack, pcall, select = tinsert, table.wipe, pairs, ipairs, unpack, pcall, select;
local format, gsub, strfind, strmatch, tonumber = format, gsub, strfind, strmatch, tonumber;
--[[ 
########################################################## 
PRE VARS/FUNCTIONS
##########################################################
]]--
local AlertActivate = function(self, child)
	local size = MOD.db.buttonSize or 22;
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

local Dock_OnEnter = function(self, ...)
	if InCombatLockdown() then return end 
	self:SetPanelColor("highlight")
	if MOD.SuperDockFaded then 
		LeftSuperDock:Show()
		SuperVillain:SecureFadeIn(LeftSuperDock, 0.2, LeftSuperDock:GetAlpha(), 1)
		RightSuperDock:Show()
		SuperVillain:SecureFadeIn(RightSuperDock, 0.2, RightSuperDock:GetAlpha(), 1)
	end
	GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 4)
	GameTooltip:ClearLines()
	GameTooltip:AddLine(L["Toggle Docks"], 1, 1, 1)
	GameTooltip:Show()
end 

local Dock_OnLeave = function(self, ...)
	if InCombatLockdown() then return end 
	self:SetPanelColor("special")
	if MOD.SuperDockFaded then 
		SuperVillain:SecureFadeOut(LeftSuperDock, 0.2, LeftSuperDock:GetAlpha(), 0, true)
		SuperVillain:SecureFadeOut(RightSuperDock, 0.2, RightSuperDock:GetAlpha(), 0, true)
	end
	GameTooltip:Hide()
end 

local Dock_OnClick = function(self)
	GameTooltip:Hide()
	if MOD.SuperDockFaded then 
		MOD.SuperDockFaded = nil;
		SuperVillain:SecureFadeIn(LeftSuperDock, 0.2, LeftSuperDock:GetAlpha(), 1)
		SuperVillain:SecureFadeIn(RightSuperDock, 0.2, RightSuperDock:GetAlpha(), 1)
	else 
		MOD.SuperDockFaded = true;
		SuperVillain:SecureFadeOut(LeftSuperDock, 0.2, LeftSuperDock:GetAlpha(), 0, true)
		SuperVillain:SecureFadeOut(RightSuperDock, 0.2, RightSuperDock:GetAlpha(), 0, true)
	end 
	SVUI_Cache["Dock"].SuperDockFaded = MOD.SuperDockFaded
end 

local Button_OnEnter = function(self, ...)
	self:SetPanelColor("highlight")
	self.icon:SetGradient(unpack(SuperVillain.Media.gradient.bizzaro))
	GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 4)
	GameTooltip:ClearLines()
	GameTooltip:AddLine(self.TText, 1, 1, 1)
	GameTooltip:Show()
end 

local Button_OnLeave = function(self, ...)
	self:SetPanelColor("special")
	self.icon:SetGradient("VERTICAL", 0.5, 0.53, 0.55, 0.8, 0.8, 1)
	GameTooltip:Hide()
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
	backdrop.top:SetTexture(0, 0, 0, 0)
	backdrop.top:Point("TOPLEFT", 1, -1)
	backdrop.top:Point("TOPRIGHT", -1, 1)
	backdrop.top:SetAlpha(0)
	backdrop.top:Height(1)
	return backdrop 
end
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
function MOD:UpdateSuperDock()
	_G["LeftSuperDock"]:Size(MOD.db.dockLeftWidth, MOD.db.dockLeftHeight);
	_G["SuperDockAlertLeft"]:Width(MOD.db.dockLeftWidth);
	_G["SuperDockWindowLeft"]:Size(MOD.db.dockLeftWidth, MOD.db.dockLeftHeight);
	_G["RightSuperDock"]:Size(MOD.db.dockRightWidth, MOD.db.dockRightHeight);
	_G["SuperDockAlertRight"]:Width(MOD.db.dockRightWidth);
	_G["SuperDockWindowRight"]:Size(MOD.db.dockRightWidth, MOD.db.dockRightHeight);
	MOD:BottomPanelVisibility();
	MOD:TopPanelVisibility();
	MOD:UpdateDockBackdrops();
	MOD:ReloadDocklets()
end  

function MOD:UpdateDockBackdrops()
	if MOD.db.rightDockBackdrop then
		RightSuperDock.backdrop:Show()
		RightSuperDock.backdrop:ClearAllPoints()
		RightSuperDock.backdrop:WrapOuter(RightSuperDock, 4, 4)
	else
		RightSuperDock.backdrop:Hide()
	end
	if MOD.db.leftDockBackdrop then
		LeftSuperDock.backdrop:Show()
		LeftSuperDock.backdrop:ClearAllPoints()
		LeftSuperDock.backdrop:WrapOuter(LeftSuperDock, 4, 4)
	else
		LeftSuperDock.backdrop:Hide()
	end
end 

function MOD:BottomPanelVisibility()
	if MOD.db.bottomPanel then 
		MOD.BottomPanel:Show()
	else 
		MOD.BottomPanel:Hide()
	end 
end 

function MOD:TopPanelVisibility()
	if MOD.db.topPanel then 
		MOD.TopPanel:Show()
	else 
		MOD.TopPanel:Hide()
	end 
end 

function HideSuperDocks()
	Dock_OnClick(LeftDockToggleButton)
end 

function MOD:CreateSuperBorders()
	local texture = [[Interface\AddOns\SVUI\assets\artwork\Template\BUTTON]];

	local TopPanel = CreateFrame("Frame", "SVUITopPanel", SuperVillain.UIParent)
	TopPanel:Point("TOPLEFT", SuperVillain.UIParent, "TOPLEFT", -1, 1)
	TopPanel:Point("TOPRIGHT", SuperVillain.UIParent, "TOPRIGHT", 1, 1)
	TopPanel:Height(14)
	TopPanel:SetBackdrop({bgFile = texture, edgeFile = [[Interface\BUTTONS\WHITE8X8]], tile = false, tileSize = 0, edgeSize = 1, insets = {left = 0, right = 0, top = 0, bottom = 0}})
	TopPanel:SetBackdropColor(unpack(SuperVillain.Media.color.special))
	TopPanel:SetBackdropBorderColor(0,0,0,1)
	TopPanel:SetFrameLevel(0)
	TopPanel:SetFrameStrata('BACKGROUND')
	MOD.TopPanel = TopPanel;
	MOD.TopPanel:SetScript("OnShow", function(self)
		self:SetFrameLevel(0)
		self:SetFrameStrata('BACKGROUND')
	end)
	MOD:TopPanelVisibility()

	local BottomPanel = CreateFrame("Frame", "SVUIBottomPanel", SuperVillain.UIParent)
	BottomPanel:Point("BOTTOMLEFT", SuperVillain.UIParent, "BOTTOMLEFT", -1, -1)
	BottomPanel:Point("BOTTOMRIGHT", SuperVillain.UIParent, "BOTTOMRIGHT", 1, -1)
	BottomPanel:Height(14)
	BottomPanel:SetBackdrop({bgFile = texture, edgeFile = [[Interface\BUTTONS\WHITE8X8]], tile = false, tileSize = 0, edgeSize = 1, insets = {left = 0, right = 0, top = 0, bottom = 0}})
	BottomPanel:SetBackdropColor(unpack(SuperVillain.Media.color.special))
	BottomPanel:SetBackdropBorderColor(0,0,0,1)
	BottomPanel:SetFrameLevel(0)
	BottomPanel:SetFrameStrata('BACKGROUND')
	MOD.BottomPanel = BottomPanel;
	MOD.BottomPanel:SetScript("OnShow", function(self)
		self:SetFrameLevel(0)
		self:SetFrameStrata('BACKGROUND')
	end)
	MOD:BottomPanelVisibility()
end

local function BorderColorUpdates()
	SVUITopPanel:SetBackdropColor(unpack(SuperVillain.Media.color.special))
	SVUITopPanel:SetBackdropBorderColor(0,0,0,1)
	SVUIBottomPanel:SetBackdropColor(unpack(SuperVillain.Media.color.special))
	SVUIBottomPanel:SetBackdropBorderColor(0,0,0,1)
end

SuperVillain.Registry:SetCallback(BorderColorUpdates)

function MOD:CreateDockPanels()
	MOD.SuperDockFaded = SVUI_Cache["Dock"].SuperDockFaded
	local leftWidth = MOD.db.dockLeftWidth or 350;
	local leftHeight = MOD.db.dockLeftHeight or 180;
	local rightWidth = MOD.db.dockRightWidth or 350;
	local rightHeight = MOD.db.dockRightHeight or 180;
	local buttonsize = MOD.db.buttonSize or 22;
	local spacing = MOD.db.buttonSpacing or 4;
	local STATS = SuperVillain.Registry:Expose("SVStats");

	-- [[ CORNER BUTTON ]] --

	local leftbutton = CreateFrame("Button", "LeftSuperDockToggleButton", SuperVillain.UIParent)
	leftbutton:Point("BOTTOMLEFT", SuperVillain.UIParent, "BOTTOMLEFT", 1, 2)
	leftbutton:Size(buttonsize, buttonsize)
	leftbutton:SetFramedButtonTemplate()
	leftbutton.icon = leftbutton:CreateTexture(nil, "OVERLAY", nil, 0)
	leftbutton.icon:FillInner(leftbutton,2,2)
	leftbutton.icon:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Icons\\SVUI-EMBLEM")
	leftbutton:RegisterForClicks("AnyUp")
	leftbutton:SetScript("OnEnter", Dock_OnEnter)
	leftbutton:SetScript("OnLeave", Dock_OnLeave)
	leftbutton:SetScript("OnClick", Dock_OnClick)

	-- [[ TOOLBARS AND OTHER NONSENSE ]] --

	local toolbarLeft = CreateFrame("Button", "SuperDockToolBarLeft", SuperVillain.UIParent)
	toolbarLeft:Point("LEFT", leftbutton, "RIGHT", spacing, 0)
	toolbarLeft:Width(1)
	toolbarLeft:Height(buttonsize)
	toolbarLeft.currentSize = buttonsize;

	local leftstation = CreateFrame("Frame", "SuperDockChatTabBar", SuperVillain.UIParent)
	leftstation:SetFrameStrata("BACKGROUND")
	leftstation:Size(leftWidth - buttonsize, buttonsize)
	leftstation:Point("LEFT", toolbarLeft, "RIGHT", spacing, 0)
	leftstation:SetFrameLevel(leftstation:GetFrameLevel() + 2)
	leftstation.currentSize = buttonsize;

	local leftdock = CreateFrame("Frame", "LeftSuperDock", SuperVillain.UIParent)
	leftdock:SetFrameStrata("BACKGROUND")
	leftdock:Point("BOTTOMLEFT", SuperVillain.UIParent, "BOTTOMLEFT", 1, buttonsize + 10)
	leftdock:Size(leftWidth, leftHeight)
	SuperVillain:SetSVMovable(leftdock, "LeftDock_MOVE", L["Left Dock"])

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

	local rightbutton = CreateFrame("Button", "RightSuperDockToggleButton", SuperVillain.UIParent)
	rightbutton:Point("BOTTOMRIGHT", SuperVillain.UIParent, "BOTTOMRIGHT", -1, 2)
	rightbutton:Size(buttonsize, buttonsize)
	rightbutton:SetFramedButtonTemplate()
	rightbutton.icon = rightbutton:CreateTexture(nil, "OVERLAY")
	rightbutton.icon:FillInner(rightbutton,2,2)
	rightbutton.icon:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Icons\DOCK-HENCHMAN]])
	rightbutton.icon:SetGradient("VERTICAL", 0.5, 0.53, 0.55, 0.8, 0.8, 1)
	rightbutton.TText = "Call Henchman!"
	rightbutton:RegisterForClicks("AnyUp")
	rightbutton:SetScript("OnEnter", Button_OnEnter)
	rightbutton:SetScript("OnLeave", Button_OnLeave)
	rightbutton:SetScript("OnClick", function()SuperVillain:ToggleHenchman()end)

	-- [[ TOOLBARS AND OTHER NONSENSE ]] --

	local toolbarRight = CreateFrame("Button", "SuperDockToolBarRight", SuperVillain.UIParent)
	toolbarRight:Point("RIGHT", rightbutton, "LEFT", -spacing, 0)
	toolbarRight:Size(1, buttonsize)
	toolbarRight.currentSize = buttonsize;

	local macrobar = CreateFrame("Button", "SuperDockMacroBar", SuperVillain.UIParent)
	macrobar:Point("RIGHT", toolbarRight, "LEFT", -spacing, 0)
	macrobar:Size(1, buttonsize)
	macrobar.currentSize = buttonsize;

	local rightdock = CreateFrame("Frame", "RightSuperDock", SuperVillain.UIParent)
	rightdock:SetFrameStrata("BACKGROUND")
	rightdock:Point("BOTTOMRIGHT", SuperVillain.UIParent, "BOTTOMRIGHT", -1, buttonsize + 10)
	rightdock:Size(rightWidth, rightHeight)
	SuperVillain:SetSVMovable(rightdock, "RightDock_MOVE", L["Right Dock"])

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

	if MOD.SuperDockFaded then LeftSuperDock:Hide()RightSuperDock:Hide() end

	local toolbarTop = CreateFrame("Button", "SuperDockToolBarTop", SuperVillain.UIParent)
	toolbarTop:Point("TOPLEFT", SuperVillain.UIParent, "TOPLEFT", 4, -2)
	toolbarTop:Size(1, buttonsize - 12)
	toolbarTop.openWidth = (leftWidth - 1) / 3;

	--TOP STAT HOLDERS
	local topanchor = CreateFrame("Frame", "SuperDockTopDataAnchor", SuperVillain.UIParent)
	topanchor:Size((leftWidth + rightWidth) - 2, buttonsize - 8)
	topanchor:Point("LEFT", toolbarTop, "RIGHT", spacing, 0)
	SuperVillain:AddToDisplayAudit(topanchor)

	local topleftdata = CreateFrame("Frame", "TopLeftDataPanel", topanchor)
	topleftdata:Size(leftWidth - 1, buttonsize - 8)
	topleftdata:Point("LEFT", topanchor, "LEFT", 0, 0)
	STATS:NewAnchor(topleftdata, 3, "ANCHOR_CURSOR", 17, -4)

	local toprightdata = CreateFrame("Frame", "TopRightDataPanel", topanchor)
	toprightdata:Size(leftWidth - 1, buttonsize - 8)
	toprightdata:Point("RIGHT", topanchor, "RIGHT", 0, 0)
	STATS:NewAnchor(toprightdata, 3, "ANCHOR_CURSOR", 17, -4)

	--BOTTOM STAT HOLDERS
	local bottomanchor = CreateFrame("Frame", "SuperDockBottomDataAnchor", SuperVillain.UIParent)
	bottomanchor:Size((leftWidth + rightWidth) - 2, buttonsize - 8)
	bottomanchor:Point("BOTTOM", SuperVillain.UIParent, "BOTTOM", 0, 2)
	SuperVillain:AddToDisplayAudit(bottomanchor)

	local bottomleftdata = CreateFrame("Frame", "BottomLeftDataPanel", bottomanchor)
	bottomleftdata:Size(leftWidth - 1, buttonsize - 8)
	bottomleftdata:Point("LEFT", bottomanchor, "LEFT", 0, 0)
	STATS:NewAnchor(bottomleftdata, 3, "ANCHOR_CURSOR", 17, 4)

	local bottomrightdata = CreateFrame("Frame", "BottomRightDataPanel", bottomanchor)
	bottomrightdata:Size(rightWidth - 1, buttonsize - 8)
	bottomrightdata:Point("RIGHT", bottomanchor, "RIGHT", 0, 0)
	STATS:NewAnchor(bottomrightdata, 3, "ANCHOR_CURSOR", 17, 4)
end 

function MOD:ReLoad()
	self:UpdateSuperDock();
end 

function MOD:Load()
	self:CreateSuperBorders()
	self:CreateDockPanels()
	self:CreateDockWindow()
	self:Protect("LoadToolBarProfessions");
	SuperVillain:ExecuteTimer(MOD.LoadToolBarProfessions, 5)
	--self:RegisterEvent("PLAYER_REGEN_DISABLED", "DockletEnterCombat")
	--self:RegisterEvent("PLAYER_REGEN_ENABLED", "DockletExitCombat")
	self:DockletInit()
	self:UpdateDockBackdrops()
end 
SuperVillain.Registry:NewPackage(MOD, "SVDock")