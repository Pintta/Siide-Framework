rg = {}
rg.Asetus = Asetus
rg.datapankki = Datapankki
rg.takaisinhuuto = {}
rg.UseableItems = {}

function GetCoreObject()
	return rg
end

RegisterServerEvent('rg:HaeAsia')
AddEventHandler('rg:HaeAsia', function(cb)
	cb(GetCoreObject())
end)

RegisterServerEvent('rg:droppaa')
AddEventHandler('rg:droppaa', function()
    local src = source
    local Player = rg.toiminnot.GetPlayer(src)
    rg.toiminnot.Kick(src, 'Sähläsit nyt jotain, mikä ei ole sallittua..')
end)