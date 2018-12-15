module Local::Specs::Fields::ImagePair

  # This is the Field type.
  def self.type
    :Compound
  end

  # ImagePair.fields :: hash -> hash
  def self.fields(attrs = { })
    _attrs = {
      :left => {
        :file => {
          :required => true,
        },
        :caption => {
          :required => nil,
        },
      },
      :right => {
        :file => {
          :required => true,
        },
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

  # view_file :: symbol -> string
  def view_file(type)
    if (type == :html)
      "#{DirMap.html_views}/fields/image-pair.html.erb"
    else
      "#{DirMap.html_views}/fields/image-pair.html.erb"
    end
  end

  # ImagePair.form_file :: void -> string
  def self.form_file
    "#{self.form_files_dir}/image-pair.html.erb"
  end

end
