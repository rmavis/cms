module Base::Fields
  class FileTransform < Compound

    def self.make(spec, attrs, val)
      field = (attrs.has_key?(:_self)) ? self.new(spec, attrs[:_self]) : self.new(spec)
      field.set_fields!(self.make_subfields(spec, attrs.select { |k,v| k != :_self }, val))
      return field
    end

    def output_file(type)
      "#{DirMap.public}/#{self.output_field.value}"
    end

    # to_view :: symbol -> string
    def to_view(type)
      self.make_output!(type)
      return self.output(type)
    end

    # make_output! :: symbol -> void
    def make_output!(type)
      file = File.open(self.output_file(type), 'w')
      file.write(self.input_field.to_view(type))
      file.close
    end

    def output(type)
      return File.read(self.output_file(type))
    end

  end
end
