module Templates::Specs
end


{
  :Fields => "fields/_autoload.rb",
  :Groups => "groups/_autoload.rb",
  :Pages => "pages/_autoload.rb",
  :Posts => "posts/_autoload.rb",
}.each do |mod,file|
  Templates::Specs.autoload(mod, "#{__dir__}/#{file}")
end
