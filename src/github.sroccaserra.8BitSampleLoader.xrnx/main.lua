-- Renoise script

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

  local form_chunk = filehandle:read(12)
  local type_id = string.sub(form_chunk, 1, 4)

  if type_id == 'RIFF' then
    renoise.app():show_message(TOOL_MESSAGES.unsupportedWaveFile)
    return
  end

  if type_id == 'FORM' then
    local file_type = string.sub(form_chunk, 9, 12)
    if file_type == 'AIFF' then
      renoise.app():show_message(TOOL_MESSAGES.unsupportedAiffFile)
      return
    end
    if file_type ~= '8SVX' then
      renoise.app():show_message(TOOL_MESSAGES.unsupportedFileType)
      return
    end

    renoise.app():show_status('File type is: '..file_type)
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
