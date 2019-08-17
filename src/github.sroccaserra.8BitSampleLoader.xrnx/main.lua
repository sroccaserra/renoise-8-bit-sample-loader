-- Renoise script

function show_file_browser()
  local filename = renoise.app():prompt_for_filename_to_read({'*.*'}, 'Choose an 8 bit sample...')

  local filehandle = assert(io.open(filename, 'r'))

  local filesignature = filehandle:read(4)

  renoise.app():show_status('File signature is: '..filesignature)
end

renoise.tool():add_menu_entry {
  name = "Main Menu:Tools:8 bit sample loader:Load...",
  invoke = show_file_browser
}

