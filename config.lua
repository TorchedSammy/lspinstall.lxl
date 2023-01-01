local M = {
	requester = 'curl',
	baseDir = '~/.local/share/lite-xl/lspinstall'
}

function M.getBaseDir()
	return M.baseDir:gsub('~', HOME)
end

return M
