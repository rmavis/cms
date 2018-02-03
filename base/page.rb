  class Page < Template
    # Page.head_file :: void -> string
    # Page.head_file returns the filename containing the
    # generic page's `head` element.
    def self.head_file
      "templates/snippets/generic-head.html.erb"
    end

    # Page.body_file :: void -> string
    # Page.body_file returns the filename containing the
    # generic page's `body` element.
    def self.body_file
      "templates/snippets/generic-body.html.erb"
    end
  end
