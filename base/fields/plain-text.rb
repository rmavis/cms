module Base::Fields
  class PlainText < ::Base::Field

    # validate :: a -> string|nil
    def validate(val)
      if (val.is_a?(String))
        return val
      elsif (val.is_a?(Numeric))
        return val.to_s
      else
        return nil
      end
    end

  end
end
