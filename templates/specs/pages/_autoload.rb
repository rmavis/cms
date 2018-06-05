module Templates::Specs::Pages
end


{
  :Generic => 'generic.rb',
  :Gallery => 'gallery.rb',
}.each do |mod,file|
  Templates::Specs::Pages.autoload(mod, "#{__dir__}/#{file}")
end
