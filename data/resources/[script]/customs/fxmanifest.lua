fx_version 'cerulean'
game 'gta5'
lua54 'on'
is_cfxv2 'yes'
use_fxv2_oal 'true'

ui_page 'core/ui/index.html'

client_scripts {
	'core/config.lua',
	'core/prices.lua',
	'core/clfunctions.lua',
	'core/menus.lua',
	'core/labels.lua',
	'core/helper.lua',
	'core/job.lua',
	'core//api.lua',
	'core/client.lua',
}

server_scripts {
	'core/config.lua',
	'core/svfunctions.lua',
	'core/server.lua',
}

files {
	'core/ui/index.html',
	'core/ui/js/main.js',
	'core/ui/css/style.css',
	'core/ui/sounds/asennus.ogg',
	'core/ui/sounds/maali.ogg',
	'core/ui/img/check.png',
	'core/ui/img/**/*.png',
}