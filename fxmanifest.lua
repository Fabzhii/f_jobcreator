fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'fabzhii'
description 'F-Jobmaker by fabzhii'
version '1.0.0'

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/sounds/*.ogg',
}

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    'config/*.lua',
    'server/*.lua',
    'edit_this/server.lua',
}

client_scripts {
    'config/*.lua',
    'action/*.lua',
    'marker/*.lua',
    'creation/*.lua',
    'edit_this/client.lua',
} 

dependencies {
	'ox_lib',
    'ox_inventory',
}