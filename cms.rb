require 'yaml'


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
    # new :: Array|Hash -> Record
    def initialize(fields)
      @fields = fields
    end

    attr_reader :fields
  end



  class Template < Record
    def self.form_file
    end

    def self.page_file
    end

    def self.from_form
    end

    def self.from_yaml(filename)
      template = self.new
      yaml = YAML.load(File.read(filename))
      template.fields.each do |k,f|
puts f
        if (yaml.has_key?(k.to_s))
          if (f.is_a?(Symbol))
            # f[:value] = yaml[k.to_s]  # Need to figure this out  @TODO
          else
            f.fields[:value] = f.validate(yaml[k.to_s])
            if ((f.fields[:value].nil?) && (f.fields[:required]))
              raise "The required value for `#{k}` is invalid."
            end
          end
        elsif (f.fields[:required])
          raise "The required key `#{k}` is missing."
        end
      end
      return template
    end

    def initialize
      super(self.class.fields)
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
    def initialize(opts = { })
      super(Form::Field::required_attrs.merge(opts))
    end

    # validate :: m -> n|nil
    # Subclasses should implement their own `validate` methods.
    def validate(val)
      if (val.is_a?(self.class.value_type))
        return val
      else
        return nil
      end
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

    # validate :: s -> String|nil
    def validate(val)
      if ((val.is_a?(self.class.value_type)) &&
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

    # validate :: s -> String|nil
    def validate(val)
      if ((val.is_a?(self.class.value_type)) &&
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

    # validate :: s -> String|nil
    def validate(val)
      if ((val.is_a?(self.class.value_type)) &&
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
    # validate :: s -> String|nil
    def validate(val)
      if ((val.is_a?(self.class.value_type)) &&
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

    # validate :: s -> String|nil
    def validate(val)
      if ((val.is_a?(self.class.value_type)) &&
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
      super(opts.merge({:fields => self.class.fields}))
    end

    def validate(val)
      if (!val.is_a?(self.fields.class))
        return nil
      end
      valid = { }
      self.fields.each do |k,f|
        if (val.has_key?(k))
          valid[k] = f.validate(val[k])
          if (valid[k].nil?)
            return nil
          end
        end
      end
    end
  end



  class Form::Field::Compound::Image < Form::Field::Compound
    def self.fields
      {
        :file => Form::Field::Image.new(
          {
            :required => true,
          }
        ),
        :caption => Form::Field::PlainText.new(
          {
            :required => nil,
          }
        ),
      }
    end    
  end



  class Form::FieldSet < Form::Field
    def initialize(opts = { })
      super(opts.merge({:fields => self.class.fields}))
    end
  end



  class Form::FieldSet::BodyBlocks < Form::FieldSet
    def self.fields
      [
        {
          :image => Form::Field::Compound::Image.new(
            {
              :required => nil,
              :limit => nil,
            }
          )
        },
        {
          :text => Form::Field::PlainText.new(
            {
              :required => nil,
              :limit => nil,
            }
          )
        },
      ]
    end
  end

end



module Templates

  class PageGeneric < Base::Template
    def self.fields
      {
        :template => :page_generic,
        :title => Base::Form::Field::PlainText.new(
          {
            :required => true
          }
        ),
        :date => Base::Form::Field::Date.new(
          {
            :required => true
          }
        ),
        :author => Base::Form::Field::PlainText.new,
        :tags => Base::Form::Field::Tags.new,
        :cover_image => Base::Form::Field::Compound::Image.new,
        :body => Base::Form::FieldSet::BodyBlocks.new(
          {
            :required => true
          }
        ),
      }
    end
  end

end


t = Templates::PageGeneric.from_yaml('content/1-index.yaml')
t.fields.each do |field|
  puts field[:value]
end
