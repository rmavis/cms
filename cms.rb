require 'yaml'
require 'erb'
require 'openssl'


class Hash
  # transform_keys :: symbol -> hash
  # transform_keys receives a symbol indicating a method callable on
  # the keys of the current hash. It returns a hash identical to the
  # current hash but with the keys transformed by the given method.
  def transform_keys(trans)
    hsh = { }
    self.each do |k,v|
      hsh[k.send(trans)] = (v.is_a?(Hash)) ? v.transform_keys(trans) : v
    end
    return hsh
  end

  # deep_merge :: hash -> hash
  # deep_merge receives a hash, which gets merged recursively with
  # the current hash into a new hash, which gets returned.
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

  # tally! :: a -> void
  # tally! receives a key. If this key is already present in the
  # current hash, its valus gets incremented. Else, it gets added
  # with value set to 1.
  def tally!(key)
    if (!self.has_key?(key))
      self[key] = 1
    else
      self[key] += 1
    end
  end

  # to_attrs :: void -> string
  # to_attrs is a convenience method. It loops through the current
  # hash, collating its keys and values into a string suitable for
  # an HTML element's attributes.
  def to_attrs
    attrs = [ ]
    self.each do |k,v|
      attrs.push("#{k}=\"#{v}\"")
    end
    return attrs.join(' ')
  end
end



class String
  # to_const :: void -> constant
  # to_const returns the current string as a constant.
  def to_const
    Object.const_get(self)
  end

  # last :: string -> string
  # last is a convenience method. It receives a string present in the
  # current string, splits on that, and returns the last part.
  def last(div)
    self.split(div).last
  end
end



