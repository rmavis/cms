module Local::Specs::Groups::PagesByTags

  def self.content_path
    "#{DirMap.content}/posts"
  end

  def self.filter(file, items)
    if ((File.extname(file) == ".md") ||
        (File.extname(file) == ".text"))
      content = ::Local::Specs::Fields::MarkdownFile.content_from_file(file)
      if ((content.has_key?(:meta)) &&
          (content[:meta].has_key?(:live)) &&
          (content[:meta][:live]) &&
          (content[:meta].has_key?(:index)) &&
          (content[:meta][:index]) &&
          (content[:meta].has_key?(:tags)) &&
          (content[:meta][:tags].is_a?(Array)))
        return ::Local::Specs::Entries::MarkdownArticle.prepare_content!(content, file)
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
      groups.push(
        ::Base::Entry.from_content(
          {
            :spec => ::Local::Specs::Entries::TaggedGroup,
            :slug => "tag-group-#{tag.downcase.gsub(/[^-0-9a-z_]/, '-')}",
            :meta => {
              :title => tag,
            },
            :group => ::Base::Group.new(
              tags[tag].sort! do |a,b|
                a.fields[:meta].fields[:title].value <=> b.fields[:meta].fields[:title].value
              end
            ),
          }
        )
      )
    end
    return groups
  end

  # view_file :: symbol -> string
  def view_file(type)
    if (type == :html)
      "#{DirMap.html_views}/entries/tag-index.html.erb"
    else
      "#{DirMap.html_views}/entries/tag-index.html.erb"
    end
  end

  # output_file :: symbol -> string
  def output_file(type)
    if (type == :html)
      "#{DirMap.public}/#{self.filename}.html"
    else
      "#{DirMap.public}/#{self.filename}.html"
    end
  end

end
