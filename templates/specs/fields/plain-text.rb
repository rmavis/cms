module Fields
  class Field::PlainText < Field
    def self.type
       :PlainText
    end

    # PlainText.page_file :: void -> string
    def self.page_file
      "#{self.page_files_dir}/plain-text.html.erb"
    end

    # PlainText.form_file :: void -> string
    def self.form_file
      "#{self.form_files_dir}/plain-text.html.erb"
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
end
