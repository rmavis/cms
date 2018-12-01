#!/usr/bin/env ruby

require_relative '_autoload.rb'

class Build

  def self.run(args)
    if (self.respond_to?(args[0]))
      self.send(args[0], args.slice(1, (args.length - 1)))
    else
      $stderr.puts "Can't build: `#{args[0]}` doesn't name a build method."
    end
  end

  def self.pages(args)
    dir = "#{DirMap.content}/#{posts}"
    Dir.foreach(dir) Do |entry|
      file = "#{dir}/#{entry}"
      if ((!File.directory?(file)) &&
          (File.readable?(file)) &&
          (file != '..') &&
          (file != '.'))
        #puts "./cms.rb view html #{args.join(' ')} #{file}"
        system("./cms.rb view html #{args.join(' ')} #{file}")
      else
        $stderr.puts "Skipping `#{file}`."
      end
    end
  end

end

Build.run(ARGV)
