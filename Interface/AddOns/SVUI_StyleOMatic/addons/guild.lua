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
local L = LibStub("LibSuperVillain-1.0"):Lang();
local STYLE = _G.StyleVillain;
--[[ 
########################################################## 
HELPERS
##########################################################
]]--
local format = string.format;
local internalTest = false;

local GuildFrameList = {	
	"GuildNewPerksFrame",
	"GuildFrameInset",
	"GuildFrameBottomInset",
	"GuildAllPerksFrame",
	"GuildMemberDetailFrame",
	"GuildMemberNoteBackground",
	"GuildInfoFrameInfo",
	"GuildLogContainer",
	"GuildLogFrame",
	"GuildRewardsFrame",
	"GuildMemberOfficerNoteBackground",
	"GuildTextEditContainer",
	"GuildTextEditFrame",
	"GuildRecruitmentRolesFrame",
	"GuildRecruitmentAvailabilityFrame",
	"GuildRecruitmentInterestFrame",
	"GuildRecruitmentLevelFrame",
	"GuildRecruitmentCommentFrame",
	"GuildRecruitmentCommentInputFrame",
	"GuildInfoFrameApplicantsContainer",
	"GuildInfoFrameApplicants",
	"GuildNewsBossModel",
	"GuildNewsBossModelTextFrame"
};

local GuildButtonList = {
	"GuildPerksToggleButton",
	"GuildMemberRemoveButton",
	"GuildMemberGroupInviteButton",
	"GuildAddMemberButton",
	"GuildViewLogButton",
	"GuildControlButton",
	"GuildRecruitmentListGuildButton",
	"GuildTextEditFrameAcceptButton",
	"GuildRecruitmentInviteButton",
	"GuildRecruitmentMessageButton",
	"GuildRecruitmentDeclineButton"
};

local GuildCheckBoxList = {
	"GuildRecruitmentQuestButton",
	"GuildRecruitmentDungeonButton",
	"GuildRecruitmentRaidButton",
	"GuildRecruitmentPvPButton",
	"GuildRecruitmentRPButton",
	"GuildRecruitmentWeekdaysButton",
	"GuildRecruitmentWeekendsButton",
	"GuildRecruitmentLevelAnyButton",
	"GuildRecruitmentLevelMaxButton"
};

local CalendarIconList = {
	[CALENDAR_EVENTTYPE_PVP] = "Interface\\Calendar\\UI-Calendar-Event-PVP",
	[CALENDAR_EVENTTYPE_MEETING] = "Interface\\Calendar\\MeetingIcon",
	[CALENDAR_EVENTTYPE_OTHER] = "Interface\\Calendar\\UI-Calendar-Event-Other"
};

local LFGFrameList = {  
  "LookingForGuildPvPButton",
  "LookingForGuildWeekendsButton",
  "LookingForGuildWeekdaysButton",
  "LookingForGuildRPButton",
  "LookingForGuildRaidButton",
  "LookingForGuildQuestButton",
  "LookingForGuildDungeonButton"
};

local function GCTabHelper(tab)
	tab.Panel:Hide()
	tab.bg1 = tab:CreateTexture(nil,"BACKGROUND")
	tab.bg1:SetDrawLayer("BACKGROUND",4)
	tab.bg1:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
	tab.bg1:SetVertexColor(unpack(SV.Media.color.default))
	tab.bg1:FillInner(tab.Panel,1)
	tab.bg3 = tab:CreateTexture(nil,"BACKGROUND")
	tab.bg3:SetDrawLayer("BACKGROUND",2)
	tab.bg3:SetTexture(0,0,0,1)
	tab.bg3:SetAllPoints(tab.Panel) 
end 

