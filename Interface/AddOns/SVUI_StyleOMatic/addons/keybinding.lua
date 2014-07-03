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
KEYBINDING STYLER
##########################################################
]]--
local function BindingStyle()
	if SuperVillain.db.SVStyle.blizzard.enable ~= true or SuperVillain.db.SVStyle.blizzard.binding ~= true then return end;
	local buttons = {"KeyBindingFrameDefaultButton", "KeyBindingFrameUnbindButton", "KeyBindingFrameOkayButton", "KeyBindingFrameCancelButton"}
	for l, m in pairs(buttons)do 
		_G[m]:Formula409()_G[m]:SetFixedPanelTemplate("Default")
	end;
	MOD:ApplyScrollStyle(KeyBindingFrameScrollFrameScrollBar)
	KeyBindingFrameCharacterButton:SetCheckboxTemplate(true)
	KeyBindingFrameHeaderText:ClearAllPoints()
	KeyBindingFrameHeaderText:Point("TOP", KeyBindingFrame, "TOP", 0, -4)
	KeyBindingFrame:Formula409()
	KeyBindingFrame:SetPanelTemplate("Halftone")
	for b = 1, KEY_BINDINGS_DISPLAYED do 
		local n = _G["KeyBindingFrameBinding"..b.."Key1Button"]
		local o = _G["KeyBindingFrameBinding"..b.."Key2Button"]
		n:Formula409(true)
		n:SetButtonTemplate()
		n:SetFixedPanelTemplate("Default")
		o:Formula409(true)
		o:SetButtonTemplate()
		o:SetFixedPanelTemplate("Default")
	end;
	KeyBindingFrameUnbindButton:Point("RIGHT", KeyBindingFrameOkayButton, "LEFT", -3, 0)KeyBindingFrameOkayButton:Point("RIGHT", KeyBindingFrameCancelButton, "LEFT", -3, 0)
end;
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
MOD:SaveBlizzardStyle("Blizzard_BindingUI",BindingStyle)