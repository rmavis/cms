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
          if (rules.include?(key))
            count.tally!(key)
            field_spec = rules[key].keys[0]
            if ((rules[key][field_spec].is_a?(Hash)) &&
                (rules[key][field_spec].has_key?(:limit)) &&
                (count[key] > rules[key][field_spec][:limit]))
              raise "Too many '#{key}' fields in Collection field '#{field_spec}': limit #{rules[key][field_spec][:limit]}."
            else
              field = ::Base::Field.from_plan(field_spec, rules[key].values[0], val)
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
