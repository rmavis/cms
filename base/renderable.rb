# This module is intended to be used as a mixin and `include`d in
# classes that will want to use these methods to render themselves.
module Base
  module Renderable

    # to_view :: void -> string
    # to_view renders the current Group as an HTML page, meaning
    # it renders and collects the `view_file` for each of its fields.
    def to_view
      return Render.template(binding(), "#{DirMap.page_views}/#{self.view_file}")
    end

    # render :: string -> string
    # render is a convenience method. It receives a filename and
    # passes that and a binding to the current Group to
    # `Render.template`.
    def render(filename)
      Render.template(binding(), filename)
    end

  end
end
