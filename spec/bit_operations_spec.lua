local bit = require('bit')

function string.fromhex(str)
    return (str:gsub('..', function (cc)
        return string.char(tonumber(cc, 16))
    end))
end

local FORM_CHUNK = string.fromhex('464f524d0000270a38535658')

describe('Bit operations', function()
  it('should read the type id of a FORM chunk', function()
    local type_id = string.sub(FORM_CHUNK, 1, 4)

    assert.is.equal('FORM', type_id)
  end)

  it('should read the size of the FORM chunk', function()
    local chunk_size = string.sub(FORM_CHUNK, 5, 8)
    local byte_4, byte_3, byte_2, byte_1 = string.byte(chunk_size, 1, 4)
    local size = byte_1 + bit.lshift(byte_2, 8) + bit.lshift(byte_3, 16) + bit.lshift(byte_4, 24)

    assert.are.same({0, 0, 0x27, 0x0a}, {byte_4, byte_3, byte_2, byte_1})
    assert.is.equal(0x270a, size)
  end)

  it('should read the file type', function()
    local file_type = string.sub(FORM_CHUNK, 9, 12)

    assert.is.equal('8SVX', file_type)
  end)
end)
