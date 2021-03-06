module Local::Specs::Entries::News

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
    "/news"
  end

  # view_file :: symbol -> string
  def view_file(type)
    if (type == :html)
      "#{DirMap.html_views}/entries/post-news.html.erb"
    else
      "#{DirMap.html_views}/entries/post-news.html.erb"
    end
  end

  # output_file :: symbol -> string
  def output_file(type)
    if (type == :html)
      "#{DirMap.public}#{News.public_path}/#{self.filename}.html"
    else
      "#{DirMap.public}#{News.public_path}/#{self.filename}.html"
    end
  end

end
