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
local MOD = SuperVillain.Registry:Expose('SVStyle');
--[[ 
########################################################## 
HELPERS
##########################################################
]]--
local function Tab_OnEnter(this)
	this.backdrop:SetPanelColor("highlight")
	this.backdrop:SetBackdropBorderColor(unpack(SuperVillain.Media.color.highlight))
end

local function Tab_OnLeave(this)
	this.backdrop:SetPanelColor("dark")
	this.backdrop:SetBackdropBorderColor(0,0,0,1)
end

local function ChangeTabHelper(this)
	this:Formula409()
	this:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
	this:GetNormalTexture():FillInner()
	this.pushed = true;
	this.backdrop = CreateFrame("Frame", nil, this)
	this.backdrop:WrapOuter(this,1,1)
	local level = this:GetFrameLevel()
	if(level > 0) then 
		this.backdrop:SetFrameLevel(level - 1)
	else 
		this.backdrop:SetFrameLevel(0)
	end
	this.backdrop:SetFixedPanelTemplate("Component", true)
	this.backdrop:SetPanelColor("dark")
	this:HookScript("OnEnter",Tab_OnEnter)
    this:HookScript("OnLeave",Tab_OnLeave)
	hooksecurefunc(this:GetHighlightTexture(), "SetTexture", function(i, w)
		if w ~= nil then
			 i:SetTexture(nil)
		end 
	end)
	hooksecurefunc(this:GetCheckedTexture(), "SetTexture", function(i, w)
		if w ~= nil then
			 i:SetTexture(nil)
		end 
	end)
	local a,b,c,d,e = this:GetPoint()
	this:Point(a,b,c,1,e)
end;

local function GetSpecTabHelper(tab)
	local i = SpellBookCoreAbilitiesFrame.SpecTabs[tab]
	ChangeTabHelper(i)
	if tab > 1 then 
		local o, Y, Z, h, s = i:GetPoint()
		i:ClearAllPoints()
		i:SetPoint(o, Y, Z, 0, s)
	end 
end;

local function SkillTabUpdateHelper()
	for j = 1, MAX_SKILLLINE_TABS do 
		local S = _G["SpellBookSkillLineTab"..j]
		local h, h, h, h, a0 = GetSpellTabInfo(j)
		if a0 then
			S:GetNormalTexture():FillInner()
			S:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
		end 
	end 
end;

local function AbilityButtonHelper(j)
	local i = SpellBookCoreAbilitiesFrame.Abilities[j]
	if i.styled then return end;
		local x = i.iconTexture;
		if not InCombatLockdown() then
			if not i.properFrameLevel then 
			 	i.properFrameLevel = i:GetFrameLevel() + 1 
			end;
			i:SetFrameLevel(i.properFrameLevel)
		end;
		if not i.styled then
		for j = 1, i:GetNumRegions()do 
			local N = select(j, i:GetRegions())
			if N:GetObjectType() == "Texture"then
				if N:GetTexture() ~= "Interface\\Buttons\\ActionBarFlyoutButton" then 
				 	N:SetTexture(nil)
				end 
			end 
		end;
		if i.highlightTexture then 
			hooksecurefunc(i.highlightTexture, "SetTexture", function(k, P, Q, R)
				if P == [[Interface\Buttons\ButtonHilight-Square]] then
					 i.highlightTexture:SetTexture(1, 1, 1, 0.3)
				end 
			end)
		end;
		i.styled = true 
	end;
	if x then
		x:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		x:ClearAllPoints()
		x:SetAllPoints()
		if not i.Panel then
			 i:SetPanelTemplate("Inset", false, 3, 3, 3)
		end 
	end;
	i.styled = true 
end;

local function ButtonUpdateHelper(k, M)
	for j=1, SPELLS_PER_PAGE do 
		local i = _G["SpellButton"..j]
		local x = _G["SpellButton"..j.."IconTexture"]
		if not InCombatLockdown() then
			 i:SetFrameLevel(SpellBookFrame:GetFrameLevel() + 5)
		end;
		if M then
			for j = 1, i:GetNumRegions()do 
				local N = select(j, i:GetRegions())
				if N:GetObjectType() == "Texture"then
					if N ~= i.FlyoutArrow then 
						N:SetTexture(nil)
					end 
				end 
			end 
		end;
		if _G["SpellButton"..j.."Highlight"]then
			_G["SpellButton"..j.."Highlight"]:SetTexture(1, 1, 1, 0.3)
			_G["SpellButton"..j.."Highlight"]:ClearAllPoints()
			_G["SpellButton"..j.."Highlight"]:SetAllPoints(x)
		end;
		if i.shine then
			i.shine:ClearAllPoints()
			i.shine:SetPoint('TOPLEFT', i, 'TOPLEFT', -3, 3)
			i.shine:SetPoint('BOTTOMRIGHT', i, 'BOTTOMRIGHT', 3, -3)
		end;
		if x then
			x:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			x:ClearAllPoints()
			x:SetAllPoints()
			if not i.Panel then
				i:SetPanelTemplate("Slot")
			end 
		end 
	end 
