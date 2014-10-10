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
local type 		= _G.type;
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
local borderTex = [[Interface\Addons\SVUI\assets\artwork\Template\ROUND]]

local SpecButtonList = {
	"PlayerTalentFrameSpecializationLearnButton",
	"PlayerTalentFrameTalentsLearnButton",
	"PlayerTalentFramePetSpecializationLearnButton"
};

local function Tab_OnEnter(this)
	this.backdrop:SetPanelColor("highlight")
	this.backdrop:SetBackdropBorderColor(0.1, 0.8, 0.8)
end

local function Tab_OnLeave(this)
	this.backdrop:SetPanelColor("dark")
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
end

local function StyleGlyphHolder(holder, offset)
    if holder.styled then return end 

    local outer = holder:CreateTexture(nil, "OVERLAY")
    outer:WrapOuter(holder, offset, offset)
    outer:SetTexture(borderTex)
    outer:SetGradient(unpack(SV.Media.gradient.class))

    local hover = holder:CreateTexture(nil, "HIGHLIGHT")
    hover:WrapOuter(holder, offset, offset)
    hover:SetTexture(borderTex)
    hover:SetGradient(unpack(SV.Media.gradient.yellow))
    holder.hover = hover

    if holder.SetDisabledTexture then 
        local disabled = holder:CreateTexture(nil, "BORDER")
        disabled:WrapOuter(holder, offset, offset)
        disabled:SetTexture(borderTex)
        disabled:SetGradient(unpack(SV.Media.gradient.default))
        holder:SetDisabledTexture(disabled)
    end 

    local cd = holder:GetName() and _G[holder:GetName().."Cooldown"]
    if cd then 
        cd:ClearAllPoints()
        cd:FillInner()
    end 
    holder.styled = true
