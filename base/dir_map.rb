class DirMap

  def self.root
    "#{__dir__}/.."
  end

  def self.init(filename)
    dir = File.realpath(File.dirname(filename))
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
