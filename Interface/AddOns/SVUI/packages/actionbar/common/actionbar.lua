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
local LibAB = LibStub("LibActionButton-1.0");
local NUM_ACTIONBAR_BUTTONS = NUM_ACTIONBAR_BUTTONS
local pointSets = {
  {"BOTTOM","SVUIParent","BOTTOM",0,28},
  {"BOTTOM","SVUI_ActionBar1","TOP",0,2},
  {"BOTTOMLEFT","SVUI_ActionBar1","BOTTOMRIGHT",2,0},
  {"RIGHT","SVUIParent","RIGHT",-2,0},
  {"BOTTOMRIGHT","SVUI_ActionBar1","BOTTOMLEFT",2,0},
  {"BOTTOM","SVUI_ActionBar2","TOP",0,2},
};
--[[ 
########################################################## 
PACKAGE PLUGIN
##########################################################
]]--
local CreateActionBars = function(self)
	for i = 1, 6 do 
		local barID = "Bar"..i;
		local position = pointSets[i]
		local parent = _G[position[2]]
		local buttonMax = NUM_ACTIONBAR_BUTTONS;
		local thisBar = CreateFrame("Frame", "SVUI_Action"..barID, SuperVillain.UIParent, "SecureHandlerStateTemplate")
		thisBar:Point(position[1], parent, position[3], position[4], position[5])
		local bg = CreateFrame("Frame", nil, thisBar)
		bg:SetAllPoints()
		bg:SetFrameLevel(0);
		thisBar:SetFrameLevel(5);
		bg:SetPanelTemplate("Component")
		bg:SetPanelColor("dark")
		thisBar.backdrop = bg;
		self.Storage[barID].buttons = {}
		for k = 1, buttonMax do 
			self.Storage[barID].buttons[k] = LibAB:CreateButton(k, "SVUI_Action"..barID.."Button"..k, thisBar, nil)
			self.Storage[barID].buttons[k]:SetState(0, "action", k)
			for x = 1, 14 do 
				local calc = (x - 1)  *  buttonMax  +  k;
				self.Storage[barID].buttons[k]:SetState(x, "action", calc)
			end;
			if k == 12 then 
				self.Storage[barID].buttons[k]:SetState(12, "custom", {
					func = function(...) 
						if UnitExists("vehicle") then 
							VehicleExit() 
						else 
							PetDismiss() 
						end 
					end, 
					texture = "Interface\\Vehicles\\UI-Vehicles-Button-Exit-Down", 
					tooltip = LEAVE_VEHICLE
				});
			end 
		end;
		self:SetBarConfigData(barID)
		if i == 1 then 
			thisBar:SetAttribute("hasTempBar", true)
		else 
			thisBar:SetAttribute("hasTempBar", false)
		end;
		thisBar:SetAttribute("_onstate-page", [[
			if HasTempShapeshiftActionBar() and self:GetAttribute("hasTempBar") then
				newstate = GetTempShapeshiftBarIndex() or newstate
			end

			if newstate ~= 0 then
				self:SetAttribute("state", newstate)
				control:ChildUpdate("state", newstate)
			else
				local newCondition = self:GetAttribute("newCondition")
				if newCondition then
					newstate = SecureCmdOptionParse(newCondition)
					self:SetAttribute("state", newstate)
					control:ChildUpdate("state", newstate)
				end
			end
		]]);
		self.Storage[barID].bar = thisBar;
		self:RefreshBar(barID)
		SuperVillain:SetSVMovable(thisBar, "SVUI_Action"..barID.."_MOVE", L[barID], nil, nil, nil, "ALL, ACTIONBARS")
	end 
end;

SuperVillain.Registry:Temp("SVBar", CreateActionBars)