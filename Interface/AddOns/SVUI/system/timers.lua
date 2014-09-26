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
local type 		= _G.type;
local tinsert 	= _G.tinsert;
local string 	= _G.string;
local math 		= _G.math;
local table 	= _G.table;
--[[ STRING METHODS ]]--
local format = string.format;
--[[ MATH METHODS ]]--
local abs, ceil, floor, round = math.abs, math.ceil, math.floor, math.round;
--[[ TABLE METHODS ]]--
local tremove = table.remove;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SVUI_ADDON_NAME, SV = ...
local L = LibStub("LibSuperVillain-1.0"):Lang();
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local TIMERFONT = [[Interface\AddOns\SVUI\assets\fonts\Numbers.ttf]];
--[[ 
########################################################## 
TIMERS
##########################################################
ExecuteTimer: Create a timer that runs once and CANNOT be stopped
ExecuteLoop: Create a timer that loops continuously and CAN be removed

NEW IN WOD: local timerloop = C_Timer.NewTicker(duration, callback, [iterations])
]]--
local Timers = CreateFrame("Frame");
Timers.TimerCount = 0;
Timers.Queue = {};

local ExeTimerManager_OnUpdate = function(self, elapsed)
	if(self.TimerCount > 0) then
		for id,_ in pairs(self.Queue) do
			local callback = self.Queue[id]
			if(callback.f) then
				if callback.t > elapsed then
					local newTime = callback.t - elapsed
					self.Queue[id].t = newTime
				else
					callback.f()
					if(callback.x) then
						self.Queue[id].t = callback.x
					else
						self.Queue[id] = nil
						self.TimerCount = self.TimerCount - 1;
					end
				end
			end
		end
	end
end

local function CallbackCheck(id)
	return function() return Timers.Queue[id] == nil end
end

function Timers:ExecuteCallbackTimer(timeOutFunction, duration)
	if(type(duration) == "number" and type(timeOutFunction) == "function") then
		self.TimerCount = self.TimerCount + 1
		local id = "LOOP" .. self.TimerCount;
		self.Queue[id] = {t = duration, f = timeOutFunction}
		return CallbackCheck(id)
	end 
	return false 
end

function Timers:ExecuteTimer(timeOutFunction, duration, idCheck)
	if(type(duration) == "number" and type(timeOutFunction) == "function") then
		if(idCheck and self.Queue[idCheck]) then
			self.Queue[idCheck].t = duration
			return idCheck
		else
			self.TimerCount = self.TimerCount + 1
			local id = "LOOP" .. self.TimerCount;
			self.Queue[id] = {t = duration, f = timeOutFunction}
			return id
		end
	end 
	return false 
end 

function Timers:ExecuteLoop(timeOutFunction, duration, idCheck)
	if(type(duration) == "number" and type(timeOutFunction) == "function") then
		if(idCheck and self.Queue[idCheck]) then
			self.Queue[idCheck].x = duration
			self.Queue[idCheck].t = duration
			return idCheck
		else
			self.TimerCount = self.TimerCount + 1
			local id = "LOOP" .. self.TimerCount;
			self.Queue[id] = {x = duration, t = duration, f = timeOutFunction}
			return id
		end
	end 
	return false
end 

function Timers:RemoveLoop(id)
	if(self.Queue[id]) then 
		self.Queue[id] = nil
		self.TimerCount = self.TimerCount - 1;
	end  
end

function Timers:ClearAllTimers()
	self:SetScript("OnUpdate", nil)
	self.Queue = {}
	self:SetScript("OnUpdate", ExeTimerManager_OnUpdate)
end

Timers:SetScript("OnUpdate", ExeTimerManager_OnUpdate)
--[[ 
########################################################## 
COOLDOWN FUNCTIONS
##########################################################
]]--
local Cooldown_ForceUpdate = function(self)
	self.nextUpdate = 0;
	self:Show()
end 

local Cooldown_StopTimer = function(self)
	self.enable = nil;
	self:Hide()
end 