end 
--[[ 
########################################################## 
TALENTFRAME STYLER
##########################################################
]]--
local function TalentFrameStyle()
	if SV.db[Schema].blizzard.enable ~= true or SV.db[Schema].blizzard.talent ~= true then return end

	STYLE:ApplyWindowStyle(PlayerTalentFrame)

	PlayerTalentFrameInset:RemoveTextures()
	PlayerTalentFrameTalents:RemoveTextures()
	PlayerTalentFrameTalentsClearInfoFrame:RemoveTextures()

	PlayerTalentFrame.Panel:Point("BOTTOMRIGHT", PlayerTalentFrame, "BOTTOMRIGHT", 0, -5)
	PlayerTalentFrameSpecializationTutorialButton:Die()
	PlayerTalentFrameTalentsTutorialButton:Die()
	PlayerTalentFramePetSpecializationTutorialButton:Die()
	STYLE:ApplyCloseButtonStyle(PlayerTalentFrameCloseButton)
	PlayerTalentFrameActivateButton:SetButtonTemplate()

	for _,name in pairs(SpecButtonList)do
		local button = _G[name];
		if(button) then
			button:RemoveTextures()
			button:SetButtonTemplate()
			local initialAnchor, anchorParent, relativeAnchor, xPosition, yPosition = button:GetPoint()
			button:SetPoint(initialAnchor, anchorParent, relativeAnchor, xPosition, -28)
		end
	end 

	PlayerTalentFrameTalents:SetFixedPanelTemplate("Inset")
	PlayerTalentFrameTalentsClearInfoFrame.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	PlayerTalentFrameTalentsClearInfoFrame:Width(PlayerTalentFrameTalentsClearInfoFrame:GetWidth()-2)
	PlayerTalentFrameTalentsClearInfoFrame:Height(PlayerTalentFrameTalentsClearInfoFrame:GetHeight()-2)
	PlayerTalentFrameTalentsClearInfoFrame.icon:Size(PlayerTalentFrameTalentsClearInfoFrame:GetSize())
	PlayerTalentFrameTalentsClearInfoFrame:Point('TOPLEFT', PlayerTalentFrameTalents, 'BOTTOMLEFT', 8, -8)

	for i = 1, 4 do
		STYLE:ApplyTabStyle(_G["PlayerTalentFrameTab"..i])
		if i == 1 then 
			local d, e, k, g = _G["PlayerTalentFrameTab"..i]:GetPoint()
			_G["PlayerTalentFrameTab"..i]:Point(d, e, k, g, -4)
		end 
	end 

	hooksecurefunc("PlayerTalentFrame_UpdateTabs", function()
		for i = 1, 4 do 
			local d, e, k, g = _G["PlayerTalentFrameTab"..i]:GetPoint()
			_G["PlayerTalentFrameTab"..i]:Point(d, e, k, g, -4)
		end 
	end)

	PlayerTalentFrameSpecializationSpellScrollFrameScrollChild.Seperator:SetTexture(1, 1, 1)
	PlayerTalentFrameSpecializationSpellScrollFrameScrollChild.Seperator:SetAlpha(0.2)

	for i = 1, 2 do 
		local v = _G["PlayerSpecTab"..i]
		_G["PlayerSpecTab"..i.."Background"]:Die()
		ChangeTabHelper(v)
	end

	hooksecurefunc("PlayerTalentFrame_UpdateSpecs", function()
		local d, x, f, g, h = PlayerSpecTab1:GetPoint()
		PlayerSpecTab1:Point(d, x, f, -1, h)
	end)

	for i = 1, MAX_NUM_TALENT_TIERS do
		local gName = ("PlayerTalentFrameTalentsTalentRow%d"):format(i)
		local rowFrame = _G[gName]
		if(rowFrame) then
			local bgFrame = _G[("%sBg"):format(gName)]
			if(bgFrame) then bgFrame:Hide() end

			rowFrame:DisableDrawLayer("BORDER")
			rowFrame:RemoveTextures()
			rowFrame.TopLine:Point("TOP", 0, 4)
			rowFrame.BottomLine:Point("BOTTOM", 0, -4)

			for z = 1, NUM_TALENT_COLUMNS do 
				local talentItem = _G[("%sTalent%d"):format(gName, z)]
				if(talentItem) then
					STYLE:ApplyItemButtonStyle(talentItem, false, true)
				end
			end
		end
	end

	hooksecurefunc("TalentFrame_Update", function()
		for i = 1, MAX_NUM_TALENT_TIERS do
			local gName = ("PlayerTalentFrameTalentsTalentRow%d"):format(i)

			for z = 1, NUM_TALENT_COLUMNS do
				local talentItem = _G[("%sTalent%d"):format(gName, z)]
				if(talentItem) then
					if talentItem.knownSelection:IsShown() then
						talentItem:SetBackdropBorderColor(0, 1, 0)
					else
			 			talentItem:SetBackdropBorderColor(0, 0, 0)
					end 
					if talentItem.learnSelection:IsShown() then
			 			talentItem:SetBackdropBorderColor(1, 1, 0)
					end 
				end
			end 
		end 
	end)

	for b = 1, 5 do
		 select(b, PlayerTalentFrameSpecializationSpellScrollFrameScrollChild:GetRegions()):Hide()
	end

	local C = _G["PlayerTalentFrameSpecializationSpellScrollFrameScrollChild"]
	C.ring:Hide()
	C:SetFixedPanelTemplate("Transparent")
	C.Panel:WrapOuter(C.specIcon)
	C.specIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

	local D = _G["PlayerTalentFramePetSpecializationSpellScrollFrameScrollChild"]
	D.ring:Hide()
	D:SetFixedPanelTemplate("Transparent")
	D.Panel:WrapOuter(D.specIcon)
	D.specIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

	hooksecurefunc("PlayerTalentFrame_UpdateSpecFrame", function(i, E)
		local F = GetSpecialization(nil, i.isPet, PlayerSpecTab2:GetChecked() and 2 or 1)
		local G = E or F or 1;
		local H, p, p, icon = GetSpecializationInfo(G, nil, i.isPet)
		local I = i.spellsScroll.child;
		I.specIcon:SetTexture(icon)
		local J = 1;
		local K;
		if i.isPet then
			K = { GetSpecializationSpells(G, nil, i.isPet) }
		else
			 K = SPEC_SPELLS_DISPLAY[H]
		end 
		for b = 1, #K, 2 do 
			local L = I["abilityButton"..J]
			local p, icon = GetSpellTexture(K[b])
			L.icon:SetTexture(icon)
			if not L.restyled then
				L.restyled = true;L:Size(30, 30)
				L.ring:Hide()
				L:SetFixedPanelTemplate("Transparent")
				L.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				L.icon:FillInner()
			end 
			J = J+1 
		end 
		for b = 1, GetNumSpecializations(nil, i.isPet)do 
			local A = i["specButton"..b]
			A.SelectedTexture:FillInner(A.Panel)
			if A.selected then
				 A.SelectedTexture:Show()
			else
				 A.SelectedTexture:Hide()
			end 
		end 
	end)

	for b = 1, GetNumSpecializations(false, nil)do 
		local button = PlayerTalentFrameSpecialization["specButton"..b]
		if(button) then
			local _, _, _, icon = GetSpecializationInfo(b, false, nil)
			button.ring:Hide()
			button.specIcon:SetTexture(icon)
			button.specIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			button.specIcon:SetSize(50, 50)
			button.specIcon:Point("LEFT", button, "LEFT", 15, 0)
			button.SelectedTexture = button:CreateTexture(nil, 'ARTWORK')
			button.SelectedTexture:SetTexture(1, 1, 0, 0.1)
		end
	end

	local btnList = {
		"PlayerTalentFrameSpecializationSpecButton", "PlayerTalentFramePetSpecializationSpecButton"
	}

	for _, gName in pairs(btnList)do
		for b = 1, 4 do 
			local button = _G[gName..b]
			if(button) then
				if(_G[gName..b.."Glow"]) then _G[gName..b.."Glow"]:Die() end
				local bTex = button:CreateTexture(nil, 'ARTWORK')
				bTex:SetTexture(1, 1, 1, 0.1)
				button:SetHighlightTexture(bTex)
				button.bg:SetAlpha(0)
				button.learnedTex:SetAlpha(0)
				button.selectedTex:SetAlpha(0)
				button:SetFixedPanelTemplate("Button")
				button:GetHighlightTexture():FillInner(button.Panel)
			end
		end 
	end

	if SV.class == "HUNTER" then
		for b = 1, 6 do
			 select(b, PlayerTalentFramePetSpecialization:GetRegions()):Hide()
		end 
		for b = 1, PlayerTalentFramePetSpecialization:GetNumChildren()do 
			local O = select(b, PlayerTalentFramePetSpecialization:GetChildren())
			if O and not O:GetName() then
				 O:DisableDrawLayer("OVERLAY")
			end 
		end 
		for b = 1, 5 do
			 select(b, PlayerTalentFramePetSpecializationSpellScrollFrameScrollChild:GetRegions()):Hide()
		end 
		for b = 1, GetNumSpecializations(false, true)do 
			local A = PlayerTalentFramePetSpecialization["specButton"..b]
			local p, p, p, icon = GetSpecializationInfo(b, false, true)
			A.ring:Hide()
			A.specIcon:SetTexture(icon)
			A.specIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			A.specIcon:SetSize(50, 50)
			A.specIcon:Point("LEFT", A, "LEFT", 15, 0)
			A.SelectedTexture = A:CreateTexture(nil, 'ARTWORK')
			A.SelectedTexture:SetTexture(1, 1, 0, 0.1)
		end 
		PlayerTalentFramePetSpecializationSpellScrollFrameScrollChild.Seperator:SetTexture(1, 1, 1)
		PlayerTalentFramePetSpecializationSpellScrollFrameScrollChild.Seperator:SetAlpha(0.2)
	end

	PlayerTalentFrameSpecialization:DisableDrawLayer('ARTWORK')
	PlayerTalentFrameSpecialization:DisableDrawLayer('BORDER')

	for b = 1, PlayerTalentFrameSpecialization:GetNumChildren()do 
		local O = select(b, PlayerTalentFrameSpecialization:GetChildren())
		if O and not O:GetName() then
			 O:DisableDrawLayer("OVERLAY")
		end 
	end 
