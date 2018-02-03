  class Field::Compound::Meta < Field::Compound
    # This class doesn't have `page_file` or `form_file` templates.  @TODO

    # Meta.fields :: hash -> hash
    def self.fields(attrs = { })
      _attrs = {
        :title => {
          :required => true,
        },
        :date => {
          :required => nil,
        },
        :author => {
          :required => nil,
        },
        :tags => {
          :required => nil,
        },
      }.deep_merge(attrs)

      return {
        :title => Field::PlainText.new(_attrs[:title]),
        :date => Field::Date.new(_attrs[:date]),
        :author => Field::PlainText.new(_attrs[:author]),
        :tags => Field::Tags.new(_attrs[:tags]),
      }
    end
  end
