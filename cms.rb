#!/usr/bin/env ruby

# This file loaded by this line should load the module that contains
# the local Specs. It is needed!
require_relative 'local/_autoload.rb'

# The file loaded by this line loads the module that contains the
# base classes. It is also needed.
require_relative 'base/_autoload.rb'

# And this runs the given command.
Base::CLI.parse_args(ARGV)
