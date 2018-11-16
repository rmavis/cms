module Local::Specs::Groups::News

  def self.path
    "local/content/news"
  end

  def self.filter(file)
    if (File.extname(file) == ".yaml")
      content = YAML.load(File.read(file)).transform_keys(lambda {|s| s.to_sym})
      if ((item.has_key?(:meta)) &&
          (item[:meta].has_key?(:live)) &&
          (item[:meta][:live]))
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

  def view_file
    "news-posts.html.erb"
  end

end
