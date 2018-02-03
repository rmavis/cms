  # A Field is an object containing a value and other attributes and
  # methods for setting, validating, retrieving, and rendering that
  # value.
  class Field
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

    # Field.page_files_dir :: void -> string
    # Field.page_files_dir returns the directory that contains the
    # field templates as snippets of an HTML page.
    def self.page_files_dir
      "templates/fields"
    end

    # Field.form_files_dir :: void -> string
    # Field.form_files_dir returns the directory that contains the
    # field templates as snippets of an HTML form.
    def self.form_files_dir
      "templates/admin/fields"
    end


    # new :: Hash -> Field
    # Initialize a Field with a hash of atributes. The given hash
    # will be merged with the class's default attributes.
    def initialize(attrs = { })
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

    # get_out_val :: void -> a
    # get_out_val returns the current Field's `value`.
    def get_out_val
      self.attrs[:value]
    end

    # validate :: m -> nil
    # Each Field can implement its own `validate` method which must
    # have the signature `a -> b|nil`. If it doesn't, the field's type
    def validate(val)
      begin
        class_name = "FieldType::#{self.class.type.to_s}"
        class_ref = Object.const_get(type_class)
        return class_ref::validate(val)
      rescue Exception => e
        puts "A field must specify a `type` and a `validate` method: #{e.message}"
        return nil
      end
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

    # to_page :: void -> string
    # Each Field can be rendered as (read-only) HTML, intended for a
    # web page. The subclass should specify the filename of the template
    # snippet in its class' `page_file` method.
    def to_page
      return Render.template(binding(), self.class.page_file)
    end

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
