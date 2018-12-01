---
Title: The King James in Fire & Flames
Author: Richard Mavis
Blurb: And also in HTML and CSS.
Tags:
    - art
    - development
    - html
    - css
    - ruby
Date posted: 2014-03-13
Date updated: 2015-02-03
Live: true
Index: true
TOC: true
...



# The King James<br />in Fire & Flames

Is the incendiary title of one of [my pieces][tumblr] for [*To All Our Future Flames*][taoff], our final show at [Gigantic][gig]. The theme of the show was matchboxes&mdash;work on, in, or otherwise involving matchboxes.

I'd been reading the [King James Version][kjv] of the Bible (and I still am&mdash;it's a long book) and I became curious about when and where and how often certain words occur. Did you know that "unicorn" occurs nine times?

> Numbers 23:22: God brought them out of Egypt; he hath as it were the strength of an unicorn.

So what I wanted to do was cull each book, chapter, and verse that contained either "fire" or "flame", highlight those words, and print the result. I also wanted to show both how code can be used in creative aims and that code itself can be interesting and fun, or at least moreso than many of the gallery-goers that I've met tend to think of it.

I underestimated the length of the result. Even after removing the line breaks and shrinking the type to 10pt it filled six 11" x 17" sheets. I rolled the pages and stuffed them in the largest matchbox I could find. I also wrapped the box in part of a page. I also printed and added the source code.

<div class="img-block"><img class="blockimg" src="/images/kjv/20130404072.jpg" alt="Rolled and boxed." /></div>

It wasn't very pretty. It looks much better [on screen][html].

And the [ruby script][script] is useful. You can feed it any words you want. You can also add *deuterocanonical* terms that are colored only if they occur in the verses that contain the primary terms. And the result is HTML, so you can style it with CSS and view it in a browser, print a [PDF][], post it to your tumblr, or whatever.




[tumblr]: http://ported.tumblr.com/post/47330736384/to-all-our-future-flames
[taoff]: http://giganticgallery.info/shows/to-all-our-future-flames
[gig]: http://giganticgallery.info
[kjv]: http://www.gutenberg.org/ebooks/10
[html]: /misc/kjv/index.html
[script]: /misc/kjv/KJV.rb
[PDF]: /misc/kjv/KJV.pdf
