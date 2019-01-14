module Local::Specs::Fields::Tags

  def self.type
    :List
  end

  # validate :: a -> [string]|nil
  def validate(val)
    if (val.is_a?(Array))
      return val.select { |s| s.is_a?(String) }
    elsif (val.is_a?(String))
      return val.split(',').collect { |s| s.strip }
    else
      return nil
    end
  end

  # view_file :: symbol -> string
  def view_file(type)
    if (type == :html)
      "#{DirMap.html_views}/fields/tags.html.erb"
    else
      "#{DirMap.html_views}/fields/tags.html.erb"
    end
  end

end
