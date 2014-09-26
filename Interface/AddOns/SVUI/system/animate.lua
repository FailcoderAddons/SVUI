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
local unpack    = _G.unpack;
local select    = _G.select;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SVUI_ADDON_NAME, SV = ...
local SVLib = LibStub("LibSuperVillain-1.0")
local L = SVLib:Lang()
--[[ 
########################################################## 
LOCALS
##########################################################
]]--
local FlickerAlpha = {0.2,0.15,0.1,0.15,0.2,0.15,0.1,0.15}
local Animate = {};
--[[ 
######################################################################
  /$$$$$$  /$$   /$$ /$$$$$$ /$$      /$$  /$$$$$$  /$$$$$$$$/$$$$$$$$
 /$$__  $$| $$$ | $$|_  $$_/| $$$    /$$$ /$$__  $$|__  $$__/ $$_____/
| $$  \ $$| $$$$| $$  | $$  | $$$$  /$$$$| $$  \ $$   | $$  | $$      
| $$$$$$$$| $$ $$ $$  | $$  | $$ $$/$$ $$| $$$$$$$$   | $$  | $$$$$   
| $$__  $$| $$  $$$$  | $$  | $$  $$$| $$| $$__  $$   | $$  | $$__/   
| $$  | $$| $$\  $$$  | $$  | $$\  $ | $$| $$  | $$   | $$  | $$      
| $$  | $$| $$ \  $$ /$$$$$$| $$ \/  | $$| $$  | $$   | $$  | $$$$$$$$
|__/  |__/|__/  \__/|______/|__/     |__/|__/  |__/   |__/  |________/                      
######################################################################
]]--
local Anim_OnShow = function(self)
	if not self.anim:IsPlaying() then 
		self.anim:Play()
	end
end 

local Anim_OnHide = function(self)
	self.anim:Finish()
end 

local Anim_OnPlay = function(self)
	local parent = self.parent
	parent:SetAlpha(1)
	if self.hideOnFinished and not parent:IsShown() then
		parent:Show()
	end
end 

local Anim_OnStop = function(self)
	local parent = self.parent
	if self.fadeOnFinished then
		parent:SetAlpha(0)
	else
		parent:SetAlpha(1)
	end
	if self.hideOnFinished and parent:IsShown() then
		parent:Hide()
	end
	if self.savedFrameLevel then
		parent:SetScale(1)
		parent:SetFrameLevel(self.savedFrameLevel)
	end
end 

local Anim_OnFinished = function(self)
	local parent = self.parent
	local looped = self:GetLooping()
	self:Stop()
	if(looped and looped == "REPEAT" and parent:IsShown()) then
		self:Play()
	end
end 

local Sprite_OnUpdate = function(self)
	local order = self:GetOrder()
	local parent = self.parent
	local left, right;
	if(self.isFadeFrame) then
		parent:SetAlpha(0)
		return
	end
	left = (order - 1) * 0.25;
	right = left + 0.25;
	parent:SetTexCoord(left,right,0,1)
	if parent.overlay then 
		parent.overlay:SetTexCoord(left,right,0,1)
		parent.overlay:SetVertexColor(1,1,1,FlickerAlpha[order])
	end
end 

local SmallSprite_OnUpdate = function(self)
	local order = self:GetOrder()
	local parent = self.parent
	local left, right;
	if(self.isFadeFrame) then
		parent:SetAlpha(0)
		return
	end
	left = (order - 1) * 0.125;
	right = left + 0.125;
	parent:SetTexCoord(left,right,0,1)
	if parent.overlay then 
		parent.overlay:SetTexCoord(left,right,0,1)
		parent.overlay:SetVertexColor(1,1,1,FlickerAlpha[order])
	end 
end 

local PulseIn_OnUpdate = function(self)
	local parent = self.parent
	local step = self:GetProgress()
	if(parent.savedFrameLevel) then
		parent:SetFrameLevel(128)
	end
	parent:SetScale(1 + (1.05 * step))
end 

local PulseOut_OnUpdate = function(self)
	local parent = self.parent
	local step = self:GetProgress()
	if(parent.savedFrameLevel) then
		parent:SetFrameLevel(128)
	end
	parent:SetScale(1 + (1.05 * (1 - step)))
