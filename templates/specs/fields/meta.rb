module Templates::Specs::Fields::Meta
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
    }.deep_merge(attrs)

    return {
      :title => {:PlainText => _attrs[:title]},
      :date => {:Date => _attrs[:date]},
      :author => {:PlainText => _attrs[:author]},
      :tags => {:Tags => _attrs[:tags]},
    }
  end

  def view_file
    "_compound.html.erb"
  end
end