local RankOrder_OnUpdate = function()
	for b=1,GuildControlGetNumRanks()do 
		local frame = _G["GuildControlUIRankOrderFrameRank"..b]
		if frame then 
			frame.downButton:SetButtonTemplate()
			frame.upButton:SetButtonTemplate()
			frame.deleteButton:SetButtonTemplate()
			if not frame.nameBox.Panel then 
				frame.nameBox:SetEditboxTemplate()
			end 
			frame.nameBox.Panel:Point("TOPLEFT",-2,-4)
			frame.nameBox.Panel:Point("BOTTOMRIGHT",-4,4)
		end 
	end 
end 

function GuildInfoEvents_SetButton(button, eventIndex)
	local dateData = date("*t")
	local month, day, weekday, hour, minute, eventType, title, calendarType, textureName = CalendarGetGuildEventInfo(eventIndex)
	local formattedTime = GameTime_GetFormattedTime(hour, minute, true)
	local unformattedText;
	if dateData["day"] == day and dateData["month"] == month then
		unformattedText = NORMAL_FONT_COLOR_CODE..GUILD_EVENT_TODAY..FONT_COLOR_CODE_CLOSE 
	else
		local year = dateData["year"]
		if month < dateData["month"] then
			year = year + 1 
		end 
		local newTime = time{year = year, month = month, day = day}
		if(((newTime - time()) < 518400) and CALENDAR_WEEKDAY_NAMES[weekday]) then
			unformattedText = CALENDAR_WEEKDAY_NAMES[weekday]
		elseif CALENDAR_WEEKDAY_NAMES[weekday]and day and month then 
			unformattedText = format(GUILD_NEWS_DATE, CALENDAR_WEEKDAY_NAMES[weekday], day, month)
		end 
	end 
	if button.text and unformattedText then
		button.text:SetFormattedText(GUILD_EVENT_FORMAT, unformattedText, formattedTime, title)
	end 
	button.index = eventIndex;
	if button.icon.type ~= "event" then
		button.icon.type = "event"
		button.icon:SetTexCoord(0, 1, 0, 1)
		button.icon:SetWidth(14)
		button.icon:SetHeight(14)
	end 
	if CalendarIconList[eventType] then
		button.icon:SetTexture(CalendarIconList[eventType])
	else
		button.icon:SetTexture("Interface\\LFGFrame\\LFGIcon-"..textureName)
	end 
