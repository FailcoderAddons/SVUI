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

STATS:Extend EXAMPLE USAGE: MOD:Extend(newStat,eventList,onEvents,update,click,focus,blur)

########################################################## 
LOCALIZED LUA FUNCTIONS
##########################################################
]]--
--[[ GLOBALS ]]--
local _G = _G;
local unpack 	= _G.unpack;
local select 	= _G.select;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L = unpack(select(2, ...));
local LDB = LibStub:GetLibrary("LibDataBroker-1.1");
--[[ 
########################################################## 
GOLD STATS
##########################################################
]]--
local LoadStatBroker = function(MOD)
	local OnEnter, OnLeave, lastObj;
  	for dataName, dataObj in LDB:DataObjectIterator()do 
	    OnEnter = nil;
	    OnLeave = nil;
	    lastObj = nil;
	    if dataObj.OnEnter then 
	      	OnEnter = function(self)
				MOD:Tip(self)
				dataObj.OnTooltipShow(MOD.tooltip)
				MOD:ShowTip()
			end
	    elseif dataObj.OnTooltipShow then 
	      	OnEnter = function(self)
				MOD:Tip(self)
				dataObj.OnTooltipShow(MOD.tooltip)
				MOD:ShowTip()
			end
	    end;
	    if dataObj.OnLeave then 
			OnLeave = function(self)
				dataObj.OnLeave(self)
				MOD.tooltip:Hide()
			end 
	    end;
	    local OnClick = function(self, e)
	      	dataObj.OnClick(self, e)
	    end;
	    local CallBack = function(_, name, _, value, _)
			if(value == nil or len(value) > 5 or value == "n / a" or name == value) then 
				lastObj.text:SetText(value ~= "n / a" and value or name)
			else 
				lastObj.text:SetText(name..": "..hexString..value.."|r")
			end 
	    end;
	    local OnEvent = function(self)
			lastObj = self;
			LDB:RegisterCallback("LibDataBroker_AttributeChanged_"..dataName.."_text", CallBack)
			LDB:RegisterCallback("LibDataBroker_AttributeChanged_"..dataName.."_value", CallBack)
			LDB.callbacks:Fire("LibDataBroker_AttributeChanged_"..dataName.."_text", dataName, nil, dataObj.text, dataObj)
	    end;
	    MOD:Extend(dataName, {"PLAYER_ENTER_WORLD"}, OnEvent, nil, OnClick, OnEnter, OnLeave)
  	end
end
SuperVillain.Registry:Temp("SVStats", LoadStatBroker)