function read_form_chunk_info_from_bytes(bytes)
  local chunk_id = string.sub(bytes, 1, 4)

  local byte_4, byte_3, byte_2, byte_1 = string.byte(bytes, 5, 8)
  local chunk_size = byte_1 + bit.lshift(byte_2, 8) + bit.lshift(byte_3, 16) + bit.lshift(byte_4, 24)

  local file_type_id = string.sub(bytes, 9, 12)

  return {
    chunk_id = chunk_id,
    chunk_size = chunk_size,
    file_type_id = file_type_id
  }
end

function read_vhdr_chunk_info_from_bytes(bytes)
  local chunk_id = string.sub(bytes, 1, 4)

  local byte_4, byte_3, byte_2, byte_1 = string.byte(bytes, 5, 8)
  local chunk_length = byte_1 + bit.lshift(byte_2, 8) + bit.lshift(byte_3, 16) + bit.lshift(byte_4, 24)

  return {
    chunk_id = chunk_id,
    chunk_length = chunk_length
  }
end
