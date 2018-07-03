module Local::Specs::Fields::MarkdownFile
  def self.type
    :MutableFile
  end

  def self.fields(attrs = { })
    _attrs = {
      :meta => {
        :_self => {
          :required => true,
        },
        :title => {
          :required => true,
        },
        :author => {
          :required => true,
        },
        :blurb => {
          :required => true,
        },
        :tags => {
          :required => true,
        },
        :datePosted => {
          :required => true,
        },
        :dateUpdated => {
          :required => true,
        },
      },
      :body => {
        :required => true,
      },
    }.deep_merge(attrs)

    return {
      :meta => {:ArticleMeta => _attrs[:meta]},
      :body => {:PlainText => _attrs[:body]},
    }
  end

  def self.mutate(file)
    return {
      :meta => self.read_metadata(file),
      :body => `multimarkdown -s #{file}`,
    }
  end

  def self.read_metadata(file)
    lines = [ ]
    block_open = false
    handle = File.open(file, 'r')
    handle.each_line do |line|
      if (line.match(/^-{3,}$/))
        block_open = true
      elsif (line.match(/^\.{3,}$/))
        break
      end
      if (block_open)
        lines.push(line)
      end
    end
    handle.close
    return YAML.load(lines.join).transform_keys(lambda {|s| s.to_sym})
  end

  def to_view
    return ::Base::Render.template(binding(), "#{DirMap.field_views}/markdown-file.html.erb")
  end
end
