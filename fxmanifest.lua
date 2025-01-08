fx_version 'cerulean'
game 'gta5'
lua54 'yes'


author 'Way Scripts | Outfit Bag'
description '[FREE] Outfit bag'
version '1.0.1'


shared_scripts {
	'@ox_lib/init.lua',
	'config/*.lua'
}
server_script {
	'server/*.lua'
}

client_scripts {
	'client/*.lua'
}

dependencies {
	'ox_lib',
	'ox_target',
	'es_extended'
 }
 