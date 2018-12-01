---
Title: MasterPlans
Author: Richard Mavis
Blurb: Not just a business plan.
Tags:
    - work
    - development
    - design
    - php
    - ruby
Date posted: 2014-07-01
Date updated: 2015-02-03
Live: true
Index: true
TOC: true
...



# MasterPlans

In early February 2008 Bryan Howe, founder and CEO of Sente, Inc., DBA [MasterPlans][mp], hired me to build internal and client projects as part of what was intended to be a creative division of the company that would do mostly marketing work for small businesses. And we did that for a while. I remade our site four or five times, remade [our other site][bp] a few times, built a custom blogging platform, made a lot of small client sites, laid out a few business plans in InDesign, etc. And then the recession hit, which changed things.


## MAPS 

The sales team was using SalesForce. Bryan wanted to move away from that so he asked me to build a replacement. He wanted the information from the various contact forms on our site to be handled differently, to have the ability to weigh those leads differently, to assign them to salespeople semi-randomly based on those weights, and to be able to track how different salespeople handled leads of different weights, among other things.

So I built that system. Bryan could log in, adjust the various form weights and distribution percentages. Sales staff could log in, view and claim leads from their haystack and work their alchemy of converting those leads to gold. They could pass leads around to each other, rank them according to their likeliness of buying, send them promotional materials, proposals, contracts. There was a section that listed two-week old leads, reminding sales to follow up with them. There was a section where Bryan could view various analytics. And it was good.

But there was a problem. Production staff was using Basecamp to manage their projects. So after closing a lead, sales would hand over the client's information to the project manager. Sometimes they would enter the name or email address or contract value or plan level incorrectly and sometimes they would find that it had been incorrect all along. And there was always the duplication of effort of re-entering information. There was also the frustration of being unable to cull certain analytics. So Bryan asked me to extend the system, to add project management capabilities to our CRM so we could stop using Basecamp.

So I did that next. After sales closed a lead, and after billing billed them, the new client information would appear on the project manager's dashboard. They would contact the client, schedule calls, keep notes, create milestones, divvy the project tasks to the production staff. Production staff would see the due dates for their tasks and milestones spread over the month's calendar. They could make notes on tasks, which everyone attached to that milestone could see, etc.

And now the whole company uses this tool, which we call MAPS. There are distinct views and permission levels for reception, sales, production, management, and myself. And there are other components, like a dropbox to anonymously pass comments to management, a book club, a forum. I take feature suggestions and add or edit whatever people want. Over the years the system has both grown quite a lot and become quite well tailored to how we work.

It has also become a nightmare to maintain&mdash;all the classic frustrations that result from piling components and features onto a system that started with a master plan much smaller than it ended up needing. Also, it's ugly.

<div class="img-block"><img class="blockimg" src="/images/masterplans/MAPS-old.png" alt="MAPS v1" /></div>


## MAPS v2

So I decided to rewrite it. The new system could be designed with the full scope of its feature set in mind. From the start I could approach the interface design knowing what the various teams wanted from their tools, and the database design knowing how information moves through it, and the client-server interaction in whatever way fit best.

I wrote the first version of MAPS in PHP because I knew PHP, I knew I could write it pretty quickly and I knew that it would be easy to set up on the server. I wrote the second version in Ruby because I wanted to learn Ruby and about what was involved with using Ruby for a web project. And instead of using Ruby On Rails I decided to build what I needed right on Rack. I learned a lot in the process.

When it came to designing the interface, I decided a few things right away:

- There would be no system-default buttons, dropdowns, checkboxes, etc.
- There would be icons only where language would be ugly or inconvenient.
- Everything that should be clickable would be and data edits would occur in-line, automatically, and be reflected everywhere they should be.

I took inspiration from tiling window managers, the [Herzog & de Meuron][hdm] website, [Xiki][xiki], [Experimental Jetset][exj], [Jesse Grosjean][hb], and I wrote nearly everything myself except for a few Javascript functions for scrolling. And so far I'm happy with the results. I think everybody is.

<div class="img-block"><img class="blockimg" src="/images/masterplans/MAPS-new.png" alt="MAPS v1" /></div>

I also wrote a [manual][howto].




[mp]: http://www.masterplans.com/
[bp]: http://www.businessplan.com/
[hdm]: http://www.herzogdemeuron.com/
[xiki]: http://xiki.org/
[exj]: http://www.experimentaljetset.nl/
[hb]: http://www.hogbaysoftware.com/
[howto]: http://maps.masterplans.com/how-to
