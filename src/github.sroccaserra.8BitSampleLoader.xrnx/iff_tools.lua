local FORM_CHUNK_NB_BYTES = 12
local VHDR_CHUNK_NB_BYTES = 28

local function _read_iff_chunk_id(bytes)
  return string.sub(bytes, 1, 4)
end

local function _read_uword(bytes, start)
  local byte_2, byte_1 = string.byte(bytes, start, start + 1)
  return byte_1 +
         bit.lshift(byte_2, 8)
end

local function _read_ulong(bytes, start)
  local byte_4, byte_3, byte_2, byte_1 = string.byte(bytes, start, start + 3)
  return byte_1 +
         bit.lshift(byte_2, 8) +
         bit.lshift(byte_3, 16) +
         bit.lshift(byte_4, 24)
end

local function _read_iff_chunk_length(bytes)
  return _read_ulong(bytes, 5)
end

local function read_form_chunk_info_from_bytes(bytes)
  local file_type_id = string.sub(bytes, 9, 12)

  return {
    chunk_id = _read_iff_chunk_id(bytes),
    chunk_length = _read_iff_chunk_length(bytes),
    file_type_id = file_type_id
  }
end

local function read_vhdr_chunk_info_from_bytes(bytes)
  return {
    chunk_id = _read_iff_chunk_id(bytes),
    chunk_length = _read_iff_chunk_length(bytes),
    sample_rate = _read_uword(bytes, 21)
  }
end

local function read_iff_chunks(file_handle)
  local form_chunk_bytes = file_handle:read(FORM_CHUNK_NB_BYTES)
  local vhdr_chunk_bytes = file_handle:read(VHDR_CHUNK_NB_BYTES)

  return {
    form_chunk_info = read_form_chunk_info_from_bytes(form_chunk_bytes),
    vhdr_chunk_info = read_vhdr_chunk_info_from_bytes(vhdr_chunk_bytes)
  }
end

return {
  read_iff_chunks = read_iff_chunks,
  read_form_chunk_info_from_bytes = read_form_chunk_info_from_bytes,
  read_vhdr_chunk_info_from_bytes = read_vhdr_chunk_info_from_bytes
}
