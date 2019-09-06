local bytes_from_hex = require('spec.byte_string_conversions').bytes_from_hex

---
-- IFF file bytes

local FORM_CHUNK = bytes_from_hex('464f524d'..  -- 'FORM'
                                  '0000003c'..  -- 60, chunk length after this ulong (the file size minus 8)
                                  '38535658')   -- '8SVX'
local VHDR_CHUNK = bytes_from_hex('56484452'..  -- 'VHDR'
                                  '00000014'..  -- chunk length after this ulong
                                  '00000628'..  -- oneShotHiSamples
                                  '00001ee8'..  -- repeatHiSamples
                                  '00000020'..  -- samplesPerHiCycle
                                  '4156'..      -- 16726, samplesPerSec = data sampling rate
                                  '01'..        -- ctOctave
                                  '00'..        -- sCompression
                                  '00010000')   -- volume (16+16 bits fixed point), 00010000 = 1.0 (maximum in the IFF spec)
local NAME_CHUNK = bytes_from_hex('4e414d45'..  -- 'NAME'
                                  '00000018'..  -- 24, chunk length
                                  '73742d30313a737472696e67733600000000000000000000')
local ANNO_CHUNK = bytes_from_hex('414e4e4f'..  -- 'ANNO'
                                  '00000010'..  -- 16, chunk length
                                  '50726f547261636b657220322e334100')
local BODY_CHUNK = bytes_from_hex('424f4459'..  -- 'BODY'
                                  '00000004')   -- chunk length

local SAMPLE_BYTES = bytes_from_hex('007f80ff') -- 8 bit two's complement representing 0, 127, -128, -1
local SAMPLE_DATA_512_BYTES = string.rep('\xde\xad\xbe\xef', 128)

local IFF_FILE_BYTES = FORM_CHUNK..VHDR_CHUNK..NAME_CHUNK..ANNO_CHUNK..BODY_CHUNK..SAMPLE_BYTES

local IFF_FILE_WITH_EMPTY_BODY = FORM_CHUNK..VHDR_CHUNK..bytes_from_hex('424f445900000000')
local IFF_FILE_WITHOUT_NAME = FORM_CHUNK..VHDR_CHUNK..BODY_CHUNK..SAMPLE_BYTES
local IFF_FILE_WITH_TRUNCATED_SAMPLE_DATA = FORM_CHUNK..VHDR_CHUNK..bytes_from_hex('424f445900000005')..SAMPLE_BYTES
local IFF_FILE_WITH_VHDR_IN_UNUSUAL_POSITION = VHDR_CHUNK..BODY_CHUNK..SAMPLE_BYTES

local IFF_FILE_WITHOUT_FORM_CHUNK = VHDR_CHUNK..BODY_CHUNK..SAMPLE_BYTES
local IFF_FILE_WITHOUT_VHDR_CHUNK = BODY_CHUNK..SAMPLE_BYTES
local IFF_FILE_WITHOUT_BODY_CHUNK = VHDR_CHUNK..SAMPLE_BYTES

local FILE_WITH_LATE_BODY = SAMPLE_DATA_512_BYTES..BODY_CHUNK..SAMPLE_BYTES

local BYTES_WITHOUT_BODY_CHUNK = FORM_CHUNK..VHDR_CHUNK..NAME_CHUNK..ANNO_CHUNK

---
-- Typical AIFF file first bytes

local AIFF_FILE_BYTES = bytes_from_hex('464f524d'..  -- 'FORM'
                                       '00001ea6'..  -- chunk length after this ulong
                                       '41494646')   -- 'AIFF'

---
-- Typical WAVE file first bytes

local WAVE_FILE_BYTES = bytes_from_hex('52494646'..  -- 'RIFF'
                                       'ce260000'..  -- little endian stuff
                                       '57415645')   -- 'WAVE'

return {
  IFF_FILE_BYTES = IFF_FILE_BYTES,
  IFF_FILE_WITH_EMPTY_BODY = IFF_FILE_WITH_EMPTY_BODY,
  IFF_FILE_WITHOUT_NAME = IFF_FILE_WITHOUT_NAME,
  IFF_FILE_WITH_TRUNCATED_SAMPLE_DATA = IFF_FILE_WITH_TRUNCATED_SAMPLE_DATA,
  IFF_FILE_WITH_VHDR_IN_UNUSUAL_POSITION = IFF_FILE_WITH_VHDR_IN_UNUSUAL_POSITION,

  IFF_FILE_WITHOUT_FORM_CHUNK = IFF_FILE_WITHOUT_FORM_CHUNK,
  IFF_FILE_WITHOUT_VHDR_CHUNK = IFF_FILE_WITHOUT_VHDR_CHUNK,
  IFF_FILE_WITHOUT_BODY_CHUNK = IFF_FILE_WITHOUT_BODY_CHUNK,

  FILE_WITH_LATE_BODY = FILE_WITH_LATE_BODY,

  BYTES_WITHOUT_BODY_CHUNK = BYTES_WITHOUT_BODY_CHUNK,
  SAMPLE_BYTES = SAMPLE_BYTES,

  AIFF_FILE_BYTES = AIFF_FILE_BYTES,
  WAVE_FILE_BYTES = WAVE_FILE_BYTES,
}
