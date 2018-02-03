require 'yaml'



  # The Template class is the core of the CMS's core functionality.
  # The main idea is that a Template contains a collection of Fields,
  # and a Field contains a value and other attributes, and these
  # Fields can be rendered as an HTML page, form, as YAML, etc. So
  # a Template is an object that contains a collection of fields and
  # methods for reading and rendering those fields in various ways.
  class Template < Record
    def self.form_file
    end

    def self.page_file
    end

    def self.from_form
    end

    # Template.from_yaml :: string -> Template
    # Template.from_yaml receives a filename containing a Template
    # rendered as YAML, reads that file, and converts it to a Template.
    def self.from_yaml(filename)
      template = nil
      yaml = YAML.load(File.read(filename)).transform_keys(:to_sym)
      yaml.each do |k,v|
        if (k == :template)
          if (::Templates.const_defined?(v))
            template = "::Templates::#{v}".to_const.new
            break
          else
            raise "Error: template named `#{v}` in file `#{filename}` is invalid."
          end
        end
      end

      if (template.nil?)
        raise "Error: no `template` specified in file `#{filename}`."
      end

      template.fields.each do |k,f|
        if (k == :template)
          next
        end
        if (yaml.has_key?(k))
          f.set_if_valid!(yaml[k])
        elsif (f.attrs[:required])
          raise "The required key '#{k}' is missing."
        end
      end
      return template
    end

    # new :: void -> Template
    def initialize
      super(self.class.fields)
    end

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
        'template' => self.class.name.last('::'),
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
