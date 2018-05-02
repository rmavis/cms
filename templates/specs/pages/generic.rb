module Templates::Specs::Pages::Generic
  # This is the Template type.
  def self.type
    :Page
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
          :self => {
            :required => true,
          },
        },
      },
      :this_year => :ThisYear,
      :make_md5 => :MD5,
    }
  end

  # Generic.page_file :: void -> string
  def self.page_file
    "#{DirMap.get[:views]}/pages/generic.html.erb"
  end

  # body_fields :: void -> [Field]
  # body_fields returns an array of Fields to be included in an
  # HTML page's `body` element.
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

  # form_fields :: void -> [Field]
  # form_fields returns an array of Fields to be included in an
  # HTML form.
  def form_fields
    self.make_fields(
      [
        :meta,
        :cover_image,
        :image_pair,
        :body,
      ]
    )
  end
end
