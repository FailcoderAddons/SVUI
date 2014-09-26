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
credit: Elv.                      original logic from ElvUI. Adapted to SVUI #
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
local QuestFrameList = {
	"QuestLogFrameAbandonButton",
	"QuestLogFramePushQuestButton",
	"QuestLogFrameTrackButton",
	"QuestLogFrameCancelButton",
	"QuestLogFrameCompleteButton"
};

local function QuestScrollHelper(b, c, d, e)
	b:SetPanelTemplate("Inset")
	b.spellTex = b:CreateTexture(nil, 'ARTWORK')
	b.spellTex:SetTexture([[Interface\QuestFrame\QuestBG]])
	if e then
		 b.spellTex:SetPoint("TOPLEFT", 2, -2)
	else
		 b.spellTex:SetPoint("TOPLEFT")
	end 
	b.spellTex:Size(c or 506, d or 615)
	b.spellTex:SetTexCoord(0, 1, 0.02, 1)
end 

local function QueuedWatchFrameItems()
	for i=1, WATCHFRAME_NUM_ITEMS do
		local button = _G["WatchFrameItem"..i]
		local point, relativeTo, relativePoint, xOffset, yOffset = button:GetPoint(1)
		button:SetFrameStrata("LOW")
		button:SetPoint("TOPRIGHT", relativeTo, "TOPLEFT", -30, -2);
		if not button.styled then
			button:SetSlotTemplate()
			button:SetBackdropColor(0,0,0,0)
			_G["WatchFrameItem"..i.."NormalTexture"]:SetAlpha(0)
			_G["WatchFrameItem"..i.."IconTexture"]:FillInner()
			_G["WatchFrameItem"..i.."IconTexture"]:SetTexCoord(0.1,0.9,0.1,0.9)
			SV.Timers:AddCooldown(_G["WatchFrameItem"..i.."Cooldown"])
			button.styled = true
		end
	end	
end

local QuestRewardScrollFrame_OnShow = function(self)
	if(not self.Panel) then
		self:SetPanelTemplate("Default")
		QuestScrollHelper(self, 509, 630, false)
		self:Height(self:GetHeight() - 2)
	end
	if(self.spellTex) then
		self.spellTex:Height(self:GetHeight() + 217)
	end
end

local Hook_QuestInfo_Display = function(self, ...)
	for i = 1, MAX_NUM_ITEMS do
		local name = ("QuestInfoItem%d"):format(i)
		local item = _G[name]
		if(item and item:IsShown()) then
			local initialAnchor, anchorParent, relativeAnchor, xPosition, yPosition = item:GetPoint()
			if(i == 1) then
				item:Point(initialAnchor, anchorParent, relativeAnchor, 0, yPosition)
			elseif(relativeAnchor == "BOTTOMLEFT") then 
				item:Point(initialAnchor, anchorParent, relativeAnchor, 0, -4)
			else
				item:Point(initialAnchor, anchorParent, relativeAnchor, 4, 0)
			end
		end 
	end 
end

local Hook_QuestInfoItem_OnClick = function(self)
	QuestInfoItemHighlight:ClearAllPoints()
	QuestInfoItemHighlight:SetAllPoints(self)
end

local Hook_QuestNPCModel = function(self, _, _, _, x, y)
	QuestNPCModel:ClearAllPoints()
	QuestNPCModel:SetPoint("TOPLEFT", self, "TOPRIGHT", x + 18, y)
end
--[[ 
########################################################## 
QUEST STYLERS
##########################################################
]]--
local function QuestGreetingStyle()
	if SV.db.SVStyle.blizzard.enable ~= true or SV.db.SVStyle.blizzard.greeting ~= true then
		return 
	end

	QuestFrameGreetingPanel:HookScript("OnShow", function()
		QuestFrameGreetingPanel:RemoveTextures()
		QuestFrameGreetingGoodbyeButton:SetButtonTemplate()
		QuestGreetingFrameHorizontalBreak:Die()
	end)
end 

