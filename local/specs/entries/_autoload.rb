module Local::Specs::Entries
end


{
  :MarkdownArticle => 'markdown-article.rb',
  :TableOfContents => 'table-of-contents.rb',
  :TaggedGroup => 'tagged-group.rb',
}.each do |mod,file|
  Local::Specs::Entries.autoload(mod, "#{__dir__}/#{file}")
end
