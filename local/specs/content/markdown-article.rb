module Local::Specs::Content::MarkdownArticle
  def self.type
    :View
  end

  def self.fields
    {
      :files => :MarkdownTransform,
    }
  end

  # to_view :: symbol -> string
  # Defer the view to the transform field's view.
  def to_view(type)
    self.fields[:files].to_view(type)
  end
end
