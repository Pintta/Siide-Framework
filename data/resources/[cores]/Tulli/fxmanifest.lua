fx_version 'cerulean'
game 'common'

server_scripts {
	'core/config.lua',
	'core/sh1.lua',
	'core/sh2.lua',
	'core/sv.lua',
	'core/svFunctions.lua',
	'core/svPlayer.lua',
	'core/svEvents.lua',
	'core/svCommands.lua',
	'core/svDebug.lua',
	'core/svQueue.lua',
	'core/svTulli.lua',
}

client_scripts {
	'core/config.lua',
	'core/sh1.lua',
	'core/sh2.lua',
	'core/clFunctions.lua',
	'core/clLoops.lua',
	'core/clEvents.lua',
	'core/clkieli.lua',
}

loadscreen 'core/loadscreen/index.html'
ui_page 'core/html/ui.html'

files {
	'core/html/ui.html',
	'core/html/css/main.css',
	'core/html/js/app.js',
	'core/loadscreen/index.html',
	'core/loadscreen/musiikki.mp3',
	'core/loadscreen/logo-up.png',
	'core/loadscreen/logo-dw.png',
}