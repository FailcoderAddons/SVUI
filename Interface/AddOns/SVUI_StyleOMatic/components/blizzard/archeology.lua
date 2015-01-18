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
local unpack  = _G.unpack;
local select  = _G.select;
--[[ ADDON ]]--
local SV = _G.SVUI;
local L = SV.L;
local PLUGIN = select(2, ...);
local Schema = PLUGIN.Schema;
--[[ 
########################################################## 
ARCHEOLOGYFRAME PLUGINR
##########################################################
]]--
local function ArchaeologyStyle()
	if PLUGIN.db.blizzard.enable ~= true or PLUGIN.db.blizzard.archaeology ~= true then return end 

	ArchaeologyFrame:RemoveTextures()
	ArchaeologyFrameInset:RemoveTextures()
	ArchaeologyFrame:SetStylePanel("Frame", "Composite1")
	ArchaeologyFrame.Panel:SetAllPoints()
	ArchaeologyFrame.portrait:SetAlpha(0)
	ArchaeologyFrameInset:SetStylePanel("Frame", "Inset")
	ArchaeologyFrameInset.Panel:SetPoint("TOPLEFT")
	ArchaeologyFrameInset.Panel:SetPoint("BOTTOMRIGHT", -3, -1)
	ArchaeologyFrameArtifactPageSolveFrameSolveButton:SetStylePanel("Button")
	ArchaeologyFrameArtifactPageBackButton:SetStylePanel("Button")
	ArchaeologyFrameRaceFilter:SetFrameLevel(ArchaeologyFrameRaceFilter:GetFrameLevel()+2)
	PLUGIN:ApplyDropdownStyle(ArchaeologyFrameRaceFilter, 125)
	PLUGIN:ApplyPaginationStyle(ArchaeologyFrameCompletedPageNextPageButton)
	PLUGIN:ApplyPaginationStyle(ArchaeologyFrameCompletedPagePrevPageButton)
	ArchaeologyFrameRankBar:RemoveTextures()
	ArchaeologyFrameRankBar:SetStatusBarTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
	ArchaeologyFrameRankBar:SetFrameLevel(ArchaeologyFrameRankBar:GetFrameLevel()+2)
	ArchaeologyFrameRankBar:SetStylePanel("Frame", "Default")
	ArchaeologyFrameArtifactPageSolveFrameStatusBar:RemoveTextures()
	ArchaeologyFrameArtifactPageSolveFrameStatusBar:SetStatusBarTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
	ArchaeologyFrameArtifactPageSolveFrameStatusBar:SetStatusBarColor(0.7, 0.2, 0)
	ArchaeologyFrameArtifactPageSolveFrameStatusBar:SetFrameLevel(ArchaeologyFrameArtifactPageSolveFrameStatusBar:GetFrameLevel()+2)
	ArchaeologyFrameArtifactPageSolveFrameStatusBar:SetStylePanel("Frame", "Default")

	for b = 1, ARCHAEOLOGY_MAX_COMPLETED_SHOWN do 
		local c = _G["ArchaeologyFrameCompletedPageArtifact"..b]
		if c then 
			_G["ArchaeologyFrameCompletedPageArtifact"..b.."Border"]:Die()
			_G["ArchaeologyFrameCompletedPageArtifact"..b.."Bg"]:Die()
			_G["ArchaeologyFrameCompletedPageArtifact"..b.."Icon"]:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			_G["ArchaeologyFrameCompletedPageArtifact"..b.."Icon"].backdrop = CreateFrame("Frame", nil, c)
			_G["ArchaeologyFrameCompletedPageArtifact"..b.."Icon"].backdrop:SetStylePanel("!_Frame", "Default")
			_G["ArchaeologyFrameCompletedPageArtifact"..b.."Icon"].backdrop:SetAllPointsOut(_G["ArchaeologyFrameCompletedPageArtifact"..b.."Icon"])
			_G["ArchaeologyFrameCompletedPageArtifact"..b.."Icon"].backdrop:SetFrameLevel(c:GetFrameLevel()-2)
			_G["ArchaeologyFrameCompletedPageArtifact"..b.."Icon"]:SetDrawLayer("OVERLAY")
		end 
	end
	
	ArchaeologyFrameArtifactPageIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	ArchaeologyFrameArtifactPageIcon.backdrop = CreateFrame("Frame", nil, ArchaeologyFrameArtifactPage)
	ArchaeologyFrameArtifactPageIcon.backdrop:SetStylePanel("!_Frame", "Default")
	ArchaeologyFrameArtifactPageIcon.backdrop:SetAllPointsOut(ArchaeologyFrameArtifactPageIcon)
	ArchaeologyFrameArtifactPageIcon.backdrop:SetFrameLevel(ArchaeologyFrameArtifactPage:GetFrameLevel())
	ArchaeologyFrameArtifactPageIcon:SetParent(ArchaeologyFrameArtifactPageIcon.backdrop)
	ArchaeologyFrameArtifactPageIcon:SetDrawLayer("OVERLAY")
	PLUGIN:ApplyCloseButtonStyle(ArchaeologyFrameCloseButton)

	local progressBarHolder = CreateFrame("Frame", "SVUI_ArcheologyProgressBar", nil)
	progressBarHolder:SetSize(240, 24)
	progressBarHolder:SetPoint("BOTTOM", CastingBarFrame, "TOP", 0, 10)
	SV.Mentalo:Add(progressBarHolder, "Archeology Progress Bar")
	
	ArcheologyDigsiteProgressBar:SetAllPoints(progressBarHolder)
	progressBarHolder:SetParent(ArcheologyDigsiteProgressBar)
end 
--[[ 
########################################################## 
PLUGIN LOADING
##########################################################
]]--
PLUGIN:SaveBlizzardStyle("Blizzard_ArchaeologyUI", ArchaeologyStyle)