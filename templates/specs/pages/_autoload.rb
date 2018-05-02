module Templates::Specs::Pages
end


{
  :Generic => 'generic.rb',
}.each do |mod,file|
  Templates::Specs::Pages.autoload(mod, "#{__dir__}/#{file}")
end
