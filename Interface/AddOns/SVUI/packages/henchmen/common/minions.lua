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
local unpack 	= _G.unpack;
local select 	= _G.select;
local pairs 	= _G.pairs;
local ipairs 	= _G.ipairs;
local type 		= _G.type;
local tinsert 	= _G.tinsert;
local string 	= _G.string;
local math 		= _G.math;
local table 	= _G.table;
--[[ STRING METHODS ]]--
local find, format, len, split = string.find, string.format, string.len, string.split;
local gmatch, gsub, join = string.gmatch, string.gsub, string.join;
--[[ MATH METHODS ]]--
local abs, ceil, floor, round = math.abs, math.ceil, math.floor, math.round;
--[[ TABLE METHODS ]]--
local twipe = table.wipe;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L = unpack(select(2, ...));
local MOD = SuperVillain.Registry:Expose('SVHenchmen');
local NOOP = function() end;
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local takingOnlyCash,deletedelay,mailElapsed,childCount=false,0.5,0,-1;
local GetAllMail, GetAllMailCash, OpenMailItem, WaitForMail, StopOpeningMail, FancifyMoneys, lastopened, needsToWait, total_cash, baseInboxFrame_OnClick;
local incpat 	  = gsub(gsub(FACTION_STANDING_INCREASED, "(%%s)", "(.+)"), "(%%d)", "(.+)");
local changedpat  = gsub(gsub(FACTION_STANDING_CHANGED, "(%%s)", "(.+)"), "(%%d)", "(.+)");
local decpat	  = gsub(gsub(FACTION_STANDING_DECREASED, "(%%s)", "(.+)"), "(%%d)", "(.+)");
local standing    = ('%s:'):format(STANDING);
local reputation  = ('%s:'):format(REPUTATION);
local hideStatic = false;
local AutomatedEvents = {
	"CHAT_MSG_COMBAT_FACTION_CHANGE",
	"MERCHANT_SHOW",
	"QUEST_COMPLETE",
	"QUEST_GREETING",
	"GOSSIP_SHOW",
	"QUEST_DETAIL",
	"QUEST_ACCEPT_CONFIRM",
	"QUEST_PROGRESS"
};
--[[ 
########################################################## 
PRE VARS/FUNCTIONS
##########################################################
]]--
function GetAllMail()
	if GetInboxNumItems()==0 then return end;
	SVUI_GetMailButton:SetScript("OnClick",nil)
	SVUI_GetGoldButton:SetScript("OnClick",nil)
	baseInboxFrame_OnClick=InboxFrame_OnClick;
	InboxFrame_OnClick=NOOP;
	SVUI_GetMailButton:RegisterEvent("UI_ERROR_MESSAGE")
	OpenMailItem(GetInboxNumItems())
end;

function GetAllMailCash()
	takingOnlyCash = true;
	GetAllMail()
end;

function OpenMailItem(mail)
	if not InboxFrame:IsVisible()then return StopOpeningMail("Mailbox Minion Needs a Mailbox!")end;
	if mail==0 then 
		MiniMapMailFrame:Hide()
		return StopOpeningMail("Finished getting your mail!")
	end;
	local _, _, _, _, money, CODAmount, _, itemCount = GetInboxHeaderInfo(mail)
	if not takingOnlyCash then 
		if money > 0 or itemCount and itemCount > 0 and CODAmount <= 0 then 
			AutoLootMailItem(mail)
			needsToWait=true 
		end 
	elseif money > 0 then 
		TakeInboxMoney(mail)
		needsToWait=true;
		if total_cash then total_cash = total_cash - money end 
	end;
	local numMail = GetInboxNumItems()
	if itemCount and itemCount > 0 or numMail > 1 and mail <= numMail then 
		lastopened = mail;
		SVUI_GetMailButton:SetScript("OnUpdate",WaitForMail)
	else 
		MiniMapMailFrame:Hide()
		StopOpeningMail()
	end 
end;

function WaitForMail(_, elapsed)
	mailElapsed = mailElapsed + elapsed;
	if not needsToWait or mailElapsed > deletedelay then
		if not InboxFrame:IsVisible() then return StopOpeningMail("The Mailbox Minion Needs a Mailbox!") end;
		mailElapsed = 0;
		needsToWait = false;
		SVUI_GetMailButton:SetScript("OnUpdate", nil)
		local _, _, _, _, money, CODAmount, _, itemCount = GetInboxHeaderInfo(lastopened)
		if money > 0 or not takingOnlyCash and CODAmount <= 0 and itemCount and itemCount > 0 then
			OpenMailItem(lastopened)
		else
			OpenMailItem(lastopened - 1)
		end 
	end 
