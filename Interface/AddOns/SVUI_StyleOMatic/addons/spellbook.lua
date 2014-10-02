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
local SV = _G["SVUI"];
local L = SV.L;
local STYLE = select(2, ...);
local Schema = STYLE.Schema;
--[[ 
########################################################## 
FRAME LISTS
##########################################################
]]--
local bookFrames = {
	"SpellBookFrame",
	"SpellBookFrameInset",
	"SpellBookSpellIconsFrame", 
	"SpellBookSideTabsFrame", 
	"SpellBookPageNavigationFrame"
}
local proButtons = {
	"PrimaryProfession1SpellButtonTop", 
	"PrimaryProfession1SpellButtonBottom", 
	"PrimaryProfession2SpellButtonTop", 
	"PrimaryProfession2SpellButtonBottom", 
	"SecondaryProfession1SpellButtonLeft", 
	"SecondaryProfession1SpellButtonRight", 
	"SecondaryProfession2SpellButtonLeft", 
	"SecondaryProfession2SpellButtonRight", 
	"SecondaryProfession3SpellButtonLeft", 
	"SecondaryProfession3SpellButtonRight", 
	"SecondaryProfession4SpellButtonLeft", 
	"SecondaryProfession4SpellButtonRight"
}

local proFrames = {
	"PrimaryProfession1", 
	"PrimaryProfession2", 
	"SecondaryProfession1", 
	"SecondaryProfession2", 
	"SecondaryProfession3", 
	"SecondaryProfession4"
}
local proBars = {
	"PrimaryProfession1StatusBar", 
	"PrimaryProfession2StatusBar", 
	"SecondaryProfession1StatusBar", 
	"SecondaryProfession2StatusBar", 
	"SecondaryProfession3StatusBar", 
	"SecondaryProfession4StatusBar"
}
--[[ 
########################################################## 
HELPERS
##########################################################
]]--
local function Tab_OnEnter(this)
	this.backdrop:SetBackdropColor(0.1, 0.8, 0.8)
	this.backdrop:SetBackdropBorderColor(0.1, 0.8, 0.8)
end

local function Tab_OnLeave(this)
	this.backdrop:SetBackdropColor(0,0,0,1)
	this.backdrop:SetBackdropBorderColor(0,0,0,1)
end

local function ChangeTabHelper(this)
	this:RemoveTextures()
	local nTex = this:GetNormalTexture()
	if(nTex) then
		nTex:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		nTex:FillInner()
	end

	this.pushed = true;

	this.backdrop = CreateFrame("Frame", nil, this)
	this.backdrop:WrapOuter(this,1,1)
	this.backdrop:SetFrameLevel(0)
	this.backdrop:SetBackdrop({
		bgFile = [[Interface\BUTTONS\WHITE8X8]], 
        tile = false, 
        tileSize = 0,
        edgeFile = [[Interface\AddOns\SVUI\assets\artwork\Template\GLOW]],
        edgeSize = 3,
        insets = {
            left = 0,
            right = 0,
            top = 0,
            bottom = 0
        }
    });
    this.backdrop:SetBackdropColor(0,0,0,1)
	this.backdrop:SetBackdropBorderColor(0,0,0,1)
	this:SetScript("OnEnter", Tab_OnEnter)
	this:SetScript("OnLeave", Tab_OnLeave)

	local a,b,c,d,e = this:GetPoint()
	this:Point(a,b,c,1,e)
end 

local function GetSpecTabHelper(index)
	local tab = SpellBookCoreAbilitiesFrame.SpecTabs[index]
	if(not tab) then return end
	ChangeTabHelper(tab)
	if index > 1 then 
		local o, Y, Z, h, s = tab:GetPoint()
		tab:ClearAllPoints()
		tab:SetPoint(o, Y, Z, 0, s)
	end 
end 

local function SkillTabUpdateHelper()
	for j = 1, MAX_SKILLLINE_TABS do 
		local S = _G["SpellBookSkillLineTab"..j]
		local h, h, h, h, a0 = GetSpellTabInfo(j)
		if a0 then
			S:GetNormalTexture():FillInner()
			S:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
		end 
	end 
end 

