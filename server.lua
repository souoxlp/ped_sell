local itemsForSale = {
    water = 10,
    bread = 15
}

local npcCoords = vector3(215.76, -810.12, 29.73) -- mesma coordenada do client

local function DistCheck(playerId, coords, check)
    local playerPed = GetPlayerPed(playerId)
    local playerCoords = GetEntityCoords(playerPed)
    local distance = #(playerCoords - coords)
    return distance <= check
end

RegisterNetEvent('ped_sell:venderItem', function(item)
    local src = source
    local price = itemsForSale[item]
    if not price then
        TriggerClientEvent('ox_lib:notify', src, {type = 'error', description = 'Item inválido!'})
        return
    end

    if not DistCheck(src, npcCoords, 3.0) then
        TriggerClientEvent('ox_lib:notify', src, {type = 'error', description = 'Você está muito longe do vendedor!'})
        return
    end

    local itemCount = exports.ox_inventory:GetItem(src, item, nil, true)
    if type(itemCount) == "table" then
        itemCount = itemCount.count or 0
    elseif type(itemCount) ~= "number" then
        itemCount = 0
    end

    if itemCount > 0 then
        exports.ox_inventory:RemoveItem(src, item, 1)
        exports.ox_inventory:AddItem(src, 'money', price)
        TriggerClientEvent('ped_sell:animVenderItem', src)
        TriggerClientEvent('ox_lib:notify', src, {type = 'success', description = 'Venda realizada!'})
    else
        TriggerClientEvent('ox_lib:notify', src, {type = 'error', description = 'Você não tem esse item!'})
    end
end)
