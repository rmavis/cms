module Templates::Specs::Fields::Tags
  def self.type
    :Tags
  end

  # view_file :: void -> string
  def view_file
    "tags.html.erb"
  end

  # Tags.form_file :: void -> string
  def self.form_file
    "#{self.form_files_dir}/tags.html.erb"
  end

  # validate :: a -> [string]|nil
  def validate(val)
    if (val.is_a?(Array))
      return val.select { |s| s.is_a?(String) }
    elsif (val.is_a?(String))
      return (val.select { |s| s.is_a?(String) })
    else
      return nil
    end
  end
end
