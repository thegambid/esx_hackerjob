resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'ESX Hacker Job'

version '1.0.0'

client_scripts {
	'@es_extended/locale.lua',
	'locales/tr.lua',
	'client/main.lua',
	'config.lua'
}

server_scripts {
	'@es_extended/locale.lua',
	'locales/tr.lua',
	'server/main.lua',
	'config.lua'
}

dependency 'es_extended'