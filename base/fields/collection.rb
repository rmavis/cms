# A Collection is similar to a Compound field. If a compound field
# is a hash, then a collection field is an array. Depending on the `limit`s
# of its subfields, each one could be present 0 or more times.
module Base::Fields
  class Collection < Compound

    def self.spec_attrs_key
       :__spec_key
    end

    # Collection.make :: (spec, attrs, value) -> Collection
    def self.make(spec, attrs = { }, value = nil)
      field = (attrs.has_key?(:_self)) ? self.new(spec, attrs[:_self]) : self.new(spec)

      if (value.is_a?(Array))
        field.set_fields!(self.make_fields(spec.fields(attrs.select { |k,v| k != :_self }), value))
      else
        field.set_fields!([ ])
      end
 
      return field
    end

    # Collection.make_fields :: (rules, values) -> [Field]
    # rules = a hash from a spec's `fields` method
    # values = an array of hashes from a content file. The hashes
    #   should have the same keys as the rules hash.
    def self.make_fields(rules, values)
      count = { }
      fields = [ ]

      values.each do |value|
        value.transform_keys(lambda {|s| s.to_sym}).each do |key,val|
          if (rules.has_key?(key))
            count.tally!(key)
            subspec = ::Base::Field.subspec(rules[key], ModMap.fields)
            if ((rules[key][subspec[:name]].is_a?(Hash)) &&
                (rules[key][subspec[:name]].has_key?(:limit)) &&
                (count[key] > rules[key][subspec[:name]][:limit]))
              raise "Too many '#{key}' fields in Collection field '#{subspec[:name]}': limit #{rules[key][subspec[:name]][:limit]}."
            else
              field = ::Base::Field.from_plan(subspec[:spec], subspec[:attrs], val)
              field.set_attr!(self.spec_attrs_key, key)
              fields.push(field)
            end
          else
            raise "Invalid key '#{key}' for Collection field. Allowed: #{rules.keys}."
          end
        end
      end

      return fields
    end

    # set_fields! :: [Field] -> void
    def set_fields!(fields)
      @fields = fields
    end

    # get_out_val :: void -> [hash]
    def get_out_val
      v = [ ]
      self.fields.each do |f|
        v.push({f.get_attr(Collection.spec_attrs_key).to_s => f.get_out_val})
      end
      return v
    end
  end
end
