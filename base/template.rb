# The Template class is the core of the CMS's core functionality.
# The main idea is that a Template contains a collection of Fields,
# and a Field contains a value and other attributes, and these
# Fields can be rendered as an HTML page, form, as YAML, etc. So
# a Template is an object that contains a collection of fields and
# methods for reading and rendering those fields in various ways.
module Base
  class Template
    include Extendable
    include Renderable

    def self.specs_prefix
      ::Local::Specs
    end

    def self.content_specs_prefix
      "#{self.specs_prefix}::Content"
    end

    def self.base_templates_prefix
      ::Base::Templates
    end

    # Template.make_slug :: string -> hash
    def self.make_slug(filename)
      {
        :slug => File.basename(filename, ".*")
      }
    end

    # Template.check_content_keys!? :: (hash, string?) -> bool
    def self.check_content_keys!(content, source = nil)
      [:spec, :slug].each do |key|
        if (!content.has_key?(key))
          if (source.nil?)
            raise "Error: no `#{key}` specified in content: `#{content.to_s}`."
          else
            raise "Error: no `#{key}` specified for content in `#{source}`."
          end
        end
      end
    end

    # Template.from_yaml :: string -> Template
    def self.from_yaml(filename)
      return self.from_content(
               # If the `slug` is specified in the content, it will
               # take precedence
               self.make_slug(filename).merge(
                 YAML.load(File.read(filename)).transform_keys(lambda {|s| s.to_sym})
               ), filename
             )
    end

    # Template.from_content :: hash -> Template
    def self.from_content(content, source = nil)
      self.check_content_keys!(content, source)

      # If the spec is a string, assume it was read from the content
      # file and is shorthand, meaning it has only the final part of
      # the name. This isn't ideal behavior -- maybe check for the
      # leading `::`?  #TODO
      template_spec = (content[:spec].is_a?(String)) ? "#{self.content_specs_prefix}::#{content[:spec]}".to_const : content[:spec]
      template = "#{self.base_templates_prefix}::#{template_spec.type}".to_const.make(
        template_spec,
        content
      )

      return template
    end

    # Template.make :: (spec, content) -> Template
    def self.make(template_spec, content)
      self.new(
        template_spec,
        self.make_fields(template_spec, content)
      )
    end

    # Template.make_fields :: (spec, content) -> Fields
    #   spec = (const) The name of the template spec to build,
    #     e.g. `:View`
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
      self.extend(spec)
      extend!(spec, [:content_path, :public_path, :view_file])
    end

    attr_reader :spec, :fields

    def set_fields!(fields)
      @fields = fields
    end

    def set_spec!(spec)
      @spec = spec
    end

    def spec_short_name
      return self.spec.to_s.sub("#{Template.specs_prefix}::", '')
    end

    def content_path
      DirMap.content
    end

    def public_path
      DirMap.public
    end

    def filename(type = nil)
      if (type.nil?)
        self.fields[:slug]
      else
        "#{self.fields[:slug]}.#{type}"
      end
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

  end
end


Base.autoload(:Templates, "#{__dir__}/templates/_autoload.rb")
