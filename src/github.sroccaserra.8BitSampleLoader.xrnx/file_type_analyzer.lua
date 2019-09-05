
local IFF_ID_AND_LENGTH_NB_BYTES = 8

local FileTypeAnalyzer = {}

function FileTypeAnalyzer:new(file_bytes)
  local o = {
    file_bytes = file_bytes
  }

  setmetatable(o, self)
  self.__index = self

  return o
end

function FileTypeAnalyzer:is_iff_file()
  local has_required_vhdr_chunk = (nil ~= string.find(self.file_bytes, 'VHDR'))
  local has_required_body_chunk = (nil ~= string.find(self.file_bytes, 'BODY'))

  return has_required_vhdr_chunk and has_required_body_chunk
end

function FileTypeAnalyzer:is_aiff_file()
  return not not string.match(self.file_bytes, 'AIFF')
end

function FileTypeAnalyzer:is_wave_file()
  return string.sub(self.file_bytes, 1, 4) == 'RIFF'
end

function FileTypeAnalyzer:has_late_first_frame()
  local first_sample_frame = self:find_first_frame_position()

  return first_sample_frame ~= 1
end

function FileTypeAnalyzer:find_first_frame_position()
  local first_body_occurrence = string.find(self.file_bytes, 'BODY')
  if nil == first_body_occurrence then
    return 1
  end
  return first_body_occurrence + IFF_ID_AND_LENGTH_NB_BYTES
end

return {
  FileTypeAnalyzer = FileTypeAnalyzer,
}