end 

local Slide_OnUpdate = function(self)
	local parent = self.parent
	local step = self:GetProgress()
	parent:SetScale(1 + (1.05 * step))
end 

local Slide_OnPlay = function(self)
	local parent = self.parent
	parent:SetScale(0.01)
	parent:SetAlpha(1)
end 

local Slide_FadeStart = function(self)
	local parent = self.parent
	UIFrameFadeOut(parent, 0.3, 1, 0)
end 

local Slide_FadeStop = function(self)
	self.parent:SetAlpha(0)
end

--[[ HELPER FUNCTION ]]--

local function SetNewAnimation(frame, animType, subType)
	local anim = frame:CreateAnimation(animType, subType)
	anim.parent = frame.parent
	return anim
end

--[[ ANIMATION CLASS METHODS ]]--

function Animate:SetTemplate(frame, animType, hideOnFinished, speed, special, scriptToParent)
	if not animType then return end 

	frame.anim = frame:CreateAnimationGroup(animType)
	frame.anim.parent = frame;
	frame.anim.hideOnFinished = hideOnFinished
	if animType ~= 'Flash' then
		frame.anim:SetScript("OnPlay", Anim_OnPlay)
		frame.anim:SetScript("OnFinished", Anim_OnFinished)
		frame.anim:SetScript("OnStop", Anim_OnStop)
	end

	if scriptToParent then
		local frameParent = frame:GetParent();
		if(frameParent.SetScript) then
			frameParent.anim = frame.anim;
			frameParent:SetScript("OnShow", Anim_OnShow)
			frameParent:SetScript("OnHide", Anim_OnHide)
		end
	elseif(frame.SetScript) then
		frame:SetScript("OnShow", Anim_OnShow)
		frame:SetScript("OnHide", Anim_OnHide)
	end

	if animType == 'Flash'then
		frame.anim.fadeOnFinished = true
		if not speed then speed = 0.33 end 

		frame.anim[1] = SetNewAnimation(frame.anim, "ALPHA", "FadeIn")
		frame.anim[1]:SetChange(1)
		frame.anim[1]:SetOrder(2)
		frame.anim[1]:SetDuration(speed)
			
		frame.anim[2] = SetNewAnimation(frame.anim, "ALPHA","FadeOut")
		frame.anim[2]:SetChange(-1)
		frame.anim[2]:SetOrder(1)
		frame.anim[2]:SetDuration(speed)

		if special then 
			frame.anim:SetLooping("REPEAT")
		end
	elseif animType == 'Orbit' then
		frame.anim[1] = SetNewAnimation(frame.anim, "Rotation")
		if special then 
			frame.anim[1]:SetDegrees(-360)
		else 
			frame.anim[1]:SetDegrees(360)
		end 
		frame.anim[1]:SetDuration(speed)
		frame.anim:SetLooping("REPEAT")
		frame.anim:Play()
	elseif animType == 'Sprite' then
		frame.anim[1] = SetNewAnimation(frame.anim, "Translation")
		frame.anim[1]:SetOrder(1)
		frame.anim[1]:SetDuration(speed)
		frame.anim[1]:SetScript("OnUpdate", Sprite_OnUpdate)

		frame.anim[2] = SetNewAnimation(frame.anim, "Translation")
		frame.anim[2]:SetOrder(2)
		frame.anim[2]:SetDuration(speed)
		frame.anim[2]:SetScript("OnUpdate", Sprite_OnUpdate)

		frame.anim[3] = SetNewAnimation(frame.anim, "Translation")
		frame.anim[3]:SetOrder(3)
		frame.anim[3]:SetDuration(speed)
		frame.anim[3]:SetScript("OnUpdate", Sprite_OnUpdate)

		frame.anim[4] = SetNewAnimation(frame.anim, "Translation")
		frame.anim[4]:SetOrder(4)
		frame.anim[4]:SetDuration(speed)
		frame.anim[4]:SetScript("OnUpdate", Sprite_OnUpdate)

		if special then 
			frame.anim[5] = SetNewAnimation(frame.anim, "Translation")
			frame.anim[5]:SetOrder(5)
			frame.anim[5]:SetDuration(special)
			frame.anim[5].isFadeFrame = true;
			frame.anim[5]:SetScript("OnUpdate", Sprite_OnUpdate)
		end 

		frame.anim:SetLooping("REPEAT")
	elseif animType == 'SmallSprite' then
		frame.anim[1] = SetNewAnimation(frame.anim, "Translation")
		frame.anim[1]:SetOrder(1)
		frame.anim[1]:SetDuration(speed)
		frame.anim[1]:SetScript("OnUpdate", SmallSprite_OnUpdate)

		frame.anim[2] = SetNewAnimation(frame.anim, "Translation")
		frame.anim[2]:SetOrder(2)
		frame.anim[2]:SetDuration(speed)
		frame.anim[2]:SetScript("OnUpdate", SmallSprite_OnUpdate)

		frame.anim[3] = SetNewAnimation(frame.anim, "Translation")
		frame.anim[3]:SetOrder(3)
		frame.anim[3]:SetDuration(speed)
		frame.anim[3]:SetScript("OnUpdate", SmallSprite_OnUpdate)
		
		frame.anim[4] = SetNewAnimation(frame.anim, "Translation")
		frame.anim[4]:SetOrder(4)
		frame.anim[4]:SetDuration(speed)
		frame.anim[4]:SetScript("OnUpdate", SmallSprite_OnUpdate)
		
		frame.anim[5] = SetNewAnimation(frame.anim, "Translation")
		frame.anim[5]:SetOrder(5)
		frame.anim[5]:SetDuration(speed)
		frame.anim[5]:SetScript("OnUpdate", SmallSprite_OnUpdate)
		
		frame.anim[6] = SetNewAnimation(frame.anim, "Translation")
		frame.anim[6]:SetOrder(6)
		frame.anim[6]:SetDuration(speed)
		frame.anim[6]:SetScript("OnUpdate", SmallSprite_OnUpdate)
		
		frame.anim[7] = SetNewAnimation(frame.anim, "Translation")
		frame.anim[7]:SetOrder(7)
		frame.anim[7]:SetDuration(speed)
		frame.anim[7]:SetScript("OnUpdate", SmallSprite_OnUpdate)
		
		frame.anim[8] = SetNewAnimation(frame.anim, "Translation")
		frame.anim[8]:SetOrder(8)
		frame.anim[8]:SetDuration(speed)
		frame.anim[8]:SetScript("OnUpdate", SmallSprite_OnUpdate)

		if special then 
			frame.anim[9] = SetNewAnimation(frame.anim, "Translation")
			frame.anim[9]:SetOrder(9)
			frame.anim[9]:SetDuration(special)
			frame.anim[9].isFadeFrame = true;
			frame.anim[9]:SetScript("OnUpdate", Sprite_OnUpdate)
		end 

		frame.anim:SetLooping("REPEAT")
	elseif animType == 'Pulse' then
		frame.anim.savedFrameLevel = frame:GetFrameLevel()

		frame.anim[1] = SetNewAnimation(frame.anim)
		frame.anim[1]:SetDuration(0.2)
		frame.anim[1]:SetEndDelay(0.1)
		frame.anim[1]:SetOrder(1)
		frame.anim[1]:SetScript("OnUpdate", PulseIn_OnUpdate)

		frame.anim[2] = SetNewAnimation(frame.anim)
		frame.anim[2]:SetDuration(0.6)
		frame.anim[2]:SetOrder(2)
		frame.anim[2]:SetScript("OnUpdate", PulseOut_OnUpdate)
	end 
