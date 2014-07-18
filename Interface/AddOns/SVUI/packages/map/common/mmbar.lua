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
local MOD = SuperVillain.Registry:Expose('SVMap');
local sub,len,find = string.sub,string.len,string.find;
local reservedFrame = {
	["SVUI_ConsolidatedBuffs"] = true,
	["GameTimeframe"] = true,
	["HelpOpenTicketButton"] = true,
	["SVUI_MinimapFrame"] = true,
	["SVUI_EnhancedMinimap"] = true,
	["QueueStatusMinimapButton"] = true,
	["TimeManagerClockButton"] = true
}
local reservedString = {"Archy","GatherMatePin","GatherNote","GuildInstance","HandyNotesPin","MinimMap","Spy_MapNoteList_mini","ZGVMarker"}
local reservedType = {"Node","Tab","Pin"}
local MMBButtons = {}
local MMBHolder,MMBBar;

local function MMB_OnEnter(this)
	if not MOD.db.minimapbar.mouseover or MOD.db.minimapbar.styleType=='NOANCHOR' then return end;
	UIFrameFadeIn(SVUI_MiniMapButtonBar, 0.2, SVUI_MiniMapButtonBar:GetAlpha(), 1)
	if this:GetName() ~= 'SVUI_MiniMapButtonBar' then 
		this:SetBackdropBorderColor(.7,.7,0)
	end 
end;

local function MMB_OnLeave(this)
	if not MOD.db.minimapbar.mouseover or MOD.db.minimapbar.styleType=='NOANCHOR' then return end;
	UIFrameFadeOut(SVUI_MiniMapButtonBar, 0.2, SVUI_MiniMapButtonBar:GetAlpha(), 0)
	if this:GetName() ~= 'SVUI_MiniMapButtonBar' then 
		this:SetBackdropBorderColor(0,0,0)
	end 
end;

function MOD:MMBarSetButton(btn)
	if btn==nil or btn:GetName()==nil or btn:GetObjectType()~="Button" or not btn:IsVisible() then return end;
	local name=btn:GetName()
	local isLib=false;
	if sub(name,1,len("LibDBIcon")) == "LibDBIcon" then isLib=true end 
	if not isLib then 
		if reservedFrame[name] then return end 
		for i=1,#reservedString do 
			if sub(name,1,len(reservedString[i])) == reservedString[i] then return end 
		end;
		for i=1,#reservedType do 
			if find(name,reservedType[i]) ~= nil then return end 
		end 
	end;
	btn:SetPushedTexture(nil)
	btn:SetHighlightTexture(nil)
	btn:SetDisabledTexture(nil)
	if name == "DBMMinimapButton" then 
		btn:SetNormalTexture("Interface\\Icons\\INV_Helmet_87")
	end;
	if name == "SmartBuff_MiniMapButton" then 
		btn:SetNormalTexture(select(3,GetSpellInfo(12051)))
	end;
	if not btn.isStyled then 
		btn:HookScript('OnEnter',MMB_OnEnter)
		btn:HookScript('OnLeave',MMB_OnLeave)
		btn:HookScript('OnClick',MOD.UpdateMMBarLayout)
		for i=1,btn:GetNumRegions() do 
			local frame = select(i,btn:GetRegions())
			btn.preset={}
			btn.preset.Width,btn.preset.Height=btn:GetSize()
			btn.preset.Point,btn.preset.relativeTo,btn.preset.relativePoint,btn.preset.xOfs,btn.preset.yOfs=btn:GetPoint()
			btn.preset.Parent=btn:GetParent()
			btn.preset.FrameStrata=btn:GetFrameStrata()
			btn.preset.FrameLevel=btn:GetFrameLevel()
			btn.preset.Scale=btn:GetScale()
			if btn:HasScript("OnDragStart") then 
				btn.preset.DragStart=btn:GetScript("OnDragStart")
			end;
			if btn:HasScript("OnDragEnd") then 
				btn.preset.DragEnd=btn:GetScript("OnDragEnd")
			end;
			if frame:GetObjectType()=="Texture" then 
				local icon=frame:GetTexture()
				if icon and icon:find("Border") or icon:find("Background") or icon:find("AlphaMask") then 
					frame:SetTexture(nil)
				else 
					frame:ClearAllPoints()
					frame:Point("TOPLEFT",btn,"TOPLEFT",4,-4)
					frame:Point("BOTTOMRIGHT",btn,"BOTTOMRIGHT",-4,4)
					frame:SetTexCoord(0.1,0.9,0.1,0.9 )
					frame:SetDrawLayer("ARTWORK")
					if name=="PS_MinimapButton" then 
						frame.SetPoint=function()end 
					end 
				end 
			end 
		end;
		btn:SetButtonTemplate()
		tinsert(MMBButtons,name)
		btn.isStyled=true 
	end 