module Base

  # The Render class exists to help render templates.
  class Render
    @@counter = 0

    # Render.render_name :: void -> string
    # Render.render_name returns a variable name to pass to the ERB
    # renderer. The variable name must be unique per call, else
    # repeated or recursive calls will clobber the previous one.
    def self.render_name
      @@counter += 1
      "_erb_template_#{@@counter}"
    end

    # Render.template :: (object, string) -> string
    # Render.template receives an object binding and a template's
    # filename and returns that template rendered in relation to the
    # bound object.
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
  # A Record's fields are Fields, which contain attributes. One of
  # those attributes is its value.
  class Record
    # new :: [Field] -> Record
    def initialize(fields)
      @fields = fields
    end

    attr_reader :fields
  end



  # The Template class is the core of the CMS's core functionality.
  # The main idea is that a Template contains a collection of Fields,
  # and a Field contains a value and other attributes, and these
  # Fields can be rendered as an HTML page, form, as YAML, etc. So
  # a Template is an object that contains a collection of fields and
  # methods for reading and rendering those fields in various ways.
  class Template < Record
    def self.form_file
    end

    def self.page_file
    end

    def self.from_form
    end

    # Template.from_yaml :: string -> Template
    # Template.from_yaml receives a filename containing a Template
    # rendered as YAML, reads that file, and converts it to a Template.
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

    # Template.page_head_file :: void -> string
    # Template.page_head_file returns the filename containing the
    # generic page's `head` element.
    def self.page_head_file
      "templates/snippets/generic-head.html.erb"
    end

    # Template.page_body_file :: void -> string
    # Template.page_body_file returns the filename containing the
    # generic page's `body` element.
    def self.page_body_file
      "templates/snippets/generic-body.html.erb"
    end

    # new :: void -> Template
    def initialize
      super(self.class.fields)
    end

    # to_form :: void -> string
    # to_form renders the current Template as an HTML form, meaning
    # it renders and collects the `form_file` for each of its fields.
    def to_form
      return Render.template(binding(), self.class.form_file)
    end

    # to_page :: void -> string
    # to_page renders the current Template as an HTML page, meaning
    # it renders and collects the `page_file` for each of its fields.
    def to_page
      return Render.template(binding(), self.class.page_file)
    end

    # render :: string -> string
    # render is a convenience method. It receives a filename and
    # passes that and a binding to the current Template to
    # `Render.template`.
    def render(filename)
      Render.template(binding(), filename)
    end

    # to_yaml :: void -> string
    # to_yaml renders the current Template as YAML and returns the
    # resulting string.
    def to_yaml
      fields = {
        'template' => self.class.name.last('::'),
      }
      self.fields.each do |k,f|
        fields[k.to_s] = f.get_out_val
      end
      return YAML.dump(fields)
    end

    # make_fields :: [symbol] -> [Field]
    # make_fields receives an array of symbols and returns an array
    # of Fields. Each (subclass of) Template will define its own
    # `fields`, which will be a hash shaped like `{:key => Field}`.
    def make_fields(keys)
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
    # Each Field must implement its own `validate` method which must
    # have the signature `a -> b|nil`. This method exists solely to
    # provide the base case and to ensure that, if a subclass fails
    # to implement `validate`, that its validation will fail.
    def validate(val)
      puts "WTF: field subclass needs to specify a `validate` method."
      return nil
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
  end



  #
  # Subclasses of the Field class must specify three methods:
  # - ::page_file (void -> string), which names the field's view
  #   template file
  # - ::form_file (void -> string), which names the field's form
  #   field template file
  # - validate (a -> b|nil), which checks and validates the given
  #   value
  #
  # Other methods from the base Field class should be re-implemented
  # whenever it makes sense. When they do, the methods must have the
  # type signatutes.
  #

  class Field::PlainText < Field
    # PlainText.page_file :: void -> string
    def self.page_file
      "#{self.page_files_dir}/plain-text.html.erb"
    end

    # PlainText.form_file :: void -> string
    def self.form_file
      "#{self.form_files_dir}/plain-text.html.erb"
    end

    # validate :: string -> string|nil
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



  class Field::Date < Field::PlainText
    # Date.page_file :: void -> string
    def self.page_file
      "#{self.page_files_dir}/date.html.erb"
    end

    # Date.page_file :: void -> string
    def self.form_file
      "#{self.form_files_dir}/date.html.erb"
    end

    # validate :: a -> Time|nil
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

    # get_out_val :: void -> string
    def get_out_val
      if (self.attrs[:value].nil?)
        return ''
      else
        self.attrs[:value].strftime("%F")
      end
    end
  end



  class Field::Image < Field::PlainText
    # Image.page_file :: void -> string
    def self.page_file
      "#{self.page_files_dir}/image.html.erb"
    end

    # Image.form_file :: void -> string
    def self.form_file
      "#{self.form_files_dir}/image.html.erb"
    end

    # validate :: a -> string|nil
    def validate(val)
      if ((val.is_a?(String)) &&
          (val.length > 0))
        return val
      else
        return nil
      end
    end
  end



  class Field::Password < Field::PlainText
    # Password.page_file :: void -> string
    def self.page_file
      "#{self.page_files_dir}/password.html.erb"
    end

    # Password.form_file :: void -> string
    def self.form_file
      "#{self.form_files_dir}/password.html.erb"
    end

    # validate :: a -> string|nil
    def validate(val)
      if ((val.is_a?(String)) &&
          (val.length > 0))
        return val
      else
        return nil
      end
    end
  end



  class Field::Tags < Field::PlainText
    # Tags.page_file :: void -> string
    def self.page_file
      "#{self.page_files_dir}/tags.html.erb"
    end

    # Tags.form_file :: void -> string
    def self.form_file
      "#{self.form_files_dir}/tags.html.erb"
    end

    # validate :: a -> [string]|nil
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



  class Field::ThisYear < Field::PlainText
    # validate :: a -> string
    def validate(val)
      return Time.now.year
    end
  end

  # ThisYear and MD5 demonstrate how to handle fields that do not
  # simply echo values given by the content file. Additional but
  # expected processing occurs when they are `validate`d. This
  # processing could be anything -- database lookups, reading files,
  # calculating values with given input, etc.

  class Field::MD5 < Field::PlainText
    # validate :: a -> string
    def validate(val)
      return OpenSSL::Digest.new('md5', val.to_s).hexdigest
    end
  end



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



  class Field::Compound::Meta < Field::Compound
    # This class doesn't have `page_file` or `form_file` templates.  @TODO

    # Meta.fields :: hash -> hash
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
        :title => Field::PlainText.new(_attrs[:title]),
        :date => Field::Date.new(_attrs[:date]),
        :author => Field::PlainText.new(_attrs[:author]),
        :tags => Field::Tags.new(_attrs[:tags]),
      }
    end
  end



  class Field::Compound::ImageAndText < Field::Compound
    # ImageAndText.page_file :: void -> string
    def self.page_file
      "#{self.page_files_dir}/image-and-text.html.erb"
    end

    # ImageAndText.form_file :: void -> string
    def self.form_file
      "#{self.form_files_dir}/image-and-text.html.erb"
    end

    # ImageAndText.fields :: hash -> hash
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
        :file => Field::Image.new(_attrs[:file]),
        :caption => Field::PlainText.new(_attrs[:caption]),
      }
    end
  end



  class Field::Compound::ImagePair < Field::Compound
    # ImagePair.page_file :: void -> string
    def self.page_file
      "#{self.page_files_dir}/image-pair.html.erb"
    end

    # ImagePair.form_file :: void -> string
    def self.form_file
      "#{self.form_files_dir}/image-pair.html.erb"
    end

    # ImagePair.fields :: hash -> hash
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
        :left => Field::Compound::ImageAndText.new(_attrs[:left]),
        :right => Field::Compound::ImageAndText.new(_attrs[:right]),
      }
    end
  end



  # An Opts Field is similar to a Compound Field. If a Compound Field
  # is a hash, then an Opts Field is an array. Depending on the `limit`s
  # of its subfields, each one could be present 0 or more times.
  class Field::Opts < Field::Compound
    # new :: (hash, hash) -> Opts
    # Initialize a new Opts Field with two attribute hashes, like
    # with a Compound Field.
    def initialize(attrs = { }, fields_attrs = { })
      super({:limit => nil}.merge(attrs), fields_attrs)
    end

    # set_if_valid! :: [hash] -> true|nil
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

    # get_out_val :: void -> [hash]
    def get_out_val
      v = [ ]
      self.fields.each do |k,f|
        v.push({k.to_s => f.get_out_val})
      end
      return v
    end
  end



  class Field::Opts::BodyBlocks < Field::Opts
    # BodyBlocks.fields :: hash -> hash
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
        :image => Field::Compound::ImageAndText.new(_attrs[:image]),
        :text => Field::PlainText.new(_attrs[:text]),
      }
    end
  end

