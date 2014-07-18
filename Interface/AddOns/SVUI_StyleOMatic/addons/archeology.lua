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
ARCHEOLOGYFRAME STYLER
##########################################################
]]--
--240 24
local progressBarHolder = CreateFrame("Frame", nil)
progressBarHolder:SetSize(240, 24)
progressBarHolder:SetPoint("BOTTOM", CastingBarFrame, "TOP", 0, 10)
SuperVillain:SetSVMovable(progressBarHolder, "ArcheologyProgressBar_MOVE", "Archeology Progress Bar")

local function ArchaeologyStyle()
	if SuperVillain.db.SVStyle.blizzard.enable ~= true or SuperVillain.db.SVStyle.blizzard.archaeology ~= true then return end ArchaeologyFrame:Formula409()
	ArchaeologyFrameInset:Formula409()
	ArchaeologyFrame:SetPanelTemplate("Transparent")
	ArchaeologyFrame.Panel:SetAllPoints()
	ArchaeologyFrame.portrait:SetAlpha(0)
	ArchaeologyFrameInset:SetPanelTemplate("Inset")
	ArchaeologyFrameInset.Panel:SetPoint("TOPLEFT")
	ArchaeologyFrameInset.Panel:SetPoint("BOTTOMRIGHT", -3, -1)
	ArchaeologyFrameArtifactPageSolveFrameSolveButton:SetButtonTemplate()
	ArchaeologyFrameArtifactPageBackButton:SetButtonTemplate()
	ArchaeologyFrameRaceFilter:SetFrameLevel(ArchaeologyFrameRaceFilter:GetFrameLevel()+2)
	MOD:ApplyDropdownStyle(ArchaeologyFrameRaceFilter, 125)
	MOD:ApplyPaginationStyle(ArchaeologyFrameCompletedPageNextPageButton)
	MOD:ApplyPaginationStyle(ArchaeologyFrameCompletedPagePrevPageButton)
	ArchaeologyFrameRankBar:Formula409()
	ArchaeologyFrameRankBar:SetStatusBarTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
	ArchaeologyFrameRankBar:SetFrameLevel(ArchaeologyFrameRankBar:GetFrameLevel()+2)
	ArchaeologyFrameRankBar:SetPanelTemplate("Default")
	ArchaeologyFrameArtifactPageSolveFrameStatusBar:Formula409()
	ArchaeologyFrameArtifactPageSolveFrameStatusBar:SetStatusBarTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
	ArchaeologyFrameArtifactPageSolveFrameStatusBar:SetStatusBarColor(0.7, 0.2, 0)
	ArchaeologyFrameArtifactPageSolveFrameStatusBar:SetFrameLevel(ArchaeologyFrameArtifactPageSolveFrameStatusBar:GetFrameLevel()+2)
	ArchaeologyFrameArtifactPageSolveFrameStatusBar:SetPanelTemplate("Default")for b = 1, ARCHAEOLOGY_MAX_COMPLETED_SHOWN do local c = _G["ArchaeologyFrameCompletedPageArtifact"..b]
		if c then 
			_G["ArchaeologyFrameCompletedPageArtifact"..b.."Border"]:MUNG()
			_G["ArchaeologyFrameCompletedPageArtifact"..b.."Bg"]:MUNG()
			_G["ArchaeologyFrameCompletedPageArtifact"..b.."Icon"]:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			_G["ArchaeologyFrameCompletedPageArtifact"..b.."Icon"].backdrop = CreateFrame("Frame", nil, c)
			_G["ArchaeologyFrameCompletedPageArtifact"..b.."Icon"].backdrop:SetFixedPanelTemplate("Default")
			_G["ArchaeologyFrameCompletedPageArtifact"..b.."Icon"].backdrop:WrapOuter(_G["ArchaeologyFrameCompletedPageArtifact"..b.."Icon"])
			_G["ArchaeologyFrameCompletedPageArtifact"..b.."Icon"].backdrop:SetFrameLevel(c:GetFrameLevel()-2)
			_G["ArchaeologyFrameCompletedPageArtifact"..b.."Icon"]:SetDrawLayer("OVERLAY")
		end 
	end 
	ArchaeologyFrameArtifactPageIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	ArchaeologyFrameArtifactPageIcon.backdrop = CreateFrame("Frame", nil, ArchaeologyFrameArtifactPage)
	ArchaeologyFrameArtifactPageIcon.backdrop:SetFixedPanelTemplate("Default")
	ArchaeologyFrameArtifactPageIcon.backdrop:WrapOuter(ArchaeologyFrameArtifactPageIcon)
	ArchaeologyFrameArtifactPageIcon.backdrop:SetFrameLevel(ArchaeologyFrameArtifactPage:GetFrameLevel())
	ArchaeologyFrameArtifactPageIcon:SetParent(ArchaeologyFrameArtifactPageIcon.backdrop)
	ArchaeologyFrameArtifactPageIcon:SetDrawLayer("OVERLAY")
	MOD:ApplyCloseButtonStyle(ArchaeologyFrameCloseButton)
	ArcheologyDigsiteProgressBar:SetAllPoints(progressBarHolder)
	progressBarHolder:SetParent(ArcheologyDigsiteProgressBar)
end 
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
MOD:SaveBlizzardStyle("Blizzard_ArchaeologyUI", ArchaeologyStyle)