#!/usr/bin/ruby

# These two lines are crucial. #HERE
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
    elsif (cmd == 'yaml')
      self.for_each_file(:yaml_to_yaml, args.slice(1, args.length - 1))
    elsif (cmd == 'group')
      self.group_to_html('ok')
      # self.for_each_file(:group_to_html, args.slice(1, args.length - 1))
    else
    end
  end

  def self.for_each_file(act, files)
    files.each do |file|
      self.send(act, file)
    end
  end

  def self.yaml_to_html(file)
    puts ::Base::Template.from_yaml(file).to_view
  end

  def self.yaml_to_yaml(file)
    puts ::Base::Template.from_yaml(file).to_yaml
  end

  def self.group_to_html(file)
    group = ::Base::Group.from_spec(::Templates::Specs::Groups::News)
    puts "GROUP: #{group.items.count} items"
    group.items.each do |item|
      puts "\nITEM:"
      puts item.to_view
    end
  end

end

CLI.run(ARGV)

# example: ruby cms.rb html templates/content/index.yaml
