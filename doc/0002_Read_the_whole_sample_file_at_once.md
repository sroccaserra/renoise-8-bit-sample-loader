Context
-------

My first idea was to read the sample file chunk by chunk, to avoid reading the whole file at once.

But:

- Reading the file chunk by chunk is less simple than reading the file at once (for branching decisions since the order of some chunks is not specified)
- The majority of the file size is the sample data, the header is considerably smaller
- The files to be read are old files, so not really big

So there is nothing to be gained by reading the file chunk by chunk.

Decision
--------

Read the whole file in one go.
