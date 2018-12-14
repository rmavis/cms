# Specs

Spec files specify how the objects that they relate to should be built.

The Specs themselves shouldn't really be thought of as objects -- instead, they are rules for how an object should be built. So Specs are not instantiable -- they should contain no Class definition, no `initialize` method, etc. Instead, they can contain singleton methods, such as:
- type: which returns a symbol naming the type of object (from the base types) to instantiate
- content_path: which returns a string naming the directory where the content files based on the spec are stored
- public_path: which returns a string naming path relative to the web root where the file should be accessed
- fields (for Entry specs and Compound field types): which returns a hash specifying the names of types and names of member Fields and rules that apply both to those members and to itself. For example:
- view_file: which returns the path (relative to `{root}/local/views`) to an ERB template that can render the spec's view
```
def self.fields
    {
      :meta => {
        :Meta => {
          :_self => {
            :required => true,
          },
          :title => {
            :required => true,
          },
          :date => {
            :required => true,
          },
          :author => {
            :required => true,
          },
          :tags => {
            :required => true,
          },
        }
      },
      :body => {
        :BodyBlocks => {
          :_self => {
            :required => true,
          },
        },
      },
    }
end
```

In this hash, the top-level keys map to keys that will be used in the content (yaml) files. The second-level keys are the module names of member fields. The third-level keys contain rules for the fields named by the second-level keys, except the `_self` key, which contains rules that apply to the field itself.

The `content_path`, `public_path`, and `view_file` methods are required. If they are not specified in the Spec, an exception will be thrown.

All this said, the Spec can also contain instance methods. When the object (a Entry, Field, etc) is built from the Spec, the object will `extend` the Spec, thereby inheriting those instance methods.


## Fields

There are two basic types of Fields: simple and compound. Simple fields are those that contain one value: a string (or array) of text, a date, etc. Compound fields are Fields composed of Fields.

Specs for simple fields should contain a couple instance methods:
- validate: which receives a value and returns either a valid form of that value or `nil`
- get_out_val: which returns a form of the field's value appropriate for viewing

Specs for compound fields don't need those methods -- they will call them on their member fields.

Both types of Fields will have a property, `type`, which will be a string matching the final segment of the Field Spec's `module` name. So the `Local::Specs::Fields::ImagePair` Field will have the `type` 'ImagePair'.


## Entry

Entry specs will be instantiated by the their base Entry `type` class. Like Compound Fields, they should also contain:
- a `fields` method that specifies their components
- a `view_file` method that returns a renderable file for the desired type of view

Aside from those three, Entry specs should be built to suit, providing what their base types require.


## Groups

Group specs differ from the others. Their purpose is different: rather than specifying an object, a Group spec specifies how to build a collection of objects. So it needs no `fields` method, because it won't contain fields. Instead, it will contain `items`, and methods for determining exactly what those items are.

All groups need a couple module methods:
- content_path: which returns a (string) path to the directory to read through
- filter, which receives a hash and returns a boolean indicating whether the object represented by that hash should be built and included in the group

A group spec can also include a `prepare` method. If it does, the method must receive an array of Entries and return an array of Entries. The purpose of the `prepare` method is to enable arbitrary transformation of the Entries that comprise the Group. If the spec defines this method, it will be called just before creating the Group. Else, not.

A group spec should also define a `view_file` method. This will work as it does for Pages, etc.


## Transclusion (kinda sorta)

Sometimes it's more convenient to write/store content in formats other than YAML. Sometimes it's nice to store an article's metadata (in YAML) and body (in Markdown) in the same file. There's a reasonably easy and flexible way to accomplish that.

This example will use the `MarkdownArticle` Entry Spec and the `MarkdownFile` Field Spec:
- The field spec (MarkdownFile) must have a `content_from_file` method (all Fields of type `ReadableFile` must have one), which must have the siguature `string -> hash`. The given string will name the file to read, and the returned hash should have have keys that match those specified by the spec's `fields` method.
- The entry spec can also have a `content_from_file` method. If so, it should have the same signature.
- When the Entry if built, it builds all its Fields. When the `MarkdownFile` Field is built, its `content_from_file` method will be called, and the Field's value will be the resulting hash.
