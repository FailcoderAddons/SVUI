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
local SuperVillain, L = unpack(SVUI);
local MOD = SuperVillain.Registry:Expose("SVStyle");
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
	end;
	b.spellTex:Size(c or 506, d or 615)
	b.spellTex:SetTexCoord(0, 1, 0.02, 1)
end;

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
			SuperVillain:AddCD(_G["WatchFrameItem"..i.."Cooldown"])
			button.styled = true
		end
	end	
end;
--[[ 
########################################################## 
QUEST STYLERS
##########################################################
]]--
local function QuestGreetingStyle()
	if SuperVillain.db.SVStyle.blizzard.enable ~= true or SuperVillain.db.SVStyle.blizzard.greeting ~= true then
		return 
	end;
	QuestFrameGreetingPanel:HookScript("OnShow", function()
		QuestFrameGreetingPanel:Formula409()
		QuestFrameGreetingGoodbyeButton:SetButtonTemplate()
		QuestGreetingFrameHorizontalBreak:MUNG()
	end)
end;

local function QuestFrameStyle()
	if SuperVillain.db.SVStyle.blizzard.enable ~= true or SuperVillain.db.SVStyle.blizzard.quest ~= true then return end;
	MOD:ApplyCloseButtonStyle(QuestLogFrameCloseButton)
	MOD:ApplyScrollStyle(QuestLogDetailScrollFrameScrollBar)
	MOD:ApplyScrollStyle(QuestLogScrollFrameScrollBar, 5)
	MOD:ApplyScrollStyle(QuestProgressScrollFrameScrollBar)
	MOD:ApplyScrollStyle(QuestRewardScrollFrameScrollBar)
	QuestLogScrollFrame:Formula409()
	QuestLogFrame:Formula409()
	QuestLogFrame:SetPanelTemplate("Halftone")
	QuestLogCount:Formula409()
	QuestLogCount:SetFixedPanelTemplate("Default")
	EmptyQuestLogFrame:Formula409()
	QuestLogDetailFrameInset:MUNG()
	MOD:ApplyScrollStyle(QuestDetailScrollFrameScrollBar)
	QuestProgressScrollFrame:Formula409()
	QuestLogFrameShowMapButton:Formula409()
	QuestLogFrameShowMapButton:SetButtonTemplate()
	QuestLogFrameShowMapButton.text:ClearAllPoints()
	QuestLogFrameShowMapButton.text:SetPoint("CENTER")
	QuestLogFrameShowMapButton:Size(QuestLogFrameShowMapButton:GetWidth()-30, QuestLogFrameShowMapButton:GetHeight(), -40)
	QuestGreetingScrollFrame:Formula409()
	MOD:ApplyScrollStyle(QuestGreetingScrollFrameScrollBar)
	QuestLogFrameInset:MUNG()
	QuestLogFrameCompleteButton:Formula409()
	for _,i in pairs(QuestFrameList)do 
		_G[i]:SetButtonTemplate()
		_G[i]:SetFrameLevel(_G[i]:GetFrameLevel() + 2)
	end;
	QuestLogFramePushQuestButton:Point("LEFT", QuestLogFrameAbandonButton, "RIGHT", 2, 0)
	QuestLogFramePushQuestButton:Point("RIGHT", QuestLogFrameTrackButton, "LEFT", -2, 0)
	for j = 1, MAX_NUM_ITEMS do 
		local cLvl = _G["QuestInfoItem"..j]:GetFrameLevel() + 1
		_G["QuestInfoItem"..j]:Formula409()
		_G["QuestInfoItem"..j]:Width(_G["QuestInfoItem"..j]:GetWidth()-4)
		_G["QuestInfoItem"..j]:SetFrameLevel(cLvl)
		
		_G["QuestInfoItem"..j.."IconTexture"]:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		_G["QuestInfoItem"..j.."IconTexture"]:SetDrawLayer("OVERLAY",1)
		_G["QuestInfoItem"..j.."IconTexture"]:Point("TOPLEFT", 2, -2)
		_G["QuestInfoItem"..j.."IconTexture"]:Size(_G["QuestInfoItem"..j.."IconTexture"]:GetWidth()-2, _G["QuestInfoItem"..j.."IconTexture"]:GetHeight()-2)
		MOD:ApplyLinkButtonStyle(_G["QuestInfoItem"..j])
	end;
	QuestInfoSkillPointFrame:Formula409()
	QuestInfoSkillPointFrame:Width(QuestInfoSkillPointFrame:GetWidth()-4)
	local curLvl = QuestInfoSkillPointFrame:GetFrameLevel() + 1
	QuestInfoSkillPointFrame:SetFrameLevel(curLvl)
	QuestInfoSkillPointFrame:SetFixedPanelTemplate("Slot")
	QuestInfoSkillPointFrame:SetBackdropColor(1,1,0,0.5)
	QuestInfoSkillPointFrameIconTexture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	QuestInfoSkillPointFrameIconTexture:SetDrawLayer("OVERLAY")
	QuestInfoSkillPointFrameIconTexture:Point("TOPLEFT", 2, -2)
	QuestInfoSkillPointFrameIconTexture:Size(QuestInfoSkillPointFrameIconTexture:GetWidth()-2, QuestInfoSkillPointFrameIconTexture:GetHeight()-2)
	QuestInfoSkillPointFrameCount:SetDrawLayer("OVERLAY")
	QuestInfoSkillPointFramePoints:ClearAllPoints()
	QuestInfoSkillPointFramePoints:Point("BOTTOMRIGHT", QuestInfoSkillPointFrameIconTexture, "BOTTOMRIGHT")
	QuestInfoItemHighlight:Formula409()
	QuestInfoItemHighlight:SetFixedPanelTemplate("Slot")
	QuestInfoItemHighlight:SetBackdropBorderColor(1, 1, 0)
	QuestInfoItemHighlight:SetBackdropColor(0, 0, 0, 0)
	QuestInfoItemHighlight:Size(142, 40)
	hooksecurefunc("QuestInfoItem_OnClick", function(k)
		QuestInfoItemHighlight:ClearAllPoints()
		QuestInfoItemHighlight:SetAllPoints(k)
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
	QuestLogDetailScrollFrame:HookScript('OnShow', function(k)
		if not QuestLogDetailScrollFrame.Panel then
			QuestLogDetailScrollFrame:SetPanelTemplate("Default")
			QuestScrollHelper(QuestLogDetailScrollFrame, 509, 630, false)
			QuestLogDetailScrollFrame:Height(k:GetHeight() - 2)
		end;
		QuestLogDetailScrollFrame.spellTex:Height(k:GetHeight() + 217)
	end)
	QuestRewardScrollFrame:HookScript('OnShow', function(k)
		if not k.Panel then
			k:SetPanelTemplate("Default")
			QuestScrollHelper(k, 509, 630, false)
			k:Height(k:GetHeight() - 2)
		end;
		k.spellTex:Height(k:GetHeight() + 217)
	end)
	hooksecurefunc("QuestInfo_Display", function(l, m)
		for j = 1, MAX_NUM_ITEMS do 
			local n = _G["QuestInfoItem"..j]
			if not n:IsShown() then
				break 
			end;
			local o, p, q, r, s = n:GetPoint()
			if j == 1 then
				n:Point(o, p, q, 0, s)
			elseif q == "BOTTOMLEFT"then 
				n:Point(o, p, q, 0, -4)
			else
				n:Point(o, p, q, 4, 0)
			end 
		end 
	end)
	QuestFrame:Formula409(true)
	QuestFrameInset:MUNG()
	QuestFrameDetailPanel:Formula409(true)
	QuestDetailScrollFrame:Formula409(true)
	QuestScrollHelper(QuestDetailScrollFrame, 506, 615, true)
	QuestProgressScrollFrame:SetFixedPanelTemplate()
	QuestScrollHelper(QuestProgressScrollFrame, 506, 615, true)
	QuestGreetingScrollFrame:SetFixedPanelTemplate()
	QuestScrollHelper(QuestGreetingScrollFrame, 506, 615, true)
	QuestDetailScrollChildFrame:Formula409(true)
	QuestRewardScrollFrame:Formula409(true)
	QuestRewardScrollChildFrame:Formula409(true)
	QuestFrameProgressPanel:Formula409(true)
	QuestFrameRewardPanel:Formula409(true)
	QuestFrame:SetPanelTemplate("Action")
	QuestFrameAcceptButton:SetButtonTemplate()
	QuestFrameDeclineButton:SetButtonTemplate()
	QuestFrameCompleteButton:SetButtonTemplate()
	QuestFrameGoodbyeButton:SetButtonTemplate()
	QuestFrameCompleteQuestButton:SetButtonTemplate()
	MOD:ApplyCloseButtonStyle(QuestFrameCloseButton, QuestFrame.Panel)
	for j = 1, 6 do 
		local i = _G["QuestProgressItem"..j]
		local texture = _G["QuestProgressItem"..j.."IconTexture"]
		i:Formula409()
		i:SetFixedPanelTemplate("Inset")
		i:Width(_G["QuestProgressItem"..j]:GetWidth() - 4)
		texture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		texture:SetDrawLayer("OVERLAY")
		texture:Point("TOPLEFT", 2, -2)
		texture:Size(texture:GetWidth() - 2, texture:GetHeight() - 2)
		_G["QuestProgressItem"..j.."Count"]:SetDrawLayer("OVERLAY")
	end;
	QuestNPCModel:Formula409()
	QuestNPCModel:SetPanelTemplate("Comic")
	QuestNPCModel:Point("TOPLEFT", QuestLogDetailFrame, "TOPRIGHT", 4, -34)
	QuestNPCModelTextFrame:Formula409()
	QuestNPCModelTextFrame:SetPanelTemplate("Default")
	QuestNPCModelTextFrame.Panel:Point("TOPLEFT", QuestNPCModel.Panel, "BOTTOMLEFT", 0, -2)
	QuestLogDetailFrame:Formula409()
	QuestLogDetailFrame:SetPanelTemplate("Action")
	QuestLogDetailScrollFrame:Formula409()
	MOD:ApplyCloseButtonStyle(QuestLogDetailFrameCloseButton)
	hooksecurefunc("QuestFrame_ShowQuestPortrait", function(m, t, text, u, r, s)
		QuestNPCModel:ClearAllPoints()
		QuestNPCModel:SetPoint("TOPLEFT", m, "TOPRIGHT", r+18, s)
	end)

	if not SuperVillain.db.system.questWatch then
		WatchFrame:HookScript("OnEvent", QueuedWatchFrameItems)
		WatchFrame:HookScript("OnUpdate", QueuedWatchFrameItems)
	end;
end;
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
MOD:SaveCustomStyle(QuestFrameStyle)
MOD:SaveCustomStyle(QuestGreetingStyle)