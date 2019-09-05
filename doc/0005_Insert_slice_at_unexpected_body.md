Status
------

Amends [3. Decide to be flaky in 8SVX file
detection](0003_Decide_to_be_flaky_in_8SVX_file_detection.md)

Context
-------

Some raw files contains an unexpected BODY chunk. ST-29/xen-megablast and
ST-29/xen-we... are two examples.

These unexpected chunks probably result in hasty sample slice and paste,
capturing parts of headers in the operation.

In the examples above, we can see the `lyzer V1.1` string, indicating that they
probably are parts of [a David Whittaker
song](https://www.exotica.org.uk/wiki/Xenon_2_-_Megablast) loaded, sliced and
saved in Oktalyzer V1.1, then later pasted together while letting part of the
header between samples.

Decision
--------

When a BODY chunk is found in a raw file, the tool will signal it to the user
and ask if he wants to insert a slice marker at that position.

Consequences
------------

The user will be able to visualize the position of the unexpected BODY marker,
and decide what to do with it.
