module Base
  class Content

    # Content::key_transform :: void -> string -> symbol
    def self.key_transform
      lambda { |s| s.to_camel_case.to_sym }
    end

    # Content::from_file :: (string, (string -> string)?) -> hash
    def self.from_file(filename, fix_keys = self.key_transform)
      self.from_yaml(File.read(filename))
    end

    # Content::from_yaml :: (string, (string -> string)?) -> hash
    def self.from_yaml(yaml, fix_keys = self.key_transform)
      YAML.load(yaml).transform_keys(fix_keys)
    end

  end
end
