Note: here I use rg (ripgrep) instead of grep.

## List files with a FORM tag or a 8SVX header or a BODY chunk


```
$ find . -type f -not -name '*.aiff' -not -name '*.wav' -print0 | xargs -0 rg -l --null-data '^FORM' | tr '\0' '\n' | sort
```

```
$ find . -type f -not -name '*.aiff' -not -name '*.wav' -print0 | xargs -0 rg -l --null-data '8SVX' | tr '\0' '\n' | sort
```

```
$ find . -type f -not -name '*.aiff' -not -name '*.wav' -print0 | xargs -0 rg -l --null-data 'BODY\z' | tr '\0' '\n' | sort
```

You can then use `diff` or `git diff --no-index` to list the files that have a 8SVX but no FORM, etc.

```
$ git diff --no-index -U0 logs/8svxvhdr_sorted.log logs/iff_sorted.log
```

## Count files with a FORM prefix by directory

```
$ find . -type f -not -name '*.aiff' -not -name '*.wav' -print0 | xargs -0 rg -l --null-data '^FORM' | tr '\0' '\n' | cut -d'/' -f2 | sort | uniq -c
```

## Find stats about where the 8SVX is in the file

First list them all:

```
$ rg -l --binary --null-data -0 8SVX ST* | xargs -0 -n1 xxd | rg 8SVX > header_positions.log
```

Then sort and count:

```
$ cut -d ':' -f1 header_positions.log | sort | uniq -c | less
```
