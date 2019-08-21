local function bytes_from_hex(str)
    return (str:gsub('..', function (cc)
        return string.char(tonumber(cc, 16))
    end))
end

local function bytes_to_hex(str)
    return (str:gsub('.', function (c)
        return string.format('%02X', string.byte(c))
    end))
end

return {
  bytes_from_hex = bytes_from_hex,
  bytes_to_hex = bytes_to_hex
}
