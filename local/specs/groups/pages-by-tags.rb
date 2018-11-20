module Local::Specs::Groups::PagesByTags

  def self.content_path
    "#{DirMap.content}/news"
  end

  def self.filter(file)
    if (File.extname(file) == ".yaml")
      content = YAML.load(File.read(file)).transform_keys(lambda {|s| s.to_sym})
      if ((content.has_key?(:meta)) &&
          (content[:meta].has_key?(:live)) &&
          (content[:meta][:live]) &&
          (content[:meta].has_key?(:tags)) &&
          (content[:meta][:tags].is_a?(Array)) &&
          (content[:meta][:tags].include?('news')))
        return content
      else
        return nil
      end
    else
      return nil
    end
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
                    :items => tags[tag].sort! { |a,b| a.fields[:meta].fields[:title].value <=> b.fields[:meta].fields[:title].value },
                  })
    end

    return groups
  end

  # view_file :: symbol -> string
  def view_file(type)
    if (type == :html)
      "#{DirMap.html_views}/content/pages-by-tags.html.erb"
    else
      "#{DirMap.html_views}/content/pages-by-tags.html.erb"
    end
  end

end
