module Fields
  class Password < Field::PlainText
    # Password.page_file :: void -> string
    def self.page_file
      "#{self.page_files_dir}/password.html.erb"
    end

    # Password.form_file :: void -> string
    def self.form_file
      "#{self.form_files_dir}/password.html.erb"
    end

    # validate :: a -> string|nil
    def validate(val)
      if ((val.is_a?(String)) &&
          (val.length > 0))
        return val
      else
        return nil
      end
    end
  end
end