end
--[[ 
########################################################## 
GUILDFRAME STYLERS
##########################################################
]]--
local function GuildBankStyle()
	if SV.db.SVStyle.blizzard.enable ~= true or SV.db.SVStyle.blizzard.gbank ~= true then
		return 
	end

	STYLE:ApplyWindowStyle(GuildBankFrame)

	GuildBankEmblemFrame:RemoveTextures(true)
	GuildBankMoneyFrameBackground:Die()
	STYLE:ApplyScrollFrameStyle(GuildBankPopupScrollFrameScrollBar)

	for b = 1, GuildBankFrame:GetNumChildren() do 
		local c = select(b, GuildBankFrame:GetChildren())
		if c.GetPushedTexture and c:GetPushedTexture() and not c:GetName() then
			STYLE:ApplyCloseButtonStyle(c)
		end 
	end

	GuildBankFrameDepositButton:SetButtonTemplate()
	GuildBankFrameWithdrawButton:SetButtonTemplate()
	GuildBankInfoSaveButton:SetButtonTemplate()
	GuildBankFramePurchaseButton:SetButtonTemplate()
	GuildBankFrameWithdrawButton:Point("RIGHT", GuildBankFrameDepositButton, "LEFT", -2, 0)
	GuildBankInfoScrollFrame:Point('TOPLEFT', GuildBankInfo, 'TOPLEFT', -10, 12)
	GuildBankInfoScrollFrame:RemoveTextures()
	GuildBankInfoScrollFrame:Width(GuildBankInfoScrollFrame:GetWidth()-8)
	GuildBankTransactionsScrollFrame:RemoveTextures()
	
	for b = 1, NUM_GUILDBANK_COLUMNS do
		if(_G["GuildBankColumn"..b]) then
			_G["GuildBankColumn"..b]:RemoveTextures()

			for d = 1, NUM_SLOTS_PER_GUILDBANK_GROUP do 
				local e = _G["GuildBankColumn"..b.."Button"..d]
				local icon = _G["GuildBankColumn"..b.."Button"..d.."IconTexture"]
				local texture = _G["GuildBankColumn"..b.."Button"..d.."NormalTexture"]
				if texture then
					texture:SetTexture(0,0,0,0)
				end 
				e:SetSlotTemplate()
				icon:FillInner()
				icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			end
		end
	end 

	for b = 1, 8 do 
		local e = _G["GuildBankTab"..b.."Button"]
		if(e) then
			local texture = _G["GuildBankTab"..b.."ButtonIconTexture"]
			_G["GuildBankTab"..b]:RemoveTextures(true)
			e:RemoveTextures()
			e:SetButtonTemplate()
			e:SetFixedPanelTemplate("Default")
			texture:FillInner()
			texture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		end
	end 

	for b = 1, 4 do
		STYLE:ApplyTabStyle(_G["GuildBankFrameTab"..b])
	end 

	hooksecurefunc('GuildBankFrame_Update', function()
		if GuildBankFrame.mode ~= "bank" then
			return 
		end 
		local f = GetCurrentGuildBankTab()
		local e, g, h, i, j, k, l, m;
		for b = 1, MAX_GUILDBANK_SLOTS_PER_TAB do
			g = mod(b, NUM_SLOTS_PER_GUILDBANK_GROUP)
			if g == 0 then
				g = NUM_SLOTS_PER_GUILDBANK_GROUP 
			end 
			h = ceil((b-0.5)/NUM_SLOTS_PER_GUILDBANK_GROUP)
			e = _G["GuildBankColumn"..h.."Button"..g]
			i = GetGuildBankItemLink(f, b)
			if i then
				j = select(3, GetItemInfo(i))
				if j > 1 then
					k, l, m = GetItemQualityColor(j)
				else
					k, l, m = 0,0,0,1
				end 
			else
				k, l, m = 0,0,0,1
			end 
			e:SetBackdropBorderColor(k, l, m)
		end 
	end)

	GuildBankPopupFrame:RemoveTextures()
	GuildBankPopupScrollFrame:RemoveTextures()
	GuildBankPopupFrame:SetFixedPanelTemplate("Transparent", true)
	GuildBankPopupFrame:Point("TOPLEFT", GuildBankFrame, "TOPRIGHT", 1, -30)
	GuildBankPopupOkayButton:SetButtonTemplate()
	GuildBankPopupCancelButton:SetButtonTemplate()
	GuildBankPopupEditBox:SetEditboxTemplate()
	GuildBankPopupNameLeft:Die()
	GuildBankPopupNameRight:Die()
	GuildBankPopupNameMiddle:Die()
	GuildItemSearchBox:RemoveTextures()
	GuildItemSearchBox:SetPanelTemplate("Overlay")
	GuildItemSearchBox.Panel:Point("TOPLEFT", 10, -1)
	GuildItemSearchBox.Panel:Point("BOTTOMRIGHT", 4, 1)

	for b = 1, 16 do 
		local e = _G["GuildBankPopupButton"..b]
		if(e) then
			local icon = _G[e:GetName().."Icon"]
			e:RemoveTextures()
			e:SetFixedPanelTemplate("Default")
			e:SetButtonTemplate()
			icon:FillInner()
			icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		end
	end 

	STYLE:ApplyScrollFrameStyle(GuildBankTransactionsScrollFrameScrollBar)
	STYLE:ApplyScrollFrameStyle(GuildBankInfoScrollFrameScrollBar)
end 

