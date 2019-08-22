local bit = require('bit')

local test_data = require('spec.test_data')

package.path = 'src/github.sroccaserra.8BitSampleLoader.xrnx/?.lua;'..package.path
local IffFileParser = require('iff_file_parser').IffFileParser


describe('The FORM chunk', function()
  local iff_file_parser
  local chunk_info

  before_each(function()
    iff_file_parser = IffFileParser:new(test_data.IFF_FILE_BYTES)
    chunk_info = iff_file_parser:get_form_chunk_info()
  end)

  it('should read the type id of a FORM chunk', function()
    assert.is.equal('FORM', chunk_info.chunk_id)
  end)

  it('should read the length of the FORM chunk', function()
    assert.is.equal(0x270a, chunk_info.chunk_length)
  end)

  it('should read the file type', function()
    assert.is.equal('8SVX', chunk_info.file_type_id)
  end)
end)


describe('The VHDR chunk', function()
  local iff_file_parser
  local chunk_info

  before_each(function()
    iff_file_parser = IffFileParser:new(test_data.IFF_FILE_BYTES)
    chunk_info = iff_file_parser:get_vhdr_chunk_info()
  end)

  it('should read the chunk_id of the VHDR chunk', function()
    assert.is.equal('VHDR', chunk_info.chunk_id)
  end)

  it('should read the chunk length', function()
    assert.is.equal(20, chunk_info.chunk_length)
  end)

  it('should read the sample rate from the VHDR chunk', function()
    assert.is.equal(16726, chunk_info.sample_rate)
  end)
end)
