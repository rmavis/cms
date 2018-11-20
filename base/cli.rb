module Base
  class CLI

    def self.parse_args(args)
      if (args.length == 0)
        self.print_help
      end

      cmd = self.get_command(args[0].downcase)
      if (cmd)
        self.send(cmd, args.slice(1, args.length - 1))
      end
    end

    # CLI.get_command :: string -> symbol?
    # If the return is nil, then the argument is invalid, meaning it
    # doesn't map to an inner function.
    def self.get_command(arg)
      if (arg == 'html')
        return :content_to_html
      elsif (arg == 'group')
        return :groups_to_view
      elsif (arg == 'view')
        return :content_to_view
      else
        return nil
      end
    end

    def self.print_help
      puts "A helpful list of commands and such will be printed."
    end

    def self.content_to_view(args)
      print_file = true
      type = args[0].to_sym
      args.slice(1, args.length - 1).each do |arg|
        if (arg == '-o')  # o = output
          print_file = nil
        elsif (arg == '-f')  # f = file
          print_file = true
        elsif (print_file)
          ::Base::Template.from_yaml(arg).to_file!(type)
        else
          puts ::Base::Template.from_yaml(arg).to_view(type)
        end
      end
    end

    def self.groups_to_view(args)
      print_file = true
      print_act = :to_file!
      type = args[0].to_sym
      args.slice(1, args.length - 1).each do |arg|
        if (arg == '-o')  # o = output
          print_file = nil
        elsif (arg == '-f')  # f = file
          print_file = true
        elsif (arg == '-g')  # g = group
          print_act = :to_file!
        elsif (arg == '-i')  # i = items
          print_act = :to_files!
        elsif (print_file)
          ::Base::Group.from_spec("::Local::Specs::Groups::#{arg}".to_const).send(print_act, type)
        elsif (print_act == :to_file!)
          puts ::Base::Group.from_spec("::Local::Specs::Groups::#{arg}".to_const).to_view(type)
        else
          ::Base::Group.from_spec("::Local::Specs::Groups::#{arg}".to_const).to_views!(type)
        end
      end
    end

  end
end

# Generate a content file's view, writing to the file specified by the spec.
# ruby cms.rb view html local/content/index.yaml
# Generate a content file's view, writing to stdout (and redirecting to a file).
# ruby cms.rb view html -o local/content/index.yaml > public/pages/index.html
# Generate a group's views, writing the group to the file the spec specifies.
# ruby cms.rb group html News
# Generte a group's views, writing each item's view to stdout.
# ruby cms.rb group html -i -o News
