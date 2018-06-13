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
      field = (attrs.has_key?(:_self)) ? self.new(attrs[:_self]) : self.new()
      field.extend(spec)

      protos = { }
      rules = spec.fields(attrs.select { |k,v| k != :_self })
      rules.each do |key,plan|
        if (attrs.has_key?(key))
          protos[key] = self.from_plan(plan.keys[0], plan.values[0].merge(attrs[key]))
        else
          protos[key] = self.from_plan(plan.keys[0], plan.values[0])
        end
      end

      if (value.is_a?(Array))
        field.set_fields!(self.make_fields(rules, value))
      else
        field.set_fields!([ ])
      end
 
      return field
    end

    # pass this a hash from a spec's `fields` method and an array
    # of hashes from the content file. The content array should have
    # the same keys as the rules hash.
    def self.make_fields(rules, values)
      count = { }
      fields = [ ]
      values.each do |value|
        value.transform_keys(lambda {|s| s.to_sym}).each do |key,val|
          if (rules.include?(key))
            count.tally!(key)
            if ((!rules[key][:limit].nil?) &&
                (count[key] > rules[key][:limit]))
              raise "Too many '#{key}' fields in Collection field '#{}': limit #{rules[key][:limit]}."
            else
              field = ::Base::Field.from_plan(rules[key].keys[0], rules[key].values[0], val)
              field.set_attr!(self.spec_attrs_key, key)
              fields.push(field)
            end
          else
            raise "Invalid key '#{key}' for Collection field '#{}'."
          end
        end
      end
      return fields
    end

    # new :: (hash, hash) -> Collection
    # Initialize a new Collection with two attribute hashes, like
    # with a Compound Field.
    def initialize(attrs = { })
      super({:limit => nil}.merge(attrs))  # Does this :limit even make sense?  #TODO
    end

    # set_if_valid! :: [hash] -> true|nil
    # def set_if_valid!(vals)
    #   if (!vals.is_a?(Array))
    #     raise "Error: a Collection must be validated with an Array."
    #   end

    #   count = { }
    #   fields = [ ]
    #   vals.each do |val|
    #     val.transform_keys(lambda {|s| s.to_sym}).each do |k,v|
    #       if (self.fields.include?(k))
    #         # This #HERE isn't working: if the field is a compound
    #         # field, it won't have a `validate` method.
    #         _val = self.fields[k].validate(v)
    #         if (_val.nil?)
    #           return nil
    #         end
    #         fields.push(::Base::Field.from_plan(self.fields[k].class.name.split('::').last, self.fields[k].attrs))
    #         count.tally!(k)
    #         if ((!self.fields[k].attrs[:limit].nil?) &&
    #             (count[k] > self.fields[k].attrs[:limit]))
    #           raise "Too many '#{k}' fields in Collection field '#{self.class.name}': limit #{self.fields[k].attrs[:limit]}."
    #         end
    #       else
    #         raise "Invalid key '#{k}' for Collection field '#{self.class.name}'."
    #       end
    #     end
    #   end
    #   self.set_fields!(fields)

    #   return true
    # end

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
