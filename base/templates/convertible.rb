module Base::Templates
  class Convertible < View

    def self.make(spec, content)
      fields = self.make_fields(spec, content)
      fields = fields.merge(fields[:files].fields[:in].fields)
      return self.new(spec, fields)
    end

  end
end
