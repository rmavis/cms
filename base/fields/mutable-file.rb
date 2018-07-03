module Base::Fields
  class MutableFile < Compound

    def self.make(spec, attrs, filename)
      path = "#{DirMap.root}/#{filename}"
      if (!File.exist?(path))
        raise "Can't read from mutable file `#{path}`: it doesn't exist."
      end
      field = (attrs.has_key?(:_self)) ? self.new(spec, attrs[:_self]) : self.new(spec)
      fields = { }

      vals = spec.mutate(path)


      field.set_fields!(fields)
      return field
    end



  end
end
