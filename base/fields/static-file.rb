module Base::Fields
  class StaticFile < Reference
    include ::Base::Extendable

    # A StaticFile's `make` procedure is identical to that of the
    # base field's, so no additional work is required here.
    def self.make(spec, attrs = { }, value = nil)
      field = self.new(spec, attrs)
      if (!value.nil?)
        field.set_if_valid!(value)
      end
      return field
    end

    def initialize(spec, attrs = { })
      super(spec, attrs)
      extend!(spec, [:content_path, :public_path, :view_file])
    end

    # validate :: a -> string|nil
    def validate(val)
      if (!val.is_a?(String))
        return nil
      end

      if (File.exist?("#{self.content_path}/#{val}"))
        return val
      else
        return nil
      end
    end

    # get_out_val :: void -> string
    def get_out_val
      self.attrs[:value]
    end

  end
end
