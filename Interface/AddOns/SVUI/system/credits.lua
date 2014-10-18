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
]]--

--[[ GLOBALS ]]--

local _G = _G;
local unpack 	 =  _G.unpack;
local pairs 	 =  _G.pairs;

--[[ ADDON ]]--

local SV = _G["SVUI"];
local L = SV.L;

--[[ CODING CREDITS ]]--

local contributors = {
	"Elv", 
	"Tukz", 
	"Azilroka", 
	"Sortokk", 
	"Kkthnx", 
	"AlleyKat", 
	"Quokka", 
	"Duugu", 
	"Zork", 
	"Haleth", 
	"P3lim", 
	"Haste", 
	"Totalpackage", 
	"Kryso", 
	"Thepilli", 
	"Phanx"
};

local coderList = "";

for _, name in pairs(contributors) do
	coderList = ("%s\n%s"):format(coderList, name)
end

--[[ DONATION CREDITS ]]--

local donations = {
	"Movster", 
	"Cazart506", 
	"FaolanKing", 
	"Doonga",
	"Meggalo",
	"Penguinsane",
	"Moondoggy",
	"Necroo",
	"Chief Pullin",
	"Other Silent Partners.. (Let me know if I have forgotten you)"
};

local donorList = "";

for _, name in pairs(contributors) do
	donorList = ("%s\n%s"):format(donorList, name)
end

--[[ TESTER CREDITS ]]--

local testers = {
	"Sinnisterr - (My wife, the MOST ruthless Warlock you will ever meet)", 
	"Doonga - (The man who keeps me busy)", 
	"Daigan - (My current 2nd in command)", 
	"Penguinsane - (Tester extraordinaire)", 
	"FaolanKing - (King of the bug report portal)"
};

local testerList = "";

for _, name in pairs(testers) do
	testerList = ("%s\n%s"):format(testerList, name)
end

--[[ COMMUNITY CREDITS ]]--

local community = {
	"Movster", 
	"Judicate", 
	"Cazart506",  
	"MuffinMonster", 
	"Joelsoul", 
	"Trendkill09", 
	"Luamar", 
	"Zharooz", 
	"Lyn3x5", 
	"Madh4tt3r", 
	"Xarioth", 
	"AtomicKiller", 
	"Meljen", 
	"Moondoggy", 
	"Stormblade", 
	"Schreibstift", 
	"Anj", 
	"Risien", 
	"Cromax", 
	"Nitro_Turtle", 
	"Shinzou", 
	"Autolykus", 
	"Taotao", 
	"ColorsGaming", 
	"Necroo",
	"The Wowinterface Community",
};

local communityList = "";

for _, name in pairs(community) do
	communityList = ("%s\n%s"):format(communityList, name)
end

--[[ BUILD STRING ]]--

local creditHeader = "|cffff9900SUPERVILLAIN CREDITS:|r\n|cff4f4f4f---------------------------------------------|r\n|cffff9900CREATED BY:|r  Munglunch\n|cff4f4f4f---------------------------------------------|r\n|cffff9900CODE GRANTS BY:|r  Elv, Tukz, Azilroka, Sortokk\n|cff4f4f4f---------------------------------------------|r\n";

local creditThanks1 = "|cffff9900SPECIAL THANKS TO:  |r|cfff81422Cairenn|r |cff2288cc(@WowInterface.com)|r  ..the most patient and accomodating person I know!\n\n";

local creditThanks2 = "|cffff9900A VERY SPECIAL THANKS TO:  |r|cffffff00Movster|r  ..who inspired me to bring this project back to life!\n|cff4f4f4f---------------------------------------------|r\n";

local creditCoders = ("|cff3399ffCODE MONKEYS  (aka CONTRIBUTORS):|r%s\n|cff4f4f4f---------------------------------------------|r\n"):format(coderList);

local creditDonations = ("|cff99ff33KINGPINS  (aka INVESTORS):|r%s\n|cff4f4f4f---------------------------------------------|r\n"):format(donorList);

local creditTesters = ("|cffaa33ffPERFECTIONISTS  (aka CORE TESTING TEAM):|r%s\n|cff4f4f4f---------------------------------------------|r\n"):format(testerList);

local creditCommunity = ("|cffaa33ffMINIONS  (aka COMMUNITY TESTERS):|r%s\n|cff4f4f4f---------------------------------------------|r\n"):format(communityList);

local creditMusic = "|cff00ccffTheme Song By: Fingathing [taken from the song: SuperHero Music]|r";

--[[ FINAL CREDITS STRING ]]--

SV.Credits = creditHeader .. creditThanks1 .. creditThanks2 .. creditCoders .. creditDonations .. creditTesters .. creditCommunity .. creditMusic;