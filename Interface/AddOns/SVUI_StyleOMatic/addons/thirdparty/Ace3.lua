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
local AceGUI = LibStub("AceGUI-3.0", true);
local NOOP = function() end;
local function Ace3_OnEnter(b)
	b:SetBackdropBorderColor(unpack(SuperVillain.Media.color.highlight))
end;
local function Ace3_OnLeave(b)
	b:SetBackdropBorderColor(0,0,0,1)
end;
local function Ace3_ScrollStyle(e, f)
	if _G[e:GetName().."BG"]then 
		_G[e:GetName().."BG"]:SetTexture(nil)
	end;
	if _G[e:GetName().."Track"]then 
		_G[e:GetName().."Track"]:SetTexture(nil)
	end;
	if _G[e:GetName().."Top"]then 
		_G[e:GetName().."Top"]:SetTexture(nil)
		_G[e:GetName().."Bottom"]:SetTexture(nil)
		_G[e:GetName().."Middle"]:SetTexture(nil)
	end;
	if _G[e:GetName().."ScrollUpButton"] and _G[e:GetName().."ScrollDownButton"] then 
		_G[e:GetName().."ScrollUpButton"]:Formula409()
		if not _G[e:GetName().."ScrollUpButton"].icon then 
			MOD:ApplyPaginationStyle(_G[e:GetName().."ScrollUpButton"])
			SquareButton_SetIcon(_G[e:GetName().."ScrollUpButton"], "UP")
			_G[e:GetName().."ScrollUpButton"]:Size(_G[e:GetName().."ScrollUpButton"]:GetWidth()+7, _G[e:GetName().."ScrollUpButton"]:GetHeight()+7)
		end;
		_G[e:GetName().."ScrollDownButton"]:Formula409()
		if not _G[e:GetName().."ScrollDownButton"].icon then 
			MOD:ApplyPaginationStyle(_G[e:GetName().."ScrollDownButton"])
			SquareButton_SetIcon(_G[e:GetName().."ScrollDownButton"], "DOWN")
			_G[e:GetName().."ScrollDownButton"]:Size(_G[e:GetName().."ScrollDownButton"]:GetWidth()+7, _G[e:GetName().."ScrollDownButton"]:GetHeight()+7)
		end;
		if not e.styledBackground then 
			e.styledBackground = CreateFrame("Frame", nil, e)
			e.styledBackground:Point("TOPLEFT", _G[e:GetName().."ScrollUpButton"], "BOTTOMLEFT", 0, -1)
			e.styledBackground:Point("BOTTOMRIGHT", _G[e:GetName().."ScrollDownButton"], "TOPRIGHT", 0, 1)
			e.styledBackground:SetPanelTemplate("Inset", true)
		end;
		if e:GetThumbTexture()then 
			if not f then 
				f = 3 
			end;
			e:GetThumbTexture():SetTexture("Interface\\Buttons\\UI-ScrollBar-Knob")
		end 
	end 
end;

local function Ace3_ButtonStyle(h, i, j)
	if h.Left then h.Left:SetAlpha(0)end;
	if h.Middle then h.Middle:SetAlpha(0)end;
	if h.Right then h.Right:SetAlpha(0)end;
	if h.SetNormalTexture then h:SetNormalTexture("")end;
	if h.SetHighlightTexture then h:SetHighlightTexture("")end;
	if h.SetPushedTexture then h:SetPushedTexture("")end;
	if h.SetDisabledTexture then h:SetDisabledTexture("")end;
	if i then h:Formula409()end;
	if not h.template and not j then h:SetFixedPanelTemplate("Button")end;
	h:HookScript("OnEnter", Ace3_OnEnter)h:HookScript("OnLeave", Ace3_OnLeave)
end;

local function Ace3_PaginationStyle(...)
	MOD:ApplyPaginationStyle(...)
end;

