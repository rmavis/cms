# This module is intended to be used as a mixin and `include`d in
# classes that will want to use these methods to render themselves.
module Base
  module Renderable

    # render :: string -> string
    # render is a convenience method. It receives a filename and
    # passes that and a binding to the current Group to
    # `Render.template`.
    def render(filename)
      Render.template(binding(), filename)
    end

    # to_view :: symbol -> string
    # to_view renders the Entry through its `view_file`.
    def to_view(type)
      return Render.template(binding(), self.view_file(type))
    end

    # to_file! :: symbol -> void
    # to_file! renders the Entry to its `output_file`.
    def to_file!(type)
      handle = File.open(self.output_file(type), 'w')
      handle.write(self.to_view(type))
      handle.close
    end

  end
end
