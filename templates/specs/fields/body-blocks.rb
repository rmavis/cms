  class Field::Opts::BodyBlocks < Field::Opts
    # BodyBlocks.fields :: hash -> hash
    def self.fields(attrs = { })
      _attrs = {
        :image => {
          :required => true,
        },
        :text => {
          :required => true,
        },
      }.deep_merge(attrs)

      return {
        :image => Field::Compound::ImageAndText.new(_attrs[:image]),
        :text => Field::PlainText.new(_attrs[:text]),
      }
    end
  end
