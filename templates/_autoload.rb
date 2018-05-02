module Templates

  def self.views_dir
    "#{__dir__}/views"
  end

  # This is not currently in use.
  # def self.fields_inputs_dir
  #   "#{self.views_dir}/inputs"
  # end

  def self.fields_views_dir
    "#{self.views_dir}/fields"
  end

  def self.pages_views_dir
    "#{self.views_dir}/pages"
  end

  def self.snippets_views_dir
    "#{self.views_dir}/snippets"
  end

end


Templates.autoload(:Specs, "#{__dir__}/specs/_autoload.rb")
