module Local::Specs
end


{
  :Entries => "entries/_autoload.rb",
  :Fields => "fields/_autoload.rb",
  :Groups => "groups/_autoload.rb",
}.each do |mod,file|
  Local::Specs.autoload(mod, "#{__dir__}/#{file}")
end
