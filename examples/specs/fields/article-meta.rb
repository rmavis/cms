module Local::Specs::Fields::ArticleMeta

  def self.type
    :Compound
  end

  # Meta.fields :: hash -> hash
  def self.fields(attrs = { })
    _attrs = {
      :slug => {
        :required => nil,
      },
      :title => {
        :required => true,
      },
      :author => {
        :required => nil,
      },
      :blurb => {
        :required => nil,
      },
      :tags => {
        :required => nil,
      },
      :datePosted => {
        :required => nil,
      },
      :dateUpdated => {
        :required => nil,
      },
      :index => {
        :required => nil,
      },
      :toc => {
        :required => nil,
      },
      :live => {
        :required => nil,
      },
    }.deep_merge(attrs)

    return {
      :slug => {:PlainText => _attrs[:slug]},
      :title => {:PlainText => _attrs[:title]},
      :author => {:PlainText => _attrs[:author]},
      :blurb => {:PlainText => _attrs[:blurb]},
      :tags => {:Tags => _attrs[:tags]},
      :datePosted => {:Date => _attrs[:datePosted]},
      :dateUpdated => {:Date => _attrs[:dateUpdated]},
      :index => {:Bool => _attrs[:index]},
      :toc => {:Bool => _attrs[:toc]},
      :live => {:Bool => _attrs[:live]},
    }
  end

  # view_file :: symbol -> string
  def view_file(type)
    if (type == :html)
      "#{DirMap.html_views}/fields/_compound.html.erb"
    else
      "#{DirMap.html_views}/fields/_compound.html.erb"
    end
  end

end
