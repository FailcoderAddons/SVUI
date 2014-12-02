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
--[[ ADDON ]]--
local SV = _G.SVUI;
local L = SV.L;
local PLUGIN = select(2, ...);
local Schema = PLUGIN.Schema;
--[[ 
########################################################## 
HELPERS
##########################################################
]]--
local FAV_ICON = [[Interface\Addons\SVUI\assets\artwork\Icons\GENERIC-STAR]]

local function PetJournal_UpdateMounts()
	for b = 1, #MountJournal.ListScrollFrame.buttons do 
		local d = _G["MountJournalListScrollFrameButton"..b]
		local e = _G["MountJournalListScrollFrameButton"..b.."Name"]
		if d.selectedTexture:IsShown() then
			e:SetTextColor(1, 1, 0)
			if d.Panel then
				d:SetBackdropBorderColor(1, 1, 0)
			end 
			if d.IconShadow then
				d.IconShadow:SetBackdropBorderColor(1, 1, 0)
			end 
		else
			e:SetTextColor(1, 1, 1)
			if d.Panel then
				d:SetBackdropBorderColor(0,0,0,1)
			end 
			if d.IconShadow then
				d.IconShadow:SetBackdropBorderColor(0,0,0,1)
			end 
		end 
	end 
end 

local function PetJournal_UpdatePets()
	local u = PetJournal.listScroll.buttons;
	local isWild = PetJournal.isWild;
	for b = 1, #u do 
		local v = u[b].index;
		if not v then
			break 
		end 
		local d = _G["PetJournalListScrollFrameButton"..b]
		local e = _G["PetJournalListScrollFrameButton"..b.."Name"]
		local w, x, y, z, level, favorite, A, B, C, D, E, F, G, H, I = C_PetJournal.GetPetInfoByIndex(v, isWild)
		if w ~= nil then 
			local J, K, L, M, N = C_PetJournal.GetPetStats(w)
			if d.selectedTexture:IsShown() then
				e:SetTextColor(1, 1, 0)
			else
				e:SetTextColor(1, 1, 1)
			end 
			if N then 
				local color = ITEM_QUALITY_COLORS[N-1]
				if d.Panel then
					d:SetBackdropBorderColor(color.r, color.g, color.b)
				end 
				if d.IconShadow then
					d.IconShadow:SetBackdropBorderColor(color.r, color.g, color.b)
				end 
			else
				if d.Panel then
					d:SetBackdropBorderColor(1, 1, 0, 0.5)
				end 
				if d.IconShadow then
					d.IconShadow:SetBackdropBorderColor(1, 1, 0, 0.5)
				end 
			end 
		end
	end 
