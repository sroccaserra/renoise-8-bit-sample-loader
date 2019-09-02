local test_data = require('spec.test_data')

package.path = 'src/github.sroccaserra.8BitSampleLoader.xrnx/?.lua;'..package.path
local FileTypeAnalyzer = require('file_type_analyzer').FileTypeAnalyzer

describe('FileTypeAnalyzer', function()
  describe('IFF files', function()
    it('should find a well formed IFF file', function()
      local file_type_analyzer = FileTypeAnalyzer:new(test_data.IFF_FILE_BYTES)

      assert.is_true(file_type_analyzer:is_iff_file())
    end)

    it('should find an IFF file without a FORM chunk', function()
      local file_type_analyzer = FileTypeAnalyzer:new(test_data.IFF_FILE_WITHOUT_FORM_CHUNK)

      assert.is_true(file_type_analyzer:is_iff_file())
    end)

    it('should not find an IFF file without a VHDR chunk', function()
      local file_type_analyzer = FileTypeAnalyzer:new(test_data.IFF_FILE_WITHOUT_VHDR_CHUNK)

      assert.is_false(file_type_analyzer:is_iff_file())
    end)

    it('should not find an IFF file without a BODY chunk', function()
      local file_type_analyzer = FileTypeAnalyzer:new(test_data.IFF_FILE_WITHOUT_BODY_CHUNK)

      assert.is_false(file_type_analyzer:is_iff_file())
    end)
  end)

  describe('Popular file formats not supported by this tool', function()
    it('should find an AIFF file', function()
      local file_type_analyzer = FileTypeAnalyzer:new(test_data.AIFF_FILE_BYTES)

      assert.is_false(file_type_analyzer:is_iff_file())
      assert.is_true(file_type_analyzer:is_aiff_file())
    end)

    it('should find a WAVE file', function()
      local file_type_analyzer = FileTypeAnalyzer:new(test_data.WAVE_FILE_BYTES)

      assert.is_false(file_type_analyzer:is_iff_file())
      assert.is_true(file_type_analyzer:is_wave_file())
    end)
  end)
end)
