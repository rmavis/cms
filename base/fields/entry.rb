module Base::Fields
  class Entry < Reference
    include ::Base::Extendable

    # Entry.make :: (spec, attrs, value) -> Entry
    # For parameter definitions, see `Field.make`.
    # Here, the `spec` is the spec of the Entry Field and the `value`
    # is the slug of the Entry's content file. The Field must define
    # a `content_path` method that returns the directory under which
    # to look for the file.
    def self.make(spec, attrs = { }, value = nil)
      field = self.new(spec, attrs)
      if (!value.nil?)
        field.set_if_valid!(value)
      end
      return field
    end

    # Entry.new :: (spec, attrs) -> Entry
    # For parameter definitions, see `Field.make`.
    def initialize(spec, attrs = { })
      super(spec, attrs)
      extend!(spec, [:content_path])
    end

    # set_if_valid! :: slug -> Entry?
    # slug = a string, when appended to the field spec's `content_path`,
    #   comprises a valid file path
    def set_if_valid!(val)
      if ((val.is_a?(String)) &&
          (path = self.resolve_slug(val)) &&
          (!path.nil?))
        self.set_attr!(:value, self.make_entry(path))
        return self.value
      end

      return nil
    end

    # resolve_slug :: string -> string?
    def resolve_slug(slug)
      if (slug.match(/\.yaml$/i))  # This might need to change. Only yaml?  #TODO
        file = "#{self.spec.content_path}/#{slug}"
      else
        file = "#{self.spec.content_path}/#{slug}.yaml"
      end

      if ((File.exist?(file)) && (File.readable?(file)))
        return file
      else
        return nil
      end
    end

    # make_entry :: string -> Entry
    def make_entry(path)
      return ::Base::Entry.from_file(path)
    end

    # to_view :: symbol -> string
    # Defer to the field's value's `to_view` method.
    def to_view(type)
      return self.value.to_view(type)
    end

  end
end
