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
local SV = _G.SVUI;
local L = SV.L;
local STYLE = select(2, ...);
local Schema = STYLE.Schema;
--[[ 
########################################################## 
HELPERS
##########################################################
]]--
local externaltest = false;

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
	["Frame"] = true, 
	["DropdownGroup"] = true
}

local function Widget_OnEnter(b)
	b:SetBackdropBorderColor(0.1, 0.8, 0.8)
end

local function Widget_OnLeave(b)
	b:SetBackdropBorderColor(0,0,0,1)
end

local function Widget_ScrollStyle(frame, arg)
	return STYLE:ApplyScrollFrameStyle(frame) 
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
	if not frame.Panel and not bypass then frame:SetButtonTemplate() end 
	frame:HookScript("OnEnter", Widget_OnEnter)
	frame:HookScript("OnLeave", Widget_OnLeave)
end 

local function Widget_PaginationStyle(...)
	STYLE:ApplyPaginationStyle(...)
end

local NOOP = SV.fubar

local WidgetButton_OnClick = function(self)
	local obj = self.obj;
	if(obj and obj.pullout and obj.pullout.frame and (not obj.pullout.frame.Panel)) then
		obj.pullout.frame:SetFixedPanelTemplate("Default")
	end
end

local WidgetDropButton_OnClick = function(self)
	local obj = self.obj;
	local widgetFrame = obj.dropdown
	if(widgetFrame and not widgetFrame.Panel) then
		widgetFrame:SetBasicPanel()
		widgetFrame.Panel:SetPoint("TOPLEFT", widgetFrame, "TOPLEFT", 20, -2)
		widgetFrame.Panel:SetPoint("BOTTOMRIGHT", widgetFrame, "BOTTOMRIGHT", -20, 2)
	end
