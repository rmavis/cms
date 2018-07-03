module Local::Specs::Content::News
  def self.type
    :View
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
end
