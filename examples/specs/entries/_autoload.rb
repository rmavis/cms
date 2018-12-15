module Local::Specs::Entries
end


{
  :Gallery => 'gallery.rb',
  :Generic => 'generic.rb',
  :MarkdownArticle => 'markdown-article.rb',
  :News => 'news.rb',
  :TableOfContents => 'table-of-contents.rb',
  :TaggedGroup => 'tagged-group.rb',
}.each do |mod,file|
  Local::Specs::Entries.autoload(mod, "#{__dir__}/#{file}")
end
