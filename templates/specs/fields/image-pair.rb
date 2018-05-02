module Templates::Specs::Fields::ImagePair
  # This is the Field type.
  def self.type
    :Compound
  end

  # ImagePair.fields :: hash -> hash
  def self.fields(attrs = { })
    _attrs = {
      :left => {
        :caption => {
          :required => nil,
        },
      },
      :right => {
        :caption => {
          :required => nil,
        },
      },
    }.deep_merge(attrs)

    return {
      :left => {:ImageAndText => _attrs[:left]},
      :right => {:ImageAndText => _attrs[:right]},
    }
  end

  # ImagePair.page_file :: void -> string
  def self.page_file
    "#{self.page_files_dir}/image-pair.html.erb"
  end

  # ImagePair.form_file :: void -> string
  def self.form_file
    "#{self.form_files_dir}/image-pair.html.erb"
  end
end
