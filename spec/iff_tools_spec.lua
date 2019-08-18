local bit = require('bit')

require('spec.test_tools')

package.path = 'src/github.sroccaserra.8BitSampleLoader.xrnx/?.lua;'..package.path
require('iff_tools')


describe('The FORM chunk', function()
  local FORM_CHUNK = bytes_from_hex('464f524d'..  -- 'FORM'
                                    '0000270a'..  -- chunk length after this ulong (the file size minus 8)
                                    '38535658')   -- '8SVX'
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
  local VHDR_CHUNK = bytes_from_hex('56484452'.. -- 'VHDR'
                                    '00000014'.. -- chunk length after this ulong
                                    '00000628'.. -- oneShotHiSamples
                                    '00001ee8'.. -- repeatHiSamples
                                    '00000020'.. -- samplesPerHiCycle
                                    '4156'..     -- samplesPerSec = data sampling rate
                                    '01'..       -- ctOctave
                                    '00'..       -- sCompression
                                    '00010000')  -- volume (16+16 bits fixed point), 00010000 = 0.1 (maximum in the IFF spec)
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
