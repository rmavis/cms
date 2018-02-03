  # A Compound Field is a Field that contains Fields.
  class Field::Compound < Field
    # new :: (hash, hash) -> Compound
    # Initialize a Compound Field with two attribute hashes: one for
    # the Compound Field itself, and one containing subhashes for
    # each of its component Fields.
    def initialize(attrs = { }, fields_attrs = { })
      super(attrs)
      # The `fields` methods of Compound Fields must have the
      # signature `hash -> hash`. For the argument hash, the keys
      # will name subfields, and the values will be attribute hashes
      # that will, in turn, get passed to each subfield's initializer.
      @fields = self.class.fields(fields_attrs)
    end

    attr_reader :fields

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

    # to_page :: void -> string
    def to_page
      if (self.class.respond_to?(:page_file))
        return Render.template(binding(), self.class.page_file)
      else
        return self.render_fields(:to_page)
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
    def to_form
      if (self.class.respond_to?(:form_file))
        return Render.template(binding(), self.class.form_file)
      else
        return self.render_fields(:to_form)
      end
    end
  end
