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

  def tally(key)
    if (!self.has_key?(key))
      self[key] = 1
    else
      self[key] += 1
    end
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



  # A Record has fields.
  # A Template is a Record.
  # A Record can be converted into an HTML form, an HTML page,
  # a YAML object, a big Hash, etc.
  # A Record's fields are Form::Fields, which contain attributes.
  # One of those attributes is its value.
  class Record
    # new :: [Form::Field] -> Record
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
            f.attrs[:value] = f.validate(yaml[k])
            if (f.attrs[:value].nil?)
              raise "The required value for '#{k}' is invalid."
            end
          end
        elsif (f.attrs[:required])
          raise "The required key '#{k}' is missing."
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



  class Form::Field
    # Field::value_type :: void -> nil
    # Subclasses should set their own `value_type`s.
    def self.value_type
      nil
    end

    # Field::attrs :: void -> Hash
    # A subclass can set its own `attrs`.
    # If it does, it should merge these in.
    def self.attrs
      {
        :limit => nil,
        :name => nil,
        :required => nil,
        :value => nil,
      }
    end


    # new :: Hash -> Field
    def initialize(attrs = { })
      @attrs = self.class.attrs.merge(attrs)
    end

    attr_reader :attrs

    # validate :: m -> nil
    # Subclasses should implement their own `validate` methods.
    # To encourage that, this will always return nil.
    def validate(val)
      return nil
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
      super('input', attrs.merge({:value => self.attrs[:value]}))
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
    def initialize(attrs = { }, fields_attrs = { })
      super(attrs)
      @fields = self.class.fields(fields_attrs)
    end

    attr_reader :fields

    def validate(val)
      return nil if (!val.is_a?(Hash))

      valid = { }
      self.fields.each do |k,f|
        if (val.has_key?(k))
          valid[k] = f.validate(val[k])
          return nil if (!valid[k])
        elsif (f.attrs[:required])
          return nil
        end
      end
      return valid
    end
  end



  class Form::Field::Compound::Image < Form::Field::Compound
    def self.fields(attrs = { })
      _attrs = {
        :file => {
          :required => true,
        },
        :caption => {
          :required => nil,
        },
      }.deep_merge(attrs)

      return {
        :file => Form::Field::Image.new(_attrs[:file]),
        :caption => Form::Field::PlainText.new(_attrs[:caption]),
      }
    end
  end



  class Form::Field::Compound::ImagePair < Form::Field::Compound
    def self.fields(attrs = { })
      _attrs = {
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
      }.deep_merge(attrs)

      return {
        :left => Form::Field::Compound::Image.new(_attrs[:left]),
        :right => Form::Field::Compound::Image.new(_attrs[:right]),
      }
    end
  end



  class Form::Field::Opts < Form::Field::Compound
    def initialize(attrs = { }, fields_attrs = { })
      super({:limit => nil}.merge(attrs), fields_attrs)
    end

    def validate(vals)
      return nil if (!vals.is_a?(Array))

      valid = [ ]
      count = { }
      vals.each do |_val|
        val = _val.transform_keys(:to_sym)
        val.each do |k,v|
          if (self.fields.include?(k))
            check = self.fields[k].validate(val[k])
            return nil if (check.nil?)
            valid.push(check)
            count.tally(k)
            if ((!self.fields[k].attrs[:limit].nil?) &&
                (count[k] > self.fields[k].attrs[:limit]))
              raise "Too many '#{k}' fields in opts field '#{self.class.name}': limit #{self.fields[k].attrs[:limit]}."
            end
          else
            raise "Invalid key '#{k}' for opts field '#{self.class.name}'."
          end
        end
      end
      return valid
    end
  end



  class Form::Field::Opts::BodyBlocks < Form::Field::Opts
    def self.fields(attrs = { })
      _attrs = {
        :image => {
          :required => true,
        },
        :text => {
          :required => true,
        },
      }.deep_merge(attrs)

      return {
        :image => Form::Field::Compound::Image.new(_attrs[:image]),
        :text => Form::Field::PlainText.new(_attrs[:text]),
      }
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
        :body => Base::Form::Field::Opts::BodyBlocks.new(
          {
            :required => true
          },
          # {
          #   :image => {:limit => 1}
          # },
        ),
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