local function QuestFrameStyle()
	if SV.db.SVStyle.blizzard.enable ~= true or SV.db.SVStyle.blizzard.quest ~= true then return end

	STYLE:ApplyWindowStyle(QuestFrame, true, true)

	--[[ THIS SECTION NOT WORKING IN WOD ]]--
	if(SV.GameVersion < 60000) then
		QuestLogScrollFrame:RemoveTextures()
		QuestLogCount:RemoveTextures()
		EmptyQuestLogFrame:RemoveTextures()
		QuestProgressScrollFrame:RemoveTextures()
		QuestLogFrameShowMapButton:RemoveTextures()
		QuestLogFrameCompleteButton:RemoveTextures()

		STYLE:ApplyWindowStyle(QuestLogFrame)
		QuestLogCount:SetFixedPanelTemplate("Default")

		QuestLogDetailFrameInset:Die()
		QuestLogFrameInset:Die()

		QuestLogFrameShowMapButton:SetButtonTemplate()
		QuestLogFrameShowMapButton.text:ClearAllPoints()
		QuestLogFrameShowMapButton.text:SetPoint("CENTER")

		for _,i in pairs(QuestFrameList)do 
			_G[i]:SetButtonTemplate()
			_G[i]:SetFrameLevel(_G[i]:GetFrameLevel() + 2)
		end

		QuestLogFramePushQuestButton:Point("LEFT", QuestLogFrameAbandonButton, "RIGHT", 2, 0)
		QuestLogFramePushQuestButton:Point("RIGHT", QuestLogFrameTrackButton, "LEFT", -2, 0)

		QuestLogDetailScrollFrame:HookScript('OnShow', function(k)
			if not QuestLogDetailScrollFrame.Panel then
				QuestLogDetailScrollFrame:SetPanelTemplate("Default")
				QuestScrollHelper(QuestLogDetailScrollFrame, 509, 630, false)
				QuestLogDetailScrollFrame:Height(k:GetHeight() - 2)
			end 
			QuestLogDetailScrollFrame.spellTex:Height(k:GetHeight() + 217)
		end)

		QuestLogFrame:HookScript("OnShow", function()
			if not QuestLogScrollFrame.spellTex then
				QuestLogScrollFrame:SetFixedPanelTemplate("Default")
				QuestLogScrollFrame.spellTex = QuestLogScrollFrame:CreateTexture(nil, 'ARTWORK')
				QuestLogScrollFrame.spellTex:SetTexture([[Interface\QuestFrame\QuestBookBG]])
				QuestLogScrollFrame.spellTex:SetPoint("TOPLEFT", 2, -2)
				QuestLogScrollFrame.spellTex:Size(514, 616)
				QuestLogScrollFrame.spellTex:SetTexCoord(0, 1, 0.02, 1)
				QuestLogScrollFrame.spellTex2 = QuestLogScrollFrame:CreateTexture(nil, 'BORDER')
				QuestLogScrollFrame.spellTex2:SetTexture([[Interface\FrameGeneral\UI-Background-Rock]])
				QuestLogScrollFrame.spellTex2:FillInner()
			end 
		end)
	end
	--[[ ############################### ]]--

	STYLE:ApplyCloseButtonStyle(QuestLogFrameCloseButton)
	STYLE:ApplyScrollFrameStyle(QuestLogDetailScrollFrameScrollBar)
	STYLE:ApplyScrollFrameStyle(QuestLogScrollFrameScrollBar, 5)
	STYLE:ApplyScrollFrameStyle(QuestProgressScrollFrameScrollBar)
	STYLE:ApplyScrollFrameStyle(QuestRewardScrollFrameScrollBar)

	QuestGreetingScrollFrame:RemoveTextures()
	STYLE:ApplyScrollFrameStyle(QuestGreetingScrollFrameScrollBar)

	for i = 1, MAX_NUM_ITEMS do
		local item = _G["QuestInfoItem"..i]
		if(item) then
			local cLvl = item:GetFrameLevel() + 1
			item:RemoveTextures()
			item:Width(item:GetWidth() - 4)
			item:SetFrameLevel(cLvl)

			local tex = _G["QuestInfoItem"..i.."IconTexture"]
			if(tex) then
				tex:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				tex:SetDrawLayer("OVERLAY",1)
				tex:SetPoint("TOPLEFT", 2, -2)
				tex:Size(tex:GetWidth() - 2, tex:GetHeight() - 2)
			end
			STYLE:ApplyItemButtonStyle(item)
		end
	end 

	QuestInfoSkillPointFrame:RemoveTextures()
	QuestInfoSkillPointFrame:Width(QuestInfoSkillPointFrame:GetWidth() - 4)

	local curLvl = QuestInfoSkillPointFrame:GetFrameLevel() + 1
	QuestInfoSkillPointFrame:SetFrameLevel(curLvl)
	QuestInfoSkillPointFrame:SetFixedPanelTemplate("Slot")
	QuestInfoSkillPointFrame:SetBackdropColor(1, 1, 0, 0.5)
	QuestInfoSkillPointFrameIconTexture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	QuestInfoSkillPointFrameIconTexture:SetDrawLayer("OVERLAY")
	QuestInfoSkillPointFrameIconTexture:Point("TOPLEFT", 2, -2)
	QuestInfoSkillPointFrameIconTexture:Size(QuestInfoSkillPointFrameIconTexture:GetWidth()-2, QuestInfoSkillPointFrameIconTexture:GetHeight()-2)
	QuestInfoSkillPointFrameCount:SetDrawLayer("OVERLAY")
	QuestInfoItemHighlight:RemoveTextures()
	QuestInfoItemHighlight:SetFixedPanelTemplate("Slot")
	QuestInfoItemHighlight:SetBackdropBorderColor(1, 1, 0)
	QuestInfoItemHighlight:SetBackdropColor(0, 0, 0, 0)
	QuestInfoItemHighlight:Size(142, 40)

	hooksecurefunc("QuestInfoItem_OnClick", Hook_QuestInfoItem_OnClick)
	hooksecurefunc("QuestInfo_Display", Hook_QuestInfo_Display)

	QuestRewardScrollFrame:HookScript("OnShow", QuestRewardScrollFrame_OnShow)

	QuestFrameInset:Die()
	QuestFrameDetailPanel:RemoveTextures(true)
	QuestDetailScrollFrame:RemoveTextures(true)
	QuestScrollHelper(QuestDetailScrollFrame, 506, 615, true)
	QuestProgressScrollFrame:SetFixedPanelTemplate()
	QuestScrollHelper(QuestProgressScrollFrame, 506, 615, true)
	QuestGreetingScrollFrame:SetFixedPanelTemplate()
	QuestScrollHelper(QuestGreetingScrollFrame, 506, 615, true)
	QuestDetailScrollChildFrame:RemoveTextures(true)
	QuestRewardScrollFrame:RemoveTextures(true)
	QuestRewardScrollChildFrame:RemoveTextures(true)
	QuestFrameProgressPanel:RemoveTextures(true)
	QuestFrameRewardPanel:RemoveTextures(true)

	QuestFrameAcceptButton:SetButtonTemplate()
	QuestFrameDeclineButton:SetButtonTemplate()
	QuestFrameCompleteButton:SetButtonTemplate()
	QuestFrameGoodbyeButton:SetButtonTemplate()
	QuestFrameCompleteQuestButton:SetButtonTemplate()

	STYLE:ApplyCloseButtonStyle(QuestFrameCloseButton, QuestFrame.Panel)

	for j = 1, 6 do 
		local i = _G["QuestProgressItem"..j]
		local texture = _G["QuestProgressItem"..j.."IconTexture"]
		i:RemoveTextures()
		i:SetFixedPanelTemplate("Inset")
		i:Width(_G["QuestProgressItem"..j]:GetWidth() - 4)
		texture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		texture:SetDrawLayer("OVERLAY")
		texture:Point("TOPLEFT", 2, -2)
		texture:Size(texture:GetWidth() - 2, texture:GetHeight() - 2)
		_G["QuestProgressItem"..j.."Count"]:SetDrawLayer("OVERLAY")
	end

	QuestNPCModel:RemoveTextures()
	QuestNPCModel:SetPanelTemplate("Comic")

	QuestNPCModelTextFrame:RemoveTextures()
	QuestNPCModelTextFrame:SetPanelTemplate("Default")
	QuestNPCModelTextFrame.Panel:Point("TOPLEFT", QuestNPCModel.Panel, "BOTTOMLEFT", 0, -2)

	hooksecurefunc("QuestFrame_ShowQuestPortrait", Hook_QuestNPCModel)

end 
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
STYLE:SaveCustomStyle(QuestFrameStyle)
STYLE:SaveCustomStyle(QuestGreetingStyle)