end 
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
STYLE:SaveBlizzardStyle("Blizzard_TalentUI", TalentFrameStyle)

local function GlyphStyle()
	GlyphFrame:RemoveTextures()
	--GlyphFrame.background:ClearAllPoints()
	--GlyphFrame.background:SetAllPoints(PlayerTalentFrameInset)
	GlyphFrame:SetFixedPanelTemplate("Comic", false, 0, 3, 3)
	GlyphFrameSideInset:RemoveTextures()
	GlyphFrameClearInfoFrame:RemoveTextures()
	GlyphFrameClearInfoFrame.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9 )
	GlyphFrameClearInfoFrame:Width(GlyphFrameClearInfoFrame:GetWidth()-2)
	GlyphFrameClearInfoFrame:Height(GlyphFrameClearInfoFrame:GetHeight()-2)
	GlyphFrameClearInfoFrame.icon:Size(GlyphFrameClearInfoFrame:GetSize())
	GlyphFrameClearInfoFrame:Point("TOPLEFT", GlyphFrame, "BOTTOMLEFT", 6, -10)
	STYLE:ApplyDropdownStyle(GlyphFrameFilterDropDown, 212)
	GlyphFrameSearchBox:SetEditboxTemplate()
	STYLE:ApplyScrollFrameStyle(GlyphFrameScrollFrameScrollBar, 5)

	for b = 1, 10 do 
		local e = _G["GlyphFrameScrollFrameButton"..b]
		local icon = _G["GlyphFrameScrollFrameButton"..b.."Icon"]
		e:RemoveTextures()
		STYLE:ApplyItemButtonStyle(e)
		icon:SetTexCoord(0.1, 0.9, 0.1, 0.9 )
	end 

	for b = 1, 6 do 
		local glyphHolder = _G["GlyphFrameGlyph"..b]
		if glyphHolder then 
			glyphHolder:RemoveTextures()
			if(b % 2 == 0) then
				StyleGlyphHolder(glyphHolder, 4)
			else
				StyleGlyphHolder(glyphHolder, 1)
			end
		end 
	end 

	GlyphFrameHeader1:RemoveTextures()
	GlyphFrameHeader2:RemoveTextures()
	GlyphFrameScrollFrame:SetPanelTemplate("Inset", false, 3, 2, 2)
end 

STYLE:SaveBlizzardStyle("Blizzard_GlyphUI", GlyphStyle)