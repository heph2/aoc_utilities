# AoC Helper
    
A simple Shell Script for speed up my AoC challange.
It provide simple options for download the input of the day,
read the text and submit the answer.

## Disclaimer

It's a very barebones shell script written yesterday night so be kindly.

Later, if i found the time, i'll provide a nix version of this.

## Why

I found a lot of this tools for the same pourpuse, but none of them
was simple enough.. IMHO for this kind of problems, a shell script
is more than enough

## Dependencies

You just need curl and html2text for better rendering html

## Prerequisites

Log-In to [AoC](https://adventofcode.com) and retrieve the cookie session
Open network-tab, make a request clicking the input of some day, and check
for the response Header.
Copy the cookie session and store it in a Environment Var named COOKIE_AOC.
Now you're Ready!

## Usage

The basic usage is passing the year, day and an action to do.
For retrieve the input of the 4th day of 2019

```
aoc -y 2019 -d 4 -i
```

For read the text

```
aoc -y 2019 -d 4 -r
```

And for submit an answer

```
aoc -y 2019 -d 4 -s
```

This will ask the user which part of the problems want to submit, and
the answer.

## Contributing

That's not Github! NO PR or Issues. If you want to contribute, send me
a patch to srht@mrkeebs.eu.
Did you know of https://git-scm.com/docs/git-send-email

If you're not familiar with those tools, there's also a mirror of this repo
on [SourceHut](https://git.sr.ht/~heph/aoc_utilities)

## Licence

GNU Affero General Public License
