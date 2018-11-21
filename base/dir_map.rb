# The DirMap class contains methods for easily referencing directories.
# It depends on a YAML file in the project's root (which should be the
# parent directory of this one) called `dir_map.yaml`. That file should
# contain key-value pairs that map a name (the key, which will become
# a class method name on DirMap) to a path.

# For example, this YAML:
#   base: 'base'
#   local: 'local'
# will create `base` and `local` class methods on `DirMap`. Both
# methods will return the strings they're mapped to.
class DirMap

  # DirMap.root :: void -> string
  def self.root
    File.realpath("#{__dir__}/..")
  end

  # DirMap.init :: string -> void
  # The parameter should be a full path to the `dir_map.yaml` file.
  def self.init(filename)
    dir = File.dirname(filename)
    YAML.load(File.read(filename)).each do |key,val|
      self.define_singleton_method(key.to_sym) do
        if (val[0] == '/')
          val
        else
          "#{dir}/#{val}"
        end
      end
    end
  end

end

DirMap.init("#{DirMap.root}/dir_map.yaml")
