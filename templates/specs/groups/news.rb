module Templates::Specs::Groups::News

  def self.path
    "templates/content/news"
  end

  def self.filter(item)
    return ((item.has_key?(:meta)) &&
            (item[:meta].has_key?(:tags)) &&
            (item[:meta][:tags].include?('news')))
  end

end
