module Base::Fields
end


{
  :Bool => 'bool.rb',
  :Collection => 'collection.rb',
  :Compound => 'compound.rb',
  :Date => 'date-time.rb',
  :Entry => 'entry.rb',
  :FileTransform => 'file-transform.rb',
  :Group => 'group.rb',
  :MutableFile => 'mutable-file.rb',
  :Number => 'number.rb',
  :PlainText => 'plain-text.rb',
  :Reference => 'reference.rb',
  :StaticFile => 'static-file.rb',
  :Tags => 'tags.rb'
}.each do |mod,file|
  Base::Fields.autoload(mod, "#{__dir__}/#{file}")
end
