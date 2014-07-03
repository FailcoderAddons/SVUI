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
DRESSUP STYLER
##########################################################
]]--
local function DressUpStyle()
	if SuperVillain.db.SVStyle.blizzard.enable ~= true or SuperVillain.db.SVStyle.blizzard.dressingroom ~= true then
		 return 
	end;
	DressUpFrame:Formula409(true)
	local w = DressUpFrame:GetWidth() - 32
	local h = DressUpFrame:GetHeight() - 72
	local bg = CreateFrame("Frame",nil,DressUpFrame)
	local lvl = DressUpFrame:GetFrameLevel()
	if lvl > 0 then
		lvl = lvl - 1
	end
	bg:SetPoint("TOPLEFT",DressUpFrame,"TOPLEFT",7,-7)
	bg:SetSize(w,h)
	bg:SetFrameLevel(lvl)
	bg:SetPanelTemplate("Pattern")
	DressUpModel:SetFixedPanelTemplate("Comic")
	DressUpModel:SetPanelColor("special")
	DressUpFrameResetButton:SetButtonTemplate()
	DressUpFrameCancelButton:SetButtonTemplate()
	MOD:ApplyCloseButtonStyle(DressUpFrameCloseButton, bg.Panel)
	DressUpFrameResetButton:Point("RIGHT", DressUpFrameCancelButton, "LEFT", -2, 0)
end;
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
MOD:SaveCustomStyle(DressUpStyle)