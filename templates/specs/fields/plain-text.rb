module Templates::Specs::Fields::PlainText
  def self.type
    :PlainText
  end

  # PlainText.view_file :: void -> string
  def self.view_file
    "#{::Templates.fields_views_dir}/plain-text.html.erb"
  end

  # PlainText.input_file :: void -> string
  def self.input_file
    "#{::Templates.fields_inputs_dir}/plain-text.html.erb"
  end

  # validate :: string -> string|nil
  def validate(val)
    if ((val.is_a?(String)) &&
        (val.length > 0))
      return val
    elsif (val.is_a?(Numeric))
      return val.to_s
    else
      return nil
    end
  end
end
