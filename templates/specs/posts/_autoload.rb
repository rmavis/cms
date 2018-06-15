module Templates::Specs::Posts
end


{
  :News => 'news.rb',
}.each do |mod,file|
  Templates::Specs::Posts.autoload(mod, "#{__dir__}/#{file}")
end
