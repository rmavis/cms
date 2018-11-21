module Local::Specs::Fields::BodyBlocks

  def self.type
    :Collection
  end

  # BodyBlocks.fields :: hash -> hash
  def self.fields(attrs = { })
    _attrs = {
      :image => {
        :required => true,
      },
      :text => {
        :required => true,
      },
    }.deep_merge(attrs)

    return {
      :image => {:ImageAndText => _attrs[:image]},
      :text => {:PlainText => _attrs[:text]},
    }
  end

  # view_file :: symbol -> string
  def view_file(type)
    if (type == :html)
      "#{DirMap.html_views}/fields/_collection.html.erb"
    else
      "#{DirMap.html_views}/fields/_collection.html.erb"
    end
  end

end
