module Local::Specs::Content
end


{
  :Gallery => 'gallery.rb',
  :Generic => 'generic.rb',
  :MarkdownArticle => 'markdown-article.rb',
  :News => 'news.rb',
}.each do |mod,file|
  Local::Specs::Content.autoload(mod, "#{__dir__}/#{file}")
end
