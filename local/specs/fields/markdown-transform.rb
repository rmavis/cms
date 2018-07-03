module Local::Specs::Fields::MarkdownTransform
  def self.type
    :FileTransform
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

  def to_view
    self.fields[:in].to_view
  end
end
