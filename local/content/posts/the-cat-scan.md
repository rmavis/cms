---
Title: The Cat Scan
Blurb: A ruby (script) makes a great gift.
Author: Richard Mavis
Tags:
    - personal
    - development
    - ruby
Date posted: 20170712
Date updated: 20170712
Live: true
Index: true
TOC: true
...



# The Cat Scan

My wife loves cats. She spends a lot of time looking at cats that are up for adoption. A couple years ago she lucked out and found one she was super excited about at the Willamette Humane Society. We drove down to Salem and adopted him that weekend.

<div class="img-block">
  <img class="blockimg" src="/images/the-cat-scan/winston-1.jpg" alt="Winston" />
  <div class="image-caption">Potential names included: Oppenheimer, Water Bear, Judge Dredd. We compromised on Winston.</div>
</div>

He was the best cat either of us had ever met. He was with us a little over two years before kidney disease killed him.

My wife was pretty upset. Plus, the timing was bad---he died a few days before her birthday.

<div class="img-block">
  <img class="blockimg" src="/images/the-cat-scan/winston-2.jpg" alt="Winston in a bag" />
</div>

So for her present I wrote her [a Ruby script][github]. It fetches web pages, reads through them, pulls chunks of information you want, checks that information against values you specify, and emails you any matches.

    There are 3 new items for Oregon Humane Society:

    Name: Baby
    Breed: Snowshoe
    Sex: Male
    Color: Seal Bicolor
    Age: 13 years and 3 months
    Link: https://www.oregonhumane.org/adopt/details/14622

    Name: Houdini
    Breed: Siamese - Mix
    Sex: Male
    Color: Chocolate Point
    Age: 9 years and 2 months
    Link: https://www.oregonhumane.org/adopt/details/85339

    Name: Prince
    Breed: Snowshoe
    Sex: Male
    Color: Seal Bicolor
    Age: 14 years and 2 months
    Link: https://www.oregonhumane.org/adopt/details/201196

And when she's ready to start looking for a new cat, I'll `cron` this script and spare her some tedium.

<div class="img-block">
  <img class="blockimg" src="/images/the-cat-scan/winston-3.jpg" alt="Winston judging my work" />
</div>



[github]: https://github.com/rmavis/site-scan