end;

function MOD:UpdateMMBarLayout()
	if(not MOD.db.minimapbar.enable) then return end;
	MMBBar:SetPoint("CENTER",MMBHolder,"CENTER",0,0)
	MMBBar:Height(MOD.db.minimapbar.buttonSize + 4)
	MMBBar:Width(MOD.db.minimapbar.buttonSize + 4)
	local lastButton,anchor,relative,xPos,yPos;
	for i=1,#MMBButtons do 
		local btn=_G[MMBButtons[i]]
		local preset = btn.preset;
		if MOD.db.minimapbar.styleType=='NOANCHOR'then 
			btn:SetParent(preset.Parent)
			if preset.DragStart then 
				btn:SetScript("OnDragStart",preset.DragStart)
			end;
			if preset.DragEnd then 
				btn:SetScript("OnDragStop",preset.DragEnd)
			end;
			btn:ClearAllPoints()
			btn:SetSize(preset.Width,preset.Height)
			btn:SetPoint(preset.Point,preset.relativeTo,preset.relativePoint,preset.xOfs,preset.yOfs)
			btn:SetFrameStrata(preset.FrameStrata)
			btn:SetFrameLevel(preset.FrameLevel)
			btn:SetScale(preset.Scale)
			btn:SetMovable(true)
		else 
			btn:SetParent(MMBBar)
			btn:SetMovable(false)
			btn:SetScript("OnDragStart",nil)
			btn:SetScript("OnDragStop",nil)
			btn:ClearAllPoints()
			btn:SetFrameStrata("LOW")
			btn:SetFrameLevel(20)
			btn:Size(MOD.db.minimapbar.buttonSize)
			if MOD.db.minimapbar.styleType=='HORIZONTAL'then 
				anchor = 'RIGHT'
				relative = 'LEFT'
				xPos = -2;
				yPos = 0 
			else 
				anchor = 'TOP'
				relative = 'BOTTOM'
				xPos = 0;
				yPos = -2 
			end;
			if not lastButton then 
				btn:SetPoint(anchor,MMBBar,anchor,xPos,yPos)
			else 
				btn:SetPoint(anchor,lastButton,relative,xPos,yPos)
			end 
		end;
		lastButton=btn 
	end;
	if (MOD.db.minimapbar.styleType~='NOANCHOR' and (#MMBButtons > 0)) then 
		if MOD.db.minimapbar.styleType=="HORIZONTAL" then 
			MMBBar:Width((MOD.db.minimapbar.buttonSize * #MMBButtons) + #MMBButtons * 2)
		else 
			MMBBar:Height((MOD.db.minimapbar.buttonSize * #MMBButtons) + #MMBButtons * 2)
		end;
		MMBHolder:SetSize(MMBBar:GetSize())
		MMBBar:Show()
	else 
		MMBBar:Hide()
	end;
end;

function MOD:ChangeMouseOverSetting()
	if MOD.db.minimapbar.mouseover then 
		MMBBar:SetAlpha(0)
	else 
		MMBBar:SetAlpha(1)
	end 
end;

function MOD:StyleMinimapButtons()
	for i=1,Minimap:GetNumChildren()do 
		MOD:MMBarSetButton(select(i,Minimap:GetChildren()))
	end;
	MOD:UpdateMMBarLayout()
	MOD:ChangeMouseOverSetting()
end;

function MOD:UpdateMinimapButtonSettings()
	if(not MOD.db.minimapbar.enable) then return end;
	SuperVillain:ExecuteTimer(MOD.StyleMinimapButtons, 5)
end;

function MOD:LoadMinimapButtons()
	if(not SuperVillain.db.SVMap.enable or not self.db.minimapbar.enable) then return end;
	MMBHolder=CreateFrame("Frame","SVUI_MiniMapButtonHolder",SVUI_MinimapFrame)
	MMBHolder:Point("TOPRIGHT",SVUI_MinimapFrame,"BOTTOMRIGHT",2,-20)
	MMBHolder:Size(SVUI_MinimapFrame:GetWidth(),32)
	MMBHolder:SetFrameStrata("BACKGROUND")
	--SuperVillain:AddToDisplayAudit(MMBHolder)
	SuperVillain:SetSVMovable(MMBHolder,"SVUI_MiniMapButtonHolder_MOVE",L["Minimap Button Bar"])
	MMBBar=CreateFrame("Frame","SVUI_MiniMapButtonBar",MMBHolder)
	MMBBar:SetFrameStrata('LOW')
	MMBBar:ClearAllPoints()
	MMBBar:SetPoint("CENTER",MMBHolder,"CENTER",0,0)
	MMBBar:SetScript("OnEnter",MMB_OnEnter)
	MMBBar:SetScript("OnLeave",MMB_OnLeave)
	self:UpdateMinimapButtonSettings()
end