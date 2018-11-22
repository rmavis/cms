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
        :live => {
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

  def self.content_from_file(filename)
    meta = [ ]
    more_meta = false
    body = IO.popen("multimarkdown -s --nolabels", 'r+') do |mmd_io|
      n = 0
      IO.foreach(filename) do |line|
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

    return ::Base::Template.slug_from_filename(filename).merge(
      {
        :meta => ::Base::Content.from_yaml(meta.join),
        :body => body
      }
    )
  end

  # view_file :: symbol -> string
  def view_file(type)
    if (type == :html)
      "#{DirMap.html_views}/fields/markdown-file.html.erb"
    else
      "#{DirMap.html_views}/fields/markdown-file.html.erb"
    end
  end

  # output_file :: symbol -> string
  def output_file(type)
    if (type == :html)
      "#{DirMap.public}/#{self.filename}.html"
    else
      "#{DirMap.public}/#{self.filename}.html"
    end
  end

end
