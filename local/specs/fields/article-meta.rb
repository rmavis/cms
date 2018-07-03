module Local::Specs::Fields::ArticleMeta
  def self.type
    :Compound
  end

  # Meta.fields :: hash -> hash
  def self.fields(attrs = { })
    _attrs = {
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
      :live => {
        :required => nil,
      },
    }.deep_merge(attrs)

    return {
      :title => {:PlainText => _attrs[:title]},
      :author => {:PlainText => _attrs[:author]},
      :blurb => {:PlainText => _attrs[:blurb]},
      :tags => {:Tags => _attrs[:tags]},
      :datePosted => {:Date => _attrs[:datePosted]},
      :dateUpdated => {:Date => _attrs[:dateUpdated]},
      :live => {:Bool => _attrs[:live]},
    }
  end

  def view_file
    "_compound.html.erb"
  end
end
