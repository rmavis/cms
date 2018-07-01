module Local::Specs::Content::Gallery
  # This is the Template type.
  def self.type
    :Page
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

  # view_file :: void -> string
  def self.view_file
    "gallery.html.erb"
  end

  # body_fields :: void -> [Field]
  # body_fields returns an array of Fields to be included in an
  # HTML page's `body` element.
  def body_fields
    self.make_fields(
      [
        :body,
        :news,
      ]
    )
  end

  # form_fields :: void -> [Field]
  # form_fields returns an array of Fields to be included in an
  # HTML form.
  def form_fields
    self.make_fields(
      [
        :meta,
        :body,
        :news,
      ]
    )
  end
end
