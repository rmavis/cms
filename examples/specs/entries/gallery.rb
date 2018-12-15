module Local::Specs::Entries::Gallery

  # Gallery.type :: void -> symbol
  # This is the base Entry type to base this Spec on.
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
          :text => {
            :required => true,
            :limit => 1,
          }
        },
      },
    }
  end

  # Gallery.content_path :: void -> string
  def self.content_path
    "#{DirMap.content}"
  end

  # Gallery.public_path :: void -> string
  def self.public_path
    "/"
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
