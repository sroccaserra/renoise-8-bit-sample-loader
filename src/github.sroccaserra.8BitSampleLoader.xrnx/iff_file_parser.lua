local FileParserABC = require('file_parser_abc').FileParserABC

local FORM_CHUNK_NB_BYTES = 12
local ID_AND_LENGTH_NB_BYTES = 8

---
-- Class IffFileParser

local IffFileParser = FileParserABC:new()
IffFileParser.ERROR_CHUNK_NOT_FOUND = 'Error: chunk "%s" not found'

function IffFileParser:get_form_chunk_info()
  local chunk_id, chunk_length = self:_read_id_and_length(1)
  local file_type_id = string.sub(self.bytes, ID_AND_LENGTH_NB_BYTES + 1,
                                              ID_AND_LENGTH_NB_BYTES + 4)

  return {
    chunk_id = chunk_id,
    chunk_length = chunk_length,
    file_type_id = file_type_id
  }
end

function IffFileParser:get_vhdr_chunk_info()
  local chunk_info = self:find_chunk_info('VHDR')
  local data_start_byte = chunk_info.start_byte_number + ID_AND_LENGTH_NB_BYTES

  local one_shot_high_samples = self:_read_ulong(data_start_byte)
  local repeat_high_samples = self:_read_ulong(data_start_byte + 4)
  local sample_rate = self:_read_uword(data_start_byte + 12)

  return {
    chunk_id = chunk_info.chunk_id,
    chunk_length = chunk_info.chunk_length,

    sample_rate = sample_rate,
    one_shot_high_samples = one_shot_high_samples,
    repeat_high_samples = repeat_high_samples
  }
end

function IffFileParser:find_chunk_info(wanted_chunk_id)
  local start_byte_number = self:_find_first_known_chunk()
  local chunk_id, chunk_length = self:_read_id_and_length(start_byte_number)

  while chunk_id ~= wanted_chunk_id do
    start_byte_number = start_byte_number + ID_AND_LENGTH_NB_BYTES + chunk_length
    if start_byte_number + ID_AND_LENGTH_NB_BYTES - 1 > #self.bytes then
      local error_message = string.format(IffFileParser.ERROR_CHUNK_NOT_FOUND, wanted_chunk_id)
      error(error_message)
    end
    chunk_id, chunk_length = self:_read_id_and_length(start_byte_number)
  end

  return {
    chunk_id = chunk_id,
    chunk_length = chunk_length,
    start_byte_number = start_byte_number
  }
end

function IffFileParser:find_body_chunk_info()
  return self:find_chunk_info('BODY')
end

function IffFileParser:get_sample_bytes()
  local body_chunk_info = self:find_body_chunk_info()
  local start_byte_number = body_chunk_info.start_byte_number + ID_AND_LENGTH_NB_BYTES

  return string.sub(self.bytes, start_byte_number, start_byte_number + body_chunk_info.chunk_length)
end

function IffFileParser:get_sample_rate()
  local vhdr_chunk_info = self:get_vhdr_chunk_info()

  return vhdr_chunk_info.sample_rate
end

function IffFileParser:get_nb_frames()
  local body_chunk_info = self:find_body_chunk_info()
  local remaining_file_size = #self.bytes + 1 - body_chunk_info.start_byte_number - ID_AND_LENGTH_NB_BYTES

  return math.min(body_chunk_info.chunk_length, remaining_file_size)
end

function IffFileParser:get_sample_name()
  local status, name_chunk_info = pcall(function()
    return self:find_chunk_info('NAME')
  end)

  if not status then
    return
  end

  local name_start = name_chunk_info.start_byte_number + ID_AND_LENGTH_NB_BYTES
  local name_end = name_start + name_chunk_info.chunk_length
  local name_bytes = string.sub(self.bytes, name_start, name_end)

  return string.gsub(name_bytes, '%z.*', '')
end

function IffFileParser:get_renoise_sample_value(index)
  local body_chunk_info = self:find_body_chunk_info()
  local start_byte_number = body_chunk_info.start_byte_number + ID_AND_LENGTH_NB_BYTES

  local signed_char =  self:_read_signed_char(start_byte_number + index - 1)

  return signed_char/128
end

function IffFileParser:get_loop_start_frame()
  local vhdr_chunk_info = self:get_vhdr_chunk_info()

  if vhdr_chunk_info.repeat_high_samples == 0 or
     vhdr_chunk_info.one_shot_high_samples == 0 then
    return nil
  end

  return vhdr_chunk_info.one_shot_high_samples + 1
end

function IffFileParser:_find_first_known_chunk()
  local start = string.find(self.bytes, 'VHDR')
  return start
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
