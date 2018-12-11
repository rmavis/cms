module Local::Specs::Groups::RecentNews

  def self.content_path
    "#{DirMap.content}/news"
  end

  def self.filter(file, items)
    if ((items.length < 6) &&
        (File.extname(file) == ".yaml"))
      content = ::Base::Content.from_file(file)
      if ((content.has_key?(:meta)) &&
          (content[:meta].has_key?(:live)) &&
          (content[:meta][:live]))
        return content
      else
        return nil
      end
    else
      return nil
    end
  end

  def self.prepare(items)
    return self.sort_by_date(items)
  end

  def self.sort_by_date(items)
    return items.sort do |fieldA, fieldB|
      fieldA.fields[:meta].fields[:date].value <=> fieldB.fields[:meta].fields[:date].value
    end
  end

  # view_file :: symbol -> string
  def view_file(type)
    if (type == :html)
      "#{DirMap.html_views}/entries/news-posts.html.erb"
    else
      "#{DirMap.html_views}/entries/news-posts.html.erb"
    end
  end

  # output_file :: symbol -> string
  def output_file(type)
    if (type == :html)
      "#{DirMap.public}/news.html"
    else
      "#{DirMap.public}/news.html"
    end
  end

end
