module Local::Specs::Fields
end


{
  :ArticleMeta => 'article-meta.rb',
  :BodyBlocks => 'body-blocks.rb',
  :Bool => 'bool.rb',
  :Date => 'date.rb',
  :Entry => 'entry.rb',
  :Group => 'group.rb',
  :GroupName => 'group-name.rb',
  :ImageAndText => 'image-and-text.rb',
  :ImagePair => 'image-pair.rb',
  :Image => 'image.rb',
  :MarkdownFile => 'markdown-file.rb',
  :MD5 => 'md5.rb',
  :Meta => 'meta.rb',
  :Password => 'password.rb',
  :PlainText => 'plain-text.rb',
  :Tags => 'tags.rb',
  :ThisYear => 'this-year.rb',
}.each do |mod,file|
  Local::Specs::Fields.autoload(mod, "#{__dir__}/#{file}")
end
