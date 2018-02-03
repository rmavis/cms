module Fields
  class Compound::ImagePair < Field::Compound
    # ImagePair.page_file :: void -> string
    def self.page_file
      "#{self.page_files_dir}/image-pair.html.erb"
    end

    # ImagePair.form_file :: void -> string
    def self.form_file
      "#{self.form_files_dir}/image-pair.html.erb"
    end

    # ImagePair.fields :: hash -> hash
    def self.fields(attrs = { })
      _attrs = {
        :left => {
          :caption => {
            :required => nil,
          },
        },
        :right => {
          :caption => {
            :required => nil,
          },
        },
      }.deep_merge(attrs)

      return {
        :left => Field::Compound::ImageAndText.new(_attrs[:left]),
        :right => Field::Compound::ImageAndText.new(_attrs[:right]),
      }
    end
  end
end
