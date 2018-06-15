module Base::Templates
end


{
  :Form => 'form.rb',
  :Page => 'page.rb',
  :Post => 'post.rb'
}.each do |mod,file|
  Base::Templates.autoload(mod, "#{__dir__}/#{file}")
end
