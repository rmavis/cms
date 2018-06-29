module Templates::Specs::Groups::PagesByTags

  def self.path
    "templates/content/news"
  end

  def self.filter(item)
    return ((item.has_key?(:meta)) &&
            (item[:meta].has_key?(:tags)) &&
            (item[:meta][:tags].include?('news')))
  end

  def self.prepare(items)
    tags = { }
    items.each do |item|
      item.fields[:meta].fields[:tags].value.each do |tag|
        if (!tags.has_key?(tag))
          tags[tag] = [ ]
        end
        tags[tag].push(item)
      end
    end

    groups = [ ]
    tags.keys.sort!.each do |tag|
      groups.push({
                    :tag => tag,
                    :items => tags[tag],
                  })
    end

    return groups
  end

  def view_file
    "pages-by-tags.html.erb"
  end

end
