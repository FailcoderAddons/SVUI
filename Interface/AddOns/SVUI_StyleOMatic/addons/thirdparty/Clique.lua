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
local SuperVillain, L = unpack(SVUI);
local MOD = SuperVillain.Registry:Expose('SVStyle');
--[[ 
########################################################## 
CLIQUE
##########################################################
]]--
local function StyleClique()
	local Frames = {
		"CliqueDialog",
		"CliqueConfig",
		"CliqueConfigPage1",
		"CliqueConfigPage2",
		"CliqueClickGrabber",
	}
	for _, object in pairs(Frames) do
		MOD:ApplyFrameStyle(_G[object],"Transparent")
		if _G[object] == CliqueConfig then
			_G[object].Panel:SetPoint("TOPLEFT",0,0)
			_G[object].Panel:SetPoint("BOTTOMRIGHT",0,-5)
		elseif _G[object] == CliqueClickGrabber or _G[object] == CliqueScrollFrame then
			_G[object].Panel:SetPoint("TOPLEFT",4,0)
			_G[object].Panel:SetPoint("BOTTOMRIGHT",-2,4)
		else
			_G[object]:SetFrameLevel(_G[object]:GetFrameLevel()+1)
			_G[object].Panel:SetPoint("TOPLEFT",0,0)
			_G[object].Panel:SetPoint("BOTTOMRIGHT",2,0)
		end
	end
	local CliqueButtons = {
		"CliqueConfigPage1ButtonSpell",
		"CliqueConfigPage1ButtonOther",
		"CliqueConfigPage1ButtonOptions",
		"CliqueConfigPage2ButtonBinding",
		"CliqueDialogButtonAccept",
		"CliqueDialogButtonBinding",
		"CliqueConfigPage2ButtonSave",
		"CliqueConfigPage2ButtonCancel",
	}
	for _, object in pairs(CliqueButtons) do
		_G[object]:SetButtonTemplate()
	end
	MOD:ApplyCloseButtonStyle(CliqueDialog.CloseButton)
	local CliqueTabs = {
		"CliqueConfigPage1Column1",
		"CliqueConfigPage1Column2",
	}
	for _, object in pairs(CliqueTabs) do
		_G[object]:Formula409(true)
	end
	CliqueConfigPage1:SetScript("OnShow", function(self)
		for i = 1, 12 do
			if _G["CliqueRow"..i] then
				_G["CliqueRow"..i.."Icon"]:SetTexCoord(0.1,0.9,0.1,0.9);
				_G["CliqueRow"..i.."Bind"]:ClearAllPoints()
				if _G["CliqueRow"..i] == CliqueRow1 then
					_G["CliqueRow"..i.."Bind"]:SetPoint("RIGHT", _G["CliqueRow"..i], 8,0)
				else
					_G["CliqueRow"..i.."Bind"]:SetPoint("RIGHT", _G["CliqueRow"..i], -9,0)
				end
				_G["CliqueRow"..i]:GetHighlightTexture():SetDesaturated(1)
			end
		end
		CliqueRow1:ClearAllPoints()
		CliqueRow1:SetPoint("TOPLEFT",5,-(CliqueConfigPage1Column1:GetHeight() +3))
	end)
	CliqueConfigPage1_VSlider:Formula409(true)
	CliqueDialog:SetSize(CliqueDialog:GetWidth()-1, CliqueDialog:GetHeight()-1)
	CliqueConfigPage1ButtonSpell:ClearAllPoints()
	CliqueConfigPage1ButtonOptions:ClearAllPoints()
	CliqueConfigPage1ButtonSpell:SetPoint("TOPLEFT", CliqueConfigPage1,"BOTTOMLEFT",0,-4)
	CliqueConfigPage1ButtonOptions:SetPoint("TOPRIGHT", CliqueConfigPage1,"BOTTOMRIGHT",2,-4)
	CliqueConfigPage2ButtonSave:ClearAllPoints()
	CliqueConfigPage2ButtonCancel:ClearAllPoints()
	CliqueConfigPage2ButtonSave:SetPoint("TOPLEFT", CliqueConfigPage2,"BOTTOMLEFT",0,-4)
	CliqueConfigPage2ButtonCancel:SetPoint("TOPRIGHT", CliqueConfigPage2,"BOTTOMRIGHT",2,-4)
	CliqueSpellTab:GetRegions():SetSize(.1,.1)
	CliqueSpellTab:GetNormalTexture():SetTexCoord(0.1,0.9,0.1,0.9)
	CliqueSpellTab:GetNormalTexture():ClearAllPoints()
	CliqueSpellTab:GetNormalTexture():FillInner()
	MOD:ApplyFrameStyle(CliqueSpellTab,"Transparent")
	CliqueSpellTab.Panel:SetAllPoints()
	CliqueSpellTab:SetButtonTemplate()
end
MOD:SaveAddonStyle("Clique", StyleClique)