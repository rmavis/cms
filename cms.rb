#!/usr/bin/ruby

require_relative '_autoload.rb'
Base::CLI.parse_args(ARGV)


# class CLI

#   def self.run(args)
#     if (args.length == 0)
#       return nil
#     end

#     cmd = args[0].downcase
#     if (cmd == 'html')
#       self.for_each_file(:content_to_html, args.slice(1, args.length - 1))
#     elsif (cmd == 'yaml')
#       self.for_each_file(:content_to_yaml, args.slice(1, args.length - 1))
#     elsif (cmd == 'group')
#       self.group_to_html('ok')
#       # self.for_each_file(:group_to_html, args.slice(1, args.length - 1))
#     elsif (match = cmd.match(/view:([a-z]+)/))
#       self.make_view(match, args.slice(1, args.length - 1))
#     else
#     end
#   end

#   def self.for_each_file(act, files)
#     files.each do |file|
#       self.send(act, file)
#     end
#   end

#   def self.content_to_html(file)
#     puts ::Base::Template.from_yaml(file).to_view(:html)
#   end

#   def self.content_to_yaml(file)
#     puts ::Base::Template.from_yaml(file).to_yaml
#   end

#   def self.group_to_html(file)
#     puts ::Base::Group.from_spec(::Local::Specs::Groups::News).to_view(:html)
#   end

#   def self.make_view(type, files)
#     files.each do |file|
#       puts ::Base::Template.from_yaml(file).to_view(type[1].to_sym)
#     end
#   end

# end

#CLI.run(ARGV)


# example: ruby cms.rb html local/content/index.yaml
# example: ruby cms.rb view:html local/content/index.yaml
