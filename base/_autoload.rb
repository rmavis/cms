# Requirements from stdlib, etc.
require 'yaml'

# Local loads.
require_relative 'extensions.rb'
require_relative 'dir_map.rb'


module Base
end


{
  :CLI => 'cli.rb',
  :Content => 'content.rb',
  :Entry => 'entry.rb',
  :Extendable => 'extendable.rb',
  :Field => 'field.rb',
  :Group => 'group.rb',
  :Render => 'render.rb',
  :Renderable => 'renderable.rb'
}.each do |mod,file|
  ::Base.autoload(mod, "#{__dir__}/#{file}")
end
