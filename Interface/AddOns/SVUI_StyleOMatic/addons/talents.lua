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
local borderTex = [[Interface\Addons\SVUI\assets\artwork\Template\ROUND]]

local SpecButtonList = {
	"PlayerTalentFrameSpecializationLearnButton",
	"PlayerTalentFrameTalentsLearnButton",
	"PlayerTalentFramePetSpecializationLearnButton"
};

local function Tab_OnEnter(this)
	this.backdrop:SetPanelColor("highlight")
	this.backdrop:SetBackdropBorderColor(unpack(SuperVillain.Media.color.highlight))
end

local function Tab_OnLeave(this)
	this.backdrop:SetPanelColor("dark")
	this.backdrop:SetBackdropBorderColor(0,0,0,1)
end

local function PseudoTabStyle(this)
	if not this then return end;
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
end;

local function StyleGlyphHolder(holder, offset)
    if holder.styled then return end;

    local outer = holder:CreateTexture(nil, "OVERLAY")
    outer:WrapOuter(holder, offset, offset)
    outer:SetTexture(borderTex)
    outer:SetGradient(unpack(SuperVillain.Media.gradient.class))

    local hover = holder:CreateTexture(nil, "HIGHLIGHT")
    hover:WrapOuter(holder, offset, offset)
    hover:SetTexture(borderTex)
    hover:SetGradient(unpack(SuperVillain.Media.gradient.yellow))
    holder.hover = hover

    if holder.SetDisabledTexture then 
        local disabled = holder:CreateTexture(nil, "BORDER")
        disabled:WrapOuter(holder, offset, offset)
        disabled:SetTexture(borderTex)
        disabled:SetGradient(unpack(SuperVillain.Media.gradient.default))
        holder:SetDisabledTexture(disabled)
    end;

    local cd = holder:GetName() and _G[holder:GetName().."Cooldown"]
    if cd then 
        cd:ClearAllPoints()
        cd:FillInner()
    end;
    holder.styled = true
