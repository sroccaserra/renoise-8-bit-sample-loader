local FileParserABC = require('file_parser_abc').FileParserABC

---
-- Class RawFileParser

local RawFileParser = FileParserABC:new()

function RawFileParser:get_sample_rate()
  return nil
end

function RawFileParser:get_nb_frames()
  return #self.bytes
end

function RawFileParser:get_renoise_sample_value(index)
  local signed_char =  self:_read_signed_char(index)

  return signed_char/128
end

function RawFileParser:get_sample_name()
  return nil
end

return {
  RawFileParser = RawFileParser
}
