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
	if SuperVillain.db.SVStyle.blizzard.enable ~= true or SuperVillain.db.SVStyle.blizzard.trainer ~= true then return end;
	for i=1, 8 do
		_G["ClassTrainerScrollFrameButton"..i]:Formula409()
		_G["ClassTrainerScrollFrameButton"..i]:SetFixedPanelTemplate()
		_G["ClassTrainerScrollFrameButton"..i]:SetButtonTemplate()
		_G["ClassTrainerScrollFrameButton"..i.."Icon"]:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		_G["ClassTrainerScrollFrameButton"..i].Panel:WrapOuter(_G["ClassTrainerScrollFrameButton"..i.."Icon"])
		_G["ClassTrainerScrollFrameButton"..i.."Icon"]:SetParent(_G["ClassTrainerScrollFrameButton"..i].Panel)
		_G["ClassTrainerScrollFrameButton"..i].selectedTex:SetTexture(1, 1, 1, 0.3)
		_G["ClassTrainerScrollFrameButton"..i].selectedTex:FillInner()
	end;
	MOD:ApplyScrollStyle(ClassTrainerScrollFrameScrollBar, 5)
	for _,frame in pairs(ClassTrainerFrameList)do
		_G[frame]:Formula409()
	end;
	for _,texture in pairs(ClassTrainerTextureList)do
		_G[texture]:MUNG()
	end;
	_G["ClassTrainerTrainButton"]:Formula409()
	_G["ClassTrainerTrainButton"]:SetButtonTemplate()
	MOD:ApplyDropdownStyle(ClassTrainerFrameFilterDropDown, 155)
	ClassTrainerFrame:SetHeight(ClassTrainerFrame:GetHeight()+42)
	ClassTrainerFrame:SetPanelTemplate("Halftone")
	ClassTrainerScrollFrame:SetFixedPanelTemplate("Inset")
	MOD:ApplyCloseButtonStyle(ClassTrainerFrameCloseButton, ClassTrainerFrame)
	ClassTrainerFrameSkillStepButton.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	ClassTrainerFrameSkillStepButton:SetFixedPanelTemplate("Button", true)
	--ClassTrainerFrameSkillStepButton.Panel:WrapOuter(ClassTrainerFrameSkillStepButton.icon)
	--ClassTrainerFrameSkillStepButton.icon:SetParent(ClassTrainerFrameSkillStepButton.Panel)
	ClassTrainerFrameSkillStepButtonHighlight:SetTexture(1, 1, 1, 0.3)
	ClassTrainerFrameSkillStepButton.selectedTex:SetTexture(1, 1, 1, 0.3)
	ClassTrainerStatusBar:Formula409()
	ClassTrainerStatusBar:SetStatusBarTexture(SuperVillain.Media.bar.default)
	ClassTrainerStatusBar:SetPanelTemplate("Slot", true, 1, 2, 2)
	ClassTrainerStatusBar.rankText:ClearAllPoints()
	ClassTrainerStatusBar.rankText:SetPoint("CENTER", ClassTrainerStatusBar, "CENTER")
end;
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
MOD:SaveBlizzardStyle("Blizzard_TrainerUI",TrainerStyle)