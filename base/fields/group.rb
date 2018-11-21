# A Group Field is a Field whose value is a Group.
# A Group is defined by its items, which is an array of Templates.
# So the value of a Group Field will be the Group.
module Base::Fields
  class Group < ::Base::Field

    def validate(val)
      if (!val.is_a?(::Base::Group))
        return nil
      end

      val.items.each do |item|
        if (!item.is_a?(::Base::Template))
          return nil
        end
      end

      return val
    end

    # def get_out_val
    # end

  end
end
