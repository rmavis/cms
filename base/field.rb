# A Field is an object containing a value and other attributes and
# methods for setting, validating, retrieving, and rendering that
# value.
module Base
  class Field
    include Extendable
    include Renderable

    # Field.fields_prefix :: void -> symbol
    def self.fields_prefix
      ::Base::Fields
    end

    # Field.get_full_spec :: (name, bank) -> constant
    # name = (module|string|symbol|hash) name of a module.
    #   If a hash, it should be one used in an Entry or compound
    #   Field's Spec to specify rules/attributes for a Field.
    # bank = (constant) naming the module the `name` is under
    def self.get_full_spec(name, bank = self.fields_prefix)
      if (name.is_a?(Module))
        return name
      elsif (name.is_a?(String))
        return self.module_from_name(name.to_sym, bank)
      elsif (name.is_a?(Symbol))
        return self.module_from_name(name, bank)
      elsif (name.is_a?(Hash))
        if (name.keys.length > 1)
          raise "A Field's plan must contain just one key."
        end
        return self.module_from_name(name.keys[0], bank)
      else
        raise "Can only deduce a Field's module name from a string, symbol, or single-key hash."
      end
    end

    # Field.module_from_name :: (name, bank) -> constant
    # name = (string|symbol) name of the individual module
    # bank = (constant) naming the module the `name` is under
    def self.module_from_name(name, bank = ModMap.fields)
      if (!bank.const_defined?(name))
        raise "The module '#{name}' doesn't exist in '#{bank}'."
      end
      return "#{bank}::#{name}".to_const
    end

    # Field.subspec :: ((symbol|hash), bank) -> subspec
    # bank = see `get_full_spec`
    # subspec = A hash containing three keys:
    #   name = (symbol) the Spec's shortname
    #   spec = (constant) the Spec's full module name
    #   attrs = (hash)
    def self.subspec(plan, bank = self.fields_prefix)
      if (plan.is_a?(Symbol))
        return {
          :name => plan,
          :spec => self.get_full_spec(plan, bank),
          :attrs => { },
        }
      elsif (plan.is_a?(Hash))
        if (plan.keys.length > 1)
          raise "A Field's subspec must contain just one key."
        end
        if (!plan.values[0].is_a?(Hash))
          raise "A Field's subspec must specify attributes as a hash."
        end
        return {
          :name => plan.keys[0].to_sym,
          :spec => self.get_full_spec(plan, bank),
          :attrs => plan.values[0],
        }
      else
        raise "A Field's subspec must be a symbol or a hash."
      end
    end

    # Field.from_plan :: (spec, attrs, val) -> Field
    # spec = (symbol) the name of the field's entry spec
    #   e.g., :Meta, :BodyBlocks, etc.
    # attrs = (hash) the field's attributes
    # val = (var) the field's value, which will be set if valid
    def self.from_plan(name, attrs = { }, value = nil)
      spec = self.get_full_spec(name, ModMap.fields)
      type = self.module_from_name(spec.type, self.fields_prefix)
      return type.make(spec, attrs, value)
    end

    # Field.make :: (spec, attrs, value) -> Field
    # spec = Constant (module name)
    # attrs = (hash) the field's attributes
    # val = (var) the field's value, which will be set if valid
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
    # Initialize a Field with a spec and an attributes hash. The
    # given hash will be merged with the class's default attributes.
    def initialize(spec, attrs = { })
      self.extend(spec)
      extend!(spec, [:view_file])
      @attrs = self.class.attrs.merge(attrs)
      @type = spec.to_s.split('::').last
    end

    attr_reader :attrs, :type

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
      end

      self.set_attr!(:value, _val)
      return _val
    end

    # validate :: m -> nil
    # Each Field can implement its own `validate` method which must
    # have the signature `a -> b|nil`.
    def validate(val)
      raise "A Field must define a `validate` method (#{self.class.name})."
    end

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

  end
end


Base.autoload(:Fields, "#{__dir__}/fields/_autoload.rb")