local function GuildFrameStyle()
	if SV.db.SVStyle.blizzard.enable ~= true or SV.db.SVStyle.blizzard.guild ~= true then
		return 
	end
	
	STYLE:ApplyWindowStyle(GuildFrame)

	STYLE:ApplyCloseButtonStyle(GuildMemberDetailCloseButton)
	STYLE:ApplyCloseButtonStyle(GuildFrameCloseButton)
	GuildRewardsFrameVisitText:ClearAllPoints()
	GuildRewardsFrameVisitText:SetPoint("TOP", GuildRewardsFrame, "TOP", 0, 30)

	for i = 1, #GuildFrameList do
		local frame = _G[GuildFrameList[i]]
		if(frame) then
			frame:RemoveTextures()
		end
	end

	for i = 1, #GuildButtonList do
		local button = _G[GuildButtonList[i]]
		if(button) then
			button:RemoveTextures(true)
			button:SetButtonTemplate()
		end
	end 

	for i = 1, #GuildCheckBoxList do
		local check = _G[GuildCheckBoxList[i]]
		if(check) then check:SetCheckboxTemplate(true) end
	end 

	for i = 1, 5 do
		local tab = _G["GuildFrameTab"..i]
		if(tab) then
			STYLE:ApplyTabStyle(tab)
			if i == 1 then
				tab:Point("TOPLEFT", GuildFrame, "BOTTOMLEFT", -10, 3)
			end
		end
	end

	GuildNewsBossModel:SetBasicPanel()
	GuildNewsBossModelTextFrame:SetPanelTemplate("Default")
	GuildNewsBossModelTextFrame.Panel:Point("TOPLEFT", GuildNewsBossModel.Panel, "BOTTOMLEFT", 0, -1)
	GuildNewsBossModel:SetPoint("TOPLEFT", GuildFrame, "TOPRIGHT", 4, -43)

	GuildRecruitmentTankButton.checkButton:SetCheckboxTemplate(true)
	GuildRecruitmentHealerButton.checkButton:SetCheckboxTemplate(true)
	GuildRecruitmentDamagerButton.checkButton:SetCheckboxTemplate(true)

	GuildFactionBar:RemoveTextures()
	GuildFactionBar.progress:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
	GuildFactionBar:SetPanelTemplate("Inset")
	GuildFactionBar.Panel:Point("TOPLEFT", GuildFactionBar.progress, "TOPLEFT", -1, 1)
	GuildFactionBar.Panel:Point("BOTTOMRIGHT", GuildFactionBar, "BOTTOMRIGHT", 1, 1)

	if(SV.GameVersion < 60000) then
		GuildLevelFrame:Die()
		
		GuildXPFrame:ClearAllPoints()
		GuildXPFrame:Point("TOP", GuildFrame, "TOP", 0, -40)

		GuildXPBar:RemoveTextures()
		GuildXPBar.progress:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
		GuildXPBar:SetPanelTemplate("Inset")
		GuildXPBar.Panel:Point("TOPLEFT", GuildXPBar, "TOPLEFT", -1, -3)
		GuildXPBar.Panel:Point("BOTTOMRIGHT", GuildXPBar, "BOTTOMRIGHT", 0, 1)
	end

	GuildLatestPerkButton:RemoveTextures()
	GuildLatestPerkButtonIconTexture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	GuildLatestPerkButtonIconTexture:ClearAllPoints()
	GuildLatestPerkButtonIconTexture:Point("TOPLEFT", 2, -2)
	GuildLatestPerkButton:SetPanelTemplate("Inset")
	GuildLatestPerkButton.Panel:WrapOuter(GuildLatestPerkButtonIconTexture)

	GuildNextPerkButton:RemoveTextures()
	GuildNextPerkButtonIconTexture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	GuildNextPerkButtonIconTexture:ClearAllPoints()
	GuildNextPerkButtonIconTexture:Point("TOPLEFT", 2, -2)
	GuildNextPerkButton:SetPanelTemplate("Inset")
	GuildNextPerkButton.Panel:WrapOuter(GuildNextPerkButtonIconTexture)
	
	GuildRosterContainer:SetBasicPanel(-2, 2, -1, -2)
	STYLE:ApplyScrollFrameStyle(GuildRosterContainerScrollBar, 4, -4)
	GuildRosterShowOfflineButton:SetCheckboxTemplate(true)

	for i = 1, 4 do
		local btn = _G["GuildRosterColumnButton"..i]
		if(btn) then
			btn:RemoveTextures(true)
		end
	end 

	STYLE:ApplyDropdownStyle(GuildRosterViewDropdown, 200)

	for i = 1, 14 do
		local btn = _G["GuildRosterContainerButton"..i.."HeaderButton"]
		if(btn) then
			btn:RemoveTextures()
			btn:SetButtonTemplate()
		end
	end

	GuildMemberDetailFrame:SetPanelTemplate("Default", true)
	GuildMemberNoteBackground:SetBasicPanel()
	GuildMemberOfficerNoteBackground:SetBasicPanel()

	GuildMemberRankDropdown:SetFrameLevel(GuildMemberRankDropdown:GetFrameLevel()+5)
	STYLE:ApplyDropdownStyle(GuildMemberRankDropdown, 182)
	GuildMemberRankDropdown.Panel:SetBackdropColor(0,0,0,1)
	GuildNewsFrame:RemoveTextures()
	GuildNewsContainer:SetBasicPanel(-2, 2, 0, -2)

	for i = 1, 17 do
		local btn = _G["GuildNewsContainerButton"..i]
		if(btn) then
			if(btn.header) then btn.header:Die() end
			btn:RemoveTextures()
			btn:SetButtonTemplate()
		end 
	end 

	GuildNewsFiltersFrame:RemoveTextures()
	GuildNewsFiltersFrame:SetFixedPanelTemplate("Transparent", true)
	STYLE:ApplyCloseButtonStyle(GuildNewsFiltersFrameCloseButton)

	for i = 1, 7 do
		local btn = _G["GuildNewsFilterButton"..i]
		if(btn) then
			btn:SetCheckboxTemplate(true)
		end
	end 

	GuildNewsFiltersFrame:Point("TOPLEFT", GuildFrame, "TOPRIGHT", 4, -20)
	STYLE:ApplyScrollFrameStyle(GuildNewsContainerScrollBar, 4, 4)
	STYLE:ApplyScrollFrameStyle(GuildInfoDetailsFrameScrollBar, 4, 4)

	for i = 1, 3 do
		local tab = _G["GuildInfoFrameTab"..i]
		if(tab) then
			tab:RemoveTextures()
		end
	end

	local panel1 = CreateFrame("Frame", nil, GuildInfoFrameInfo)
	panel1:SetPoint("TOPLEFT", GuildInfoFrameInfo, "TOPLEFT", 2, -22)
	panel1:SetPoint("BOTTOMRIGHT", GuildInfoFrameInfo, "BOTTOMRIGHT", 0, 200)
	panel1:SetBasicPanel()

	local panel2 = CreateFrame("Frame", nil, GuildInfoFrameInfo)
	panel2:SetPoint("TOPLEFT", GuildInfoFrameInfo, "TOPLEFT", 2, -158)
	panel2:SetPoint("BOTTOMRIGHT", GuildInfoFrameInfo, "BOTTOMRIGHT", 0, 118)
	panel2:SetBasicPanel()

	local panel3 = CreateFrame("Frame", nil, GuildInfoFrameInfo)
	panel3:SetPoint("TOPLEFT", GuildInfoFrameInfo, "TOPLEFT", 2, -233)
	panel3:SetPoint("BOTTOMRIGHT", GuildInfoFrameInfo, "BOTTOMRIGHT", 0, 3)
	panel3:SetBasicPanel()

	GuildRecruitmentCommentInputFrame:SetFixedPanelTemplate("Default")
	GuildTextEditFrame:SetFixedPanelTemplate("Transparent", true)
	STYLE:ApplyScrollFrameStyle(GuildTextEditScrollFrameScrollBar, 4, 4)
	GuildTextEditContainer:SetFixedPanelTemplate("Default")

	local editChildren = GuildTextEditFrame:GetNumChildren()

	for i = 1, editChildren do 
		local child = select(i, GuildTextEditFrame:GetChildren())
		if(child:GetName() == "GuildTextEditFrameCloseButton") then
			if(child:GetWidth() < 33) then
				STYLE:ApplyCloseButtonStyle(child)
			else
				child:SetButtonTemplate()
			end
		end 
	end

	STYLE:ApplyScrollFrameStyle(GuildLogScrollFrameScrollBar, 4, 4)
	GuildLogFrame:SetBasicPanel()

	local logChildren = GuildLogFrame:GetNumChildren()

	for i = 1, logChildren do 
		local child = select(i, GuildLogFrame:GetChildren())
		if child:GetName() == "GuildLogFrameCloseButton" then 
			if(child:GetWidth() < 33) then
				STYLE:ApplyCloseButtonStyle(child)
			else
				child:SetButtonTemplate()
			end
		end 
	end 

	GuildRewardsFrame:SetBasicPanel(2, 0, -22, 18)
	STYLE:ApplyScrollFrameStyle(GuildRewardsContainerScrollBar, 4, -4)

	GuildNewPerksFrame:SetBasicPanel(-1, 0, 1, 0)
	GuildPerksContainer:SetBasicPanel(-3, 0, 26, -3)

	STYLE:ApplyScrollFrameStyle(GuildPerksContainerScrollBar, 4, 2)

	for i = 1, 8 do 
		local button = _G["GuildPerksContainerButton"..i]
		if button then
			button:RemoveTextures()
			if button.icon then
				STYLE:ApplyItemButtonStyle(button, nil, true)
				button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				button.icon:ClearAllPoints()
				button.icon:Point("TOPLEFT", button, "TOPLEFT", 2, -2)
				button.icon:SetParent(button.Panel)
			end
		end
	end 

	for i = 1, 8 do 
		local button = _G["GuildRewardsContainerButton"..i]
		if button then
			button:RemoveTextures()
			if button.icon then
				button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				button.icon:ClearAllPoints()
				button.icon:Point("TOPLEFT", button, "TOPLEFT", 2, -2)
				button:SetFixedPanelTemplate("Button")
				button.Panel:WrapOuter(button.icon)
				button.icon:SetParent(button.Panel)
			end
		end
	end 

	local maxCalendarEvents = CalendarGetNumGuildEvents();
	local scrollFrame = GuildInfoFrameApplicantsContainer;
  	local offset = HybridScrollFrame_GetOffset(scrollFrame);
  	local buttonIndex,counter = 0,0;

	for _,button in next, GuildInfoFrameApplicantsContainer.buttons do
		counter = counter + 1;
		buttonIndex = offset + counter;
		button.selectedTex:Die()
		button:GetHighlightTexture():Die()
		button:SetBackdrop(nil)
	end 
