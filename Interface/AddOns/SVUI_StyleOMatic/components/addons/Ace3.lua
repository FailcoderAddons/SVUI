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
--[[ GLOBALS ]]--
local _G = _G;
local unpack  = _G.unpack;
local select  = _G.select;
--[[ ADDON ]]--
local SV = _G.SVUI;
local L = SV.L;
local PLUGIN = select(2, ...);
local Schema = PLUGIN.Schema;
--[[ 
########################################################## 
HELPERS
##########################################################
]]--
local RegisterAsWidget, RegisterAsContainer;

local DockableAddons = {
	["alDamageMeter"] = L["alDamageMeter"],
	["Skada"] = L["Skada"],
	["Recount"] = L["Recount"],
	["TinyDPS"] = L["TinyDPS"],
	["Omen"] = L["Omen"]
}

local function GetLiveDockletsA()
	local test = SV.db.Dock.docklets.DockletExtra;
	local t = {["None"] = L["None"]};
	for n,l in pairs(DockableAddons) do
		if IsAddOnLoaded(n) or IsAddOnLoaded(l) then
			if (test ~= n and test ~= l) then
				if n == "Skada" and _G.Skada then
					for index,window in pairs(_G.Skada:GetWindows()) do
					    local key = window.db.name
					    t["SkadaBarWindow"..key] = (key == "Skada") and "Skada - Main" or "Skada - "..key;
					end
				else
					t[n] = l;
				end
			end
		end
	end
	return t;
end

local function GetLiveDockletsB()
	local test = SV.db.Dock.docklets.DockletMain;
	local t = {["None"] = L["None"]};
	for n,l in pairs(DockableAddons) do
		if IsAddOnLoaded(n) or IsAddOnLoaded(l) then
			if (test ~= n and test ~= l) then
				if n == "Skada" and _G.Skada then
					for index,window in pairs(_G.Skada:GetWindows()) do
					    local key = window.db.name
					    t["SkadaBarWindow"..key] = (key == "Skada") and "Skada - Main" or "Skada - "..key;
					end
				else
					t[n] = l;
				end
			end
		end
	end
	return t;
end

local ProxyLSMType = {
	["LSM30_Font"] = true, 
	["LSM30_Sound"] = true, 
	["LSM30_Border"] = true, 
	["LSM30_Background"] = true, 
	["LSM30_Statusbar"] = true
}

local ProxyType = {
	["InlineGroup"] = true, 
	["TreeGroup"] = true, 
	["TabGroup"] = true, 
	["SimpleGroup"] = true,
	["DropdownGroup"] = true
}

local function Widget_OnEnter(b)
	b:SetBackdropBorderColor(0.1, 0.8, 0.8)
end

local function Widget_OnLeave(b)
	b:SetBackdropBorderColor(0,0,0,1)
end

local function Widget_ScrollStyle(frame, arg)
	return PLUGIN:ApplyScrollFrameStyle(frame) 
end 

local function Widget_ButtonStyle(frame, strip, bypass)
	if frame.Left then frame.Left:SetAlpha(0) end 
	if frame.Middle then frame.Middle:SetAlpha(0) end 
	if frame.Right then frame.Right:SetAlpha(0) end 
	if frame.SetNormalTexture then frame:SetNormalTexture("") end 
	if frame.SetHighlightTexture then frame:SetHighlightTexture(0,0,0,0) end 
	if frame.SetPushedTexture then frame:SetPushedTexture(0,0,0,0) end 
	if frame.SetDisabledTexture then frame:SetDisabledTexture("") end 
	if strip then frame:RemoveTextures() end 
	if not bypass then 
		frame:SetButtonTemplate()
	end
end 

local function Widget_PaginationStyle(...)
	PLUGIN:ApplyPaginationStyle(...)
end

local NOOP = SV.fubar

local WidgetButton_OnClick = function(self)
	local obj = self.obj;
	if(obj and obj.pullout and obj.pullout.frame) then
		PLUGIN:ApplyFrameStyle(obj.pullout.frame, "Default", true)
	end
end

local WidgetDropButton_OnClick = function(self)
	local obj = self.obj;
	local widgetFrame = obj.dropdown
	if(widgetFrame) then
		PLUGIN:ApplyAdjustedFrameStyle(widgetFrame, "Transparent", 20, -2, -20, 2)
	end
