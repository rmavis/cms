module Local::Specs::Fields::Bool
  def self.type
    :Bool
  end

  # view_file :: symbol -> string
  def view_file(type)
    if (type == :html)
      "#{DirMap.html_views}/fields/bool.html.erb"
    else
      "#{DirMap.html_views}/fields/bool.html.erb"
    end
  end

  # input_view_file :: void -> string
  def input_view_file
    "#{::Local.fields_inputs_dir}/bool.html.erb"
  end

  # validate :: string -> string|nil
  # def validate(val)
  #   if ((val.is_a?(String)) &&
  #       (val.length > 0))
  #     return val
  #   elsif (val.is_a?(Numeric))
  #     return val.to_s
  #   else
  #     return nil
  #   end
  # end
end
