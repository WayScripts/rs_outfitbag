RegisterServerEvent('way_outfitbag:placedBag')
AddEventHandler('way_outfitbag:placedBag',function ()
    -- Handle inventory based on Config.Inventory
    if Config.Inventory == 'ox' then
     exports.ox_inventory:RemoveItem(source, Config.Item.item, 1, nil, nil, nil)
    elseif Config.Inventory == 'qs' then
	exports['qs-inventory']:RemoveItem(source, Config.Item.item, 1)
    elseif Config.Inventory == 'codem' then
     exports['codem-inventory']:RemoveItem(source, Config.Item.item, 1)
    else
        print("Invalid inventory type in Config.Inventory")
    end
end)

RegisterServerEvent('way_outfitbag:pickedupBag')
AddEventHandler('way_outfitbag:pickedupBag',function ()
    -- Handle inventory based on Config.Inventory
    if Config.Inventory == 'ox' then
        exports.ox_inventory:AddItem(source, Config.Item.item, 1, nil, nil, nil)
    elseif Config.Inventory == 'qs' then
	exports['qs-inventory']:AddItem(source, Config.Item.item, 1)
    elseif Config.Inventory == 'codem' then
	exports['codem-inventory']:AddItem(source, Config.Item.item, 1)
    else
        print("Invalid inventory type in Config.Inventory")
    end
end)
