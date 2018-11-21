module Local::Specs::Content::TaggedGroup

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
      :group => {
        :Group => {
          :_self => {
            :required => true,
          },
        },
      },
    }
  end

  # view_file :: symbol -> string
  # This method was copy-and-pasted and not modified.
  def view_file(type)
    if (type == :html)
      "#{DirMap.html_views}/content/tagged-group.html.erb"
    else
      "#{DirMap.html_views}/content/tagged-group.html.erb"
    end
  end

  # output_file :: symbol -> string
  def output_file(type)
    if (type == :html)
      "#{DirMap.public}/#{self.filename}.html"
    else
      "#{DirMap.public}/#{self.filename}.html"
    end
  end

end
