# Requirements from stdlib, etc.
require 'yaml'

# Local loads.
require_relative 'extensions.rb'
require_relative 'dir_map.rb'


module Base
end


{
  :Field => 'field.rb',
  :Group => 'group.rb',
  :Template => 'template.rb',
  :Render => 'render.rb'
}.each do |mod,file|
  Base.autoload(mod, "#{__dir__}/#{file}")
end