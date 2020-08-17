local cfg = Coinflip:CreateConfig()
-- This is how fast the coin should be spinning at the start. 
-- I recommend 18, but you shouldn't really put it below 12.
cfg:SetSpeed(18)

-- What colour should the prefix be?
-- You can use Color(r, g, b)
cfg:SetChatPrefixColor(XeninUI.Theme.Accent)

-- What text should the prefix for chat messages?
cfg:SetChatPrefix("[COINFLIP] ")

-- What is the minimum amount someone can bet?
cfg:SetMinBet(100)

-- What is the maximum amount someone can bet?
cfg:SetMaxBet(10000)

-- How many coinflips can a user have active at once?
cfg:SetMaxCoinflips(3)

-- Xenin Coinflip - VIP System by dotCore (14.08 update)

--[[
	Hello there !
	Here's the files that should be replaced : config.lua / config_wrapper.lua / server.lua / games.lua
	Thanks for using this and good game ! (hope you will earn a lot of money thanks to this)
]]

-- How many coinflips can VIP users have active at once?
cfg:SetMaxVIPCoinflips(6)

-- What should it say in the top left of the menu?
cfg:SetMenuTitle("Xenin - Coinflips")

-- What text should be in the overhead of the NPC?
cfg:SetNPCTitle("Coinflip NPC")

-- What model should the NPC have?
cfg:SetNPCModel("models/Barney.mdl")

-- What icon should there be in the overhead of the NPC besides the text?
-- Example: Material("xenin/coinflip/icon.png", "smooth")
-- By default it's set to nil, which means it wont have an icon.
cfg:SetNPCIcon(nil)

-- What color should the NPC overhead have as an outline?
cfg:SetNPCOutlineColor(Color(205, 50, 50))

-- Disable the creation annoucement?
cfg:SetCreationAnnouncementDisabled(false)

-- Disable the win announcement?
cfg:SetWinAnnouncementDisabled(true)

-- Seed regularly
-- Changes how the coinflip deals with randomness.
-- Not really more random, just a different way
cfg:SetSeedRegularly(false)

-- What currency should coinflips pre v2 be?
-- If you have never had a coinflip in your database before v2 this will do literally nothing.
-- If not, make sure it's the right currency.
cfg:SetOldCurrency("DarkRP")

-- What currency?
-- Supports:
-- DarkRP
-- Pointshop
-- Pointshop 2
------
-- You can make this a table, i.e { "DarkRP", "Pointshop" } to have multiple currencies
-- To make it a single currency, just have it "DarkRP"
cfg:SetCurrency("DarkRP")

/*
	Set the language!
	You can find the languages you can use here: https://gitlab.com/sleeppyy/xenin-languages/tree/master/coinflip
	You dont need to write the .json part

	If you want to add your own language you can
	1. Create a pull request (create new file) that will be uploaded to that website with the language
	2. Use a second argument in the :SetLanguage function

	How to do now #2. This will set the language without needing to use the version from a website. 
	cfg:SetLanguage("french", [[
		{
			"phrases": {
				"ui": {
					
				}
			}
		}
	]])

	So for example
	cfg:SetLanguage("russian", [[
		-- copy the contents of english.json and translate it here
	]])

	Its recommended you use method #1, but you can use method #2 till the file you upload have been approved
*/
cfg:SetLanguage("English")

-- What text messages should work as a way to open up the flip menu?
-- If you don't want any chat commands you just remove every command
cfg:AddChatCommand("!flip")
cfg:AddChatCommand("/flip")
cfg:AddChatCommand("!flips")
cfg:AddChatCommand("/flips")
cfg:AddChatCommand("!createflip")
cfg:AddChatCommand("/createflip")
cfg:AddChatCommand("!createflips")
cfg:AddChatCommand("/createflips")
cfg:AddChatCommand("!coinflip")
cfg:AddChatCommand("/coinflip")
cfg:AddChatCommand("!coinflips")
cfg:AddChatCommand("/coinflips")
cfg:AddChatCommand("!cf")
cfg:AddChatCommand("/cf")
