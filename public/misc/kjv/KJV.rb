#!/usr/bin/ruby
# 
# THOU SHALT EXECUTE MINE COMMANDMENTS HEREIN ACCORDING TO MY LAWS,
# WHICH ARE DEAR TO ME. THUS:
#   $ ruby KJV.rb fire flame -d lord god
# AND WE SHALL LOOK UPON THE FRUITS OF THIS THY LABOR AND WE SHALL
# JUDGE THEE THUS.
#



class KJV


  # IN THE BEGINNING WAS THE INIT. AND THE INIT RECEIVES A HOLY LOGOS
  # CONTAINING THE COMMANDMENTS BEGOTTEN OF HE WHO COMMANDS.
  def initialize( logos = [ ] )
    laws = self.receive_the_law(logos)

    if (laws.empty? || !self.climb_sinai?)
      self.all_is_vanity!
    else
      self.genesis(laws)
    end
  end



  # AND HIS SERVANT RECEIVED HIS LAW AND HIS SERVANT STROVE TO
  # UNDERSTAND HIS LAW FOR THE PEOPLE NEED ALSO UNDERSTAND THE LAW.
  def receive_the_law( logos = [ ] )
    laws = {
      :canon => [ ],
      :deutero => [ ]
    }

    if logos.is_a?(Array)
      key = :canon

      logos.each do |word|
        if word == "-d"
          key = :deutero
        else
          laws[key].push(word.strip.downcase)
        end
      end
    end

    return laws
  end




  # AND HE WHO COMMANDS CALLED TO HIS MESSENGER. AND HE SPOKE HIS
  # LOGOS AND HIS SERVANT HIS MESSENGER WENT TO THE WILDERNESS TO
  # LOCATE THE BOOK OF THE LAW.
  def climb_sinai?
    if File.exists?(KJV.TXT)
      return true
    else
      return nil
    end
  end




  # AND HIS SOLDIERS AND HIS SCRIBES AND HIS ENUMERATORS WERE FAITHFUL
  # TO HIS LAW. AND HIS PEOPLE READ THE BOOK OF HIS LAW LINE BY LINE.
  # AND THEY MADE MUCH MEANING OF THE LINES OF THE BOOK OF HIS LAW.
  def genesis( laws = { } )
    test, book = nil, nil
    t_out, b_out = nil, nil

    scroll = File.open(KJV.TXT, "r")

    scroll.each do |line|
      line = line.strip

      if !line.empty?
        if line[0,1] == '#'
          test, t_out = line[2, (line.length - 1)], nil

        elsif line[0,1] == '%'
          book, b_out = line[2, (line.length - 1)], nil

        elsif self.chaff_from_grain(line, laws[:canon])
          if t_out.nil?
            self.proclaim(self.wrap_in_linens(test, 'h2'))
            t_out = true
          end

          if b_out.nil?
            self.proclaim(self.wrap_in_linens(book, 'h3'))
            b_out = true
          end

          self.proclaim(self.wrap_in_linens(self.anoint(line, laws), 'p'))
        end
      end
    end

    scroll.close
  end



  # AND HIS PEOPLE SEPARATED THE CHAFF FROM THE GRAIN. FOR THE GRAIN
  # IS GOOD IN HIS SIGHT BUT THE CHAFF CHAFES SORE HIS COMMANDMENTS.
  def chaff_from_grain( line, terms = [ ] )
    ret = nil

    terms.each { |term| ret = true if line.downcase.include?(term) }

    return ret
  end



  def wrap_in_linens( cont, tag, attrs = nil )
    if attrs.is_a?(Hash)
      arr = [ ]
      attrs.each { |k,v| arr.push("#{k}=\"#{v}\"") }
      return "<#{tag} #{arr.join(' ')}>#{cont}</#{tag}>"

    else
      return "<#{tag}>#{cont}</#{tag}>"
    end
  end


  def anoint( verse, laws = { } )
    antd = verse.sub(/^[0-9]+:[0-9]+/) { |m| self.wrap_in_linens(m, 'span', {'class' => 'versenum'}) }

    laws.keys.each do |k|
      laws[k].each do |term|
        re = Regexp.new(term, true)
        antd = antd.gsub(re) { |m| self.wrap_in_linens(m, 'span', {'class' => k.to_s}) }
      end
    end

    return antd
  end



  # AND HIS PROPHETS PROCLAIMED HIS LAW TO HIS PEOPLE.
  # AND HIS SOLDIERS AND SCRIBES, EVEN ALL HIS PEOPLE
  # FAITHFUL AND STIFF-NECKED, RECEIVED THE WORDS OF HIS LAW.
  def proclaim( the_word )
    $stdout.puts the_word
  end



  # ALL MAN IS VANITY. AND THE WORK OF MAN IS ALSO VANITY.
  # AND THE WORK OF THE VAIN MAN IS THE VAINEST OF VANITIES.
  def all_is_vanity!
    $stdout.puts "O ye sons of men, how long will ye turn my glory into shame? how long will ye love vanity, and seek after leasing? Selah."
  end



  # MY TEXT IS MY SELF.
  def self.TXT
    "#{File.expand_path(File.dirname(__FILE__))}/KJV-use.txt"
  end

end





# LET IT BE.
KJV.new(ARGV)
