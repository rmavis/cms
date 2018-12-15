# Specs CMS: Base


## Core Components

There are three key, core components to this CMS:
- Fields, which are containers for values
- Entries, which are containers for Fields
- Groups, which are containers for Entries

The particulars of how Fields, Entries, and Groups should cooperate is specified by the various Spec modules.

A Field Spec, at very least, will specify the Field type it's based on. Depending on the needs/expectations of that Field type, it might also specify subfields, how to extract and parse the value intended for that field, etc.

An Entry Spec, similarly, will at very least specify the Entry it's based on and the Fields that comprise it.

A Group Spec, unlike the others, is not based on a pre-defined base Group type, but it will need to specify the directory containing the content files relevant to the group, how to `filter` and `prepare` the content.

Specs can also specify a `view_file`---which names an `erb` template file that knows how to render a view of that object---and an `output_file`---which names a file to write the view into.

### Fields

The base Field class contains functionality common to its children.

There are three methods to instantiate a new Field object:
- the standard `new` method
- `make`, which calls `new`
- `from_plan`, which calls `make`

`from_plan` is essentially a conveinence method / thin wrapper around `make`.

Subclasses of the base Field can define their own `make` methods, and often should to fit their needs.

During initialization, a Field object will `extend` the Spec it's given, thereby inheriting the instance methods defined in the Spec. This allows for including Spec-specific functionality for building the field as well as instance methods in the spec's file.

### Entries

### Groups


## CLI

You can use the `Base::CLI` class to interact with the CMS.

Commands follow this pattern:

    subject verb [adjective(s)] object(s)

The `subject` specifies the thing/action/function that will be run. For example, to render a view, the subject will be `view`, or to render a group, the subject will be `group`.

The `verb` specifies the way to render the `subject`'s `object`s. For example, when rendering HTML views, the `verb` will be `html`.

The `adjective`(s) modify how the verb should function. For example, a view can be output to stdout (`-o`) or a file (`-f`).

The `object`(s) specify the thing(s) to act on. In the case of views, a content file should be specified. In the case of groups, the last part of its module name (for `Local::Specs::Groups::News`, it will be `News`).

The first two arguments (subject and verb) must occur in that order. The subject and verb specify the behavior of the command and, after those, arguments are processed sequentially, and earlier arguments can be overridden by later ones. For example:

    ./cms.rb view html -o -s TestSpec local/content/index.yaml -f -sx local/content/index.yaml

will render the `local/content/index.yaml` file twice: first by using the `TestSpec` spec (the pattern `-s SpecName`) and printing to `stdout` (the `-o` option), and second by using the spec specified in the content file (the `-sx` cancels a spec given previously in the command) and writing to the output file as specified in the spec (the `-f` option). This could be useful for comparing how different Specs handle their data.

### Commands and Options

Currently, there are two commands:

- `view`, which renders an Entry, and expects a file path as its object
- `group`, which renders a Group, and expects a group spec's name

For both of these commands, the `verb` specifies the view type to render. Currently, the only valid, working view type is `html`, but others can be added.

There are a few options:

- `-o`: write to `stdout`
- `-f`: write to the output file as defined in the Spec
- `-g`: render the given Group as a group
- `-i`: render each item of the given Group individually
- `-s {SpecName}`: render the specified object using the given `SpecName`
- `-sx`: stop using the previously-given `SpecName`

### Examples

Generate a content file's view, writing to the file specified by the spec:

    ./cms.rb view html local/content/index.yaml


Generate a content file's view, writing to stdout (and redirecting to a file):

    ./cms.rb view html -o local/content/index.yaml > public/index.html


Generate a group's views, writing the group to the file the spec specifies:

    ./cms.rb group html News

Generate a group's views, writing each item's view to stdout:

    ./cms.rb group html -i -o News