end 

local function GuildControlStyle()
	if SV.db.SVStyle.blizzard.enable~=true or SV.db.SVStyle.blizzard.guildcontrol~=true then return end

	GuildControlUI:RemoveTextures()
	GuildControlUIHbar:RemoveTextures()
	GuildControlUIRankBankFrameInset:RemoveTextures()
	GuildControlUIRankBankFrameInsetScrollFrame:RemoveTextures()

	STYLE:ApplyWindowStyle(GuildControlUI)

	STYLE:ApplyScrollFrameStyle(GuildControlUIRankBankFrameInsetScrollFrameScrollBar)

	hooksecurefunc("GuildControlUI_RankOrder_Update",RankOrder_OnUpdate)

	GuildControlUIRankOrderFrameNewButton:HookScript("OnClick", function()
		SV.Timers:ExecuteTimer(1,RankOrder_OnUpdate)
	end)

	STYLE:ApplyDropdownStyle(GuildControlUINavigationDropDown)
	STYLE:ApplyDropdownStyle(GuildControlUIRankSettingsFrameRankDropDown,180)
	GuildControlUINavigationDropDownButton:Width(20)
	GuildControlUIRankSettingsFrameRankDropDownButton:Width(20)

	for i=1, NUM_RANK_FLAGS do
		local check = _G["GuildControlUIRankSettingsFrameCheckbox"..i]
		if(check) then check:SetCheckboxTemplate(true) end 
	end

	GuildControlUIRankOrderFrameNewButton:SetButtonTemplate()
	GuildControlUIRankSettingsFrameGoldBox:SetEditboxTemplate()
	GuildControlUIRankSettingsFrameGoldBox.Panel:Point("TOPLEFT",-2,-4)
	GuildControlUIRankSettingsFrameGoldBox.Panel:Point("BOTTOMRIGHT",2,4)
	GuildControlUIRankSettingsFrameGoldBox:RemoveTextures()
	GuildControlUIRankBankFrame:RemoveTextures()

	hooksecurefunc("GuildControlUI_BankTabPermissions_Update",function()
		local tabs = GetNumGuildBankTabs()

		if tabs < MAX_BUY_GUILDBANK_TABS then 
			tabs = tabs + 1 
		end

		for i=1, tabs do 
			local tab = _G["GuildControlBankTab"..i.."Owned"]

			if(tab) then
				if(tab.tabIcon) then tab.tabIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9) end
				if(tab.editBox) then tab.editBox:SetEditboxTemplate() end

				if internalTest == false then 
					_G["GuildControlBankTab"..i.."BuyPurchaseButton"]:SetButtonTemplate()
					_G["GuildControlBankTab"..i.."OwnedStackBox"]:SetEditboxTemplate()
					_G["GuildControlBankTab"..i.."OwnedViewCheck"]:SetCheckboxTemplate(true)
					_G["GuildControlBankTab"..i.."OwnedDepositCheck"]:SetCheckboxTemplate(true)
					_G["GuildControlBankTab"..i.."OwnedUpdateInfoCheck"]:SetCheckboxTemplate(true)

					GCTabHelper(_G["GuildControlBankTab"..i.."OwnedStackBox"])
					GCTabHelper(_G["GuildControlBankTab"..i.."OwnedViewCheck"])
					GCTabHelper(_G["GuildControlBankTab"..i.."OwnedDepositCheck"])
					GCTabHelper(_G["GuildControlBankTab"..i.."OwnedUpdateInfoCheck"])
				end
			end
		end 
		internalTest = true 
	end)

	STYLE:ApplyDropdownStyle(GuildControlUIRankBankFrameRankDropDown, 180)

	GuildControlUIRankBankFrameRankDropDownButton:Width(20)
