# A Reference Field points to things.
module Base::Fields
  class Reference < ::Base::Field

    # The Reference field requires to class methods on the spec:
    # spec_prefix :: void -> const
    # make_spec :: const -> a

    # Base::Fields::Reference.make :: (spec, attrs, value) -> Base::Fields::Reference
    # For more, see `Base::Field.make`.
    def self.make(spec, attrs = { }, value = nil)
      ref_spec = "#{spec.spec_prefix}::#{value}".to_const
      if (!ref_spec.is_a?(Module))
        raise "Can't make a reference field to `#{ref_spec}`: that module doesn't exist."
      end
      return super(spec, attrs, spec.make_spec(ref_spec))
    end

    # validate :: a -> Module|nil
    def validate(val)
      raise "A Reference field must define its own `validate` method."
    end

    # Since the `value` for a Reference field will be a Field, just
    # defer the `(view|output)_file` methods to that. A subclass can
    # define its own methods, but this is a sane defualt.

    # view_file :: symbol -> string
    def view_file(type)
      self.value.view_file(type)
    end

    # output_file :: symbol -> string
    def output_file(type)
      self.value.output_file(type)
    end

  end
end
