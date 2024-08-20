fx_version 'cerulean'
game 'gta5'

author 'Randolio'
description 'Pickpocketing'

shared_scripts { '@ox_lib/init.lua', 'config.lua', }

client_scripts { 'bridge/client/**.lua', 'client/*.lua', }

server_scripts {'bridge/server/**.lua', 'server/*.lua', }

dependencies { '/onesync', 'ox_lib' }

lua54 'yes'