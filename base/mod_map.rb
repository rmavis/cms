class ModMap

  def self.required_modules
    [
      'specs',
      'fields',
      'entries',
      'groups',
    ]
  end

  # ModMap.init :: string -> void
  # The parameter should be a full path to the `mod_map.yaml` file.
  def self.init(path)
    mods = YAML.load(File.read(path))

    self.required_modules.each do |mod|
      if (!mods.has_key?(mod))
        raise "ModMap file '#{path}' missing required key '#{mod}'."
      end
    end

    mods.each do |key,val|
      self.define_singleton_method(key.to_sym) do
        if (val.slice(0, 2) == '::')
          val.to_const
        else
          "::#{val}".to_const
        end
      end
    end
  end

end

ModMap.init("#{DirMap.root}/mod_map.yaml")
