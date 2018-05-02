module Base::Fields
end


{
  :Asset => 'asset.rb',
  :Collection => 'collection.rb',
  :Compound => 'compound.rb',
  :Date => 'date-time.rb',
  :Number => 'number.rb',
  :PlainText => 'plain-text.rb',
  :Tags => 'tags.rb'
}.each do |mod,file|
  Base::Fields.autoload(mod, "#{__dir__}/#{file}")
end
