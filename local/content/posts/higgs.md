---
Title: Higgs
Author: Richard Mavis
Blurb: For simple sites.
Tags:
    - design
    - development
    - php
Date posted: 20140731
Date updated: 20150203
Live: true
Index: true
TOC: true
...



# Higgs

Greg Higgins, an artist I met through [Gigantic][gig], wanted to commission me to build a site for him. Having made a few client sites while working for [MasterPlans][mp], I knew he'd want:

- the ability to create and delete pages
- the ability to edit the content on those pages
- the ability to rearrange the order of those pages in the nav bar
- the ability to upload images and swap out his main logo
- the ability to do all these things himself, but also
- the ability to holler at me if he got frustrated

And if I was going to build this for him, I'd want the system to be eminently self-explanatory and insanely easy to use so that he would have no foreseeable reason to get frustrated and holler at me.

So I built Higgs. It's a one-page web app for building a simple site.

<div class="img-block"><img class="blockimg" src="/images/higgs/admin-overview.png" alt="Admin overview." /></div>

The primary goal was of course to make an awesome site-building tool for my client. And the secondary goal was to build a tool that I could easily replicate and repurpose for other people that might want similar.

Greg liked the look of the [Serendipity Wine Rack][swr] site that I built for my friend Jon Rossitto. So the output of the admin system would be pages that looked similar: nav on top, a big header, big images, and text beneath that.

So the admin login is {domain}/admin.

<div class="img-block"><img class="blockimg" src="/images/higgs/admin-login.png" alt="Admin login." /></div>

The page scales down well.

<div class="img-block"><img class="smallblock" src="/images/higgs/admin-login-phone.png" alt="Admin login on small screens." /></div>

The whole system does.

<div class="img-block">
  <img class="blockimg" src="/images/higgs/admin-page.png" alt="Admin page editing on larger screens." />
  <img class="blockimg" src="/images/higgs/admin-menu-phone.png" alt="Admin page menu on small screens." />
  <img class="blockimg" src="/images/higgs/admin-page-phone.png" alt="Admin page editing on small screens." />
</div>

Greg wanted the option to use images for the top nav links. Hence the "logo goes here" filler image&mdash;clicking that triggers the image upload form and the newly-uploaded logo replaces that. The image upload script makes copies of each image at multiple sizes and uses a baby bear size for the nav image, a mama bear size for the admin panel, and the papa bear size for the public page.

The page URLs are sanitized versions of the page titles. So the URL for "KissKill Bags" is {domain}/kisskill-bags.

Each page's images are accessed by clicking the "images" header. A plus sign appears in-line, with thumbnails of each image beneath that.

<div class="img-block"><img class="blockimg" src="/images/higgs/admin-images.png" alt="Admin image uploads on larger screens." /></div>

Clicking the plus, as with the "logo goes here", triggers the image upload form. Newly-uploaded images are added to the bank beneath the header.

Clicking the image's thumbnail toggles its larger version and a text area for its caption.

<div class="img-block"><img class="blockimg" src="/images/higgs/admin-image-caption.png" alt="Admin image caption editing on small screens." /></div>

The dropdown beneath each image (and beneath the page's main textarea) allows you to mark that image (or that page) as hidden or public, or to delete it.

Similarly, when mousing over an image thumbnail, or a page title in the sidebar, a pound sign appears.

<div class="img-block"><img class="blockimg" src="/images/higgs/admin-page-rearrange.png" alt="Admin page rearranging on larger screens." /></div>

You can click and drag the pound sign handles to reorder the images and the pages. The order shown is reflected on the public site.

The **home page** on top is different. It cannot be retitled, hidden, deleted, or reordered to a lower position. It has the same "logo goes here" and main text area as every other page, but its image list is built from the public images of the other pages.

<div class="img-block"><img class="blockimg" src="/images/higgs/admin-home-image-list.png" alt="Admin home page image editing on larger screens." /></div>

Selected images&mdash;those at full opacity and with a thick green border&mdash;appear on the home page.

<div class="img-block"><img class="blockimg" src="/images/higgs/home-page.png" alt="Home page on larger screens." /></div>

The captions of images on the home page link to the pages they represent.

<div class="img-block"><img class="blockimg" src="/images/higgs/example-page-body.png" alt="Example page on larger screens." /></div>

And of course the pages scale down well too.

<div class="img-block"><img class="blockimg smallblock" src="/images/higgs/example-page-phone.png" alt="Example page on smaller screens." /></div>

Greg is still working on the content for his site, so it's not ready to show yet.

Meanwhile, my friend Jon Rossitto asked if I'd build a site for him, so I gave him a modified Higgs. He's also working on his content, and it's coming along nicely. Here's [a preview of the result][jon]. It's loaded primarily with filler content but you can see the idea.




[gig]: http://giganticgallery.info/
[swr]: http://serendipitywinerack.info/
[mp]: http://www.masterplans.com/
[jon]: http://jon.richardmavis.info/