end



module Templates

  # The PageGeneric class is a Template.
  class PageGeneric < Base::Template
    # PageGeneric.fields :: void -> hash
    def self.fields
      {
        :meta => Base::Field::Compound::Meta.new(
          {
            :required => true,
          }
        ),
        :cover_image => Base::Field::Compound::ImageAndText.new,
        :image_pair => Base::Field::Compound::ImagePair.new,
        :body => Base::Field::Opts::BodyBlocks.new(
          {
            :required => true
          },
          # {
          #   :image => {:limit => 1}
          # },
        ),
        :this_year => Base::Field::ThisYear.new,
        :make_md5 => Base::Field::MD5.new,
      }
    end

    # PageGeneric.page_file :: void -> string
    def self.page_file
      "templates/pages/generic.html.erb"
    end

    # PageGeneric.form_file :: void -> string
    def self.form_file
      "templates/admin/forms/generic.html.erb"
    end

    # PageGeneric.form_attrs :: void -> hash
    # The form_attrs are used in the form's HTML in a simple key->val
    # pattern for the `form` element's attributes.
    def self.form_attrs
      {
        :action => '/admin/edit/forms/generic',
        :method => 'post',
        :name => 'form--generic',
      }
    end

    # body_fields :: void -> [Field]
    # body_fields returns an array of Fields to be included in an
    # HTML page's `body` element.
    def body_fields
      self.make_fields(
        [
          :cover_image,
          :image_pair,
          :body,
          :this_year,
        ]
      )
    end

    # form_fields :: void -> [Field]
    # form_fields returns an array of Fields to be included in an
    # HTML form.
    def form_fields
      self.make_fields(
        [
          :meta,
          :cover_image,
          :image_pair,
          :body,
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
