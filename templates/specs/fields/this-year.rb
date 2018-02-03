module Fields
  class ThisYear < Field::PlainText
    # validate :: a -> string
    def validate(val)
      return Time.now.year
    end
  end
end
