module Local::Specs::Groups::MarkdownPages

  def self.content_path
    "#{DirMap.content}/posts"
  end

  def self.field_spec
    ::Local::Specs::Fields::MarkdownFile
  end

  def self.view_spec
    ::Local::Specs::Content::MarkdownArticle
  end

  def self.filter(file)
    content = self.field_spec.content_from_file(file)
    if ((content.has_key?(:meta)) &&
        (content[:meta].has_key?(:live)) &&
        (content[:meta][:live]))
      return self.view_spec.prepare_content!(content, file)
    else
      return nil
    end
  end

  def self.prepare(items)
    return self.sort_by_date(items)
  end

  def self.sort_by_date(items)
    return items.sort do |fieldA, fieldB|
      fieldA.fields[:meta].fields[:datePosted].value <=> fieldB.fields[:meta].fields[:datePosted].value
    end
  end

  # view_file :: symbol -> string
  def view_file(type)
    if (type == :html)
      "#{DirMap.html_views}/content/markdown-posts.html.erb"
    else
      "#{DirMap.html_views}/content/markdown-posts.html.erb"
    end
  end

  # output_file :: symbol -> string
  def output_file(type)
    if (type == :html)
      "#{DirMap.public}/markdown-pages.html"
    else
      "#{DirMap.public}/markdown-pages.html"
    end
  end

end
