module Local::Specs::Fields::ImagePair
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

  # view_file :: void -> string
  def view_file
    "image-pair.html.erb"
  end

  # ImagePair.form_file :: void -> string
  def self.form_file
    "#{self.form_files_dir}/image-pair.html.erb"
  end
end
