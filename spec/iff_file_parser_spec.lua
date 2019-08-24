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
    assert.is.equal(0x3c, chunk_info.chunk_length)
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

describe('The BODY chunk', function()
  describe('Main behaviour', function()
    local iff_file_parser

    before_each(function()
      iff_file_parser = IffFileParser:new(test_data.IFF_FILE_BYTES)
    end)

    it('should find the BODY chunk', function()
      local chunk_info = iff_file_parser:find_body_chunk_info()

      assert.is.equal('BODY', chunk_info.chunk_id)
      assert.is.equal(4, chunk_info.chunk_length)
    end)

    it('should return the sample data', function()
      local sample_data = iff_file_parser:get_sample_data()

      assert.is.equal('ABCD', sample_data)
    end)
  end)

  describe('Edge cases and errors', function()
    it('should find an empty BODY chunk', function()
      local iff_file_parser = IffFileParser:new(test_data.IFF_FILE_WITH_EMPTY_BODY)

      local chunk_info = iff_file_parser:find_body_chunk_info()

      assert.is.equal('BODY', chunk_info.chunk_id)
      assert.is.equal(0, chunk_info.chunk_length)
    end)

    it('should return an error when the BODY chunk is not found', function()
      local iff_file_parser = IffFileParser:new(test_data.BYTES_WITHOUT_BODY_CHUNK)

      assert.has_error(function()
        chunk_info = iff_file_parser:find_body_chunk_info()
      end, IffFileParser.ERROR_BODY_CHUNK_NOT_FOUND)
    end)
  end)
end)
