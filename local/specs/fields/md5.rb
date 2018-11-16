require 'openssl'


module Local::Specs::Fields::MD5
  def self.type
    :PlainText
  end

  # validate :: a -> string
  def validate(val)
    return OpenSSL::Digest.new('md5', val.to_s).hexdigest
  end

  # view_file :: symbol -> string
  def view_file(type)
    if (type == :html)
      "#{DirMap.html_views}/fields/plain-text.html.erb"
    else
      "#{DirMap.html_views}/fields/plain-text.html.erb"
    end
  end
end
