local bit = require('bit')

require('spec.test_tools')
require('spec.file_handle_stub')

package.path = 'src/github.sroccaserra.8BitSampleLoader.xrnx/?.lua;'..package.path
require('iff_tools')


describe('The FORM chunk', function()
  local chunk_info

  before_each(function()
    chunk_info = read_form_chunk_info_from_bytes(FORM_CHUNK)
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
  local chunk_info

  before_each(function()
    chunk_info = read_vhdr_chunk_info_from_bytes(VHDR_CHUNK)
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


describe('Splitting chunks until the BODY chunk', function()
  it('should return the FORM chunk (info only)', function()
    local file_handle_stub = FileHandleStub:new()

    local iff_chunks, err = read_iff_chunks(file_handle_stub)

    local chunk_info = iff_chunks.form_chunk_info

    assert.is.equal('FORM', chunk_info.chunk_id)
  end)

  it('should return the VHDR chunk', function()
    local file_handle_stub = FileHandleStub:new()

    local iff_chunks, err = read_iff_chunks(file_handle_stub)

    local chunk_info = iff_chunks.vhdr_chunk_info

    assert.is.equal('VHDR', chunk_info.chunk_id)
  end)
end)