local Cooldown_OnUpdate = function(self, elapsed)
	if self.nextUpdate > 0 then 
		self.nextUpdate = self.nextUpdate - elapsed;
		return 
	end 
	local expires = (self.duration - (GetTime() - self.start));
	if expires > 0.05 then 
		if (self.fontScale * self:GetEffectiveScale() / UIParent:GetScale()) < 0.5 then 
			self.text:SetText('')
			self.nextUpdate = 500 
		else 
			local timeLeft = 0;
			local calc = 0;
			if expires < 4 then
				self.nextUpdate = 0.051
				self.text:SetFormattedText("|cffff0000%.1f|r", expires)
			elseif expires < 60 then 
				self.nextUpdate = 0.51
				self.text:SetFormattedText("|cffffff00%d|r", floor(expires)) 
			elseif expires < 3600 then
				timeLeft = ceil(expires / 60);
				calc = floor((expires / 60) + .5);
				self.nextUpdate = calc > 1 and ((expires - calc) * 29.5) or (expires - 59.5);
				self.text:SetFormattedText("|cffffffff%dm|r", timeLeft)
			elseif expires < 86400 then
				timeLeft = ceil(expires / 3600);
				calc = floor((expires / 3600) + .5);
				self.nextUpdate = calc > 1 and ((expires - calc) * 1799.5) or (expires - 3570);
				self.text:SetFormattedText("|cff66ffff%dh|r", timeLeft)
			else
				timeLeft = ceil(expires / 86400);
				calc = floor((expires / 86400) + .5);
				self.nextUpdate = calc > 1 and ((expires - calc) * 43199.5) or (expires - 86400);
				self.text:SetFormattedText("|cff6666ff%dd|r", timeLeft)
			end
		end
	else 
		Cooldown_StopTimer(self)
	end 
end 

local function ModifyCoolSize(self, width, height, override)
	local newSize = floor(width + .5) / 36;
	override = override or self:GetParent():GetParent().SizeOverride;
	if override then
		newSize = override / 20 
	end 
	if newSize == self.fontScale then 
		return 
	end 
	self.fontScale = newSize;
	if newSize < 0.5 and not override then 
		self:Hide()
	else 
		self:Show()
		self.text:SetFont(TIMERFONT, newSize * 15, 'OUTLINE')
		if self.enable then 
			Cooldown_ForceUpdate(self)
		end 
	end 
end 

local Cool_OnSize = function(self, width, height)
	ModifyCoolSize(self.timer, width, height, self.SizeOverride)
end

local function CreateCoolTimer(self)
	local timer = CreateFrame('Frame', nil, self)
	timer:Hide()
	timer:SetAllPoints()
	timer:SetScript('OnUpdate', Cooldown_OnUpdate)

	local timeText = timer:CreateFontString(nil,'OVERLAY')
	timeText:SetPoint('CENTER',1,1)
	timeText:SetJustifyH("CENTER")
	timer.text = timeText;

	self.timer = timer;
	local width, height = self:GetSize()
	ModifyCoolSize(self.timer, width, height, self.SizeOverride)
	self:SetScript('OnSizeChanged', Cool_OnSize)
	
	return self.timer 
end 

local Cooldown_OnLoad = function(self, start, duration, elapsed)
	if start > 0 and duration > 2.5 then 
		local timer = self.timer or CreateCoolTimer(self)
		timer.start = start;
		timer.duration = duration;
		timer.enable = true;
		timer.nextUpdate = 0;
		
		if timer.fontScale >= 0.5 then 
			timer:Show()
		end 
	else 
		local timer = self.timer;
		if timer then 
			Cooldown_StopTimer(timer)
		end 
	end 
	if self.timer then 
		if elapsed and elapsed > 0 then 
			self.timer:SetAlpha(0)
		else 
			self.timer:SetAlpha(1)
		end 
	end 
end 

function Timers:AddCooldown(origin)
	if(origin.HookedCooldown or not SV.db.general.cooldown) then return end
	hooksecurefunc(origin, "SetCooldown", Cooldown_OnLoad)
	origin.HookedCooldown = true
end

SV.Timers = Timers;