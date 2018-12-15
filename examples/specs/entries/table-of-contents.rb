module Local::Specs::Entries::TableOfContents

  def self.type
    :View
  end

  def self.fields
    {
      :meta => {
        :Meta => {
          :_self => {
            :required => nil,
          },
          :title => {
            :required => true,
          },
        },
      },
      :group => :GroupName,
    }
  end

  # view_file :: symbol -> string
  def view_file(type)
    if (type == :html)
      "#{DirMap.html_views}/entries/table-of-contents.html.erb"
    else
      "#{DirMap.html_views}/entries/table-of-contents.html.erb"
    end
  end

  # output_file :: symbol -> string
  def output_file(type)
    if (type == :html)
      "#{DirMap.public}/pages/table-of-contents.html"
    else
      "#{DirMap.public}/pages/table-of-contents.html"
    end
  end

end
