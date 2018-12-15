# Specs CMS

Some things I hate about otherwise great CMSes are:

- Having to work through their GUIs
- Storing site configuration in the database
- Storing custom field information in the database
- Not easily enabling re-use of custom fields
- View templates via weird templating languages like Handlebars and Twig
- Needlessly re-generating views instead of serving what could or should be static files
- The Loop and all those globals

So this CMS:

- Stores configuration, custom field rules, and everything else in files: either YAML or Ruby, as the situation warrants
- Makes re-use of things easy
- Uses `erb` to render templates
- Generates static files

It currently has no graphical admin---though I plan on writing one---so as of now it's "headless", meaning you interact with the CMS by writing files and acting on them via the command line.


## Core Concepts

The mental model is pretty simple.

There are Fields, which are containers for values.

There are Entries, which are containers for Fields.

There are Groups, which are containers for Entries.

And there are Specs, which define how the other things should be made and behave.

These things can be rendered through Views, which could be HTML (for web pages), XML (for RSS feeds), JSON (for easy data exchange), etc.


### Fields

Fields can be of various `type`s---some for storing plain text, some for numbers, some for arrangements of other Fields, etc.

There are Base Fields, which are defined by the CMS, and Local Fields, which are defined by Specs you write. Local Fields are based on Base Fields.

For example, you might create a ("simple") local field named `PlainText`, which is based on the `PlainText` base field. You might then create a ("compound") local field named `MetaData`, which contains a number of simple `PlainText` subfields.


### Entries

Similarly, there are Base Entries and Local Entries. As with Fields, Local Entries are based on base Entries.

You could create an Entry for blog posts, for items in your portfolio, for pages showing various collections of work from your portfolio, etc.


### Groups

Since a Group is collection of Entries, there aren't any Base Groups. But there are two kinds: pre-defined, which you define in a Spec, and ad hoc, which you define on the fly.

When you define a Group by name, you can reference it in content files.

But sometimes it's nice to be able to build a Group wherever and whenever you want. So you can do that too.


### Specs

A Spec is a collection of methods---both on the class and on the instance---that define a Field, Entry, or Group. Each type of Spec has its own requirements, but the idea is the same: to put all the rules and functionality that define a thing in one file.

For a Field, this means specifying the Base Field it's based on, the view template that can render it, the subfields (if applicable), a method to `validate` values (if applicable), etc.

For an Entry, this means specifying the Base Entry as well as the Fields that comprise it, the directory where content files based on the Spec are stored, the view template and the location of the rendered output, etc.

For a Group, this means specifying the directory that stores the content files, a function to `filter` those files to grab just the ones you want, etc.

For specifics on Specs, read [this](examples/specs/readme.md). And see the [examples](examples/specs/).


## Content

Content is stored in files. The format is really up to you, though I've found that a combination of YAML and Markdown is pretty great. Here's a sample:

    spec: News
    meta:
      title: Important Announcement
      author: Richard Mavis
      tags:
        - great
        - good
        - news
      date: 2018-12-15
      live: true
    body:
      -
        text: "We have great news."
      -
        image:
          file: path/to/image.jpg
          caption: This is so great.
      -
        text: "This is really the best news yet."

The format that a content file should take is defined in the Spec. This content is based on the [News spec](examples/specs/entries/news.rb).

A content file that combines YAML and Markdown could look like [this](examples/content/posts/a-few-recent-sites.md), and [here's](examples/specs/fields/markdown-file.rb) the Spec it's based on.


## Interaction

Since there is no graphical admin UI yet, all interaction is done on the command line.

To generate a single Entry, you could run something like

    ./cms.rb view html -o examples/content/index.yaml
    -------- ---- ---- -- ---------------------------
        |     |    |    |              |
        |     |    |    |              |
      script  |    |  option(s)        |
           command |           entry content file
               view type

That will print the rendered view to `stdout` (as the `-o` option indicates). If an entry's Spec defines the output file, you could run something like

    ./cms.rb view html -s MarkdownArticle examples/content/posts/a-few-recent-sites.md
    -------- ---- ---- -- --------------- --------------------------------------------
        |     |    |    |        |                             |
        |     |    |    |        |                             |
      script  |    |  option(s)  |                             |
           command |         spec name                entry content file
               view type

which will write its output to `examples/public/pages/a-few-recent-sites.html`.

You can render a Group by running something like

    ./cms.rb group html -o MarkdownPages
    -------- ----- ---- -- -------------
        |      |     |   |        |
        |      |     |   |        |
      script   |     | option(s)  |
            command  |       group name
                 view type

Since interaction is on the command line, you can use other CLI tools to automate or script things. For example, you could write a `Makefile`, like

    pages:
        ./build.rb pages
    
    index:
        ./cms.rb view html examples/content/index.yaml
    
    site: pages index

and build your whole site by running `make site`.
