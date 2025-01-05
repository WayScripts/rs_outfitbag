function Notify(title,desc)
     if Config.Notify == 'ox' then
     lib.notify({
          title = title,
          description = desc,
          position = 'top',
          icon = 'shirt',
      })
     elseif Config.Notify == 'wayscripts' then
          exports['way_notifystyle2']:showNotification('info', title, desc, 5000, 'top-right')
     elseif Config.Notify == 'custom' then
            -- Add Your custom notify
     end
end

function openAppearance()
     if Config.Appearance == 'illenium' then
          TriggerEvent('illenium-appearance:client:openOutfitMenu')
     elseif Config.Appearance == 'fivem' then

     elseif Config.Appearance == 'custom' then
         -- Add Your custom appearance
     end
end