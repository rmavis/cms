module Base
  class Group
    include Renderable

    # Group.from_spec :: spec -> Group
    # spec = a constant that names a module that conforms to the
    # Group requisites.
    def self.from_spec(spec)
      if (spec.respond_to?(:prepare))
        group = self.make(
          File.expand_path(spec.content_path),
          lambda { |item| spec.filter(item) },
          lambda { |items| spec.prepare(items) }
        )
      else
        group = self.make(
          File.expand_path(spec.content_path),
          lambda { |item| spec.filter(item) }
        )
      end
      group.extend(spec)
      return group
    end

    # Group.make :: (path, (path -> hash?), ([Template] -> [Template])?) -> Group
    # path = (string) The directory that contains the content files
    # The purpose of the `filter` function is to determine which
    # files in the `path` should be used in this Group.
    # The purpose of the optional `prepare` function is to perform
    # any other desired transforms on the Group's items.
    def self.make(path, filter, prepare = nil)
      full_path = File.expand_path(path)
      if (!Dir.exist?(full_path))
        raise "Can't make group: directory `#{path}` doesn't exist."
      end

      items = [ ]
      Dir.foreach(full_path) do |file|
        path = File.expand_path(file, full_path)
        if (!File.directory?(path))
          content = filter.call(path)
          if (content)
            items.push(Template.from_content(Template.make_slug(path).merge(content), path))
          end
        end
      end

      if (prepare.nil?)
          return self.new(items)
      else
        return self.new(prepare.call(items))
      end
    end


    # new :: [Template] -> Group
    def initialize(items = [ ])
      @items = items
    end

    attr_reader :items

    def set_items!(items)
      @items = items
    end

    def to_views!(type)
      self.items.each { |item| puts item.to_view(type) }
    end

    def to_files!(type)
      self.items.each { |item| item.to_file!(type) }
    end

  end
end
