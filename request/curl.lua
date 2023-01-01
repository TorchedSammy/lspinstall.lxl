local core = require 'core'
local util = require 'plugins.lspinstall.util'
local Promise = require 'plugins.lspinstall.promise'

local M = {}

function M.req(url)
	local promise = Promise:new()

	core.add_thread(function()
		local out = util.exec {'curl', '--fail', '-s', url}
		if not out then promise:reject() end

		if out.exitCode ~= 0 then
			promise:reject {
				success = true,
				output = out.stdout .. out.stderr
			}
			return
		end

		promise:resolve {
			success = true,
			output = out.stdout .. out.stderr
		}
	end)
	return promise
end

function M.download(url, dest)
	local destDir = util.dir(dest)
	local fname = util.basename(dest)

	local promise = Promise:new()
	core.add_thread(function()
		local out = util.exec {'curl', '-L', '--create-dirs', '--output-dir', destDir, '--fail', url, '-o', fname}
		if not out then promise:reject() end

		if out.exitCode ~= 0 then
			promise:reject {
				success = false,
				output = out.stdout .. out.stderr
			}
			return
		end

		promise:resolve {
			success = true,
			output = out.stdout .. out.stderr
		}
	end)
	return promise
end

return M
