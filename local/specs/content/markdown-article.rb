module Local::Specs::Content::MarkdownArticle
  def self.type
    :Convertible
  end

  def self.fields
    {
      :files => {
        :MarkdownTransform => {
          :in => {
            :required => true,
          },
          :out => {
            :required => true,
          },
        },
      }
    }
  end

  def to_view
    self.fields[:files].fields[:in].to_view
  end
end
