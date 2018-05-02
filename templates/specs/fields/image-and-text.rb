module Templates::Specs::Fields::ImageAndText
  def self.type
    :Compound
  end

  # ImageAndText.fields :: hash -> hash
  def self.fields(attrs = { })
    _attrs = {
      :file => {
        :required => true,
      },
      :caption => {
        :required => nil,
      },
    }.deep_merge(attrs)

    return {
      :file => {:Image => _attrs[:file]},
      :caption => {:PlainText => _attrs[:caption]},
    }
  end

  # ImageAndText.page_file :: void -> string
  def self.page_file
    "#{self.page_files_dir}/image-and-text.html.erb"
  end

  # ImageAndText.form_file :: void -> string
  def self.form_file
    "#{self.form_files_dir}/image-and-text.html.erb"
  end
end