end

--[[ ROTATE AND WOBBLE (kinda like twerking i guess...) ]]--

function Animate:Orbit(frame, speed, reversed, hideOnFinished)
	if not frame then return end 
	if not speed then speed = 1 end 
	self:SetTemplate(frame, 'Orbit', hideOnFinished, speed, reversed)
end 

function Animate:Pulse(frame, hideOnFinished)
	if not frame then return end 
	self:SetTemplate(frame, 'Pulse', hideOnFinished) 
end

--[[ ANIMATED SPRITES ]]--

function Animate:Sprite(frame, speed, fadeTime, scriptToParent)
	if not frame then return end 
	speed = speed or 0.08;
	self:SetTemplate(frame, 'Sprite', false, speed, fadeTime, scriptToParent)
end 

function Animate:SmallSprite(frame, speed, fadeTime, scriptToParent)
	if not frame then return end 
	speed = speed or 0.08;
	self:SetTemplate(frame, 'SmallSprite', false, speed, fadeTime, scriptToParent) 
end 

function Animate:StopSprite(frame)
	if not frame then return end 
	frame.anim:Finish() 
end

--[[ FLASHING ]]--

function Animate:Flash(frame, speed, looped)
	if not frame.anim then
		self:SetTemplate(frame, 'Flash', false, speed, looped)
	end
	if not frame.anim:IsPlaying() then
		frame.anim:Play()
	end 
