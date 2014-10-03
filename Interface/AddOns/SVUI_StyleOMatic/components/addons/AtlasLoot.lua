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
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = _G.SVUI;
local L = SV.L;
local STYLE = select(2, ...);
local Schema = STYLE.Schema;
--[[ 
########################################################## 
ATLASLOOT
##########################################################
]]--
local timeLapse = 0;
local nineisthere = {"AtlasLootCompareFrameSortButton_7","AtlasLootCompareFrameSortButton_8","AtlasLootCompareFrameSortButton_9"}
local StripAllTextures = {"AtlasLootDefaultFrame","AtlasLootDefaultFrame_ScrollFrame","AtlasLootItemsFrame","AtlasLootPanel","AtlasLootCompareFrame","AtlasLootCompareFrame_ScrollFrameMainFilterScrollChildFrame","AtlasLootCompareFrame_ScrollFrameItemFrame","AtlasLootCompareFrame_ScrollFrameMainFilter","AtlasLootCompareFrameSortButton_Name","AtlasLootCompareFrameSortButton_Rarity","AtlasLootCompareFrameSortButton_1","AtlasLootCompareFrameSortButton_2","AtlasLootCompareFrameSortButton_3","AtlasLootCompareFrameSortButton_4","AtlasLootCompareFrameSortButton_5","AtlasLootCompareFrameSortButton_6"}

local SetTemplateDefault = {"AtlasLootCompareFrameSortButton_Name","AtlasLootCompareFrameSortButton_Rarity","AtlasLootCompareFrameSortButton_1","AtlasLootCompareFrameSortButton_2","AtlasLootCompareFrameSortButton_3","AtlasLootCompareFrameSortButton_4","AtlasLootCompareFrameSortButton_5","AtlasLootCompareFrameSortButton_6"}

local buttons = {"AtlasLoot_AtlasInfoFrame_ToggleALButton","AtlasLootPanelSearch_SearchButton","AtlasLootDefaultFrame_CompareFrame","AtlasLootPanelSearch_ClearButton","AtlasLootPanelSearch_LastResultButton","AtlasLoot10Man25ManSwitch","AtlasLootItemsFrame_BACK","AtlasLootCompareFrameSearch_ClearButton","AtlasLootCompareFrameSearch_SearchButton","AtlasLootCompareFrame_WishlistButton","AtlasLootCompareFrame_CloseButton2"}

