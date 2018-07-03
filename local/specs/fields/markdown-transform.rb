module Local::Specs::Fields::MarkdownTransform
  def self.type
    :Compound
  end

  def self.fields(attrs = { })
    _attrs = {
      :in => {
        :required => true,
      },
      :out => {
        :required => true,
      },
    }.deep_merge(attrs)

    return {
      :in => {:MarkdownFile => _attrs[:in]},
      :out => {:PlainText => _attrs[:out]},
    }
  end



  def self.content_path
    self.public_path
  end

  def self.public_path
    "#{DirMap.public}/img"
  end

  def self.view_file
    "markdown.html.erb"
  end

  def get_out_val
    "/#{self.public_path}/#{self.value}"
  end
end
