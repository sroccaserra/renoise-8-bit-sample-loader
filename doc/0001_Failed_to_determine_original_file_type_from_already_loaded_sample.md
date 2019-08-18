This doesn't work. The sample buffer doesn't have the original 8 bit data it seems?

```lua
function remove_iff_header_from_selected_sample_buffer()
  local sample = renoise.song().selected_sample
  if not sample then
    renoise.app():show_message('Please select a sample.')
    return
  end

  renoise.app():show_status('Sample '..sample.name..' selected.')

  local buffer = sample.sample_buffer
  if not buffer then
    renoise.app():show_status('Buffer not loaded.')
    return
  end

  local first_byte = buffer:sample_data(renoise.SampleBuffer.CHANNEL_LEFT, 1)
  renoise.app():show_status('First byte loaded.')
  renoise.app():show_status('First byte: '..first_byte)
end
```
