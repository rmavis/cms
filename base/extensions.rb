class Hash
  # transform_keys :: lambda -> hash
  def transform_keys(trans)
    hsh = { }
    self.each do |k,v|
      hsh[trans.call(k)] = (v.is_a?(Hash)) ? v.transform_keys(trans) : v
    end
    return hsh
  end

  # transform_vals :: lambda -> hash
  def transform_vals(trans)
    hsh = { }
    self.each do |k,v|
      hsh[k] = (v.is_a?(Hash)) ? v.transform_vals(trans) : trans.call(v)
    end
    return hsh
  end

  # deep_merge :: hash -> hash
  # deep_merge receives a hash, which gets merged recursively with
  # the current hash into a new hash, which gets returned.
  def deep_merge(hsh)
    m = { }
    self.each do |k,v|
      if (hsh.has_key?(k))
        if ((v.is_a?(Hash)) &&
            (hsh[k].is_a?(Hash)))
          m[k] = v.deep_merge(hsh[k])
        else
          m[k] = hsh[k]
        end
      else
        m[k] = v
      end
    end
    hsh.each do |k,v|
      if (!m.has_key?(k))
        m[k] = v
      end
    end
    return m
  end

  # tally! :: a -> void
  # tally! receives a key. If this key is already present in the
  # current hash, its valus gets incremented. Else, it gets added
  # with value set to 1.
  def tally!(key)
    if (!self.has_key?(key))
      self[key] = 1
    else
      self[key] += 1
    end
  end

  # to_attrs :: void -> string
  # to_attrs is a convenience method. It loops through the current
  # hash, collating its keys and values into a string suitable for
  # an HTML element's attributes.
  def to_attrs
    attrs = [ ]
    self.each do |k,v|
      attrs.push("#{k}=\"#{v}\"")
    end
    return attrs.join(' ')
  end
end



class String
  # to_const :: void -> constant
  # to_const returns the current string as a constant.
  def to_const
    Object.const_get(self)
  end

  # last :: string -> string
  # last is a convenience method. It receives a string present in the
  # current string, splits on that, and returns the last part.
  def last(div)
    self.split(div).last
  end

  # to_camel_case :: str? -> str
  def to_camel_case(splitter = ' ')
    words = self.split(splitter).reduce([ ]) do |parts, word|
      if (parts.empty?)
        parts.push(word.downcase)
      else
        parts.push(word.capitlize)
      end
      return parts
    end
    return words.join
  end
end
