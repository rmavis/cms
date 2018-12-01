---
Title: Intro to HTML
Author: Richard Mavis
Blurb: Calm down, it's only hypertext.
Tags:
    - development
    - html
    - css
Date posted: 2014-01-25
Date updated: 2015-02-03
Live: true
Index: true
TOC: true
...



# Intro to HTML

*One of my younger brothers was curious about HTML and building a website. So I wrote this for him.*

Just to review what we've already discussed: `HTML` is an acronym that stands for `H`yper`T`ext `M`arkup `L`anguage. Hypertext is different than plain text in that it has [hyperlinks][]. To enable hyperlinks, the content you want to display needs to be *marked up* in a certain way, and the program you use to display the hypertext needs to be able to make sense of your markup.

That's only true on one level. But on another level, hypertext and plain text are identical. Take a look at this [.txt][hihihitxt] file and then this [.html][hihihihtml] file. If you download those files and open both in Notepad (or View Page Source on the `.html` file) you'll see that their contents are the same. The only difference in those files is the extension. File extensions are helpful for humans---when we see a file ending with a `.jpg`, we can identify it as an image---and for programs that open files---if you double-click a `.doc` file, Windows will want to open that file with Microsoft Word---but they have no relevance on the file's contents.

The most basic job of a web browser, or any other program that can interpret and display HTML files, is to hide the markup and modify the appearance of the marked-up text according to the way it's marked up.

So this will be an interactive tutorial but interactive in a lo-fi, <acronym title="Do It Yourself">DIY</acronym> kind of way. HTML is a language and as with any other language, if you want to become fluent, you need to learn both how to read it and how to write it.

But first things first: you need a text editor. Dreamweaver will work but if you want to use it you should turn off tag auto-completion and every other auto-whatever features it has. You may prefer the idea of being repeatedly slapped on the forehead with cold steak to repeatedly typing your own closing brackets but, while you're learning, the benefits of this tedium are numerous. By writing your own HTML, opening and closing your own brackets, copying and pasting the parts you wrote around inside the file, you'll learn how a web page is built. And when you know how it's built, you'll have a much better idea of what to fix when the page suddenly gets all borked up. And things *always* get borked up. Always.

