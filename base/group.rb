module Base
  class Group
    include Renderable

    # Group.specs_prefix :: void -> symbol
    def self.specs_prefix
      ::Local::Specs::Groups
    end

    # Group::get_full_spec :: a -> constant?
    # This method was copied from Entry and should probably be
    # improved in similar ways.  @TODO
    def self.get_full_spec(spec)
      if (spec.is_a?(String))
        "#{self.specs_prefix}::#{spec}".to_const
      elsif (spec.is_a?(Symbol))
        spec.to_s.to_const
      elsif (spec.is_a?(Module))
        spec
      else
        nil
      end
    end

    # Group.from_spec :: spec -> Group
    # spec = a constant that names a module that conforms to the
    #   Group requisites.
    def self.from_spec(spec)
      if (spec.respond_to?(:prepare))
        group = self.make(
          File.expand_path(spec.content_path),
          lambda { |item, items| spec.filter(item, items) },
          lambda { |items| spec.prepare(items) }
        )
      else
        group = self.make(
          File.expand_path(spec.content_path),
          lambda { |item, items| spec.filter(item, items) }
        )
      end
      group.extend(spec)
      return group
    end

    # Group.make :: (path, ((path, [hash]) -> hash?), ([Entry] -> [Entry])?) -> Group
    # path = (string) The directory that contains the content files.
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
          content = filter.call(path, items)
          if (content)
            items.push(Entry.from_content(content))
          end
        end
      end

      if (prepare.nil?)
        return self.new(items)
      else
        return self.new(prepare.call(items))
      end
    end


    # new :: [Entry] -> Group
    # Technically, any type of parameter can be assigned to a Group's
    # `items`, but it's really meant to use an array of Entries.
    def initialize(items = [ ])
      @items = items
    end

    attr_reader :items

    # set_items! :: [Entry] -> void
    # See note on `initialize`.
    def set_items!(items)
      @items = items
    end

    # to_views :: symbol -> void
    def to_views(type)
      self.items.each { |item| puts item.to_view(type) }
    end

    # to_files! :: symbol -> void
    def to_files!(type)
      self.items.each { |item| item.to_file!(type) }
    end

  end
end
