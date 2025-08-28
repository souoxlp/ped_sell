RegisterNetEvent('ped_sell:venderItem', function(item, price)
    local src = source

    -- Verifica se o jogador tem o item
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