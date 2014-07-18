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
local SuperVillain, L = unpack(select(2, ...));
local Totems = CreateFrame("Frame");
local TotemBar;
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
local Totems_OnEvent = function(self, event)
	if not TotemBar then return end 
	local displayedTotems = 0;
	for i=1,MAX_TOTEMS do
		if TotemBar[i] then
			local haveTotem, name, start, duration, icon = GetTotemInfo(i)
			if haveTotem and icon and icon ~= '' then 
				TotemBar[i]:Show()
				TotemBar[i].Icon:SetTexture(icon)
				displayedTotems = displayedTotems + 1;
				CooldownFrame_SetTimer(TotemBar[i].CD, start, duration, 1)
				for i=1,MAX_TOTEMS do 
					if _G['TotemFrameTotem'..i..'IconTexture']:GetTexture()==icon then 
						_G['TotemFrameTotem'..i]:ClearAllPoints()
						_G['TotemFrameTotem'..i]:SetParent(TotemBar[i].Anchor)
						_G['TotemFrameTotem'..i]:SetAllPoints(TotemBar[i].Anchor)
					end 
				end 
			else 
				TotemBar[i]:Hide()
			end
		end
	end
end 

function SuperVillain:UpdateTotems()
	local totemSize = self.db.system.totems.size;
	local totemSpace = self.db.system.totems.spacing;
	local totemGrowth = self.db.system.totems.showBy;
	local totemSort = self.db.system.totems.sortDirection;

	for i = 1, MAX_TOTEMS do 
		local button = TotemBar[i]
		local lastButton = TotemBar[i - 1]
		button:Size(totemSize)
		button:ClearAllPoints()
		if(totemGrowth == "HORIZONTAL" and totemSort == "ASCENDING") then 
			if(i == 1) then 
				button:SetPoint("LEFT", TotemBar, "LEFT", totemSpace, 0)
			elseif lastButton then 
				button:SetPoint("LEFT", lastButton, "RIGHT", totemSpace, 0)
			end 
		elseif(totemGrowth == "VERTICAL" and totemSort == "ASCENDING") then
			if(i == 1) then 
				button:SetPoint("TOP", TotemBar, "TOP", 0, -totemSpace)
			elseif lastButton then 
				button:SetPoint("TOP", lastButton, "BOTTOM", 0, -totemSpace)
			end 
		elseif(totemGrowth == "HORIZONTAL" and totemSort == "DESCENDING") then 
			if(i == 1) then 
				button:SetPoint("RIGHT", TotemBar, "RIGHT", -totemSpace, 0)
			elseif lastButton then 
				button:SetPoint("RIGHT", lastButton, "LEFT", -totemSpace, 0)
			end 
		else 
			if(i == 1) then 
				button:SetPoint("BOTTOM", TotemBar, "BOTTOM", 0, totemSpace)
			elseif lastButton then 
				button:SetPoint("BOTTOM", lastButton, "TOP", 0, totemSpace)
			end 
		end 
	end 
	local tS1 = ((totemSize  *  MAX_TOTEMS)  +  (totemSpace  *  MAX_TOTEMS)  +  totemSpace);
	local tS2 = (totemSize  +  (totemSpace  *  2));
	local tW = (totemGrowth == "HORIZONTAL" and tS1 or tS2);
	local tH = (totemGrowth == "HORIZONTAL" and tS2 or tS1);
	TotemBar:Size(tW, tH);
	Totems_OnEvent()
end 

local function CreateTotemBar()
	if(not SuperVillain.db.system.totems.enable) then return; end
	local xOffset = SuperVillain.db.SVDock.dockLeftWidth + 12
	TotemBar = CreateFrame("Frame", nil, SuperVillain.UIParent)
	TotemBar:SetPoint("BOTTOMLEFT", SuperVillain.UIParent, "BOTTOMLEFT", xOffset, 40)
	for i = 1, MAX_TOTEMS do 
		local totem = CreateFrame("Button", "TotemBarTotem"..i, TotemBar)
		totem:SetID(i)
		totem:SetButtonTemplate()
		totem:Hide()
		totem.Anchor = CreateFrame("Frame", nil, totem)
		totem.Anchor:SetAlpha(0)
		totem.Anchor:SetAllPoints()
		totem.Icon = totem:CreateTexture(nil, "ARTWORK")
		totem.Icon:FillInner()
		totem.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		totem.CD = CreateFrame("Cooldown", "TotemBarTotem"..i.."Cooldown", totem, "CooldownFrameTemplate")
		totem.CD:SetReverse(true)
		totem.CD:FillInner()
		SuperVillain:AddCD(totem.CD)
		TotemBar[i] = totem 
	end 
	TotemBar:Show()
	Totems:RegisterEvent("PLAYER_TOTEM_UPDATE")
	Totems:RegisterEvent("PLAYER_ENTERING_WORLD")
	Totems:SetScript("OnEvent", Totems_OnEvent)
	Totems_OnEvent()
	SuperVillain:UpdateTotems()
	local frame_name;
	if SuperVillain.class == "DEATHKNIGHT" then
		frame_name = L["Ghoul Bar"]
	elseif SuperVillain.class == "DRUID" then
		frame_name = L["Mushroom Bar"]
	else
		frame_name = L["Totem Bar"]
	end
	SuperVillain:SetSVMovable(TotemBar, "TotemBar_MOVE", frame_name)
end 

SuperVillain.Registry:NewScript(CreateTotemBar);