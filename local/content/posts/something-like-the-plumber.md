---
Title: Something Like The Plumber
Blurb: Long live pipes.
Author: Richard Mavis
Tags:
    - development
    - linux
Date posted: 2018-06-18
Date updated: 2018-06-24
Live: true
Index: true
TOC: true
...



# Something Like The Plumber

I've never used it directly but the examples I've seen of [Plan 9's plumber][plumberinfo] [in action][plumberdemo] make it seem easy to use and insanely helpful. The internals are a mystery to me but from a UI perspective it looks a lot like a launcher (such as [dmenu][dmenu] or [Quicksilver][qs]) that acts on selected text, and from a conceptual perspective seems a lot like [pipes][pipes]. Basically, you select some text and click some mouse key chord---the selected text gets piped into some set of rules and, if it passes all the checks, gets sent on to some action, which then does whatever you want with it.

So I wrote a little collection of scripts that, together, create functionality that's something like the plumber. It relies on:
- `dmenu` and `xclip`
- a collection of scripts that all receive some text and act on it
- a script that passes the names of those scripts to `dmenu`, gets the wanted one, and calls it, piping the active text selection into it
- some way to launch that piping script (in this case, some [`i3`][i3] configuration)

It's very simple:

<div class="img-block">
  <img class="blockimg" src="/images/something-like-the-plumber/screenshot-plumber.png" alt="i3 plumber screenshot" />
</div>

In this screenshot, the part bordered in blue shows four files:
- top: The `i3` config to call the `plumber-list-scripts` script (enabling you to type the mod key and `p` to execute the given command, thereby making it accessible anywhere during the session)
- middle: The `plumber-list-scripts` script
- bottom left: The directory of `plumber` scripts
- bottom right: The `dictionary` script

The bar in [Acme][acme] colors up on top is `dmenu` rendered with the colors, prompt, etc., specified in the `plumber-list-scripts` script.

And the block beneath the part bordered in blue is the result of calling the `dictionary` script with the highlighted text, in this case the "plumber" highlighted in blue.

I've only tried this in `i3` but it should be more or less trivial to set up in any Linux desktop or window manager.



[plumberinfo]: https://9p.io/wiki/plan9/Using_plumbing/index.html
[plumberdemo]: http://www.mostlymaths.net/2013/04/just-as-mario-using-plan9-plumber.html
[dmenu]: https://tools.suckless.org/dmenu/
[qs]: https://qsapp.com/
[pipes]: http://www.linfo.org/pipes.html
[i3]: https://i3wm.org/
[acme]: http://acme.cat-v.org/
