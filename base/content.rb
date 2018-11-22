module Base
  class Content

    # Content::key_transform :: void -> string -> symbol
    def self.key_transform
      lambda { |s| s.to_s.to_camel_case.to_sym }
    end

    # Content.default_reader :: void -> path -> string
    # path = (string) the filepath to read
    def self.default_reader
      lambda { |f| File.read(f) }
    end

    # Content::from_file :: (string, (string -> string)?) -> hash
    def self.from_file(filename, fix_keys = self.key_transform)
      Template.slug_from_filename(filename).merge(self.from_yaml(File.read(filename)))
    end

    # Content::from_yaml :: (string, (string -> string)?) -> hash
    def self.from_yaml(yaml, fix_keys = self.key_transform)
      YAML.load(yaml).transform_keys(fix_keys)
    end

    # Content::from_reader :: ((string -> hash), string, (string -> string)?) -> hash
    def self.from_reader(reader, source, fix_keys = self.key_transform)
      reader.call(source).transform_keys(fix_keys)
    end

  end
end
