module Local::Specs::Fields::MarkdownFile
  def self.type
    :ReadableFile
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
        :index => {
          :required => true,
        },
        :toc => {
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

  def self.read(file)
    meta = [ ]
    more_meta = false
    body = IO.popen("multimarkdown -s --nolabels", 'r+') do |mmd_io|
      n = 0
      IO.foreach(file) do |line|
        if (n == 0)
          if (line.match(/^-{3,}$/))
            more_meta = true
            meta.push(line)
          else
            mmd_io.puts line
          end
        elsif (more_meta)
          meta.push(line)
          if (line.match(/^\.{3,}$/))
            more_meta = false
          end
        else
          mmd_io.puts line
        end
        n += 1
      end

      mmd_io.close_write
      mmd_io.readlines.join
    end

    return {
      # Will need to parse the meta lines separately. The keys in the
      # file don't match the keys in the spec, but they can be transformed.
      # Could just change the function passed to `transform_keys`?
      :meta => YAML.load(meta.join).transform_keys(lambda {|s| s.to_camel_case.to_sym}),
      :body => body
    }
  end

  def view_file
    "markdown-file.html.erb"
  end
end
