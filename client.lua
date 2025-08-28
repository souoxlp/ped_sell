local pedModel = "a_m_m_business_01"
local coords = vector3(215.76, -810.12, 29.73)
local npcPed -- salva referência do ped

Citizen.CreateThread(function()
    RequestModel(pedModel)
    while not HasModelLoaded(pedModel) do
        Wait(100)
    end                                     

    npcPed = CreatePed(4, pedModel, coords.x, coords.y, coords.z, 0.0, false, true)
    SetModelAsNoLongerNeeded(pedModel)
    FreezeEntityPosition(npcPed, true)
    SetEntityInvincible(npcPed, true)
    SetBlockingOfNonTemporaryEvents(npcPed, true)
    TaskStartScenarioInPlace(npcPed, "WORLD_HUMAN_STAND_IMPATIENT", 0, true)
    SetEntityHeading(npcPed, 340.0)

    exports.ox_target:addLocalEntity(npcPed, {
        {
            label = 'Vender itens',
            icon = 'fa-solid fa-dollar-sign',
            onSelect = function()
                lib.registerContext({
                    id = 'venda_menu',
                    title = 'Venda de Itens',
                    options = {
                        {
                            title = 'Vender Água',
                            description = 'Vende uma garrafa de água por $10',
                            icon = 'fa-solid fa-water',
                            onSelect = function()
                                TriggerServerEvent('ped_sell:venderItem', 'water', 10)
                            end
                        },
                        {
                            title = 'Vender Pão',
                            description = 'Vende um pão por $15',
                            icon = 'fa-solid fa-bread-slice',
                            onSelect = function()
                                TriggerServerEvent('ped_sell:venderItem', 'bread', 15)
                            end
                        }
                    }
                })
                lib.showContext('venda_menu')
            end
        }
    })
end)

RegisterNetEvent('ped_sell:animVenderItem', function()
    local playerPed = PlayerPedId()
    RequestAnimDict('mp_common')
    while not HasAnimDictLoaded('mp_common') do
        Wait(10)
    end
    -- Bloqueia ações do jogador
    TaskPlayAnim(playerPed, 'mp_common', 'givetake1_a', 8.0, -8.0, 1500, 48, 0, false, false, false)
    FreezeEntityPosition(playerPed, true)

    -- Animação do ped recebendo o item
    if npcPed and DoesEntityExist(npcPed) then
        RequestAnimDict('mp_common')
        while not HasAnimDictLoaded('mp_common') do
            Wait(10)
        end
        TaskPlayAnim(npcPed, 'mp_common', 'givetake2_a', 8.0, -8.0, 1500, 48, 0, false, false, false)
    end

    Wait(1500) -- tempo da animação
    ClearPedTasks(playerPed)
    FreezeEntityPosition(playerPed, false)
    if npcPed and DoesEntityExist(npcPed) then
        ClearPedTasks(npcPed)
        TaskStartScenarioInPlace(npcPed, "WORLD_HUMAN_STAND_IMPATIENT", 0, true)
    end
end)