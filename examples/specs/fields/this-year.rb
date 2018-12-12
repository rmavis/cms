module Local::Specs::Fields::ThisYear
  def self.type
    :Number
  end

  # view_file :: symbol -> string
  def view_file(type)
    if (type == :html)
      "#{DirMap.html_views}/fields/plain-text.html.erb"
    else
      "#{DirMap.html_views}/fields/plain-text.html.erb"
    end
  end

  # validate :: a -> string
  def validate(val)
    return Time.now.year
  end
end
