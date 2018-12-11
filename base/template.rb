# The Template class is the core of the CMS's core functionality.
# The main idea is that a Template contains a collection of Fields,
# and a Field contains a value and other attributes, and these
# Fields can be rendered in a variety of view types.
module Base
  class Template
    include Extendable
    include Renderable

    # Template.specs_prefix :: void -> symbol
    def self.specs_prefix
      ::Local::Specs
    end

    # Template.content_specs_prefix :: void -> string
    def self.content_specs_prefix
      "#{self.specs_prefix}::Content"
    end

    # Template.base_templates_prefix :: void -> symbol
    def self.base_templates_prefix
      ::Base::Templates
    end

    # Template::get_full_spec :: a -> constant?
    def self.get_full_spec(spec)
      # If the spec is a string, assume it was read from the content
      # file and is shorthand, meaning it has only the final part of
      # the name. This isn't ideal behavior -- maybe check for the
      # leading `::`?  #TODO
      if (spec.is_a?(String))
        "#{self.content_specs_prefix}::#{spec}".to_const
      elsif (spec.is_a?(Symbol))
        spec.to_s.to_const
      elsif (spec.is_a?(Module))
        spec
      else
        nil
      end
    end

    # Template.from_file :: (string, spec?) -> Template
    # spec = constant
    def self.from_file(path, spec = nil)
      return self.from_content(Content.from_file(path, spec))
    end

    # Template.from_content :: hash -> Template
    # In this method, the `content` must specify its own `spec`.
    # That Spec must specify a Base Template `type` that it's based on.
    def self.from_content(content)
      spec = self.get_full_spec(content[:spec])
      return "#{self.base_templates_prefix}::#{spec.type}".to_const.make(spec, content)
    end

    # Template.make :: (constant, hash) -> Template
    # Subclasses of Template can implement their own `make` methods.
    def self.make(spec, content)
      self.new(spec, self.make_fields(spec, content))
    end

    # Template.make_fields :: (spec, content) -> Fields
    #   spec = (constant) The template spec to build
    #     e.g. `Local::Specs::Content::Generic`
    #   content = (hash) The keys of which will be contained in the
    #     hash returned by the spec's `fields` method, and the values
    #     will be the content to make the `:value` of the newly-created
    #     fields
    #   Fields = (hash) The keys of which will be the same as given by
    #     the content hash, and the values will be Field objects, the
    #     values of which will be the values given by the content hash
    def self.make_fields(spec, content = { })
      fields = self.get_default_fields(content)

      spec.fields.each do |key,val|
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

    # Template.get_default_fields :: (hash) -> hash
    def self.get_default_fields(content)
      fields = { }

      Content.default_fields.each_pair do |key,val|
        if (content.has_key?(key))
          fields[key] = content[key]
        else
          fields[key] = val
        end
      end

      return fields
    end


    # new :: (const, fields) -> Template
    # fields = a hash mapping symbols to Fields
    def initialize(spec, fields)
      @spec = spec
      @fields = fields
      self.extend(spec)
      extend!(spec, [:content_path, :public_path, :view_file])
    end

    attr_reader :spec, :fields

    # set_fields! :: fields -> void
    def set_fields!(fields)
      @fields = fields
    end

    # set_spec! :: symbol -> void
    def set_spec!(spec)
      @spec = spec
    end

    # spec_short_name :: void -> string
    def spec_short_name
      return self.spec.to_s.sub("#{Template.specs_prefix}::", '')
    end

    # content_path :: void -> string
    def content_path
      DirMap.content
    end

    # public_path :: void -> string
    def public_path
      DirMap.public
    end

    # filename :: symbol? -> string
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
