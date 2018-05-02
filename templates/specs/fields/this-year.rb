module Templates::Specs::Fields::ThisYear
  def self.type
    :Number
  end

  def view_file
    "plain-text.html.erb"
  end

  # validate :: a -> string
  def validate(val)
    return Time.now.year
  end
end