local function AL_OnShow(self, event, ...)
	AtlasLootPanel:Point("TOP", AtlasLootDefaultFrame, "BOTTOM", 0, -1)
	AtlasLootQuickLooksButton:Point("BOTTOM", AtlasLootItemsFrame, "BOTTOM", 53, 33)
	AtlasLootPanelSearch_Box:ClearAllPoints()
	AtlasLootPanelSearch_Box:Point("TOP", AtlasLoot_PanelButton_7, "BOTTOM", 80, -10)
	AtlasLootPanelSearch_SearchButton:Point("LEFT", AtlasLootPanelSearch_Box, "RIGHT", 5, 0)
	AtlasLootPanelSearch_SelectModuel:Point("LEFT", AtlasLootPanelSearch_SearchButton, "RIGHT", 5, 0)
	AtlasLootPanelSearch_ClearButton:Point("LEFT", AtlasLootPanelSearch_SelectModuel, "RIGHT", 5, 0)
	AtlasLootPanelSearch_LastResultButton:Point("LEFT", AtlasLootPanelSearch_ClearButton, "RIGHT", 5, 0)
	AtlasLoot10Man25ManSwitch:Point("BOTTOM", AtlasLootItemsFrame, "BOTTOM", -130, 4)
	if AtlasLoot_PanelButton_2 then AtlasLoot_PanelButton_2:Point("LEFT", AtlasLoot_PanelButton_1, "RIGHT", 1, 0) end
	if AtlasLoot_PanelButton_3 then AtlasLoot_PanelButton_3:Point("LEFT", AtlasLoot_PanelButton_2, "RIGHT", 1, 0) end
	if AtlasLoot_PanelButton_4 then AtlasLoot_PanelButton_4:Point("LEFT", AtlasLoot_PanelButton_3, "RIGHT", 1, 0) end
	if AtlasLoot_PanelButton_5 then AtlasLoot_PanelButton_5:Point("LEFT", AtlasLoot_PanelButton_4, "RIGHT", 1, 0) end
	if AtlasLoot_PanelButton_6 then AtlasLoot_PanelButton_6:Point("LEFT", AtlasLoot_PanelButton_5, "RIGHT", 1, 0) end
	if AtlasLoot_PanelButton_8 then AtlasLoot_PanelButton_8:Point("LEFT", AtlasLoot_PanelButton_7, "RIGHT", 1, 0) end
	if AtlasLoot_PanelButton_9 then AtlasLoot_PanelButton_9:Point("LEFT", AtlasLoot_PanelButton_8, "RIGHT", 1, 0) end
	if AtlasLoot_PanelButton_10 then AtlasLoot_PanelButton_10:Point("LEFT", AtlasLoot_PanelButton_9, "RIGHT", 1, 0) end
	if AtlasLoot_PanelButton_11 then AtlasLoot_PanelButton_11:Point("LEFT", AtlasLoot_PanelButton_10, "RIGHT", 1, 0) end
	if AtlasLoot_PanelButton_12 then AtlasLoot_PanelButton_12:Point("LEFT", AtlasLoot_PanelButton_11, "RIGHT", 1, 0) end
	AtlasLootCompareFrameSortButton_Rarity:Point("LEFT", AtlasLootCompareFrameSortButton_Name, "RIGHT", 1, 0)
	AtlasLootCompareFrameSortButton_Rarity:Width(80)
	AtlasLootCompareFrameSortButton_Name:Width(80)
	AtlasLootCompareFrameSortButton_1:Point("LEFT", AtlasLootCompareFrameSortButton_Rarity, "RIGHT", 1, 0)
	AtlasLootCompareFrameSortButton_2:Point("LEFT", AtlasLootCompareFrameSortButton_1, "RIGHT", 1, 0)
	AtlasLootCompareFrameSortButton_3:Point("LEFT", AtlasLootCompareFrameSortButton_2, "RIGHT", 1, 0)
	AtlasLootCompareFrameSortButton_4:Point("LEFT", AtlasLootCompareFrameSortButton_3, "RIGHT", 1, 0)
	AtlasLootCompareFrameSortButton_5:Point("LEFT", AtlasLootCompareFrameSortButton_4, "RIGHT", 1, 0)
	AtlasLootCompareFrameSortButton_6:Point("LEFT", AtlasLootCompareFrameSortButton_5, "RIGHT", 1, 0)
	AtlasLootCompareFrame_CloseButton2:Point("BOTTOMRIGHT", AtlasLootCompareFrame, "BOTTOMRIGHT", -7, 10)
	AtlasLootCompareFrame_WishlistButton:Point("RIGHT", AtlasLootCompareFrame_CloseButton2, "LEFT", -1, 0)
	AtlasLootCompareFrameSearch_SearchButton:Point("LEFT", AtlasLootCompareFrameSearch_Box, "RIGHT", 5, 0)
	AtlasLootCompareFrameSearch_SelectModuel:Point("LEFT", AtlasLootCompareFrameSearch_SearchButton, "RIGHT", 5, 0)
	AtlasLootDefaultFrame_CloseButton:ClearAllPoints()
	AtlasLootDefaultFrame_CloseButton:SetPoint("TOPRIGHT", AtlasLootDefaultFrame, "TOPRIGHT", -5 -2)
	AtlasLootDefaultFrame:SetFrameLevel(0)
	AtlasLootItemsFrame:SetFrameLevel(AtlasLootDefaultFrame:GetFrameLevel()+1)
	for i = 1, 30 do if _G["AtlasLootDefaultFrame_ScrollLine"..i] then _G["AtlasLootDefaultFrame_ScrollLine"..i]:SetFrameLevel(AtlasLootDefaultFrame:GetFrameLevel()+1)end end 

	if(AtlasLootDefaultFrame_PackageSelect) then
		AtlasLootDefaultFrame_PackageSelect:SetFrameLevel(AtlasLootDefaultFrame:GetFrameLevel()+1)
	end
	AtlasLootDefaultFrame_InstanceSelect:SetFrameLevel(AtlasLootDefaultFrame:GetFrameLevel()+1)
	AtlasLoot_AtlasInfoFrame_ToggleALButton:SetFrameLevel(AtlasLootDefaultFrame:GetFrameLevel()+1)
	AtlasLootDefaultFrame_CompareFrame:SetFrameLevel(AtlasLootDefaultFrame:GetFrameLevel()+1)
	AtlasLootPanelSearch_Box:SetHeight(16)
	AtlasLootPanel:SetWidth(921)
