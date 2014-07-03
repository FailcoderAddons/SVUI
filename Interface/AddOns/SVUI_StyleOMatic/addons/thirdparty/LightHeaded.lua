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
LIGHTHEADED
##########################################################
]]--
local timeLapse = 0;

local function DoDis(self, elapsed)
	self.timeLapse = self.timeLapse + elapsed
	if(self.timeLapse < 2) then 
		return 
	else
		self.timeLapse = 0
	end
	QuestNPCModel:ClearAllPoints()
	QuestNPCModel:SetPoint("TOPLEFT", LightHeadedFrame, "TOPRIGHT", 5, -10)
	QuestNPCModel:SetAlpha(0.85)
	LightHeadedFrame:SetPoint("LEFT", QuestLogFrame, "RIGHT", 2, 0)
end

local function StyleLightHeaded()
	MOD:ApplyFrameStyle(LightHeadedFrame)
	MOD:ApplyFrameStyle(LightHeadedFrameSub)
	MOD:ApplyFrameStyle(LightHeadedSearchBox)
	MOD:ApplyTooltipStyle(LightHeadedTooltip)
	LightHeadedScrollFrame:Formula409()
	local lhframe = LightHeadedFrame		
	lhframe.close:Hide()
	MOD:ApplyCloseButtonStyle(lhframe.close)
	lhframe.handle:Hide()
	local lhframe = LightHeadedFrameSub
	MOD:ApplyPaginationStyle(lhframe.prev)
	MOD:ApplyPaginationStyle(lhframe.next)
	lhframe.prev:SetWidth(16)
	lhframe.prev:SetHeight(16)
	lhframe.next:SetWidth(16)
	lhframe.next:SetHeight(16)
	lhframe.prev:SetPoint("RIGHT", lhframe.page, "LEFT", -25, 0)
	lhframe.next:SetPoint("LEFT", lhframe.page, "RIGHT", 25, 0)
	MOD:ApplyScrollStyle(LightHeadedScrollFrameScrollBar, 5)
	lhframe.title:SetTextColor(23/255, 132/255, 209/255)	
	local LH_OnLoad = _G["LightHeadedFrame"]
	LH_OnLoad.timeLapse = 0;
	LH_OnLoad:SetScript("OnUpdate", DoDis)
	local LH_Options = _G["LightHeaded_Panel"]
	if LH_Options:IsVisible() then
		for i = 1, 9 do
			local cbox = _G["LightHeaded_Panel_Toggle"..i]
			cbox:SetCheckboxTemplate(true)
		end
		local buttons = {
			"LightHeaded_Panel_Button1",
			"LightHeaded_Panel_Button2",
		}

		for _, button in pairs(buttons) do
			_G[button]:SetButtonTemplate()
		end

		LightHeaded_Panel_Button2:Disable()
	end
end
MOD:SaveAddonStyle("Lightheaded", StyleLightHeaded)