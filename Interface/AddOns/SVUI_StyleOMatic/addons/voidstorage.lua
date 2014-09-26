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
local SV = _G.SVUI;
local L = LibStub("LibSuperVillain-1.0"):Lang();
local STYLE = _G.StyleVillain;
--[[ 
########################################################## 
HELPERS
##########################################################
]]--
local VoidStorageList = {
  "VoidStorageBorderFrame",
  "VoidStorageDepositFrame",
  "VoidStorageWithdrawFrame",
  "VoidStorageCostFrame",
  "VoidStorageStorageFrame",
  "VoidStoragePurchaseFrame",
  "VoidItemSearchBox"
};
--[[ 
########################################################## 
VOIDSTORAGE STYLER
##########################################################
]]--
local function VoidStorageStyle()
  if SV.db.SVStyle.blizzard.enable ~= true or SV.db.SVStyle.blizzard.voidstorage ~= true then
     return 
  end

  STYLE:ApplyWindowStyle(VoidStorageFrame, true)

  for _,frame in pairs(VoidStorageList)do 
    _G[frame]:RemoveTextures()
  end

  VoidStoragePurchaseFrame:SetFrameStrata('DIALOG')
  VoidStoragePurchaseFrame:SetFixedPanelTemplate("Button", true)
  VoidStorageFrameMarbleBg:Die()
  VoidStorageFrameLines:Die()

  select(2, VoidStorageFrame:GetRegions()):Die()

  VoidStoragePurchaseButton:SetButtonTemplate()
  VoidStorageHelpBoxButton:SetButtonTemplate()
  VoidStorageTransferButton:SetButtonTemplate()
  STYLE:ApplyCloseButtonStyle(VoidStorageBorderFrame.CloseButton)
  VoidItemSearchBox:SetPanelTemplate("Inset")
  VoidItemSearchBox.Panel:Point("TOPLEFT", 10, -1)
  VoidItemSearchBox.Panel:Point("BOTTOMRIGHT", 4, 1)

  for e = 1, 9 do 
    local f = _G["VoidStorageDepositButton"..e]
    local g = _G["VoidStorageWithdrawButton"..e]
    local h = _G["VoidStorageDepositButton"..e.."IconTexture"]
    local i = _G["VoidStorageWithdrawButton"..e.."IconTexture"]
    _G["VoidStorageDepositButton"..e.."Bg"]:Hide()
    _G["VoidStorageWithdrawButton"..e.."Bg"]:Hide()
    f:SetSlotTemplate(true)
    g:SetSlotTemplate(true)
    h:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    h:FillInner()
    i:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    i:FillInner()
  end 

  for e = 1, 80 do 
    local j = _G["VoidStorageStorageButton"..e]
    local k = _G["VoidStorageStorageButton"..e.."IconTexture"]
    _G["VoidStorageStorageButton"..e.."Bg"]:Hide()
    j:SetSlotTemplate(true)
    k:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    k:FillInner()
  end 
end 
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
STYLE:SaveBlizzardStyle("Blizzard_VoidStorageUI", VoidStorageStyle)