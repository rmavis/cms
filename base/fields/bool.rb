module Base::Fields
  class Bool < ::Base::Field

    # validate :: a -> string|nil
    def validate(val)
      if (!!val == val)
        return val
      else
        return nil
      end
    end

  end
end
