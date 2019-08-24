---
-- Class FileParserABC

local FileParserABC = {}

function FileParserABC:new(file_bytes)
  local o = {
    bytes = file_bytes
  }

  setmetatable(o, self)
  self.__index = self

  return o
end

function FileParserABC:get_sample_rate(index)
  error('Subclass responsibility.')
end

function FileParserABC:get_nb_frames(index)
  error('Subclass responsibility.')
end

function FileParserABC:get_renoise_sample_value(index)
  error('Subclass responsibility.')
end

function FileParserABC:get_sample_name(index)
  error('Subclass responsibility.')
end

function FileParserABC:_read_signed_char(position)
  local char = string.byte(self.bytes, position)

  if char < 128 then
    return char
  end

  return char - 256
end

return {
  FileParserABC = FileParserABC
}

