# A Group Field is a Field whose value is a Group.
# A Group is defined by its items, which is an array of Entries.
# So the value of a Group Field will be the Group.
module Base::Fields
  class Group < ::Base::Field

    # Base::Fields::Group.make :: (spec, attrs, value) -> Base::Fields::Group
    # For more, see `Base::Field.make`.
    # def self.make(spec, attrs = { }, value = nil)
    #   group_spec = ::Base::Group.get_full_spec(value)
    #   if (group_spec.nil?)
    #     raise "Can't make a `#{spec}` group field: that module doesn't exist in `#{::Base::Group.specs_prefix}`."
    #   end
    #   return super(group_spec, attrs, ::Base::Group.from_spec(group_spec))
    # end

    # validate :: a -> Group?
    def validate(val)
      if (!val.is_a?(::Base::Group))
        return nil
      end

      val.items.each do |item|
        if (!item.is_a?(::Base::Entry))
          return nil
        end
      end

      return val
    end

    # This is a convenience method for accessing a group field's items.
    # Because the `value` of a group field is a Group.
    def items
      self.attrs[:value].items
    end

  end
end