end;
--[[ 
########################################################## 
TALENTFRAME STYLER
##########################################################
]]--
local function TalentFrameStyle()
	if SuperVillain.db.SVStyle.blizzard.enable ~= true or SuperVillain.db.SVStyle.blizzard.talent ~= true then return end;
	PlayerTalentFrame:Formula409()
	PlayerTalentFrameInset:Formula409()
	PlayerTalentFrameTalents:Formula409()
	local r = CreateFrame('Frame', nil, PlayerTalentFrame)
	r:WrapOuter(PlayerTalentFrame)
	local s = PlayerTalentFrame:GetFrameLevel()
	if((s - 1) >= 0) then
		 r:SetFrameLevel(s - 1)
	else
		 r:SetFrameLevel(0)
	end;
	PlayerTalentFrame:SetPanelTemplate("Halftone")
	PlayerTalentFrame.Panel:Point("BOTTOMRIGHT", PlayerTalentFrame, "BOTTOMRIGHT", 0, -5)
	PlayerTalentFrameSpecializationTutorialButton:MUNG()
	PlayerTalentFrameTalentsTutorialButton:MUNG()
	PlayerTalentFramePetSpecializationTutorialButton:MUNG()
	MOD:ApplyCloseButtonStyle(PlayerTalentFrameCloseButton)
	PlayerTalentFrameActivateButton:SetButtonTemplate()
	for _,name in pairs(SpecButtonList)do
		local button = _G[name];
		button:Formula409()
		button:SetButtonTemplate()
		local d, e, k, g = button:GetPoint()
		button:Point(d, e, k, g, -28)
	end;
	PlayerTalentFrameTalents:SetFixedPanelTemplate('Transparent')
	PlayerTalentFrameTalentsClearInfoFrame:SetFixedPanelTemplate('Transparent')
	PlayerTalentFrameTalentsClearInfoFrame.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	PlayerTalentFrameTalentsClearInfoFrame:Width(PlayerTalentFrameTalentsClearInfoFrame:GetWidth()-2)
	PlayerTalentFrameTalentsClearInfoFrame:Height(PlayerTalentFrameTalentsClearInfoFrame:GetHeight()-2)
	PlayerTalentFrameTalentsClearInfoFrame.icon:Size(PlayerTalentFrameTalentsClearInfoFrame:GetSize())
	PlayerTalentFrameTalentsClearInfoFrame:Point('TOPLEFT', PlayerTalentFrameTalents, 'BOTTOMLEFT', 8, -8)
	for b = 1, 4 do
		MOD:ApplyTabStyle(_G['PlayerTalentFrameTab'..b])
		if b == 1 then 
			local d, e, k, g = _G['PlayerTalentFrameTab'..b]:GetPoint()
			_G['PlayerTalentFrameTab'..b]:Point(d, e, k, g, -4)
		end 
	end;
	hooksecurefunc('PlayerTalentFrame_UpdateTabs', function()
		for b = 1, 4 do 
			local d, e, k, g = _G['PlayerTalentFrameTab'..b]:GetPoint()
			_G['PlayerTalentFrameTab'..b]:Point(d, e, k, g, -4)
		end 
	end)
	PlayerTalentFrameSpecializationSpellScrollFrameScrollChild.Seperator:SetTexture(1, 1, 1)
	PlayerTalentFrameSpecializationSpellScrollFrameScrollChild.Seperator:SetAlpha(0.2)
	for b = 1, 2 do 
		local v = _G['PlayerSpecTab'..b]
		_G['PlayerSpecTab'..b..'Background']:MUNG()
		PseudoTabStyle(v)
		hooksecurefunc(v:GetHighlightTexture(), "SetTexture", function(i, w)
			if w ~= nil then
				 i:SetTexture(nil)
			end 
		end)
		hooksecurefunc(v:GetCheckedTexture(), "SetTexture", function(i, w)
			if w ~= nil then
				 i:SetTexture(nil)
			end 
		end)
	end;
	hooksecurefunc('PlayerTalentFrame_UpdateSpecs', function()
		local d, x, f, g, h = PlayerSpecTab1:GetPoint()
		PlayerSpecTab1:Point(d, x, f, -1, h)
	end)
	for b = 1, MAX_NUM_TALENT_TIERS do 
		local y = _G["PlayerTalentFrameTalentsTalentRow"..b]
		_G["PlayerTalentFrameTalentsTalentRow"..b.."Bg"]:Hide()
		y:DisableDrawLayer("BORDER")
		y:Formula409()
		y.TopLine:Point("TOP", 0, 4)
		y.BottomLine:Point("BOTTOM", 0, -4)
		for z = 1, NUM_TALENT_COLUMNS do 
			local A = _G["PlayerTalentFrameTalentsTalentRow"..b.."Talent"..z]
			local B = _G["PlayerTalentFrameTalentsTalentRow"..b.."Talent"..z.."IconTexture"]A:Formula409()
			A:SetFrameLevel(A:GetFrameLevel()+5)
			A:SetPanelTemplate("Transparent")
			A.Panel:WrapOuter(B)
			B:SetDrawLayer("OVERLAY")
			B:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			A.bg = CreateFrame("Frame", nil, A)
			A.bg:SetFrameLevel(A:GetFrameLevel()-2)
			A.bg:Point("TOPLEFT", 15, -1)
			A.bg:Point("BOTTOMRIGHT", -10, 1)
			A.bg:SetFixedPanelTemplate("Default")
			A.bg.SelectedTexture = A.bg:CreateTexture(nil, 'ARTWORK')
			A.bg.SelectedTexture:Point("TOPLEFT", A, "TOPLEFT", 15, -1)
			A.bg.SelectedTexture:Point("BOTTOMRIGHT", A, "BOTTOMRIGHT", -10, 1)
		end 
	end;
	hooksecurefunc("TalentFrame_Update", function()
		for b = 1, MAX_NUM_TALENT_TIERS do
			for z = 1, NUM_TALENT_COLUMNS do 
				local A = _G["PlayerTalentFrameTalentsTalentRow"..b.."Talent"..z]
				if A.knownSelection:IsShown() then
		 			A.bg.SelectedTexture:Show()
					A.bg.SelectedTexture:SetTexture(0, 1, 0, 0.1)
				else
		 			A.bg.SelectedTexture:Hide()
				end;
				if A.learnSelection:IsShown() then
		 			A.bg.SelectedTexture:Show()
					A.bg.SelectedTexture:SetTexture(1, 1, 0, 0.1)
				end 
			end 
		end 
	end)
	for b = 1, 5 do
		 select(b, PlayerTalentFrameSpecializationSpellScrollFrameScrollChild:GetRegions()):Hide()
	end;
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
		local I = i.spellsScroll.child;I.specIcon:SetTexture(icon)
		local J = 1;
		local K;
		if i.isPet then
			K = { GetSpecializationSpells(G, nil, i.isPet) }
		else
			 K = SPEC_SPELLS_DISPLAY[H]
		end;
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
			end;
			J = J+1 
		end;
		for b = 1, GetNumSpecializations(nil, i.isPet)do 
			local A = i["specButton"..b]A.SelectedTexture:FillInner(A.Panel)
			if A.selected then
				 A.SelectedTexture:Show()
			else
				 A.SelectedTexture:Hide()
			end 
		end 
	end)
	for b = 1, GetNumSpecializations(false, nil)do 
		local A = PlayerTalentFrameSpecialization["specButton"..b]
		local p, p, p, icon = GetSpecializationInfo(b, false, nil)
		A.ring:Hide()
		A.specIcon:SetTexture(icon)
		A.specIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		A.specIcon:SetSize(50, 50)
		A.specIcon:Point("LEFT", A, "LEFT", 15, 0)
		A.SelectedTexture = A:CreateTexture(nil, 'ARTWORK')
		A.SelectedTexture:SetTexture(1, 1, 0, 0.1)
	end;
	local btnList = {
		"PlayerTalentFrameSpecializationSpecButton", "PlayerTalentFramePetSpecializationSpecButton"
	}
	for p, M in pairs(btnList)do
		for b = 1, 4 do 
			local A = _G[M..b]_G["PlayerTalentFrameSpecializationSpecButton"..b.."Glow"]:MUNG()
			local N = A:CreateTexture(nil, 'ARTWORK')
			N:SetTexture(1, 1, 1, 0.1)
			A:SetHighlightTexture(N)
			A.bg:SetAlpha(0)
			A.learnedTex:SetAlpha(0)
			A.selectedTex:SetAlpha(0)
			A:SetFixedPanelTemplate("Button")
			A:GetHighlightTexture():FillInner(A.Panel)
		end 
	end;
	if SuperVillain.class == "HUNTER" then
		for b = 1, 6 do
			 select(b, PlayerTalentFramePetSpecialization:GetRegions()):Hide()
		end;
		for b = 1, PlayerTalentFramePetSpecialization:GetNumChildren()do 
			local O = select(b, PlayerTalentFramePetSpecialization:GetChildren())
			if O and not O:GetName() then
				 O:DisableDrawLayer("OVERLAY")
			end 
		end;
		for b = 1, 5 do
			 select(b, PlayerTalentFramePetSpecializationSpellScrollFrameScrollChild:GetRegions()):Hide()
		end;
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
		end;
		PlayerTalentFramePetSpecializationSpellScrollFrameScrollChild.Seperator:SetTexture(1, 1, 1)
		PlayerTalentFramePetSpecializationSpellScrollFrameScrollChild.Seperator:SetAlpha(0.2)
	end;
	PlayerTalentFrameSpecialization:DisableDrawLayer('ARTWORK')
	PlayerTalentFrameSpecialization:DisableDrawLayer('BORDER')
	for b = 1, PlayerTalentFrameSpecialization:GetNumChildren()do 
		local O = select(b, PlayerTalentFrameSpecialization:GetChildren())
		if O and not O:GetName() then
			 O:DisableDrawLayer("OVERLAY")
		end 
	end 
