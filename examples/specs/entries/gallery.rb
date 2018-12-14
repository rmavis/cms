module Local::Specs::Entries::Gallery

  # This is the Entry type.
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

  def self.content_path
    "#{DirMap.content}"
  end

  def self.public_path
    "/"
  end

  # view_fields :: void -> [Field]
  def view_fields(type)
    if (type == :html)
      self.make_fields(
        [
          :body,
          # :news,
        ]
      )
    else
      self.fields
    end
  end

  # view_file :: symbol -> string
  def view_file(type)
    if (type == :html)
      "#{DirMap.html_views}/entries/gallery.html.erb"
    else
      "#{DirMap.html_views}/entries/gallery.html.erb"
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
