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
      if (args.length > 2)
        cmd = self.get_command(args[0].downcase)
        if (cmd)
          self.call_with_args(args.slice(1, args.length - 1), self.default_conf, cmd)
        else
          puts "The given command (#{args[0].downcase}) is invalid."
        end
      else
        self.print_help
      end
    end

    protected

    # CLI.get_command :: string -> symbol?
    # If the return is nil, then the argument is invalid, meaning it
    # doesn't map to an inner function.
    def self.get_command(arg)
      if (arg == 'group')
        return :make_group
      elsif (arg == 'view')
        return :make_content
      else
        return nil
      end
    end

    # CLI.print_help :: void -> void
    def self.print_help
      puts "A helpful list of commands and such will be printed."
    end

    # CLI.default_conf :: void -> hash
    def self.default_conf
      self.common_conf.merge(self.group_conf)
    end

    # CLI.common_conf :: void -> hash
    def self.common_conf
      {
        :spec => nil,
        :to_file => true,
        :type => nil,
      }
    end

    # CLI.group_conf :: void -> hash
    def self.group_conf
      {
        :as_group => true,
        :print_act => :to_file!,
      }
    end

    # CLI.call_with_args :: ([string], conf, symbol) -> void
    # conf = a hash from one of the `self.*_conf` methods. It might
    #   be mutated in place.
    def self.call_with_args(args, conf, func)
      i = 1
      while (i < args.length) do
        if (args[i] == '-o')  # o = output
          conf[:to_file] = nil
        elsif (args[i] == '-f')  # f = file
          conf[:to_file] = true
        elsif (args[i] == '-g')  # g = group
          conf[:as_group] = true
        elsif (args[i] == '-i')  # i = items
          conf[:as_group] = nil
        elsif (args[i] == '-s')  # s = spec
          conf[:spec] = args[(i + 1)]
          i += 1
        elsif (args[i] == '-sx')  # sx = cancel spec
          conf[:spec] = nil
        else
          self.send(func, conf, args[i])
        end
        i += 1
      end
    end

    # CLI.make_content :: (conf, string) -> void
    # conf = see `call_with_args`
    def self.make_content(conf, ref)
      if (conf[:to_file])
        if (conf[:spec])
          Entry.from_file(ref, Entry.get_full_spec(conf[:spec], ModMap.entries)).to_file!(conf[:type])
        else
          Entry.from_file(ref).to_file!(conf[:type])
        end
      else
        if (conf[:spec])
          puts Entry.from_file(ref, Entry.get_full_spec(conf[:spec], ModMap.entries)).to_view(conf[:type])
        else
          puts Entry.from_file(ref).to_view(conf[:type])
        end
      end
    end

    # CLI.make_group :: (conf, string) -> void
    # conf = see `call_with_args`
    def self.make_group(conf, ref)
      if (conf[:to_file])
        if (conf[:as_group])
          Group.from_spec("::Local::Specs::Groups::#{ref}".to_const).to_file!(conf[:type])
        else
          Group.from_spec("::Local::Specs::Groups::#{ref}".to_const).to_files!(conf[:type])
        end
      else
        if (conf[:as_group])
          puts Group.from_spec("::Local::Specs::Groups::#{ref}".to_const).to_view(conf[:type])
        else
          Group.from_spec("::Local::Specs::Groups::#{ref}".to_const).to_views(conf[:type])
        end
      end
    end

  end
end
