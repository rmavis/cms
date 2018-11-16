module Local::Specs::Groups::News

  def self.content_path
    "#{DirMap.content}/news"
  end

  def self.filter(item)
    return ((item.has_key?(:meta)) &&
            (item[:meta].has_key?(:live)) &&
            (item[:meta][:live]))
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
      "#{DirMap.html_views}/content/news-posts.html.erb"
    else
      "#{DirMap.html_views}/content/news-posts.html.erb"
    end
  end

end
