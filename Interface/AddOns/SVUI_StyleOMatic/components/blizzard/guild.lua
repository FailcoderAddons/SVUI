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
local unpack  	= _G.unpack;
local select  	= _G.select;
local ipairs  	= _G.ipairs;
local pairs   	= _G.pairs;
local next    	= _G.next;
local time 		= _G.time;
local date 		= _G.date;
local ceil, modf = math.ceil, math.modf;
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

local _hook_RankOrder_OnUpdate = function()
	for i = 1, GuildControlGetNumRanks()do 
		local frame = _G["GuildControlUIRankOrderFrameRank"..i]
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

local _hook_UIRankOrder = function(self)
	SV.Timers:ExecuteTimer(1, _hook_RankOrder_OnUpdate)
end

local _hook_GuildBankFrame_Update = function(self)
	if GuildBankFrame.mode ~= "bank" then return end 
	local curTab = GetCurrentGuildBankTab()
	local numSlots = NUM_SLOTS_PER_GUILDBANK_GROUP
	local maxSlots = MAX_GUILDBANK_SLOTS_PER_TAB
	local button, btnName, btnID, slotID, itemLink;
	for i = 1, maxSlots do
		btnID = i % numSlots
		if btnID == 0 then
			btnID = numSlots 
		end
		slotID = ceil((i - 0.5) / numSlots)
		btnName = ("GuildBankColumn%dButton%d"):format(slotID, btnID)
		button = _G[btnName]
		if(button) then
			itemLink = GetGuildBankItemLink(curTab, i)
			local r, g, b, a = 0,0,0,1
			if(itemLink) then
				local quality = select(3, GetItemInfo(itemLink))
				if(quality > 1) then
					r, g, b = GetItemQualityColor(quality)
				end
			end 
			button:SetBackdropBorderColor(r, g, b, a)
		end
	end 
end

local _hook_BankTabPermissions = function(self)
	local tab, tabs, baseName, ownedName, purchase, view, stack, deposit, update

	tabs = GetNumGuildBankTabs()

	if tabs < MAX_BUY_GUILDBANK_TABS then 
		tabs = tabs + 1 
	end

	for i = 1, tabs do 
		baseName = ("GuildControlBankTab%d"):format(i)
		ownedName = ("%sOwned"):format(baseName)
		tab = _G[ownedName]
		
		if(tab) then
			if(tab.tabIcon) then tab.tabIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9) end
			if(tab.editBox) then tab.editBox:SetEditboxTemplate() end

			if internalTest == false then
				purchase =  _G[baseName.."BuyPurchaseButton"]
				if(purchase) then
					purchase:SetButtonTemplate()
				end
				view =  _G[ownedName.."ViewCheck"]
				if(view) then
					view:SetCheckboxTemplate(true)
					GCTabHelper(view)
				end
				stack =  _G[ownedName.."StackBox"]
				if(stack) then
					stack:SetEditboxTemplate()
					GCTabHelper(stack)
				end
				deposit =  _G[ownedName.."DepositCheck"]
				if(deposit) then
					deposit:SetCheckboxTemplate(true)
					GCTabHelper(deposit)
				end
				update =  _G[ownedName.."UpdateInfoCheck"]
				if(update) then
					update:SetCheckboxTemplate(true)
					GCTabHelper(update)
				end
			end
		end
	end 
	internalTest = true 
