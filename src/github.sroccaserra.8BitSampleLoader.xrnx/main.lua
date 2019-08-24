-- Renoise script

local IffFileParser = require('iff_file_parser').IffFileParser

local BIT_DEPTH = 8
local NUM_CHANNELS = 1
local CHANNEL_INDEX = 1

local IS_DEV_MODE = false

local TOOL_MESSAGES = {
  unsupportedWaveFile = 'You are trying to load a WAVE file, this tool is not able to load it. As Renoise supports WAVE files, please load this file the usual way.',
  unsupportedAiffFile = 'You are trying to load an AIFF file, this tool is not able to load it. As Renoise supports AIFF files, please load this file the usual way.',
  unsupportedFileType = 'The file starts with a FORM chunk, but is not supported.'
}

local function insert_sample_from_iff_data(file_parser)
  local sample_rate = file_parser:get_sample_rate()
  local nb_frames = file_parser:get_nb_frames()
  local sample_name = file_parser:get_sample_name() or 'IFF sample'
  local instrument = renoise.song().selected_instrument

  local selected_sample = renoise.song().selected_sample

  if not selected_sample then
    selected_sample = instrument:insert_sample_at(1)
  end

  local sample_buffer = selected_sample.sample_buffer

  local status = sample_buffer:create_sample_data(sample_rate, BIT_DEPTH, NUM_CHANNELS, nb_frames)
  if not status then
    error('Error: Allocation failed.')
  end

  sample_buffer:prepare_sample_data_changes()

  for i = 1,nb_frames do
    local sample_value = file_parser:get_renoise_sample_value(i)
    sample_buffer:set_sample_data(CHANNEL_INDEX, i, sample_value)
  end

  sample_buffer:finalize_sample_data_changes()

  selected_sample.name = sample_name
  instrument.name = sample_name
end

local function read_iff_file(filename)
  if IS_DEV_MODE then
    filename = filename or '/Users/sebastien.roccaserra/Music/Amiga/ST-XX_with_conversion/ST-01/strings6'
  end

  local filehandle, err = io.open(filename, 'r')
  if not filehandle then
    renoise.app():show_message('File '..filename..' not found.')
    if err then
      print(err)
    end
    return
  end

  local file_bytes, err = filehandle:read('*all')
  if not file_bytes then
    renoise.app():show_message('Error while reading file '..filename)
    if err then
      print(err)
    end
  end

  local iff_file_parser = IffFileParser:new(file_bytes)
  local form_chunk_info = iff_file_parser:get_form_chunk_info()

  if form_chunk_info.chunk_id == 'RIFF' then
    renoise.app():show_message(TOOL_MESSAGES.unsupportedWaveFile)
    return
  end

  if form_chunk_info.chunk_id == 'FORM' then
    if form_chunk_info.file_type_id == 'AIFF' then
      renoise.app():show_message(TOOL_MESSAGES.unsupportedAiffFile)
      return
    end
    if form_chunk_info.file_type_id ~= '8SVX' then
      renoise.app():show_message(TOOL_MESSAGES.unsupportedFileType)
      return
    end

    insert_sample_from_iff_data(iff_file_parser)
  else
    renoise.app():show_status('File type is: RAW (hopefully).')
  end
end

local function tool_show_file_browser()
  local filename = renoise.app():prompt_for_filename_to_read({'*.*'}, 'Choose an 8 bit sample...')

  read_iff_file(filename)
end

renoise.tool():add_menu_entry {
  name = "Main Menu:Tools:8 bit sample loader:Load IFF audio file...",
  invoke = tool_show_file_browser
}

if IS_DEV_MODE then
  renoise.tool():add_menu_entry {
    name = "Main Menu:Tools:8 bit sample loader:Read IFF file",
    invoke = read_iff_file
  }
end
