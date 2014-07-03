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
local error 	= _G.error;
local pcall 	= _G.pcall;
local tinsert 	= _G.tinsert;
local string 	= _G.string;
local table 	= _G.table;
--[[ STRING METHODS ]]--
local lower, upper, find = string.lower, string.upper, string.find;
--[[ TABLE METHODS ]]--
local twipe = table.wipe;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L = unpack(SVUI);
local MOD = SuperVillain.Registry:Expose('SVStyle');
--[[ 
########################################################## 
LOCAL FUNCTIONS
##########################################################
]]--
local function Button_OnEnter(this)
    this:SetBackdropColor(unpack(SuperVillain.Media.color.highlight))
end

local function Button_OnLeave(this)
    this:SetBackdropColor(unpack(SuperVillain.Media.color.default))
end

local function Button_OnEnter2(this)
    this:SetBackdropColor(unpack(SuperVillain.Media.color.highlight))
    this:SetBackdropBorderColor(unpack(SuperVillain.Media.color.highlight))
end

local function Button_OnLeave2(this)
    this:SetBackdropColor(unpack(SuperVillain.Media.color.default))
    this:SetBackdropBorderColor(0,0,0,1)
end

local function Tab_OnEnter(this)
	this.backdrop:SetPanelColor("highlight")
	this.backdrop:SetBackdropBorderColor(unpack(SuperVillain.Media.color.highlight))
end

local function Tab_OnLeave(this)
	this.backdrop:SetPanelColor("dark")
	this.backdrop:SetBackdropBorderColor(0,0,0,1)
end

local function DD_OnClick(btn)
    btn.func()
    btn:GetParent():Hide()
end

local function DD_OnEnter(btn)
    btn.hoverTex:Show()
end

local function DD_OnLeave(btn)
    btn.hoverTex:Hide()
end;

local function CloseButton_OnEnter(this)
    this:SetBackdropBorderColor(unpack(SuperVillain.Media.color.highlight))
end

local function CloseButton_OnLeave(this)
    this:SetBackdropBorderColor(0,0,0,1)
end
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
function MOD:ApplyCloseButtonStyle(this, anchor)
	if not this then return end;
    if not this.hookedColors then 
        this:HookScript("OnEnter", CloseButton_OnEnter)
        this:HookScript("OnLeave", CloseButton_OnLeave)
        this.hookedColors = true
    end;
    if anchor then 
    	this:SetPoint("TOPRIGHT", anchor, "TOPRIGHT", 2, 2) 
    end
end;

function MOD:ApplyScrollStyle(this)
	if(not this or (this and this.appliedStyle)) then return end;
	if _G[this:GetName().."BG"]then 
		_G[this:GetName().."BG"]:SetTexture(nil)
	end;
	if _G[this:GetName().."Track"]then 
		_G[this:GetName().."Track"]:SetTexture(nil)
	end;
	if _G[this:GetName().."Top"]then 
		_G[this:GetName().."Top"]:SetTexture(nil)
	end;
	if _G[this:GetName().."Bottom"]then 
		_G[this:GetName().."Bottom"]:SetTexture(nil)
	end;
	if _G[this:GetName().."Middle"]then 
		_G[this:GetName().."Middle"]:SetTexture(nil)
	end;
	if _G[this:GetName().."ScrollUpButton"] and _G[this:GetName().."ScrollDownButton"]then 
		_G[this:GetName().."ScrollUpButton"]:Formula409()
		if not _G[this:GetName().."ScrollUpButton"].icon then 
			MOD:ApplyPaginationStyle(_G[this:GetName().."ScrollUpButton"])
			SquareButton_SetIcon(_G[this:GetName().."ScrollUpButton"], "UP")
			_G[this:GetName().."ScrollUpButton"]:Size(_G[this:GetName().."ScrollUpButton"]:GetWidth() + 7, _G[this:GetName().."ScrollUpButton"]:GetHeight() + 7)
		end;
		_G[this:GetName().."ScrollDownButton"]:Formula409()
		if not _G[this:GetName().."ScrollDownButton"].icon then 
			MOD:ApplyPaginationStyle(_G[this:GetName().."ScrollDownButton"])
			SquareButton_SetIcon(_G[this:GetName().."ScrollDownButton"], "DOWN")
			_G[this:GetName().."ScrollDownButton"]:Size(_G[this:GetName().."ScrollDownButton"]:GetWidth() + 7, _G[this:GetName().."ScrollDownButton"]:GetHeight() + 7)
		end;
		if not this.styledBackground then 
			this.styledBackground = CreateFrame("Frame", nil, this)
			this.styledBackground:Point("TOPLEFT", _G[this:GetName().."ScrollUpButton"], "BOTTOMLEFT", 0, -1)
			this.styledBackground:Point("BOTTOMRIGHT", _G[this:GetName().."ScrollDownButton"], "TOPRIGHT", 0, 1)
			this.styledBackground:SetPanelTemplate("Inset", true)
		end;
		this:SetThumbTexture("Interface\\Buttons\\UI-ScrollBar-Knob")
	end
	this.appliedStyle = true
