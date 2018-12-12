module Local::Specs::Fields::Group

  def self.type
     :Group
  end

  # view_file :: symbol -> string
  # This method was copy-and-pasted and not modified.
  def view_file(type)
    if (type == :html)
      "#{DirMap.html_views}/fields/_compound.html.erb"
    else
      "#{DirMap.html_views}/fields/_compound.html.erb"
    end
  end

  # output_file :: symbol -> string
  # This method was copy-and-pasted and not modified.
  def output_file(type)
    if (type == :html)
      "#{DirMap.public}/tag-index.html"
    else
      "#{DirMap.public}/tag-index.html"
    end
  end

end
