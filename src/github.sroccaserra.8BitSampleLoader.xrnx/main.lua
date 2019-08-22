-- Renoise script

local iff_file_parser = require('iff_file_parser')

local IS_DEV_MODE = true

local TOOL_MESSAGES = {
  unsupportedWaveFile = 'You are trying to load a WAVE file, this tool is not able to load it. As Renoise supports WAVE files, please load this file the usual way.',
  unsupportedAiffFile = 'You are trying to load an AIFF file, this tool is not able to load it. As Renoise supports AIFF files, please load this file the usual way.',
  unsupportedFileType = 'The file starts with a FORM chunk, but is not supported.'
}

function tool_show_file_browser()
  local filename = renoise.app():prompt_for_filename_to_read({'*.*'}, 'Choose an 8 bit sample...')

  tool_remove_iff_header(filename)
end

function tool_remove_iff_header(filename)
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

    renoise.app():show_status('File type is: '..form_chunk_info.file_type_id)
  else
    renoise.app():show_status('File type is: RAW (hopefully).')
  end
end

renoise.tool():add_menu_entry {
  name = "Main Menu:Tools:8 bit sample loader:Load...",
  invoke = tool_show_file_browser
}

if IS_DEV_MODE then
  renoise.tool():add_menu_entry {
    name = "Main Menu:Tools:8 bit sample loader:Remove IFF header",
    invoke = tool_remove_iff_header
  }
end
