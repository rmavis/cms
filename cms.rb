require 'yaml'
require 'erb'
require 'digest'  # This is just for the md5 function.


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

  def tally!(key)
    if (!self.has_key?(key))
      self[key] = 1
    else
      self[key] += 1
    end
  end
end



class String
  def to_const
    Object.const_get(self)
  end

  def last(div)
    self.split(div).last
  end
end



module Base

  class Render
    @@counter = 0

    def self.render_name
      @@counter += 1
      "_erb_template_#{@@counter}"
    end

    def self.template(binding, filename)
      if ((File.exist?(filename)) &&
          (File.readable?(filename)))
        return ERB.new(IO.read(filename), $SAFE, '>', self.render_name).result(binding)
      else
        raise "Error: template file `#{filename}` doesn't exist or cannot be read."
      end
    end

    # This is an alternative strategy for enabling stacked rendering.
    # Instead of relying on internal state, it converts the given
    # filename and execution time to a valid variable name. If the
    # filename is the same as the one beneath it, and if the execution
    # time is in the same microsecond, then there could be a clash.
    # A strategy involving a random number or hashed string could
    # help avoid that. Computation is cheaper than storage, so the
    # ideal strategy would not rely on internal state. Think on it.  @TODO
    # def self.template(binding, filename)
    #   if ((File.exist?(filename)) &&
    #       (File.readable?(filename)))
    #     return ERB.new(
    #              IO.read(filename),
    #              $SAFE,
    #              '>',
    #              "_#{filename.gsub(/[^A-Z0-9a-z]/, '')}_#{Time.now.to_f.to_s.gsub(/\./, '')}"
    #            ).result(binding)
    #   else
    #     raise "Error: template file `#{filename}` doesn't exist or cannot be read."
    #   end
    # end
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



  # A Template is an object that contains a collection of fields and
  # methods for rendering those fields in various ways.
  class Template < Record
    def self.form_file
    end

    def self.page_file
    end

    def self.from_form
    end

    def self.from_yaml(filename)
      template = nil
      yaml = YAML.load(File.read(filename)).transform_keys(:to_sym)
      yaml.each do |k,v|
        if (k == :template)
          if (::Templates.const_defined?(v))
            template = "::Templates::#{v}".to_const.new
            break
          else
            raise "Error: template named `#{v}` in file `#{filename}` is invalid."
          end
        end
      end

      if (template.nil?)
        raise "Error: no `template` specified in file `#{filename}`."
      end

      template.fields.each do |k,f|
        if (k == :template)
          next
        end
        if (yaml.has_key?(k))
          f.set_if_valid!(yaml[k])
        elsif (f.attrs[:required])
          raise "The required key '#{k}' is missing."
        end
      end
      return template
    end

    def self.page_head_file
      "templates/snippets/generic-head.html.erb"
    end

    def self.page_body_file
      "templates/snippets/generic-body.html.erb"
    end

    def initialize
      super(self.class.fields)
    end

    def to_form
      return Render.template(binding(), self.class.form_file)
    end

    def to_page
      return Render.template(binding(), self.class.page_file)
    end

    # A convenience method.
    def render(filename)
      Render.template(binding(), filename)
    end

    def to_yaml
      fields = {
        'template' => self.class.name.last('::'),
      }
      self.fields.each do |k,f|
        fields[k.to_s] = f.get_out_val
      end
      return YAML.dump(fields)
    end

    def body_fields(keys)
      fields = [ ]
      keys.each do |key|
        if (self.class.fields.has_key?(key))
          fields.push(self.fields[key])
        end
      end
      return fields
    end

    def form_fields(keys)
      fields = [ ]
      keys.each do |key|
        if (self.class.fields.has_key?(key))
          fields.push(self.fields[key])
        end
      end
      return fields
    end
  end



  class Form < Template
  end



  class Form::Field
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

    def self.page_files_dir
      "templates/fields"
    end

    def self.form_files_dir
      "templates/admin/fields"
    end


    # new :: Hash -> Field
    def initialize(attrs = { })
      @attrs = self.class.attrs.merge(attrs)
    end

    attr_reader :attrs

    def get_attr(attr)
      self.attrs[attr]
    end

    def set_attr!(attr, val)
      self.attrs[attr] = val
    end

    def get_out_val
      self.attrs[:value]
    end

    # validate :: m -> nil
    # Subclasses should implement their own `validate` methods.
    # To encourage that, this will always return nil.
    def validate(val)
      puts "WTF: field subclass needs to specify a `validate` method."
      return nil
    end

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

    def to_html
      return Render.template(binding(), self.class.page_file)
    end

    def to_input
      return Render.template(binding(), self.class.form_file)
    end
  end



  class Form::Field::PlainText < Form::Field
    def self.page_file
      "#{self.page_files_dir}/plain-text.html.erb"
    end

    def self.form_file
      "#{self.form_files_dir}/plain-text.html.erb"
    end

    # validate :: s -> String|nil
    def validate(val)
      if ((val.is_a?(String)) &&
          (val.length > 0))
        return val
      elsif (val.is_a?(Numeric))
        return val.to_s
      else
        return nil
      end
    end
  end



  class Form::Field::Date < Form::Field::PlainText
    def self.page_file
      "#{self.page_files_dir}/date.html.erb"
    end

    def self.form_file
      "#{self.form_files_dir}/date.html.erb"
    end

    # validate :: s -> Time|nil
    def validate(val)
      if ((val.is_a?(String)) &&
          # This could be expanded.  @TODO
          (m = val.match(/([0-9]{4})-([0-9]{2})-([0-9]{2})/)))
        return Time.new(m[1], m[2], m[3])
      elsif (val.respond_to?(:to_time))
        return val.to_time
      elsif (val.is_a?(Time))
        return val
      else
        return nil
      end
    end

    def get_out_val
      if (self.attrs[:value].nil?)
        return ''
      else
        self.attrs[:value].strftime("%F")
      end
    end
  end



  class Form::Field::Image < Form::Field::PlainText
    def self.page_file
      "#{self.page_files_dir}/image.html.erb"
    end

    def self.form_file
      "#{self.form_files_dir}/image.html.erb"
    end

    # validate :: s -> String|nil
    def validate(val)
      if ((val.is_a?(String)) &&
          (val.length > 0))
        return val
      else
        return nil
      end
    end
  end



  class Form::Field::Password < Form::Field::PlainText
    def self.page_file
      "#{self.page_files_dir}/password.html.erb"
    end

    def self.form_file
      "#{self.form_files_dir}/password.html.erb"
    end

    # validate :: s -> String|nil
    def validate(val)
      if ((val.is_a?(String)) &&
          (val.length > 0))
        return val
      else
        return nil
      end
    end
  end



  class Form::Field::Tags < Form::Field::PlainText
    def self.page_file
      "#{self.page_files_dir}/tags.html.erb"
    end

    def self.form_file
      "#{self.form_files_dir}/tags.html.erb"
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
  end



  class Form::Field::ThisYear < Form::Field::PlainText
    def validate(val)
      return Time.now.year
    end
  end

  # ThisYear and MD5 demonstrate how to handle fields that do not
  # simply echo values given by the content file. Additional but
  # expected processing occurs when they are `validate`d. This
  # processing could be anything -- database lookups, reading files,
  # calculating values with given input, etc.

  class Form::Field::MD5 < Form::Field::PlainText
    def validate(val)
      md5 = Digest::MD5.new
      md5.update(val.to_s)
      return md5.hexdigest
    end
  end



  class Form::Field::Compound < Form::Field
    def initialize(attrs = { }, fields_attrs = { })
      super(attrs)
      @fields = self.class.fields(fields_attrs)
    end

    attr_reader :fields

    # A compound field's subfields can be either simple fields or
    # other compound fields. Either way, the fieldwill have a
    # `set_if_valid!` method. And all simple fields have a `validate`
    # method (called in the simple field's `set_if_valid!` method).
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

    def get_out_val
      val = { }
      self.fields.each do |k,f|
        val[k.to_s] = f.get_out_val
      end
      return val
    end

    def to_html
      if (self.class.respond_to?(:page_file))
        return Render.template(binding(), self.class.page_file)
      else
        return self.render_fields(:to_html)
      end
    end

    def render_fields(meth)
      parts = [ ]
      self.fields.each do |k,f|
        parts.push(f.send(meth))
      end
      return parts.join('')
    end

    def to_input
      if (self.class.respond_to?(:form_file))
        return Render.template(binding(), self.class.form_file)
      else
        return self.render_fields(:to_input)
      end
    end
  end



  class Form::Field::Compound::Meta < Form::Field::Compound
    def self.fields(attrs = { })
      _attrs = {
        :title => {
          :required => true,
        },
        :date => {
          :required => nil,
        },
        :author => {
          :required => nil,
        },
        :tags => {
          :required => nil,
        },
      }.deep_merge(attrs)

      return {
        :title => Form::Field::PlainText.new(_attrs[:title]),
        :date => Form::Field::Date.new(_attrs[:date]),
        :author => Form::Field::PlainText.new(_attrs[:author]),
        :tags => Form::Field::Tags.new(_attrs[:tags]),
      }
    end
  end



  class Form::Field::Compound::ImageAndText < Form::Field::Compound
    def self.page_file
      "#{self.page_files_dir}/image-and-text.html.erb"
    end

    def self.form_file
      "#{self.form_files_dir}/image-and-text.html.erb"
    end

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
    def self.page_file
      "#{self.page_files_dir}/image-pair.html.erb"
    end

    def self.form_file
      "#{self.form_files_dir}/image-pair.html.erb"
    end

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
        :left => Form::Field::Compound::ImageAndText.new(_attrs[:left]),
        :right => Form::Field::Compound::ImageAndText.new(_attrs[:right]),
      }
    end
  end



  class Form::Field::Opts < Form::Field::Compound
    def initialize(attrs = { }, fields_attrs = { })
      super({:limit => nil}.merge(attrs), fields_attrs)
    end

    def set_if_valid!(vals)
      if (!vals.is_a?(Array))
        raise "Error: an Opts field must be validated with an Array."
      end

      count = { }
      vals.each do |val|
        val.transform_keys(:to_sym).each do |k,v|
          if (self.fields.include?(k))
            if (self.fields[k].set_if_valid!(v).nil?)
              return nil
            end
            count.tally!(k)
            if ((!self.fields[k].attrs[:limit].nil?) &&
                (count[k] > self.fields[k].attrs[:limit]))
              raise "Too many '#{k}' fields in opts field '#{self.class.name}': limit #{self.fields[k].attrs[:limit]}."
            end
          else
            raise "Invalid key '#{k}' for opts field '#{self.class.name}'."
          end
        end
      end
      return true
    end

    def get_out_val
      v = [ ]
      self.fields.each do |k,f|
        v.push({k.to_s => f.get_out_val})
      end
      return v
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
        :image => Form::Field::Compound::ImageAndText.new(_attrs[:image]),
        :text => Form::Field::PlainText.new(_attrs[:text]),
      }
    end
  end

