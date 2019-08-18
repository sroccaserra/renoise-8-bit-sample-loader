local bit = require('bit')

require('spec.test_tools')

package.path = 'src/github.sroccaserra.8BitSampleLoader.xrnx/?.lua;'..package.path
require('iff_tools')

local FORM_CHUNK = bytes_from_hex('464f524d0000270a38535658')

describe('Bit operations', function()
  local chunk_info

  before_each(function()
    chunk_info = read_form_chunk_info_from_bytes(FORM_CHUNK)
  end)

  it('should read the type id of a FORM chunk', function()
    assert.is.equal('FORM', chunk_info.chunk_id)
  end)

  it('should read the size of the FORM chunk', function()
    assert.is.equal(0x270a, chunk_info.chunk_size)
  end)

  it('should read the file type', function()
    assert.is.equal('8SVX', chunk_info.file_type_id)
  end)
end)
