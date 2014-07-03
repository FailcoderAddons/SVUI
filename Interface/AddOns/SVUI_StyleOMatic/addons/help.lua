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
local HelpFrameList = {
	"HelpFrameLeftInset",
	"HelpFrameMainInset",
	"HelpFrameKnowledgebase",
	"HelpFrameHeader",
	"HelpFrameKnowledgebaseErrorFrame"
};
local HelpFrameButtonList = {
	"HelpFrameOpenTicketHelpItemRestoration",
	"HelpFrameAccountSecurityOpenTicket",
	"HelpFrameOpenTicketHelpTopIssues",
	"HelpFrameOpenTicketHelpOpenTicket",
	"HelpFrameKnowledgebaseSearchButton",
	"HelpFrameKnowledgebaseNavBarHomeButton",
	"HelpFrameCharacterStuckStuck",
	"GMChatOpenLog",
	"HelpFrameTicketSubmit",
	"HelpFrameTicketCancel"
};
local function NavBarHelper(button)
	for d = 1, #button.navList do 
		local i = button.navList[d]
		local j = button.navList[d-1]
		if i and j then
			i:SetFrameLevel(j:GetFrameLevel()-2)
		end 
	end 
end;
--[[ 
########################################################## 
HELPFRAME STYLER
##########################################################
]]--
local function HelpFrameStyle()
	if SuperVillain.db.SVStyle.blizzard.enable ~= true or SuperVillain.db.SVStyle.blizzard.help ~= true then
		return 
	end;
	if SuperVillain.build >= 15595 then
		tinsert(HelpFrameButtonList, "HelpFrameButton16")
		tinsert(HelpFrameButtonList, "HelpFrameSubmitSuggestionSubmit")
		tinsert(HelpFrameButtonList, "HelpFrameReportBugSubmit")
	end;
	for d = 1, #HelpFrameList do
		_G[HelpFrameList[d]]:Formula409(true)
		_G[HelpFrameList[d]]:SetPanelTemplate("Default")
	end;
	HelpFrameHeader:SetFrameLevel(HelpFrameHeader:GetFrameLevel()+2)
	HelpFrameKnowledgebaseErrorFrame:SetFrameLevel(HelpFrameKnowledgebaseErrorFrame:GetFrameLevel()+2)
	HelpFrameReportBugScrollFrame:Formula409()
	HelpFrameReportBugScrollFrame:SetPanelTemplate("Default")
	HelpFrameReportBugScrollFrame.Panel:Point("TOPLEFT", -4, 4)
	HelpFrameReportBugScrollFrame.Panel:Point("BOTTOMRIGHT", 6, -4)
	for d = 1, HelpFrameReportBug:GetNumChildren()do 
		local e = select(d, HelpFrameReportBug:GetChildren())
		if not e:GetName() then
			e:Formula409()
		end 
	end;
	MOD:ApplyScrollStyle(HelpFrameReportBugScrollFrameScrollBar)
	HelpFrameSubmitSuggestionScrollFrame:Formula409()
	HelpFrameSubmitSuggestionScrollFrame:SetPanelTemplate("Default")
	HelpFrameSubmitSuggestionScrollFrame.Panel:Point("TOPLEFT", -4, 4)
	HelpFrameSubmitSuggestionScrollFrame.Panel:Point("BOTTOMRIGHT", 6, -4)
	for d = 1, HelpFrameSubmitSuggestion:GetNumChildren()do 
		local e = select(d, HelpFrameSubmitSuggestion:GetChildren())
		if not e:GetName() then
			e:Formula409()
		end 
	end;
	MOD:ApplyScrollStyle(HelpFrameSubmitSuggestionScrollFrameScrollBar)
	HelpFrameTicketScrollFrame:Formula409()
	HelpFrameTicketScrollFrame:SetPanelTemplate("Default")
	HelpFrameTicketScrollFrame.Panel:Point("TOPLEFT", -4, 4)
	HelpFrameTicketScrollFrame.Panel:Point("BOTTOMRIGHT", 6, -4)
	for d = 1, HelpFrameTicket:GetNumChildren()do 
		local e = select(d, HelpFrameTicket:GetChildren())
		if not e:GetName() then
			e:Formula409()
		end 
	end;
	MOD:ApplyScrollStyle(HelpFrameKnowledgebaseScrollFrame2ScrollBar)
	for d = 1, #HelpFrameButtonList do
		_G[HelpFrameButtonList[d]]:Formula409(true)
		_G[HelpFrameButtonList[d]]:SetButtonTemplate()
		if _G[HelpFrameButtonList[d]].text then
			_G[HelpFrameButtonList[d]].text:ClearAllPoints()
			_G[HelpFrameButtonList[d]].text:SetPoint("CENTER")
			_G[HelpFrameButtonList[d]].text:SetJustifyH("CENTER")
		end 
	end;
	for d = 1, 6 do 
		local f = _G["HelpFrameButton"..d]
		f:SetButtonTemplate()
		f.text:ClearAllPoints()
		f.text:SetPoint("CENTER")
		f.text:SetJustifyH("CENTER")
	end;
	for d = 1, HelpFrameKnowledgebaseScrollFrameScrollChild:GetNumChildren()do 
		local f = _G["HelpFrameKnowledgebaseScrollFrameButton"..d]
		f:Formula409(true)
		f:SetButtonTemplate()
	end;
	HelpFrameKnowledgebaseSearchBox:ClearAllPoints()
	HelpFrameKnowledgebaseSearchBox:Point("TOPLEFT", HelpFrameMainInset, "TOPLEFT", 13, -10)
	HelpFrameKnowledgebaseNavBarOverlay:MUNG()
	HelpFrameKnowledgebaseNavBar:Formula409()
	HelpFrame:Formula409(true)
	HelpFrame:SetPanelTemplate("Halftone")
	HelpFrameKnowledgebaseSearchBox:SetEditboxTemplate()
	MOD:ApplyScrollStyle(HelpFrameKnowledgebaseScrollFrameScrollBar, 5)
	MOD:ApplyScrollStyle(HelpFrameTicketScrollFrameScrollBar, 4)
	MOD:ApplyCloseButtonStyle(HelpFrameCloseButton, HelpFrame.Panel)
	MOD:ApplyCloseButtonStyle(HelpFrameKnowledgebaseErrorFrameCloseButton, HelpFrameKnowledgebaseErrorFrame.Panel)
	HelpFrameCharacterStuckHearthstone:SetButtonTemplate()
	HelpFrameCharacterStuckHearthstone:SetFixedPanelTemplate("Default")
	HelpFrameCharacterStuckHearthstone.IconTexture:FillInner()
	HelpFrameCharacterStuckHearthstone.IconTexture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	hooksecurefunc("NavBar_AddButton", function(h, k)
		local i = h.navList[#h.navList]
		if not i.styled then
			i:SetButtonTemplate()
			i.styled = true;
			i:HookScript("OnClick", function()
				NavBarHelper(h)
			end)
		end;
		NavBarHelper(h)
	end)
	HelpFrameGM_ResponseNeedMoreHelp:SetButtonTemplate()
	HelpFrameGM_ResponseCancel:SetButtonTemplate()
	for d = 1, HelpFrameGM_Response:GetNumChildren()do 
		local e = select(d, HelpFrameGM_Response:GetChildren())
		if e and e:GetObjectType()
		 == "Frame"and not e:GetName()
		then
			e:SetFixedPanelTemplate("Default")
		end 
	end 
end;
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
MOD:SaveCustomStyle(HelpFrameStyle)