end



module Templates

  class PageGeneric < Base::Template
    def self.fields
      {
        :meta => Base::Form::Field::Compound::Meta.new(
          {
            :required => true,
          }
        ),
        :cover_image => Base::Form::Field::Compound::ImageAndText.new,
        :image_pair => Base::Form::Field::Compound::ImagePair.new,
        :body => Base::Form::Field::Opts::BodyBlocks.new(
          {
            :required => true
          },
          # {
          #   :image => {:limit => 1}
          # },
        ),
        :this_year => Base::Form::Field::ThisYear.new,
        :make_md5 => Base::Form::Field::MD5.new,
      }
    end

    def self.page_file
      "templates/pages/generic.html.erb"
    end

    def self.form_file
      "templates/admin/forms/generic.html.erb"
    end

    def body_fields
      super(
        [
          :cover_image,
          :image_pair,
          :body,
          :this_year,
        ]
      )
    end

    def form_fields
      super(
        [
          :meta,
          :cover_image,
          :image_pair,
          :body,
          :this_year,
        ]
      )
    end
  end

end


t = Base::Template.from_yaml('content/1-index.yaml')
puts "YAML:"
puts t.to_yaml
# puts "\n\n\n"
# puts "PAGE:"
# puts t.to_page
puts "\n\n\n"
puts "FORM:"
puts t.to_form
