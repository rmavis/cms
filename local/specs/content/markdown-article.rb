module Local::Specs::Content::MarkdownArticle

  def self.type
    :View
  end

  def self.fields
    ::Local::Specs::Fields::MarkdownFile.fields
  end

  # MarkdownArticle::prepare_content! :: (hash, string) -> hash
  # The content paramater will be altered in-place.
  def self.prepare_content!(content, file)
    # This is necessary.
    content[:spec] = ::Local::Specs::Content::MarkdownArticle

    # This seems a reasonable default.
    if (!content[:meta].has_key?(:slug))
      content[:meta][:slug] = File.basename(file, File.extname(file))
    end

    return content
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
