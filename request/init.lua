local core = require 'core'
local config = require 'plugins.lspinstall.config'
local ok, requester = pcall(require, 'plugins.lspinstall.request.' .. config.requester)

if not ok then
	core.error('Invalid requester %s supplied in config', config.requester)
end

return requester