end;

function StopOpeningMail(msg, ...)
	SVUI_GetMailButton:SetScript("OnUpdate", nil)
	SVUI_GetMailButton:SetScript("OnClick", GetAllMail)
	SVUI_GetGoldButton:SetScript("OnClick", GetAllMailCash)
	if baseInboxFrame_OnClick then
		InboxFrame_OnClick = baseInboxFrame_OnClick 
	end;
	SVUI_GetMailButton:UnregisterEvent("UI_ERROR_MESSAGE")
	takingOnlyCash = false;
	total_cash = nil;
	needsToWait = false;
	if msg then
		SuperVillain:HenchmanSays(msg)
	end 
end;

function FancifyMoneys(cash)
	if cash > 10000 then
		return("%d|cffffd700g|r%d|cffc7c7cfs|r%d|cffeda55fc|r"):format((cash / 10000), ((cash / 100) % 100), (cash % 100))
	elseif cash > 100 then 
		return("%d|cffc7c7cfs|r%d|cffeda55fc|r"):format(((cash / 100) % 100), (cash % 100))
	else
		return("%d|cffeda55fc|r"):format(cash%100)
	end 
end;
--[[ 
########################################################## 
MAIL HELPER
##########################################################
]]--
function MOD:ToggleMailMinions()
	if not SuperVillain.db.SVHenchmen.mailOpener then 
		SVUI_MailMinion:Hide()
	else
		SVUI_MailMinion:Show()
	end;
end;

function MOD:LoadMailMinions()
	local SVUI_MailMinion = CreateFrame("Frame","SVUI_MailMinion",InboxFrame);
	SVUI_MailMinion:SetWidth(150)
	SVUI_MailMinion:SetHeight(25)
	SVUI_MailMinion:SetPoint("CENTER",InboxFrame,"TOP",-22,-400)

	local SVUI_GetMailButton=CreateFrame("Button","SVUI_GetMailButton",SVUI_MailMinion,"UIPanelButtonTemplate")
	SVUI_GetMailButton:SetWidth(70)
	SVUI_GetMailButton:SetHeight(25)
	SVUI_GetMailButton:SetButtonTemplate()
	SVUI_GetMailButton:SetPoint("LEFT",SVUI_MailMinion,"LEFT",0,0)
	SVUI_GetMailButton:SetText("Get All")
	SVUI_GetMailButton:SetScript("OnClick",GetAllMail)
	SVUI_GetMailButton:SetScript("OnEnter",function()
		GameTooltip:SetOwner(SVUI_GetMailButton,"ANCHOR_RIGHT")
		GameTooltip:AddLine(string.format("%d messages",GetInboxNumItems()),1,1,1)
		GameTooltip:Show()
	end)
	SVUI_GetMailButton:SetScript("OnLeave",function()GameTooltip:Hide()end)
	SVUI_GetMailButton:SetScript("OnEvent",function(l,m,h,n,o,p)
		if m=="UI_ERROR_MESSAGE"then 
			if h==ERR_INV_FULL then 
				StopOpeningMail("Your bags are too full!")
			end 
		end 
	end)
	
	local SVUI_GetGoldButton=CreateFrame("Button","SVUI_GetGoldButton",SVUI_MailMinion,"UIPanelButtonTemplate")
	SVUI_GetGoldButton:SetWidth(70)
	SVUI_GetGoldButton:SetHeight(25)
	SVUI_GetGoldButton:SetButtonTemplate()
	SVUI_GetGoldButton:SetPoint("RIGHT",SVUI_MailMinion,"RIGHT",0,0)
	SVUI_GetGoldButton:SetText("Get Gold")
	SVUI_GetGoldButton:SetScript("OnClick",GetAllMailCash)
	SVUI_GetGoldButton:SetScript("OnEnter",function()
		if not total_cash then 
			total_cash=0;
			for a=0,GetInboxNumItems()do 
				total_cash=total_cash + select(5,GetInboxHeaderInfo(a))
			end 
		end;
		GameTooltip:SetOwner(SVUI_GetGoldButton,"ANCHOR_RIGHT")
		GameTooltip:AddLine(FancifyMoneys(total_cash),1,1,1)
		GameTooltip:Show()
	end)
	SVUI_GetGoldButton:SetScript("OnLeave",function()GameTooltip:Hide()end)
