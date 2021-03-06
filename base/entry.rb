# The Entry class is the core of the CMS's core functionality.
# The main idea is that a Entry contains a collection of Fields,
# and a Field contains a value and other attributes, and these
# Fields can be rendered in a variety of view types.
module Base
  class Entry
    include Extendable
    include Renderable

    # Entry.base_entries_prefix :: void -> symbol
    def self.base_entries_prefix
      ::Base::Entries
    end

    # Entry::get_full_spec :: (a, constant) -> constant?
    def self.get_full_spec(spec, bank = self.base_entries_prefix)
      if (spec.is_a?(Module))
        return spec
      elsif (spec.is_a?(Symbol))
        return ModMap.module_from_name(spec, bank)
      elsif (spec.is_a?(String))
        if (spec.slice(0, 2) == '::')
          return self.get_full_spec(spec.to_const, bank)
        else
          return ModMap.module_from_name(spec, bank)
        end
      else
        nil
      end
    end

    # Entry.from_file :: (string, spec?) -> Entry
    # spec = constant
    def self.from_file(path, spec = nil)
      return self.from_content(Content.from_file(path, spec))
    end

    # Entry.from_content :: hash -> Entry
    # In this method, the `content` must specify its own `spec`.
    # That Spec must specify a Base Entry `type` that it's based on.
    def self.from_content(content)
      spec = self.get_full_spec(content[:spec], ModMap.entries)
      return "#{self.base_entries_prefix}::#{spec.type}".to_const.make(spec, content)
    end

    # Entry.make :: (constant, hash) -> Entry
    # Subclasses of Entry can implement their own `make` methods.
    def self.make(spec, content)
      self.new(spec, self.make_fields(spec, content))
    end

    # Entry.make_fields :: (spec, content) -> Fields
    # spec = (constant) The entry spec to build
    #   e.g. `Local::Specs::Content::Generic`
    # content = (hash) The keys of which will be contained in the
    #   hash returned by the spec's `fields` method, and the values
    #   will be the content to make the `:value` of the newly-created
    #   fields
    # Fields = (hash) The keys of which will be the same as given by
    #   the content hash, and the values will be Field objects, the
    #   values of which will be the values given by the content hash
    def self.make_fields(spec, content = { })
      fields = self.get_default_fields(content)

      spec.fields.each do |key,val|
        subspec = Field.subspec(val, ModMap.fields)
        fields[key] = Field.from_plan(
          subspec[:spec],
          subspec[:attrs],
          (content.has_key?(key)) ? content[key] : nil
        )
      end

      return fields
    end

    # Entry.get_default_fields :: (hash) -> hash
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


    # new :: (const, fields) -> Entry
    # fields = a hash mapping symbols to Fields
    def initialize(spec, fields)
      @spec = spec
      self.set_fields!(fields)
      self.extend(spec)
      extend!(spec, [:content_path, :public_path, :view_file])
    end

    attr_reader :spec, :fields

    # set_fields! :: fields -> void
    def set_fields!(fields)
      @fields = fields
      if (self.fields.is_a?(Hash))
        make_readers!(self.fields)
      end
    end

    # set_spec! :: symbol -> void
    def set_spec!(spec)
      @spec = spec
    end

    # spec_short_name :: void -> string
    def spec_short_name
      return self.spec.to_s.sub("#{ModMap.specs}::", '')
    end

    # content_path :: void -> string
    # An Entry's `content_path` should return the local directory
    # where its content file is kept.
    def content_path
      raise "An Entry must define a `content_path` in its Spec."
    end

    # public_path :: void -> string
    # An Entry's `public_path` should return the web-accessible path
    # (less the slug) where it cna be accessed.
    def public_path
      raise "An Entry must define a `public_path` in its Spec."
    end

    # url :: void -> string
    def url
      "#{self.public_path}/#{self.slug}"
    end

    # slug :: void -> string
    def slug
      self.fields[:slug]
    end

    # filename :: symbol? -> string
    def filename(type = nil)
      if (type.nil?)
        self.slug
      else
        "#{self.slug}.#{type}"
      end
    end

    # to_yaml :: void -> string
    # to_yaml renders the current Entry as YAML and returns the
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
    # of Fields. Each (subclass of) Entry will define its own
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


Base.autoload(:Entries, "#{__dir__}/entries/_autoload.rb")
