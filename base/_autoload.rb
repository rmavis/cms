require 'yaml'

require_relative 'extensions.rb'


module Base
end


{
  :Field => 'field.rb',
  :Template => 'template.rb',
  :Render => 'render.rb'
}.each do |mod,file|
  Base.autoload(mod, "#{__dir__}/#{file}")
end
