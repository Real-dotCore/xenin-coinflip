util.AddNetworkString("Coinflip.Create")
util.AddNetworkString("Coinflip.Remove")
util.AddNetworkString("Coinflip.Delete")
util.AddNetworkString("Coinflip.Join.Error")
util.AddNetworkString("Coinflip.Join")
util.AddNetworkString("Coinflip.PlayerJoined")
util.AddNetworkString("Coinflip.AnnounceWinner")
util.AddNetworkString("Coinflip.RequestHistory")
util.AddNetworkString("Coinflip.Menu")

-- Which ranks should be considered as VIP?
-- You can edit this table, but make sure to edit it in games.lua so it corresponds
local VIPRanksTable = { 
	["superadmin"] = true,
	["vip"] = true,
}

net.Receive("Coinflip.Delete", function(len, ply)
	local id = net.ReadUInt(24)
	local tbl = Coinflip.Games[id]
	if (!tbl) then return end
	if (tbl.author != ply) then return end

	Coinflip:RefundGame(id, true)
end)

net.Receive("Coinflip.Create", function(len, ply)
	local money = net.ReadUInt(32)
	local announceCreation = net.ReadBool()
	local announceWinner = net.ReadBool()
	local timeLimit = net.ReadUInt(5)
	local currency = net.ReadString()
	local curr = Coinflip:GetCurrency(currency)
	
	if (timeLimit < 5 or timeLimit > 30) then return end
	if (!curr:CanAfford(ply, money)) then return end
	if (money < Coinflip.Config.MinBet) then return end
	if (money > Coinflip.Config.MaxBet and Coinflip.Config.MaxBet != 0) then return end
	local betsUp = 0
	if (Coinflip.Config.MaxCoinflips != 0) then
		for i, v in pairs(Coinflip.Games) do
			if (v.author != ply or v.claimed) then continue end

			betsUp = betsUp + 1
		end

		if VIPRanksTable[ply:GetUserGroup()] then
			if (betsUp >= Coinflip.Config.MaxVIPCoinflips) then return end
		end
		
		if not VIPRanksTable[ply:GetUserGroup()] then
			if (betsUp >= Coinflip.Config.MaxCoinflips) then return end
		end
	end

	local id = Coinflip:CreateGame(ply, money, announceCreation, announceWinner, timeLimit, currency)

	net.Start("Coinflip.Create")
		net.WriteUInt(id, 24)
		net.WriteEntity(ply)
		net.WriteUInt(money, 32)
		net.WriteBool(announceCreation and !Coinflip.Config.DisableCreationAnnouncement)
		net.WriteString(currency)
	net.Broadcast()

	Coinflip.Database:SaveGame(id, ply:SteamID64(), money, currency)
end)

local function err(ply, error)
	net.Start("Coinflip.Join.Error")
		net.WriteString(error)
	net.Send(ply)
end
net.Receive("Coinflip.Join", function(len, ply)
	-- This doesn't really make it more random, but some people want it
	if (Coinflip.Config.SeedRegularly) then
		math.randomseed(os.time() - math.random(1, 200))
	end

	local id = net.ReadUInt(24)
	local tbl = Coinflip.Games[id]
	local curr = Coinflip:GetCurrency(tbl.currency)
	if (!tbl) then err(ply, "This coinflip no longer exists. It's been claimed/deleted") return end
	if (tbl.claimed) then err(ply, "This coinflip is already in progress") return end
	if (!IsValid(tbl.author)) then err(ply, "The author is this coinflip seems to have disconnected") return end
	if (ply == tbl.author) then err(ply, "You can't join your own flip") return end
	local money = tbl.money
	if (!curr:CanAfford(ply, money)) then err(ply, "You can't afford to join this coinflip") return end

	curr:Add(ply, -money)
	local rnd = math.random(1, 2)
	local winner = rnd == 1 and tbl.author or ply
	local rndTime = math.Round(math.Rand(5, 8), 2)
	
	-- Delay before it starts on client
	local flipDelay = 4
	-- Add a little extra for ping (150ms)
	local pingTime = 0.15
	local doneTime = flipDelay + rndTime + pingTime
	hook.Run("Coinflip.Played", tbl.author, ply, money * 2, winner, tbl.currency)

	timer.Simple(doneTime, function()
		if (IsValid(winner)) then
			curr:Add(winner, money * 2)

			local str = Coinflip.i18n:get("chat.won", {
				money = curr:Format(money * 2)
			}, "You have won :money: in a coinflip")
			XeninUI:Notify(winner, str, winner, 5, Color(41, 128, 185))

			if (tbl.announceWinner and !Coinflip.Config.DisableWinAnnouncement) then
				net.Start("Coinflip.AnnounceWinner")
					net.WriteEntity(winner)
					net.WriteUInt(money * 2, 32)
					net.WriteEntity(winner == ply and tbl.author or ply)
					net.WriteString(tbl.currency)
				net.Broadcast()
			end
		end
	end)

	local authorSid64 = tbl.author:SteamID64()
	local winnerSid64 = winner:SteamID64()
	local plySid64 = ply:SteamID64()
	Coinflip.Database:DeleteGame(id, tbl.author:SteamID64())
	timer.Simple(doneTime, function()
		Coinflip.Database:AddToHistory(authorSid64, plySid64, money * 2, winnerSid64, tbl.currency)
	end)
	hook.Run("Coinflip.StartedFlip", tbl, ply, id)

	tbl.claimed = true

	net.Start("Coinflip.Join")
		net.WriteUInt(id, 24)
		net.WriteEntity(winner)
		net.WriteFloat(rndTime)
	net.Send(ply)
	
	net.Start("Coinflip.PlayerJoined")
		net.WriteUInt(id, 24)
		net.WriteEntity(ply)
		net.WriteEntity(winner)
		net.WriteFloat(rndTime)
	net.Send(tbl.author)

	net.Start("Coinflip.Remove")
		net.WriteUInt(id, 24)
	net.SendOmit({ ply, tbl.author })
end)

net.Receive("Coinflip.RequestHistory", function(len, ply)
	Coinflip.Database:GetHistory(ply:SteamID64(), 15, 0, function(result)
		if (!IsValid(ply)) then return end

		net.Start("Coinflip.RequestHistory")
			net.WriteTable(result)
		net.Send(ply)
	end)
end)
