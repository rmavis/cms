require_relative 'plain-text.rb'


module Base::Fields
  class Date < PlainText
    def self.validate(val)
      if ((val.is_a?(String)) &&
          # This could be expanded.  @TODO
          (m = val.match(/([0-9]{4})-([0-9]{2})-([0-9]{2})/)))
        return Time.new(m[1], m[2], m[3])
      elsif (val.respond_to?(:to_time))
        return val.to_time
      elsif (val.is_a?(Time))
        return val
      else
        return nil
      end
    end

    # get_out_val :: void -> string
    def get_out_val
      if (self.attrs[:value].nil?)
        return ''
      else
        self.attrs[:value].strftime("%F")
      end
    end
  end
end
