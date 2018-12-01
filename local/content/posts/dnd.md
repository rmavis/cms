---
Title: Dungeons & Debauchery
Author: Richard Mavis
Blurb: Like peas in a pod.
Tags:
    - design
    - development
    - ruby
    - html
    - css
Date posted: 2014-10-15
Date updated: 2015-04-04
Live: true
Index: true
TOC: true
...



# Dungeons & Debauchery

- <a href="#the-story">The story</a>
- <a href="#the-tech">The tech</a>



<a name="the-story"></a>
## The story

I don't remember who had the idea or why it seemed so good but somehow it was decided that we'd throw a D&D party. It turns out that D&D makes a great party game.

<div class="img-block"><img class="blockimg" src="/images/dungeons-and-debauchery/dnd-group-1.jpg" alt="Adventurers. Clearly." /></div>

My friend [Jason Edward Davis][jed] offered both to host the party and to DM the game. He and I talked about the adventure a little but he did all the creative work of fleshing out the story, building the dungeon, and generally making the game awesome.

I've always played D&D the normal way---sitting around a table, talking, rolling dice, eating a huge bag of Doritos. But in the way Jason plays there are real-life interactions. At one point I had to arm wrestle another guy at the table. I won, my character won money, and his took a temporary hit to his charisma. Another house rule: if you fumbled a roll, then you had to take a shot. And if you rolled a critical, then you got to assign a shot to someone else. I'm pretty sure only one character survived.

<div class="img-block"><img class="blockimg" src="/images/dungeons-and-debauchery/dnd-group-2.jpg" alt="Adventurers in action." /></div>

One essential ingredient to any game of D&D is the character sheet. In case you're not familiar, a character sheet is a form where you fill in the details of your character---name, race and class, level, alignment, stats, hit points, THAC0, armor class, languages and proficiencies, saving throws, weapons, armor, items, spells, that sort of thing. The character sheet is your ticket to the game. It contains all the information on the character you're playing.

But somehow character sheets are impossible to find. I have seen literally two fresh character sheets---one each for a friend and me, given to us by our first DM. All the others have been copies of copies. Gaming stores don't carry them. They carry standalone adventure books, complete campaign sets, binders of monsters, reference books on everything from gnomes and halflings to the planes of existence, but character sheets? They told us good luck. And then I spent $30 on dice.

<div class="img-block"><img class="blockimg" src="/images/dungeons-and-debauchery/dnd-dice.jpg" alt="We used every one of them, too." /></div>

Also, creating characters isn't something you want to do at a party. There are so many dice to roll, so many soul-searching decisions to make. If you care about your character, it could take 20, 30 minutes. And it's a process you'll want to work through at home, alone. Pour a Chimay and light some candles. But if you don't care, it could take 20 to 30 milliseconds.

So some friends came over and we created 40 characters. I wrote a Ruby script to generate the boring stuff and we had a lot of fun picking a name, an item, and a character trait. We wrote everything out, and then I typed everything back in. Yes, I'm an idiot.

But then I made my own character sheets. The Ruby script chomps through the file containing the character data and spits out HTML files. Those HTML files can then be styled, opened in a browser, and converted to PDFs. Those PDFs can then be taken to Kinko's and printed. Those printed sheets can then by cut up and stacked. Those stacked sheets can then by rifled through by your party people. Those party people can then select a character they like. And then you can play.

<div class="img-block"><img class="blockimg" src="/images/dungeons-and-debauchery/dnd-char-sheets.jpg" alt="And play we did." /></div>

I left out a lot of things---it's a party, we play loose with the rules---but they fit the purpose well. And they look snazzy thanks to Hoefler Text and some icons from [The Noun Project][nounp].



<a name="the-tech"></a>
## The tech

For our second Dungeons & Debauchery party, I wrote a character generator. It's an expansion of the above-mentioned Ruby script that will randomly pull each aspect of the character from a library of source files---there are files for first and last names, items and character traits, race- and class-specific proficiencies and spells, etc. You can run something like

    $ ./dnd.rb sheets 40

and in return get 10 HTML files, which you can then make into PDFs. [Here's an example][sample].

If you're into this sort of thing, it's on [Github][].





[jed]: http://jasonedwarddavis.com/
[nounp]: http://thenounproject.com/
[sample]: /misc/dnd/char-sheets-3.pdf
[github]: https://github.com/rmavis/dnd-character-generator