end;
--[[ 
########################################################## 
SPELLBOOK STYLER
##########################################################
]]--
local function SpellBookStyle()
	if SuperVillain.db.SVStyle.blizzard.enable ~= true or SuperVillain.db.SVStyle.blizzard.spellbook ~= true then return end;
	MOD:ApplyCloseButtonStyle(SpellBookFrameCloseButton)
	local J = {
		"SpellBookFrame", "SpellBookFrameInset", "SpellBookSpellIconsFrame", "SpellBookSideTabsFrame", "SpellBookPageNavigationFrame"
	}
	local Kill = {
		"SpellBookFrameTutorialButton"
	}
	for h, K in pairs(J)do
		 _G[K]:Formula409()
	end;
	for h, K in pairs(Kill)do
		 _G[K]:MUNG()
	end;
	SpellBookFrame:SetPanelTemplate("Pattern")
	for j = 1, 2 do
		 _G['SpellBookPage'..j]:SetDrawLayer('BORDER', 3)
	end;
	MOD:ApplyPaginationStyle(SpellBookPrevPageButton)
	MOD:ApplyPaginationStyle(SpellBookNextPageButton)
	ButtonUpdateHelper(nil, true)
	hooksecurefunc("SpellButton_UpdateButton", ButtonUpdateHelper)
	hooksecurefunc("SpellBook_GetCoreAbilityButton", AbilityButtonHelper)
	for j = 1, MAX_SKILLLINE_TABS do 
		local S = _G["SpellBookSkillLineTab"..j]
		_G["SpellBookSkillLineTab"..j.."Flash"]:MUNG()
		ChangeTabHelper(S)
	end;
	hooksecurefunc('SpellBook_GetCoreAbilitySpecTab', GetSpecTabHelper)
	hooksecurefunc("SpellBookFrame_UpdateSkillLineTabs", SkillTabUpdateHelper)
	local a1 = {
		"PrimaryProfession1SpellButtonTop", "PrimaryProfession1SpellButtonBottom", "PrimaryProfession2SpellButtonTop", "PrimaryProfession2SpellButtonBottom", "SecondaryProfession1SpellButtonLeft", "SecondaryProfession1SpellButtonRight", "SecondaryProfession2SpellButtonLeft", "SecondaryProfession2SpellButtonRight", "SecondaryProfession3SpellButtonLeft", "SecondaryProfession3SpellButtonRight", "SecondaryProfession4SpellButtonLeft", "SecondaryProfession4SpellButtonRight"
	}
	local a2 = {
		"PrimaryProfession1", "PrimaryProfession2", "SecondaryProfession1", "SecondaryProfession2", "SecondaryProfession3", "SecondaryProfession4"
	}
	for h, a3 in pairs(a2)do
		_G[a3 .."Missing"]:SetTextColor(1, 1, 0)
		_G[a3].missingText:SetTextColor(0, 0, 0)
	end;
	for h, i in pairs(a1)do 
		local x = _G[i.."IconTexture"]
		local i = _G[i]i:Formula409()
		if x then
			x:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			x:FillInner()
			i:SetFrameLevel(i:GetFrameLevel()+2)
			if not i.Panel then
				i:SetPanelTemplate("Inset", false, 3, 3, 3)
				i.Panel:SetAllPoints()
			end 
		end 
	end;
	local a4 = {
		"PrimaryProfession1StatusBar", "PrimaryProfession2StatusBar", "SecondaryProfession1StatusBar", "SecondaryProfession2StatusBar", "SecondaryProfession3StatusBar", "SecondaryProfession4StatusBar"
	}
	for h, a5 in pairs(a4)do 
		local a5 = _G[a5]a5:Formula409()
		a5:SetStatusBarTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
		a5:SetStatusBarColor(0, 220/255, 0)
		a5:SetPanelTemplate("Default")
		a5.rankText:ClearAllPoints()
		a5.rankText:SetPoint("CENTER")
	end;
	for j = 1, 5 do
		 MOD:ApplyTabStyle(_G["SpellBookFrameTabButton"..j])
	end;
	SpellBookFrameTabButton1:ClearAllPoints()
	SpellBookFrameTabButton1:SetPoint('TOPLEFT', SpellBookFrame, 'BOTTOMLEFT', 0, 2)
end;
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
MOD:SaveCustomStyle(SpellBookStyle)