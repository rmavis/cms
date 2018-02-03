
  class Asset
    # validate :: a -> string|nil
    def self.validate(val)
      if ((val.is_a?(String)) &&
          (File.exist?(val)))
        return val
      else
        return nil
      end
    end
  end

