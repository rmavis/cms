module Base::Fields
  class List < PlainText

    # validate :: a -> [b]|nil
    def validate(val)
      if (val.is_a?(Array))
        return val
      else
        return nil
      end
    end

    # def each(block)
    #   self.get_attr(:value).each do |val|
    #     block.call(val)
    #   end
    # end

  end
end
