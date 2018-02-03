  class FieldType::PlainText < Field
    # FieldType::PlainText::validate :: a -> string|nil
    def self.validate(val)
      if (val.is_a?(String))
        return val
      elsif (val.is_a?(Numeric))
        return val.to_s
      else
        return nil
      end
    end
  end

