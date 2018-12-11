# Core Components

There are three key, core components to this CMS:
- Fields, which are containers for values
- Entries, which are containers for Fields
- Groups, which are containers for Entries

The particulars of how Fields, Entries, and Groups should cooperate is specified by the various Spec modules.

A Field Spec, at very least, will specify the Field type it's based on. Depending on the needs/expectations of that Field type, it might also specify subfields, how to extract and parse the value intended for that field, etc.

A Content Spec, similarly, will at very least specify the Entry it's based on and the Fields that comprise it.

A Group Spec, unlike the others, is not based on a pre-defined base Group type, but it will need to specify the directory containing the content files relevant to the group, how to `filter` and `prepare` the content.

Specs can also specify a `view_file`---which names an `erb` template file that knows how to render a view of that object---and an `output_file`---which names a file to write the view into.


## Fields

The base Field class contains functionality common to its children.

There are three methods to instantiate a new Field object:
- the standard `new` method
- `make`, which calls `new`
- `from_plan`, which calls `make`

`from_plan` is essentially a conveinence method / thin wrapper around `make`.

Subclasses of the base Field can define their own `make` methods, and often should to fit their needs.

During initialization, a Field object will `extend` the Spec it's given, thereby inheriting the instance methods defined in the Spec. This allows for including Spec-specific functionality for building the field as well as instance methods in the spec's file.


## Entries

## Groups
