require 'yaml'


class Hash
  def transform_keys(trans)
    hsh = { }
    self.each do |k,v|
      hsh[k.send(trans)] = (v.is_a?(Hash)) ? v.transform_keys(trans) : v
    end
    return hsh
  end

  def deep_merge(hsh)
    m = { }
    self.each do |k,v|
      if (hsh.has_key?(k))
        if ((v.is_a?(Hash)) &&
            (hsh[k].is_a?(Hash)))
          m[k] = v.deep_merge(hsh[k])
        else
          m[k] = hsh[k]
        end
      else
        m[k] = v
      end
    end
    hsh.each do |k,v|
      if (!m.has_key?(k))
        m[k] = v
      end
    end
    return m
  end
end



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
      yaml = YAML.load(File.read(filename)).transform_keys(:to_sym)
      template.fields.each do |k,f|
        if (yaml.has_key?(k))
          if (f.is_a?(Symbol))
            # f[:value] = yaml[k]  # Need to figure this out  @TODO
          else
            f.fields[:value] = f.validate(yaml[k])
            if (f.fields[:value].nil?)
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

    # validate :: s -> Time|nil
    def validate(val)
      if ((val.is_a?(String)) &&
          # This could be expanded.  @TODO
          (t = val.match(/([0-9]{4})-([0-9]{2})-([0-9]{2})/)))
        return Time.new(m[1], m[2], m[3])
      elsif (val.respond_to?(:to_time))
        return val.to_time
      elsif (val.is_a?(Time))
        return val
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

    # validate :: s -> [String]|nil
    def validate(val)
      if (val.is_a?(Array))
        return val.select { |s| s.is_a?(String) }
      elsif (val.is_a?(String))
        return (val.select { |s| s.is_a?(String) })
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
    def initialize(opts = { }, fields_opts = { })
      super(opts.merge({:fields => self.class.fields(fields_opts)}))
    end

    # A compound field's :fields contains fields.
    def validate(val)
      if (!val.is_a?(self.fields.class))
        return nil
      end
      valid = { }
      self.fields[:fields].each do |k,f|
        if (val.has_key?(k))
          valid[k] = f.validate(val[k])
          if (!valid[k])
            return nil
          end
        elsif (f.fields[:required])
          return nil
        end
      end
      return valid
    end
  end



  class Form::Field::Compound::Image < Form::Field::Compound
    def self.fields(opts = { })
      conf = {
        :file => {
          :required => true,
        },
        :caption => {
          :required => nil,
        },
      }.deep_merge(opts)

      return {
        :file => Form::Field::Image.new(conf[:file]),
        :caption => Form::Field::PlainText.new(conf[:caption]),
      }
    end
  end



  class Form::Field::Compound::ImagePair < Form::Field::Compound
    def self.fields(opts = { })
      conf = {
        :left => {
          :caption => {
            :required => nil,
          },
        },
        :right => {
          :caption => {
            :required => nil,
          },
        },
      }.deep_merge(opts)

      return {
        :left => Form::Field::Compound::Image.new(conf[:left]),
        :right => Form::Field::Compound::Image.new(conf[:right]),
      }
    end
  end



  class Form::FieldSet < Form::Field
    def initialize(opts = { })
      super(opts.merge({:fields => self.class.fields}))
    end

    def validate(vals)
      if (!vals.is_a?(self.fields.class))
        return nil
      end
      self.fields.validate_fields(val)
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
        :image_pair => Base::Form::Field::Compound::ImagePair.new,
        # :body => Base::Form::FieldSet::BodyBlocks.new(
        #   {
        #     :required => true
        #   }
        # ),
      }
    end
  end

end


t = Templates::PageGeneric.from_yaml('content/1-index.yaml')
t.fields.each do |k,f|
  puts "- #{k} :: #{f}"
end

# puts "IMAGE PAIR:"
# t.fields[:image_pair].fields.each do |k,f|
#   puts "- #{k} :: #{f}"
# end

