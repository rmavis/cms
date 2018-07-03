module Base::Templates
end


{
  :Form => 'form.rb',
  :View => 'view.rb',
}.each do |mod,file|
  Base::Templates.autoload(mod, "#{__dir__}/#{file}")
end
