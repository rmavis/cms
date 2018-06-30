module Templates::Specs::Groups::News

  def self.path
    "templates/content/news"
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

  def view_file
    "news-posts.html.erb"
  end

end