end;

function MOD:ApplyScrollbarStyle(this)
	if(not this or (this and this.appliedStyle)) then return end;
	this:Formula409()
	this:SetFixedPanelTemplate("Inset")
	hooksecurefunc(this, "SetBackdrop", function(f, backdrop)
		if backdrop ~= nil then 
			f:SetBackdrop(nil)
		end 
	end)
	this:SetThumbTexture("Interface\\Buttons\\UI-ScrollBar-Knob")
	if this:GetOrientation() == "VERTICAL"then 
		this:Width(12)
	else 
		this:Height(12)
		for i=1, this:GetNumRegions()do 
			local child = select(i, this:GetRegions())
			if child and child:GetObjectType() == "FontString" then 
				local anchor, parent, relative, x, y = child:GetPoint()
				if relative:find("BOTTOM")then 
					child:Point(anchor, parent, relative, x, y - 4)
				end 
			end 
		end 
	end
	this.appliedStyle = true
end;

function MOD:ApplyTabStyle(this)
	if(not this or (this and this.appliedStyle)) then return end;

	local tab = this:GetName();
	if _G[tab.."Left"] then _G[tab.."Left"]:SetTexture(nil) end
	if _G[tab.."LeftDisabled"] then _G[tab.."LeftDisabled"]:SetTexture(nil) end
	if _G[tab.."Right"] then _G[tab.."Right"]:SetTexture(nil) end
	if _G[tab.."RightDisabled"] then _G[tab.."RightDisabled"]:SetTexture(nil) end
	if _G[tab.."Middle"] then _G[tab.."Middle"]:SetTexture(nil) end
	if _G[tab.."MiddleDisabled"] then _G[tab.."MiddleDisabled"]:SetTexture(nil) end

	if this.GetHighlightTexture and this:GetHighlightTexture()then 
		this:GetHighlightTexture():SetTexture(nil)
	else 
		this:Formula409()
	end;

	local text = _G[tab.."Text"]
	this.backdrop = CreateFrame("Frame", nil, this)
	this.backdrop:FillInner(this, 10, 3)
	this.backdrop:SetFixedPanelTemplate("Component", true)
	this.backdrop:SetPanelColor("dark")
	if(this:GetFrameLevel() > 0) then
		this.backdrop:SetFrameLevel(this:GetFrameLevel() - 1)
	end
	this:HookScript("OnEnter",Tab_OnEnter)
    this:HookScript("OnLeave",Tab_OnLeave)
    this.appliedStyle = true
end;

