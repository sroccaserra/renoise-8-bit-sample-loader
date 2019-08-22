local bytes_from_hex = require('spec.byte_string_conversions').bytes_from_hex

local FORM_CHUNK = bytes_from_hex('464f524d'..  -- 'FORM'
                                  '0000270a'..  -- chunk length after this ulong (the file size minus 8)
                                  '38535658')   -- '8SVX'
local VHDR_CHUNK = bytes_from_hex('56484452'..  -- 'VHDR'
                                  '00000014'..  -- chunk length after this ulong
                                  '00000628'..  -- oneShotHiSamples
                                  '00001ee8'..  -- repeatHiSamples
                                  '00000020'..  -- samplesPerHiCycle
                                  '4156'..      -- samplesPerSec = data sampling rate
                                  '01'..        -- ctOctave
                                  '00'..        -- sCompression
                                  '00010000')   -- volume (16+16 bits fixed point), 00010000 = 0.1 (maximum in the IFF spec)
local NAME_CHUNK = bytes_from_hex('4e414d45'..  -- 'NAME'
                                  '00000018')   -- chunk length
local ANNO_CHUNK = bytes_from_hex('414e4e4f'..  -- 'ANNO'
                                  '00000010')   -- chunk length
local BODY_CHUNK = bytes_from_hex('424f4459'..  -- 'BODY'
                                  '000026aa')   -- chunk length

local IFF_FILE_BYTES = FORM_CHUNK..VHDR_CHUNK..NAME_CHUNK..ANNO_CHUNK..BODY_CHUNK

return {
  IFF_FILE_BYTES = IFF_FILE_BYTES
}
