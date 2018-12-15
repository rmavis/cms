module Local::Specs::Fields::Image

  def self.type
    :StaticFile
  end

  def self.content_path
    "#{DirMap.public}#{self.public_path}"
  end

  def self.public_path
    "/img"
  end

  # view_file :: symbol -> string
  def view_file(type)
    if (type == :html)
      "#{DirMap.html_views}/fields/image.html.erb"
    else
      "#{DirMap.html_views}/fields/image.html.erb"
    end
  end

  def get_out_val
    "#{self.public_path}/#{self.value}"
  end

end
