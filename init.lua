local core = require 'core'
local command = require 'core.command'

local servers = {
	'lua-language-server'
}

command.add(nil, {
	['lspinstall:install-server'] = function()
		core.command_view:enter('Install LSP server', {
			submit = function(server)
				local serverManager = require('plugins.lspinstall.managers.' .. server)
				serverManager.install()
			end,
			suggest = function()
				return servers
			end
		})
	end
})
