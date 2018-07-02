module Local::Specs::Content::News
  def self.type
    :Post
  end

  def self.fields
    {
      :meta => {
        :Meta => {
          :_self => {
            :required => true,
          },
          :title => {
            :required => true,
          },
          :date => {
            :required => true,
          },
          :author => {
            :required => true,
          },
          :tags => {
            :required => true,
          },
        }
      },
      :body => {
        :BodyBlocks => {
          :_self => {
            :required => true,
          },
        },
      },
    }
  end

  def self.content_path
    "#{DirMap.content}/news"
  end

  def self.public_path
    "#{DirMap.public}/news"
  end

  def self.view_file
    "post-news.html.erb"
  end

  # body_fields :: void -> [Field]
  # body_fields returns an array of Fields to be included in an
  # HTML page's `body` element.
  def body_fields
    self.make_fields(
      [
        :meta,
        :body,
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
      ]
    )
  end
end