module Base::Fields
  class ReadableFile < Compound

    def self.make(spec, attrs, filename)
      path = "#{DirMap.root}/#{filename}"
      if (!File.exist?(path))
        raise "Can't read from readable file `#{path}`: it doesn't exist."
      end

      field = (attrs.has_key?(:_self)) ? self.new(spec, attrs[:_self]) : self.new(spec)
      field.set_fields!(self.make_subfields(spec, attrs.select { |k,v| k != :_self }, spec.read(path)))
      return field
    end

  end
end
