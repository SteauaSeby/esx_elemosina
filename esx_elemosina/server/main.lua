ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj
end)

RegisterServerEvent('esx_elemosina:soldi')
AddEventHandler('esx_elemosina:soldi', function()
  local xPlayer = ESX.GetPlayerFromId(source)
  local soldi = Config.Guadagno

      xPlayer.addMoney(soldi)


end)

