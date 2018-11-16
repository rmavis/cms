module Local::Specs::Content::Generic
  # This is the Template type.
  def self.type
    :View
  end

  # Generic.fields :: void -> hash
  def self.fields
    {
      :meta => {
        :Meta => {
          :_self => {
            :required => true,
          },
          :author => {
            :required => true,
          },
        },
      },
      :cover_image => :ImageAndText,
      :image_pair => :ImagePair,
      :body => {
        :BodyBlocks => {
          :_self => {
            :required => true,
          },
        },
      },
      :this_year => :ThisYear,
      :make_md5 => :MD5,
    }
  end

  # view_file :: symbol -> string
  def view_file(type)
    if (type == :html)
      "#{DirMap.html_views}/content/generic.html.erb"
    else
      "#{DirMap.html_views}/content/generic.html.erb"
    end
  end

  # body_fields :: void -> [Field]
  # body_fields returns an array of Fields to be included in an
  # HTML page's `body` element. This is called in the template.
  def body_fields
    self.make_fields(
      [
        :cover_image,
        :image_pair,
        :body,
        :this_year,
      ]
    )
  end
end
