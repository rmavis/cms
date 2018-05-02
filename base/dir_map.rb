class DirMap

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

DirMap.init("#{__dir__}/../dir_map.yaml")
