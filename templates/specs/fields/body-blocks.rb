module Templates::Specs::Fields::BodyBlocks
  def self.type
    :Collection
  end

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
      :image => {:ImageAndText => _attrs[:image]},
      :text => {:PlainText => _attrs[:text]},
    }
  end
end
