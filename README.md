Tentative Renoise tool to load 8 bit samples from the Amiga era (IFF and RAW 8 bit signed mono PCM only).

Loading the sample data looks alright, reviews and some tests are welcome :)

If you wonder what a sample from the Amiga era is, you can look here:

- <https://www.youtube.com/watch?v=t5G3-qG76ho>
- <https://www.youtube.com/watch?v=LWMcENSpB1A>
- <https://archive.org/details/AmigaSTXX>

See also:

- <https://gist.github.com/sroccaserra/5bacbdb3e000a54dbae0972c346021d4>
- <https://forum.renoise.com/t/the-original-amiga-soundtracker-sample-disks/39473/22>
- <https://forum.renoise.com/t/tool-to-load-8-bit-samples-from-the-amiga-era-iff-and-raw-8-bit-signed-mono-pcm-only/58002>

## Installation

Tested with:

- Renoise 3.2

See [this branch](https://github.com/sroccaserra/renoise-8-bit-sample-loader/tree/renoise-3-1-1) for a version tested with Renoise 3.1.1.

Download or clone this repository's content, then drag and drop the
`github.sroccaserra.8BitSampleLoader.xrnx` folder on Renoise.

Note: the `github.sroccaserra.8BitSampleLoader.xrnx` folder is in the `src`
folder.

## How to use

After installation, this tool adds a _Load IFF or RAW file..._ menu entry to
the _Tools_ menu.

Clicking on it opens a file browser. Selecting an IFF or RAW 8 bit signed mono
file will load it in the current instrument's current sample.

For IFF files: sample rate, loop start info, and sample name are used if
present. Octaves and compression are not supported (maybe a nice addition).

For RAW files: a sample rate of 16726 Hz is assumed (allow to customize this
would be a nice addition).

Tip: try turning off interpolation in the sample options for that extra 8 bit
noise. After that you can try a ~ 7 kHz low pass filter to tame some of it.

## Docs, learnings and decisions

You can learn more about this project's learnings and decisions in the
[doc](doc) folder.

## TODO

```
- [X] Learn how to script Renoise for dummies
- [X] Parse the FORM chunk
- [X] Warn for unsupported file types and quit
- [X] Setup test environment for a quicker feedback
- [X] Parse sample rate info from the VHDR chunk
- [X] Find the BODY chunk
- [X] Load the BODY chunk data to the current sample <-- If I can do that, the
  project will be ok. If not I'll need some help.
- [X] Allow to load a RAW file
- [X] Parse loop info from the VHDR chunk
- [X] Set the loop start in the current sample
- [X] Deal with variable chunk order (or check that the VHDR chunk always
  starts at byte 13) - short answer: it doesn't :(
- [X] Deal with BODY only files (no sample rate or looping info)
- [ ] Deal with late IFF headers
- [ ] Check the signed char [-128, 127] to Lua [-1, 1] float conversion. How
  can it be right ?
- [ ] More checks!
- [ ] More error messages!
```

Then maybe:

```
- [ ] Add a right-click option to load the file from the disk browser panel
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
- <https://files.renoise.com/xrnx/documentation/Renoise.ScriptingTool.API.lua.html>

About Lua and Luajit:

- <https://www.lua.org/pil/contents.html>
- <http://bitop.luajit.org/api.html>
- <https://olivinelabs.com/busted/>

About the IFF sound file format:

- <https://wiki.amigaos.net/wiki/IFF_Standard>
- <https://wiki.amigaos.net/wiki/8SVX_IFF_8-Bit_Sampled_Voice>
- <https://www.exotica.org.uk/wiki/Format_and_Replays>
- <http://lclevy.free.fr/amiga/formats.html>
