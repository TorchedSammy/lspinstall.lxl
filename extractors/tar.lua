local core = require 'core'
local util = require 'plugins.lspinstall.util'
local Promise = require 'plugins.lspinstall.promise'

local M = {}

function M.extract(file, cwd)
	local promise = Promise:new()
	core.add_thread(function()
		util.exec({'tar', 'xvzf', file, '-C', cwd or util.dir(file)})
		promise:resolve()
	end)
	return promise
end

return M