Unfortunately I can't really recommend an editor since I haven't used Windows in a long time. But I used [Crimson][crimson] for a while, and I also used [gedit][gedit] which is native to Linux but it looks like [it's also available on Windows][gdwn]. I've never used it but [Notepad++][nppp] is free, and it looks like [Sublime Text][st] is initially free but they might eventually push you to buy it? You could also use plain old Notepad. Or if none of those appeal, here's [a list of options][wikiwintxt]. It doesn't really matter which one you choose but get one before you continue.

By the end of this tutorial you'll have your own website.



## Brackets, slashes, and tags

So as you saw in the `hihihi` files, in an HTML document the content and the markup are mingled. Just like in a well-marbled steak. Imagine your content as the protein-packed flesh and your markup as the ribbons of fat that make it oh so tasty.

Anyway. An HTML tag is built from these parts:

1. An opening angle bracket: `<`
2. Some text indicating the type of tag that the tag will become, such as `p` or `a` or `div`.
3. A closing angle bracket: `>`
4. And a forward slash, `/`, which occurs in different places depending on the tag's type (item 2).

This is a tag: `<p>`. So is this: `</p>`. And so is this: `<img />`.

Referring to the list, the `p` or *paragraph* tag is called a "p tag" or a "paragraph tag" because the second part of the tag is the character "p", and it's used to demarcate a paragraph of text. Amazing stuff, right?


### Block elements

But "the paragraph tag" is actually two tags: `<p>`, which starts a paragraph, and `</p>`, which ends it. They are appropriately called "opening" and "closing" tags. A closing tag contains the slash (item 4 in the list) and the same shorthand (item 2) as the opening tag.

So when I say something like "wrap your text in p tags", I mean put an opening `<p>` tag at the start of your paragraph and a closing `</p>` tag at the end. Kind of like complicated parentheses: `<p>` is to ( as `</p>` is to ).

A paragraph is called a "block element". There are a lot of block elements, such as headers (which are created with `<h1>`, `<h2>`, `<h3>`, down to `<h6>` tags), pre-formatted blocks (which are created with `<pre>` tags), and divisions (which are created with `<div>` tags).

So what do all block elements have in common?

1. They are created with opening and closing tags.
2. They are separated from other elements by linebreaks, or white space.

Lists are block elements, too. There are two types of lists:

- Ordered lists, created with `<ol>` tags.
- Unordered lists, created with `<ul>` tags.

Ordered lists are numbered. Unordered lists are bulleted. Items in both types of lists are wrapped in `<li>` tags.


#### Playing with blocks

Okay, fire up your text editor. Let's make a page.

Create a new file. Write a paragraph or two about absolutely anything you want. Add a list or two. Put a heading at the top of your page and smaller headers at the top of different sections. And wrap each element in the appropriate tag.

You can look at [my page][radpage1] for examples (right-click, View Page Source) but you should write your own page. Copying and pasting is not learning. As you continue this lesson you'll keep adding to your page, and at the end of it you'll upload your page to a public web server. So if you just copy mine the whole time, the end will be a big fat bore-fest. For you *and* for me.

After you've written your page, save the file. You can then open it in a browser to see how the browser hides the markup and displays the marked-up text according to the markup you used. If you're using Chrome, click File, then Open File..., then find your file, and *voil&agrave;*, your page.

And I want to see it! You should send me a screenshot.


### Inline elements

In addition to block elements there are *inline elements*. Hyperlinks are inline elements, and you create those by wrapping text with `<a>` tags. You can make text **bold** by wrapping it in `<strong>` tags, and you can make text *italic* by wrapping it in `<em>` tags.

So how are inline elements different than block elements?

- They are usually inside block elements.
- They are not separated from other elements by linebreaks or white space.

This paragraph is a block element. This **bold text** is an inline element.


#### HREF equals attribute

Links point to things. When you click a link, your browser checks the address that the link points to and then downloads whatever it finds there. If the link points to another web page, then your browser will download that web page and display it. If the link points to a `.zip` or a `.exe` file, then your browser will download the file and let you decide what to do with it next.

First, a little bit about *attributes*. Attributes are additional specifications to an element. Their general format is `attribute="whatever"`. That is:

1. Attribute name. In this case, the rather clever `attribute`.
2. Equals sign.
3. Opening quote.
4. Attribute value. In this case, the rather meaningful `whatever`.
5. Closing quote.

Attributes go in the opening tag. Don't worry about the closing tag---it only needs the slash and the element type to do its job. Here are a few examples:

	<h1 title="Howdy, dude">I eat beans.</h1>
	<p><a href="http://www.nyan.cat/">Yay! Yay!</a></p>
	<p>I eat <strong style="color: #0000FF;">beans</strong>!</p>

You can add as many attributes as you want to your elements. You can give those attributes whatever name you want and specify any value at all. But browsers only know how to make sense of a few specific names.

So to make a link you wrap some text with `<a>` tags, and in your opening `<a>` tag you specify what you want the link to point to with the `href` attribute. Here's an example:

	<a href="http://www.jellotime.com/">Jello Time</a>

And here's that HTML in action: <a href="http://www.jellotime.com/" target="_blank">Jello Time</a>.

That link will open the page that it points to in a new tab. It does that because I added another attribute: `target="_blank"`.

So now we can expand our list of tag parts:

1. An opening angle bracket.
2. Text indicating the tag type.
3. Attributes!
4. A closing angle bracket.
5. And, in closing tags, a forward slash placed between parts 1 and 2.


#### Imagine the possibilities

Images are a special kind of inline element: the `<img>` tag is entirely self-containing. The image you want to show is specified with an `src` attribute, and the element doesn't need a separate closing tag, but just a slash before the closing angle bracket:

	<img src="big_burger.jpg" />

The `src` attribute needs to point to the image. In this case, the image file is in the same directory as the HTML file. But if it's somewhere else, the `src` attribute needs to show that. The file path must be correct or the image won't load.

	<img src="/images/big_burger.jpg" />

That tag creates this image element on this page:

<div class="img-block"><img src="/images/big_burger.jpg" /></div>

Remember that images are inline elements. They will display inline with whatever element is around it. I put that `<img>` in its own `<p>` to separate it.

Images can have other attributes, like `alt`, which is short for "alternative text", or `title`, which displays its value in a little box if you hover over the image. But it must have an `src` attribute. Otherwise it will show nothing except your failure to use the tag correctly `:(`


#### Inline it up

So if it's not open still, open your text editor again and open the file you created before. Add a couple inline elements. Make some text **bold** or *italic*. Add a couple links.

I updated [mine][radpage2], which you can look at for examples. But write your own. Learning doesn't need to be work, so have fun with it. Be creative. And send me a screenshot of your updates!



## Stylin'

So now you know the basics of tags, tag attributes, and two types of elements: block and inline. And, as your page shows, this knowledge is enough to write a basic HTML document and create a basic web page.

But say you don't like the way the browser underlines the text of your links and colors them blue or purple after you click them. Say you don't like the plain black and white color scheme, or you want your main header to be bigger and in ALL CAPS, or you just want to change the font.

This is where styles come in. Styles allow you to change the visual appearance of your HTML.

Right now your page is unstyled. Neither is [this one][uns1]. [This one][uns2] is but just barely. So your page probably looks pretty similar, stylistically, to those. The browser needs to display the elements of the HTML document *somehow*---it needs to size the text for paragraphs and headers, it needs to add space between block elements, it needs to distinguish linked from unlinked text, it needs to color the body text and the background, etc.---so if the document doesn't provide its own rules to specify how it should be styled, then the browser will use its own rules. Those rules are the browser's *default styles*. If you want to, you can change the defaults in your browser's settings.

But most websites are styled---their visual appearance is specified by style definitions that it provides the browser in the same way that it provides the content.

You may not like the look of a lot of sites out there, but at least there's variety. Without styles, the internet would look *boring*.


### Inline styles

If your page doesn't have a main header on top, add one now. Use an `<h1>` element. Then open your page in your browser.

You can specify style rules for individual elements using *inline style definitions*. You do so by adding a `style` attribute to the element.

Right now, your main header is probably bold, in the same font as your paragraphs but maybe two times as large? The definition in this header's style attribute will make the text five times larger than the body text:

	<h1 style="font-size: 500%;">This is rad</h1>

So add a style attribute to your page's main header. Set the `font-size` to `500%` and then go back to your browser and refresh the page. Set it to 5000% and refresh again. Go nuts.

The general format for a style definition is `property: value;`. That is:

1. Style property. A few other properties are `color`, `font-weight`, and `margin`.
2. A colon.
3. Style value. This must be appropriate for the style property.
4. Semicolon. Think of this as punctuation---a sentence ends with a period, a style rule ends with a semicolon.

You can add as many style rules to an element as you want. Put them all in the element's `style` attribute.

	<h1 style="font-size: 500%; text-transform: uppercase; margin-bottom: 0px;">This is rad</h1>

The style property dictates what type of value can be used. A value of `500%` for `background-color` makes no sense, but for `font-size` it's awesome. For properties where a numerical value makes sense the number needs to be qualified by a unit of measurement---either an absolute unit, like `px`, or a relative unit, like `em` or `%` (which is relative to the default text size).

The value for the `margin-bottom` property follows the same format but the unit of measurement is `px`, short for "pixels". So that rule specifies that the header should have a bottom margin of 0 pixels. Tight!

The `text-transform` property needs a different type of value. If you tell the browser to transform the text by `500%` or `42px`, it won't know what to do and you might hurt its feelers. But if you tell the browser to transform the text by making it `uppercase`, it will know exactly what to do and it will do exactly that.

These style rules makes sense:

	<h1 style="font-size: 300px; font-weight: normal; font-style: italic;">This is rad</h1>

These does not:

	<h1 style="font-size: uppercase; font-weight: #0000FF; font-style: 42%;">This is rad</h1>

[W3Schools has a big list][w3css] of style properties you can look through. They also show appropriate values for each property. A few that you can use on your main header are:

- `font-size`, which controls the size of the text. Sample values: `350%`, `350px`, `350em`.
- `font-weight`, which controls the boldness of the text. Sample values: `normal`, `bold`.
- `font-family`, which sets the font by name. Sample values: `Georgia`, `Helvetica`, `"Comic Sans"`, or the name of any other font installed on your computer. If the name is more than one word, wrap the name in quotes.


### Don't quote me, but...

Okay, open your page in your text editor. Let's add a cool quote and make it look *stylin'*.

Start by adding another header.

	<h2>Cool Quotes</h2>

I'm going to wrap my quote in a `div` to separate it from the other elements.

	<div style="margin-top:50px; margin-bottom:50px;">
	</div>

Those style rules will add 50-pixel margins above and below the element.

Since we're displaying text, let's use `<p>` tags for the quote. Find a cool quote, wrap it up, style it up, and put it in the `div`. Here's mine:

	<div style="margin-top:50px; margin-bottom:50px;">
		<p style="margin-top:0; margin-bottom:0; font-size:150%; font-style:italic;">I don't exactly know what I mean by that, but I mean it.</p>
	</div>

And since it's a quote, we need to include the attribution. Because the attribution includes the author's name and the book's title, I'll use a `<p>` tag for the whole line and `<span>` tags to distinguish the inline elements.

	<div style="margin-top:50px; margin-bottom:50px;">
		<p style="margin-top:0; margin-bottom:0; font-size:150%; font-style:italic;">I don't exactly know what I mean by that, but I mean it.</p>
		<p style="margin-top:0; margin-bottom:0;">
			<span style="font-weight:bold;">J.D. Salinger</span>, from <span style="font-style:italic;">The Catcher in the Rye</span>
		</p>
	</div>

And because there are so many cool quotes out there, let's add another:

	<div style="margin-top:50px; margin-bottom:50px;">
		<p style="margin-top:0; margin-bottom:0; font-size:150%; font-style:italic;">Beware of the man who works hard to learn something, learns it, and finds himself no wiser than before.</p>
		<p style="margin-top:0; margin-bottom:0;">
			<span style="font-weight:bold;">Kurt Vonnegut</span>, from <span style="font-style:italic;">Cat's Cradle</span>
		</p>
	</div>

[I'm stopping with those][radpage3], but you should add as many as you want to. Change the styles and formatting. Make it look awesome! And then send me a screenshot.



## Getting heady

Here's the HTML for my two quotes:

	<div style="margin-top:50px; margin-bottom:50px;">
		<p style="margin-top:0; margin-bottom:0; font-size:150%; font-style:italic;">I don't exactly know what I mean by that, but I mean it.</p>
		<p style="margin-top:0; margin-bottom:0;">
			<span style="font-weight:bold;">J.D. Salinger</span>, from <span style="font-style:italic;">The Catcher in the Rye</span>
		</p>
	</div>
	
	<div style="margin-top:50px; margin-bottom:50px;">
		<p style="margin-top:0; margin-bottom:0; font-size:150%; font-style:italic;">Beware of the man who works hard to learn something, learns it, and finds himself no wiser than before.</p>
		<p style="margin-top:0; margin-bottom:0;">
			<span style="font-weight:bold;">Kurt Vonnegut</span>, from <span style="font-style:italic;">Cat's Cradle</span>
		</p>
	</div>

Say you wanted to change the `font-size` of the quote to `175%`. And make it bold instead of italic. And say you wanted to add some whitespace between the quote and the attribution. And say you had 14 quotes instead of two. And say you really, *really* don't want to comb through every last element attribute and change every last style definition one by everloving one. How would you do it?

The answer, dear brother, is you would move the style definitions out of the HTML and into the <acronym title="Cascading Style Sheet">CSS</acronym>. And you would put the CSS up in your HTML's `<head>` tag.


### Keep your `<head>` up

I hate to break this to you buddy, but right now your HTML is invalid. It's malformed and incomplete. But don't worry. Unless your browser was built circa 1983, or by Microsoft, then it probably knows how to display your HTML. But, technically, all the HTML you've written so far belongs in a `<body>` tag. And---you guessed it---the `<head>` tag goes above the `<body>`. And the whole shebang belongs in an `<html>` tag. Like this:

	<html>
	
		<head>
			<!-- This is the head section. You'll add your CSS here soon. -->
		</head>
		
		<body>
			<!-- This is the body section. Your HTML goes here. -->
		</body>
		
	</html>

<strong>`<aQuickAside>`</strong>

Elements of a whole different set can go in the `<head>` section, like links to external Javascript files, data about your data (called "metadata"), special instructions for mobile devices, etc. Along with all that optional stuff, one very important element belongs in the `<head>`: the page `title`. The title is shown in the tab, or the window, and the bookmark, if you're into browser bookmarks. Without a `<title>` tag, the browser will default to the URL as the page's title, which can be unsightly.

	<title>This page is awesome</title>

So a title your page. Breathe deeply and feel satisfied knowing that by doing so you helped reduce the general ugliness of the world. Every bit counts.

Also, text between `<!--` and `-->` tags is called a "comment". Comments are present in your HTML but browsers don't display them. And unless you add something strange and unexpected, your browser won't display what's in the `<head>` tag either.

<strong>`</aQuickAside>`</strong>

The `<body>` section should contain the *body* of your page---the content you want to display. And the `<head>` section contains information that supports the content.

Think about a theatre. It contains an auditorium, a stage, and a backstage area. The people visiting your page are in the auditorium. The stage and the actors on that stage are in your page's `<body>` section, and they're being supported by the backstage area in your page's `<head>` section.

Or think about a big delicious steak. The plate and knife and fork and stuff are the `<head>` section. This stuff can enhance your experience. It frames the beautiful cut of meat and gives it context. But the steak itself is the `<body>` section. That's what you're after, what you really want, regardless of context or presentation.

Or I guess you could also think about a human. We can't see what happens in someone's `<head>`, but we can see everything their `<body>` does.


### Style guide

In your `<head>` section, add a `<style>` tag.

	<head>
		<title>This page is awesome</title>
		<style>
		</style>
	</head>

CSS is a style language. Its whole point is to make your HTML look good. In that way it's a little like one of those tiny fish that swim alongside sharks and suck sea-dirt and streaks of [whale poop][] off their bodies. The suckfish finds a steady and easily accessible supply of food on the shark's body, and also protection so it doesn't become easy food for some other fish. And the shark gets cleaned by the suckfish. Both benefit from the other. It's a classic example of a mutually beneficial parasitic relationship.

HTML and CSS have something like a mutually beneficial parasitic relationship. HTML can exist without CSS---it would be a lot dirtier without CSS (think about all those `style` attributes in our quotes) but it would live. And CSS can exist without HTML, but it wouldn't do anything. Its purpose is to add style---if there's nothing to style, then it's useless. So HTML and CSS are much better off when they're together.


#### Match it up

CSS works by matching style definitions with elements. The style definitions are written in the same format that you used in the `style` attributes of your elements: property, colon, definition, semicolon.

Put this between the `<style>` tags in your `<head>` section:

	p {
		margin: 150px;
	}

Save the file and refresh it in your browser. If the spacing of your paragraphs looks all borked up---a huge amount of whitespace between paragraphs and between the paragraphs and the edge of the page---congrats! You successfully borked your first page design. Savor this moment.

Now let's fix it.

The general format for CSS rules is:

1. Element type to be modified.
2. Open curly bracket.
3. Style definition(s).
4. Close curly bracket.

So, in all, that CSS tells your browser to add a margin of 150 pixels all the way around each `<p>` tag in your HTML.

One way to return sane margins to your paragraphs is to replace that rule with these:

	p {
		margin-top: 25px;
		margin-bottom: 25px;
		margin-left: 0px;
		margin-right: 0px;
	}

That explicitly states the values for the top, bottom, left, and right margins.

But that's a lot of typing just to specify paragraph margin rules.

One awesome thing about computer programmers is that they're pathologically lazy. For them, it's the computer's job to do all the repetitive, tedious, and boring work, and it's their job to tell the computer how to do that stuff. So, in general, they hate tedium and repetition more than almost anything.

Specifying margin definitions one rule per line is pretty tedious and repetitive. Why spread your definitions over four lines when you could condense them to one?

	p {
		margin: 25px 0 25px 0;
	}

But if you want to be lazy and condense that definition, then you need to follow the rules and do it in a way the browser will understand---you need to arrange your values for top, bottom, left, and right in an expected way. And the way the browser expects them is: top, right, bottom, left. That is, clockwise. So the above definition will set the top margin to `25px`, the right to `0`, the bottom to `25px`, and the bottom to `0`.

And if you want your top and bottom margins to be one value (`25px`), and your right and left margins to be another (`0`), you can condense that definition even further:

	p {
		margin: 25px 0;
	}

That condensed rule starts with the single-line, clockwise-oriented rule, and also follows the *don't repeat yourself* <acronym title="Modus Operandi">MO</acronym>. Start at the top: the margin's top value is set to `25px`. Next: right margin is set to `0`. And, since the are no other values, the bottom is assigned the same value as the top, and the left the same value as the right.

Which leads us full circle, back to the first rule:

	p {
		margin: 150px;
	}

That gives the top margin a value of `150px`. And, since there are no other values, the right, bottom, and left are all assigned the same value. And the browser will expand that shorthand to have the same effect as:

	p {
		margin-top: 150px;
		margin-right: 150px;
		margin-bottom: 150px;
		margin-left: 150px;
	}	


#### Taggin'

So now you can style your elements according to their tag type. Here's [my page's][radpage4] new `<style>` section:

	<style>
	body {
		margin: 0;
		padding: 25px;
		font-size: 16px;
	}
	h1 {
		font-size: 400%;
		font-style: italic;
	}
	h2 {
		font-size: 200%;
		font-weight: bold;
	}
	p, ol, ul {
		line-height: 150%;
		margin: 25px 0;
	}
	li {
		line-height: 125%;
	}
	pre {
		font-size: 150%;
	}
	</style>

Two things to note:

1. Keeping with the *don't repeat yourself* mentality, if you want multiple element types to share the same style definitions, you can list them. Just separate the tag types with commas: `p, ol, ul`.
2. The `body` section of your page is an element like any other and can therefore be styled like any other element.


##### More body

Every element that you see on your page is inside the file's `<body>` tags---in other words, every element that your browser displays is contained in the document's `<body>` element.

Elements that contain other elements are called "parent" elements. And elements that are contained by others are "child" elements.

So take a look at this:

	<html>
		
		<head>
			<style>
				body {
					background-color: #000000;
					color: #FFFFFF;
				}
			</style>
		</head>
		
		<body>
			<h1>Hello!</h1>
			<p>Hi. <em>Yo.</em> <strong>Howdy!</strong></p>
		</body>
		
	</html>

The `<html>` element contains every other element and is contained by none. It's the parent. Inside the `<html>` element are the `<head>` and `<body>` elements---those are its child elements. Going further: the `<style>` element is a child of the `<head>`, the `<h1>` and `<p>` elements are children of the `<body>`, and the `<em>` and `<strong>` elements are children of the `<p>`. The `<em>` and `<strong>` elements are direct children of `<p>`, and are sort of like grandchildren of `<body>`.

So, in a way, your HTML document is structured like a big happy extended family.


##### Inheritance

Taking the happy family analogy further is the concept of *inheritance*. Child elements *inherit* the styles of their parent elements.

The `<body>` element is the parent of every element on your page. So style definitions you give to the `body` will be inherited by all of its children.

	body {
		background-color: #000000;
		color: #FFFFFF;
	}

Unless other style definitions override these, every child and grandchild and great-grandchild of the `<body>`, all the way down the line, will display with white text on a black background.

Say you edit that example's style definitions:

	body {
		background-color: #000000;
		color: #FFFFFF;
		font-size: 13px;
	}
	h1 {
		font-size: 300%;
	}
	p {
		background-color: #FFFFFF;
		color: #000000;
	}

The `body`'s `font-size` is set to `13px`---which is an absolute measurement. And the `h1`'s `font-size` is set to `300%`---which is a relative measurement. Because the `<h1>` is a child of the `<body>`, it will inherit the `body`'s `font-size` definition. So its default `font-size` will be `13px`. The `300%` is relative to that value---`300%` of 13, resulting in 39px.

And the `<h1>` will inherit the color definitions of the `body`, showing as white on black, but the `<p>` has its own style definitions, so it will use those instead, and will appear as black on white.

I'm sure you've noticed that blocks of code on this page are colored differently than paragraphs. If not, well, maybe you take a little break?

I'm going to take a couple of these funky styles back into [my page][radpage5]. You should funk yours up too! And send me a screenshot.


#### Make it classy

But say you want to give certain elements their own styles. Like our quotes. We used `<p>` tags, but we want *those* `<p>`s to look different than the other `<p>`s. And we want the quotes themselves to look different than the attributions.

If you look up the word "class" in the [dictionary][defclass], you'll see it can be defined as

> a set or category of things having some property or attribute in common and differentiated from others by kind, type, or quality

So when we talk about certain types of `<p>`s looking different from others, we're talking about *classes*. We want to create different classes of `<p>`s that have their own sets of styles.

Here's the quote section from my page:

	<div style="margin-top:50px; margin-bottom:50px;">
		<p style="margin-top:0; margin-bottom:0; font-size:150%; font-style:italic;">I don't exactly know what I mean by that, but I mean it.</p>
		<p style="margin-top:0; margin-bottom:0;">
			<span style="font-weight:bold;">J.D. Salinger</span>, from <span style="font-style:italic;">The Catcher in the Rye</span>
		</p>
	</div>
	
	<div style="margin-top:50px; margin-bottom:50px;">
		<p style="margin-top:0; margin-bottom:0; font-size:150%; font-style:italic;">Beware of the man who works hard to learn something, learns it, and finds himself no wiser than before.</p>
		<p style="margin-top:0; margin-bottom:0;">
			<span style="font-weight:bold;">Kurt Vonnegut</span>, from <span style="font-style:italic;">Cat's Cradle</span>
		</p>
	</div>

It's pretty ugly. So much text is repeated, and it was horribly tedious to type. If it were a steak, there would be way too much fat. You'd spit it out before getting any tasty flesh.

And here it is all classed up:

	<div class="quote-case">
		<p class="quote-quote">I don't exactly know what I mean by that, but I mean it.</p>
		<p class="quote-attr-case">
			<span class="attr-auth">J.D. Salinger</span>, from <span class="attr-book">The Catcher in the Rye</span>
		</p>
	</div>
	
	<div class="quote-case">
		<p class="quote-quote">Beware of the man who works hard to learn something, learns it, and finds himself no wiser than before.</p>
		<p class="quote-attr-case">
			<span class="attr-auth">Kurt Vonnegut</span>, from <span class="attr-book">Cat's Cradle</span>
		</p>
	</div>

A class modifies an element---it is an attribute of an element. And you add a class to an element as you would any other attribute.

Try to pick sensible names for your classes. For the sake of your sanity. Trust me.

To apply class-specific styles to your elements, you need to add the same class names, along with their class-specific style definitions, to your CSS:

	div.quote-case {
		margin-top: 50px;
		margin-bottom: 50px;
	}
	p.quote-quote {
		margin-top: 0;
		margin-bottom: 0;
		font-size: 150%;
		font-style: italic;
	}
	p.quote-attr-case {
		margin-top: 0;
		margin-bottom: 0;
	}
	span.attr-auth {
		font-weight: bold;
	}
	span.attr-book {
		font-style: italic;
	}

So here's the general format for CSS rules, expanded to include classes:

1. Element type to be modified.
2. A period and a class name attached to item 1.
3. Open curly bracket.
4. Style definition(s).
5. Close curly bracket.

Here's [mine][radpage6]. Class yours up and send me a screenshot!

Actually, hold off on the screenshot. It'd be much cooler to see it live and in action.



## It lives

There are a lot of services online that will host your website for free. To recoup their expenses some of these services will insert ads, others will require personal data (which they could sell to marketers) or permission to re-use your content (which they could use to promote themselves). And some, like wandering monks, live on donations.

[Neocities][neoc] is one of those. It won't add ads or sell your stuff. It also won't allow you fancy tools or specialized access to the server. It allows you to post very basic web pages---that's it. And sometimes that's exactly what you need. [Here's a page I made a friend for his birthday][hbdjta].

So go there: [neocities.org][neoc]. Signing up is simple. First, pick a domain name---it will end up being prepended to `.neocities.org`, and that will be your page's URL. So think about it and pick a good one. I picked "<a href="http://htmlfornick.neocities.org/">htmlfornick</a>".

Next, type that name in the box and click the big red Create My Website button. The next page will ask you for some basic information so you can log in and edit your site, like a password. So fill in all that stuff and then submit the form.

After you log in you'll be shown your dashboard page. Your URL will be shown in the top part of the right column. You can visit it but it will just show the default HTML from Neocities.

Notice that the URL for your new site, `http://yourcoolname.neocities.org`, doesn't have a filename on the end, like `/rad-page-6.html`. When no filename is specified, web servers will offer up the site's *index* page, usually `index.html` though you might also see `index.php`, `index.asp`, or others.

So that's why, on top of the main left column in the Neocities dashboard, you see `index.html`. Under the icon and explanatory paragraph, click "Edit with text editor". Delete all the default stuff, copy and paste your entire HTML file into the editor, save it. Assuming it doesn't break, your site will now be live.

But your images will probably be broken. You need to upload those (via the Upload New Files button in the right column), and you might need to change the file path in the `<img>`'s `src`. Neocities will actually just give you the tag after you upload the image---mine was `<img src="/big_burger.jpg">`---so you could copy and paste the `src`s it gives you over the old ones.

And after that, your page will be complete! You and the entire internet can now see your work at your URL.

So instead of a screenshot, send me that URL.



## This is the end...

And now you know a bit about HTML, CSS, and you know how to write a cool page in the coolest way there is: by hand.

If you liked learning these basics and want another tutorial, just let me know. I'd be happy to write another one for you.




[hyperlinks]: https://en.wikipedia.org/wiki/Hyperlink
[hihihitxt]: /misc/html-for-nick/hihihi.txt
[hihihihtml]: /misc/html-for-nick/hihihi.html
[wikiwintxt]: https://en.wikipedia.org/wiki/Category:Windows_text_editors
[crimson]: http://www.crimsoneditor.com/
[gedit]: https://projects.gnome.org/gedit/
[gdwn]: http://ftp.gnome.org/pub/GNOME/binaries/win32/gedit/2.30/gedit-setup-2.30.1-1.exe
[nppp]: http://notepad-plus-plus.org/
[st]: http://www.sublimetext.com/
[radpage1]: /misc/html-for-nick/rad-page-1.html
[radpage2]: /misc/html-for-nick/rad-page-2.html
[radpage3]: /misc/html-for-nick/rad-page-3.html
[radpage4]: /misc/html-for-nick/rad-page-4.html
[radpage5]: /misc/html-for-nick/rad-page-5.html
[radpage6]: /misc/html-for-nick/rad-page-6.html
[uns1]: http://mw.rat.bz/wgmag/
[uns2]: http://www.davidhorvitz.com/
[w3css]: http://www.w3schools.com/cssref/
[whale poop]: https://www.youtube.com/watch?v=_KD7O8W_VLo
[defclass]: http://www.oxforddictionaries.com/us/definition/american_english/class?q=class
[neoc]: https://neocities.org/
[hbdjta]: http://jacktheandre.neocities.org/