local function AbilityButtonHelper(j)
	local i = SpellBookCoreAbilitiesFrame.Abilities[j]
	if i.styled then return end 
		local x = i.iconTexture;
		if not InCombatLockdown() then
			if not i.properFrameLevel then 
			 	i.properFrameLevel = i:GetFrameLevel() + 1 
			end 
			i:SetFrameLevel(i.properFrameLevel)
		end 
		if not i.styled then
		for j = 1, i:GetNumRegions()do 
			local N = select(j, i:GetRegions())
			if N:GetObjectType() == "Texture"then
				if N:GetTexture() ~= "Interface\\Buttons\\ActionBarFlyoutButton" then 
				 	N:SetTexture(0,0,0,0)
				end 
			end 
		end 
		if i.highlightTexture then 
			hooksecurefunc(i.highlightTexture, "SetTexture", function(k, P, Q, R)
				if P == [[Interface\Buttons\ButtonHilight-Square]] then
					 i.highlightTexture:SetTexture(1, 1, 1, 0.3)
				end 
			end)
		end 
		i.styled = true

		if x then
			x:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			x:ClearAllPoints()
			x:SetAllPoints()
			if not i.Panel then
				 i:SetPanelTemplate("Inset", false, 3, 3, 3)
			end 
		end

		if(i.Name) then i.Name:SetFontObject(NumberFont_Outline_Large) i.Name:SetTextColor(1,1,0) end
		if(i.InfoText) then i.InfoText:SetFontObject(NumberFont_Shadow_Small) i.InfoText:SetTextColor(0.9,0.9,0.9) end
	end  
	i.styled = true 
end 

local function ButtonUpdateHelper(self, strip)
	for j=1, SPELLS_PER_PAGE do
		local name = "SpellButton"..j
		local i = _G[name]
		local x = _G[name.."IconTexture"]
		local spellString = _G[name.."SpellName"];
    	local subSpellString = _G[name.."SubSpellName"];
		if not InCombatLockdown() then
			 i:SetFrameLevel(SpellBookFrame:GetFrameLevel() + 5)
		end 
		if strip then
			for j = 1, i:GetNumRegions()do 
				local N = select(j, i:GetRegions())
				if N:GetObjectType() == "Texture"then
					if N ~= i.FlyoutArrow then 
						N:SetTexture(0,0,0,0)
					end 
				end 
			end 
		end 
		if _G[name.."Highlight"] then
			_G[name.."Highlight"]:SetTexture(1, 1, 1, 0.3)
			_G[name.."Highlight"]:ClearAllPoints()
			_G[name.."Highlight"]:SetAllPoints(x)
		end 
		if i.shine then
			i.shine:ClearAllPoints()
			i.shine:SetPoint('TOPLEFT', i, 'TOPLEFT', -3, 3)
			i.shine:SetPoint('BOTTOMRIGHT', i, 'BOTTOMRIGHT', 3, -3)
		end 
		if x then
			x:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			x:ClearAllPoints()
			x:SetAllPoints()
			if not i.Panel then
				i:SetPanelTemplate("Slot")
			end 
		end
		if(spellString) then spellString:SetFontObject(NumberFontNormal) spellString:SetTextColor(1,1,0) end
		if(subSpellString) then subSpellString:SetFontObject(NumberFont_Shadow_Small) subSpellString:SetTextColor(0.9,0.9,0.9) end
	end 
