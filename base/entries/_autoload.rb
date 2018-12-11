module Base::Entries
end


{
  :Form => 'form.rb',
  :View => 'view.rb',
}.each do |mod,file|
  ::Base::Entries.autoload(mod, "#{__dir__}/#{file}")
end
