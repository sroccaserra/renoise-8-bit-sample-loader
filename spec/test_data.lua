local bytes_from_hex = require('spec.byte_string_conversions').bytes_from_hex

local FORM_CHUNK = bytes_from_hex('464f524d'..  -- 'FORM'
                                  '0000003c'..  -- 60, chunk length after this ulong (the file size minus 8)
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
                                  '00000018'..  -- 24, chunk length
                                  '73742d30313a737472696e67733600000000000000000000')
local ANNO_CHUNK = bytes_from_hex('414e4e4f'..  -- 'ANNO'
                                  '00000010'..  -- 16, chunk length
                                  '50726f547261636b657220322e334100')
local BODY_CHUNK = bytes_from_hex('424f4459'..  -- 'BODY'
                                  '00000004'..  -- chunk length
                                  '41424344')   -- chunk data ('ABCD')

local IFF_FILE_BYTES = FORM_CHUNK..VHDR_CHUNK..NAME_CHUNK..ANNO_CHUNK..BODY_CHUNK
local IFF_FILE_WITH_EMPTY_BODY = FORM_CHUNK..VHDR_CHUNK..bytes_from_hex('424f445900000000')

local BYTES_WITHOUT_BODY_CHUNK = FORM_CHUNK..VHDR_CHUNK..NAME_CHUNK..ANNO_CHUNK

return {
  IFF_FILE_BYTES = IFF_FILE_BYTES,
  IFF_FILE_WITH_EMPTY_BODY = IFF_FILE_WITH_EMPTY_BODY,
  BYTES_WITHOUT_BODY_CHUNK = BYTES_WITHOUT_BODY_CHUNK
}