end;
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
MOD:SaveBlizzardStyle("Blizzard_TalentUI",TalentFrameStyle)

local function GlyphStyle()
	GlyphFrame.background:ClearAllPoints()
	GlyphFrame.background:SetAllPoints(PlayerTalentFrameInset)
	GlyphFrame:SetPanelTemplate("Comic", false, 0, 3, 3)
	GlyphFrameSideInset:Formula409()
	GlyphFrameClearInfoFrame:SetFixedPanelTemplate("Comic")
	GlyphFrameClearInfoFrame.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9 )
	GlyphFrameClearInfoFrame:Width(GlyphFrameClearInfoFrame:GetWidth()-2)
	GlyphFrameClearInfoFrame:Height(GlyphFrameClearInfoFrame:GetHeight()-2)
	GlyphFrameClearInfoFrame.icon:Size(GlyphFrameClearInfoFrame:GetSize())
	GlyphFrameClearInfoFrame:Point("TOPLEFT", GlyphFrame, "BOTTOMLEFT", 6, -10)
	MOD:ApplyDropdownStyle(GlyphFrameFilterDropDown, 212)
	GlyphFrameSearchBox:SetEditboxTemplate()
	MOD:ApplyScrollStyle(GlyphFrameScrollFrameScrollBar, 5)

	for b = 1, 10 do 
		local e = _G["GlyphFrameScrollFrameButton"..b]
		local icon = _G["GlyphFrameScrollFrameButton"..b.."Icon"]
		e:Formula409()
		MOD:ApplyLinkButtonStyle(e)
		icon:SetTexCoord(0.1, 0.9, 0.1, 0.9 )
	end;

	for b = 1, 6 do 
		local glyphHolder = _G["GlyphFrameGlyph"..b]
		if glyphHolder then 
			glyphHolder:Formula409()
			if(b % 2 == 0) then
				StyleGlyphHolder(glyphHolder, 4)
			else
				StyleGlyphHolder(glyphHolder, 1)
			end
		end 
	end;

	GlyphFrameHeader1:Formula409()
	GlyphFrameHeader2:Formula409()
	GlyphFrameScrollFrame:SetPanelTemplate("Inset", false, 3, 2, 2)
end;

MOD:SaveBlizzardStyle("Blizzard_GlyphUI",GlyphStyle)