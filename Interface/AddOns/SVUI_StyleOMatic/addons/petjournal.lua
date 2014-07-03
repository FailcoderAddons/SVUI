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
local function PetJournal_UpdateMounts()
	for b = 1, #MountJournal.ListScrollFrame.buttons do 
		local d = _G["MountJournalListScrollFrameButton"..b]
		local e = _G["MountJournalListScrollFrameButton"..b.."Name"]
		if d.selectedTexture:IsShown() then
			e:SetTextColor(1, 1, 0)
			if d.Panel then
				d:SetBackdropBorderColor(1, 1, 0)
			end;
			if d.IconShadow then
				d.IconShadow:SetBackdropBorderColor(1, 1, 0)
			end 
		else
			e:SetTextColor(1, 1, 1)
			if d.Panel then
				d:SetBackdropBorderColor(0,0,0,1)
			end;
			if d.IconShadow then
				d.IconShadow:SetBackdropBorderColor(0,0,0,1)
			end 
		end 
	end 
end;

local function PetJournal_UpdatePets()
	local u = PetJournal.listScroll.buttons;
	local isWild = PetJournal.isWild;
	for b = 1, #u do 
		local v = u[b].index;
		if not v then
			break 
		end;
		local d = _G["PetJournalListScrollFrameButton"..b]
		local e = _G["PetJournalListScrollFrameButton"..b.."Name"]
		local w, x, y, z, level, favorite, A, B, C, D, E, F, G, H, I = C_PetJournal.GetPetInfoByIndex(v, isWild)
		if w ~= nil then 
			local J, K, L, M, N = C_PetJournal.GetPetStats(w)
			if d.selectedTexture:IsShown() then
				e:SetTextColor(1, 1, 0)
			else
				e:SetTextColor(1, 1, 1)
			end;
			if N then 
				local color = ITEM_QUALITY_COLORS[N-1]
				if d.Panel then
					d.Panel:SetBackdropBorderColor(color.r, color.g, color.b)
				end;
				if d.IconShadow then
					d.IconShadow:SetBackdropBorderColor(color.r, color.g, color.b)
				end 
			else
				if d.Panel then
					d.Panel:SetBackdropBorderColor(1, 1, 0, 0.5)
				end;
				if d.IconShadow then
					d.IconShadow:SetBackdropBorderColor(1, 1, 0, 0.5)
				end 
			end 
		end
	end 