end 


local function GuildRegistrarStyle()
	if SV.db.SVStyle.blizzard.enable ~= true or SV.db.SVStyle.blizzard.guildregistrar ~= true then
		return 
	end

	STYLE:ApplyWindowStyle(GuildRegistrarFrame, true, true)

	GuildRegistrarFrameInset:Die()
	GuildRegistrarFrameEditBox:RemoveTextures()
	GuildRegistrarGreetingFrame:RemoveTextures()

	GuildRegistrarFrameGoodbyeButton:SetButtonTemplate()
	GuildRegistrarFrameCancelButton:SetButtonTemplate()
	GuildRegistrarFramePurchaseButton:SetButtonTemplate()
	STYLE:ApplyCloseButtonStyle(GuildRegistrarFrameCloseButton)
	GuildRegistrarFrameEditBox:SetEditboxTemplate()

	for b = 1, GuildRegistrarFrameEditBox:GetNumRegions()do 
		local a2 = select(b, GuildRegistrarFrameEditBox:GetRegions())
		if a2 and a2:GetObjectType() == "Texture"then
			if a2:GetTexture() == "Interface\\ChatFrame\\UI-ChatInputBorder-Left" or a2:GetTexture() == "Interface\\ChatFrame\\UI-ChatInputBorder-Right" then 
				a2:Die()
			end 
		end 
	end

	GuildRegistrarFrameEditBox:Height(20)

	if(_G["GuildRegistrarButton1"]) then
		_G["GuildRegistrarButton1"]:GetFontString():SetTextColor(1, 1, 1)
	end
	if(_G["GuildRegistrarButton2"]) then
		_G["GuildRegistrarButton2"]:GetFontString():SetTextColor(1, 1, 1)
	end

	GuildRegistrarPurchaseText:SetTextColor(1, 1, 1)
	AvailableServicesText:SetTextColor(1, 1, 0)
