
local FileTypeAnalyzer = {}

function FileTypeAnalyzer:new(file_bytes)
  local o = {
    first_bytes = string.sub(file_bytes, 1, 512)
  }

  setmetatable(o, self)
  self.__index = self

  return o
end

function FileTypeAnalyzer:is_iff_file()
  return not not string.match(self.first_bytes, '8SVX')
end

function FileTypeAnalyzer:is_aiff_file()
  return not not string.match(self.first_bytes, 'AIFF')
end

function FileTypeAnalyzer:is_wave_file()
  return string.sub(self.first_bytes, 1, 4) == 'RIFF'
end

return {
  FileTypeAnalyzer = FileTypeAnalyzer,
}
