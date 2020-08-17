local PANEL = {}

XeninUI:CreateFont("Coinflip.Games.Title", 28)
XeninUI:CreateFont("Coinflip.Games.Button", 20)

-- Which ranks are considered VIP?
-- You can edit this but make sure it corresponds to server.lua table
local VIPRanksTable = { 
	["superadmin"] = true,
	["vip"] = true,
}

function PANEL:Init()
	self.Title = self:Add("DLabel")
	self.Title:SetTextInset(0, 2)
	self.Title:SetFont("Coinflip.Games.Title")
	self.Title:SetTextColor(Color(220, 220, 220))

	self.CreateFlip = self:Add("DButton")
	self.CreateFlip:SetText(Coinflip.i18n:get("ui.flips.createFlip", nil, "Create coinflip"))
	self.CreateFlip:SetFont("Coinflip.Games.Button")
	self.CreateFlip:SizeToContentsY(15)
	self.CreateFlip:SizeToContentsX(48)
	self.CreateFlip.BackgroundColor = XeninUI.Theme.Primary
	self.CreateFlip.OutlineColor = XeninUI.Theme.Primary
	self.CreateFlip.TextColor = Color(212, 212, 212)
	self.CreateFlip.Paint = function(pnl, w, h)
		pnl:SetTextColor(pnl.TextColor)

		XeninUI:DrawRoundedBox(6, 0, 0, w, h, pnl.BackgroundColor)

		XeninUI:MaskInverse(function()
			XeninUI:DrawRoundedBox(6, 1, 1, w - 2, h - 2, color_white)
		end, function()
			XeninUI:DrawRoundedBox(6, 0, 0, w, h, pnl.OutlineColor)
		end)
	end
	self.CreateFlip.OnCursorEntered = function(pnl)
		local atLimit = pnl:IsAtFlipLimit()

		pnl:LerpColor("OutlineColor", atLimit and XeninUI.Theme.Red or XeninUI.Theme.Green)
		pnl:LerpColor("TextColor", atLimit and XeninUI.Theme.Red or color_white)
	end
	self.CreateFlip.OnCursorExited = function(pnl)
		pnl:LerpColor("OutlineColor", XeninUI.Theme.Primary)
		pnl:LerpColor("TextColor", Color(212, 212, 212))
	end
	self.CreateFlip.IsAtFlipLimit = function(pnl)
		local betsUp = 0
		
		if not VIPRanksTable[LocalPlayer():GetUserGroup()] then
			if (Coinflip.Config.MaxCoinflips != 0) then
				for i, v in pairs(Coinflip.Games) do
					if (v.author != LocalPlayer()) then continue end

					betsUp = betsUp + 1
				end

				if (betsUp >= Coinflip.Config.MaxCoinflips) then
					return true
				end
			end
		elseif VIPRanksTable[LocalPlayer():GetUserGroup()] then
			if (Coinflip.Config.MaxVIPCoinflips != 0) then
				for i, v in pairs(Coinflip.Games) do
					if (v.author != LocalPlayer()) then continue end

					betsUp = betsUp + 1
				end

				if (betsUp >= Coinflip.Config.MaxVIPCoinflips) then
					return true
				end 
			end
		end
	end

	self.CreateFlip.DoClick = function(pnl)
		if (pnl:IsAtFlipLimit() and not VIPRanksTable[LocalPlayer():GetUserGroup()]) then
			return XeninUI:Notify(Coinflip.i18n:get("ui.flips.maxFlipsReached", { 
				number = Coinflip.Config.MaxCoinflips 
				}, "You can maximum have :number: coinflips active!"),
				NOTIFY_ERROR, 4, XeninUI.Theme.Red)
		end
		if (pnl:IsAtFlipLimit() and VIPRanksTable[LocalPlayer():GetUserGroup()]) then
			return XeninUI:Notify(Coinflip.i18n:get("ui.flips.maxFlipsReached", { 
				number = Coinflip.Config.MaxVIPCoinflips 
				}, "You can maximum have :number: coinflips active!"),
				NOTIFY_ERROR, 4, XeninUI.Theme.Red)
		end

		local panel = vgui.Create("Coinflip.Games.Create")
	end

	self.Scroll = self:Add("XeninUI.Scrollpanel.Wyvern")
	self.Scroll:Dock(FILL)
	self.Scroll:DockMargin(16, 60, 16, 16)

	self.Rows = {}

	self:Populate()

	hook.Add("Coinflip.Created", self, function(self, id)
		self:Populate()
	end)
	hook.Add("Coinflip.Removed", self, function(self, id)
		self:Populate()
	end)
	hook.Add("Coinflip.Join.Error", self, function(self, err)
		self:Notification(err, XeninUI.Theme.Red)
	end)
end

function PANEL:Populate()
	for i, v in pairs(self.Scroll:GetChildren()[1]:GetChildren()) do
		v:Remove()
		self.Scroll:GetChildren()[1]:GetChildren()[i] = nil
	end

	local amt = table.Count(Coinflip.Games)
	self.Title:SetText(Coinflip.i18n:get("ui.flips.title", { flips = amt }, ":flips: active flips"))

	for i, v in pairs(Coinflip.Games) do
		if (!IsValid(v.author)) then continue end
		local panel = self.Scroll:Add("Coinflip.Games.Row")
		self.Rows[#self.Rows + 1] = panel
		panel:Dock(TOP)
		panel:DockMargin(0, 0, 8, 8)
		panel:SetTall(64)
		panel:SetID(i)
		panel:SetInfo(v)
	end

	self:InvalidateLayout()
end

function PANEL:PerformLayout(w, h)
	self.CreateFlip:SetPos(w - self.CreateFlip:GetWide() - 16, 12)

	self.Title:SetPos(16, 12)
	self.Title:SizeToContents()
end

vgui.Register("Coinflip.Games", PANEL, "XeninUI.Panel")
