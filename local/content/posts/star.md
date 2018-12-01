---
Title: STAR
Author: Richard Mavis
Blurb: Simple Text Archiving and Retrieving.
Tags:
    - development
    - ruby
Date posted: 2014-06-28
Date updated: 2016-11-30
Live: true
Index: true
TOC: true
...



# STAR

STAR stands for Simple Text Archiving and Retrieving. There are two versions: an [old one written in Ruby][gh], and [a new one written in Go][gogh]. Their `readme`s are below.



## In Go

`star` is a simple tool for saving and retrieving bits of text. You could use it to save bookmarks, hard-to-remember commands, complex emoticons, stuff like that.


### Usage

I use `star` for all sorts of things.

    $ star music listen
    1) https://www.youtube.com/watch?v=Aloryfd5ipw
       analord, aphex twin, listen, music, music, afx
    2) http://modernarecords.com/releases
       label, listen, music, contemporary classical
    3) https://soundcloud.com/terryurban/sets/fka-biggie
       listen, music, terry urban, fka biggie
    4) http://prefuse73.bandcamp.com/album/travels-in-constants-vol-25
       music, prefuse 73, temporary residence, travels in constants, listen

    $ star book readme
    1) http://www.squeakland.org/resources/books/readingList.jsp
       alan kay, books, readme, syllabus
    2) http://www.gigamonkeys.com/book/
       Practical Common Lisp, readme, lisp
    3) https://tachyonpublications.com/product/central-station/
       books, readme, scifi
    4) https://en.wikipedia.org/wiki/The_World_as_Will_and_Representation
       books, philosophy, readme, schopenhauer
    5) http://www.goodreads.com/book/show/18877915-the-lonely-astronaut-on-christmas-eve
       blink-182, readme, space

    $ star emoticon
    1) ¯\_(ツ)_/¯
       emoticon, shrug
    2) (╯°□°）╯︵ ┻━┻
       emoticon, fliptable
    3) ⊙︿⊙
       bugeye, emoticon
    4) (╯︵╰,)
       emoticon, sadcry
    5) (*￣з￣)
       emoticon, kissing

Never [let your friends down][xkcd-tar] again!

    $ star unix tar
    1) tar -czvf DIR
       unix, tar, zip
    2) tar -tzvf DIR.tar.gz
       unix, tar, list
    3) tar -xzvf DIR.tar.gz
       unix, tar, unzip

That's the "Retrieving" part of `star`. Depending on your config (or command line flags) you can then pipe the string on the numbered line to `pbcopy`, `open`, or any other external tool you like.

The "Archiving" part is done like this:

    $ star -n value tag tag tag

So this:

    $ star -n "tar -czvf DIR" unix tar zip

will create a new record in the store file. `star` stores records in a plain text file, by default at `~/.config/star/store` but that's configurable via the config file at `~/.config/star/config.yaml`.

You can edit records via a temp file in your `$EDITOR`:

    $ star -e unix tar
    1) tar -czvf DIR
       unix, tar, zip
    2) tar -tzvf DIR.tar.gz
       unix, tar, list
    3) tar -xzvf DIR.tar.gz
       unix, tar, unzip
    Edit these records: 1 3

Deleting records is also easy:

    $ star -d todo
    1) shave
       todo, today
    2) shower
       todo, today
    3) wash dishes
       todo, today
    Delete these records: all

So essentially `star` saves, interfaces with, and acts on text snippets that it stores in a plain text file.



### Installation

This version of `star` is written in Go. In `bin/` there are compiled executables for every combination of `[linux darwin windows]` and `[amd64 386]` in the format `star_[os]-[arch]`. So to install you could just download the executable you need, put it somewhere useful, and create a symlink somewhere in your `$PATH`:

    $ cd wherever/you/keep/programs
    $ curl -O https://github.com/rmavis/go-STAR/raw/master/bin/star_[os]-[arch]
    $ ln -s [executable] /usr/local/bin/star

Or you can clone the repo and build it yourself. If you have a working Go setup, it's very easy:

    $ cd $GOPATH/src/where/ever
    $ git clone https://github.com/rmavis/go-STAR.git
    $ go get gopkg.in/yaml.v2  # This is star's only dependency.
    $ go install

There's also [a version written in Ruby][star-ruby], if you're into that. They're similar but I recommend this one---it's faster and has better browsing options.



[gogh]: https://github.com/rmavis/go-STAR
[star-ruby]: https://github.com/rmavis/star
[xkcd-tar]: https://xkcd.com/1168/





## In Ruby

`star` is a simple tool for saving and retrieving bits of text. You could use it to save bookmarks, hard-to-remember commands, complex emoticons, stuff like that. It's similar to the excellent [boom][] by [Zach Holman][zh] but suits me better.

I wanted:

- to store a large variety of things
- to classify those things with tags
- to store those things and their tags in a plain text file

I did not want:

- to need to remember specific keys associated with specific values in order to get to the things that I had saved
- to need to install a collection of Ruby gems that I might never use otherwise
- to need to deal with the associated problems with gem versions, etc.

So I wrote `star`. I use it every day.

So say you want to find some music. You type:

    $ star music

Which returns:

    1) http://adambryanbaumwiltzie.bandcamp.com/
       Tags: Adam Wiltzie, listen, music
    2) http://screws.nilsfrahm.com/
       Tags: Nils Frahm, Screws, music
    3) https://soundcloud.com/deadbeat
       Tags: Deadbeat, dub techno, music
    4) https://soundcloud.com/modernlove/sets/andy-stott-luxury-problems-1
       Tags: Andy Stott, Luxury Problems, music
    5) https://soundcloud.com/user18081971
       Tags: aphex twin, listen, music
    0) None.
    ?: 

Or say you're working with a MySQL database:

    $ star mysql
    1) alter table `TABLE` add [primary] key (`COLUMN`);
       Tags: add key, mysql
    2) alter table `TABLE` add `COLUMN-NAME` TYPE(LENGTH) default 'DEFAULT-VALUE' not null after `AFTER-THIS-COLUMN`;
       Tags: add column, mysql
    3) alter table `TABLE` change `OLD-NAME` `NEW-NAME` TYPE(LENGTH);
       Tags: change column, mysql
    4) alter table `TABLE` drop column `COLUMN`;
       Tags: drop column, mysql
    5) create table `TABLE` (`COLUMN` TYPE(LENGTH) not null auto_increment [, MORE COLUMNS...], primary key (`id`));
       Tags: create a table, mysql
    0) None.
    ?: 

You type the number of the line you want and the script pipes the text on that line to `pbcopy`, thereby copying it to your clipboard.

You can add new entries with something like:

    $ star -n clipboard utility "OS X" Flycut https://github.com/TermiT/Flycut/

You can delete entries by using the `-d` option, and you can edit, add, or delete entries in your `$EDITOR` with `-e`.

Your data is stored in plain text in a file, by default at `~/.config/star/store` but you can change that by specifying a different filename in the config file at `~/.config/star/config.yaml`.

So if you're interested, it's [on github][gh]. Clone the repo and run the demo:

    $ ruby star.rb --demo

And if you like it and decide to keep it, installation is as easy as putting it somewhere safe, `chmod`ing the `star.rb` file executable, and creating a link to it in some directory in your `PATH`, like:

    $ sudo ln -s where/ever/it/is/star.rb /usr/local/bin/star





[zh]: http://zachholman.com/
[boom]: http://zachholman.com/boom/
[gh]: https://github.com/rmavis/star
