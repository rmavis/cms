# A Field is an object containing a value and other attributes and
# methods for setting, validating, retrieving, and rendering that
# value.
module Base
  class Field
    include Extendable
    include Renderable

    def self.render_dir
      DirMap.field_views
    end

    def self.specs_prefix
      ::Local::Specs::Fields
    end

    def self.fields_prefix
      ::Base::Fields
    end


    # Field.from_plan :: (spec, attrs, val) -> Field
    #   spec = (symbol) the name of the field's template spec
    #          e.g., :Meta, :BodyBlocks, etc.
    #   attrs = (hash) the field's attributes
    #   val = (var) the field's value, which will be set if valid
    def self.from_plan(name, attrs = { }, value = nil)
      if (self.specs_prefix.const_defined?(name))
        spec = "#{self.specs_prefix}::#{name}".to_const
        type = "#{self.fields_prefix}::#{spec.type}".to_const
        return type.make(spec, attrs, value)
      else
        raise "Can't create a `#{name}` field: that module doesn't exist in `#{self.specs_prefix}`."
      end
    end

    # Field.make :: (spec, attrs, value) -> Field
    # For type definitions, see `from_plan`.
    # Subclasses can override this method but those methods must have
    # the same type signature.
    def self.make(spec, attrs = { }, value = nil)
      field = self.new(spec, attrs)
      if (!value.nil?)
        field.set_if_valid!(value)
      end
      return field
    end

    # Field.attrs :: void -> Hash
    # Field.attrs returns a hash of attributes related to the value
    # this Field can hold. Each subclass can set its own `attrs`.
    # If it does, it should merge these in.
    def self.attrs
      {
        :limit => nil,
        :name => nil,
        :required => nil,
        :value => nil,
      }
    end


    # new :: (contant, hash) -> Field
    # Initialize a Field with a hash of atributes. The given hash
    # will be merged with the class's default attributes.
    def initialize(spec, attrs = { })
      self.extend(spec)
      extend!(spec, [:view_file])
      @attrs = self.class.attrs.merge(attrs)
    end

    attr_reader :attrs

    # get_attr :: symbol -> a
    # get_attr receives a key of the current's Field's `attrs` and
    # returns the assciated value.
    def get_attr(attr)
      self.attrs[attr]
    end

    # set_attr! :: (symbol, a) -> a
    # set_attr! receives a key and a value to be set in the current
    # Field's `attrs`, sets it, and returns the given `val`.
    def set_attr!(attr, val)
      self.attrs[attr] = val
    end

    # value :: void -> a
    # value is a convenience method for retrieving the field's `value`
    # from its attributes.
    def value
      self.attrs[:value]
    end

    # get_out_val :: void -> a
    # get_out_val returns the current Field's `value`.
    def get_out_val
      self.attrs[:value]
    end

    # validate :: m -> nil
    # Each Field can implement its own `validate` method which must
    # have the signature `a -> b|nil`.
    def validate(val)
      raise "A Field must define a `validate` method (#{self.class.name})."
    end

    # set_if_valid! :: a -> b|nil
    # set_if_valid! receives a value intended for the current Field.
    # If the value is valid, it will be set and returned. Else, nil.
    def set_if_valid!(val)
      _val = self.validate(val)
      if (_val.nil?)
        if (self.attrs[:required])
          raise "The value given (`#{val}`) for field `#{self.class}` is required but invalid."
        else
          return nil
        end
      else
        self.set_attr!(:value, _val)
        return _val
      end
    end

    # type :: void -> string
    # type returns the last segment of field's class name.
    # The previous segments will be, e.g., `Base::Fields`, etc.
    # It might be better to know the the segments that are safe to
    # strip out rather than assume that only the last one is the
    # most relevant. The user could define arbitrary subclasses.  #TODO
    def type
      self.class.name.split('::').last
    end

    # to_view :: void -> string
    # Each Field can be rendered as (read-only) HTML, intended for a
    # web page. The subclass should specify the filename of the template
    # snippet in its class' `view_file` method.
    # See Renderable.to_view

    # to_form :: void -> string
    # Each Field can be rendered as an input field in an HTML form.
    # The subclass should specify the filename of the template snippet
    # in its class' `form_file` method.
    # web page.
    def to_form
      return Render.template(binding(), self.class.form_file)
    end

    # render :: string -> string
    def render(filename)
      Render.template(binding(), filename)
    end

  end
end


Base.autoload(:Fields, "#{__dir__}/fields/_autoload.rb")
