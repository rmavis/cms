module Local::Specs::Fields::Meta
  def self.type
    :Compound
  end

  # Meta.fields :: hash -> hash
  def self.fields(attrs = { })
    _attrs = {
      :title => {
        :required => true,
      },
      :date => {
        :required => nil,
      },
      :author => {
        :required => nil,
      },
      :tags => {
        :required => nil,
      },
      :live => {
        :required => nil,
      },
    }.deep_merge(attrs)

    return {
      :title => {:PlainText => _attrs[:title]},
      :date => {:Date => _attrs[:date]},
      :author => {:PlainText => _attrs[:author]},
      :tags => {:Tags => _attrs[:tags]},
      :live => {:Bool => _attrs[:live] },
    }
  end

  def view_file
    "_compound.html.erb"
  end
end
