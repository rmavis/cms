module Local::Specs::Fields::Date
  def self.type
    :PlainText
  end

  # view_file :: void -> string
  def self.view_file
    "date.html.erb"
  end

  # input_view_file :: void -> string
  def input_view_file
    "#{self.form_files_dir}/date.html.erb"
  end

  # validate :: a -> Time|nil
  def validate(val)
    if ((val.is_a?(String)) &&
        # This could be expanded.  @TODO
        (m = val.match(/([0-9]{4})-([0-9]{2})-([0-9]{2})/)))
      return Time.new(m[1], m[2], m[3])
    elsif (val.respond_to?(:to_time))
      return val.to_time
    elsif (val.is_a?(Time))
      return val
    else
      return nil
    end
  end

  # get_out_val :: void -> string
  def get_out_val
    if (self.attrs[:value].nil?)
      return ''
    else
      self.attrs[:value].strftime("%F")
    end
  end
end
