fx_version 'adamant'
game 'gta5'

client_scripts {
    'core/sh.lua',
    'core/cl.lua',
}

server_scripts {
    'core/sh.lua',
    'core/sv.lua',
}

server_export 'getCurrentGameType'
server_export 'getCurrentMap'
server_export 'changeGameType'
server_export 'changeMap'
server_export 'doesMapSupportGameType'
server_export 'getMaps'
server_export 'roundEnded'