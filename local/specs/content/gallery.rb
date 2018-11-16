module Local::Specs::Content::Gallery
  # This is the Template type.
  def self.type
    :View
  end

  # Gallery.fields :: void -> hash
  def self.fields
    {
      :meta => {
        :Meta => {
          :_self => {
            :required => true,
          },
        },
      },
      :body => {
        :BodyBlocks => {
          :_self => {
            :required => true,
          },
        },
      },
     # :news => {
     #    :Entry => {
     #      :spec => :News,
     #      :required => true,
     #      :limit => 2,
     #    },
     #  },
    }
  end

  # view_file :: symbol -> string
  def view_file(type)
    if (type == :html)
      "#{DirMap.html_views}/content/gallery.html.erb"
    else
      "#{DirMap.html_views}/content/gallery.html.erb"
    end
  end

  # view_fields :: void -> [Field]
  def view_fields(type)
    if (type == :html)
      self.make_fields(
        [
          :body,
          :news,
        ]
      )
    else
      self.fields
    end
  end
end
