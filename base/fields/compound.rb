# A Compound Field is a Field that contains Fields.
module Base::Fields
  class Compound < ::Base::Field

    # Compound.make :: (spec, attrs, val) -> Compound
    # For more, see `Field.make`.
    def self.make(spec, attrs = { }, value = nil)
      field = (attrs.has_key?(:_self)) ? self.new(attrs[:_self]) : self.new()
      field.extend(spec)
puts "MAKING COMPOUND FIELD: '#{spec}' :: '#{attrs}' :: '#{value}'"
      fields = { }
      spec.fields(attrs.select { |k,v| k != :_self }).each do |key,plan|
puts "MAKING SUBFIELD: '#{key}' :: '#{plan}'"
        field_type = plan.keys[0]
        field_attrs = (attrs.has_key?(key)) ? plan.values[0].merge(attrs[key]) : plan.values[0]
        field_val = ((value.is_a?(Hash)) && (value.has_key?(:nil))) ? 'ok' : 'nok'
        fields[key] = ::Base::Field.from_plan(field_type, field_attrs, field_val)
      end
      field.set_fields!(fields)

      return field
    end

    # new :: hash -> Compound
    def initialize(attrs = { })
      super(attrs)
      @fields = { }
    end

    attr_reader :fields

    def set_fields!(fields)
      @fields = fields
    end

    # set_if_valid! :: hash -> true|nil
    # A compound field's subfields can be either simple fields or
    # other compound fields. Either way, the field will have a
    # `set_if_valid!` method.
    def set_if_valid!(val)
      if (!val.is_a?(Hash))
        raise "Error: a Compound field must be validated with a Hash."
      end

      self.fields.each do |k,f|
        if (val.has_key?(k))
          if (f.set_if_valid!(val[k]).nil?)
            return nil
          end
        elsif (f.attrs[:required])
          raise "Error: the required sub-field keyed on `#{k}` is missing."
        end
      end
      return true
    end

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

    # to_view :: void -> string
    def to_view
      if (self.respond_to?(:view_file))
        return ::Base::Render.template(binding(), "#{DirMap.field_views}/#{self.view_file}")
      else
        return self.render_fields(:to_view)
      end
    end

    # render_fields :: symbol -> string
    # render_fields receives a symbol naming a Field class's render
    # method. It returns the result of rendering and collecting each
    # subfield with that method.
    def render_fields(meth)
      parts = [ ]
      self.fields.each do |k,f|
        parts.push(f.send(meth))
      end
      return parts.join('')
    end

    # to_form :: void -> string
    # def to_form
    #   if (self.respond_to?(:form_file))
    #     return ::Base::Render.template(binding(), self.form_file)
    #   else
    #     return self.render_fields(:to_form)
    #   end
    # end

  end
end