end
--[[ 
########################################################## 
AceGUI STYLE
##########################################################
]]--
local function StyleAceGUI(event, addon)
	assert((LibStub("AceGUI-3.0") and (addon == SV.ConfigID)), "Addon Not Loaded")
	local AceGUI = LibStub("AceGUI-3.0")

	local regWidget = AceGUI.RegisterAsWidget;
	local regContainer = AceGUI.RegisterAsContainer;

	AceGUI.RegisterAsWidget = function(self, widget)

		local widgetType = widget.type;

		if(widgetType == "MultiLineEditBox") then 
			local widgetFrame = widget.frame;
			widgetFrame:SetFixedPanelTemplate("Default")
			if not widget.scrollBG.Panel then 
				widget.scrollBG:SetBasicPanel()
			end 
			Widget_ButtonStyle(widget.button)
			STYLE:ApplyScrollFrameStyle(widget.scrollBar) 
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
				widget.styledCheckBG:SetFixedPanelTemplate("Inset")
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

			if(not widgetDropdown.Panel) then 
				widgetDropdown:SetBasicPanel()
				widgetDropdown.Panel:Point("TOPLEFT", widgetDropdown, "TOPLEFT", 20, -2)
				widgetDropdown.Panel:Point("BOTTOMRIGHT", widgetDropdown, "BOTTOMRIGHT", -20, 2)
			end 

			widgetButton:SetParent(widgetDropdown.Panel)
			widget.text:SetParent(widgetDropdown.Panel)
			widgetButton:HookScript("OnClick", WidgetButton_OnClick)

		elseif(widgetType == "EditBox") then 
			local widgetEditbox = widget.editbox;
			local boxName = widgetEditbox:GetName()

			if(_G[boxName.."Left"]) then
				_G[boxName.."Left"]:Die()
			end

			if(_G[boxName.."Middle"]) then
				_G[boxName.."Middle"]:Die()
			end

			if(_G[boxName.."Right"]) then
				_G[boxName.."Right"]:Die()
			end

			widgetEditbox:Height(17)
			--widgetEditbox:SetFixedPanelTemplate("Default")
			Widget_ButtonStyle(widget.button)

		elseif(widgetType == "Button") then 
			local widgetFrame = widget.frame;
			Widget_ButtonStyle(widgetFrame, nil, true)
			
			if(not widgetFrame.Panel) then
				widgetFrame:RemoveTextures()
				widgetFrame:SetFixedPanelTemplate("Button", true)
			end
			widget.text:SetParent(widgetFrame.Panel)

		elseif(widgetType == "Slider") then 
			local widgetSlider = widget.slider;
			local widgetEditbox = widget.editbox;

			if(not widgetSlider.Panel) then
				widgetSlider:RemoveTextures()
				widgetSlider:SetFixedPanelTemplate("Bar")
			end

			widgetSlider:Height(20)
			widgetSlider:SetThumbTexture("Interface\\Buttons\\UI-ScrollBar-Knob")
			widgetSlider:GetThumbTexture():SetVertexColor(0.8, 0.8, 0.8)

			widgetEditbox:Height(15)
			widgetEditbox:SetPoint("TOP", widgetSlider, "BOTTOM", 0, -1)

			-- if(not widgetEditbox.Panel) then
			-- 	widgetEditbox:SetFixedPanelTemplate("Default")
			-- end

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
				widgetFrame:SetBasicPanel()
				if(widgetType == "LSM30_Font") then 
					widgetFrame.Panel:Point("TOPLEFT", 20, -17)
				elseif(widgetType == "LSM30_Sound") then 
					widgetFrame.Panel:Point("TOPLEFT", 20, -17)
					widget.soundbutton:SetParent(widgetFrame.Panel)
					widget.soundbutton:ClearAllPoints()
					widget.soundbutton:Point("LEFT", widgetFrame.Panel, "LEFT", 2, 0)
				elseif(widgetType == "LSM30_Statusbar") then 
					widgetFrame.Panel:Point("TOPLEFT", 20, -17)
					widget.bar:SetParent(widgetFrame.Panel)
					widget.bar:FillInner()
				elseif(widgetType == "LSM30_Border" or widgetType == "LSM30_Background") then 
					widgetFrame.Panel:Point("TOPLEFT", 42, -16)
				end 
				widgetFrame.Panel:Point("BOTTOMRIGHT", dropButton, "BOTTOMRIGHT", 2, -2)
			end 
			dropButton:SetParent(widgetFrame.Panel)
			widgetFrame.text:SetParent(widgetFrame.Panel)
			dropButton:HookScript("OnClick", WidgetDropButton_OnClick)
		end
		return regWidget(self, widget)
	end

	AceGUI.RegisterAsContainer = function(self, widget)
		local widgetType = widget.type;
		local widgetParent = widget.content:GetParent()
		if widgetType == "ScrollFrame" then 
			STYLE:ApplyScrollFrameStyle(widget.scrollBar) 
		elseif widgetType == "Window" then
			widgetParent:SetPanelTemplate("Halftone")
		elseif(ProxyType[widgetType]) then 
			if widgetType == "Frame" then 
				widgetParent:RemoveTextures()
				for i = 1, widgetParent:GetNumChildren()do 
					local childFrame = select(i, widgetParent:GetChildren())
					if childFrame:GetObjectType() == "Button" and childFrame:GetText() then 
						Widget_ButtonStyle(childFrame)
					else 
						childFrame:RemoveTextures()
					end 
				end 
			end

			if widget.treeframe then 
				widget.treeframe:SetBasicPanel()
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
				if not externaltest then 
					widgetParent:SetPanelTemplate("Halftone")
					widgetParent.Panel:SetFrameLevel(0)
					externaltest = true 
				else 
					widgetParent:SetFixedPanelTemplate("Default")
				end
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
				STYLE:ApplyScrollFrameStyle(widget.scrollBar) 
			end 
		end
		return regContainer(self, widget)
	end 
end
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
STYLE:SaveAddonStyle("ConfigOMatic", StyleAceGUI, nil, true)