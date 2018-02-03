  # A Record has fields.
  # A Record's fields are Fields, which contain attributes. One of
  # those attributes is its value.
  class Record
    # new :: [Field] -> Record
    def initialize(fields)
      @fields = fields
    end

    attr_reader :fields
  end
