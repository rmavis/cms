module Templates::Specs::Fields::Image
  def self.type
    :Asset
  end

  # view_file :: void -> string
  def view_file
    "image.html.erb"
  end

  # Image.form_file :: void -> string
  def self.form_file
    "#{self.form_files_dir}/image.html.erb"
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
