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
local ipairs        = _G.ipairs;
local pairs         = _G.pairs;
--[[ ADDON ]]--
local SV = _G.SVUI;
local L = SV.L;
local STYLE = select(2, ...);
local Schema = STYLE.Schema;
--[[ 
########################################################## 
HELPERS
##########################################################
]]--
local CalendarButtons = {
	"CalendarViewEventAcceptButton",
	"CalendarViewEventTentativeButton",
	"CalendarViewEventRemoveButton",
	"CalendarViewEventDeclineButton"
};
--[[ 
########################################################## 
CALENDAR STYLER
##########################################################
]]--
local function CalendarStyle()
	if SV.db[Schema].blizzard.enable ~= true or SV.db[Schema].blizzard.calendar ~= true then
		 return 
	end

	STYLE:ApplyWindowStyle(CalendarFrame)

	STYLE:ApplyCloseButtonStyle(CalendarCloseButton)
	CalendarCloseButton:SetPoint("TOPRIGHT", CalendarFrame, "TOPRIGHT", -4, -4)
	STYLE:ApplyPaginationStyle(CalendarPrevMonthButton)
	STYLE:ApplyPaginationStyle(CalendarNextMonthButton)

	do 
		local cfframe = _G["CalendarFilterFrame"];
		
		if(cfframe) then
			cfframe:RemoveTextures()
			cfframe:Width(155)
			cfframe:SetPanelTemplate("Default")

			local cfbutton = _G["CalendarFilterButton"];
			if(cfbutton) then
				cfbutton:ClearAllPoints()
				cfbutton:SetPoint("RIGHT", cfframe, "RIGHT", -10, 3)
				STYLE:ApplyPaginationStyle(cfbutton, true)
				cfframe.Panel:SetPoint("TOPLEFT", 20, 2)
				cfframe.Panel:SetPoint("BOTTOMRIGHT", cfbutton, "BOTTOMRIGHT", 2, -2)

				local cftext = _G["CalendarFilterFrameText"]
				if(cftext) then
					cftext:ClearAllPoints()
					cftext:SetPoint("RIGHT", cfbutton, "LEFT", -2, 0)
				end
			end
		end
	end

	local l = CreateFrame("Frame", "CalendarFrameBackdrop", CalendarFrame)
	l:SetFixedPanelTemplate("Default")
	l:SetPoint("TOPLEFT", 10, -72)
	l:SetPoint("BOTTOMRIGHT", -8, 3)
	CalendarContextMenu:SetFixedPanelTemplate("Default")
	hooksecurefunc(CalendarContextMenu, "SetBackdropColor", function(f, r, g, b, a)
		if r ~= 0 or g ~= 0 or b ~= 0 or a ~= 0.5 then
			 f:SetBackdropColor(0, 0, 0, 0.5)
		end 
	end)
	hooksecurefunc(CalendarContextMenu, "SetBackdropBorderColor", function(f, r, g, b)
		if r ~= 0 or g ~= 0 or b ~= 0 then
			 f:SetBackdropBorderColor(0, 0, 0)
		end 
	end)
	for u = 1, 42 do
		 _G["CalendarDayButton"..u]:SetFrameLevel(_G["CalendarDayButton"..u]:GetFrameLevel()+1)
	end 
	CalendarCreateEventFrame:RemoveTextures()
	CalendarCreateEventFrame:SetFixedPanelTemplate("Transparent", true)
	CalendarCreateEventFrame:SetPoint("TOPLEFT", CalendarFrame, "TOPRIGHT", 3, -24)
	CalendarCreateEventTitleFrame:RemoveTextures()
	CalendarCreateEventCreateButton:SetButtonTemplate()
	CalendarCreateEventMassInviteButton:SetButtonTemplate()
	CalendarCreateEventInviteButton:SetButtonTemplate()
	CalendarCreateEventInviteButton:SetPoint("TOPLEFT", CalendarCreateEventInviteEdit, "TOPRIGHT", 4, 1)
	CalendarCreateEventInviteEdit:Width(CalendarCreateEventInviteEdit:GetWidth()-2)
	CalendarCreateEventInviteList:RemoveTextures()
	CalendarCreateEventInviteList:SetFixedPanelTemplate("Default")
	CalendarCreateEventInviteEdit:SetEditboxTemplate()
	CalendarCreateEventTitleEdit:SetEditboxTemplate()
	STYLE:ApplyDropdownStyle(CalendarCreateEventTypeDropDown, 120)
	CalendarCreateEventDescriptionContainer:RemoveTextures()
	CalendarCreateEventDescriptionContainer:SetFixedPanelTemplate("Default")
	STYLE:ApplyCloseButtonStyle(CalendarCreateEventCloseButton)
	CalendarCreateEventLockEventCheck:SetCheckboxTemplate(true)
	STYLE:ApplyDropdownStyle(CalendarCreateEventHourDropDown, 68)
	STYLE:ApplyDropdownStyle(CalendarCreateEventMinuteDropDown, 68)
	STYLE:ApplyDropdownStyle(CalendarCreateEventAMPMDropDown, 68)
	STYLE:ApplyDropdownStyle(CalendarCreateEventRepeatOptionDropDown, 120)
	CalendarCreateEventIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	hooksecurefunc(CalendarCreateEventIcon, "SetTexCoord", function(f, v, w, x, y)
		local z, A, B, C = 0.1, 0.9, 0.1, 0.9 
		if v ~= z or w ~= A or x ~= B or y ~= C then
			 f:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		end 
	end)
	CalendarCreateEventInviteListSection:RemoveTextures()
	CalendarClassButtonContainer:HookScript("OnShow", function()
		for u, D in ipairs(CLASS_SORT_ORDER)do 	
			local e = _G["CalendarClassButton"..u]e:RemoveTextures()
			e:SetPanelTemplate("Default")
			local E = CLASS_ICON_TCOORDS[D]
			local F = e:GetNormalTexture()
			F:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes")
			F:SetTexCoord(E[1]+0.015, E[2]-0.02, E[3]+0.018, E[4]-0.02)
		end 
		CalendarClassButton1:SetPoint("TOPLEFT", CalendarClassButtonContainer, "TOPLEFT", 5, 0)
		CalendarClassTotalsButton:RemoveTextures()
		CalendarClassTotalsButton:SetPanelTemplate("Default")
	end)
	CalendarTexturePickerFrame:RemoveTextures()
	CalendarTexturePickerTitleFrame:RemoveTextures()
	CalendarTexturePickerFrame:SetFixedPanelTemplate("Transparent", true)
	STYLE:ApplyScrollFrameStyle(CalendarTexturePickerScrollBar)
	CalendarTexturePickerAcceptButton:SetButtonTemplate()
	CalendarTexturePickerCancelButton:SetButtonTemplate()
	CalendarCreateEventInviteButton:SetButtonTemplate()
	CalendarCreateEventRaidInviteButton:SetButtonTemplate()
	CalendarMassInviteFrame:RemoveTextures()
	CalendarMassInviteFrame:SetFixedPanelTemplate("Transparent", true)
	CalendarMassInviteTitleFrame:RemoveTextures()
	STYLE:ApplyCloseButtonStyle(CalendarMassInviteCloseButton)
	CalendarMassInviteGuildAcceptButton:SetButtonTemplate()
	STYLE:ApplyDropdownStyle(CalendarMassInviteGuildRankMenu, 130)
	CalendarMassInviteGuildMinLevelEdit:SetEditboxTemplate()
	CalendarMassInviteGuildMaxLevelEdit:SetEditboxTemplate()
	CalendarViewRaidFrame:RemoveTextures()
	CalendarViewRaidFrame:SetFixedPanelTemplate("Transparent", true)
	CalendarViewRaidFrame:SetPoint("TOPLEFT", CalendarFrame, "TOPRIGHT", 3, -24)
	CalendarViewRaidTitleFrame:RemoveTextures()
	STYLE:ApplyCloseButtonStyle(CalendarViewRaidCloseButton)
	CalendarViewHolidayFrame:RemoveTextures(true)
	CalendarViewHolidayFrame:SetFixedPanelTemplate("Transparent", true)
	CalendarViewHolidayFrame:SetPoint("TOPLEFT", CalendarFrame, "TOPRIGHT", 3, -24)
	CalendarViewHolidayTitleFrame:RemoveTextures()
	STYLE:ApplyCloseButtonStyle(CalendarViewHolidayCloseButton)
	CalendarViewEventFrame:RemoveTextures()
	CalendarViewEventFrame:SetFixedPanelTemplate("Transparent", true)
	CalendarViewEventFrame:SetPoint("TOPLEFT", CalendarFrame, "TOPRIGHT", 3, -24)
	CalendarViewEventTitleFrame:RemoveTextures()
	CalendarViewEventDescriptionContainer:RemoveTextures()
	CalendarViewEventDescriptionContainer:SetFixedPanelTemplate("Transparent", true)
	CalendarViewEventInviteList:RemoveTextures()
	CalendarViewEventInviteList:SetFixedPanelTemplate("Transparent", true)
	CalendarViewEventInviteListSection:RemoveTextures()
	STYLE:ApplyCloseButtonStyle(CalendarViewEventCloseButton)
	STYLE:ApplyScrollFrameStyle(CalendarViewEventInviteListScrollFrameScrollBar)
	for _,btn in pairs(CalendarButtons)do
		 _G[btn]:SetButtonTemplate()
	end 
	CalendarEventPickerFrame:RemoveTextures()
	CalendarEventPickerTitleFrame:RemoveTextures()
	CalendarEventPickerFrame:SetFixedPanelTemplate("Transparent", true)
	STYLE:ApplyScrollFrameStyle(CalendarEventPickerScrollBar)
	CalendarEventPickerCloseButton:SetButtonTemplate()
	STYLE:ApplyScrollFrameStyle(CalendarCreateEventDescriptionScrollFrameScrollBar)
	STYLE:ApplyScrollFrameStyle(CalendarCreateEventInviteListScrollFrameScrollBar)
	STYLE:ApplyScrollFrameStyle(CalendarViewEventDescriptionScrollFrameScrollBar)
end 
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
STYLE:SaveBlizzardStyle("Blizzard_Calendar",CalendarStyle)