# The Template class is the core of the CMS's core functionality.
# The main idea is that a Template contains a collection of Fields,
# and a Field contains a value and other attributes, and these
# Fields can be rendered as an HTML page, form, as YAML, etc. So
# a Template is an object that contains a collection of fields and
# methods for reading and rendering those fields in various ways.
module Base
  class Template

    def self.specs_prefix
      ::Templates::Specs
    end

    def self.page_specs_prefix
      "#{self.specs_prefix}::Pages"
    end

    # Template.from_yaml :: string -> Template
    def self.from_yaml(filename)
      return self.from_content(YAML.load(File.read(filename)).transform_keys(lambda {|s| s.to_sym}))
    end

    # Template.from_content :: hash -> Template
    def self.from_content(content)
      if (!content.has_key?(:spec))
        raise "Error: no `spec` specified in content file `#{filename}`."
      end

      # Working on creating fields from specs and compound/collection
      # field, in particular for collections, which need to map
      # one-to-many from the spec to the content
      template_spec = "#{self.specs_prefix}::#{content[:spec]}".to_const
      template = "::Base::Templates::#{template_spec.type}".to_const.new(self.load_fields(template_spec))
      template.extend(template_spec)

      template_spec.fields.each do |key,_val|
        if (content.has_key?(key))
          template.fields[key].set_if_valid!(content[key])
        elsif (template.fields[key].attrs[:required])
          raise "The required key `#{key}` is missing."
        end
      end

      # fields = self.make_fields(template_spec, content)
      # template.set_fields!(fields)

      return template
    end

    # Template.load_fields :: Spec -> {Fields}
    # The keys of the Fields hash will be identical to the Spec's
    # `fields` hash, but the values will be with Field objects.
    def self.load_fields(template_spec, content = { })
      fields = { }

      template_spec.fields.each do |key,val|
        if (val.is_a?(Symbol))
          fields[key] = Field.from_plan(val)
        elsif (val.is_a?(Hash))
          # There should only be one of each `key` in the spec,
          # this is just an easy way to reference the values.
          val.each do |_key,_val|
            fields[key] = Field.from_plan(_key, _val)
          end
        else
          raise "The classes of a Spec's `fields` must be specified as a Symbol or a Hash."
        end
      end

      return fields
    end

    def self.make_fields(template_spec, content)
      fields = { }

      template_spec.fields.each do |key,val|
        if (val.is_a?(Symbol))
          fields[key] = Field.from_plan(val)
        elsif (val.is_a?(Hash))
          # There should only be one of each `key` in the spec,
          # this is just an easy way to reference the values.
          val.each do |_key,_val|
            fields[key] = Field.from_plan(_key, _val)
          end
        else
          raise "The classes of a Spec's `fields` must be specified as a Symbol or a Hash."
        end
      end

      return fields
    end

    # new :: {Fields} -> Template
    def initialize(fields)
      @fields = fields
    end

    attr_reader :fields

    def set_fields!(fields)
      @fields = fields
    end

    # to_input_view :: void -> string
    # to_input_view renders the current Template as an HTML form, meaning
    # it collects and renders the `input_view_file`s of its fields.
    def to_input_view
      return Render.template(binding(), self.input_view_file)
    end

    # to_view :: void -> string
    # to_view renders the current Template as an HTML page, meaning
    # it renders and collects the `page_file` for each of its fields.
    def to_view
      return Render.template(binding(), "#{DirMap.page_views}/#{self.view_file}")
    end

    # render :: string -> string
    # render is a convenience method. It receives a filename and
    # passes that and a binding to the current Template to
    # `Render.template`.
    def render(filename)
      Render.template(binding(), filename)
    end

    # to_yaml :: void -> string
    # to_yaml renders the current Template as YAML and returns the
    # resulting string.
    def to_yaml
      fields = {
        'spec' => self.class.name.last('::'),
      }
      self.fields.each do |k,f|
        fields[k.to_s] = f.get_out_val
      end
      return YAML.dump(fields)
    end

    # make_fields :: [symbol] -> [Field]
    # make_fields receives an array of symbols and returns an array
    # of Fields. Each (subclass of) Template will define its own
    # `fields`, which will be a hash shaped like `{:key => Field}`.
    def make_fields(keys)
      fields = [ ]
      keys.each do |key|
        if (self.fields.has_key?(key))
          fields.push(self.fields[key])
        end
      end
      return fields
    end

  end
end


Base.autoload(:Templates, "#{__dir__}/templates/_autoload.rb")
