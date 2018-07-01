# This module is intended to be used as a mixin and `include`d in
# classes that will want to extend their objects.
module Base
  module Extendable

    private

    # extend! :: (spec, methods) -> void
    #   spec = (constant) The name of the spec that the hot object
    #     is building from.
    #   methods = ([symbol]) Methods that might exist on the spec.
    #     If they do, then they will take priority over the host's.
    def extend!(spec, methods)
      methods.each do |method|
        if (spec.respond_to?(method))
          self.class.send(:define_method, method, lambda { spec.send(method) })
        end
      end
    end

  end
end
