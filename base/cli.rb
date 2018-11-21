# This class interfaces between the command line and the program. It
# receives the command line arguments and routes control accordingly.

# Commands follow this pattern:
# subject verb [adjective(s)] object(s)
# The `subject` specifies the thing/action/function that will be run.
# For example, to render a view, the subject will be `view`, or to
# render a group, the subject will be `group`.
# The `verb` specifies the way to render the `subject`'s `object`s.
# For example, when rendering HTML views, the `verb` will be `html`.
# The `adjective`(s) modify how the verb should function.
# For example, a view can be output to stdout (`-o`) or a file (`-f`).
# The `object`(s) specify the thing(s) to act on. In the case of views,
# a content file should be specified. In the case of groups, the last
# part of its module name (for `Local::Specs::Groups::News`, it will
# be `News`).

# Examples:
# Generate a content file's view, writing to the file specified by
# the spec:
# $ ruby cms.rb view html local/content/index.yaml
# Generate a content file's view, writing to stdout (and redirecting
# to a file):
# $ ruby cms.rb view html -o local/content/index.yaml > public/index.html
# Generate a group's views, writing the group to the file the spec
# specifies:
# $ ruby cms.rb group html News
# Generate a group's views, writing each item's view to stdout:
# $ ruby cms.rb group html -i -o News

module Base
  class CLI

    # CLI.parse_args :: [string] -> void
    def self.parse_args(args)
      if (args.length == 0)
        self.print_help
      end

      cmd = self.get_command(args[0].downcase)
      if (cmd)
        self.send(cmd, args.slice(1, args.length - 1))
      end
    end

    protected

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

    # CLI.print_help :: void -> void
    def self.print_help
      puts "A helpful list of commands and such will be printed."
    end

    # CLI.content_to_view :: [string] -> void
    # CLI.content_to_view receives an array of arguments (excluding
    # the one that specifies that this is the intended function to
    # run).
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

    # CLI.groups_to_view :: [string] -> void
    # For more, see `content_to_view`.
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
