# A Reference Field points to things.
module Base::Fields
  class Reference < ::Base::Field

    # new :: (costant, hash) -> Reference
    def initialize(spec, attrs = { })
      super(spec, attrs)
    end

  end
end