local function StyleAce3()
	local AceGUI = LibStub("AceGUI-3.0", true)
	if not AceGUI then return end;
	local savedFn = AceGUI.RegisterAsWidget;
	AceGUI.RegisterAsWidget = function(b, m)
		if not SuperVillain.db.SVStyle or not SuperVillain.db.SVStyle.addons.ace3 then 
			return savedFn(b, m)
		end;
		local n = m.type;
		if n == "MultiLineEditBox"then 
			local e = m.frame;
			e:SetFixedPanelTemplate("Pattern")
			if not m.scrollBG.template then 
				m.scrollBG:SetFixedPanelTemplate("Inset")
			end;
			Ace3_ButtonStyle(m.button)
			Ace3_ScrollStyle(m.scrollBar)
			m.scrollBar:SetPoint("RIGHT", e, "RIGHT", 0-4)
			m.scrollBG:SetPoint("TOPRIGHT", m.scrollBar, "TOPLEFT", -2, 19)
			m.scrollBG:SetPoint("BOTTOMLEFT", m.button, "TOPLEFT")
			m.scrollFrame:SetPoint("BOTTOMRIGHT", m.scrollBG, "BOTTOMRIGHT", -4, 8)
		elseif n == "CheckBox"then 
			m.checkbg:MUNG()m.highlight:MUNG()
			if not m.styledCheckBG then 
				m.styledCheckBG = CreateFrame("Frame", nil, m.frame)
				m.styledCheckBG:FillInner(m.check)
				m.styledCheckBG:SetFixedPanelTemplate("Inset")
			end;
			m.check:SetParent(m.styledCheckBG)
		elseif n == "Dropdown"then 
			local e = m.dropdown;
			local o = m.button;
			local p = m.text;
			e:Formula409()
			o:ClearAllPoints()
			o:Point("RIGHT", e, "RIGHT", -20, 0)
			o:SetFrameLevel(o:GetFrameLevel() + 1)
			Ace3_PaginationStyle(o, true)
			if not e.Panel then 
				e:SetPanelTemplate("Inset")
				e.Panel:Point("TOPLEFT", e, "TOPLEFT", 20, -2)
				e.Panel:Point("BOTTOMRIGHT", e, "BOTTOMRIGHT", -20, 2)
				local level = e:GetFrameLevel()
				if(level > 0) then 
					e.Panel:SetFrameLevel(level - 1)
				else 
					e.Panel:SetFrameLevel(0)
				end
			end;
			o:SetParent(e.Panel)
			p:SetParent(e.Panel)
			o:HookScript("OnClick", function(s)
				local b = s.obj;
				b.pullout.frame:SetFixedPanelTemplate("Default")
			end)
		elseif n == "LSM30_Font" or n == "LSM30_Sound" or n == "LSM30_Border" or n == "LSM30_Background" or n == "LSM30_Statusbar" then 
			local e = m.frame;
			local o = e.dropButton;
			local p = e.text;e:Formula409()
			Ace3_PaginationStyle(o, true)
			e.text:ClearAllPoints()
			e.text:Point("RIGHT", o, "LEFT", -2, 0)
			o:ClearAllPoints()
			o:Point("RIGHT", e, "RIGHT", -10, -6)
			if not e.Panel then 
				e:SetFixedPanelTemplate("Inset")
				if n == "LSM30_Font"then 
					e.Panel:Point("TOPLEFT", 20, -17)
				elseif n == "LSM30_Sound"then 
					e.Panel:Point("TOPLEFT", 20, -17)
					m.soundbutton:SetParent(e.Panel)
					m.soundbutton:ClearAllPoints()
					m.soundbutton:Point("LEFT", e.Panel, "LEFT", 2, 0)
				elseif n == "LSM30_Statusbar"then 
					e.Panel:Point("TOPLEFT", 20, -17)
					m.bar:SetParent(e.Panel)
					m.bar:FillInner()
				elseif n == "LSM30_Border"or n == "LSM30_Background"then 
					e.Panel:Point("TOPLEFT", 42, -16)
				end;
				e.Panel:Point("BOTTOMRIGHT", o, "BOTTOMRIGHT", 2, -2)
			end;
			o:SetParent(e.Panel)
			p:SetParent(e.Panel)
			o:HookScript("OnClick", function(s, o)local b = s.obj;
				if(b.dropdown and not b.dropdown.Panel) then
					local e = b.dropdown
					e:SetPanelTemplate("Inset")
					e.Panel:Point("TOPLEFT", e, "TOPLEFT", 20, -2)
					e.Panel:Point("BOTTOMRIGHT", e, "BOTTOMRIGHT", -20, 2)
					local level = e:GetFrameLevel()
					if(level > 0) then 
						e.Panel:SetFrameLevel(level - 1)
					else 
						e.Panel:SetFrameLevel(0)
					end
				end
			end)
		elseif n == "EditBox" then 
			local e = m.editbox;
			local o = m.button;
			_G[e:GetName().."Left"]:MUNG()
			_G[e:GetName().."Middle"]:MUNG()
			_G[e:GetName().."Right"]:MUNG()
			e:Height(17)
			e:SetFixedPanelTemplate("Inset")
			local level = e:GetFrameLevel()
			if(level > 0) then 
				e.Panel:SetFrameLevel(level - 1)
			else 
				e.Panel:SetFrameLevel(0)
			end
			Ace3_ButtonStyle(o)
		elseif n == "Button"then 
			local e = m.frame;Ace3_ButtonStyle(e, nil, true)
			e:Formula409()
			e:SetFixedPanelTemplate("Button", true)
			e.Panel:FillInner()
			m.text:SetParent(e.Panel)
		elseif n == "Slider"then 
			local e = m.slider;
			local t = m.editbox;
			local u = m.lowtext;
			local v = m.hightext;
			local w = 20;
			e:Formula409()
			e:SetFixedPanelTemplate("Inset")
			e:Height(w)
			e:SetThumbTexture("Interface\\Buttons\\UI-ScrollBar-Knob")
			e:GetThumbTexture():SetVertexColor(0.8, 0.8, 0.8)
			t:SetFixedPanelTemplate("Inset")
			t:Height(15)
			t:Point("TOP", e, "BOTTOM", 0, -1)
			u:SetPoint("TOPLEFT", e, "BOTTOMLEFT", 2, -2)
			v:SetPoint("TOPRIGHT", e, "BOTTOMRIGHT", -2, -2)
		end;
		return savedFn(b, m)
	end;
	local x = AceGUI.RegisterAsContainer;
	local y = false;
	AceGUI.RegisterAsContainer = function(b, m)
		if(not SuperVillain.db.SVStyle or not SuperVillain.db.SVStyle.addons or not SuperVillain.db.SVStyle.addons.ace3) then 
			return x(b, m)
		end;
		local n = m.type;
		if n == "ScrollFrame" then 
			local e = m.scrollbar;
			Ace3_ScrollStyle(e)
		elseif n == "Window" then
			local e = m.content:GetParent()
			e:SetPanelTemplate("Halftone")
		elseif n == "InlineGroup" or n == "TreeGroup" or n == "TabGroup" or n == "SimpleGroup" or n == "Frame" or n == "DropdownGroup" then 
			local e = m.content:GetParent()
			if n == "Frame" then 
				e:Formula409()
				for z = 1, e:GetNumChildren()do 
					local A = select(z, e:GetChildren())
					if A:GetObjectType() == "Button"and A:GetText() then 
						Ace3_ButtonStyle(A)
					else 
						A:Formula409()
					end 
				end 
			end;
			if not m.treeframe then 
				if not y then 
					e:SetPanelTemplate("Halftone")
					e.Panel:SetFrameLevel(0)
					y = true 
				else 
					e:SetFixedPanelTemplate("Default")
				end 
			end;
			if m.treeframe then 
				m.treeframe:SetFixedPanelTemplate("Inset")
				e:Point("TOPLEFT", m.treeframe, "TOPRIGHT", 1, 0)
				local B = m.CreateButton;m.CreateButton = function(b)
					local o = B(b)o.toggle:Formula409()
					o.toggle.SetNormalTexture = NOOP;
					o.toggle.SetPushedTexture = NOOP;
					o.toggleText = o.toggle:CreateFontString(nil, "OVERLAY")
					o.toggleText:SetFontTemplate(nil, 19)
					o.toggleText:SetPoint("CENTER")
					o.toggleText:SetText("+")
					return o 
				end;
				local C = m.RefreshTree;m.RefreshTree = function(b, D)C(b, D)
					if not b.tree then return end;
					local E = b.status or b.localstatus;
					local F = E.groups;
					local G = b.lines;
					local H = b.buttons;
					for z, I in pairs(G)do 
						local o = H[z]
						if F[I.uniquevalue]and o then 
							o.toggleText:SetText("-")
						elseif o then 
							o.toggleText:SetText("+")
						end 
					end 
				end 
			end;
			if n == "TabGroup" then 
				local J = m.CreateTab;m.CreateTab = function(b, K)
					local L = J(b, K)L:Formula409()
					return L 
				end 
			end;
			if m.scrollbar then Ace3_ScrollStyle(m.scrollbar) end 
		end;
		return x(b, m)
	end 
end;
if not AceGUI then 
	local h = CreateFrame("Frame")
	h:RegisterEvent("ADDON_LOADED")
	h:SetScript("OnEvent", function(b, M, N)
		if LibStub("AceGUI-3.0", true) then 
			StyleAce3()
			b:UnregisterEvent("ADDON_LOADED")
		end 
	end)
	return 
end;

MOD:SaveBlizzardStyle('Ace3', StyleAce3, true)