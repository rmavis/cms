module Templates::Specs::Groups
end


{
  :News => 'news.rb',
  :PagesByTags => 'pages-by-tags.rb',
}.each do |mod,file|
  Templates::Specs::Groups.autoload(mod, "#{__dir__}/#{file}")
end
