# A Compound Field is a Field that contains Fields.
module Base::Fields
  class Compound < ::Base::Field

    # Compound.make :: (spec, attrs, val) -> Compound
    # For more, see `Field.make`.
    def self.make(spec, attrs = { }, value = nil)
      fields = self.make_subfields(spec, attrs.select { |k,v| k != :_self }, value)
      field = (attrs.has_key?(:_self)) ? self.new(spec, attrs[:_self], fields) : self.new(spec, { }, fields)
      return field
    end

    # Compound.make_subfields :: (spec, attrs, vals) -> subfields
    # For `spec` and `attrs`, see `Field.make`.
    #   vals = A hash of values for the subfields.
    #   subfields = A hash keyed on the same keys as `vals`, with the
    #     values being Fields containing the corresponding values.
    def self.make_subfields(spec, attrs, vals)
      fields = { }
      spec.fields(attrs).each do |key,plan|
        subspec = ::Base::Field.subspec(plan, ModMap.fields)
        field_attrs = (attrs.has_key?(key)) ? subspec[:attrs].merge(attrs[key]) : subspec[:attrs]
        field_val = ((vals.is_a?(Hash)) && (vals.has_key?(key))) ? vals[key] : nil
        fields[key] = ::Base::Field.from_plan(subspec[:spec], field_attrs, field_val)
      end
      return fields
    end

    # new :: (constant, hash, hash|array) -> Compound
    def initialize(spec, attrs = { }, fields = { })
      super(spec, attrs)
      self.set_fields!(fields)
      self.extend(spec)
    end

    attr_reader :fields

    # set_fields! :: hash -> void
    def set_fields!(fields)
      @fields = fields
      make_readers!(self.fields)
    end

    # set_if_valid! :: hash -> true|nil
    # A compound field's subfields can be either simple fields or
    # other compound fields. Either way, the field will have a
    # `set_if_valid!` method.
    # def set_if_valid!(val)
    #   if (!val.is_a?(Hash))
    #     raise "Error: a Compound field must be validated with a Hash."
    #   end
    #   self.fields.each do |k,f|
    #     if (val.has_key?(k))
    #       if (f.set_if_valid!(val[k]).nil?)
    #         return nil
    #       end
    #     elsif (f.attrs[:required])
    #       raise "Error: the required sub-field keyed on `#{k}` is missing."
    #     end
    #   end
    #   return true
    # end

    # get_out_val :: void -> hash
    # get_out_val returns a hash shaped just like the class' `fields`
    # hash but, instead of the Field, the values will be the fields'
    # `value`s.
    def get_out_val
      val = { }
      self.fields.each do |k,f|
        val[k.to_s] = f.get_out_val
      end
      return val
    end

    # to_view :: symbol -> string
    def to_view(type)
      if (self.respond_to?(:view_file))
        return ::Base::Render.template(binding(), self.view_file(type))
      else
        return self.render_fields(:to_view, type)
      end
    end

    # render_fields :: (symbol, symbol) -> string
    # render_fields receives a symbol naming a Field class's render
    # method and the type of view to render. It returns the result
    # of rendering and collecting each subfield with that method.
    def render_fields(meth)
      parts = [ ]
      self.fields.each do |k,f|
        parts.push(f.send(meth, type))
      end
      return parts.join('')
    end

  end
end
