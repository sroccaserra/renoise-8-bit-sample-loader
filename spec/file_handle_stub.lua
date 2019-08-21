local conv = require 'spec.byte_string_conversions'

FORM_CHUNK = conv.bytes_from_hex('464f524d'..  -- 'FORM'
                                 '0000270a'..  -- chunk length after this ulong (the file size minus 8)
                                 '38535658')   -- '8SVX'
VHDR_CHUNK = conv.bytes_from_hex('56484452'..  -- 'VHDR'
                                 '00000014'..  -- chunk length after this ulong
                                 '00000628'..  -- oneShotHiSamples
                                 '00001ee8'..  -- repeatHiSamples
                                 '00000020'..  -- samplesPerHiCycle
                                 '4156'..      -- samplesPerSec = data sampling rate
                                 '01'..        -- ctOctave
                                 '00'..        -- sCompression
                                 '00010000')   -- volume (16+16 bits fixed point), 00010000 = 0.1 (maximum in the IFF spec)
NAME_CHUNK = conv.bytes_from_hex('4e414d45'..  -- 'NAME'
                                 '00000018')   -- chunk length
ANNO_CHUNK = conv.bytes_from_hex('414e4e4f'..  -- 'ANNO'
                                 '00000010')   -- chunk length
BODY_CHUNK = conv.bytes_from_hex('424f4459'..  -- 'BODY'
                                 '000026aa')   -- chunk length

local FileHandleStub = {}
FileHandleStub.__index = FileHandleStub

function FileHandleStub:new()
  o = {
    value_index = 1,
    return_values = {
      FORM_CHUNK,
      VHDR_CHUNK,
      NAME_CHUNK,
      ANNO_CHUNK,
      BODY_CHUNK
    }
  }
  setmetatable(o, self)
  return o
end

function FileHandleStub:read()
  local value_index = self.value_index

  self.value_index = self.value_index + 1

  return self.return_values[value_index]
end

return FileHandleStub
