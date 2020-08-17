local CONFIG = {}

function CONFIG:Init()
  Coinflip.Config = {}
  Coinflip.Config.ChatCommands = {}
end

function CONFIG:SetChatPrefixColor(col)
  Coinflip.Config.ChatPrefixColor = col
end

function CONFIG:SetChatPrefix(str)
  Coinflip.Config.ChatPrefix = str
end

function CONFIG:SetSpeed(num)
  Coinflip.Config.StartSpeed = num
end

function CONFIG:SetMinBet(num)
  Coinflip.Config.MinBet = num
end

function CONFIG:SetMaxBet(num)
  Coinflip.Config.MaxBet = num
end

function CONFIG:SetMaxCoinflips(num)
  Coinflip.Config.MaxCoinflips = num
end
-- Added by dotCore
function CONFIG:SetMaxVIPCoinflips(num)
  Coinflip.Config.MaxVIPCoinflips = num
end

function CONFIG:SetMenuTitle(str)
  Coinflip.Config.MenuTitle = str
end

function CONFIG:SetNPCTitle(title)
  Coinflip.Config.NPCTitle = title
end

function CONFIG:SetNPCModel(model)
  Coinflip.Config.NPCModel = model
end

function CONFIG:SetNPCIcon(icon)
  assert(type(icon) == "IMaterial" or icon == nil, "You need to use a Material!")

  Coinflip.Config.NPCIcon = icon
end

function CONFIG:SetNPCOutlineColor(color)
  Coinflip.Config.NPCOutlineColor = color
end

function CONFIG:SetCreationAnnouncementDisabled(bool)
  Coinflip.Config.DisableCreationAnnouncement = bool
end

function CONFIG:SetWinAnnouncementDisabled(bool)
  Coinflip.Config.DisableWinAnnouncement = bool
end

function CONFIG:SetSeedRegularly(bool)
  Coinflip.Config.SeedRegularly = bool
end

function CONFIG:SetOldCurrency(curr)
  Coinflip.Config.OldCurrency = curr
end

function CONFIG:SetCurrency(currs)
  Coinflip.Config.Currency = currs
end

function CONFIG:SetLanguage(lang, tbl)
  Coinflip.i18n:setLanguage(lang, tbl)
end

function CONFIG:AddChatCommand(cmd)
  Coinflip.Config.ChatCommands[cmd] = true
end

function Coinflip:CreateConfig()
  local tbl = table.Copy(CONFIG)
  tbl:Init()

  return tbl
end
