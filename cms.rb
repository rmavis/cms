#!/usr/bin/ruby

require_relative 'base/_autoload.rb'
require_relative 'templates/_autoload.rb'


class CLI

  def self.run(args)
    if (args.length == 0)
      return nil
    end

    cmd = args[0].downcase
    if (cmd == 'html')
      self.for_each_file(:yaml_to_html, args.slice(1, args.length - 1))
    else
    end
  end

  def self.for_each_file(act, files)
    files.each do |file|
      self.send(act, file)
    end
  end

  def self.yaml_to_html(file)
    puts Base::Template.from_yaml(file)
  end

end

CLI.run(ARGV)


# t = Base::Template.from_yaml('content/1-index.yaml')
# puts "YAML:"
# puts t.to_yaml
# # puts "\n\n\n"
# # puts "PAGE:"
# # puts t.to_page
# puts "\n\n\n"
# puts "FORM:"
# puts t.to_form