end;
--[[ 
########################################################## 
INVITE AUTOMATONS
##########################################################
]]--
function MOD:AutoGroupInvite(b,B)
	if not SuperVillain.db.SVHenchmen.autoAcceptInvite then return end;
	if b=="PARTY_INVITE_REQUEST"then 
		if QueueStatusMinimapButton:IsShown()then return end;
		if IsInGroup()then return end;
		hideStatic=true;
		if GetNumFriends()>0 then ShowFriends()end;
		if IsInGuild()then GuildRoster()end;
		local r=false;
		for C=1,GetNumFriends()do 
			local D=GetFriendInfo(C)
			if D==B then 
				AcceptGroup()r=true;
				SuperVillain:HenchmanSays("Accepted an Invite From Your Friends!")
				break 
			end 
		end;
		if not r then 
			for E=1,GetNumGuildMembers(true)do 
				local F=GetGuildRosterInfo(E)
				if F==B then 
					AcceptGroup()r=true;
					SuperVillain:HenchmanSays("Accepted an Invite From Your Guild!")
					break 
				end 
			end 
		end;
		if not r then 
			for G=1,BNGetNumFriends()do 
				local m,m,m,H=BNGetFriendInfo(G)
				B=B:match("(.+)%-.+") or B;
				if H==B then 
					AcceptGroup()
					SuperVillain:HenchmanSays("Accepted an Invite!")
					break 
				end 
			end 
		end 
	elseif b=="GROUP_ROSTER_UPDATE" and hideStatic==true then 
		StaticPopup_Hide("PARTY_INVITE")
		hideStatic=false 
	end 
end;
--[[ 
########################################################## 
REPAIR AUTOMATONS
##########################################################
]]--
function MOD:MERCHANT_SHOW()
	if SuperVillain.db.SVHenchmen.vendorGrays then SuperVillain.Registry:Expose('SVBag'):VendorGrays(nil,true) end;
	local autoRepair = SuperVillain.db.SVHenchmen.autoRepair;
	if IsShiftKeyDown() or autoRepair == "NONE" or not CanMerchantRepair() then return end;
	local repairCost,canRepair=GetRepairAllCost()
	local loan=GetGuildBankWithdrawMoney()
	if autoRepair == "GUILD" and (not CanGuildBankRepair() or (repairCost > loan)) then autoRepair = "PLAYER" end;
	if repairCost > 0 then 
		if canRepair then 
			RepairAllItems(autoRepair=='GUILD')
			local x,y,z= repairCost % 100,floor((repairCost % 10000)/100), floor(repairCost / 10000)
			if autoRepair=='GUILD' then 
				SuperVillain:HenchmanSays("Repairs Complete! ...Using Guild Money!\n"..GetCoinTextureString(repairCost,12))
			else 
				SuperVillain:HenchmanSays("Repairs Complete!\n"..GetCoinTextureString(repairCost,12))
			end 
		else 
			SuperVillain:HenchmanSays("The Minions Say You Are Too Broke To Repair! They Are Laughing..")
		end 
	end 
end;
--[[ 
########################################################## 
REP AUTOMATONS
##########################################################
]]--
function MOD:CHAT_MSG_COMBAT_FACTION_CHANGE(event, msg)
	if not SuperVillain.db.SVHenchmen.autorepchange then return end;
	local _, _, faction, amount = find(msg, incpat)
	if not faction then 
		_, _, faction, amount = find(msg, changedpat) or find(msg, decpat) 
	end
	if faction and faction ~= GUILD_REPUTATION then
		local active = GetWatchedFactionInfo()
		for factionIndex = 1, GetNumFactions() do
			local name = GetFactionInfo(factionIndex)
			if name == faction and name ~= active then
				local inactive = IsFactionInactive(factionIndex) or SetWatchedFactionIndex(factionIndex)
				SuperVillain:AddonMessage("Now Tracking: "..name.." Reputation")
				break
			end
		end
	end
end;
--[[ 
########################################################## 
QUEST AUTOMATONS
##########################################################
]]--
function MOD:AutoQuestProxy()
	if(IsShiftKeyDown()) then return false; end
    if((not QuestIsDaily() or not QuestIsWeekly()) and (SuperVillain.db.SVHenchmen.autodailyquests)) then return false; end
    if(QuestFlagsPVP() and (not SuperVillain.db.SVHenchmen.autopvpquests)) then return false; end
    return true
end

function MOD:QUEST_GREETING()
    if(SuperVillain.db.SVHenchmen.autoquestaccept == true and MOD:AutoQuestProxy()) then
        local active,available = GetNumActiveQuests(), GetNumAvailableQuests()
        if(active + available == 0) then return end
        if(available > 0) then
            SelectAvailableQuest(1)
        end
        if(active > 0) then
            SelectActiveQuest(1)
        end
    end
end

