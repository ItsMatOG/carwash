RegisterServerEvent("carwash:serversync")
AddEventHandler("carwash:serversync", function(target)
    TriggerClientEvent("carwash:startcarwash", target)
end)