end
--[[ 
########################################################## 
AceGUI PLUGIN
##########################################################
]]--
local function StyleAceGUI(event, addon)
	local AceGUI = LibStub("AceGUI-3.0", true)

	assert(AceGUI and (AceGUI.RegisterAsContainer ~= RegisterAsContainer or AceGUI.RegisterAsWidget ~= RegisterAsWidget), "Addon Not Loaded")

	local regWidget = AceGUI.RegisterAsWidget;
	local regContainer = AceGUI.RegisterAsContainer;

	RegisterAsWidget = function(self, widget)

		local widgetType = widget.type;
		-- print("RegisterAsWidget: " .. widgetType);
		if(widgetType == "MultiLineEditBox") then 
			local widgetFrame = widget.frame;
			PLUGIN:ApplyFixedFrameStyle(widgetFrame, "Default", true)
			PLUGIN:ApplyFrameStyle(widget.scrollBG, "Transparent", true) 
			Widget_ButtonStyle(widget.button)
			PLUGIN:ApplyScrollFrameStyle(widget.scrollBar) 
			widget.scrollBar:SetPoint("RIGHT", widgetFrame, "RIGHT", -4)
			widget.scrollBG:SetPoint("TOPRIGHT", widget.scrollBar, "TOPLEFT", -2, 19)
			widget.scrollBG:SetPoint("BOTTOMLEFT", widget.button, "TOPLEFT")
			widget.scrollFrame:SetPoint("BOTTOMRIGHT", widget.scrollBG, "BOTTOMRIGHT", -4, 8)

		elseif(widgetType == "CheckBox") then 
			widget.checkbg:Die()
			widget.highlight:Die()
			if not widget.styledCheckBG then 
				widget.styledCheckBG = CreateFrame("Frame", nil, widget.frame)
				widget.styledCheckBG:FillInner(widget.check)
				PLUGIN:ApplyFixedFrameStyle(widget.styledCheckBG, "Inset")
			end 
			widget.check:SetParent(widget.styledCheckBG)

		elseif(widgetType == "Dropdown") then 
			local widgetDropdown = widget.dropdown;
			local widgetButton = widget.button;

			widgetDropdown:RemoveTextures()
			widgetButton:ClearAllPoints()
			widgetButton:Point("RIGHT", widgetDropdown, "RIGHT", -20, 0)
			widgetButton:SetFrameLevel(widgetButton:GetFrameLevel() + 1)
			Widget_PaginationStyle(widgetButton, true)

			PLUGIN:ApplyAdjustedFrameStyle(widgetDropdown, "Transparent", 20, -2, -20, 2)

			widgetButton:SetParent(widgetDropdown.Panel)
			widget.text:SetParent(widgetDropdown.Panel)
			widgetButton:HookScript("OnClick", WidgetButton_OnClick)

		elseif(widgetType == "EditBox") then 
			local widgetEditbox = widget.editbox;
			PLUGIN:ApplyEditBoxStyle(widgetEditbox, nil, 15, 2, -2)

		elseif(widgetType == "Button") then 
			local widgetFrame = widget.frame;
			Widget_ButtonStyle(widgetFrame, true)
			widget.text:SetParent(widgetFrame.Panel)

		elseif(widgetType == "Slider") then 
			local widgetSlider = widget.slider;
			local widgetEditbox = widget.editbox;

			PLUGIN:ApplyFixedFrameStyle(widgetSlider, "Bar")

			widgetSlider:Height(20)
			widgetSlider:SetThumbTexture("Interface\\Buttons\\UI-ScrollBar-Knob")
			widgetSlider:GetThumbTexture():SetVertexColor(0.8, 0.8, 0.8)

			widgetEditbox:Height(15)
			widgetEditbox:SetPoint("TOP", widgetSlider, "BOTTOM", 0, -1)

			widget.lowtext:SetPoint("TOPLEFT", widgetSlider, "BOTTOMLEFT", 2, -2)
			widget.hightext:SetPoint("TOPRIGHT", widgetSlider, "BOTTOMRIGHT", -2, -2)

		elseif(ProxyLSMType[widgetType]) then 
			local widgetFrame = widget.frame;
			local dropButton = widgetFrame.dropButton;

			widgetFrame:RemoveTextures()
			Widget_PaginationStyle(dropButton, true)
			widgetFrame.text:ClearAllPoints()
			widgetFrame.text:Point("RIGHT", dropButton, "LEFT", -2, 0)
			dropButton:ClearAllPoints()
			dropButton:Point("RIGHT", widgetFrame, "RIGHT", -10, -6)
			if(not widgetFrame.Panel) then 
				if(widgetType == "LSM30_Font") then 
					PLUGIN:ApplyAdjustedFrameStyle(widgetFrame, "Transparent", 20, -17, 2, -2)
				elseif(widgetType == "LSM30_Sound") then 
					PLUGIN:ApplyAdjustedFrameStyle(widgetFrame, "Transparent", 20, -17, 2, -2)
					widget.soundbutton:SetParent(widgetFrame.Panel)
					widget.soundbutton:ClearAllPoints()
					widget.soundbutton:Point("LEFT", widgetFrame.Panel, "LEFT", 2, 0)
				elseif(widgetType == "LSM30_Statusbar") then 
					PLUGIN:ApplyAdjustedFrameStyle(widgetFrame, "Transparent", 20, -17, 2, -2)
					widget.bar:SetParent(widgetFrame.Panel)
					widget.bar:FillInner()
				elseif(widgetType == "LSM30_Border" or widgetType == "LSM30_Background") then 
					PLUGIN:ApplyAdjustedFrameStyle(widgetFrame, "Transparent", 42, -16, 2, -2)
				end 
				widgetFrame.Panel:Point("BOTTOMRIGHT", dropButton, "BOTTOMRIGHT", 2, -2)
				PLUGIN:ApplyAdjustedFrameStyle(widgetFrame, "Transparent", 20, -2, 2, -2)
			end 
			dropButton:SetParent(widgetFrame.Panel)
			widgetFrame.text:SetParent(widgetFrame.Panel)
			dropButton:HookScript("OnClick", WidgetDropButton_OnClick)
		end
		return regWidget(self, widget)
	end

	AceGUI.RegisterAsWidget = RegisterAsWidget

	RegisterAsContainer = function(self, widget)
		local widgetType = widget.type;
		-- print("RegisterAsContainer: " .. widgetType);
		local widgetParent = widget.content:GetParent()
		if widgetType == "ScrollFrame" then 
			PLUGIN:ApplyScrollFrameStyle(widget.scrollBar) 
		elseif widgetType == "Frame" then
			for i = 1, widgetParent:GetNumChildren()do 
				local childFrame = select(i, widgetParent:GetChildren())
				if childFrame:GetObjectType() == "Button" and childFrame:GetText() then 
					Widget_ButtonStyle(childFrame)
				else 
					childFrame:RemoveTextures()
				end 
			end
			PLUGIN:ApplyWindowStyle(widgetParent)
		elseif(ProxyType[widgetType]) then

			if widget.treeframe then 
				PLUGIN:ApplyFrameStyle(widget.treeframe, "Transparent", true)
				widgetParent:SetPoint("TOPLEFT", widget.treeframe, "TOPRIGHT", 1, 0)
				local oldFunc = widget.CreateButton;
				widget.CreateButton = function(self)
					local newButton = oldFunc(self)
					newButton.toggle:RemoveTextures()
					newButton.toggle.SetNormalTexture = NOOP;
					newButton.toggle.SetPushedTexture = NOOP;
					newButton.toggle:SetButtonTemplate()
					newButton.toggleText = newButton.toggle:CreateFontString(nil, "OVERLAY")
					newButton.toggleText:SetFont([[Interface\AddOns\SVUI\assets\fonts\Roboto.ttf]], 19)
					newButton.toggleText:SetPoint("CENTER")
					newButton.toggleText:SetText("*")
					return newButton 
				end
			else
				PLUGIN:ApplyFrameStyle(widgetParent, "Default", true)
			end

			if(widgetType == "TabGroup") then 
				local oldFunc = widget.CreateTab;
				widget.CreateTab = function(self, arg)
					local newTab = oldFunc(self, arg)
					newTab:RemoveTextures()
					return newTab 
				end 
			end

			if widget.scrollbar then 
				PLUGIN:ApplyScrollFrameStyle(widget.scrollBar) 
			end 
		end
		return regContainer(self, widget)
	end 

	AceGUI.RegisterAsContainer = RegisterAsContainer

	SV.Options.args.Dock.args.docklets = {
		order = 100,
		type = 'group',
		name = 'Addon Docklets',
		guiInline = true,
		args = {
			docked = {
				order = 0,
				type = 'group',
				name = 'Docklet Settings',
				guiInline = true,
				args = {
					DockletMain = {
						type = "select",
						order = 1,
						name = "Primary Docklet",
						desc = "Select an addon to occupy the primary docklet window",
						values = function()return GetLiveDockletsA()end,
						get = function()return PLUGIN.cache.Docks[1] end,
						set = function(a,value) PLUGIN.cache.Docks[1] = value; PLUGIN:RegisterAddonDocklets() end,
					},
					DockletCombatFade = {
						type = "toggle",
						order = 2,
						name = "Out of Combat (Hide)",
						get = function()return PLUGIN.db.docklets.DockletCombatFade end,
						set = function(a,value) PLUGIN.db.docklets.DockletCombatFade = value;end
					},
					enableExtra = {
						type = "toggle",
						order = 3,
						name = "Split Docklet",
						desc = "Split the primary docklet window for 2 addons.",
						get = function()return PLUGIN.db.docklets.enableExtra end,
						set = function(a,value) PLUGIN.db.docklets.enableExtra = value; PLUGIN:RegisterAddonDocklets() end,
					},
					DockletExtra = {
						type = "select",
						order = 4,
						name = "Secondary Docklet",
						desc = "Select another addon",
						disabled = function()return (not PLUGIN.db.docklets.enableExtra or PLUGIN.cache.Docks[1] == "None") end, 
						values = function()return GetLiveDockletsB()end,
						get = function()return PLUGIN.cache.Docks[2] end,
						set = function(a,value) PLUGIN.cache.Docks[2] = value; PLUGIN:RegisterAddonDocklets() end,
					}
				}
			}
		}
	}
end
--[[ 
########################################################## 
PLUGIN LOADING
##########################################################
]]--
PLUGIN:SaveAddonStyle("SVUI_ConfigOMatic", StyleAceGUI, nil, true)