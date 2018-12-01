---
Title: The Big Busk
Author: Richard Mavis
Blurb: Not the big bust.
Tags:
    - music
    - design
    - development
    - php
Date posted: 20140731
Date updated: 20150203
Live: true
Index: true
TOC: true
...



# The Big Busk

I started [The Big Busk][tbb] mostly as a bet. A friend and I were wandering [Last Thursday][lt], which started as an art walk similar to the First Thursday event in downtown Portland but has evolved into something more like a gigantic street fair. Imagine dozens and dozens of bands, jugglers, stilt walkers, hula hoopers, curbside acrobats, and sundry synchronized hippie demonstrations scattered over fifteen blocks with thousands of people of every age wandering like water all around them. At the time I was living in downtown and I wanted to bring a little of that down there with me. So I told my friend we should organize a street music event. He told me good luck. Six weeks later we had our first Big Busk.

<div class="img-block">
  <img class="blockimg" src="/images/the-big-busk/100_6138.jpg" alt="Gone Fishin'" />
  <img class="blockimg" src="/images/the-big-busk/100_6256.jpg" alt="Pieco$t" />
  <img class="blockimg" src="/images/the-big-busk/DSCF1209.jpg" alt="" />
</div>

It's been fun. After the first Busk, [Charley McGowan][char] and [DaiN][dain], both of whom played, offered to help and both have been involved since. In 2010 about 35 acts played and we started having an afterparty where performers could meet, drink, share stories, and listen to each other perform plugged in. In 2011 we hosted [Thoth][]. In 2012 we had our first afterparty downtown, at Backspace. And we took 2013 off. But we resumed the show in 2014.

<div class="img-block">
  <img class="blockimg" src="/images/the-big-busk/100_6196.jpg" alt="The Non" />
  <img class="blockimg" src="/images/the-big-busk/IMG_1874.jpg" alt="Thoth" />
  <img class="blockimg" src="/images/the-big-busk/IMG_1855.jpg" alt="" />
</div>


<a name="the-tech"></a>
## The Tech

In addition to the main site I built an admin/scheduling tool. Scheduling the Busk is a matter of arranging one-hour time slots for many bands over many locations over an eight or nine hour period. The admin tool allows us to do that much more handily than the cardboard box + tourism map + color-coded pins that I had been using.

<div class="img-block">
  <img class="blockimg" src="/images/the-big-busk/admin-1.png" alt="Entering and editing bands" />
  <p class="image-caption">Entering and editing bands.</p>
</div>

The system is a one-page web app. All edits occur immediately (onblur, etc) and there's a little notification area that explains what the system is doing, such as pushing data or fetching the schedule.

<div class="img-block">
  <img class="blockimg" src="/images/the-big-busk/admin-3.png" alt="Schedule view: bands by time at location" />
  <p class="image-caption">Scheduling bands per hour at a location.</p>
</div>

The schedule's determining aspect is on top, beneath the header&mdash;in this case, the location. The location shown is part of a dropdown.

<div class="img-block"><img class="blockimg" src="/images/the-big-busk/admin-4.png" alt="Schedule view: determining aspect dropdown" /></div>

You can click the location, select a different one, and the selected bands will change to suit.

<div class="img-block"><img class="blockimg" src="/images/the-big-busk/admin-5.png" alt="Schedule view: updated bands to new location" /></div>

And if you click an hour, the locations and hours will switch positions&mdash;the hours will replace the locations as the schedule's determining aspect.

<div class="img-block">
  <img class="blockimg" src="/images/the-big-busk/admin-6.png" alt="Schedule view: select an hour" />
  <img class="blockimg" src="/images/the-big-busk/admin-7.png" alt="Schedule view: updated bands to new hour" />
</div>

To save myself even more time I had the system generate unique sign-up URLs per band. I could send the band that URL and they could edit their information and schedule themselves wherever and whenever they wanted.

<div class="img-block"><img class="blockimg" src="/images/the-big-busk/admin-8.png" alt="Band self-signup page" /></div>

Clicking a **+** runs a conflict check and, if that passes, schedules a band to that slot and fills in their name. And clicking their name cancels that appearance.

Near the day of the show I'll make the schedule live on the site. Interested attendees can order the schedule, as we could in the admin system, by location, time, or band. Every component of the schedule is clickable for them, too: selecting a band shows where they're playing when, selecting an hour shows who's playing where at that hour, etc. There's also a Google map.

And the day of the show is a lot of fun.




[tbb]: http://thebigbusk.info/
[lt]: https://www.facebook.com/lastthursdayonalberta
[char]: http://instagram.com/charleydrums
[dain]: http://dain.bandcamp.com/
[Thoth]: https://en.wikipedia.org/wiki/S._K._Thoth
