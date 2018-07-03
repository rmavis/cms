module Local::Specs::Fields::Image
  def self.type
    :StaticFile
  end

  def self.content_path
    self.public_path
  end

  def self.public_path
    "#{DirMap.public}/img"
  end

  def self.view_file
    "image.html.erb"
  end

  def get_out_val
    "/#{self.public_path}/#{self.value}"
  end

  # Image.form_file :: void -> string
  # def self.form_file
  #   "#{self.form_files_dir}/image.html.erb"
  # end
end
