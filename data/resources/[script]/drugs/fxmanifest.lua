fx_version 'cerulean'
game 'common'

client_scripts {
    'client/main.lua',
    'client/deliveries.lua',
    'client/cornerselling.lua',
    'config.lua',
}

server_scripts {
    'server/main.lua',
    'server/deliveries.lua',
    'server/cornerselling.lua',
    'config.lua',
}

server_export 'GetDealers'