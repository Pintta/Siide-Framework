rg.Players = {}
rg.Player = {}

rg.Player.Login = function(source, citizenid, newData)
	if source ~= nil then
		if citizenid then
			rg.toiminnot.datasilta(true, "SELECT * FROM `players` WHERE `citizenid` = '"..citizenid.."'", function(result)
				local PlayerData = result[1]
				if PlayerData ~= nil then
					PlayerData.money = json.decode(PlayerData.money)
					PlayerData.job = json.decode(PlayerData.job)
					PlayerData.position = json.decode(PlayerData.position)
					PlayerData.metadata = json.decode(PlayerData.metadata)
					PlayerData.charinfo = json.decode(PlayerData.charinfo)
					if PlayerData.rikollinen ~= nil then
						PlayerData.rikollinen = json.decode(PlayerData.rikollinen)
					else
						PlayerData.rikollinen = {}
					end
				end
				rg.Player.CheckPlayerData(source, PlayerData)
			end)
		else
			rg.Player.CheckPlayerData(source, newData)
		end
		return true
	else
		rg.ShowError(GetCurrentResourceName(), "ERROR rg.PLAYER.LOGIN - NO SOURCE GIVEN!")
		return false
	end
end

rg.Player.CheckPlayerData = function(source, PlayerData)
	PlayerData										= PlayerData 									~= nil and PlayerData or {}
	PlayerData.source								= source
	PlayerData.citizenid							= PlayerData.citizenid 							~= nil and PlayerData.citizenid or rg.Player.CreateCitizenId()
	PlayerData.steam								= PlayerData.steam 								~= nil and PlayerData.steam or rg.toiminnot.GetIdentifier(source, "steam")
	PlayerData.license								= PlayerData.license 							~= nil and PlayerData.license or rg.toiminnot.GetIdentifier(source, "license")
	PlayerData.name									= GetPlayerName(source)
	PlayerData.cid									= PlayerData.cid 								~= nil and PlayerData.cid or 1
	PlayerData.money								= PlayerData.money 								~= nil and PlayerData.money or {}
	for moneytype, startamount in pairs(rg.Asetus.Valuutta.Muodot) do
		PlayerData.money[moneytype] = PlayerData.money[moneytype]									~= nil and PlayerData.money[moneytype] or startamount
	end
	PlayerData.charinfo								= PlayerData.charinfo 							~= nil and PlayerData.charinfo or {}
	PlayerData.charinfo.firstname					= PlayerData.charinfo.firstname 				~= nil and PlayerData.charinfo.firstname or "Etunimi"
	PlayerData.charinfo.lastname					= PlayerData.charinfo.lastname 					~= nil and PlayerData.charinfo.lastname or "Sukunimi"
	PlayerData.charinfo.birthdate					= PlayerData.charinfo.birthdate 				~= nil and PlayerData.charinfo.birthdate or "00-00-0000"
	PlayerData.charinfo.gender						= PlayerData.charinfo.gender 					~= nil and PlayerData.charinfo.gender or 0
	PlayerData.charinfo.backstory					= PlayerData.charinfo.backstory 				~= nil and PlayerData.charinfo.backstory or "taustatarina"
	PlayerData.charinfo.nationality					= PlayerData.charinfo.nationality 				~= nil and PlayerData.charinfo.nationality or "suomalainen"
	PlayerData.charinfo.phone						= PlayerData.charinfo.phone 					~= nil and PlayerData.charinfo.phone or "045"..math.random(11111111, 99999999)
	PlayerData.charinfo.account						= PlayerData.charinfo.account 					~= nil and PlayerData.charinfo.account or "FI17"..math.random(1,9).."RG"..math.random(1111,9999)..math.random(1111,9999)..math.random(11,99)
	PlayerData.metadata								= PlayerData.metadata 							~= nil and PlayerData.metadata or {}
	PlayerData.metadata["hunger"]					= PlayerData.metadata["hunger"] 				~= nil and PlayerData.metadata["hunger"] or 100
	PlayerData.metadata["thirst"]					= PlayerData.metadata["thirst"] 				~= nil and PlayerData.metadata["thirst"] or 100
	PlayerData.metadata["stress"]					= PlayerData.metadata["stress"] 				~= nil and PlayerData.metadata["stress"] or 0
	PlayerData.metadata["isdead"]					= PlayerData.metadata["isdead"] 				~= nil and PlayerData.metadata["isdead"] or false
	PlayerData.metadata["inlaststand"]				= PlayerData.metadata["inlaststand"] 			~= nil and PlayerData.metadata["inlaststand"] or false
	PlayerData.metadata["armor"]					= PlayerData.metadata["armor"]					~= nil and PlayerData.metadata["armor"] or 0
	PlayerData.metadata["ishandcuffed"]				= PlayerData.metadata["ishandcuffed"] 			~= nil and PlayerData.metadata["ishandcuffed"] or false	
	PlayerData.metadata["tracker"]					= PlayerData.metadata["tracker"] 				~= nil and PlayerData.metadata["tracker"] or false
	PlayerData.metadata["injail"]					= PlayerData.metadata["injail"] 				~= nil and PlayerData.metadata["injail"] or 0
	PlayerData.metadata["jailitems"]				= PlayerData.metadata["jailitems"] 				~= nil and PlayerData.metadata["jailitems"] or {}
	PlayerData.metadata["status"]					= PlayerData.metadata["status"] 				~= nil and PlayerData.metadata["status"] or {}
	PlayerData.metadata["phone"]					= PlayerData.metadata["phone"] 					~= nil and PlayerData.metadata["phone"] or {}
	PlayerData.metadata["fitbit"]					= PlayerData.metadata["fitbit"]					~= nil and PlayerData.metadata["fitbit"] or {}
	PlayerData.metadata["commandbinds"]				= PlayerData.metadata["commandbinds"]			~= nil and PlayerData.metadata["commandbinds"] or {}
	PlayerData.metadata["bloodtype"]				= PlayerData.metadata["bloodtype"]				~= nil and PlayerData.metadata["bloodtype"] or rg.Asetus.Pelaaja.Veriarvo[math.random(1, #rg.Asetus.Pelaaja.Veriarvo)]
	PlayerData.metadata["dealerrep"]				= PlayerData.metadata["dealerrep"]				~= nil and PlayerData.metadata["dealerrep"] or 0
	PlayerData.metadata["craftingrep"]				= PlayerData.metadata["craftingrep"]			~= nil and PlayerData.metadata["craftingrep"] or 0
	PlayerData.metadata["attachmentcraftingrep"]	= PlayerData.metadata["attachmentcraftingrep"]	~= nil and PlayerData.metadata["attachmentcraftingrep"] or 0
	PlayerData.metadata["currentapartment"]			= PlayerData.metadata["currentapartment"]		~= nil and PlayerData.metadata["currentapartment"] or nil
	PlayerData.metadata["jobrep"]					= PlayerData.metadata["jobrep"]					~= nil and PlayerData.metadata["jobrep"] or {
		["tow"] = 0,
		["trucker"] = 0,
		["taxi"] = 0,
		["hotdog"] = 0,
	}
	PlayerData.metadata["callsign"]					= PlayerData.metadata["callsign"] 				~= nil and PlayerData.metadata["callsign"] or "NO CALLSIGN"
	PlayerData.metadata["fingerprint"]				= PlayerData.metadata["fingerprint"] 			~= nil and PlayerData.metadata["fingerprint"] or rg.Player.CreateFingerId()
	PlayerData.metadata["walletid"]					= PlayerData.metadata["walletid"] 				~= nil and PlayerData.metadata["walletid"] or rg.Player.CreateWalletId()
	PlayerData.metadata["criminalrecord"]			= PlayerData.metadata["criminalrecord"] 		~= nil and PlayerData.metadata["criminalrecord"] or {
		["hasRecord"] = false,
		["date"] = nil
	}	
	PlayerData.metadata["licences"]					= PlayerData.metadata["licences"] 				~= nil and PlayerData.metadata["licences"] or {
		["driver"] = true,
		["business"] = false,
		["weapon"] = false,
	}	
	PlayerData.metadata["inside"]					= PlayerData.metadata["inside"] 				~= nil and PlayerData.metadata["inside"] or {
		house = nil,
		apartment = {
			apartmentType = nil,
			apartmentId = nil,
		}
	}
	PlayerData.metadata["phonedata"]				= PlayerData.metadata["phonedata"] 				~= nil and PlayerData.metadata["phonedata"] or {
        SerialNumber = rg.Player.CreateSerialNumber(),
        InstalledApps = {},
    }
	PlayerData.job									= PlayerData.job								~= nil and PlayerData.job or {}
	PlayerData.job.name								= PlayerData.job.name							~= nil and PlayerData.job.name or "unemployed"
	PlayerData.job.label							= PlayerData.job.label							~= nil and PlayerData.job.label or "Työtön"
	PlayerData.job.payment							= PlayerData.job.payment						~= nil and PlayerData.job.payment or 10
	PlayerData.job.onduty							= PlayerData.job.onduty							~= nil and PlayerData.job.onduty or true
	PlayerData.job.isboss							= PlayerData.job.isboss							~= nil and PlayerData.job.isboss or false
	PlayerData.job.grade							= PlayerData.job.grade							~= nil and PlayerData.job.grade or {}
	PlayerData.job.grade.name						= PlayerData.job.grade.name						~= nil and PlayerData.job.grade.name or "Vapaalla"
	PlayerData.job.grade.level						= PlayerData.job.grade.level					~= nil and PlayerData.job.grade.level or 0
	PlayerData.rikollinen							= PlayerData.rikollinen							~= nil and PlayerData.rikollinen or {}
	PlayerData.rikollinen.name						= PlayerData.rikollinen.name					~= nil and PlayerData.rikollinen.name or "geen"
	PlayerData.rikollinen.label						= PlayerData.rikollinen.label					~= nil and PlayerData.rikollinen.label or "rikollinen"
	PlayerData.rikollinen.payment					= PlayerData.rikollinen.payment					~= nil and PlayerData.rikollinen.payment or 10
	PlayerData.rikollinen.onduty					= PlayerData.rikollinen.onduty					~= nil and PlayerData.rikollinen.onduty or true
	PlayerData.rikollinen.isboss					= PlayerData.rikollinen.isboss					~= nil and PlayerData.rikollinen.isboss or false
	PlayerData.rikollinen.grade						= PlayerData.rikollinen.grade					~= nil and PlayerData.rikollinen.grade or {}
	PlayerData.rikollinen.grade.name				= PlayerData.rikollinen.grade.name				~= nil and PlayerData.rikollinen.grade.name or "Vapaalla"
	PlayerData.rikollinen.grade.level				= PlayerData.rikollinen.grade.level				~= nil and PlayerData.rikollinen.grade.level or 0
	PlayerData.position								= PlayerData.position							~= nil and PlayerData.position or Asetus.DefaultSpawn
	PlayerData.LoggedIn								= true
	PlayerData										= rg.Player.LoadInventory(PlayerData)
	rg.Player.CreatePlayer(PlayerData)
end

rg.Player.CreatePlayer = function(PlayerData)
	local self = {}
	self.Functions = {}
	self.PlayerData = PlayerData
	self.Functions.PaivitaPelaajaTtiedot = function()
		TriggerClientEvent("rg:Player:AsetaPelaajantiedot", self.PlayerData.source, self.PlayerData)
		rg.komennot.Refresh(self.PlayerData.source)
	end
	self.Functions.SetJob = function(job)
		local job = job:lower()
		local grade = tostring(grade)				~= nil and tostring(grade) or '0'
		if rg.datapankki.Jobs[job]					~= nil then
			self.PlayerData.job.name				= job
			self.PlayerData.job.label				= rg.datapankki.Jobs[job].label
			self.PlayerData.job.payment				= rg.datapankki.Jobs[job].payment
			self.PlayerData.job.onduty				= rg.datapankki.Jobs[job].defaultDuty
		if rg.datapankki.Jobs[job].grades[grade] then
			local jobgrade							= rg.datapankki.Jobs[job].grades[grade]
			self.PlayerData.job.grade				= {}
			self.PlayerData.job.grade.name			= jobgrade.name
			self.PlayerData.job.grade.level			= tonumber(grade)
			self.PlayerData.job.payment				= jobgrade.payment ~= nil and jobgrade.payment or 30
			self.PlayerData.job.isboss				= jobgrade.isboss ~= nil and jobgrade.isboss or false
		else
			self.PlayerData.job.grade				= {}
			self.PlayerData.job.grade.name			= 'No Grades'
			self.PlayerData.job.grade.level			= 0
			self.PlayerData.job.payment				= 30
			self.PlayerData.job.isboss				= false
		end
			self.Functions.PaivitaPelaajaTtiedot()
			TriggerClientEvent("rg:Client:OnJobUpdate", self.PlayerData.source, self.PlayerData.job)
		end
	end
	self.Functions.AsetaRikollinen = function(rikollinen)
		local rikollinen = rikollinen:lower()
		local grade = tostring(grade)					~= nil and tostring(grade) or '0'
		if rg.datapankki.rikollinen[rikollinen] 		~= nil then
			self.PlayerData.rikollinen.name				= rikollinen
			self.PlayerData.rikollinen.label			= rg.datapankki.rikollinen[rikollinen].label
			self.PlayerData.rikollinen.payment			= rg.datapankki.rikollinen[rikollinen].payment
			self.PlayerData.rikollinen.onduty			= rg.datapankki.rikollinen[rikollinen].defaultDuty
		if rg.datapankki.rikollinen[rikollinen].grades[grade] then
			local rikollinengrade						= rg.datapankki.rikollinen[rikollinen].grades[grade]
			self.PlayerData.rikollinen.grade			= {}
			self.PlayerData.rikollinen.grade.name		= rikollinengrade.name
			self.PlayerData.rikollinen.grade.level		= tonumber(grade)
			self.PlayerData.rikollinen.payment			= rikollinengrade.payment ~= nil and rikollinengrade.payment or 30
			self.PlayerData.rikollinen.isboss			= rikollinengrade.isboss ~= nil and rikollinengrade.isboss or false
		else
			self.PlayerData.rikollinen.grade			= {}
			self.PlayerData.rikollinen.grade.name		= 'No Grades'
			self.PlayerData.rikollinen.grade.level		= 0
			self.PlayerData.rikollinen.payment			= 30
			self.PlayerData.rikollinen.isboss			= false
		end
			self.Functions.PaivitaPelaajaTtiedot()
			TriggerClientEvent("rg:Client:OnGangUpdate", self.PlayerData.source, self.PlayerData.rikollinen)
		end
	end
	self.Functions.SetJobDuty = function(onDuty)
		self.PlayerData.job.onduty = onDuty
		self.Functions.PaivitaPelaajaTtiedot()
	end
	self.Functions.SetMetaData = function(meta, val)
		local meta = meta:lower()
		if val ~= nil then
			self.PlayerData.metadata[meta] = val
			self.Functions.PaivitaPelaajaTtiedot()
		end
	end
	self.Functions.AddJobReputation = function(amount)
		local amount = tonumber(amount)
		self.PlayerData.metadata["jobrep"][self.PlayerData.job.name] = self.PlayerData.metadata["jobrep"][self.PlayerData.job.name] + amount
		self.Functions.PaivitaPelaajaTtiedot()
	end
	self.Functions.AddMoney = function(moneytype, amount, reason)
		reason = reason ~= nil and reason or "unkown"
		local moneytype = moneytype:lower()
		local amount = tonumber(amount)
		if amount < 0 then return end
		if self.PlayerData.money[moneytype] ~= nil then
			self.PlayerData.money[moneytype] = self.PlayerData.money[moneytype]+amount
			self.Functions.PaivitaPelaajaTtiedot()
			TriggerEvent("logs:server:sendLog", self.PlayerData.citizenid, "moneyadded", {amount=amount, moneytype=moneytype, newbalance=self.PlayerData.money[moneytype], reason=reason})
			if amount > 100000 then
				TriggerEvent("logs:server:CreateLog", "playermoney", "TILISIIRTO", "lightgreen", "**"..GetPlayerName(self.PlayerData.source) .. " (citizenid: "..self.PlayerData.citizenid.." | id: "..self.PlayerData.source..")** "..amount .. "€ ("..moneytype..") ON SIIRETTY TILILLE "..moneytype.." SALDO: "..self.PlayerData.money[moneytype], true)
			else
				TriggerEvent("logs:server:CreateLog", "playermoney", "TILISIIRTO", "lightgreen", "**"..GetPlayerName(self.PlayerData.source) .. " (citizenid: "..self.PlayerData.citizenid.." | id: "..self.PlayerData.source..")** "..amount .. "€ ("..moneytype..") ON SIIRETTY TILILLE "..moneytype.." SALDO: "..self.PlayerData.money[moneytype])
			end
			TriggerClientEvent("hud:client:OnMoneyChange", self.PlayerData.source, moneytype, amount, false)
			return true
		end
		return false
	end
	self.Functions.RemoveMoney = function(moneytype, amount, reason)
		reason = reason ~= nil and reason or "unkown"
		local moneytype = moneytype:lower()
		local amount = tonumber(amount)
		if amount < 0 then return end
		if self.PlayerData.money[moneytype] ~= nil then
			for _, mtype in pairs(rg.Asetus.Valuutta.DontAllowMinus) do
				if mtype == moneytype then
					if self.PlayerData.money[moneytype] - amount < 0 then return false end
				end
			end
			self.PlayerData.money[moneytype] = self.PlayerData.money[moneytype] - amount
			self.Functions.PaivitaPelaajaTtiedot()
			TriggerEvent("logs:server:sendLog", self.PlayerData.citizenid, "moneyremoved", {amount=amount, moneytype=moneytype, newbalance=self.PlayerData.money[moneytype], reason=reason})
			if amount > 100000 then
				TriggerEvent("logs:server:CreateLog", "playermoney", "OSTOTAPAHTUMA", "red", "**"..GetPlayerName(self.PlayerData.source) .. " (citizenid: "..self.PlayerData.citizenid.." | id: "..self.PlayerData.source..")** "..amount .. "€ ("..moneytype..") ON SIIRETTY TILILTÄ "..moneytype.." SALDO: "..self.PlayerData.money[moneytype], true)
			else
				TriggerEvent("logs:server:CreateLog", "playermoney", "OSTOTAPAHTUMA", "red", "**"..GetPlayerName(self.PlayerData.source) .. " (citizenid: "..self.PlayerData.citizenid.." | id: "..self.PlayerData.source..")** "..amount .. "€ ("..moneytype..") ON SIIRETTY TILILTÄ "..moneytype.." SALDO: "..self.PlayerData.money[moneytype])
			end
			TriggerClientEvent("hud:client:OnMoneyChange", self.PlayerData.source, moneytype, amount, true)
			TriggerClientEvent('phone:client:RemoveBankMoney', self.PlayerData.source, amount)
			return true
		end
		return false
	end
	self.Functions.SetMoney = function(moneytype, amount, reason)
		reason = reason ~= nil and reason or "unkown"
		local moneytype = moneytype:lower()
		local amount = tonumber(amount)
		if amount < 0 then return end
		if self.PlayerData.money[moneytype] ~= nil then
			self.PlayerData.money[moneytype] = amount
			self.Functions.PaivitaPelaajaTtiedot()
			TriggerEvent("logs:server:sendLog", self.PlayerData.citizenid, "moneyset", {amount=amount, moneytype=moneytype, newbalance=self.PlayerData.money[moneytype], reason=reason})
			TriggerEvent("logs:server:CreateLog", "playermoney", "SetMoney", "green", "**"..GetPlayerName(self.PlayerData.source) .. " (citizenid: "..self.PlayerData.citizenid.." | id: "..self.PlayerData.source..")** $"..amount .. " ("..moneytype..") gezet, nieuw "..moneytype.." balans: "..self.PlayerData.money[moneytype])
			return true
		end
		return false
	end
	self.Functions.AddItem = function(item, amount, slot, info)
		local totalWeight = rg.Player.GetTotalWeight(self.PlayerData.items)
		local itemInfo = rg.datapankki.Items[item:lower()]
		if itemInfo == nil then TriggerClientEvent('chatMessage', -1, "SYSTEM",  "warning", "No item found??") return end
		local amount = tonumber(amount)
		local slot = tonumber(slot) ~= nil and tonumber(slot) or rg.Player.GetFirstSlotByItem(self.PlayerData.items, item)
		if itemInfo["type"] == "weapon" and info == nil then
			info = {
				serie = tostring(rg.datapankki.RandomInt(2) .. rg.datapankki.RandomStr(3) .. rg.datapankki.RandomInt(1) .. rg.datapankki.RandomStr(2) .. rg.datapankki.RandomInt(3) .. rg.datapankki.RandomStr(4)),
			}
		end
		if (totalWeight + (itemInfo["weight"] * amount)) <= rg.Asetus.Pelaaja.Reppupaino then
			if (slot ~= nil and self.PlayerData.items[slot] ~= nil) and (self.PlayerData.items[slot].name:lower() == item:lower()) and (itemInfo["type"] == "item" and not itemInfo["unique"]) then
				self.PlayerData.items[slot].amount = self.PlayerData.items[slot].amount + amount
				self.Functions.PaivitaPelaajaTtiedot()
				TriggerEvent("logs:server:sendLog", self.PlayerData.citizenid, "itemadded", {name=self.PlayerData.items[slot].name, amount=amount, slot=slot, newamount=self.PlayerData.items[slot].amount, reason="unkown"})
				TriggerEvent("logs:server:CreateLog", "playerinventory", "REPPU", "green", "**"..GetPlayerName(self.PlayerData.source) .. " (citizenid: "..self.PlayerData.citizenid.." | id: "..self.PlayerData.source..")** got item: [slot:" ..slot.."], itemname: " .. self.PlayerData.items[slot].name .. ", added amount: " .. amount ..", new total amount: ".. self.PlayerData.items[slot].amount)
				return true
			elseif (not itemInfo["unique"] and slot or slot ~= nil and self.PlayerData.items[slot] == nil) then
				self.PlayerData.items[slot] = {name = itemInfo["name"], amount = amount, info = info ~= nil and info or "", label = itemInfo["label"], description = itemInfo["description"] ~= nil and itemInfo["description"] or "", weight = itemInfo["weight"], type = itemInfo["type"], unique = itemInfo["unique"], useable = itemInfo["useable"], image = itemInfo["image"], shouldClose = itemInfo["shouldClose"], slot = slot, combinable = itemInfo["combinable"]}
				self.Functions.PaivitaPelaajaTtiedot()
				TriggerEvent("logs:server:sendLog", self.PlayerData.citizenid, "itemadded", {name=self.PlayerData.items[slot].name, amount=amount, slot=slot, newamount=self.PlayerData.items[slot].amount, reason="unkown"})
				TriggerEvent("logs:server:CreateLog", "playerinventory", "REPPU", "green", "**"..GetPlayerName(self.PlayerData.source) .. " (citizenid: "..self.PlayerData.citizenid.." | id: "..self.PlayerData.source..")** got item: [slot:" ..slot.."], itemname: " .. self.PlayerData.items[slot].name .. ", added amount: " .. amount ..", new total amount: ".. self.PlayerData.items[slot].amount)
				return true
			elseif (itemInfo["unique"]) or (not slot or slot == nil) or (itemInfo["type"] == "weapon") then
				for i = 1, Asetus.Pelaaja.Repputila, 1 do
					if self.PlayerData.items[i] == nil then
						self.PlayerData.items[i] = {name = itemInfo["name"], amount = amount, info = info ~= nil and info or "", label = itemInfo["label"], description = itemInfo["description"] ~= nil and itemInfo["description"] or "", weight = itemInfo["weight"], type = itemInfo["type"], unique = itemInfo["unique"], useable = itemInfo["useable"], image = itemInfo["image"], shouldClose = itemInfo["shouldClose"], slot = i, combinable = itemInfo["combinable"]}
						self.Functions.PaivitaPelaajaTtiedot()
						TriggerEvent("logs:server:sendLog", self.PlayerData.citizenid, "itemadded", {name=self.PlayerData.items[i].name, amount=amount, slot=i, newamount=self.PlayerData.items[i].amount, reason="unkown"})
						TriggerEvent("logs:server:CreateLog", "playerinventory", "REPPU", "green", "**"..GetPlayerName(self.PlayerData.source) .. " (citizenid: "..self.PlayerData.citizenid.." | id: "..self.PlayerData.source..")** got item: [slot:" ..i.."], itemname: " .. self.PlayerData.items[i].name .. ", added amount: " .. amount ..", new total amount: ".. self.PlayerData.items[i].amount)
						return true
					end
				end
			end
		end
		return false
	end
	self.Functions.RemoveItem = function(item, amount, slot)
		local itemInfo = rg.datapankki.Items[item:lower()]
		local amount = tonumber(amount)
		local slot = tonumber(slot)
		if slot ~= nil then
			if self.PlayerData.items[slot].amount > amount then
				self.PlayerData.items[slot].amount = self.PlayerData.items[slot].amount - amount
				self.Functions.PaivitaPelaajaTtiedot()
				TriggerEvent("logs:server:sendLog", self.PlayerData.citizenid, "itemremoved", {name=self.PlayerData.items[slot].name, amount=amount, slot=slot, newamount=self.PlayerData.items[slot].amount, reason="unkown"})
				TriggerEvent("logs:server:CreateLog", "playerinventory", "RemoveItem", "red", "**"..GetPlayerName(self.PlayerData.source) .. " (citizenid: "..self.PlayerData.citizenid.." | id: "..self.PlayerData.source..")** lost item: [slot:" ..slot.."], itemname: " .. self.PlayerData.items[slot].name .. ", removed amount: " .. amount ..", new total amount: ".. self.PlayerData.items[slot].amount)
				return true
			else
				self.PlayerData.items[slot] = nil
				self.Functions.PaivitaPelaajaTtiedot()
				TriggerEvent("logs:server:sendLog", self.PlayerData.citizenid, "itemremoved", {name=item, amount=amount, slot=slot, newamount=0, reason="unkown"})
				TriggerEvent("logs:server:CreateLog", "playerinventory", "RemoveItem", "red", "**"..GetPlayerName(self.PlayerData.source) .. " (citizenid: "..self.PlayerData.citizenid.." | id: "..self.PlayerData.source..")** lost item: [slot:" ..slot.."], itemname: " .. item .. ", removed amount: " .. amount ..", item removed")
				return true
			end
		else
			local slots = rg.Player.GetSlotsByItem(self.PlayerData.items, item)
			local amountToRemove = amount
			if slots ~= nil then
				for _, slot in pairs(slots) do
					if self.PlayerData.items[slot].amount > amountToRemove then
						self.PlayerData.items[slot].amount = self.PlayerData.items[slot].amount - amountToRemove
						self.Functions.PaivitaPelaajaTtiedot()
						TriggerEvent("logs:server:sendLog", self.PlayerData.citizenid, "itemremoved", {name=self.PlayerData.items[slot].name, amount=amount, slot=slot, newamount=self.PlayerData.items[slot].amount, reason="unkown"})
						TriggerEvent("logs:server:CreateLog", "playerinventory", "RemoveItem", "red", "**"..GetPlayerName(self.PlayerData.source) .. " (citizenid: "..self.PlayerData.citizenid.." | id: "..self.PlayerData.source..")** lost item: [slot:" ..slot.."], itemname: " .. self.PlayerData.items[slot].name .. ", removed amount: " .. amount ..", new total amount: ".. self.PlayerData.items[slot].amount)
						return true
					elseif self.PlayerData.items[slot].amount == amountToRemove then
						self.PlayerData.items[slot] = nil
						self.Functions.PaivitaPelaajaTtiedot()
						TriggerEvent("logs:server:sendLog", self.PlayerData.citizenid, "itemremoved", {name=item, amount=amount, slot=slot, newamount=0, reason="unkown"})
						TriggerEvent("logs:server:CreateLog", "playerinventory", "RemoveItem", "red", "**"..GetPlayerName(self.PlayerData.source) .. " (citizenid: "..self.PlayerData.citizenid.." | id: "..self.PlayerData.source..")** lost item: [slot:" ..slot.."], itemname: " .. item .. ", removed amount: " .. amount ..", item removed")
						return true
					end
				end
			end
		end
		return false
	end
	self.Functions.SetInventory = function(items)
		self.PlayerData.items = items
		self.Functions.PaivitaPelaajaTtiedot()
		TriggerEvent("logs:server:sendLog", self.PlayerData.citizenid, "setinventory", {items=json.encode(items)})
		TriggerEvent("logs:server:CreateLog", "playerinventory", "SetInventory", "blue", "**"..GetPlayerName(self.PlayerData.source) .. " (citizenid: "..self.PlayerData.citizenid.." | id: "..self.PlayerData.source..")** items set: " .. json.encode(items))
	end
	self.Functions.ClearInventory = function()
		self.PlayerData.items = {}
		self.Functions.PaivitaPelaajaTtiedot()
		TriggerEvent("logs:server:sendLog", self.PlayerData.citizenid, "clearinventory", {})
		TriggerEvent("logs:server:CreateLog", "playerinventory", "ClearInventory", "red", "**"..GetPlayerName(self.PlayerData.source) .. " (citizenid: "..self.PlayerData.citizenid.." | id: "..self.PlayerData.source..")** inventory cleared")
	end
	self.Functions.GetItemByName = function(item)
		local item = tostring(item):lower()
		local slot = rg.Player.GetFirstSlotByItem(self.PlayerData.items, item)
		if slot ~= nil then
			return self.PlayerData.items[slot]
		end
		return nil
	end
	self.Functions.GetItemBySlot = function(slot)
		local slot = tonumber(slot)
		if self.PlayerData.items[slot] ~= nil then
			return self.PlayerData.items[slot]
		end
		return nil
	end
	self.Functions.Save = function()
		rg.Player.Save(self.PlayerData.source)
	end
	rg.Players[self.PlayerData.source] = self
	rg.Player.Save(self.PlayerData.source)
	self.Functions.PaivitaPelaajaTtiedot()
end

rg.Player.Save = function(source)
	local PlayerData = rg.Players[source].PlayerData
	if PlayerData ~= nil then
		rg.toiminnot.datasilta(true, "SELECT * FROM `players` WHERE `citizenid` = '"..PlayerData.citizenid.."'", function(result)
			if result[1] == nil then
				rg.toiminnot.datasilta(true, "INSERT INTO `players` (`citizenid`, `cid`, `steam`, `license`, `name`, `money`, `charinfo`, `job`, `gang`, `rikollinen`, `position`, `metadata`) VALUES ('"..PlayerData.citizenid.."', '"..tonumber(PlayerData.cid).."', '"..PlayerData.steam.."', '"..PlayerData.license.."', '"..PlayerData.name.."', '"..json.encode(PlayerData.money).."', '"..rg.EscapeSqli(json.encode(PlayerData.charinfo)).."', '"..json.encode(PlayerData.job).."', '"..json.encode(PlayerData.gang).."', '"..json.encode(PlayerData.rikollinen).."', '"..json.encode(PlayerData.position).."', '"..json.encode(PlayerData.metadata).."')")
			else
				rg.toiminnot.datasilta(true, "UPDATE `players` SET steam='"..PlayerData.steam.."',license='"..PlayerData.license.."',name='"..PlayerData.name.."',money='"..json.encode(PlayerData.money).."',charinfo='"..rg.EscapeSqli(json.encode(PlayerData.charinfo)).."',job='"..json.encode(PlayerData.job).."',gang='"..json.encode(PlayerData.gang).."',rikollinen='"..json.encode(PlayerData.rikollinen).."', position='"..json.encode(PlayerData.position).."',metadata='"..json.encode(PlayerData.metadata).."' WHERE `citizenid` = '"..PlayerData.citizenid.."'")
			end
			rg.Player.SaveInventory(source)
		end)
		rg.ShowSuccess(GetCurrentResourceName(), PlayerData.name .." henkilön tiedot tallennettu.")
	else
		rg.ShowError(GetCurrentResourceName(), "ERROR rg.PLAYER.SAVE - PLAYERDATA IS EMPTY!")
	end
end

rg.Player.Logout = function(source)
	TriggerClientEvent('rg:Client:OnPlayerUnload', source)
	TriggerClientEvent("rg:Player:PaivitaPelaajaTtiedot", source)
	Citizen.Wait(200)
	rg.Players[source] = nil
end

rg.Player.DeleteCharacter = function(source, citizenid)
	rg.toiminnot.datasilta(true, "DELETE FROM `players` WHERE `citizenid` = '"..citizenid.."'")
	TriggerEvent("logs:server:sendLog", citizenid, "characterdeleted", {})
	TriggerEvent("logs:server:CreateLog", "joinleave", "Character Deleted", "red", "**".. GetPlayerName(source) .. "** ("..GetPlayerIdentifiers(source)[1]..") deleted **"..citizenid.."**..")
end

rg.Player.LoadInventory = function(PlayerData)
	PlayerData.items = {}
	rg.toiminnot.datasilta(true, "SELECT * FROM `playeritems` WHERE `citizenid` = '"..PlayerData.citizenid.."'", function(oldInventory)
		if oldInventory[1] ~= nil then
			for _, item in pairs(oldInventory) do
				if item ~= nil then
					local itemInfo = rg.datapankki.Items[item.name:lower()]
					PlayerData.items[item.slot] = {name = itemInfo["name"], amount = item.amount, info = json.decode(item.info) ~= nil and json.decode(item.info) or "", label = itemInfo["label"], description = itemInfo["description"] ~= nil and itemInfo["description"] or "", weight = itemInfo["weight"], type = itemInfo["type"], unique = itemInfo["unique"], useable = itemInfo["useable"], image = itemInfo["image"], shouldClose = itemInfo["shouldClose"], slot = item.slot, combinable = itemInfo["combinable"]}
				end
				Citizen.Wait(1)
			end
			rg.toiminnot.datasilta(true, "DELETE FROM `playeritems` WHERE `citizenid` = '"..PlayerData.citizenid.."'")
		else
			rg.toiminnot.datasilta(true, "SELECT * FROM `players` WHERE `citizenid` = '"..PlayerData.citizenid.."'", function(result)
				if result[1] ~= nil then 
					if result[1].inventory ~= nil then
						plyInventory = json.decode(result[1].inventory)
						if next(plyInventory) ~= nil then 
							for _, item in pairs(plyInventory) do
								if item ~= nil then
									local itemInfo = rg.datapankki.Items[item.name:lower()]
									PlayerData.items[item.slot] = {name = itemInfo["name"], amount = item.amount, info = item.info ~= nil and item.info or "", label = itemInfo["label"], description = itemInfo["description"] ~= nil and itemInfo["description"] or "", weight = itemInfo["weight"], type = itemInfo["type"], unique = itemInfo["unique"], useable = itemInfo["useable"], image = itemInfo["image"], shouldClose = itemInfo["shouldClose"], slot = item.slot, combinable = itemInfo["combinable"]}
								end
							end
						end
					end
				end
			end)
		end
	end)
	return PlayerData
end

rg.Player.SaveInventory = function(source)
	if rg.Players[source] ~= nil then 
		local PlayerData = rg.Players[source].PlayerData
		local items = PlayerData.items
		local ItemsJson = {}
		if items ~= nil and next(items) ~= nil then
			for slot, item in pairs(items) do
				if items[slot] ~= nil then
					table.insert(ItemsJson, {name = item.name, amount = item.amount, info = item.info, type = item.type, slot = slot})
				end
			end
			rg.toiminnot.datasilta(true, "UPDATE `players` SET `inventory` = '"..rg.EscapeSqli(json.encode(ItemsJson)).."' WHERE `citizenid` = '"..PlayerData.citizenid.."'")
		end
	end
end

rg.Player.GetTotalWeight = function(items)
	local weight = 0
	if items ~= nil then
		for slot, item in pairs(items) do
			weight = weight + (item.weight * item.amount)
		end
	end
	return tonumber(weight)
end

rg.Player.GetSlotsByItem = function(items, itemName)
	local slotsFound = {}
	if items ~= nil then
		for slot, item in pairs(items) do
			if item.name:lower() == itemName:lower() then
				table.insert(slotsFound, slot)
			end
		end
	end
	return slotsFound
end

rg.Player.GetFirstSlotByItem = function(items, itemName)
	if items ~= nil then
		for slot, item in pairs(items) do
			if item.name:lower() == itemName:lower() then
				return tonumber(slot)
			end
		end
	end
	return nil
end

rg.Player.CreateCitizenId = function()
	local UniqueFound = false
	local CitizenId = nil
	while not UniqueFound do
		CitizenId = tostring(rg.datapankki.RandomStr(3) .. rg.datapankki.RandomInt(5)):upper()
		rg.toiminnot.datasilta(true, "SELECT COUNT(*) as count FROM `players` WHERE `citizenid` = '"..CitizenId.."'", function(result)
			if result[1].count == 0 then
				UniqueFound = true
			end
		end)
	end
	return CitizenId
end

rg.Player.CreateFingerId = function()
	local UniqueFound = false
	local FingerId = nil
	while not UniqueFound do
		FingerId = tostring(rg.datapankki.RandomStr(2) .. rg.datapankki.RandomInt(3) .. rg.datapankki.RandomStr(1) .. rg.datapankki.RandomInt(2) .. rg.datapankki.RandomStr(3) .. rg.datapankki.RandomInt(4))
		rg.toiminnot.datasilta(true, "SELECT COUNT(*) as count FROM `players` WHERE `metadata` LIKE '%"..FingerId.."%'", function(result)
			if result[1].count == 0 then
				UniqueFound = true
			end
		end)
	end
	return FingerId
end

rg.Player.CreateWalletId = function()
	local UniqueFound = false
	local WalletId = nil
	while not UniqueFound do
		WalletId = "RV-"..math.random(11111111, 99999999)
		rg.toiminnot.datasilta(true, "SELECT COUNT(*) as count FROM `players` WHERE `metadata` LIKE '%"..WalletId.."%'", function(result)
			if result[1].count == 0 then
				UniqueFound = true
			end
		end)
	end
	return WalletId
end

rg.Player.CreateSerialNumber = function()
    local UniqueFound = false
    local SerialNumber = nil
    while not UniqueFound do
        SerialNumber = math.random(11111111, 99999999)
        rg.toiminnot.datasilta(true, "SELECT COUNT(*) as count FROM players WHERE metadata LIKE '%"..SerialNumber.."%'", function(result)
            if result[1].count == 0 then
                UniqueFound = true
            end
        end)
    end
    return SerialNumber
end

rg.EscapeSqli = function(str)
    local replacements = {['"'] = '\\"', ["'"] = "\\'"}
    return str:gsub("['\"]", replacements)
end