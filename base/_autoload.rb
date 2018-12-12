# Requirements from stdlib, etc.
require 'yaml'

# Local loads.
# These must occur in this order.
# 0. Extensions. Because other classes will use them.
require_relative 'extensions.rb'
# 1. DirMap. For the same reason.
require_relative 'dir_map.rb'
# 2. ModMap. Because it uses extensions and DirMap.
require_relative 'mod_map.rb'


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
