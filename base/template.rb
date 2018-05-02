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

      template_spec = "#{self.specs_prefix}::#{content[:spec]}".to_const
      fields = self.load_fields(template_spec)
      template = "Base::Templates::#{template_spec.type}".to_const.new(fields)
      template.extend(template_spec)

      template_spec.fields.each do |key,_val|
        if (content.has_key?(key))
          template.fields[key].set_if_valid!(content[key])
        elsif (template.fields[key].attrs[:required])
          raise "The required key `#{key}` is missing."
        end
      end

      return template
    end

    # Template.load_fields :: Spec -> {Fields}
    # The keys of the Fields hash will be identical to the Spec's
    # `fields` hash, but the values will be with Field objects.
    def self.load_fields(template_spec)
      fields = { }

      template_spec.fields.each do |key,val|
        if (val.is_a?(Symbol))
          fields[key] = Field.from_plan(val)
        elsif (val.is_a?(Hash))
          val.each do |_key,_val|
            fields[key] = Field.from_plan(_key, _val)
          end
        else
          raise "The classes of a Spec's `fields` must be specified as a Symbol or a Hash."
        end
      end

      puts fields
      return fields
    end

    # new :: {Fields} -> Template
    def initialize(fields)
      @fields = fields
    end

    attr_reader :fields

    # to_form :: void -> string
    # to_form renders the current Template as an HTML form, meaning
    # it renders and collects the `form_file` for each of its fields.
    def to_form
      return Render.template(binding(), self.class.form_file)
    end

    # to_page :: void -> string
    # to_page renders the current Template as an HTML page, meaning
    # it renders and collects the `page_file` for each of its fields.
    def to_page
      return Render.template(binding(), self.class.page_file)
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
        if (self.class.fields.has_key?(key))
          fields.push(self.fields[key])
        end
      end
      return fields
    end

  end
end


Base.autoload(:Templates, "#{__dir__}/templates/_autoload.rb")
