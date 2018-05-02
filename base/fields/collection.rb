# A Collection is similar to a Compound field. If a compound field
# is a hash, then a collection field is an array. Depending on the `limit`s
# of its subfields, each one could be present 0 or more times.
module Base::Fields
  class Collection < Compound
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
      vals.each do |val|
        val.transform_keys(lambda {|s| s.to_sym}).each do |k,v|
          if (self.fields.include?(k))
            if (self.fields[k].set_if_valid!(v).nil?)
              return nil
            end
            count.tally!(k)
            if ((!self.fields[k].attrs[:limit].nil?) &&
                (count[k] > self.fields[k].attrs[:limit]))
              raise "Too many '#{k}' fields in FieldCollection field '#{self.class.name}': limit #{self.fields[k].attrs[:limit]}."
            end
          else
            raise "Invalid key '#{k}' for FieldCollection field '#{self.class.name}'."
          end
        end
      end
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
