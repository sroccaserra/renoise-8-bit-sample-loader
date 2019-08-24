Tentative Renoise tool to load 8 bit samples from the Amiga era (IFF and RAW 8 bit signed mono PCM only).

`/!\` Warning: this is unusable at the moment, I am not sure I have the time or
skills to finish this. If you whish to help, please make a pull request.

If you wonder what a sample from the Amiga era is, you can look here:

- <https://www.youtube.com/watch?v=t5G3-qG76ho>
- <https://www.youtube.com/watch?v=LWMcENSpB1A>
- <https://archive.org/details/AmigaSTXX>

See also:

- <https://forum.renoise.com/t/the-original-amiga-soundtracker-sample-disks/39473/22>
- <https://gist.github.com/sroccaserra/5bacbdb3e000a54dbae0972c346021d4>

## TODO

There is still a little work to do to load an IFF file:

```
- [X] Learn how to script Renoise for dummies
- [X] Parse the FORM chunk
- [X] Warn for unsupported file types and quit
- [X] Setup test environment for a quicker feedback
- [X] Parse sample rate info from the VHDR chunk
- [X] Find the BODY chunk
- [-] Load the BODY chunk data to the current sample <-- If I can do that, the project will be ok. If not I'll need some help.
- [ ] Parse loop info from the VHDR chunk
- [ ] Set the loop start in the current sample
- [ ] Deal with variable chunk order (or check that the VHDR chunk always starts at byte 13)
```

Then maybe:

```
- [ ] Allow to load a RAW file
- [ ] Allow to select sample rate for RAW files
- [ ] Support many octaves from IFF files (add slices in Renoise?)
```

## Running the Lua tests

Requirements: have docker installed, and having built the docker image. Run
`make build` to build the docker image.

Since I got tired of editing / reloading the tools in Renoise / running the
tools in Renoise to see the result, I wrote automated tests to have faster
feedback while working.

Run the tests:

```
$ make test
```

Note: the tests use [Busted](https://olivinelabs.com/busted/).

## References

About Renoise:

- <https://renoise.com>

About Renoise script development:

- <https://github.com/renoise/xrnx>
- <https://files.renoise.com/xrnx/documentation/>
- <https://files.renoise.com/xrnx/documentation/Renoise.Song.API.lua.html#h2_97>

About Lua and Luajit:

- <https://www.lua.org/pil/contents.html>
- <http://bitop.luajit.org/api.html>
- <https://olivinelabs.com/busted/>

About the IFF sound file format:

- <https://wiki.amigaos.net/wiki/IFF_Standard>
- <https://wiki.amigaos.net/wiki/8SVX_IFF_8-Bit_Sampled_Voice>
