# This module is intended to be used as a mixin and `include`d in
# classes that will want to extend their objects.
module Base
  module Extendable

    private

    # extend! :: (spec, methods) -> void
    # spec = (constant) The name of the spec that the host object is
    #   building from.
    # methods = ([symbol]) Methods that might exist on the spec. If
    #   they do, then they will take priority over the host's.
    def extend!(spec, methods)
      methods.each do |method|
        if (spec.respond_to?(method))
          self.class.send(:define_method, method, lambda { spec.send(method) })
        end
      end
    end

    # make_readers! :: fields -> void
    # fields = a hash whose keys are symbols and values are Fields
    # make_readers! creates instance methods for easily accessing an
    # object's (Entry, compound Field) fields. So, rather than like
    # `self.fields[:fieldname]`, this enables `self._fieldname`.
    def make_readers!(fields, prefix = '_')
      fields.each do |key,field|
        self.define_singleton_method("#{prefix}#{key}".to_sym) { fields[key] }
      end
    end

  end
end
