#!/usr/bin/env ruby

require_relative 'cms.rb'

class Build

  # Build.run :: [string] -> void
  def self.run(args)
    if (self.respond_to?(args[0]))
      self.send(args[0], args.slice(1, (args.length - 1)))
    else
      $stderr.puts "Can't build: `#{args[0]}` doesn't name a build method."
    end
  end


  #
  # Runnable functions / valid arguments.
  #

  # Build.mdposts :: [string] -> void
  def self.mdposts(args)
    dir = "#{DirMap.content}/posts"
    Dir.foreach(dir) do |entry|
      file = "#{dir}/#{entry}"
      if (self.is_readable_file?(file))
        system("#{__dir__}/cms.rb view html -s MarkdownArticle #{args.join(' ')} #{file}")
      else
        $stderr.puts "Skipping `#{file}`."
      end
    end
  end

  def self.content(args)
    Dir.foreach(DirMap.content) do |entry|
      file = "#{DirMap.content}/#{entry}"
      if ((self.is_readable_file?(file)) &&
          (File.extname(file) == ".yaml"))
        system("./cms.rb view html #{args.join(' ')} #{file}")
      else
        $stderr.puts "Skipping `#{file}`."
      end
    end
  end


  #
  # Utility functions.
  #

  def self.is_readable_file?(path)
    ((!File.directory?(path)) &&
     (File.readable?(path)) &&
     (path != '..') &&
     (path != '.'))
  end

end

Build.run(ARGV)
