module Local::Specs::Groups::MarkdownPages

  def self.path
    "local/content/posts"
  end

  def self.page_spec
    ::Local::Specs::Fields::MarkdownFile
  end

  def self.filter(file)
    content = self.page_spec.read(file)
    if ((content.has_key?(:meta)) &&
        (content[:meta].has_key?(:live)) &&
        (content[:meta][:live]))
      return self.prepare_content(content, file)
    else
      return nil
    end
  end

  def self.prepare_content!(item, file)
    # This is necessary.
    item[:spec] = self.page_spec

    # This seems a reasonable default.
    if (!item[:meta].has_key?(:slug))
      item[:meta][:slug] = File.basename(file, File.extname(file))
    end

    return item
  end

  def self.prepare(items)
    return self.sort_by_date(items)
  end

  def self.sort_by_date(items)
    return items.sort do |fieldA, fieldB|
      fieldA.fields[:meta].fields[:datePosted].value <=> fieldB.fields[:meta].fields[:datePosted].value
    end
  end

  def view_file
    "markdown-pages.html.erb"
  end

end
