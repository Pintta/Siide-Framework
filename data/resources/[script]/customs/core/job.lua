rg = nil
jobName = nil

CreateThread(function()
    while rg == nil do
		TriggerEvent('rg:HaeAsia', function(obj) rg = obj end)
		Wait(200)
    end
end)

RegisterNetEvent('rg:Client:OnPlayerLoaded')
AddEventHandler('rg:Client:OnPlayerLoaded', function()
    jobName = rg.toiminnot.GetPlayerData().job.name
    updateUICurrentJob()
end)

RegisterNetEvent('rg:Client:OnJobUpdate')
AddEventHandler('rg:Client:OnJobUpdate', function(JobInfo)
    jobName = rg.toiminnot.GetPlayerData().job.name
    updateUICurrentJob()
end)