end;
--[[ 
########################################################## 
FRAME STYLER
##########################################################
]]--
local function PetJournalStyle()
	if SuperVillain.db.SVStyle.blizzard.enable ~= true or SuperVillain.db.SVStyle.blizzard.mounts ~= true then return end;
	PetJournalParent:Formula409()
	PetJournalParent:SetPanelTemplate("Halftone")
	PetJournalParentPortrait:Hide()
	MOD:ApplyTabStyle(PetJournalParentTab1)
	MOD:ApplyTabStyle(PetJournalParentTab2)
	MOD:ApplyCloseButtonStyle(PetJournalParentCloseButton)
	MountJournal:Formula409()
	MountJournal.LeftInset:Formula409()
	MountJournal.RightInset:Formula409()
	MountJournal.MountDisplay:Formula409()
	MountJournal.MountDisplay.ShadowOverlay:Formula409()
	MountJournal.MountCount:Formula409()
	MountJournalListScrollFrame:Formula409()
	MountJournalMountButton:SetButtonTemplate()
	MountJournalSearchBox:SetEditboxTemplate()
	MOD:ApplyScrollStyle(MountJournalListScrollFrameScrollBar)
	MountJournal.MountDisplay:SetFixedPanelTemplate("Comic")
	for b = 1, #MountJournal.ListScrollFrame.buttons do
		MOD:ApplyLinkButtonStyle(_G["MountJournalListScrollFrameButton"..b], false, true)
	end;

	hooksecurefunc("MountJournal_UpdateMountList", PetJournal_UpdateMounts)
	MountJournalListScrollFrame:HookScript("OnVerticalScroll", PetJournal_UpdateMounts)
	MountJournalListScrollFrame:HookScript("OnMouseWheel", PetJournal_UpdateMounts)
	PetJournalSummonButton:Formula409()
	PetJournalFindBattle:Formula409()
	PetJournalSummonButton:SetButtonTemplate()
	PetJournalFindBattle:SetButtonTemplate()
	PetJournalRightInset:Formula409()
	PetJournalLeftInset:Formula409()

	for b = 1, 3 do 
		local s = _G["PetJournalLoadoutPet"..b.."HelpFrame"]s:Formula409()
	end;

	PetJournalTutorialButton:MUNG()
	PetJournal.PetCount:Formula409()
	PetJournalSearchBox:SetEditboxTemplate()
	PetJournalFilterButton:Formula409(true)
	PetJournalFilterButton:SetButtonTemplate()
	PetJournalListScrollFrame:Formula409()
	MOD:ApplyScrollStyle(PetJournalListScrollFrameScrollBar)

	for b = 1, #PetJournal.listScroll.buttons do 
		local d = _G["PetJournalListScrollFrameButton"..b]
		local f = _G["PetJournalListScrollFrameButton"..b.."Favorite"]
		MOD:ApplyLinkButtonStyle(d, false, true)
		if(f) then
			local fg = CreateFrame("Frame", nil, d)
			fg:SetSize(40,40)
			fg:SetPoint("TOPLEFT", d, "TOPLEFT", -1, 1)
			fg:SetFrameLevel(d:GetFrameLevel() + 30)
			f:SetParent(fg)
			d.dragButton.favorite:SetParent(fg)
		end
		d.dragButton.levelBG:SetAlpha(0)
		d.dragButton.level:SetParent(d)
	end;

	hooksecurefunc('PetJournal_UpdatePetList', PetJournal_UpdatePets)
	PetJournalListScrollFrame:HookScript("OnVerticalScroll", PetJournal_UpdatePets)
	PetJournalListScrollFrame:HookScript("OnMouseWheel", PetJournal_UpdatePets)
	PetJournalAchievementStatus:DisableDrawLayer('BACKGROUND')
	MOD:ApplyLinkButtonStyle(PetJournalHealPetButton, true)
	PetJournalHealPetButton.texture:SetTexture([[Interface\Icons\spell_magic_polymorphrabbit]])
	PetJournalLoadoutBorder:Formula409()

	for b = 1, 3 do
		local pjPet = _G['PetJournalLoadoutPet'..b]
		pjPet:Formula409()
		pjPet:SetPanelTemplate("Inset")
		local level = pjPet:GetFrameLevel()
		if(level > 0) then 
			pjPet.Panel:SetFrameLevel(level - 1)
		else 
			pjPet.Panel:SetFrameLevel(0)
		end
		pjPet.petTypeIcon:SetPoint('BOTTOMLEFT', 2, 2)
		pjPet.dragButton:WrapOuter(_G['PetJournalLoadoutPet'..b..'Icon'])
		pjPet.hover = true;
		pjPet.pushed = true;
		pjPet.checked = true;
		MOD:ApplyLinkButtonStyle(pjPet)
		pjPet.setButton:Formula409()
		_G['PetJournalLoadoutPet'..b..'HealthFrame'].healthBar:Formula409()
		_G['PetJournalLoadoutPet'..b..'HealthFrame'].healthBar:SetPanelTemplate('Default')
		_G['PetJournalLoadoutPet'..b..'HealthFrame'].healthBar:SetStatusBarTexture(SuperVillain.Media.bar.default)
		_G['PetJournalLoadoutPet'..b..'XPBar']:Formula409()
		_G['PetJournalLoadoutPet'..b..'XPBar']:SetPanelTemplate('Default')
		_G['PetJournalLoadoutPet'..b..'XPBar']:SetStatusBarTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
		_G['PetJournalLoadoutPet'..b..'XPBar']:SetFrameLevel(_G['PetJournalLoadoutPet'..b..'XPBar']:GetFrameLevel()+2)
		for v = 1, 3 do 
			local s = _G['PetJournalLoadoutPet'..b..'Spell'..v]
			MOD:ApplyLinkButtonStyle(s)
			s.FlyoutArrow:SetTexture([[Interface\Buttons\ActionBarFlyoutButton]])
			_G['PetJournalLoadoutPet'..b..'Spell'..v..'Icon']:FillInner(s)
			s.Panel:SetFrameLevel(s:GetFrameLevel() + 1)
			_G['PetJournalLoadoutPet'..b..'Spell'..v..'Icon']:SetParent(s.Panel)
		end 
	end;

	PetJournalSpellSelect:Formula409()

	for b = 1, 2 do 
		local Q = _G['PetJournalSpellSelectSpell'..b]
		MOD:ApplyLinkButtonStyle(Q)
		_G['PetJournalSpellSelectSpell'..b..'Icon']:FillInner(Q)
		_G['PetJournalSpellSelectSpell'..b..'Icon']:SetDrawLayer('BORDER')
	end;

	PetJournalPetCard:Formula409()
	PetJournalPetCard:SetPanelTemplate("Inset")
	local level = PetJournalPetCard:GetFrameLevel()
	if(level > 0) then 
		PetJournalPetCard.Panel:SetFrameLevel(level - 1)
	else 
		PetJournalPetCard.Panel:SetFrameLevel(0)
	end
	PetJournalPetCardInset:Formula409()
	PetJournalPetCardPetInfo.levelBG:SetAlpha(0)
	PetJournalPetCardPetInfoIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	PetJournalPetCardPetInfo:SetPanelTemplate('Transparent')
	local fg = CreateFrame("Frame", nil, PetJournalPetCardPetInfo)
	fg:SetSize(40,40)
	fg:SetPoint("TOPLEFT", PetJournalPetCardPetInfo, "TOPLEFT", -1, 1)
	fg:SetFrameLevel(PetJournalPetCardPetInfo:GetFrameLevel() + 30)
	PetJournalPetCardPetInfo.favorite:SetParent(fg)
	PetJournalPetCardPetInfo.Panel:WrapOuter(PetJournalPetCardPetInfoIcon)
	PetJournalPetCardPetInfoIcon:SetParent(PetJournalPetCardPetInfo.Panel)
	PetJournalPetCardPetInfo.level:SetParent(PetJournalPetCardPetInfo.Panel)
	local R = PetJournalPrimaryAbilityTooltip;R.Background:SetTexture(nil)
	if R.Delimiter1 then
		R.Delimiter1:SetTexture(nil)
		R.Delimiter2:SetTexture(nil)
	end;
	R.BorderTop:SetTexture(nil)
	R.BorderTopLeft:SetTexture(nil)
	R.BorderTopRight:SetTexture(nil)
	R.BorderLeft:SetTexture(nil)
	R.BorderRight:SetTexture(nil)
	R.BorderBottom:SetTexture(nil)
	R.BorderBottomRight:SetTexture(nil)
	R.BorderBottomLeft:SetTexture(nil)
	R:SetFixedPanelTemplate("Transparent", true)
	for b = 1, 6 do 
		local S = _G['PetJournalPetCardSpell'..b]
		S:SetFrameLevel(S:GetFrameLevel() + 2)
		S:DisableDrawLayer('BACKGROUND')
		S:SetPanelTemplate('Transparent')
		S.Panel:SetAllPoints()
		S.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		S.icon:FillInner(S.Panel)
	end;
	PetJournalPetCardHealthFrame.healthBar:Formula409()
	PetJournalPetCardHealthFrame.healthBar:SetPanelTemplate('Default')
	PetJournalPetCardHealthFrame.healthBar:SetStatusBarTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
	PetJournalPetCardXPBar:Formula409()
	PetJournalPetCardXPBar:SetPanelTemplate('Default')
	PetJournalPetCardXPBar:SetStatusBarTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
end;
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
MOD:SaveBlizzardStyle("Blizzard_PetJournal", PetJournalStyle)