function MOD:ApplyPaginationStyle(button, isVertical)
	if(not button or not button:GetName() or (button and button.appliedStyle)) then return end;
	local c,d,e;
	local leftDown = (button:GetName() and find(button:GetName():lower(),'left')) or find(button:GetName():lower(),'prev') or find(button:GetName():lower(),'decrement')
	button:Formula409()
	button:SetNormalTexture(nil)
	button:SetPushedTexture(nil)
	button:SetHighlightTexture(nil)
	button:SetDisabledTexture(nil)
	if not button.icon then 
		button.icon=button:CreateTexture(nil,'ARTWORK')
		button.icon:Size(13)
		button.icon:SetPoint('CENTER')
		button.icon:SetTexture([[Interface\Buttons\SquareButtonTextures]])
		button.icon:SetTexCoord(0.01562500,0.20312500,0.01562500,0.20312500)
		button:SetScript('OnMouseDown',function(g)
			if g:IsEnabled()then 
				g.icon:SetPoint("CENTER",-1,-1)
			end 
		end)
		button:SetScript('OnMouseUp',function(g)
			g.icon:SetPoint("CENTER",0,0)
		end)
		button:SetScript('OnDisable',function(g)
			SetDesaturation(g.icon,true)
			g.icon:SetAlpha(0.5)
		end)
		button:SetScript('OnEnable',function(g)
			SetDesaturation(g.icon,false)
			g.icon:SetAlpha(1.0)
		end)
		if not button:IsEnabled()then 
			button:GetScript('OnDisable')(button)
		end 
	end;
	if isVertical then 
		if leftDown then SquareButton_SetIcon(button,'UP')else SquareButton_SetIcon(button,'DOWN')end 
	else 
		if leftDown then SquareButton_SetIcon(button,'LEFT')else SquareButton_SetIcon(button,'RIGHT')end 
	end;
	button:SetButtonTemplate()
	button:Size((button:GetWidth() - 7),(button:GetHeight() - 7))
	button.appliedStyle = true
end;

function MOD:ApplyDropdownStyle(this, width)
	if(not this or (this and this.appliedStyle)) then return end;
	local ddname = this:GetName();
	local button = _G[this:GetName().."Button"]
	if not width then width = 155 end;
	this:Formula409()
	this:Width(width)
	_G[ddname.."Text"]:ClearAllPoints()
	_G[ddname.."Text"]:Point("RIGHT", button, "LEFT", -2, 0)
	button:ClearAllPoints()
	button:Point("RIGHT", this, "RIGHT", -10, 3)
	hooksecurefunc(button, "SetPoint", function(this, _, _, _, _, _, breaker)
		if not breaker then 
			button:ClearAllPoints()
			button:Point("RIGHT", this, "RIGHT", -10, 3, true)
		end 
	end)
	MOD:ApplyPaginationStyle(button, true)
	local bg = CreateFrame("Frame", nil, this)
	bg:Point("TOPLEFT", this, "TOPLEFT", 20, -2)
	bg:Point("BOTTOMRIGHT", button, "BOTTOMRIGHT", 2, -2)
	bg:SetPanelTemplate("Inset")
	this.appliedStyle = true 
end;

function MOD:ApplyLinkButtonStyle(this, adjust, shrink)
	if(not this or (this and this.appliedStyle)) then return end;

	local link = this:GetName()
	this:Formula409()

	if shrink then 
		this:SetPanelTemplate("Button", true, 1, -2, -2)
	else
		this:SetFixedPanelTemplate("Button")
	end;
	if link then
		if _G[link.."Name"] then 
			_G[link.."Name"]:SetParent(this.Panel)
		end;
		local icon = this.icon or this.IconTexture;
		if _G[link.."IconTexture"] then 
			icon = _G[link.."IconTexture"]
		elseif _G[link.."Icon"]then 
			icon = _G[link.."Icon"]
		end;
		if icon then 
			icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			if adjust then 
				icon:FillInner(this, 2, 2)
			end;
			local bg = CreateFrame("Frame", nil, this)
			bg:WrapOuter(icon)
			bg:SetFixedPanelTemplate("Transparent")
			icon:SetParent(bg)
			this.IconShadow = bg
		end
		if(_G[link.."Count"]) then
			local fg = CreateFrame("Frame", nil, this)
			fg:SetSize(120, 22)
			fg:SetPoint("BOTTOMLEFT", this, "BOTTOMLEFT", 0, -11)
			fg:SetFrameLevel(this:GetFrameLevel() + 30)
			_G[link.."Count"]:SetParent(fg)
			_G[link.."Count"]:SetAllPoints(fg)
			_G[link.."Count"]:SetFontTemplate(SuperVillain.Media.font.numbers, 12, "OUTLINE", "LEFT")
			_G[link.."Count"]:SetDrawLayer("ARTWORK",7)
		end;
	end;
	this:HookScript("OnEnter",Button_OnEnter)
    this:HookScript("OnLeave",Button_OnLeave)
	this.appliedStyle = true 