end
--[[ 
########################################################## 
GUILDFRAME STYLERS
##########################################################
]]--
local function GuildBankStyle()
	if SV.db[Schema].blizzard.enable ~= true or SV.db[Schema].blizzard.gbank ~= true then
		return 
	end

	STYLE:ApplyWindowStyle(GuildBankFrame)

	GuildBankEmblemFrame:RemoveTextures(true)
	GuildBankMoneyFrameBackground:Die()
	STYLE:ApplyScrollFrameStyle(GuildBankPopupScrollFrameScrollBar)

	for i = 1, GuildBankFrame:GetNumChildren() do 
		local child = select(i, GuildBankFrame:GetChildren())
		if(child and child.GetPushedTexture and child:GetPushedTexture() and not child:GetName()) then
			STYLE:ApplyCloseButtonStyle(child)
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
	
	for i = 1, NUM_GUILDBANK_COLUMNS do
		local frame = _G["GuildBankColumn"..i]
		if(frame) then
			frame:RemoveTextures()
			local baseName = ("GuildBankColumn%dButton"):format(i)
			for slotID = 1, NUM_SLOTS_PER_GUILDBANK_GROUP do 
				local btnName = ("%s%d"):format(baseName, slotID)
				local button = _G[btnName]
				if(button) then
					local texture = _G[btnName.."NormalTexture"]
					if texture then
						texture:SetTexture(0,0,0,0)
					end

					button:SetSlotTemplate()

					local icon = _G[btnName.."IconTexture"]
					if(icon) then
						icon:FillInner()
						icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
					end
				end
			end
		end
	end 

	for i = 1, 8 do
		local baseName = ("GuildBankTab%d"):format(i)
		local tab = _G[baseName]
		if(tab) then
			local btnName = ("%sButton"):format(baseName)
			local button = _G[baseName]
			if(button) then
				tab:RemoveTextures(true)
				button:RemoveTextures()
				button:SetButtonTemplate()
				button:SetFixedPanelTemplate("Default")

				local texture = _G[btnName.."IconTexture"]
				if(texture) then
					texture:FillInner()
					texture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				end
			end
		end
	end 

	for i = 1, 4 do
		local baseName = ("GuildBankFrameTab%d"):format(i)
		local frame = _G[baseName]
		if(frame) then
			STYLE:ApplyTabStyle(_G[baseName])
		end
	end 

	hooksecurefunc('GuildBankFrame_Update', _hook_GuildBankFrame_Update)

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

	for i = 1, 16 do
		local btnName = ("GuildBankPopupButton%d"):format(i)
		local button = _G[btnName]
		if(button) then
			button:RemoveTextures()
			button:SetFixedPanelTemplate("Default")
			button:SetButtonTemplate()

			local icon = _G[btnName.."Icon"]
			if(icon) then
				icon:FillInner()
				icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			end
		end
	end 

	STYLE:ApplyScrollFrameStyle(GuildBankTransactionsScrollFrameScrollBar)
	STYLE:ApplyScrollFrameStyle(GuildBankInfoScrollFrameScrollBar)
end 

local function GuildFrameStyle()
	if SV.db[Schema].blizzard.enable ~= true or SV.db[Schema].blizzard.guild ~= true then
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
	if SV.db[Schema].blizzard.enable~=true or SV.db[Schema].blizzard.guildcontrol~=true then return end

	GuildControlUI:RemoveTextures()
	GuildControlUIHbar:RemoveTextures()
	GuildControlUIRankBankFrameInset:RemoveTextures()
	GuildControlUIRankBankFrameInsetScrollFrame:RemoveTextures()

	STYLE:ApplyWindowStyle(GuildControlUI)

	STYLE:ApplyScrollFrameStyle(GuildControlUIRankBankFrameInsetScrollFrameScrollBar)

	hooksecurefunc("GuildControlUI_RankOrder_Update", _hook_RankOrder_OnUpdate)
	GuildControlUIRankOrderFrameNewButton:HookScript("OnClick", _hook_UIRankOrder)

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

	hooksecurefunc("GuildControlUI_BankTabPermissions_Update", _hook_BankTabPermissions)

	STYLE:ApplyDropdownStyle(GuildControlUIRankBankFrameRankDropDown, 180)

	GuildControlUIRankBankFrameRankDropDownButton:Width(20)
end 


local function GuildRegistrarStyle()
	if SV.db[Schema].blizzard.enable ~= true or SV.db[Schema].blizzard.guildregistrar ~= true then
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
	if(SV.db[Schema].blizzard.enable ~= true or SV.db[Schema].blizzard.lfguild ~= true) then return end

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