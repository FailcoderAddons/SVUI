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
local MOD = SuperVillain.Registry:Expose('SVUnit');
local _, ns = ...
local oUF_SuperVillain = ns.oUF
--[[ MUNGLUNCH's FASTER ASSERT FUNCTION ]]--
local assert = enforce;
assert(oUF_SuperVillain, "SVUI was unable to locate oUF.");
local LSM = LibStub("LibSharedMedia-3.0");
--[[ 
########################################################## 
LOCAL VARIABLES
##########################################################
]]--
local random = math.random;
local token={[0]="MANA",[1]="RAGE",[2]="FOCUS",[3]="ENERGY",[6]="RUNIC_POWER"}
--[[ 
########################################################## 
LOCAL FUNCTIONS
##########################################################
]]--
local PostUpdateAltPower = function(self,min,current,max)
	local remaining=floor(current / max * 100)
	local parent=self:GetParent()
	if remaining < 35 then 
		self:SetStatusBarColor(0,1,0)
	elseif remaining < 70 then 
		self:SetStatusBarColor(1,1,0)
	else 
		self:SetStatusBarColor(1,0,0)
	end;
	local unit=parent.unit;
	if(unit == "player" and self.text) then 
		local apInfo=select(10,UnitAlternatePowerInfo(unit))
		if remaining > 0 then 
			self.text:SetText(apInfo..": "..format("%d%%",remaining))
		else 
			self.text:SetText(apInfo..": 0%")
		end 
	elseif(unit and unit:find("boss%d") and self.text) then 
		self.text:SetTextColor(self:GetStatusBarColor())
		if not parent.Power.value:GetText() or parent.Power.value:GetText()=="" then 
			self.text:Point("BOTTOMRIGHT",parent.Health,"BOTTOMRIGHT")
		else 
			self.text:Point("RIGHT", parent.Power.value.value, "LEFT", 2, 0)
		end;
		if remaining > 0 then 
			self.text:SetText("|cffD7BEA5[|r"..format("%d%%",remaining).."|cffD7BEA5]|r")
		else 
			self.text:SetText(nil)
		end 
	end 
end;
--[[ 
########################################################## 
BUILD FUNCTION
##########################################################
]]--
function MOD:CreatePowerBar(frame,bg,text,direction)
	local power=CreateFrame('StatusBar',nil,frame)
	MOD:SetUnitStatusbar(power)
	power:SetPanelTemplate("Inset")
	if bg then 
		power.bg=power:CreateTexture(nil,'BORDER')
		power.bg:SetAllPoints()
		power.bg:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
		power.bg.multiplier=0.2 
	end;
	if text then 
		power.value=frame.InfoPanel:CreateFontString(nil,'OVERLAY')
		power.value.db='power'MOD:SetUnitFont(power.value)
		power.value:SetParent(frame.InfoPanel)
		local offset = -2;
		if direction=='LEFT'then offset=2 end;
		power.value:Point(direction,frame.Health,direction,offset,0)
	end;
	power.colorDisconnected=false;
	power.colorTapping=false;
	power.PostUpdate=MOD.PostUpdatePower;
	return power 
end;

function MOD:CreateAltPowerBar(frame)
	local altPower = CreateFrame("StatusBar",nil,frame)
	MOD:SetUnitStatusbar(altPower)
	altPower:SetPanelTemplate("Inset")
	altPower:GetStatusBarTexture():SetHorizTile(false)
	altPower:SetFrameStrata("MEDIUM")
	altPower.text = altPower:CreateFontString(nil,'OVERLAY')
	altPower.text:SetPoint("CENTER")
	altPower.text:SetJustifyH("CENTER")
	MOD:SetUnitFont(altPower.text)
	altPower.PostUpdate = PostUpdateAltPower;
	return altPower 
end;
--[[ 
########################################################## 
UPDATE
##########################################################
]]--
function MOD:PowerUpdateNamePosition(frame,unit)
	if not frame.Power.value:IsShown() or not frame.Name then return end;
	local db = frame.db;
	local parent = frame.Name:GetParent()
	if UnitIsPlayer(unit)then 
		local point = db.name.position;
		frame.Power.value:SetAlpha(1)
		frame.Name:ClearAllPoints()
		SuperVillain:ReversePoint(frame.Name, point, parent, db.name.xOffset, db.name.yOffset)
	else 
		frame.Power.value:SetAlpha(db.power.hideonnpc and 0 or 1)
		frame.Name:ClearAllPoints()
		frame.Name:SetPoint(frame.Power.value:GetPoint())
	end;
end;

function MOD:PostUpdatePower(unit,value,max)
	local powerType,_,_,_,_ = UnitPowerType(unit)
	local parent=self:GetParent()
	if parent.isForced then
		value = random(1, max)
		powerType = random(0, 4)
		self:SetValue(value)
	end;
	local colors=oUF_SuperVillain.colors.power[token[powerType]]
	local mult = self.bg.multiplier or 1;
	local isPlayer = UnitPlayerControlled(unit)
	if isPlayer and self.colorClass then 
		local _,class=UnitClassBase(unit);
		colors=oUF_SuperVillain['colors'].class[class]
	elseif not isPlayer then 
		local react=UnitReaction("player",unit)
		colors=oUF_SuperVillain['colors'].reaction[react]
	end;
	if not colors then return end
	self:SetStatusBarColor(colors[1],colors[2],colors[3])
	self.bg:SetVertexColor(colors[1]*mult,colors[2]*mult,colors[3]*mult)
	local db=parent.db;
	if db and db.power and db.power.hideonnpc then 
		MOD:PowerUpdateNamePosition(parent,unit)
	end 
end;