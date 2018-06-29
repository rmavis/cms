# The Template class is the core of the CMS's core functionality.
# The main idea is that a Template contains a collection of Fields,
# and a Field contains a value and other attributes, and these
# Fields can be rendered as an HTML page, form, as YAML, etc. So
# a Template is an object that contains a collection of fields and
# methods for reading and rendering those fields in various ways.
module Base
  class Template
    include Renderable

    def self.specs_prefix
      ::Templates::Specs
    end

    def self.page_specs_prefix
      "#{self.specs_prefix}::Pages"
    end

    def self.base_templates_prefix
      ::Base::Templates
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

      template_spec = "#{self.specs_prefix}::#{content[:spec]}".to_const
      template = "#{self.base_templates_prefix}::#{template_spec.type}".to_const.new(
        template_spec,
        self.make_fields(template_spec, content)
      )
      template.extend(template_spec)

      return template
    end

    # Template.make_fields :: (spec, content) -> Fields
    #   spec = (const) The name of the template spec to build,
    #     e.g. `:Page`
    #   content = (hash) The keys of which will be contained in the
    #     hash returned by the spec's `fields` method, and the values
    #     will be the content to make the `:value` of the newly-created
    #     fields
    #   Fields = (hash) The keys of which will be the same as given by
    #     the content hash, and the values will be Field objects, the
    #     values of which will be the values given by the content hash
    def self.make_fields(template_spec, content = { })
      fields = { }

      template_spec.fields.each do |key,val|
        if (val.is_a?(Symbol))
          if (content.has_key?(key))
            fields[key] = Field.from_plan(val, { }, content[key])
          else
            fields[key] = Field.from_plan(val)
          end
        elsif (val.is_a?(Hash))
          # There should only be one of each `key` in the spec.
          if (content.has_key?(key))
            fields[key] = Field.from_plan(val.keys[0], val.values[0], content[key])
          else
            fields[key] = Field.from_plan(val.keys[0], val.values[0])
          end
        else
          raise "The classes of a Spec's `fields` must be specified as a Symbol or a Hash."
        end
      end

      return fields
    end


    # new :: (const, {Field}) -> Template
    def initialize(spec, fields)
      @spec = spec
      @fields = fields
    end

    attr_reader :spec, :fields

    def set_spec!(spec)
      @spec = spec
    end

    def set_fields!(fields)
      @fields = fields
    end

    # to_input_view :: void -> string
    # to_input_view renders the current Template as an HTML form, meaning
    # it collects and renders the `input_view_file`s of its fields.
    def to_input_view
      return Render.template(binding(), self.input_view_file)
    end

    # to_yaml :: void -> string
    # to_yaml renders the current Template as YAML and returns the
    # resulting string.
    def to_yaml
      fields = {
        'spec' => self.spec_short_name,
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

    def spec_short_name
      return self.spec.to_s.sub("#{Template.specs_prefix}::", '')
    end

  end
end


Base.autoload(:Templates, "#{__dir__}/templates/_autoload.rb")
