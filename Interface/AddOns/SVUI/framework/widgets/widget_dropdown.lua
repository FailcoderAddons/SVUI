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
local InCombatLockdown     	= _G.InCombatLockdown;
local CreateFrame          	= _G.CreateFrame;
--[[ 
########################################################## 
ADDON
##########################################################
]]--
local SV = select(2, ...)
local L = SV.L

SV.Dropdown = _G["SVUI_DropdownFrame"];

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

local function GetScreenPosition(parent)
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

function SV.Dropdown:Open(parent, list)
	if(InCombatLockdown() or (not list)) then return end

	if not self.buttons then
		self.buttons = {}
		self:SetFrameStrata("DIALOG")
		self:SetClampedToScreen(true)
		tinsert(UISpecialFrames, self:GetName())
		self:Hide()
	end
	local maxPerColumn = 25
	local cols = 1
	for i=1, #self.buttons do
		self.buttons[i]:Hide()
	end

	for i=1, #list do 
		if not self.buttons[i] then
			self.buttons[i] = CreateFrame("Button", nil, self)
			self.buttons[i].hoverTex = self.buttons[i]:CreateTexture(nil, 'OVERLAY')
			self.buttons[i].hoverTex:SetAllPoints()
			self.buttons[i].hoverTex:SetTexture([[Interface\QuestFrame\UI-QuestTitleHighlight]])
			self.buttons[i].hoverTex:SetBlendMode("ADD")
			self.buttons[i].hoverTex:Hide()
			self.buttons[i].text = self.buttons[i]:CreateFontString(nil, 'BORDER')
			self.buttons[i].text:SetAllPoints()
			self.buttons[i].text:SetFont(SV.Media.font.roboto,12,"OUTLINE")
			self.buttons[i].text:SetJustifyH("LEFT")
			self.buttons[i]:SetScript("OnEnter", DD_OnEnter)
			self.buttons[i]:SetScript("OnLeave", DD_OnLeave)           
		end
		self.buttons[i]:Show()
		self.buttons[i]:SetHeight(16)
		self.buttons[i]:SetWidth(135)
		self.buttons[i].text:SetText(list[i].text)
		self.buttons[i].func = list[i].func
		self.buttons[i]:SetScript("OnClick", DD_OnClick)
		if i == 1 then
			self.buttons[i]:SetPoint("TOPLEFT", self, "TOPLEFT", 10, -10)
		elseif((i -1) % maxPerColumn == 0) then
			self.buttons[i]:SetPoint("TOPLEFT", self.buttons[i - maxPerColumn], "TOPRIGHT", 10, 0)
			cols = cols + 1
		else
			self.buttons[i]:SetPoint("TOPLEFT", self.buttons[i - 1], "BOTTOMLEFT")
		end
	end

	local maxHeight = (min(maxPerColumn, #list) * 16) + 20
	local maxWidth = (135 * cols) + (10 * cols)
	self:SetSize(maxWidth, maxHeight)    
	self:ClearAllPoints()
	local point = GetScreenPosition(parent:GetParent()) 
	if point:find("BOTTOM") then
		self:SetPoint("BOTTOMLEFT", parent, "TOPLEFT", 10, 10)
	else
		self:SetPoint("TOPLEFT", parent, "BOTTOMLEFT", 10, -10)
	end
	ToggleFrame(self)
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

function SV.Dropdown:Initialize()
	self:SetParent(SV.Screen)
	self:SetPanelTemplate("Default")
	self.buttons = {}
	self:SetClampedToScreen(true)
	self:SetSize(135, 94)

	SV:AddToDisplayAudit(self)
end