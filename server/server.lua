RegisterServerEvent('way_outfitbag:placedBag')
AddEventHandler('way_outfitbag:placedBag',function ()
	exports.ox_inventory:RemoveItem(source, Config.Item.item, 1, nil, nil, nil)
end)

RegisterServerEvent('way_outfitbag:pickedupBag')
AddEventHandler('way_outfitbag:pickedupBag',function ()
	exports.ox_inventory:AddItem(source, Config.Item.item, 1, nil, nil, nil)
end)