module Templates::Specs::Fields::ThisYear
  def self.type
    :Number
  end

  # validate :: a -> string
  def validate(val)
    return Time.now.year
  end
end
