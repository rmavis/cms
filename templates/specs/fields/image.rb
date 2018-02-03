module Fields
  class Image < Field::PlainText
    # Image.page_file :: void -> string
    def self.page_file
      "#{self.page_files_dir}/image.html.erb"
    end

    # Image.form_file :: void -> string
    def self.form_file
      "#{self.form_files_dir}/image.html.erb"
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
