module Pages
  class PageGeneric < Base::Page
    # PageGeneric.fields :: void -> hash
    def self.fields
      {
        :meta => Base::Field::Compound::Meta.new(
          {
            :required => true,
          }
        ),
        :cover_image => Base::Field::Compound::ImageAndText.new,
        :image_pair => Base::Field::Compound::ImagePair.new,
        :body => Base::Field::Collection::BodyBlocks.new(
          {
            :required => true
          },
          # {
          #   :image => {:limit => 1}
          # },
        ),
        :this_year => Base::Field::ThisYear.new,
        :make_md5 => Base::Field::MD5.new,
      }
    end

    # PageGeneric.page_file :: void -> string
    def self.page_file
      "templates/pages/generic.html.erb"
    end

    # PageGeneric.form_file :: void -> string
    def self.form_file
      "templates/admin/forms/generic.html.erb"
    end

    # PageGeneric.form_attrs :: void -> hash
    # The form_attrs are used in the form's HTML in a simple key->val
    # pattern for the `form` element's attributes.
    def self.form_attrs
      {
        :action => '/admin/edit/forms/generic',
        :method => 'post',
        :name => 'form--generic',
      }
    end

    # body_fields :: void -> [Field]
    # body_fields returns an array of Fields to be included in an
    # HTML page's `body` element.
    def body_fields
      self.make_fields(
        [
          :cover_image,
          :image_pair,
          :body,
          :this_year,
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
          :cover_image,
          :image_pair,
          :body,
        ]
      )
    end
  end
end
