local outfitbags = {}

function DebugPrint(text)
    if Config.Debug then print("[ Outfit Bag | DEBUG] "..text) end
end

RegisterNetEvent('rs_outfitbag:open')
AddEventHandler('rs_outfitbag:open',function ()
    DebugPrint('Bag has been opened')
    openAppearance()
end)

-- Ensure commands are registered when enabled
if Config.Command.enabled then
    -- Register the full command
    RegisterCommand(Config.Command.command, function()
        print('Bag has been opened')
        TriggerEvent('rs_outfitbag:place')
    end)
end

exports('place', function()
 TriggerEvent('rs_outfitbag:place')
end)

RegisterNetEvent('rs_outfitbag:placed')
AddEventHandler('rs_outfitbag:placed',function ()
    DebugPrint('Bag has been placed')
    TriggerServerEvent('rs_outfitbag:placedBag')
end)

RegisterNetEvent('rs_outfitbag:pickedup')
AddEventHandler('rs_outfitbag:pickedup',function ()
    DebugPrint('Progress bar for picking up bag has started')
    lib.progressCircle({
        duration = 1000,
        position = 'bottom',
        label = Language.picking,
        useWhileDead = false,
        canCancel = false,
        disable = {
            car = true,
            move = true,
            combat = true
        },
        anim = {
            dict = 'random@domestic',
            clip = 'pickup_low'
        }
    })
    DebugPrint('Progress bar for picking up bag has completed')
    TriggerServerEvent('rs_outfitbag:pickedupBag')
    DebugPrint('Bag has been added to player\'s inventory')
    local outfitbag = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 2.1, GetHashKey(Config.Prop))
    DebugPrint('Bag has been deleted')
    DeleteEntity(outfitbag)
end)

local options = {
    {
        canInteract = function(_, distance, _)
            if IsEntityDead(PlayerPedId()) then
                return false
            end
            if distance >= Config.Distance then
                return false
            end
            if IsPedInAnyVehicle(PlayerPedId(), false) then
                return false
            end
            return true
        end,
        event = 'rs_outfitbag:open',
        icon = 'fa-solid fa-shirt',
        label = Language.open,
        distance = Config.Distance + 0.1
    },
    {
        canInteract = function(_, distance, _)
            if IsEntityDead(PlayerPedId()) then
                return false
            end
            if distance >= Config.Distance then
                return false
            end
            if IsPedInAnyVehicle(PlayerPedId(), false) then
                return false
            end
            return true
        end,
        event = 'rs_outfitbag:pickedup',
        icon = 'fa-solid fa-hand',
        label = Language.pickup,
        distance = Config.Distance + 0.1
    },
}

DebugPrint('Added bag model to target options')
exports.ox_target:addModel(Config.Prop, options)

RegisterNetEvent('rs_outfitbag:place')
AddEventHandler('rs_outfitbag:place',function ()
    RequestModel(Config.Prop)
    while not HasModelLoaded(Config.Prop) do Citizen.Wait(10) DebugPrint('Loading bag model...') end
    local ped = PlayerPedId()

    -- Handle inventory based on Config.Inventory
    local count
    if Config.Inventory == 'ox' then
	 count = lib.callback.await('ox_inventory:getItemCount', false, Config.Item.item, {})
    elseif Config.Inventory == 'qs' then
	 count = exports['qs-inventory']:Search(Config.Item.item)
    elseif Config.Inventory == 'codem' then
        count = lib.callback.await('codem_inventory:getItemCount', false, Config.Item.item, {})
    else
        DebugPrint('Invalid inventory type set in Config.Inventory')
        return
    end

    local x, y, z = table.unpack(GetEntityCoords(ped))
    if count >= 1 then
        DebugPrint('Player has '..count..' outfit bags')
        lib.progressCircle({
            duration = 1000,
            position = 'bottom',
            label = Language.placing,
            useWhileDead = false,
            canCancel = false,
            disable = {
                car = true,
                move = true,
                combat = true
            },
            anim = {
                dict = 'random@domestic',
                clip = 'pickup_low'
            },
            prop = {
                model = Config.Prop,
                pos = vec3(0.3, 0.03, 0.02),
                rot = vec3(0.05, 0.3, 0.15)
            },
        })
        Notify(Language.title, Language.placeditem)
        TriggerEvent('rs_outfitbag:placed')
        local outfitbag = CreateObject(Config.Prop, x, y, z-1, true, false, false)
        SetEntityHeading(outfitbag, GetEntityHeading(ped))
        PlaceObjectOnGroundProperly(outfitbag)
        table.insert(outfitbags, outfitbag)
    else
        DebugPrint('Player doesn\'t have the required item: '.. Config.Item.item)
    end
end)

function stopScript()
    -- Zastavení všech událostí a odstranění entit
    DebugPrint('Ukončuji všechny události a entitky.')

    -- Odstranění všech outfitbagů
    for _, bag in ipairs(outfitbags) do
        if DoesEntityExist(bag) then
            DeleteEntity(bag)
            DebugPrint('Bag entity has been deleted.')
        end
    end
    outfitbags = {}  -- Reset seznamu bagů

    DebugPrint('All events have been unregistered.')

    Citizen.CreateThread(function()
        DebugPrint('Stopping client script...')
        SetTimeout(1000, function()  -- Krátké zpoždění pro vyčištění
            ForceSocialClubUpdate()  -- Tento příkaz zajistí, že klient ukončí vlákno.
            DebugPrint('Client script has been stopped.')
        end)
    end)
    DebugPrint('Script has been stopped.')
end

AddEventHandler('onResourceStart', function(resourceName)
    local resourceName = 'rs_outfitbag'

    if resourceName == GetCurrentResourceName() then
        for k, bag in pairs(outfitbags) do
            DebugPrint('Trying to deleted outfitbag with hash key: '..bag)
            if DoesEntityExist(bag) then DeleteEntity(bag) DebugPrint('Deleted '..bag) end
        end
    elseif resourceName ~= GetCurrentResourceName() then
        stopScript()
    end
end)