end

local function Nine_IsThere(self, elapsed)
	self.timeLapse = self.timeLapse + elapsed
	if(self.timeLapse < 2) then 
		return 
	else
		self.timeLapse = 0
	end
	for i = 1, 9 do local f = _G["AtlasLootCompareFrameSortButton_"..i]f:SetWidth(44.44)end 
	for _, object in pairs(nineisthere) do STYLE:ApplyFrameStyle(_G[object]) end 
	AtlasLootCompareFrameSortButton_7:Point("LEFT", AtlasLootCompareFrameSortButton_6, "RIGHT", 1, 0)
	AtlasLootCompareFrameSortButton_8:Point("LEFT", AtlasLootCompareFrameSortButton_7, "RIGHT", 1, 0)
	AtlasLootCompareFrameSortButton_9:Point("LEFT", AtlasLootCompareFrameSortButton_8, "RIGHT", 1, 0)
end

local function Compare_OnShow(self, event, ...)
	for i = 1, 6 do _G["AtlasLootCompareFrameSortButton_"..i]:SetWidth(40)end 
	local Nine = AtlasLootCompareFrameSortButton_9
	if Nine ~= nil then
		Nine.timeLapse = 0
		Nine:SetScript("OnUpdate", Nine_IsThere)
	end 
end

local _hook_ALPanel = function(self,_,parent,_,_,_,breaker)
	if not breaker then 
		self:ClearAllPoints()
		self:SetPoint("TOP",parent,"BOTTOM",0,-1,true)
	end 
end

local _hook_OnUpdate = function(self, elapsed)
	self.timeLapse = self.timeLapse + elapsed
	if(self.timeLapse < 2) then 
		return 
	else
		self.timeLapse = 0
	end
	self:SetWidth(AtlasLootDefaultFrame:GetWidth()) 
end


