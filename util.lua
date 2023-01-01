local config = require 'plugins.lspinstall.config'
local M = {}

--- @param cmd table
--- @param opts table?
--- @return table?
function M.exec(cmd, opts)
	local proc = process.start(cmd, opts or {})
	if proc then
		local stdout = ''
		local stderr = ''
		while true do
			local outChunk = proc:read_stdout()
			local errChunk = proc:read_stderr()

			if not proc:running() and not outChunk and not errChunk then break end

			stdout = stdout .. outChunk
			stderr = stderr .. errChunk

			coroutine.yield(0.1)
		end

		return {
			stdout = stdout,
			stderr = stderr,
			exitCode = proc:returncode()
		}
	end

	return nil
end

function M.joinPath(parts)
	local str = ''
	local sepPattern = string.format('%s$', '%' .. PATHSEP)
	for i, part in ipairs(parts) do
		local sepMatch = part:match(sepPattern)
		str = str .. part .. (sepMatch or i == #parts and '' or PATHSEP)
	end
	str = M.cleanPath(str)

	return str
end

function M.downloadPath(fname)
	local path = M.joinPath {config.getBaseDir(), fname}
	return path
end

function M.cleanPath(path)
	return path:gsub(string.format('%s$', '%' .. PATHSEP), '')
end

function M.dir(path)
	return M.cleanPath(path):match('(.*[/\\])')
end

function M.basename(path)
	return M.cleanPath(path):match('^.+/(.+)$')
end

return M
