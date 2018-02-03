require 'erb'


  # The Render class exists to help render templates.
  class Render
    @@counter = 0

    # Render.render_name :: void -> string
    # Render.render_name returns a variable name to pass to the ERB
    # renderer. The variable name must be unique per call, else
    # repeated or recursive calls will clobber the previous one.
    def self.render_name
      @@counter += 1
      "_erb_template_#{@@counter}"
    end

    # Render.template :: (object, string) -> string
    # Render.template receives an object binding and a template's
    # filename and returns that template rendered in relation to the
    # bound object.
    def self.template(binding, filename)
      if ((File.exist?(filename)) &&
          (File.readable?(filename)))
        return ERB.new(IO.read(filename), $SAFE, '>', self.render_name).result(binding)
      else
        raise "Error: template file `#{filename}` doesn't exist or cannot be read."
      end
    end

    # This is an alternative strategy for enabling stacked rendering.
    # Instead of relying on internal state, it converts the given
    # filename and execution time to a valid variable name. If the
    # filename is the same as the one beneath it, and if the execution
    # time is in the same microsecond, then there could be a clash.
    # A strategy involving a random number or hashed string could
    # help avoid that. Computation is cheaper than storage, so the
    # ideal strategy would not rely on internal state. Think on it.  @TODO
    # def self.template(binding, filename)
    #   if ((File.exist?(filename)) &&
    #       (File.readable?(filename)))
    #     return ERB.new(
    #              IO.read(filename),
    #              $SAFE,
    #              '>',
    #              "_#{filename.gsub(/[^A-Z0-9a-z]/, '')}_#{Time.now.to_f.to_s.gsub(/\./, '')}"
    #            ).result(binding)
    #   else
    #     raise "Error: template file `#{filename}` doesn't exist or cannot be read."
    #   end
    # end
  end
