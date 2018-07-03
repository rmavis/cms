module Local::Specs::Content::MarkdownArticle
  def self.type
    :Post
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

  def view_file
puts "FIELS: #{self.fields}"
    self.fields[:files].fields[:out].value
  end

  # body_fields :: void -> [Field]
  # body_fields returns an array of Fields to be included in an
  # HTML page's `body` element.
  def body_fields
    self.make_fields(
      [
        :meta,
        :body,
      ]
    )
  end

  # form_fields :: void -> [Field]
  # form_fields returns an array of Fields to be included in an
  # HTML form.
  def form_fields
    self.make_fields(
      [
        :meta,
        :body,
      ]
    )
  end
end
