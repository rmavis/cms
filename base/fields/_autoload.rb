module Base::Fields
end


{
  :Bool => 'bool.rb',
  :Collection => 'collection.rb',
  :Compound => 'compound.rb',
  :Date => 'date-time.rb',
  :Entry => 'entry.rb',
  :Group => 'group.rb',
  :List => 'list.rb',
  :Number => 'number.rb',
  :PlainText => 'plain-text.rb',
  :ReadableFile => 'readable-file.rb',
  :Reference => 'reference.rb',
  :StaticFile => 'static-file.rb',
}.each do |mod,file|
  Base::Fields.autoload(mod, "#{__dir__}/#{file}")
end
