---@param message string
local function _error(message)
    error({ message = message, name = "Lua Error" })
end

return _error
