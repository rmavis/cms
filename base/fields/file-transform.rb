module Base::Fields
  class FileTransform < Compound

    def self.make(spec, attrs, val)
      field = (attrs.has_key?(:_self)) ? self.new(spec, attrs[:_self]) : self.new(spec)
      field.set_fields!(self.make_subfields(spec, attrs.select { |k,v| k != :_self }, val))

      file = File.open("#{DirMap.public}/#{field.fields[:out].value}", 'w')
      file.write(field.fields[:in].to_view)
      file.close

      return field
    end

    def to_view
      self.fields[:in]
    end

  end
end
