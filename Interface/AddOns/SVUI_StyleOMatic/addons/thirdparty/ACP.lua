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
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L = unpack(SVUI);
local MOD = SuperVillain.Registry:Expose('SVStyle');
--[[ 
########################################################## 
ACP
##########################################################
]]--
local function StyleACP()
	local function cbResize(self,elapsed)
		self.timeLapse = self.timeLapse + elapsed
		if(self.timeLapse < 2) then 
			return 
		else
			self.timeLapse = 0
		end
		for i=1,20,1 do 
			local d=_G["ACP_AddonListEntry"..i.."Enabled"]
			local e=_G["ACP_AddonListEntry"..i.."Collapse"]
			local f=_G["ACP_AddonListEntry"..i.."Security"]
			local g=""
			if g=="" then 
				d:SetPoint("LEFT",5,0)
				if e:IsShown()then 
					d:SetWidth(26)
					d:SetHeight(26)
				else 
					d:SetPoint("LEFT",15,0)
					d:SetWidth(20)
					d:SetHeight(20)
				end 
			end;
			if f:IsShown()then 
				d:SetPoint("LEFT",5,0)
				d:SetWidth(26)
				d:SetHeight(26)
			end 
		end 
	end;
	MOD:ApplyFrameStyle(ACP_AddonList)
	MOD:ApplyFrameStyle(ACP_AddonList_ScrollFrame)
	local h={"ACP_AddonListSetButton","ACP_AddonListDisableAll","ACP_AddonListEnableAll","ACP_AddonList_ReloadUI","ACP_AddonListBottomClose"}
	for i,j in pairs(h)do _G[j]:SetButtonTemplate()end;
	for c=1,20 do _G["ACP_AddonListEntry"..c.."LoadNow"]:SetButtonTemplate()end;
	MOD:ApplyCloseButtonStyle(ACP_AddonListCloseButton)
	for c=1,20,1 do 
		local k=_G["ACP_AddonList"]
		k.timeLapse = 0
		k:SetScript("OnUpdate",cbResize)
	end;
	for c=1,20 do _G["ACP_AddonListEntry"..c.."Enabled"]:SetCheckboxTemplate(true)end;
	ACP_AddonList_NoRecurse:SetCheckboxTemplate(true)
	MOD:ApplyScrollStyle(ACP_AddonList_ScrollFrameScrollBar)
	MOD:ApplyDropdownStyle(ACP_AddonListSortDropDown)
	ACP_AddonListSortDropDown:Width(130)
	ACP_AddonList_ScrollFrame:SetWidth(590)
	ACP_AddonList_ScrollFrame:SetHeight(412)
	ACP_AddonList:SetHeight(502)
	ACP_AddonListEntry1:Point("TOPLEFT",ACP_AddonList,"TOPLEFT",47,-62)
	ACP_AddonList_ScrollFrame:Point("TOPLEFT",ACP_AddonList,"TOPLEFT",20,-53)
	ACP_AddonListCloseButton:Point("TOPRIGHT",ACP_AddonList,"TOPRIGHT",4,5)
	ACP_AddonListSetButton:Point("BOTTOMLEFT",ACP_AddonList,"BOTTOMLEFT",20,8)
	ACP_AddonListSetButton:SetHeight(25)
	ACP_AddonListDisableAll:Point("BOTTOMLEFT",ACP_AddonList,"BOTTOMLEFT",90,8)
	ACP_AddonListDisableAll:SetHeight(25)
	ACP_AddonListEnableAll:Point("BOTTOMLEFT",ACP_AddonList,"BOTTOMLEFT",175,8)
	ACP_AddonListEnableAll:SetHeight(25)
	ACP_AddonList_ReloadUI:Point("BOTTOMRIGHT",ACP_AddonList,"BOTTOMRIGHT",-160,8)
	ACP_AddonListBottomClose:Point("BOTTOMRIGHT",ACP_AddonList,"BOTTOMRIGHT",-50,8)
	ACP_AddonListBottomClose:SetHeight(25)ACP_AddonList:SetParent(UIParent)
end
MOD:SaveAddonStyle("ACP", StyleACP)