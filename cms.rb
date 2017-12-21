module Base

  class Utils
    def self.make_html(tag, attrs = { }, body = '')
      parts = [ ]
      attrs.each { |key,val| parts.push("#{key}=\"#{val}\"") }

      if ((body.length == 0) &&
          (['area',
            'base',
            'br',
            'col',
            'embed',
            'hr',
            'img',
            'input',
            'link',
            'meta',
            'param',
            'source',
            'track',
            'wbr'].include?(tag)))
        return "<#{tag} #{parts.join(' ')} />"
      else
        return "<#{tag} #{parts.join(' ')}>#{body}</#{tag}>"
      end
    end
  end



  # A Record contains fields.
  class Record
    # new :: Hash -> Record
    def initialize(fields = { })
      @fields = fields
      # fields.each do |k,v|
      #   # Setter.
      #   self.class.send(
      #     :define_method,
      #     "#{k}=".to_sym,
      #     Proc.new do |val|
      #       self.instance_variable_set("@#{k}".to_sym, val)
      #     end
      #   )
      #   # Getter.
      #   self.class.send(
      #     :define_method,
      #     "#{k}".to_sym,
      #     Proc.new do
      #       self.instance_variable_get("@#{k}")
      #     end
      #   )
      #   # Set it.
      #   self.send("#{k}=".to_sym, v)
      # end
    end

    attr_reader :fields

    def fill_values(opts = { })
      puts "FILLING '#{opts}' in '#{self.fields}'"

      opts.each do |k,v|
        if (self.class.method_defined?(k))
          if ((self.send(k).is_a?(Record)) &&
              (v.is_a?(Hash)))
            self.send(k).send(:fill_values, v)
          else
            self.send("#{k}=".to_sym, v)
          end
        else
          raise ArgumentError, "Record lacks the given '#{k}' field."
        end
      end
    end
  end



  class Template < Record
    def self.form_file
    end

    def self.page_file
    end

    def self.from_form
    end

    def self.from_yaml
    end

    def initialize(opts = { })
      super(self.class.fields)
      self.fill_values(opts)
    end

    def to_form
    end

    def to_page
    end

    def to_yaml
    end
  end



  class Form < Template
  end



  class Form::Field < Record
    # Field::value_type :: void -> nil
    # Subclasses should set their own `value_type`s.
    def self.value_type
      nil
    end

    # Field::validate :: m -> n|nil
    # Subclasses should implement their own `validate` methods.
    def self.validate(val)
      if (val.is_a?(self.value_type))
        return val
      else
        return nil
      end
    end

    # Field::required_attrs :: void -> Hash
    def self.required_attrs
      {
        :name => nil,
        :required => nil,
        :value => nil,
        :limit => 1,
      }
    end


    # new :: Hash -> Field
    def initialize(opts)
      super(Form::Field::required_attrs.merge(opts))
    end

    # to_html :: (String, Hash?) -> string
    # Subclasses should implement their own `to_html` methods.
    def to_html(tag, attrs = { })
      Utils::make_html(tag, attrs)
    end
  end



  class Form::Field::PlainText < Form::Field
    # PlainText::value_type :: void -> Class
    def self.value_type
      String
    end

    # PlainText::validate :: s -> String|nil
    def self.validate(val)
      if ((val.is_a?(self.value_type)) &&
          (val.length > 0))
        return val
      elsif (val.is_a?(Numeric))
        return val.to_s
      else
        return nil
      end
    end

    # to_html :: Hash? -> String
    def to_html(attrs = { })
      super('input', attrs.merge({:value => self.value}))
    end
  end



  class Form::Field::Date < Form::Field::PlainText
    # Date::value_type :: void -> Class
    def self.value_type
      Time
    end

    # Date::validate :: s -> String|nil
    def self.validate(val)
      if ((val.is_a?(self.value_type)) &&
          (val.length > 0))
        return val
      elsif (val.is_a?(Numeric))
        return val.to_s
      else
        return nil
      end
    end

    # to_html :: Hash? -> String
    def to_html(attrs = { })
      super(attrs.merge({:type => 'date'}))
    end

    # Might want to add a `clean` or whatever method that returns
    # a string form of the Time `value` for the content file.  @TODO
  end



  class Form::Field::Image < Form::Field::PlainText
    # Image::value_type :: void -> Class
    def self.value_type
      String
    end

    # Image::validate :: s -> String|nil
    def self.validate(val)
      if ((val.is_a?(self.value_type)) &&
          (val.length > 0))
        return val
      elsif (val.is_a?(Numeric))
        return val.to_s
      else
        return nil
      end
    end

    # to_html :: Hash? -> String
    def to_html(attrs = { })
      super(attrs.merge({:type => 'file'}))
    end
  end



  class Form::Field::Password < Form::Field::PlainText
    # Password::validate :: s -> String|nil
    def self.validate(val)
      if ((val.is_a?(self.value_type)) &&
          (val.length > 0))
        return val
      elsif (val.is_a?(Numeric))
        return val.to_s
      else
        return nil
      end
    end

    # to_html :: Hash? -> String
    def to_html(attrs = { })
      super(attrs.merge({:type => 'password'}))
    end
  end



  class Form::Field::Tags < Form::Field::PlainText

    # Tags::value_type :: void -> Class
    def self.value_type
      Array
    end

    # Tags::validate :: s -> String|nil
    def self.validate(val)
      if ((val.is_a?(self.value_type)) &&
          (val.length > 0))
        return val
      elsif (val.is_a?(Numeric))
        return val.to_s
      else
        return nil
      end
    end

    # to_html :: Hash? -> String
    def to_html(attrs = { })
      super(attrs.merge({:type => 'tags'}))
    end
  end



  class Form::Field::Compound < Form::Field
    def initialize(opts = { })
      fields = { }
      # self.class.fields ust be defined by the subclass.
      self.class.fields.each do |f|
        fields[f.name.to_syn] = f
      end

      super(self.class.fields)
    end
  end



  class Form::Field::Compound::Image < Form::Field::Compound
    def self.fields
      [
        Form::Field::Image.new(
          {
            :name => "file",
            :required => true,
            :limit => 1,
          }
        ),
        Form::Field::PlainText.new(
          {
            :name => "caption",
            :required => nil,
            :limit => 1,
          }
        ),
      ]
    end    
  end



  class Form::FieldSet
  end



  class Form::FieldSet::BodyBlocks < Form::FieldSet
    def self.fields
      [
        Form::Field::Compound::Image.new(
          {
            :name => "image",
            :required => nil,
            :limit => nil,
          }
        ),
        Form::Field::PlainText.new(
          {
            :name => "text",
            :required => nil,
            :limit => nil,
          }
        ),
      ]
    end
  end

end



module Templates

  class PageGeneric < Base::Template
    def self.fields
      [
        Base::Form::Field::PlainText.new(
          {
            :name => "title",
            :required => true,
          }
        ),
        Base::Form::Field::Date.new(
          {
            :name => "date",
            :required => true,
          }
        ),
        Base::Form::Field::PlainText.new(
          {
            :name => "author",
          }
        ),
        Base::Form::Field::Tags.new(
          {
            :name => "tags",
          }
        ),
        Base::Form::Field::Compound::Image.new(
          {
            :name => "cover_image",
          }
        ),
        # Base::Form::FieldSet::BodyBlocks.new(
        #   {
        #     :name => "body",
        #     :required => true
        #   }
        # ),
      ]
    end
  end

end


t = Templates::PageGeneric.new(
  {
    :title => 'testo',
    :author => 'yesto',
    :cover_image => {
      :file => '/this/is/my/cover-image.jpg'
    }
  }
)

t.fields.each do |field|
  puts field.value
end