end 
--[[ 
########################################################## 
FRAME PLUGINR
##########################################################
]]--
local function PetJournalStyle()
	if PLUGIN.db.blizzard.enable ~= true or PLUGIN.db.blizzard.mounts ~= true then return end 

	PLUGIN:ApplyWindowStyle(PetJournalParent)

	PetJournalParentPortrait:Hide()
	PLUGIN:ApplyTabStyle(PetJournalParentTab1)
	PLUGIN:ApplyTabStyle(PetJournalParentTab2)
	PLUGIN:ApplyCloseButtonStyle(PetJournalParentCloseButton)

	MountJournal:RemoveTextures()
	MountJournal.LeftInset:RemoveTextures()
	MountJournal.RightInset:RemoveTextures()
	MountJournal.MountDisplay:RemoveTextures()
	MountJournal.MountDisplay.ShadowOverlay:RemoveTextures()
	MountJournal.MountCount:RemoveTextures()
	MountJournalListScrollFrame:RemoveTextures()
	MountJournalMountButton:RemoveTextures()
	MountJournalMountButton:SetButtonTemplate()
	MountJournalSearchBox:SetEditboxTemplate()

	PLUGIN:ApplyScrollFrameStyle(MountJournalListScrollFrameScrollBar)
	MountJournal.MountDisplay:SetFixedPanelTemplate("Model")

	local buttons = MountJournal.ListScrollFrame.buttons
	for i = 1, #buttons do
		local button = buttons[i]
		if(button) then
			PLUGIN:ApplyItemButtonStyle(button, nil, true, true)
			local bar = _G["SVUI_MountSelectBar"..i]
			if(bar) then bar:SetParent(button.Panel) end
			if(button.favorite) then
				local fg = CreateFrame("Frame", nil, button)
				fg:SetAllPoints(favorite)
				fg:SetFrameLevel(button:GetFrameLevel() + 30)
				button.favorite:SetParent(fg)
				button.favorite:SetTexture([[Interface\Addons\SVUI\assets\artwork\Icons\GENERIC-STAR]])
			end
		end
	end

	hooksecurefunc("MountJournal_UpdateMountList", PetJournal_UpdateMounts)
	MountJournalListScrollFrame:HookScript("OnVerticalScroll", PetJournal_UpdateMounts)
	MountJournalListScrollFrame:HookScript("OnMouseWheel", PetJournal_UpdateMounts)
	PetJournalSummonButton:RemoveTextures()
	PetJournalFindBattle:RemoveTextures()
	PetJournalSummonButton:SetButtonTemplate()
	PetJournalFindBattle:SetButtonTemplate()
	PetJournalRightInset:RemoveTextures()
	PetJournalLeftInset:RemoveTextures()

	for i = 1, 3 do 
		local button = _G["PetJournalLoadoutPet" .. i .. "HelpFrame"]
		button:RemoveTextures()
	end 

	PetJournalTutorialButton:Die()
	PetJournal.PetCount:RemoveTextures()
	PetJournalSearchBox:SetEditboxTemplate()
	PetJournalFilterButton:RemoveTextures(true)
	PetJournalFilterButton:SetButtonTemplate()
	PetJournalListScrollFrame:RemoveTextures()
	PLUGIN:ApplyScrollFrameStyle(PetJournalListScrollFrameScrollBar)

	for i = 1, #PetJournal.listScroll.buttons do 
		local button = _G["PetJournalListScrollFrameButton" .. i]
		local favorite = _G["PetJournalListScrollFrameButton" .. i .. "Favorite"]
		PLUGIN:ApplyItemButtonStyle(button, false, true)
		if(favorite) then
			local fg = CreateFrame("Frame", nil, button)
			fg:SetAllPoints(favorite)
			fg:SetFrameLevel(button:GetFrameLevel() + 30)
			favorite:SetParent(fg)
			button.dragButton.favorite:SetParent(fg)
			favorite:SetTexture([[Interface\Addons\SVUI\assets\artwork\Icons\GENERIC-STAR]])
			favorite:SetTexCoord(0,1,0,1)
		end
		
		button.dragButton.levelBG:SetAlpha(0)
		button.dragButton.level:SetParent(button)
		button.petTypeIcon:SetParent(button.Panel)
	end 

	hooksecurefunc('PetJournal_UpdatePetList', PetJournal_UpdatePets)
	PetJournalListScrollFrame:HookScript("OnVerticalScroll", PetJournal_UpdatePets)
	PetJournalListScrollFrame:HookScript("OnMouseWheel", PetJournal_UpdatePets)
	PetJournalAchievementStatus:DisableDrawLayer('BACKGROUND')
	PLUGIN:ApplyItemButtonStyle(PetJournalHealPetButton, true)
	PetJournalHealPetButton.texture:SetTexture([[Interface\Icons\spell_magic_polymorphrabbit]])
	PetJournalLoadoutBorder:RemoveTextures()

	for b = 1, 3 do
		local pjPet = _G['PetJournalLoadoutPet'..b]
		pjPet:RemoveTextures()
		pjPet.petTypeIcon:SetPoint('BOTTOMLEFT', 2, 2)
		pjPet.dragButton:WrapOuter(_G['PetJournalLoadoutPet'..b..'Icon'])
		pjPet.hover = true;
		pjPet.pushed = true;
		pjPet.checked = true;
		PLUGIN:ApplyItemButtonStyle(pjPet, nil, nil, true)
		pjPet.setButton:RemoveTextures()
		_G['PetJournalLoadoutPet'..b..'HealthFrame'].healthBar:RemoveTextures()
		_G['PetJournalLoadoutPet'..b..'HealthFrame'].healthBar:SetPanelTemplate('Default')
		_G['PetJournalLoadoutPet'..b..'HealthFrame'].healthBar:SetStatusBarTexture(SV.Media.bar.default)
		_G['PetJournalLoadoutPet'..b..'XPBar']:RemoveTextures()
		_G['PetJournalLoadoutPet'..b..'XPBar']:SetPanelTemplate('Default')
		_G['PetJournalLoadoutPet'..b..'XPBar']:SetStatusBarTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
		_G['PetJournalLoadoutPet'..b..'XPBar']:SetFrameLevel(_G['PetJournalLoadoutPet'..b..'XPBar']:GetFrameLevel()+2)
		for v = 1, 3 do 
			local s = _G['PetJournalLoadoutPet'..b..'Spell'..v]
			PLUGIN:ApplyItemButtonStyle(s)
			s.FlyoutArrow:SetTexture([[Interface\Buttons\ActionBarFlyoutButton]])
			_G['PetJournalLoadoutPet'..b..'Spell'..v..'Icon']:FillInner(s)
			s.Panel:SetFrameLevel(s:GetFrameLevel() + 1)
			_G['PetJournalLoadoutPet'..b..'Spell'..v..'Icon']:SetParent(s.Panel)
		end 
	end 

	PetJournalSpellSelect:RemoveTextures()

	for b = 1, 2 do 
		local Q = _G['PetJournalSpellSelectSpell'..b]
		PLUGIN:ApplyItemButtonStyle(Q)
		_G['PetJournalSpellSelectSpell'..b..'Icon']:FillInner(Q)
		_G['PetJournalSpellSelectSpell'..b..'Icon']:SetDrawLayer('BORDER')
	end 

	PetJournalPetCard:RemoveTextures()
	PLUGIN:ApplyItemButtonStyle(PetJournalPetCard, nil, nil, true)
	PetJournalPetCardInset:RemoveTextures()
	PetJournalPetCardPetInfo.levelBG:SetAlpha(0)
	PetJournalPetCardPetInfoIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	PLUGIN:ApplyItemButtonStyle(PetJournalPetCardPetInfo, nil, true, true)

	local fg = CreateFrame("Frame", nil, PetJournalPetCardPetInfo)
	fg:SetSize(40,40)
	fg:SetPoint("TOPLEFT", PetJournalPetCardPetInfo, "TOPLEFT", -1, 1)
	fg:SetFrameLevel(PetJournalPetCardPetInfo:GetFrameLevel() + 30)

	PetJournalPetCardPetInfo.favorite:SetParent(fg)
	PetJournalPetCardPetInfo.Panel:WrapOuter(PetJournalPetCardPetInfoIcon)
	PetJournalPetCardPetInfoIcon:SetParent(PetJournalPetCardPetInfo.Panel)
	PetJournalPetCardPetInfo.level:SetParent(PetJournalPetCardPetInfo.Panel)

	local R = PetJournalPrimaryAbilityTooltip;R.Background:SetTexture(0,0,0,0)
	if R.Delimiter1 then
		R.Delimiter1:SetTexture(0,0,0,0)
		R.Delimiter2:SetTexture(0,0,0,0)
	end

	R.BorderTop:SetTexture(0,0,0,0)
	R.BorderTopLeft:SetTexture(0,0,0,0)
	R.BorderTopRight:SetTexture(0,0,0,0)
	R.BorderLeft:SetTexture(0,0,0,0)
	R.BorderRight:SetTexture(0,0,0,0)
	R.BorderBottom:SetTexture(0,0,0,0)
	R.BorderBottomRight:SetTexture(0,0,0,0)
	R.BorderBottomLeft:SetTexture(0,0,0,0)
	R:SetFixedPanelTemplate("Transparent", true)

	for b = 1, 6 do 
		local S = _G['PetJournalPetCardSpell'..b]
		S:SetFrameLevel(S:GetFrameLevel() + 2)
		S:DisableDrawLayer('BACKGROUND')
		S:SetPanelTemplate('Transparent')
		S.Panel:SetAllPoints()
		S.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		S.icon:FillInner(S.Panel)
	end

	PetJournalPetCardHealthFrame.healthBar:RemoveTextures()
	PetJournalPetCardHealthFrame.healthBar:SetPanelTemplate('Default')
	PetJournalPetCardHealthFrame.healthBar:SetStatusBarTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
	PetJournalPetCardXPBar:RemoveTextures()
	PetJournalPetCardXPBar:SetPanelTemplate('Default')
	PetJournalPetCardXPBar:SetStatusBarTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])

	PLUGIN:ApplyTabStyle(PetJournalParentTab3)
	ToyBox:RemoveTextures()
	ToyBoxProgressBar:SetPanelTemplate("Bar", true)
	ToyBoxSearchBox:SetEditboxTemplate()
	ToyBoxFilterButton:RemoveTextures()
	ToyBoxFilterButton:SetButtonTemplate()
	ToyBoxIconsFrame:RemoveTextures()
	ToyBoxIconsFrame:SetFixedPanelTemplate('Model')

	MountJournalFilterButton:RemoveTextures()
	MountJournalFilterButton:SetButtonTemplate()

	MountJournal.SummonRandomFavoriteButton:RemoveTextures()
	MountJournal.SummonRandomFavoriteButton:SetSlotTemplate(true, 2, 0, 0, 0.5)
	MountJournal.SummonRandomFavoriteButton.texture:SetTexture([[Interface\ICONS\ACHIEVEMENT_GUILDPERK_MOUNTUP]])
	MountJournal.SummonRandomFavoriteButton.texture:SetTexCoord(0.1, 0.9, 0.1, 0.9)

	for i = 1, 18 do
		local gName = ("ToySpellButton%d"):format(i)
		local button = _G[gName]
		if(button) then
			button:SetButtonTemplate()
		end
	end
end 
--[[ 
########################################################## 
PLUGIN LOADING
##########################################################
]]--
PLUGIN:SaveBlizzardStyle("Blizzard_PetJournal", PetJournalStyle)