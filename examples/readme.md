# Examples

## How To Initialize An Installation

0. Put the `cms` somewhere.
1. Create a `dir_map.yaml` file in the `cms`'s root directory. See the [example](dir_map.yaml).
2. Create a `mod_map.yaml` file in the `cms`'s root directory. See the [example](mod_map.yaml).
3. Create an `_autoload.rb` file in the `cms`'s root directory. See the [example](_root_autoload.rb).


## How To Create A Page

### Step 1: Create the Spec(s)

A page is an Entry rendered through a view template. So, to create a page, we'll start by creating an Entry.

An Entry is built from a Spec. A Spec is a Ruby class that specifies how the object it represents should be built, the type(s) of values it can contain, etc. There are multiple kinds of Specs, but the most relevant right now is the Entry Spec.

So create an Entry Spec file. For an example, see `examples/specs/entries/news.rb`.

A Spec file must contain a few required methods. The different types of Specs---Entry, Field, Group, etc---each require their own methods. For example, a Field spec must contain a `type` class method, which will specify the base value type of the Field. An Entry Spec must also specify a `type`, as well as its `fields`, as class methods. A Group Spec doesn't need to specify a `type` but must specify a `content_path` to read from and a `filter` method to collect the group's `items`.

An Entry Spec's `fields` method must return a hash. The keys of this hash map to keys that can be present in a content file that conforms to this Spec. The values of these keys can contain either symbols or subhashes---either way, they must name a Field spec. For example:

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

This Entry Spec permits two Fields, one `Meta` field named `meta` and one `BodyBlocks` field named `body`. The subhashes of each specify additional attributes on the Fields, in this case marking certain things as required.

If the Field Spec you want to use already exists, you can use it in an Entry spec as shown above. If not, then you can create one. See examples in the `examples/specs/fields/` directory.

Both Entry and Field specs must specify which base `type` they're based on. A field's type correlates to the type of value it can contain, as defined by its `validate` method. A Field Spec can either use the base Field's built-in `validate` method or define its own.

Note that a Spec is not a class (it will not be instantiated): it is a collection of class and instance methods. The class methods will be used when building the Entry or Field object (the particular type of which is specified by the Spec's `type` class method), and the object will inherit the instance methods, which may override methods of the same name on the base object.

After creating Entry Spec (and any additional Field Specs that it might need), be sure to add the spec file to the appropriate `_autoload.rb` file. These files contain hashes that map a module name to a file that defines that module. The first time that that module is requested, it will be loaded from the specified file.

### Step 2: Create the content

Now create the page's content file.

By default, content is stored as YAML. The keys of the YAML map to the top-level keys of the Spec's `fields`, and the values of each must conform to the Fields they're based on (they must pass the Field's `validate` method).

In addition to the Entry Spec's `fields`, a content file should contain a `spec` key that names the Entry Spec it conforms to. The `spec` can be named as the last part of a compound module name---e.g., if based on the `::Local::Specs::Entries::News` module, in the content file the spec can be specified as `spec: News`.

### Step 3: Create the view template

The Entry Spec must include two methods that each have the same signature: `symbol -> string`. These methods are `view_file` and `output_file`. The symbol they receive will specify the type of view being created---e.g., `:html`---and the string they return should name the file to use. For `view_file`, this should be an `erb` template that knows how to render the object it's given. For `output_file`, this is the name of the file to write the rendered view to.

For examples, see the `examples/views/html/` directory.
