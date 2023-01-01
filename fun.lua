-- Functional Module
local M = {}

--- @param t table
--- @param fn function
function M.filter(t, fn)
	local res = {}

	for k, v in pairs(t) do
		if fn(v, k, t) then table.insert(res, v) end
	end

	return res
end

return M
