local FORM_CHUNK_NB_BYTES = 12
local VHDR_CHUNK_NB_BYTES = 28

---
-- Class IffFileParser

local IffFileParser = {}
IffFileParser.__index = IffFileParser

function IffFileParser:new(iff_file_bytes)
  local o = {
    bytes = iff_file_bytes
  }

  setmetatable(o, self)

  return o
end

function IffFileParser:get_form_chunk_info()
  local chunk_id, chunk_length = self:_read_id_and_length(1)
  local file_type_id = string.sub(self.bytes, 9, 12)

  return {
    chunk_id = chunk_id,
    chunk_length = chunk_length,
    file_type_id = file_type_id
  }
end

function IffFileParser:get_vhdr_chunk_info()
  local chunk_id, chunk_length = self:_read_id_and_length(FORM_CHUNK_NB_BYTES + 1)
  local sample_rate = self:_read_uword(FORM_CHUNK_NB_BYTES + 21)

  return {
    chunk_id = chunk_id,
    chunk_length = chunk_length,
    sample_rate = sample_rate
  }
end

function IffFileParser:_read_id_and_length(start)
  local chunk_id = string.sub(self.bytes, start, start + 3)
  local chunk_length = self:_read_ulong(start + 4)

  return chunk_id, chunk_length
end

function IffFileParser:_read_uword(start)
  local byte_2, byte_1 = string.byte(self.bytes, start, start + 1)

  return byte_1 +
         bit.lshift(byte_2, 8)
end

function IffFileParser:_read_ulong(start)
  local byte_4, byte_3, byte_2, byte_1 = string.byte(self.bytes, start, start + 3)

  return byte_1 +
         bit.lshift(byte_2, 8) +
         bit.lshift(byte_3, 16) +
         bit.lshift(byte_4, 24)
end

---
-- Module exports

return {
  IffFileParser = IffFileParser
}
