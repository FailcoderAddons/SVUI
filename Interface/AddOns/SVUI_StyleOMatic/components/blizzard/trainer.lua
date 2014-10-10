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
local ClassTrainerFrameList = {
	"ClassTrainerFrame",
	"ClassTrainerScrollFrameScrollChild",
	"ClassTrainerFrameSkillStepButton",
	"ClassTrainerFrameBottomInset"
};
local ClassTrainerTextureList = {
	"ClassTrainerFrameInset",
	"ClassTrainerFramePortrait",
	"ClassTrainerScrollFrameScrollBarBG",
	"ClassTrainerScrollFrameScrollBarTop",
	"ClassTrainerScrollFrameScrollBarBottom",
	"ClassTrainerScrollFrameScrollBarMiddle"
};
--[[ 
########################################################## 
TRAINER STYLER
##########################################################
]]--
local function TrainerStyle()
	if SV.db[Schema].blizzard.enable ~= true or SV.db[Schema].blizzard.trainer ~= true then return end

	ClassTrainerFrame:SetHeight(ClassTrainerFrame:GetHeight() + 42)
	STYLE:ApplyWindowStyle(ClassTrainerFrame)

	for i=1, 8 do
		_G["ClassTrainerScrollFrameButton"..i]:RemoveTextures()
		_G["ClassTrainerScrollFrameButton"..i]:SetFixedPanelTemplate()
		_G["ClassTrainerScrollFrameButton"..i]:SetButtonTemplate()
		_G["ClassTrainerScrollFrameButton"..i.."Icon"]:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		_G["ClassTrainerScrollFrameButton"..i].Panel:WrapOuter(_G["ClassTrainerScrollFrameButton"..i.."Icon"])
		_G["ClassTrainerScrollFrameButton"..i.."Icon"]:SetParent(_G["ClassTrainerScrollFrameButton"..i].Panel)
		_G["ClassTrainerScrollFrameButton"..i].selectedTex:SetTexture(1, 1, 1, 0.3)
		_G["ClassTrainerScrollFrameButton"..i].selectedTex:FillInner()
	end

	STYLE:ApplyScrollFrameStyle(ClassTrainerScrollFrameScrollBar, 5)

	for _,frame in pairs(ClassTrainerFrameList)do
		_G[frame]:RemoveTextures()
	end

	for _,texture in pairs(ClassTrainerTextureList)do
		_G[texture]:Die()
	end

	_G["ClassTrainerTrainButton"]:RemoveTextures()
	_G["ClassTrainerTrainButton"]:SetButtonTemplate()
	STYLE:ApplyDropdownStyle(ClassTrainerFrameFilterDropDown, 155)
	ClassTrainerScrollFrame:SetFixedPanelTemplate("Inset")
	STYLE:ApplyCloseButtonStyle(ClassTrainerFrameCloseButton, ClassTrainerFrame)
	ClassTrainerFrameSkillStepButton.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	ClassTrainerFrameSkillStepButton:SetFixedPanelTemplate("Button", true)
	--ClassTrainerFrameSkillStepButton.Panel:WrapOuter(ClassTrainerFrameSkillStepButton.icon)
	--ClassTrainerFrameSkillStepButton.icon:SetParent(ClassTrainerFrameSkillStepButton.Panel)
	ClassTrainerFrameSkillStepButtonHighlight:SetTexture(1, 1, 1, 0.3)
	ClassTrainerFrameSkillStepButton.selectedTex:SetTexture(1, 1, 1, 0.3)
	ClassTrainerStatusBar:RemoveTextures()
	ClassTrainerStatusBar:SetStatusBarTexture(SV.Media.bar.default)
	ClassTrainerStatusBar:SetPanelTemplate("Slot", true, 1, 2, 2)
	ClassTrainerStatusBar.rankText:ClearAllPoints()
	ClassTrainerStatusBar.rankText:SetPoint("CENTER", ClassTrainerStatusBar, "CENTER")
end 
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
STYLE:SaveBlizzardStyle("Blizzard_TrainerUI",TrainerStyle)