function MOD:GOSSIP_SHOW()
    if(SuperVillain.db.SVHenchmen.autoquestaccept == true and MOD:AutoQuestProxy()) then
        if GetGossipAvailableQuests() then
            SelectGossipAvailableQuest(1)
        elseif GetGossipActiveQuests() then
            SelectGossipActiveQuest(1)
        end
    end
end

function MOD:QUEST_DETAIL()
    if(SuperVillain.db.SVHenchmen.autoquestaccept == true and MOD:AutoQuestProxy()) then 
        AcceptQuest()
    end
end

function MOD:QUEST_ACCEPT_CONFIRM()
    if(SuperVillain.db.SVHenchmen.autoquestaccept == true and MOD:AutoQuestProxy()) then
        ConfirmAcceptQuest()
    end
end

function MOD:QUEST_PROGRESS()
	if(IsShiftKeyDown()) then return false; end
    if(SuperVillain.db.SVHenchmen.autoquestcomplete == true) then
        CompleteQuest()
    end
end

function MOD:QUEST_COMPLETE()
	if(not SuperVillain.db.SVHenchmen.autoquestcomplete and (not SuperVillain.db.SVHenchmen.autoquestreward)) then return end;
	if(IsShiftKeyDown()) then return false; end
	local rewards = GetNumQuestChoices()
	local auto_select = QuestFrameRewardPanel.itemChoice or QuestInfoFrame.itemChoice;
	local selection, value = 1, 0;
	if rewards > 0 then
		if SuperVillain.db.SVHenchmen.autoquestreward == true then
			for i = 1, rewards do 
				local iLink = GetQuestItemLink("choice", i)
				if iLink then 
					local iValue = select(11,GetItemInfo(iLink))
					if iValue and iValue > value then 
						value = iValue;
						selection = i 
					end 
				end 
			end;
			local chosenItem = _G[("QuestInfoItem%d"):format(selection)]
			if chosenItem.type == "choice" then 
				QuestInfoItemHighlight:ClearAllPoints()
				QuestInfoItemHighlight:SetAllPoints(chosenItem)
				QuestInfoItemHighlight:Show()
				QuestInfoFrame.itemChoice = chosenItem:GetID()
				SuperVillain:HenchmanSays("A Minion Has Chosen Your Reward!")
			end
		end
		auto_select = selection
		if SuperVillain.db.SVHenchmen.autoquestcomplete == true then
			GetQuestReward(auto_select)
		end
	else
		if(SuperVillain.db.SVHenchmen.autoquestreward == true and SuperVillain.db.SVHenchmen.autoquestcomplete == true) then
			GetQuestReward(auto_select)
		end
	end
end;
--[[ 
########################################################## 
BUILD FUNCTION
##########################################################
]]--
function MOD:LoadAllMinions()
	if IsAddOnLoaded("Postal") then 
		SuperVillain.db.SVHenchmen.mailOpener = false
	else
		self:LoadMailMinions()
		self:ToggleMailMinions()
	end;

	self:RegisterEvent('PARTY_INVITE_REQUEST','AutoGroupInvite')
	self:RegisterEvent('GROUP_ROSTER_UPDATE','AutoGroupInvite')
	for _,event in pairs(AutomatedEvents) do
		self:RegisterEvent(event)
	end

	if SuperVillain.db.SVHenchmen.pvpautorelease then 
		local autoReleaseHandler = CreateFrame("frame")
		autoReleaseHandler:RegisterEvent("PLAYER_DEAD")
		autoReleaseHandler:SetScript("OnEvent",function(self,event)
			local isInstance, instanceType = IsInInstance()
			if(isInstance and instanceType == "pvp") then 
				local spell = GetSpellInfo(20707)
				if(SuperVillain.class ~= "SHAMAN" and not(spell and UnitBuff("player",spell))) then 
					RepopMe()
				end 
			end;
			for i=1,GetNumWorldPVPAreas() do 
				local _,localizedName, isActive = GetWorldPVPAreaInfo(i)
				if(GetRealZoneText() == localizedName and isActive) then RepopMe() end 
			end 
		end)
	end;

	local skippy = CreateFrame("Frame")
	skippy:RegisterEvent("CINEMATIC_START")
	skippy:SetScript("OnEvent", function(_, event)
		if event == "CINEMATIC_START" then
			if(SuperVillain.db.SVHenchmen.skipcinematics) then
				CinematicFrame_CancelCinematic()
			end
		end
	end)
	local PlayMovie_hook = MovieFrame_PlayMovie
	MovieFrame_PlayMovie = function(...)
		if(SuperVillain.db.SVHenchmen.skipcinematics) then
			GameMovieFinished()
		else
			PlayMovie_hook(...)
		end
	end
end;