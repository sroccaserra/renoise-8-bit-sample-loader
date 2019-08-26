Context
-------

Most files in 8SVX format in the ST-XX collection are properly formated (more than 4600). They have a FORM prefix at the beginning of the file, a regular VHDX chunk and BODY chunk.

Some are missing the FORM prefix but still have a VHDR in the first few bytes (around 150)

But around 60 files in the collection have their header data positionned aphazardly (going as far as 35 kB into the file?)

Decision
--------

In order to parse the sound part of some of these files, the 8SVX detection mechanism will be flaky and allow missing FORM prefix and VHDR position up to 512 kB into the file.

The files with VHDR info too far are not super interesting anyway.

Later, files with missing VHDR info but with BODY info could be treated as RAW files.
