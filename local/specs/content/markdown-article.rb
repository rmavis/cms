module Local::Specs::Content::MarkdownArticle

  def self.type
    :View
  end

  def self.fields
    ::Local::Specs::Fields::MarkdownFile.fields
  end

  # view_file :: symbol -> string
  def view_file(type)
    if (type == :html)
      "#{DirMap.html_views}/content/markdown-page.html.erb"
    else
      "#{DirMap.html_views}/content/markdown-page.html.erb"
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