local function StyleAtlasLoot(event, addon)
	assert(AtlasLootPanel, "AddOn Not Loaded")

	for _, object in pairs(StripAllTextures) do _G[object]:RemoveTextures()end 
	for _, object in pairs(SetTemplateDefault) do STYLE:ApplyFrameStyle(_G[object], "Default")end 
	for _, button in pairs(buttons) do _G[button]:SetButtonTemplate()end 

	-- Manipulate the main frames
	STYLE:ApplyFrameStyle(_G["AtlasLootDefaultFrame"], "Action");
	STYLE:ApplyUnderlayStyle(_G["AtlasLootItemsFrame"], "Inset");
	STYLE:ApplyFrameStyle(_G["AtlasLootPanel"], "Default");
	hooksecurefunc(_G["AtlasLootPanel"], "SetPoint", _hook_ALPanel);

	_G["AtlasLootPanel"]:SetPoint("TOP",_G["AtlasLootDefaultFrame"],"BOTTOM",0,-1);
	-- Back to the rest
	STYLE:ApplyFrameStyle(_G["AtlasLootCompareFrame"], "Transparent");
	if AtlasLoot_PanelButton_1 then AtlasLoot_PanelButton_1:SetButtonTemplate() end
	if AtlasLoot_PanelButton_2 then AtlasLoot_PanelButton_2:SetButtonTemplate() end
	if AtlasLoot_PanelButton_3 then AtlasLoot_PanelButton_3:SetButtonTemplate() end
	if AtlasLoot_PanelButton_4 then AtlasLoot_PanelButton_4:SetButtonTemplate() end
	if AtlasLoot_PanelButton_5 then AtlasLoot_PanelButton_5:SetButtonTemplate() end
	if AtlasLoot_PanelButton_6 then AtlasLoot_PanelButton_6:SetButtonTemplate() end
	if AtlasLoot_PanelButton_7 then AtlasLoot_PanelButton_7:SetButtonTemplate() end
	if AtlasLoot_PanelButton_8 then AtlasLoot_PanelButton_8:SetButtonTemplate() end
	if AtlasLoot_PanelButton_9 then AtlasLoot_PanelButton_9:SetButtonTemplate() end
	if AtlasLoot_PanelButton_10 then AtlasLoot_PanelButton_10:SetButtonTemplate() end
	if AtlasLoot_PanelButton_11 then AtlasLoot_PanelButton_11:SetButtonTemplate() end
	if AtlasLoot_PanelButton_12 then AtlasLoot_PanelButton_12:SetButtonTemplate() end

	for i = 1, 15 do local f = _G["AtlasLootCompareFrameMainFilterButton"..i]f:RemoveTextures() end 

	STYLE:ApplyCloseButtonStyle(AtlasLootDefaultFrame_CloseButton)
	STYLE:ApplyCloseButtonStyle(AtlasLootCompareFrame_CloseButton)
	STYLE:ApplyCloseButtonStyle(AtlasLootCompareFrame_CloseButton_Wishlist)
	STYLE:ApplyPaginationStyle(AtlasLootQuickLooksButton)
	STYLE:ApplyPaginationStyle(AtlasLootItemsFrame_NEXT)
	AtlasLootItemsFrame_NEXT:SetWidth(25)
	AtlasLootItemsFrame_NEXT:SetHeight(25)
	STYLE:ApplyPaginationStyle(AtlasLootItemsFrame_PREV)
	AtlasLootItemsFrame_PREV:SetWidth(25)
	AtlasLootItemsFrame_PREV:SetHeight(25)
	STYLE:ApplyPaginationStyle(AtlasLootPanelSearch_SelectModuel)	
	STYLE:ApplyPaginationStyle(AtlasLootCompareFrameSearch_SelectModuel)

	if(AtlasLootDefaultFrame_PackageSelect) then
		STYLE:ApplyDropdownStyle(AtlasLootDefaultFrame_PackageSelect)
		AtlasLootDefaultFrame_PackageSelect:SetWidth(240)
		AtlasLootDefaultFrame_PackageSelect:SetPoint("TOPLEFT", AtlasLootDefaultFrame, "TOPLEFT", 50, -50)
	end

	STYLE:ApplyDropdownStyle(AtlasLootDefaultFrame_ModuleSelect,240)
	STYLE:ApplyDropdownStyle(AtlasLootDefaultFrame_InstanceSelect,240)
	
	STYLE:ApplyDropdownStyle(AtlasLootCompareFrameSearch_StatsListDropDown)
	AtlasLootCompareFrameSearch_StatsListDropDown:SetWidth(240)
	STYLE:ApplyDropdownStyle(AtlasLootCompareFrame_WishlistDropDown)
	AtlasLootCompareFrame_WishlistDropDown:SetWidth(240)
	AtlasLootPanelSearch_Box:SetEditboxTemplate()
	AtlasLootCompareFrameSearch_Box:SetEditboxTemplate()

	if AtlasLootFilterCheck then 
		AtlasLootFilterCheck:SetCheckboxTemplate(true) 
	end
	if AtlasLootItemsFrame_Heroic then 
		AtlasLootItemsFrame_Heroic:SetCheckboxTemplate(true) 
	end
	if AtlasLootCompareFrameSearch_FilterCheck then AtlasLootCompareFrameSearch_FilterCheck:SetCheckboxTemplate(true)
	end
	if AtlasLootItemsFrame_RaidFinder then 
		AtlasLootItemsFrame_RaidFinder:SetCheckboxTemplate(true) 
	end
	if AtlasLootItemsFrame_Thunderforged then 
		AtlasLootItemsFrame_Thunderforged:SetCheckboxTemplate(true) 
	end

	AtlasLootPanel.Titel:SetTextColor(23/255, 132/255, 209/255)
	AtlasLootPanel.Titel:SetPoint("BOTTOM", AtlasLootPanel.TitelBg, "BOTTOM", 0, 40)
	STYLE:ApplyScrollFrameStyle(AtlasLootCompareFrame_ScrollFrameItemFrameScrollBar)
	STYLE:ApplyScrollFrameStyle(AtlasLootCompareFrame_WishlistScrollFrameScrollBar)
	AtlasLootDefaultFrame:HookScript("OnShow", AL_OnShow)
	AtlasLootCompareFrame:HookScript("OnShow", Compare_OnShow)
	AtlasLootPanel.timeLapse = 0;

	--AtlasLootPanel:HookScript("OnUpdate", _hook_OnUpdate)

	if(AtlasLootTooltip:GetName() ~= "GameTooltip") then 
		STYLE:ApplyTooltipStyle(AtlasLootTooltip)
	end
end
STYLE:SaveAddonStyle("AtlasLoot", StyleAtlasLoot, nil, true)