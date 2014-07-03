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
local SuperVillain, L = unpack(SVUI);
local MOD = SuperVillain.Registry:Expose("SVStyle");
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
	if SuperVillain.db.SVStyle.blizzard.enable ~= true or SuperVillain.db.SVStyle.blizzard.calendar ~= true then
		 return 
	end;
	_G["CalendarFrame"]:Formula409()
	CalendarFrame:SetPanelTemplate("Halftone")
	MOD:ApplyCloseButtonStyle(CalendarCloseButton)
	CalendarCloseButton:Point("TOPRIGHT", CalendarFrame, "TOPRIGHT", -4, -4)
	MOD:ApplyPaginationStyle(CalendarPrevMonthButton)
	MOD:ApplyPaginationStyle(CalendarNextMonthButton)
	do 
		local d = CalendarFilterFrame;
		local e = CalendarFilterButton;
		d:Formula409()
		d:Width(155)
		_G[d:GetName().."Text"]:ClearAllPoints()
		_G[d:GetName().."Text"]:Point("RIGHT", e, "LEFT", -2, 0)
		e:ClearAllPoints()
		e:Point("RIGHT", d, "RIGHT", -10, 3)
		hooksecurefunc(e, "SetPoint", function(f, g, h, i, j, k)
			if g ~= "RIGHT"or h ~= d or i ~= "RIGHT"or j ~= -10 or k ~= 3 then
				 f:ClearAllPoints()
				 f:Point("RIGHT", d, "RIGHT", -10, 3)
			end 
		end)
		MOD:ApplyPaginationStyle(e, true)
		d:SetPanelTemplate("Default")
		d.Panel:Point("TOPLEFT", 20, 2)
		d.Panel:Point("BOTTOMRIGHT", e, "BOTTOMRIGHT", 2, -2)
	end;
	local l = CreateFrame("Frame", "CalendarFrameBackdrop", CalendarFrame)
	l:SetFixedPanelTemplate("Default")
	l:Point("TOPLEFT", 10, -72)
	l:Point("BOTTOMRIGHT", -8, 3)
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
	end;
	CalendarCreateEventFrame:Formula409()
	CalendarCreateEventFrame:SetFixedPanelTemplate("Transparent", true)
	CalendarCreateEventFrame:Point("TOPLEFT", CalendarFrame, "TOPRIGHT", 3, -24)
	CalendarCreateEventTitleFrame:Formula409()
	CalendarCreateEventCreateButton:SetButtonTemplate()
	CalendarCreateEventMassInviteButton:SetButtonTemplate()
	CalendarCreateEventInviteButton:SetButtonTemplate()
	CalendarCreateEventInviteButton:Point("TOPLEFT", CalendarCreateEventInviteEdit, "TOPRIGHT", 4, 1)
	CalendarCreateEventInviteEdit:Width(CalendarCreateEventInviteEdit:GetWidth()-2)
	CalendarCreateEventInviteList:Formula409()
	CalendarCreateEventInviteList:SetFixedPanelTemplate("Default")
	CalendarCreateEventInviteEdit:SetEditboxTemplate()
	CalendarCreateEventTitleEdit:SetEditboxTemplate()
	MOD:ApplyDropdownStyle(CalendarCreateEventTypeDropDown, 120)
	CalendarCreateEventDescriptionContainer:Formula409()
	CalendarCreateEventDescriptionContainer:SetFixedPanelTemplate("Default")
	MOD:ApplyCloseButtonStyle(CalendarCreateEventCloseButton)
	CalendarCreateEventLockEventCheck:SetCheckboxTemplate(true)
	MOD:ApplyDropdownStyle(CalendarCreateEventHourDropDown, 68)
	MOD:ApplyDropdownStyle(CalendarCreateEventMinuteDropDown, 68)
	MOD:ApplyDropdownStyle(CalendarCreateEventAMPMDropDown, 68)
	MOD:ApplyDropdownStyle(CalendarCreateEventRepeatOptionDropDown, 120)
	CalendarCreateEventIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	hooksecurefunc(CalendarCreateEventIcon, "SetTexCoord", function(f, v, w, x, y)
		local z, A, B, C = 0.1, 0.9, 0.1, 0.9 
		if v ~= z or w ~= A or x ~= B or y ~= C then
			 f:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		end 
	end)
	CalendarCreateEventInviteListSection:Formula409()
	CalendarClassButtonContainer:HookScript("OnShow", function()
		for u, D in ipairs(CLASS_SORT_ORDER)do 	
			local e = _G["CalendarClassButton"..u]e:Formula409()
			e:SetPanelTemplate("Default")
			local E = CLASS_ICON_TCOORDS[D]
			local F = e:GetNormalTexture()
			F:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes")
			F:SetTexCoord(E[1]+0.015, E[2]-0.02, E[3]+0.018, E[4]-0.02)
		end;
		CalendarClassButton1:Point("TOPLEFT", CalendarClassButtonContainer, "TOPLEFT", 5, 0)
		CalendarClassTotalsButton:Formula409()
		CalendarClassTotalsButton:SetPanelTemplate("Default")
	end)
	CalendarTexturePickerFrame:Formula409()
	CalendarTexturePickerTitleFrame:Formula409()
	CalendarTexturePickerFrame:SetFixedPanelTemplate("Transparent", true)
	MOD:ApplyScrollStyle(CalendarTexturePickerScrollBar)
	CalendarTexturePickerAcceptButton:SetButtonTemplate()
	CalendarTexturePickerCancelButton:SetButtonTemplate()
	CalendarCreateEventInviteButton:SetButtonTemplate()
	CalendarCreateEventRaidInviteButton:SetButtonTemplate()
	CalendarMassInviteFrame:Formula409()
	CalendarMassInviteFrame:SetFixedPanelTemplate("Transparent", true)
	CalendarMassInviteTitleFrame:Formula409()
	MOD:ApplyCloseButtonStyle(CalendarMassInviteCloseButton)
	CalendarMassInviteGuildAcceptButton:SetButtonTemplate()
	MOD:ApplyDropdownStyle(CalendarMassInviteGuildRankMenu, 130)
	CalendarMassInviteGuildMinLevelEdit:SetEditboxTemplate()
	CalendarMassInviteGuildMaxLevelEdit:SetEditboxTemplate()
	CalendarViewRaidFrame:Formula409()
	CalendarViewRaidFrame:SetFixedPanelTemplate("Transparent", true)
	CalendarViewRaidFrame:Point("TOPLEFT", CalendarFrame, "TOPRIGHT", 3, -24)
	CalendarViewRaidTitleFrame:Formula409()
	MOD:ApplyCloseButtonStyle(CalendarViewRaidCloseButton)
	CalendarViewHolidayFrame:Formula409(true)
	CalendarViewHolidayFrame:SetFixedPanelTemplate("Transparent", true)
	CalendarViewHolidayFrame:Point("TOPLEFT", CalendarFrame, "TOPRIGHT", 3, -24)
	CalendarViewHolidayTitleFrame:Formula409()
	MOD:ApplyCloseButtonStyle(CalendarViewHolidayCloseButton)
	CalendarViewEventFrame:Formula409()
	CalendarViewEventFrame:SetFixedPanelTemplate("Transparent", true)
	CalendarViewEventFrame:Point("TOPLEFT", CalendarFrame, "TOPRIGHT", 3, -24)
	CalendarViewEventTitleFrame:Formula409()
	CalendarViewEventDescriptionContainer:Formula409()
	CalendarViewEventDescriptionContainer:SetFixedPanelTemplate("Transparent", true)
	CalendarViewEventInviteList:Formula409()
	CalendarViewEventInviteList:SetFixedPanelTemplate("Transparent", true)
	CalendarViewEventInviteListSection:Formula409()
	MOD:ApplyCloseButtonStyle(CalendarViewEventCloseButton)
	MOD:ApplyScrollStyle(CalendarViewEventInviteListScrollFrameScrollBar)
	for _,btn in pairs(CalendarButtons)do
		 _G[btn]:SetButtonTemplate()
	end;
	CalendarEventPickerFrame:Formula409()
	CalendarEventPickerTitleFrame:Formula409()
	CalendarEventPickerFrame:SetFixedPanelTemplate("Transparent", true)
	MOD:ApplyScrollStyle(CalendarEventPickerScrollBar)
	CalendarEventPickerCloseButton:SetButtonTemplate()
	MOD:ApplyScrollStyle(CalendarCreateEventDescriptionScrollFrameScrollBar)
	MOD:ApplyScrollStyle(CalendarCreateEventInviteListScrollFrameScrollBar)
	MOD:ApplyScrollStyle(CalendarViewEventDescriptionScrollFrameScrollBar)
end;
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
MOD:SaveBlizzardStyle("Blizzard_Calendar",CalendarStyle)