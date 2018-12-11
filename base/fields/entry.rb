module Base::Fields
  class Entry < Reference
    include ::Base::Extendable

    # Entry.make :: (spec, attrs, value) -> Entry
    # For parameter definitions, see `Field.make`.
    def self.make(spec, attrs = { }, value = nil)
      if (!attrs.has_key?(:spec))
        raise "Can't make Entry Field: attributes lack a `:spec`."
      end

      field = self.new(spec, attrs)
      if (!value.nil?)
        field.set_if_valid!(value)
      end
      return field
    end

    # Entry.get_spec :: Symbol -> Constant
    def self.get_spec(spec)
      "#{::Base::Entry.content_specs_prefix}::#{spec}".to_const
    end

    # Entry.new :: attrs -> Entry
    #   attrs = This is the standard attributes hash but it must also
    #           contain a `:spec` key, which must be a symbol that
    #           names the entry's content spec.
    def initialize(spec, attrs = { })
      super(spec, attrs)
      extend!(spec, [:content_path, :public_path])
      @spec = Entry.get_spec(attrs[:spec])
    end

    attr_reader :spec

    # set_if_valid! :: raw -> valid|nil
    #   raw = a string or an array of strings that, when appended to the
    #         content spec's `content_path`, comprise a valid file path
    #   valid = will be identical to `raw`
    def set_if_valid!(val)
      if ((val.is_a?(String)) &&
          (self.is_slug_ok?(val)))
        self.set_attr!(:value, val)

      elsif (val.is_a?(Array))
        if ((self.attrs[:limit].is_a?(Numeric)) &&
            (val.length > self.attrs[:limit]))
          raise "Too many slugs for Entry (#{val.length} given, limit #{self.attrs[:limit]})."
        end

        slugs = [ ]
        val.each do |slug|
          if ((slug.is_a?(String)) &&
              (self.is_slug_ok?(slug)))
            slugs.push(slug)
          else
            return nil
          end
        end
        self.set_attr!(:value, slugs)

      else
        return nil
      end

      return self.value
    end

    # is_slug_ok? :: string -> bool
    def is_slug_ok?(slug)
      file = self.content_file(slug)
      return ((File.exist?(file)) && (File.readable?(file)))
    end

    # content_file :: string -> string
    def content_file(slug)
      "#{self.content_path}/#{slug}.yaml"  # This might need to change.  #TODO
    end

    # path :: void -> string|[string]
    def path
      if (self.value.is_a?(String))
        return self.content_file(slug)
      elsif (self.value.is_a?(Array))
        self.value.collect { |slug| self.content_file(slug) }
      else
        raise "Can't make Entry's path: `value` must be a String or an Array."
      end
    end

    # resolve :: void -> Entry|[Entry]
    def resolve
      if (self.value.is_a?(String))
        return ::Base::Entry.from_file(self.path)
      elsif (self.value.is_a?(Array))
        return self.path.collect { |path| ::Base::Entry.from_file(path) }
      else
        raise "Can't resolve Entry: `value` must be a String or an Array."
      end
    end

    # to_view :: symbol -> string
    def to_view(type)
      entry = self.resolve
      if (entry.is_a?(Array))
        (entry.collect { |_t| _t.to_view(type) }).join("\n")
      else
        return entry.to_view(type)
      end
    end

  end
end
