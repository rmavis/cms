# A Collection is similar to a Compound field. If a compound field
# is a hash, then a collection field is an array. Depending on the `limit`s
# of its subfields, each one could be present 0 or more times.
module Base::Fields
  class Collection < Compound

    # Collection.make :: (spec, attrs, value) -> Collection
    def self.make(spec, attrs = { }, value = nil)
      field = (attrs.has_key?(:_self)) ? spec.new(attrs[:_self]) : spec.new()
      field.extend(spec)

      fields = { }
      spec.fields(attrs.select { |k,v| k != :_self }).each do |key,plan|
        if (attrs.has_key?(key))
          fields[key] = self.from_plan(plan.keys[0], plan.values[0].merge(attrs[key]))
        else
          fields[key] = self.from_plan(plan.keys[0], plan.values[0])
        end
      end
      field.set_fields!(fields)
 
      return field
    end

    # new :: (hash, hash) -> Collection
    # Initialize a new Collection with two attribute hashes, like
    # with a Compound Field.
    def initialize(attrs = { })
      super({:limit => nil}.merge(attrs))
    end

    # set_if_valid! :: [hash] -> true|nil
    def set_if_valid!(vals)
      if (!vals.is_a?(Array))
        raise "Error: a Collection must be validated with an Array."
      end

      count = { }
      fields = [ ]
      vals.each do |val|
        val.transform_keys(lambda {|s| s.to_sym}).each do |k,v|
          if (self.fields.include?(k))
            # This #HERE isn't working: if the field is a compound
            # field, it won't have a `validate` method.
            _val = self.fields[k].validate(v)
            if (_val.nil?)
              return nil
            end
            fields.push(::Base::Field.from_plan(self.fields[k].class.name.split('::').last, self.fields[k].attrs))
            count.tally!(k)
            if ((!self.fields[k].attrs[:limit].nil?) &&
                (count[k] > self.fields[k].attrs[:limit]))
              raise "Too many '#{k}' fields in Collection field '#{self.class.name}': limit #{self.fields[k].attrs[:limit]}."
            end
          else
            raise "Invalid key '#{k}' for Collection field '#{self.class.name}'."
          end
        end
      end
      self.set_fields!(fields)

      return true
    end

    # get_out_val :: void -> [hash]
    def get_out_val
      v = [ ]
      self.fields.each do |k,f|
        v.push({k.to_s => f.get_out_val})
      end
      return v
    end
  end
end
