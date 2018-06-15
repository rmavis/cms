module Base
  class Group

    def self.from_spec(spec)
      return self.make(
               File.expand_path(spec.path),
               lambda { |item| spec.filter(item) }
             )
    end

    def self.make(path, filter)
      full_path = File.expand_path(path)
      if (!Dir.exist?(full_path))
        raise "Can't make group: directory `#{path}` doesn't exist."
      end

      items = [ ]
      Dir.foreach(full_path) do |file|
        if ((!File.directory?(File.expand_path(file, full_path))) &&
            (File.extname(file) == ".yaml"))  # This will need to expand.  #TODO
          content = YAML.load(File.read(File.expand_path(file, full_path))).transform_keys(lambda {|s| s.to_sym})
          check = filter.call(content)
          if (check)
            items.push(Template.from_content(content))
          end
        end
      end

      group = self.new(items)
      return group
    end


    def initialize(items = [ ])
      @items = items
    end

    attr_reader :items

    def set_items!(items)
      @items = items
    end

  end
end