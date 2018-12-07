module Local::Specs::Fields::GroupName

  def self.type
     :Reference
  end

  # spec_prefix :: void -> const
  def self.spec_prefix
    ::Local::Specs::Groups
  end

  # make_spec :: const -> Base::Group
  def self.make_spec(spec)
    ::Base::Group.from_spec(spec)
  end

  def validate(val)
    if (val.is_a?(::Base::Group))
      return val
    else
      return nil
    end
  end

  # This is a convenience method for accessing the field value's items.
  # The field's value will be a Group. A Group has `items`.
  def items
    self.attrs[:value].items
  end

end
