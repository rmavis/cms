module Local::Specs::Content::MarkdownArticle
  def self.type
    :View
  end

  def self.fields
    {
      :files => :MarkdownTransform,
    }
  end

  # Defer the view to the transform field's view.
  def to_view
    self.fields[:files].to_view
  end
end
