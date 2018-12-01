---
Title: Random Backgrounds
Author: Richard Mavis
Blurb: Because plain backgrounds are plain.
Tags:
    - design
    - development
    - html
    - css
    - javascript
Date posted: 2015-05-09
Date updated: 2017-01-11
Live: true
Index: true
TOC: true
...



# Random Backgrounds

Plain backgrounds are plain. So [here are a few little Javascripts][github] to generate random backgrounds.


## Samples
- [Stars](http://richardmavis.info/stars)
- [Circles](http://richardmavis.info/circles)
- [Grids](http://richardmavis.info/grids)
- [Squares](http://richardmavis.info/squares)

Refresh the pages a few times. They're pretty.

There's a randomly-chosen random background on the bottom of this page, too.


## Files

There are three generators in the repository:

- `bg-circles.js`
- `bg-grid.js`
- `bg-squares.js`

And one controller: `bg-loader.js`.

And one test page: `bg-test.html`.


## Installation

1. Download the files
2. Add them to your pages
3. There is no step 3


## Use

Each generator receives an object specifying things like the number of elements to create, upper and lower bounds for colors, the element to append the elements it generates to, etc. There are sample parameters at the bottom of each file. Or you can pass it nothing and let the generator generate the values it needs itself.

The only thing that you must provide is the target element.

This looks best when the target element spans the full height and width of the page.


## Bonus

The `bg-loader.js` file contains a few functions used by the generators, but can also randomly choose a random generator. So rather than calling, e.g., `new Circles()`, you can call `new BackgroundLoader()`, and in return you'll get a random random background. That's what the pages on this site use.




[github]: https://github.com/rmavis/random-backgrounds
