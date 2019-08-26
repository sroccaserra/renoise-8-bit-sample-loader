-- Renoise script

local FileTypeAnalyzer = require('file_type_analyzer').FileTypeAnalyzer
local IffFileParser = require('iff_file_parser').IffFileParser
local RawFileParser = require('raw_file_parser').RawFileParser

local BIT_DEPTH = 8
local NUM_CHANNELS = 1
local CHANNEL_INDEX = 1
local DEFAULT_SAMPLE_RATE = 16726

local IS_DEV_MODE = false

local TOOL_MESSAGES = {
  unsupportedWaveFile = 'You are trying to load a WAVE file, this tool is not able to load it. As Renoise supports WAVE files, please load this file the usual way.',
  unsupportedAiffFile = 'You are trying to load an AIFF file, this tool is not able to load it. As Renoise supports AIFF files, please load this file the usual way.',
  unsupportedFileType = 'The file starts with a FORM chunk, but is not supported.'
}

---
--
local function insert_sample_from_file_parser(file_parser, default_sample_rate, default_sample_name)
  local sample_rate = file_parser:get_sample_rate() or default_sample_rate
  local nb_frames = file_parser:get_nb_frames()
  local sample_name = file_parser:get_sample_name() or default_sample_name
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

  local loop_start_frame = file_parser:get_loop_start_frame()
  if loop_start_frame then
    selected_sample.loop_mode = renoise.Sample.LOOP_MODE_FORWARD
    selected_sample.loop_start = loop_start_frame
  else
    selected_sample.loop_mode = renoise.Sample.LOOP_MODE_OFF
  end

  selected_sample.name = sample_name
  instrument.name = sample_name
end

---
--
local function load_iff_or_raw_file(filename)
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
    return
  end

  local file_type_analyzer = FileTypeAnalyzer:new(file_bytes)

  if file_type_analyzer:is_wave_file() then
    renoise.app():show_message(TOOL_MESSAGES.unsupportedWaveFile)
    return
  end

  if file_type_analyzer:is_aiff_file() then
    renoise.app():show_message(TOOL_MESSAGES.unsupportedAiffFile)
    return
  end

  if file_type_analyzer:is_iff_file() then
    local iff_file_parser = IffFileParser:new(file_bytes)
    insert_sample_from_file_parser(iff_file_parser, DEFAULT_SAMPLE_RATE, 'IFF sample')
  else
    local raw_file_parser = RawFileParser:new(file_bytes)
    insert_sample_from_file_parser(raw_file_parser, DEFAULT_SAMPLE_RATE, 'RAW sample')
  end
end

---
--
local function tool_show_file_browser()
  local filename = renoise.app():prompt_for_filename_to_read({'*.*'}, 'Choose an 8 bit sample...')

  if not filename then
    return
  end

  load_iff_or_raw_file(filename)
end

---
-- Adding menu entries

if IS_DEV_MODE then
  renoise.tool():add_menu_entry {
    name = "Main Menu:Tools:8 bit sample loader:Load IFF or RAW audio file...",
    invoke = tool_show_file_browser
  }

  renoise.tool():add_menu_entry {
    name = "Main Menu:Tools:8 bit sample loader:Read IFF file",
    invoke = load_iff_or_raw_file
  }

  renoise.tool():add_menu_entry {
    name = "Disk Browser Files:Load IFF or RAW audio file...",
    invoke = tool_show_file_browser
  }
else
  renoise.tool():add_menu_entry {
    name = "Main Menu:Tools:Load IFF or RAW audio file...",
    invoke = tool_show_file_browser
  }
end
