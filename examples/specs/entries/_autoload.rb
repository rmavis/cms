module Local::Specs::Entries
end


{
  :Gallery => 'gallery.rb',
  :Generic => 'generic.rb',
  :News => 'news.rb',
}.each do |mod,file|
  Local::Specs::Entries.autoload(mod, "#{__dir__}/#{file}")
end
