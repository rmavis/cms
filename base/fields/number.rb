module Base::Fields
  class Number < ::Base::Field
    # validate :: a -> [string]|nil
    def self.validate(val)
      if (val.is_a?(Numeric))
        return val
      elsif (val.is_a?(String))
        if (val.match(/^[0-9]+$/))
          return val.to_i
        elsif (val.match(/^[\.0-9]+$/))
          return val.to_f
        else
          return nil
        end
      else
        return nil
      end
    end
  end
end
