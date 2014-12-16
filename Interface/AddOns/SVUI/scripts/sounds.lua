--[[
 /$$      /$$ /$$   /$$ /$$   /$$  /$$$$$$ 
| $$$    /$$$| $$  | $$| $$$ | $$ /$$__  $$
| $$$$  /$$$$| $$  | $$| $$$$| $$| $$  \__/
| $$ $$/$$ $$| $$  | $$| $$ $$ $$| $$ /$$$$
| $$  $$$| $$| $$  | $$| $$  $$$$| $$|_  $$
| $$\  $ | $$| $$  | $$| $$\  $$$| $$  \ $$
| $$ \/  | $$|  $$$$$$/| $$ \  $$|  $$$$$$/
|__/     |__/ \______/ |__/  \__/ \______/ 
 /$$      /$$  /$$$$$$  /$$$$$$$  /$$$$$$$$
| $$$    /$$$ /$$__  $$| $$__  $$| $$_____/
| $$$$  /$$$$| $$  \ $$| $$  \ $$| $$      
| $$ $$/$$ $$| $$$$$$$$| $$  | $$| $$$$$   
| $$  $$$| $$| $$__  $$| $$  | $$| $$__/   
| $$\  $ | $$| $$  | $$| $$  | $$| $$      
| $$ \/  | $$| $$  | $$| $$$$$$$/| $$$$$$$$
|__/     |__/|__/  |__/|_______/ |________/
########################################################## 
LOCALIZED LUA FUNCTIONS
##########################################################
]]--
--[[ GLOBALS ]]--
local _G = _G;
local unpack 	= _G.unpack;
local select 	= _G.select;
local pairs 	= _G.pairs;
local ipairs 	= _G.ipairs;
local type 		= _G.type;
local tinsert 	= _G.tinsert;
local string 	= _G.string;
--[[ STRING METHODS ]]--
local format, gsub = string.format, string.gsub;

--PlaySoundFile("sound\\vehicles\\veh_hordechopper_summon.ogg")