end 
--[[ 
########################################################## 
SPELLBOOK STYLER
##########################################################
]]--
local function SpellBookStyle()
	if SV.db[Schema].blizzard.enable ~= true or SV.db[Schema].blizzard.spellbook ~= true then return end

	STYLE:ApplyWindowStyle(SpellBookFrame)
	STYLE:ApplyCloseButtonStyle(SpellBookFrameCloseButton)

	for _, gName in pairs(bookFrames) do
		local frame = _G[gName]
		if(frame) then
			frame:RemoveTextures()
		end
	end

	-- SpellBookFrameInset:ClearAllPoints()
	-- SpellBookFrameInset:Point("TOPLEFT", SpellBookFrame, "TOPLEFT", 20, -46)
	-- SpellBookFrameInset:Point("BOTTOMRIGHT", SpellBookFrame, "BOTTOMRIGHT", -20, 20)
	SpellBookFrameInset:SetFixedPanelTemplate("Blackout")
	
	_G["SpellBookFrameTutorialButton"]:Die()

	for i = 1, 2 do
		local frame = _G[("SpellBookPage%d"):format(i)]
		if(frame) then
			frame:SetDrawLayer('BORDER', 3)
		end
	end

	STYLE:ApplyPaginationStyle(SpellBookPrevPageButton)
	STYLE:ApplyPaginationStyle(SpellBookNextPageButton)

	ButtonUpdateHelper(nil, true)

	hooksecurefunc("SpellButton_UpdateButton", ButtonUpdateHelper)
	hooksecurefunc("SpellBook_GetCoreAbilityButton", AbilityButtonHelper)

	for i = 1, MAX_SKILLLINE_TABS do
		local tabName = ("SpellBookSkillLineTab%d"):format(i)
		local tab = _G[tabName]
		local tabFlash = _G[("%sFlash"):format(tabName)]
		if(tabFlash) then tabFlash:Die() end
		if(tab) then ChangeTabHelper(tab) end
	end

	hooksecurefunc('SpellBook_GetCoreAbilitySpecTab', GetSpecTabHelper)
	hooksecurefunc("SpellBookFrame_UpdateSkillLineTabs", SkillTabUpdateHelper)

	for _, gName in pairs(proFrames)do
		local frame = _G[gName]
		local frameMissing = _G[("%sMissing"):format(gName)]
		if(frame and frame.missingText) then frame.missingText:SetTextColor(0, 0, 0) end
		if(frameMissing) then frameMissing:SetTextColor(1, 1, 0) end
    	--frame.skillName
    	if(frame.missingHeader) then frame.missingHeader:SetFontObject(NumberFont_Outline_Large) frame.missingHeader:SetTextColor(1,1,0) end
    	if(frame.missingText) then frame.missingText:SetFontObject(NumberFont_Shadow_Small) frame.missingText:SetTextColor(0.9,0.9,0.9) end
    	if(frame.rank) then frame.rank:SetFontObject(NumberFontNormal) frame.rank:SetTextColor(0.9,0.9,0.9) end
    	if(frame.professionName) then frame.professionName:SetFontObject(NumberFont_Outline_Large) frame.professionName:SetTextColor(1,1,0) end
	end

	for _, gName in pairs(proButtons)do
		local button = _G[gName]
		local buttonTex = _G[("%sIconTexture"):format(gName)]
		if(button) then
			button:RemoveTextures()
			if(buttonTex) then
				buttonTex:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				buttonTex:FillInner()
				button:SetFrameLevel(button:GetFrameLevel() + 2)
				if not button.Panel then
					button:SetPanelTemplate("Inset", false, 3, 3, 3)
					button.Panel:SetAllPoints()
				end 
			end
			if(button.spellString) then button.spellString:SetFontObject(NumberFontNormal) button.spellString:SetTextColor(1,1,0) end
			if(button.subSpellString) then button.subSpellString:SetFontObject(NumberFont_Shadow_Small) button.subSpellString:SetTextColor(0.9,0.9,0.9) end
		end
	end

	for _, gName in pairs(proBars) do 
		local bar = _G[gName]
		if(bar) then
			bar:RemoveTextures()
			bar:SetHeight(12)
			bar:SetStatusBarTexture([[Interface\AddOns\SVUI\assets\artwork\Bars\DEFAULT]])
			bar:SetStatusBarColor(0, 220/255, 0)
			bar:SetPanelTemplate("Default")
			bar.rankText:ClearAllPoints()
			bar.rankText:SetPoint("CENTER")
		end
	end

	for i = 1, 5 do
		local frame = _G[("SpellBookFrameTabButton%d"):format(i)]
		if(frame) then
			STYLE:ApplyTabStyle(frame)
		end
	end

	SpellBookFrameTabButton1:ClearAllPoints()
	SpellBookFrameTabButton1:SetPoint('TOPLEFT', SpellBookFrame, 'BOTTOMLEFT', 0, 2)
end 
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
STYLE:SaveCustomStyle(SpellBookStyle)