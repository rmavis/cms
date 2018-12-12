module Local::Specs::Groups
end


{
  :MarkdownPages => 'markdown-pages.rb',
  :PagesByTags => 'pages-by-tags.rb',
  :TableOfContents => 'table-of-contents.rb',
}.each do |mod,file|
  Local::Specs::Groups.autoload(mod, "#{__dir__}/#{file}")
end
