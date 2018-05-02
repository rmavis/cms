require 'openssl'


module Templates::Specs::Fields::MD5
  def self.type
    :PlainText
  end

  # validate :: a -> string
  def validate(val)
    return OpenSSL::Digest.new('md5', val.to_s).hexdigest
  end
end
