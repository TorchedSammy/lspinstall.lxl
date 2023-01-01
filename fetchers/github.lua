local core = require 'core'
local json = require 'plugins.lspinstall.json'
local fun = require 'plugins.lspinstall.fun'
local requester = require 'plugins.lspinstall.request'
local Promise = require 'plugins.lspinstall.promise'

local M = {}

--- @param asset string The name of the release asset
--- @param dest string
function M.release(repo, asset, dest)
	local promise = Promise:new()
	requester.req(string.format('https://api.github.com/repos/%s/releases/latest', repo)):done(function(ret)
		local tbl = json.decode(ret.output)
		local filteredAssets = fun.filter(tbl.assets, function(t) return t.name == asset end)
		local reqAsset = filteredAssets[1]

		requester.download(reqAsset.browser_download_url, dest):forward(promise)
	end):fail(function()
		core.error 'Install failed.'
	end)

	return promise
end

function M.latestTag(repo)
	local promise = Promise:new()
	requester.req(string.format('https://api.github.com/repos/%s/releases/latest', repo)):done(function(ret)
		local tbl = json.decode(ret.output)
		promise:resolve(tbl.name)
	end):fail(function()
		promise:reject()
	end)

	return promise
end

return M