end 

local function LFGuildFrameStyle()
	if(SV.db.SVStyle.blizzard.enable ~= true or SV.db.SVStyle.blizzard.lfguild ~= true) then return end

	STYLE:ApplyWindowStyle(LookingForGuildFrame, true)

	for i = 1, #LFGFrameList do
		local check = _G[LFGFrameList[i]]
		if(check) then check:SetCheckboxTemplate(true) end
	end
	
	LookingForGuildTankButton.checkButton:SetCheckboxTemplate(true)
	LookingForGuildHealerButton.checkButton:SetCheckboxTemplate(true)
	LookingForGuildDamagerButton.checkButton:SetCheckboxTemplate(true)
	LookingForGuildFrameInset:RemoveTextures(false)
	LookingForGuildBrowseButton_LeftSeparator:Die()
	LookingForGuildRequestButton_RightSeparator:Die()

	STYLE:ApplyScrollFrameStyle(LookingForGuildBrowseFrameContainerScrollBar)
	LookingForGuildBrowseButton:SetButtonTemplate()
	LookingForGuildRequestButton:SetButtonTemplate()

	STYLE:ApplyCloseButtonStyle(LookingForGuildFrameCloseButton)
	LookingForGuildCommentInputFrame:SetPanelTemplate("Default")
	LookingForGuildCommentInputFrame:RemoveTextures(false)

	for u = 1, 5 do
		local J = _G["LookingForGuildBrowseFrameContainerButton"..u]
		local K = _G["LookingForGuildAppsFrameContainerButton"..u]
		J:SetBackdrop(nil)
		K:SetBackdrop(nil)
	end

	for u = 1, 3 do
		local tab = _G["LookingForGuildFrameTab"..u]
		STYLE:ApplyTabStyle(tab)
		tab:SetFrameStrata("HIGH")
		tab:SetFrameLevel(99)
	end

	GuildFinderRequestMembershipFrame:RemoveTextures(true)
	GuildFinderRequestMembershipFrame:SetFixedPanelTemplate("Transparent", true)
	GuildFinderRequestMembershipFrameAcceptButton:SetButtonTemplate()
	GuildFinderRequestMembershipFrameCancelButton:SetButtonTemplate()
	GuildFinderRequestMembershipFrameInputFrame:RemoveTextures()
	GuildFinderRequestMembershipFrameInputFrame:SetFixedPanelTemplate("Default")
end 
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
STYLE:SaveBlizzardStyle("Blizzard_GuildBankUI",GuildBankStyle)
STYLE:SaveBlizzardStyle("Blizzard_GuildUI",GuildFrameStyle)
STYLE:SaveBlizzardStyle("Blizzard_GuildControlUI",GuildControlStyle)
STYLE:SaveCustomStyle(GuildRegistrarStyle)
STYLE:SaveBlizzardStyle("Blizzard_LookingForGuildUI",LFGuildFrameStyle)