module Local::Specs::Fields::Password
  def self.type
    :PlainText
  end

  # view_file :: symbol -> string
  def view_file(type)
    if (type == :html)
      "#{DirMap.html_views}/fields/password.html.erb"
    else
      "#{DirMap.html_views}/fields/password.html.erb"
    end
  end

  # Password.form_file :: void -> string
  def self.form_file
    "#{self.form_files_dir}/password.html.erb"
  end

  # validate :: a -> string|nil
  def validate(val)
    if ((val.is_a?(String)) &&
        (val.length > 0))
      return val
    else
      return nil
    end
  end
end
