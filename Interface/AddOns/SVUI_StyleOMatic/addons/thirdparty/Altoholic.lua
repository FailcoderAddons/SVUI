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
local string 	= _G.string;
--[[ STRING METHODS ]]--
local format = string.format;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = _G.SVUI;
local L = LibStub("LibSuperVillain-1.0"):Lang();
local STYLE = _G.StyleVillain;
--[[ 
########################################################## 
ALTOHOLIC
##########################################################
]]--
local function ColorAltoBorder(self)
	if self.border then
		local r, g, b = self.border:GetVertexColor()
		local Backdrop = self.backdrop or self.Backdrop
		Backdrop:SetBackdropBorderColor(r, g, b, 1)
	end
end

local function StyleAltoholic(event, addon)
	assert(AltoholicFrame, "AddOn Not Loaded")

	if event == "PLAYER_ENTERING_WORLD" then
		STYLE:ApplyTooltipStyle(AltoTooltip)

		AltoholicFramePortrait:Die()

		STYLE:ApplyFrameStyle(AltoholicFrame, "Action", false, true)
		STYLE:ApplyFrameStyle(AltoMsgBox)
		STYLE:ApplyButtonStyle(AltoMsgBoxYesButton)
		STYLE:ApplyButtonStyle(AltoMsgBoxNoButton)
		STYLE:ApplyCloseButtonStyle(AltoholicFrameCloseButton)
		STYLE:ApplyEditBoxStyle(AltoholicFrame_SearchEditBox, 175, 15)
		STYLE:ApplyButtonStyle(AltoholicFrame_ResetButton)
		STYLE:ApplyButtonStyle(AltoholicFrame_SearchButton)

		AltoholicFrameTab1:Point("TOPLEFT", AltoholicFrame, "BOTTOMLEFT", -5, 2)
		AltoholicFrame_ResetButton:Point("TOPLEFT", AltoholicFrame, "TOPLEFT", 25, -77)
		AltoholicFrame_SearchEditBox:Point("TOPLEFT", AltoholicFrame, "TOPLEFT", 37, -56)
		AltoholicFrame_ResetButton:Size(85, 24)
		AltoholicFrame_SearchButton:Size(85, 24)
	end

	if addon == "Altoholic_Summary" then
		STYLE:ApplyFrameStyle(AltoholicFrameSummary)
		STYLE:ApplyFrameStyle(AltoholicFrameBagUsage)
		STYLE:ApplyFrameStyle(AltoholicFrameSkills)
		STYLE:ApplyFrameStyle(AltoholicFrameActivity)
		STYLE:ApplyScrollBarStyle(AltoholicFrameSummaryScrollFrameScrollBar)
		STYLE:ApplyScrollBarStyle(AltoholicFrameBagUsageScrollFrameScrollBar)
		STYLE:ApplyScrollBarStyle(AltoholicFrameSkillsScrollFrameScrollBar)
		STYLE:ApplyScrollBarStyle(AltoholicFrameActivityScrollFrameScrollBar)
		STYLE:ApplyDropdownStyle(AltoholicTabSummary_SelectLocation, 200)

		if(AltoholicFrameSummaryScrollFrame) then		
			AltoholicFrameSummaryScrollFrame:RemoveTextures(true)
		end

		if(AltoholicFrameBagUsageScrollFrame) then
			AltoholicFrameBagUsageScrollFrame:RemoveTextures(true)
		end

		if(AltoholicFrameSkillsScrollFrame) then
			AltoholicFrameSkillsScrollFrame:RemoveTextures(true)
		end

		if(AltoholicFrameActivityScrollFrame) then
			AltoholicFrameActivityScrollFrame:RemoveTextures(true)
		end

		STYLE:ApplyButtonStyle(AltoholicTabSummary_RequestSharing)
		STYLE:ApplyTextureStyle(AltoholicTabSummary_RequestSharingIconTexture)
		STYLE:ApplyButtonStyle(AltoholicTabSummary_Options)
		STYLE:ApplyTextureStyle(AltoholicTabSummary_OptionsIconTexture)
		STYLE:ApplyButtonStyle(AltoholicTabSummary_OptionsDataStore)
		STYLE:ApplyTextureStyle(AltoholicTabSummary_OptionsDataStoreIconTexture)

		for i = 1, 5 do
			STYLE:ApplyButtonStyle(_G["AltoholicTabSummaryMenuItem"..i], true)
		end
		for i = 1, 8 do
			STYLE:ApplyButtonStyle(_G["AltoholicTabSummary_Sort"..i], true)
		end
		for i = 1, 7 do
			STYLE:ApplyTabStyle(_G["AltoholicFrameTab"..i], true)
		end
	end
	
	if IsAddOnLoaded("Altoholic_Characters") or addon == "Altoholic_Characters" then
		STYLE:ApplyFrameStyle(AltoholicFrameContainers)
		STYLE:ApplyFrameStyle(AltoholicFrameRecipes)
		STYLE:ApplyFrameStyle(AltoholicFrameQuests)
		STYLE:ApplyFrameStyle(AltoholicFrameGlyphs)
		STYLE:ApplyFrameStyle(AltoholicFrameMail)
		STYLE:ApplyFrameStyle(AltoholicFrameSpellbook)
		STYLE:ApplyFrameStyle(AltoholicFramePets)
		STYLE:ApplyFrameStyle(AltoholicFrameAuctions)
		STYLE:ApplyScrollBarStyle(AltoholicFrameContainersScrollFrameScrollBar)
		STYLE:ApplyScrollBarStyle(AltoholicFrameQuestsScrollFrameScrollBar)
		STYLE:ApplyScrollBarStyle(AltoholicFrameRecipesScrollFrameScrollBar)
		STYLE:ApplyDropdownStyle(AltoholicFrameTalents_SelectMember)
		STYLE:ApplyDropdownStyle(AltoholicTabCharacters_SelectRealm)
		STYLE:ApplyPaginationStyle(AltoholicFrameSpellbookPrevPage)
		STYLE:ApplyPaginationStyle(AltoholicFrameSpellbookNextPage)
		STYLE:ApplyPaginationStyle(AltoholicFramePetsNormalPrevPage)
		STYLE:ApplyPaginationStyle(AltoholicFramePetsNormalNextPage)
		STYLE:ApplyRotateStyle(AltoholicFramePetsNormal_ModelFrameRotateLeftButton)
		STYLE:ApplyRotateStyle(AltoholicFramePetsNormal_ModelFrameRotateRightButton)
		STYLE:ApplyButtonStyle(AltoholicTabCharacters_Sort1)
		STYLE:ApplyButtonStyle(AltoholicTabCharacters_Sort2)
		STYLE:ApplyButtonStyle(AltoholicTabCharacters_Sort3)
		AltoholicFrameContainersScrollFrame:RemoveTextures(true)
		AltoholicFrameQuestsScrollFrame:RemoveTextures(true)
		AltoholicFrameRecipesScrollFrame:RemoveTextures(true)

		local Buttons = {
			'AltoholicTabCharacters_Characters',
			'AltoholicTabCharacters_CharactersIcon',
			'AltoholicTabCharacters_BagsIcon',
			'AltoholicTabCharacters_QuestsIcon',
			'AltoholicTabCharacters_TalentsIcon',
			'AltoholicTabCharacters_AuctionIcon',
			'AltoholicTabCharacters_MailIcon',
			'AltoholicTabCharacters_SpellbookIcon',
			'AltoholicTabCharacters_ProfessionsIcon',
		}

		for _, object in pairs(Buttons) do
			STYLE:ApplyTextureStyle(_G[object..'IconTexture'])
			STYLE:ApplyTextureStyle(_G[object])
		end

		for i = 1, 7 do
			for j = 1, 14 do
				STYLE:ApplyItemButtonStyle(_G["AltoholicFrameContainersEntry"..i.."Item"..j])
				_G["AltoholicFrameContainersEntry"..i.."Item"..j]:HookScript('OnShow', ColorAltoBorder)
			end
		end
	end

	if IsAddOnLoaded("Altoholic_Achievements") or addon == "Altoholic_Achievements" then
		STYLE:ApplyUnderlayStyle(AltoholicFrameAchievements)
		AltoholicFrameAchievementsScrollFrame:RemoveTextures(true)
		AltoholicAchievementsMenuScrollFrame:RemoveTextures(true)
		STYLE:ApplyScrollBarStyle(AltoholicFrameAchievementsScrollFrameScrollBar)
		STYLE:ApplyScrollBarStyle(AltoholicAchievementsMenuScrollFrameScrollBar)
		STYLE:ApplyDropdownStyle(AltoholicTabAchievements_SelectRealm)
		AltoholicTabAchievements_SelectRealm:Point("TOPLEFT", AltoholicFrame, "TOPLEFT", 205, -57)

		for i = 1, 15 do
			STYLE:ApplyButtonStyle(_G["AltoholicTabAchievementsMenuItem"..i], true)
		end

		for i = 1, 8 do
			for j = 1, 10 do
				STYLE:ApplyUnderlayStyle(_G["AltoholicFrameAchievementsEntry"..i.."Item"..j])
				local Backdrop = _G["AltoholicFrameAchievementsEntry"..i.."Item"..j].backdrop or _G["AltoholicFrameAchievementsEntry"..i.."Item"..j].Backdrop
				STYLE:ApplyTextureStyle(_G["AltoholicFrameAchievementsEntry"..i.."Item"..j..'_Background'])
				_G["AltoholicFrameAchievementsEntry"..i.."Item"..j..'_Background']:SetInside(Backdrop)
			end
		end
	end

	if IsAddOnLoaded("Altoholic_Agenda") or addon == "Altoholic_Agenda" then
		STYLE:ApplyFrameStyle(AltoholicFrameCalendarScrollFrame)
		STYLE:ApplyFrameStyle(AltoholicTabAgendaMenuItem1)
		STYLE:ApplyScrollBarStyle(AltoholicFrameCalendarScrollFrameScrollBar)
		STYLE:ApplyPaginationStyle(AltoholicFrameCalendar_NextMonth)
		STYLE:ApplyPaginationStyle(AltoholicFrameCalendar_PrevMonth)
		STYLE:ApplyButtonStyle(AltoholicTabAgendaMenuItem1, true)

		for i = 1, 14 do
			STYLE:ApplyFrameStyle(_G["AltoholicFrameCalendarEntry"..i])
		end
	end

	if IsAddOnLoaded("Altoholic_Grids") or addon == "Altoholic_Grids" then
		AltoholicFrameGridsScrollFrame:RemoveTextures(true)
		STYLE:ApplyUnderlayStyle(AltoholicFrameGrids)
		STYLE:ApplyScrollBarStyle(AltoholicFrameGridsScrollFrameScrollBar)
		STYLE:ApplyDropdownStyle(AltoholicTabGrids_SelectRealm)
		STYLE:ApplyDropdownStyle(AltoholicTabGrids_SelectView)

		for i = 1, 8 do
			for j = 1, 10 do
				STYLE:ApplyUnderlayStyle(_G["AltoholicFrameGridsEntry"..i.."Item"..j], nil, nil, nil, true)
				_G["AltoholicFrameGridsEntry"..i.."Item"..j]:HookScript('OnShow', ColorAltoBorder)
			end
		end

		AltoholicFrameGrids:HookScript('OnUpdate', function()
			for i = 1, 10 do
				for j = 1, 10 do
					if _G["AltoholicFrameGridsEntry"..i.."Item"..j.."_Background"] then
						_G["AltoholicFrameGridsEntry"..i.."Item"..j.."_Background"]:SetTexCoord(.08, .92, .08, .82)
					end
				end
			end
		end)

	end

	if IsAddOnLoaded("Altoholic_Guild") or addon == "Altoholic_Guild" then
		STYLE:ApplyFrameStyle(AltoholicFrameGuildMembers)
		STYLE:ApplyFrameStyle(AltoholicFrameGuildBank)
		STYLE:ApplyScrollBarStyle(AltoholicFrameGuildMembersScrollFrameScrollBar)
		AltoholicFrameGuildMembersScrollFrame:RemoveTextures(true)

		for i = 1, 2 do
			STYLE:ApplyButtonStyle(_G["AltoholicTabGuildMenuItem"..i])
		end

		for i = 1, 7 do
			for j = 1, 14 do
				STYLE:ApplyItemButtonStyle(_G["AltoholicFrameGuildBankEntry"..i.."Item"..j])
			end
		end

		for i = 1, 19 do
			STYLE:ApplyItemButtonStyle(_G["AltoholicFrameGuildMembersItem"..i])
		end

		for i = 1, 5 do
			STYLE:ApplyButtonStyle(_G["AltoholicTabGuild_Sort"..i])
		end
	end

	if IsAddOnLoaded("Altoholic_Search") or addon == "Altoholic_Search" then
		STYLE:ApplyUnderlayStyle(AltoholicFrameSearch, true)
		AltoholicFrameSearchScrollFrame:RemoveTextures(true)
		AltoholicSearchMenuScrollFrame:RemoveTextures(true)
		STYLE:ApplyScrollBarStyle(AltoholicFrameSearchScrollFrameScrollBar)
		STYLE:ApplyScrollBarStyle(AltoholicSearchMenuScrollFrameScrollBar)
		STYLE:ApplyDropdownStyle(AltoholicTabSearch_SelectRarity)
		STYLE:ApplyDropdownStyle(AltoholicTabSearch_SelectSlot)
		STYLE:ApplyDropdownStyle(AltoholicTabSearch_SelectLocation)
		AltoholicTabSearch_SelectRarity:Size(125, 32)
		AltoholicTabSearch_SelectSlot:Size(125, 32)
		AltoholicTabSearch_SelectLocation:Size(175, 32)
		STYLE:ApplyEditBoxStyle(_G["AltoholicTabSearch_MinLevel"])
		STYLE:ApplyEditBoxStyle(_G["AltoholicTabSearch_MaxLevel"])

		for i = 1, 15 do
			STYLE:ApplyButtonStyle(_G["AltoholicTabSearchMenuItem"..i])
		end

		for i = 1, 8 do
			STYLE:ApplyButtonStyle(_G["AltoholicTabSearch_Sort"..i])
		end
	end
end

STYLE:SaveAddonStyle("Altoholic", StyleAltoholic, nil, true)