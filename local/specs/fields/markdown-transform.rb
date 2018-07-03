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


  # The FileTransform class overrides the base Template's `to_view`.
  # That procedure requires `(in|out)put_field` methods from this class.

  def input_field
    self.fields[:in]
  end

  def output_field
    self.fields[:out]
  end
end
