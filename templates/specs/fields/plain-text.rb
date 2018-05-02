module Templates::Specs::Fields::PlainText
  def self.type
    :PlainText
  end

  # view_file :: void -> string
  def view_file
    "plain-text.html.erb"
  end

  # input_view_file :: void -> string
  def input_view_file
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
