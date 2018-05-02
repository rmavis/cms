require_relative 'plain-text.rb'


module Base::Fields
  class Tags < PlainText
    # validate :: a -> [string]|nil
    def self.validate(val)
      if (val.is_a?(Array))
        return val.select { |s| s.is_a?(String) }
      elsif (val.is_a?(String))
        return (val.split(',').map { |s| s.strip })
      else
        return nil
      end
    end
  end
end