end;

function MOD:ApplyTooltipStyle(frame)
	if(not frame or (frame and frame.appliedStyle)) then return end;
	frame:HookScript('OnShow',function(this)
		this:SetBackdrop({
			bgFile = [[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]],
			edgeFile = [[Interface\BUTTONS\WHITE8X8]],
			tile = false,
			edgeSize=1
		})
		this:SetBackdropColor(0,0,0,0.8)
		this:SetBackdropBorderColor(0,0,0)
	end)
	frame.appliedStyle = true
end;

function MOD:ApplyFrameStyle(frame,template,noStripping,fullStripping)
	if(not frame or (frame and frame.appliedStyle)) then return end;
	if not template then template = 'Transparent' end;
	if not noStripping then frame:Formula409(fullStripping) end;
	frame:SetPanelTemplate(template)
	frame.appliedStyle = true
end;

function MOD:ApplyAlertStyle(frame)
	if(not frame or (frame and frame.appliedStyle)) then return end;
    local alertpanel = CreateFrame("Frame", nil, frame)
    alertpanel:SetAllPoints(frame)
    alertpanel:SetFrameLevel(frame:GetFrameLevel() - 1)
    alertpanel:SetBackdrop({
        bgFile = "Interface\\AddOns\\SVUI\\assets\\artwork\\Template\\Alert\\ALERT-BG"
    })
    alertpanel:SetBackdropColor(0.8, 0.2, 0.2)
    --[[ LEFT ]]--
    local left = alertpanel:CreateTexture(nil, "BORDER")
    left:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Template\\Alert\\ALERT-LEFT")
    left:Point("TOPRIGHT", alertpanel,"TOPLEFT", 0, 0)
    left:Point("BOTTOMRIGHT", alertpanel, "BOTTOMLEFT", 0, 0)
    left:Width(frame:GetHeight())
    --[[ RIGHT ]]--
    local right = alertpanel:CreateTexture(nil, "BORDER")
    right:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Template\\Alert\\ALERT-RIGHT")
    right:SetVertexColor(0.8, 0.2, 0.2)
    right:Point("TOPLEFT", alertpanel,"TOPRIGHT", -1, 0)
    right:Point("BOTTOMLEFT", alertpanel, "BOTTOMRIGHT", -1, 0)
    right:Width(frame:GetHeight() * 2)
    --[[ TOP ]]--
    local top = alertpanel:CreateTexture(nil, "BORDER")
    top:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Template\\Alert\\ALERT-TOP")
    top:Point("BOTTOMLEFT", alertpanel,"TOPLEFT", 0, 0)
    top:Point("BOTTOMRIGHT", alertpanel, "TOPRIGHT", 0, 0)
    top:Height(frame:GetHeight() * 0.5)
    --[[ BOTTOM ]]--
    local bottom = alertpanel:CreateTexture(nil, "BORDER")
    bottom:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Template\\Alert\\ALERT-BOTTOM")
    bottom:Point("TOPLEFT", alertpanel,"BOTTOMLEFT", 0, 0)
    bottom:Point("TOPRIGHT", alertpanel, "BOTTOMRIGHT", 0, 0)
    bottom:Width(frame:GetHeight() * 0.5)

    frame.appliedStyle = true
end;