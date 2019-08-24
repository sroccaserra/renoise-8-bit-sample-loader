local test_data = require('spec.test_data')
local bytes_from_hex = require('spec.byte_string_conversions').bytes_from_hex

package.path = 'src/github.sroccaserra.8BitSampleLoader.xrnx/?.lua;'..package.path
local RawFileParser = require('raw_file_parser').RawFileParser

describe('RawFileParser', function()
  local raw_file_parser

  before_each(function()
    raw_file_parser = RawFileParser:new(test_data.SAMPLE_BYTES)
  end)

  it('should read the first sample byte as integer', function()
    local value_0 = raw_file_parser:get_renoise_sample_value(1)

    assert.is.equal(0, value_0)
  end)

  it('should read the second sample byte as integer', function()
    local value_127 = raw_file_parser:get_renoise_sample_value(2)

    assert.is.equal(0.9921875, value_127)
  end)

  it('should read the third sample byte as integer', function()
    local value_minus_128 = raw_file_parser:get_renoise_sample_value(3)

    assert.is.equal(-1, value_minus_128)
  end)

  it('should read the fourth sample byte as integer', function()
    local value_minus_one = raw_file_parser:get_renoise_sample_value(4)

    assert.is.equal(-0.0078125, value_minus_one)
  end)
end)
