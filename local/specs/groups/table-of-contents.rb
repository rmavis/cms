module Local::Specs::Groups::TableOfContents

  def self.content_path
    "#{DirMap.content}/posts"
  end

  def self.filter(file, items)
    content = ::Local::Specs::Fields::MarkdownFile.content_from_file(file)
    if ((content.has_key?(:meta)) &&
        (content[:meta].has_key?(:live)) &&
        (content[:meta][:live]) &&
        (content[:meta].has_key?(:toc)) &&
        (content[:meta][:toc]))
      return ::Local::Specs::Entries::MarkdownArticle.prepare_content!(content, file)
    else
      return nil
    end
  end

  def self.prepare(items)
    return self.sort_by_date(items)
  end

  def self.sort_by_date(items)
    return items.sort do |fieldA, fieldB|
      fieldB.fields[:meta].fields[:datePosted].value <=> fieldA.fields[:meta].fields[:datePosted].value
    end
  end

  # view_file :: symbol -> string
  def view_file(type)
    if (type == :html)
      "#{DirMap.html_views}/groups/table-of-contents.html.erb"
    else
      "#{DirMap.html_views}/groups/table-of-contents.html.erb"
    end
  end

  # output_file :: symbol -> string
  def output_file(type)
    if (type == :html)
      "#{DirMap.public}/includes/table-of-contents.html"
    else
      "#{DirMap.public}/includes/table-of-contents.html"
    end
  end

end