end 

function Animate:StopFlash(frame)
	if not frame.anim then return end
	frame.anim:Finish()
	frame.anim:Stop() 
end 

--[[ SLIDING ]]--

function Animate:Slide(frame, xDirection, yDirection, bounce)
	if(not frame or (frame and frame.anim)) then return end 

	frame.anim = frame:CreateAnimationGroup("Slide")
	frame.anim.hideOnFinished = true;
	frame.anim.parent = frame;
	frame.anim:SetScript("OnPlay", Anim_OnPlay)
	frame.anim:SetScript("OnFinished", Anim_OnFinished)
	frame.anim:SetScript("OnStop", Anim_OnStop)

	frame.anim[1] = SetNewAnimation(frame.anim, "Translation")
	frame.anim[1]:SetDuration(0)
	frame.anim[1]:SetOrder(1)
	
	frame.anim[2] = SetNewAnimation(frame.anim, "Translation")
	frame.anim[2]:SetDuration(0.3)
	frame.anim[2]:SetOrder(2)
	frame.anim[2]:SetSmoothing("OUT")

	if bounce then
		frame.anim[3] = SetNewAnimation(frame.anim, "Translation")
		frame.anim[3]:SetDuration(0.5)
		frame.anim[3]:SetOrder(3)

		frame.anim[4] = SetNewAnimation(frame.anim, "Translation")
		frame.anim[4]:SetDuration(0.3)
		frame.anim[4]:SetOrder(4)
		frame.anim[4]:SetSmoothing("IN")
		frame.anim[4]:SetOffset(xDirection, yDirection)
	end
end 

function Animate:RandomSlide(frame, raised)
	if not frame then return end 
	if raised then 
		frame:SetFrameLevel(30)
	else 
		frame:SetFrameLevel(20)
	end 
	frame:SetPoint("CENTER", SV.UIParent, "CENTER", 0, -150)

	frame.anim = frame:CreateAnimationGroup("RandomSlide")
	frame.anim.parent = frame;
	frame.anim[1] = SetNewAnimation(frame.anim, "Translation")
	frame.anim[1]:SetOrder(1)
	frame.anim[1]:SetDuration(0.1)
	frame.anim[1]:SetScript("OnUpdate", Slide_OnUpdate)
	frame.anim[1]:SetScript("OnPlay", Slide_OnPlay)

	frame.anim[2] = SetNewAnimation(frame.anim, "Translation")
	frame.anim[2]:SetOrder(2)
	frame.anim[2]:SetDuration(1)

	frame.anim[3] = SetNewAnimation(frame.anim, "Translation")
	frame.anim[3]:SetOrder(3)
	frame.anim[3]:SetDuration(0.3)
	frame.anim[3]:SetSmoothing("OUT")
	frame.anim[3]:SetScript("OnPlay", Slide_FadeStart)
	frame.anim[3]:SetScript("OnStop", Slide_FadeStop)

	frame.anim:SetScript("OnFinished", Slide_FadeStop)
end 

function Animate:SlideIn(frame)
	if not frame.anim then return end 
	frame:Show()
	frame.anim:Play()
end 

function Animate:SlideOut(frame)
	if not frame.anim then return end 
	frame.anim:Finish()
	frame.anim:Stop()
end 

SV.Animate = Animate;