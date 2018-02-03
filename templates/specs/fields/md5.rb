require 'openssl'


  class Field::MD5 < Field::PlainText
    # validate :: a -> string
    def validate(val)
      return OpenSSL::Digest.new('md5', val.to_s).hexdigest
    end
  end
