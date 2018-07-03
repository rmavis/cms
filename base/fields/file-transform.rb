module Base::Fields
  class FileTransform < Compound

    def self.make(spec, attrs, val)
      field = (attrs.has_key?(:_self)) ? self.new(spec, attrs[:_self]) : self.new(spec)
      field.set_fields!(self.make_subfields(spec, attrs.select { |k,v| k != :_self }, val))
      return field
    end

    def output_file
      "#{DirMap.public}/#{self.output_field.value}"
    end

    def to_view
      self.make_output!
      return self.output
    end

    def make_output!
      file = File.open(self.output_file, 'w')
      file.write(self.input_field.to_view)
      file.close
    end

    def output
      return File.read(self.output_file)
    end

  end
end
