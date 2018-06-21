# Specs

Spec files specify how the objects that they relate to should be built.

The Specs themselves shouldn't be thought of as objects -- instead, they are rules for how an object should be built. So Specs are not instantiable -- they should contain no Class definition, no `initialize` method, etc. Instead, they contain singleton methods:
- type: which returns a symbol naming the type of object (from the base types) to instantiate
- fields (for Pages, Compound field types): which returns a hash specifying the names of types and names of member Fields and rules that apply both to those members and to itself. For example:

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

The Spec can contain instance methods. When the object (a Page, Field, etc) is built from the Spec, the object will `extend` the Spec, thereby inheriting those instance methods.

All specs should specify a `view_file` method, which return the path (relative to `{root}/templates/views`) to an ERB template that can render the field's view.


## Fields

There are two basic types of Fields: simple and compound. Simple fields are those that contain one value: a string (or array) of text, a date, etc. Compound fields are Fields composed of Fields.

Specs for simple fields should contain a couple instance methods:
- validate: which receives a value and returns either a valid form of that value or `nil`
- get_out_val: which returns a form of the field's value appropriate for viewing

Specs for compound fields don't need those methods -- they will call them on their member fields.


## Pages & Posts

Page and Post specs should contain a couple instance methods:
- body_fields: which returns an array of Fields that should be included in the page's `body` element


## Groups

Group specs differ from the others. Their purpose is different: rather than specifying an object, a Group spec specifies how to build a collection of objects. So it needs no `fields` method, no instance methods at all. Instead, it needs a few module methods:
- path: which returns a (string) path to the directory to read through
- filter, which receives a hash and returns a boolean indicating whether the object represented by that hash should be built and included in the group
