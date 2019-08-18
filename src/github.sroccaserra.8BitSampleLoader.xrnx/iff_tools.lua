function read_form_chunk_info_from_bytes(bytes)
  local file_type_id = string.sub(bytes, 9, 12)

  return {
    chunk_id = _read_iff_chunk_id(bytes),
    chunk_length = _read_iff_chunk_length(bytes),
    file_type_id = file_type_id
  }
end

function read_vhdr_chunk_info_from_bytes(bytes)
  return {
    chunk_id = _read_iff_chunk_id(bytes),
    chunk_length = _read_iff_chunk_length(bytes)
  }
end

function _read_iff_chunk_id(bytes)
  return string.sub(bytes, 1, 4)
end

function _read_iff_chunk_length(bytes)
  return _read_ulong(bytes, 5)
end

function _read_ulong(bytes, start)
  local byte_4, byte_3, byte_2, byte_1 = string.byte(bytes, start, start + 3)
  return byte_1 +
         bit.lshift(byte_2, 8) +
         bit.lshift(byte_3, 16) +
         bit.lshift(byte_4, 24)
end
