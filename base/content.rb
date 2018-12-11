module Base
  class Content

    # Content::from_file :: (path, spec?) -> content
    # path = (string) the path to content file
    # spec = (constant) if a spec is given, it will be used instead
    #   of the one specified in the content file
    # content = (hash) the keys will be transformed according to the
    #   `key_transform`, and the hash will be checked
    def self.from_file(file, spec = nil)
      # If the spec if not given, it must be specified in the content
      # file, or this procedure will fail.
      if (spec.nil?)
        content = self.read_yaml(File.read(file), self.key_transform)
      else
        if (spec.respond_to?(:content_from_file))
          content = spec.send(:content_from_file, file).transform_keys(self.key_transform)
        else
          content = self.read_yaml(File.read(file), self.key_transform)
        end
        content = content.merge({:spec => spec})
      end

      # If the `slug` is specified in the content, it will take precedence.
      return self.check_keys!(self.slug_from_filename(file).merge(content), file)
    end

    # Content::from_yaml :: (string, (string -> string)?) -> hash
    def self.from_yaml(yaml, fix_keys = self.key_transform)
      self.check_keys!(self.read_yaml(yaml, fix_keys))
    end

    # Content::read_yaml :: (string, (string -> string)?) -> hash
    # The hash returned read `read_yaml` will not be checked, but
    # its keys will be transformed.
    def self.read_yaml(yaml, fix_keys = self.key_transform)
      YAML.load(yaml).transform_keys(fix_keys)
    end

    # Content::key_transform :: void -> string -> symbol
    def self.key_transform
      lambda { |key| key.to_s.to_camel_case.to_sym }
    end

    # Content.check_keys! :: (hash, string?) -> hash
    def self.check_keys!(content, file = nil)
      self.default_fields.keys.each do |key|
        if (!content.has_key?(key))
          if (file.nil?)
            raise "Error: `#{key}` required but not specified in content: `#{content.to_s}`."
          else
            raise "Error: `#{key}` required but not specified for content in `#{file}`."
          end
        end
      end
      return content
    end

    # Content.slug_from_filename :: string -> hash
    def self.slug_from_filename(filename)
      {:slug => File.basename(filename, ".*")}
    end

    # Content.default_fields :: void -> hash
    def self.default_fields
      {
        :slug => nil,
        :spec => nil,
      }
    end

  end
end
