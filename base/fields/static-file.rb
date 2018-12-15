# A StaticFile Field must define these additional methods:
# content_path: (string) the full directory path where the file
#   is stored
# public_path: (string) the directory relative to the web root
#   where the file can be accessed as in a URL
module Base::Fields
  class StaticFile < Reference
    include ::Base::Extendable

    # StaticFile.make :: (spec, attrs, value) -> StaticFile
    # For more, see `Base::Field.make`.
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

#puts "CHECKING #{self.spec.content_path}/#{val}"
      if (File.exist?("#{self.spec.content_path}/#{val}"))
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
