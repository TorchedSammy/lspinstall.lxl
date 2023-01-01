local core = require 'core'
local util = require 'plugins.lspinstall.util'
local github = require 'plugins.lspinstall.fetchers.github'
local tar = require 'plugins.lspinstall.extractors.tar'
local installPath = util.downloadPath(util.joinPath {
	'lua-language-server', string.format('lua-language-server.tar.gz')
})

local M = {}

local function extract()
	tar.extract(installPath)
	:done(function()
		core.log 'install complete!'
	end)
	:fail(function()
		core.error 'extract failed'
	end)
end

function M.install()
	github.latestTag 'sumneko/lua-language-server'
	:done(function(tag)
		if not tag or tag == '' then core.error 'oh no'; return end

		local releaseAsset = string.format('lua-language-server-%s-linux-x64.tar.gz', tag)
		github.release('sumneko/lua-language-server', releaseAsset, installPath)
		:done(extract)
		:fail(function()
			core.error 'FAILURE'
		end)
	end)
	:fail(function()
		core.error 'OH NO'
	end)
end

return M
